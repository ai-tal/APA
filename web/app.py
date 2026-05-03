"""
Antenna Pattern Analyzer (APA) — unified Python/NiceGUI implementation.
"""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))

import numpy as np
from nicegui import ui, app

from src.parsers import load_pattern
from src.processing import (process_pattern, combine_patterns, compute_coverage,
                             rotation_matrix_from_vectors, apply_rotation,
                             get_component_grid, get_cut)
from src.plotting import (plot_contour, plot_polar_cut, plot_rect_cut,
                           plot_3d_pattern, plot_3d_sphere,
                           plot_circular, plot_filled_polar,
                           plot_coverage_cdf, plot_batch_summary, auto_clim)

# ── Module-level state ───────────────────────────────────────────────────────
_state = dict(
    P_single=None, R_single=None, rot_matrix=np.eye(3),
    batch_entries=[],
    cov_patterns=[],   # {'name', 'R', 'enabled'}
    cov_runs=[],
    cmb_patterns=[],
    cmb_result=None,
)

# Tab references — filled in main_page() so send-to buttons can navigate
_ui_tabs = {}

COMPONENTS = ['Total Gain', 'RHCP Gain', 'LHCP Gain', 'Axial Ratio', 'PLF']
CUT_TYPES  = ['Phi Cut', 'Theta Cut']

# Full-pattern plot types (no cut controls needed)
FULL_PLOT_TYPES = ['Contour', 'Circular', '3D Pattern', '3D Spherical']
# Cut plot types (need cut_type + cut_value)
CUT_PLOT_TYPES  = ['Polar Cut', 'Rect Cut', 'Filled Polar']
PLOT_TYPES      = FULL_PLOT_TYPES + CUT_PLOT_TYPES

FORMATS = ['auto', 'xgtd', 'feko', 'hfss', 'cst', 'grasp', 'csv']

METHODS_DISPLAY = ['Incoherent', 'Coherent', 'Envelope', 'Regional Mask']
METHOD_MAP = {
    'Incoherent':    'incoherent',
    'Coherent':      'coherent',
    'Envelope':      'envelope',
    'Regional Mask': 'regional_mask',
}

MASK_TYPE_DISPLAY = ['Phi / Azimuthal', 'Theta / Elevation', 'Custom (Phi + Theta)']
MASK_TYPE_MAP = {
    'Phi / Azimuthal':        'phi_range',
    'Theta / Elevation':      'theta_range',
    'Custom (Phi + Theta)':   'custom',
}


def _notify(msg, t='positive'):
    ui.notify(msg, type=t, position='top-right', timeout=3000)

def _notify_err(msg):
    ui.notify(msg, type='negative', position='top-right', timeout=6000)


class _Card:
    def __init__(self, title=''):
        self._title = title

    def __enter__(self):
        self._card = ui.card().tight().style(
            'background:#161b22; border:1px solid #30363d; border-radius:8px; '
            'padding:10px; width:100%; gap:4px').classes('w-full')
        self._card.__enter__()
        if self._title:
            ui.label(self._title).style(
                'font-size:0.75rem; font-weight:600; color:#8b949e; '
                'text-transform:uppercase; letter-spacing:0.08em; margin-bottom:2px')
        return self._card

    def __exit__(self, *a):
        self._card.__exit__(*a)


def _card(title=''):
    return _Card(title)


def _render_plot(R, plot_type, component, cut_type, cut_value, cmin, cmax,
                 show_peak=True, show_hpbw=True):
    if plot_type == 'Contour':
        return plot_contour(R, component, cmin, cmax, show_peak)
    elif plot_type == 'Circular':
        return plot_circular(R, component, cmin, cmax)
    elif plot_type == '3D Pattern':
        return plot_3d_pattern(R, component, cmin, cmax)
    elif plot_type == '3D Spherical':
        return plot_3d_sphere(R, component, cmin, cmax)
    elif plot_type == 'Polar Cut':
        return plot_polar_cut(R, cut_type, cut_value, component, cmin, cmax, show_hpbw)
    elif plot_type == 'Rect Cut':
        return plot_rect_cut(R, cut_type, cut_value, cmin, cmax, show_hpbw)
    elif plot_type == 'Filled Polar':
        return plot_filled_polar(R, component, cut_type, cut_value, cmin, cmax)
    else:
        return plot_contour(R, component, cmin, cmax, show_peak)


# ══════════════════════════════════════════════════════════════════════════════
# MAIN PAGE
# ══════════════════════════════════════════════════════════════════════════════
@ui.page('/')
def main_page():
    ui.query('body').style(
        'background:#0d1117; color:#e0e0e0; font-family:Roboto,sans-serif')

    with ui.header(elevated=True).style(
            'background:#161b22; border-bottom:1px solid #30363d; padding:6px 18px'):
        ui.label('📡 Antenna Pattern Analyzer').style(
            'font-size:1.3rem; font-weight:700; color:#58a6ff; letter-spacing:1px')
        ui.space()
        ui.label('APAv01 · APA_v02 · APA_v03 → unified Python/NiceGUI').style(
            'font-size:0.72rem; color:#8b949e')

    with ui.tabs().props('dense indicator-color=blue').classes('w-full').style(
            'background:#161b22; border-bottom:1px solid #30363d') as tabs:
        t_single   = ui.tab('Single',   icon='tune')
        t_batch    = ui.tab('Batch',    icon='folder_open')
        t_coverage = ui.tab('Coverage', icon='radar')
        t_combine  = ui.tab('Combine',  icon='merge')

    _ui_tabs['tabs']       = tabs
    _ui_tabs['t_single']   = t_single
    _ui_tabs['t_coverage'] = t_coverage
    _ui_tabs['t_combine']  = t_combine

    with ui.tab_panels(tabs, value=t_single).classes('w-full').style(
            'background:#0d1117; padding:0'):
        with ui.tab_panel(t_single).style('padding:8px'):
            _build_single_tab()
        with ui.tab_panel(t_batch).style('padding:8px'):
            _build_batch_tab()
        with ui.tab_panel(t_coverage).style('padding:8px'):
            _build_coverage_tab()
        with ui.tab_panel(t_combine).style('padding:8px'):
            _build_combine_tab()


# ══════════════════════════════════════════════════════════════════════════════
# TAB 1 — SINGLE PATTERN
# ══════════════════════════════════════════════════════════════════════════════
def _build_single_tab():
    plot_refs = {}

    with ui.row().classes('w-full gap-2').style('flex-wrap:nowrap'):

        # ── Left controls ─────────────────────────────────────────────────
        with ui.column().style('width:272px; min-width:260px; gap:6px; flex-shrink:0'):

            with _card('Load Pattern'):
                fmt_dd = ui.select(FORMATS, value='auto', label='Format hint').props(
                    'dense dark outlined').classes('w-full')
                ui.upload(
                    label='Drop / click to upload', auto_upload=True,
                    on_upload=lambda e: _on_upload_single(
                        e, lbl_status, plot_refs, tbl_in, tbl_out,
                        lbl_peak, lbl_pol, lbl_hpbw)
                ).props(
                    'accept=".fz,.uan,.ffe,.ffd,.ffs,.out,.cut,.csv,.txt,.dat"'
                    ' color=blue flat'
                ).classes('w-full')
                lbl_status = ui.label('No file loaded').style(
                    'color:#8b949e; font-size:0.78rem; word-break:break-all')

            with _card('Parameters'):
                with ui.grid(columns=2).classes('w-full gap-1'):
                    pt_inp   = ui.number('Tx Power (dBW)', value=0.0, format='%.1f').props('dense dark outlined')
                    loss_inp = ui.number('Loss (dB)',       value=0.0, format='%.1f').props('dense dark outlined')
                    rw_inp   = ui.number('Rw (dB)',         value=0.0, format='%.1f').props('dense dark outlined')
                    dist_inp = ui.number('Distance (m)',    value=1.0, format='%.2f').props('dense dark outlined')

                def _reprocess():
                    if _state['P_single'] is None:
                        _notify_err('Load a file first.'); return
                    _do_process_single(plot_refs, tbl_in, tbl_out, lbl_peak, lbl_pol, lbl_hpbw,
                                       pt_inp, loss_inp, rw_inp, dist_inp)
                ui.button('Re-process', on_click=_reprocess, icon='refresh').props(
                    'flat color=blue').classes('w-full')

            with _card('Metrics'):
                lbl_peak = ui.label('Peak Gain: —').style('color:#58a6ff; font-size:0.88rem')
                lbl_pol  = ui.label('Dominant Pol: —').style('color:#8b949e; font-size:0.8rem')
                lbl_hpbw = ui.label('HPBW E/H: —').style('color:#8b949e; font-size:0.8rem')

            with _card('Send to Other Tabs'):
                def _send_to_coverage():
                    if _state['R_single'] is None:
                        _notify_err('Process a pattern first.'); return
                    P = _state['P_single']; R = _state['R_single']
                    for p in _state['cov_patterns']:
                        if p['name'] == P.name:
                            _notify(f'"{P.name}" already in Coverage.', 'warning'); return
                    _state['cov_patterns'].append({'name': P.name, 'R': R, 'enabled': True})
                    _notify(f'Sent "{P.name}" → Coverage tab')
                    if _ui_tabs.get('tabs'):
                        _ui_tabs['tabs'].set_value(_ui_tabs['t_coverage'])

                def _send_to_combine():
                    if _state['R_single'] is None:
                        _notify_err('Process a pattern first.'); return
                    P = _state['P_single']; R = _state['R_single']
                    for p in _state['cmb_patterns']:
                        if p['name'] == P.name:
                            _notify(f'"{P.name}" already in Combine.', 'warning'); return
                    _state['cmb_patterns'].append({'name': P.name, 'R': R})
                    _notify(f'Sent "{P.name}" → Combine tab')
                    if _ui_tabs.get('tabs'):
                        _ui_tabs['tabs'].set_value(_ui_tabs['t_combine'])

                with ui.row().classes('w-full gap-1'):
                    ui.button('→ Coverage', on_click=_send_to_coverage, icon='radar').props(
                        'flat color=green size=sm').classes('flex-1')
                    ui.button('→ Combine',  on_click=_send_to_combine,  icon='merge').props(
                        'flat color=purple size=sm').classes('flex-1')

            with _card('Rotation (cumulative SO(3))'):
                with ui.grid(columns=2).classes('w-full gap-1'):
                    src_th = ui.number('Src θ (°)', value=0.0).props('dense dark outlined')
                    src_ph = ui.number('Src φ (°)', value=0.0).props('dense dark outlined')
                    dst_th = ui.number('Dst θ (°)', value=0.0).props('dense dark outlined')
                    dst_ph = ui.number('Dst φ (°)', value=0.0).props('dense dark outlined')

                def _do_rotate():
                    if _state['P_single'] is None:
                        _notify_err('Load a file first.'); return
                    try:
                        R_mat = rotation_matrix_from_vectors(
                            src_th.value, src_ph.value, dst_th.value, dst_ph.value)
                        _state['rot_matrix'] = _state['rot_matrix'] @ R_mat
                        P = _state['P_single']
                        P.theta, P.phi = apply_rotation(P, R_mat)
                        P._build_header()
                        _notify('Rotation applied — re-processing…')
                        _reprocess()
                    except Exception as ex:
                        _notify_err(str(ex))

                def _reset_rot():
                    _state['rot_matrix'] = np.eye(3)
                    _notify('Rotation reset. Re-upload to restore original directions.')

                with ui.row().classes('w-full gap-1'):
                    ui.button('Rotate', on_click=_do_rotate, icon='360').props(
                        'flat color=orange').classes('flex-1')
                    ui.button('Reset',  on_click=_reset_rot, icon='undo').props(
                        'flat color=grey').classes('flex-1')

            with _card('Export'):
                def _export_csv():
                    R = _state['R_single']
                    if R is None: _notify_err('Process a pattern first.'); return
                    rows = ['theta_deg,phi_deg,G_total_dBi,G_RHCP_dBic,G_LHCP_dBic,AR_dB,PLF_dB,EIRP_dBW']
                    for i in range(len(R.theta)):
                        rows.append(f'{R.theta[i]:.3f},{R.phi[i]:.3f},'
                                    f'{R.G_total_dB[i]:.4f},{R.G_RHCP_dB[i]:.4f},'
                                    f'{R.G_LHCP_dB[i]:.4f},{R.AR_dB[i]:.4f},'
                                    f'{R.PLF_dB[i]:.4f},{R.EIRP_dBW[i]:.4f}')
                    ui.download('\n'.join(rows).encode(), 'pattern_output.csv')
                    _notify('Downloading pattern_output.csv')
                ui.button('Export Output CSV', on_click=_export_csv, icon='download').props(
                    'flat color=teal').classes('w-full')

        # ── Right: plot + tables ──────────────────────────────────────────
        with ui.column().classes('flex-1').style('gap:6px; min-width:0'):

            # Plot controls bar
            with ui.row().classes('w-full gap-2 items-center').style(
                    'background:#161b22; border-radius:6px; padding:6px 10px; '
                    'border:1px solid #30363d; flex-wrap:wrap'):
                comp_dd  = ui.select(COMPONENTS, value='Total Gain', label='Component').props(
                    'dense dark outlined').style('min-width:128px')
                plot_dd  = ui.select(PLOT_TYPES, value='Contour', label='Plot Type').props(
                    'dense dark outlined').style('min-width:140px')
                cut_type = ui.select(CUT_TYPES, value='Phi Cut', label='Cut Type').props(
                    'dense dark outlined').style('min-width:106px')
                cut_val  = ui.number('Cut Value (°)', value=0.0, format='%.1f').props(
                    'dense dark outlined').style('min-width:106px')
                cmin_inp = ui.number('Cmin (dB)', value=-50.0, format='%.0f').props(
                    'dense dark outlined').style('min-width:88px')
                cmax_inp = ui.number('Cmax (dB)', value=0.0,   format='%.0f').props(
                    'dense dark outlined').style('min-width:88px')
                cb_peak = ui.checkbox('Peak', value=True).props('dark color=blue').style('color:#e0e0e0')
                cb_hpbw = ui.checkbox('HPBW', value=True).props('dark color=blue').style('color:#e0e0e0')

                def _update_cut_visibility():
                    show = plot_dd.value in CUT_PLOT_TYPES
                    cut_type.set_visibility(show)
                    cut_val.set_visibility(show)

                # Hide cut controls by default (Contour is selected)
                cut_type.set_visibility(False)
                cut_val.set_visibility(False)

                def _refresh_plot():
                    _update_cut_visibility()
                    if _state['R_single'] is None: return
                    _update_single_plot(
                        plot_refs, comp_dd, plot_dd, cut_type, cut_val,
                        cmin_inp, cmax_inp, cb_peak, cb_hpbw)

                ui.button('Refresh', on_click=_refresh_plot, icon='refresh').props(
                    'flat color=blue size=sm')

            main_plot = ui.plotly({}).classes('w-full').style('height:460px')
            plot_refs.update(dict(
                main=main_plot, comp_dd=comp_dd, plot_dd=plot_dd,
                cut_type=cut_type, cut_val=cut_val,
                cmin_inp=cmin_inp, cmax_inp=cmax_inp,
                cb_peak=cb_peak, cb_hpbw=cb_hpbw,
                fmt_dd=fmt_dd,
                pt=pt_inp, loss=loss_inp, rw=rw_inp, dist=dist_inp,
            ))

            for ctrl in [comp_dd, plot_dd, cut_type, cut_val, cmin_inp, cmax_inp]:
                ctrl.on('update:model-value', lambda _: _refresh_plot())
            cb_peak.on('update:model-value', lambda _: _refresh_plot())
            cb_hpbw.on('update:model-value', lambda _: _refresh_plot())

            # Data tables
            with ui.tabs().props('dense indicator-color=blue').classes('w-full') as dtabs:
                dt_in  = ui.tab('Input Data')
                dt_out = ui.tab('Output Metrics')

            with ui.tab_panels(dtabs, value=dt_in).classes('w-full').style(
                    'background:#0d1117'):
                with ui.tab_panel(dt_in):
                    tbl_in = ui.table(
                        columns=[
                            {'name': 'theta', 'label': 'θ (°)',    'field': 'theta', 'sortable': True},
                            {'name': 'phi',   'label': 'φ (°)',    'field': 'phi',   'sortable': True},
                            {'name': 'gth',   'label': 'Gθ (dB)', 'field': 'gth'},
                            {'name': 'gph',   'label': 'Gφ (dB)', 'field': 'gph'},
                            {'name': 'pth',   'label': '∠Eθ (°)', 'field': 'pth'},
                            {'name': 'pph',   'label': '∠Eφ (°)', 'field': 'pph'},
                        ],
                        rows=[], row_key='theta',
                    ).props('dense dark flat virtual-scroll').style(
                        'max-height:220px').classes('w-full')
                with ui.tab_panel(dt_out):
                    tbl_out = ui.table(
                        columns=[
                            {'name': 'metric', 'label': 'Metric', 'field': 'metric', 'align': 'left'},
                            {'name': 'value',  'label': 'Value',  'field': 'value',  'align': 'left'},
                        ],
                        rows=[], row_key='metric',
                    ).props('dense dark flat virtual-scroll').style(
                        'max-height:220px').classes('w-full')


# ── Single-tab callbacks ─────────────────────────────────────────────────────

async def _on_upload_single(e, lbl_status, plot_refs, tbl_in, tbl_out,
                            lbl_peak, lbl_pol, lbl_hpbw):
    try:
        data = await e.file.read()
        P = load_pattern(data, filename=e.file.name,
                         format_hint=plot_refs['fmt_dd'].value)
        _state['P_single'] = P
        _state['rot_matrix'] = np.eye(3)
        h = P.header
        freq_str = f' | {P.freq_mhz:.1f} MHz' if np.isfinite(P.freq_mhz) else ''
        lbl_status.set_text(
            f'{P.name}  [{P.fmt}]{freq_str}\n'
            f'θ {h["theta_min"]:.0f}°–{h["theta_max"]:.0f}°  '
            f'φ {h["phi_min"]:.0f}°–{h["phi_max"]:.0f}°  '
            f'{h["n_theta"]}×{h["n_phi"]} pts')
        _do_process_single(plot_refs, tbl_in, tbl_out, lbl_peak, lbl_pol, lbl_hpbw,
                           plot_refs['pt'], plot_refs['loss'],
                           plot_refs['rw'],  plot_refs['dist'])
    except Exception as ex:
        import traceback; traceback.print_exc()
        _notify_err(f'Load error: {ex}')
        lbl_status.set_text(f'Error: {ex}')


def _do_process_single(plot_refs, tbl_in, tbl_out, lbl_peak, lbl_pol, lbl_hpbw,
                        pt_inp, loss_inp, rw_inp, dist_inp):
    P = _state['P_single']
    if P is None: return
    try:
        params = dict(Pt_dBW=float(pt_inp.value), Loss_dB=float(loss_inp.value),
                      Rw_dB=float(rw_inp.value), dist_m=float(dist_inp.value))
        R = process_pattern(P, params)
        _state['R_single'] = R

        cmin, cmax = auto_clim(R.max_gain_dB)
        plot_refs['cmin_inp'].set_value(cmin)
        plot_refs['cmax_inp'].set_value(cmax)

        dir_str = f'θ={R.max_gain_dir[0]:.1f}° φ={R.max_gain_dir[1]:.1f}°'
        d_str   = f'  D={R.directivity_dBi:.2f} dBi' if R.directivity_dBi else ''
        lbl_peak.set_text(f'Peak: {R.max_gain_dB:.2f} dBi  @  {dir_str}{d_str}')
        lbl_pol.set_text(f'Dom Pol: {R.dominant_pol}')
        he = f'{R.hpbw_e:.1f}°' if R.hpbw_e else 'N/A'
        hh = f'{R.hpbw_h:.1f}°' if R.hpbw_h else 'N/A'
        fb = f'   FBR={R.fbr_dB:.1f} dB' if R.fbr_dB else ''
        lbl_hpbw.set_text(f'HPBW  E:{he}  H:{hh}{fb}')

        # Input data table
        MAX = 2000
        n   = len(P.theta)
        idx = np.arange(min(n, MAX))
        Gth = 20 * np.log10(np.abs(P.Eth[idx]) + 1e-30)
        Gph = 20 * np.log10(np.abs(P.Eph[idx]) + 1e-30)
        pth = np.angle(P.Eth[idx], deg=True)
        pph = np.angle(P.Eph[idx], deg=True)
        tbl_in.rows = [
            dict(theta=f'{P.theta[i]:.2f}', phi=f'{P.phi[i]:.2f}',
                 gth=f'{Gth[k]:.3f}', gph=f'{Gph[k]:.3f}',
                 pth=f'{pth[k]:.2f}', pph=f'{pph[k]:.2f}')
            for k, i in enumerate(idx)
        ]
        tbl_in.update()
        if n > MAX:
            _notify(f'Input table: showing first {MAX} of {n} rows.', 'info')

        # Output metrics table
        tbl_out.rows = [{'metric': r[0], 'value': r[1]} for r in R.table_rows]
        tbl_out.update()

        _update_single_plot(
            plot_refs,
            plot_refs['comp_dd'], plot_refs['plot_dd'],
            plot_refs['cut_type'], plot_refs['cut_val'],
            plot_refs['cmin_inp'], plot_refs['cmax_inp'],
            plot_refs['cb_peak'],  plot_refs['cb_hpbw'])

        _notify(f'Processed  {P.name}  [{P.fmt}]')
    except Exception as ex:
        import traceback; traceback.print_exc()
        _notify_err(f'Processing error: {ex}')


def _update_single_plot(plot_refs, comp_dd, plot_dd, cut_type, cut_val,
                         cmin_inp, cmax_inp, cb_peak, cb_hpbw):
    R = _state['R_single']
    if R is None: return
    try:
        fig = _render_plot(
            R, plot_type=plot_dd.value, component=comp_dd.value,
            cut_type=cut_type.value, cut_value=float(cut_val.value),
            cmin=float(cmin_inp.value), cmax=float(cmax_inp.value),
            show_peak=cb_peak.value, show_hpbw=cb_hpbw.value,
        )
        plot_refs['main'].update_figure(fig)
    except Exception as ex:
        import traceback; traceback.print_exc()
        _notify_err(f'Plot error: {ex}')


# ══════════════════════════════════════════════════════════════════════════════
# TAB 2 — BATCH
# ══════════════════════════════════════════════════════════════════════════════
def _build_batch_tab():
    refs = {}

    with ui.row().classes('w-full gap-2').style('flex-wrap:nowrap'):

        with ui.column().style('width:300px; min-width:260px; gap:6px; flex-shrink:0'):

            with _card('Load Files'):
                ui.upload(
                    label='Upload multiple pattern files',
                    auto_upload=True, multiple=True,
                    on_upload=lambda e: _on_batch_upload(e, refs)
                ).props(
                    'accept=".fz,.uan,.ffe,.ffd,.ffs,.out,.cut,.csv,.txt,.dat"'
                    ' color=blue flat'
                ).classes('w-full')
                lbl_b_status = ui.label('0 files queued').style('color:#8b949e; font-size:0.78rem')
                refs['lbl_status'] = lbl_b_status

            with _card('Parameters'):
                with ui.grid(columns=2).classes('w-full gap-1'):
                    b_pt   = ui.number('Tx Power (dBW)', value=0.0).props('dense dark outlined')
                    b_loss = ui.number('Loss (dB)',       value=0.0).props('dense dark outlined')
                    b_rw   = ui.number('Rw (dB)',         value=0.0).props('dense dark outlined')
                    b_dist = ui.number('Distance (m)',    value=1.0).props('dense dark outlined')

            def _run_batch():
                entries = _state['batch_entries']
                if not entries: _notify_err('Upload files first.'); return
                params = dict(Pt_dBW=b_pt.value, Loss_dB=b_loss.value,
                              Rw_dB=b_rw.value, dist_m=b_dist.value)
                ok = 0
                for ent in entries:
                    if ent.get('P') and not ent.get('R'):
                        try:
                            ent['R'] = process_pattern(ent['P'], params)
                            ent['ok'] = True; ok += 1
                        except Exception as ex:
                            ent['ok'] = False; ent['err'] = str(ex)
                refs['refresh_list'](refs['file_list'])
                refs['refresh_summary'](refs['summary_plot'])
                _notify(f'Batch complete: {ok}/{len(entries)} OK')

            def _export_batch_csv():
                entries = [e for e in _state['batch_entries'] if e.get('ok')]
                if not entries: _notify_err('Run batch processing first.'); return
                rows = ['name,peak_gain_dBi,peak_theta,peak_phi,dominant_pol,'
                        'hpbw_e_deg,hpbw_h_deg,fbr_dB,directivity_dBi']
                for e in entries:
                    R = e['R']
                    rows.append(f"{e['name']},{R.max_gain_dB:.4f},"
                                f"{R.max_gain_dir[0]:.2f},{R.max_gain_dir[1]:.2f},"
                                f"{R.dominant_pol},"
                                f"{R.hpbw_e or ''},{R.hpbw_h or ''},"
                                f"{R.fbr_dB or ''},{R.directivity_dBi or ''}")
                ui.download('\n'.join(rows).encode(), 'batch_summary.csv')
                _notify('Downloading batch_summary.csv')

            def _clear_batch():
                _state['batch_entries'].clear()
                refs['file_list'].clear()
                refs['lbl_status'].set_text('0 files queued')
                refs['summary_plot'].update_figure({})
                _notify('Batch cleared.')

            with ui.row().classes('w-full gap-1'):
                ui.button('Run Batch',  on_click=_run_batch,       icon='play_arrow').props(
                    'flat color=green').classes('flex-1')
                ui.button('Export CSV', on_click=_export_batch_csv, icon='download').props(
                    'flat color=teal').classes('flex-1')
                ui.button('Clear', on_click=_clear_batch, icon='delete').props(
                    'flat color=red size=sm')

            with _card('File List'):
                file_list = ui.list().props('dense bordered').style(
                    'max-height:260px; overflow-y:auto; '
                    'background:#0d1117; border-radius:4px')
                refs['file_list'] = file_list

        with ui.column().classes('flex-1').style('gap:6px'):
            with _card('Peak Gain Summary'):
                summary_plot = ui.plotly({}).classes('w-full').style('height:260px')
                refs['summary_plot'] = summary_plot

            with _card('Inspect Selected'):
                with ui.row().classes('w-full gap-2 items-center'):
                    b_view = ui.select(
                        ['Contour', 'Circular', 'Polar Cut', '3D Pattern'],
                        value='Contour', label='View').props(
                        'dense dark outlined').style('min-width:120px')
                    b_comp = ui.select(COMPONENTS[:3], value='Total Gain', label='Comp').props(
                        'dense dark outlined').style('min-width:128px')
                    lbl_sel = ui.label('Click a file').style(
                        'color:#8b949e; font-size:0.78rem; flex:1')
                inspect_plot = ui.plotly({}).classes('w-full').style('height:360px')
                refs.update(inspect_plot=inspect_plot, lbl_sel=lbl_sel,
                            b_view=b_view, b_comp=b_comp)

    def _refresh_batch_list(lst):
        lst.clear()
        for ent in _state['batch_entries']:
            icon = '✅' if ent.get('ok') else ('❌' if ent.get('err') else '⏳')
            with lst:
                with ui.item().props('clickable').on(
                        'click', lambda _, e=ent: _select_entry(e, refs)):
                    with ui.item_section():
                        ui.item_label(f'{icon} {ent["name"]}')
                        if ent.get('ok') and ent.get('R'):
                            R = ent['R']
                            ui.item_label(
                                f'Peak {R.max_gain_dB:.2f} dBi  •  {R.dominant_pol}'
                            ).props('caption')
                        elif ent.get('err'):
                            ui.item_label(ent['err'][:80]).props('caption').style(
                                'color:#ef5350')

    def _refresh_batch_summary(plt_el):
        ok = [e for e in _state['batch_entries'] if e.get('ok') and e.get('R')]
        if not ok: return
        plt_el.update_figure(
            plot_batch_summary([e['name'] for e in ok],
                               [e['R'].max_gain_dB for e in ok]))

    refs['refresh_list']    = _refresh_batch_list
    refs['refresh_summary'] = _refresh_batch_summary


async def _on_batch_upload(e, refs):
    try:
        data = await e.file.read()
        P = load_pattern(data, filename=e.file.name)
        _state['batch_entries'].append({'name': P.name, 'P': P, 'R': None, 'ok': False, 'err': ''})
        n = len(_state['batch_entries'])
        refs['lbl_status'].set_text(f'{n} file(s) queued')
        refs['refresh_list'](refs['file_list'])
    except Exception as ex:
        _notify_err(f'Load error ({e.file.name}): {ex}')


def _select_entry(ent, refs):
    if not ent.get('ok') or not ent.get('R'):
        refs['lbl_sel'].set_text(f'{ent["name"]}  — not yet processed'); return
    R = ent['R']
    refs['lbl_sel'].set_text(
        f'{ent["name"]}  |  Peak {R.max_gain_dB:.2f} dBi  |  {R.dominant_pol}')
    cmin, cmax = auto_clim(R.max_gain_dB)
    try:
        fig = _render_plot(R, plot_type=refs['b_view'].value, component=refs['b_comp'].value,
                           cut_type='Phi Cut', cut_value=R.max_gain_dir[0],
                           cmin=cmin, cmax=cmax)
        refs['inspect_plot'].update_figure(fig)
    except Exception as ex:
        _notify_err(f'Inspect error: {ex}')


# ══════════════════════════════════════════════════════════════════════════════
# TAB 3 — COVERAGE
# ══════════════════════════════════════════════════════════════════════════════
def _build_coverage_tab():

    with ui.row().classes('w-full gap-2').style('flex-wrap:nowrap'):

        with ui.column().style('width:300px; min-width:260px; gap:6px; flex-shrink:0'):

            with _card('Load Patterns'):
                ui.upload(
                    label='Upload pattern file(s)',
                    auto_upload=True, multiple=True,
                    on_upload=lambda e: _on_cov_upload(e, cov_list_col, lbl_cov_n)
                ).props(
                    'accept=".fz,.uan,.ffe,.ffd,.ffs,.out,.cut,.csv,.txt,.dat"'
                    ' color=blue flat'
                ).classes('w-full')
                lbl_cov_n = ui.label('0 patterns loaded').style(
                    'color:#8b949e; font-size:0.78rem')

                with ui.scroll_area().style(
                        'max-height:200px; width:100%; background:#0d1117; '
                        'border-radius:4px; border:1px solid #30363d'):
                    cov_list_col = ui.column().classes('w-full').style('gap:2px; padding:4px')

                def _clear_cov():
                    _state['cov_patterns'].clear(); _state['cov_runs'].clear()
                    cov_list_col.clear(); lbl_cov_n.set_text('0 patterns loaded')
                    cov_plot.update_figure({})
                    cov_results_tbl.columns = []; cov_results_tbl.rows = []
                ui.button('Clear All', on_click=_clear_cov, icon='delete').props(
                    'flat color=red size=sm').classes('w-full')

            with _card('Coverage Parameters'):
                cov_mode = ui.radio(['Spherical', 'Conical'], value='Spherical').props(
                    'dark inline color=blue').classes('w-full')
                with ui.column().classes('w-full gap-1') as cone_col:
                    cone_th  = ui.number('Cone axis θ (°)', value=0.0,  format='%.1f').props('dense dark outlined')
                    cone_ph  = ui.number('Cone axis φ (°)', value=0.0,  format='%.1f').props('dense dark outlined')
                    cone_ang = ui.number('Half-angle (°)',  value=60.0, format='%.1f').props('dense dark outlined')
                cone_col.set_visibility(False)
                cov_mode.on('update:model-value',
                            lambda v: cone_col.set_visibility(v.args == 'Conical'))

                ui.separator().style('background:#30363d')
                with ui.grid(columns=3).classes('w-full gap-1'):
                    thr_min  = ui.number('Min (dB)',  value=-40.0, format='%.0f').props('dense dark outlined')
                    thr_max  = ui.number('Max (dB)',  value=0.0,   format='%.0f').props('dense dark outlined')
                    thr_step = ui.number('Step (dB)', value=1.0,   format='%.1f').props('dense dark outlined')

            def _run_coverage():
                pats = [p for p in _state['cov_patterns'] if p.get('enabled', True)]
                if not pats: _notify_err('No enabled patterns.'); return
                thr = np.arange(float(thr_min.value),
                                float(thr_max.value) + 1e-6,
                                max(float(thr_step.value), 0.1))
                mode = 'conical' if cov_mode.value == 'Conical' else 'spherical'
                _state['cov_runs'] = []
                for pat in pats:
                    try:
                        cov = compute_coverage(
                            pat['R'], thr, mode=mode,
                            cone_axis_th=float(cone_th.value),
                            cone_axis_ph=float(cone_ph.value),
                            cone_half_angle=float(cone_ang.value))
                        _state['cov_runs'].append({'name': pat['name'], 'thr': thr, 'cov': cov})
                    except Exception as ex:
                        _notify_err(f'{pat["name"]}: {ex}')
                _refresh_cov_plot()
                _notify('Coverage computed.')

            def _export_cov():
                runs = _state['cov_runs']
                if not runs: _notify_err('Run coverage first.'); return
                thr = runs[0]['thr']
                hdr = 'threshold_dBi,' + ','.join(r['name'] + '_%' for r in runs)
                rows = [hdr]
                for i, t in enumerate(thr):
                    vals = ','.join(f'{r["cov"][i]*100:.2f}' for r in runs)
                    rows.append(f'{t:.2f},{vals}')
                ui.download('\n'.join(rows).encode(), 'coverage.csv')
                _notify('Downloading coverage.csv')

            with ui.row().classes('w-full gap-1'):
                ui.button('Compute',   on_click=_run_coverage, icon='radar').props(
                    'flat color=green').classes('flex-1')
                ui.button('Export CSV', on_click=_export_cov,   icon='download').props(
                    'flat color=teal').classes('flex-1')

        with ui.column().classes('flex-1').style('gap:6px'):
            with _card('Coverage CDF  (% solid angle ≥ threshold)'):
                cov_plot = ui.plotly({}).classes('w-full').style('height:380px')

            with _card('Coverage Results  (threshold × patterns)'):
                cov_results_tbl = ui.table(
                    columns=[], rows=[], row_key='threshold',
                ).props('dense dark flat virtual-scroll').style(
                    'max-height:220px').classes('w-full')

    # ── Helpers (closed over cov_plot and cov_results_tbl) ────────────────
    def _refresh_cov_plot():
        runs = _state['cov_runs']
        if not runs: return

        cov_plot.update_figure(
            plot_coverage_cdf(
                [r['thr'] for r in runs],
                [r['cov'] for r in runs],
                [r['name'] for r in runs],
            )
        )

        # Results table: rows=thresholds, columns=patterns
        thr_arr = np.asarray(runs[0]['thr'])
        # Downsample to ≤30 rows for readability
        step = max(1, len(thr_arr) // 30)

        cols = [{'name': 'threshold', 'label': 'Threshold (dBi)',
                 'field': 'threshold', 'align': 'left', 'sortable': True}]
        for r in runs:
            cols.append({'name': r['name'], 'label': r['name'],
                         'field': r['name'], 'align': 'right'})

        rows = []
        for idx in range(0, len(thr_arr), step):
            row = {'threshold': f'{thr_arr[idx]:.1f}'}
            for r in runs:
                cov_pct = np.asarray(r['cov']) * 100
                row[r['name']] = f'{cov_pct[idx]:.1f}%'
            rows.append(row)

        cov_results_tbl.columns = cols
        cov_results_tbl.rows    = rows
        cov_results_tbl.update()


async def _on_cov_upload(e, lst_col, lbl):
    try:
        data = await e.file.read()
        P = load_pattern(data, filename=e.file.name)
        R = process_pattern(P)
        pat_entry = {'name': P.name, 'R': R, 'enabled': True}
        _state['cov_patterns'].append(pat_entry)
        n = len(_state['cov_patterns'])
        lbl.set_text(f'{n} pattern(s) loaded')

        with lst_col:
            with ui.row().classes('w-full items-center gap-1').style('flex-wrap:nowrap'):
                cb = ui.checkbox(value=True,
                                 on_change=lambda e, p=pat_entry: p.update({'enabled': e.value})
                                 ).props('dark color=blue size=xs')
                ui.label(P.name).style(
                    'font-size:0.8rem; color:#e0e0e0; flex:1; '
                    'overflow:hidden; text-overflow:ellipsis')
                ui.label(f'{R.max_gain_dB:.1f} dBi').style(
                    'font-size:0.75rem; color:#8b949e; white-space:nowrap')

        _notify(f'Loaded {P.name}')
    except Exception as ex:
        _notify_err(f'Coverage load error ({e.file.name}): {ex}')


# ══════════════════════════════════════════════════════════════════════════════
# TAB 4 — COMBINE
# ══════════════════════════════════════════════════════════════════════════════
def _build_combine_tab():
    mask_rows = []      # list of {'type_el', 'v1_el', 'v2_el', 'phi_min_el', ...}
    cmb_refs  = {}

    with ui.row().classes('w-full gap-2').style('flex-wrap:nowrap'):

        with ui.column().style('width:360px; min-width:320px; gap:6px; flex-shrink:0'):

            with _card('Load Patterns to Combine'):
                ui.upload(
                    label='Upload pattern file(s)',
                    auto_upload=True, multiple=True,
                    on_upload=lambda e: _on_cmb_upload(
                        e, cmb_list, lbl_cmb_n, mask_col, mask_rows, cmb_refs)
                ).props(
                    'accept=".fz,.uan,.ffe,.ffd,.ffs,.out,.cut,.csv,.txt,.dat"'
                    ' color=blue flat'
                ).classes('w-full')
                lbl_cmb_n = ui.label('0 pattern(s)').style('color:#8b949e; font-size:0.78rem')
                cmb_list = ui.list().props('dense bordered').style(
                    'max-height:150px; overflow-y:auto; '
                    'background:#0d1117; border-radius:4px')

                def _clear_cmb():
                    _state['cmb_patterns'].clear(); _state['cmb_result'] = None
                    mask_rows.clear(); cmb_list.clear(); mask_col.clear()
                    lbl_cmb_n.set_text('0 pattern(s)')
                    cmb_plot_el.update_figure({})
                    lbl_cmb_result.set_text('Upload ≥ 2 patterns and click Combine')
                    if cmb_refs.get('subplot_row'):
                        cmb_refs['subplot_row'].clear()
                ui.button('Clear All', on_click=_clear_cmb, icon='delete').props(
                    'flat color=red size=sm').classes('w-full')

            with _card('Combine Method'):
                cmb_method = ui.radio(METHODS_DISPLAY, value='Incoherent').props(
                    'dark color=blue').classes('w-full')
                ui.label(
                    'Incoherent = power sum  |  Coherent = E-field sum\n'
                    'Envelope = max per direction  |  Regional Mask = sector selection'
                ).style('color:#8b949e; font-size:0.72rem; white-space:pre-line')

            # ── Regional Mask card — hidden until Regional Mask selected ──
            with _card('Regional Masks') as mask_card_ctx:
                mask_card_el = mask_card_ctx

            # We need the actual card widget to toggle visibility.
            # Re-create it as a column with set_visibility support.

        # We build the mask card outside the nested `with` to get a ref:
        # (restructured below — see mask_outer)

        with ui.column().classes('flex-1').style('gap:6px; min-width:0'):
            with _card('Loaded Patterns Preview'):
                loaded_scroll = ui.scroll_area().style(
                    'width:100%; height:280px; background:#0d1117; border-radius:4px')
                with loaded_scroll:
                    subplot_row = ui.row().classes('gap-2').style(
                        'flex-wrap:nowrap; padding:6px; align-items:flex-start')
                cmb_refs['subplot_row'] = subplot_row

            lbl_cmb_result = ui.label(
                'Upload ≥ 2 patterns and click Combine'
            ).style('color:#8b949e; font-size:0.82rem; padding:4px')

            with _card('Combined Pattern'):
                with ui.row().classes('w-full gap-2 items-center'):
                    cp_type = ui.select(
                        ['Contour', 'Circular', '3D Pattern', '3D Spherical',
                         'Polar Cut', 'Rect Cut'],
                        value='Contour', label='Plot').props(
                        'dense dark outlined').style('min-width:140px')
                    cp_comp = ui.select(COMPONENTS[:3], value='Total Gain', label='Comp').props(
                        'dense dark outlined').style('min-width:128px')

                    def _refresh_cmb_plot():
                        R = _state.get('cmb_result')
                        if R is None: return
                        cmin, cmax = auto_clim(R.max_gain_dB)
                        try:
                            fig = _render_plot(
                                R, plot_type=cp_type.value, component=cp_comp.value,
                                cut_type='Phi Cut', cut_value=R.max_gain_dir[0],
                                cmin=cmin, cmax=cmax)
                            cmb_plot_el.update_figure(fig)
                        except Exception as ex:
                            _notify_err(f'Plot error: {ex}')

                    cp_type.on('update:model-value', lambda _: _refresh_cmb_plot())
                    cp_comp.on('update:model-value', lambda _: _refresh_cmb_plot())
                    ui.button('Refresh', on_click=_refresh_cmb_plot, icon='refresh').props(
                        'flat color=blue size=sm')

                cmb_plot_el = ui.plotly({}).classes('w-full').style('height:460px')

    # ── Regional Mask panel — built separately so we can toggle visibility ──
    with ui.column().classes('w-full').style('gap:6px') as mask_outer:
        with ui.card().tight().style(
                'background:#161b22; border:1px solid #30363d; border-radius:8px; '
                'padding:10px; width:100%; gap:6px').classes('w-full'):
            ui.label('REGIONAL MASKS').style(
                'font-size:0.75rem; font-weight:600; color:#8b949e; '
                'text-transform:uppercase; letter-spacing:0.08em')

            # Global mask type selector
            with ui.row().classes('w-full items-center gap-2'):
                ui.label('Mask type (all patterns):').style(
                    'color:#e0e0e0; font-size:0.82rem; white-space:nowrap')
                mask_type_global = ui.select(
                    MASK_TYPE_DISPLAY, value='Phi / Azimuthal',
                    label='Type').props('dense dark outlined').style('min-width:200px')

            ui.separator().style('background:#30363d')

            with ui.scroll_area().style('max-height:280px; width:100%'):
                mask_col = ui.column().classes('w-full').style('gap:4px')

            ui.label('Pattern 1 covers areas NOT explicitly assigned to other patterns '
                     '(first match wins when masks overlap).').style(
                'color:#8b949e; font-size:0.72rem; font-style:italic')

    mask_outer.set_visibility(False)   # hidden by default

    # Show/hide regional mask panel when method changes
    def _on_method_change(v):
        show = (cmb_method.value == 'Regional Mask')
        mask_outer.set_visibility(show)

    cmb_method.on('update:model-value', _on_method_change)

    # ── Combine / Export buttons (below everything) ───────────────────────
    with ui.row().classes('w-full gap-1').style('padding:4px 0'):
        def _run_combine():
            pats = _state['cmb_patterns']
            if len(pats) < 2: _notify_err('Load ≥ 2 patterns first.'); return
            method_key = METHOD_MAP.get(cmb_method.value, 'incoherent')
            masks = []
            if method_key == 'regional_mask':
                mtype_display = mask_type_global.value
                mtype_key     = MASK_TYPE_MAP.get(mtype_display, 'phi_range')
                for row in mask_rows:
                    if mtype_key == 'custom':
                        masks.append({
                            'type':      'custom',
                            'phi_min':   row['phi_min_el'].value,
                            'phi_max':   row['phi_max_el'].value,
                            'theta_min': row['th_min_el'].value,
                            'theta_max': row['th_max_el'].value,
                        })
                    else:
                        masks.append({
                            'type': mtype_key,
                            'v1':   row['v1_el'].value,
                            'v2':   row['v2_el'].value,
                        })
            try:
                R_comb = combine_patterns(
                    [p['R'] for p in pats], method=method_key, masks=masks)
                _state['cmb_result'] = R_comb
                cmin, cmax = auto_clim(R_comb.max_gain_dB)
                cmb_plot_el.update_figure(plot_contour(R_comb, 'Total Gain', cmin, cmax))
                lbl_cmb_result.set_text(
                    f'Combined {len(pats)} patterns  |  {cmb_method.value}  |  '
                    f'Peak: {R_comb.max_gain_dB:.2f} dBi  |  {R_comb.dominant_pol}')
                _notify('Combine complete.')
            except Exception as ex:
                import traceback; traceback.print_exc()
                _notify_err(f'Combine error: {ex}')

        def _export_combined():
            R = _state.get('cmb_result')
            if R is None: _notify_err('Run combine first.'); return
            rows = ['theta_deg,phi_deg,G_total_dBi,G_RHCP_dBic,G_LHCP_dBic,AR_dB,PLF_dB']
            for i in range(len(R.theta)):
                rows.append(f'{R.theta[i]:.3f},{R.phi[i]:.3f},'
                             f'{R.G_total_dB[i]:.4f},{R.G_RHCP_dB[i]:.4f},'
                             f'{R.G_LHCP_dB[i]:.4f},{R.AR_dB[i]:.4f},{R.PLF_dB[i]:.4f}')
            ui.download('\n'.join(rows).encode(), 'combined_pattern.csv')
            _notify('Downloading combined_pattern.csv')

        ui.button('Combine', on_click=_run_combine, icon='merge').props(
            'flat color=green')
        ui.button('Export CSV', on_click=_export_combined, icon='download').props(
            'flat color=teal')

    # ── Helpers ────────────────────────────────────────────────────────────
    def _rebuild_mask_rows():
        """Rebuild mask input rows for all current patterns."""
        mask_col.clear()
        mask_rows.clear()
        mtype_display = mask_type_global.value
        is_custom = (mtype_display == 'Custom (Phi + Theta)')

        for idx, pat in enumerate(_state['cmb_patterns']):
            row_dict = {}
            with mask_col:
                with ui.row().classes('w-full gap-1 items-center').style('flex-wrap:wrap'):
                    ui.label(f'Pat {idx + 1}: {pat["name"][:20]}').style(
                        'color:#8b949e; min-width:110px; font-size:0.8rem')
                    if is_custom:
                        row_dict['phi_min_el']   = ui.number('φ min', value=idx * (360.0 / max(len(_state['cmb_patterns']), 1)), format='%.1f').props('dense dark outlined').style('width:72px')
                        row_dict['phi_max_el']   = ui.number('φ max', value=(idx + 1) * (360.0 / max(len(_state['cmb_patterns']), 1)), format='%.1f').props('dense dark outlined').style('width:72px')
                        row_dict['th_min_el']    = ui.number('θ min', value=0.0,   format='%.1f').props('dense dark outlined').style('width:66px')
                        row_dict['th_max_el']    = ui.number('θ max', value=180.0, format='%.1f').props('dense dark outlined').style('width:66px')
                    else:
                        n = max(len(_state['cmb_patterns']), 1)
                        span = 360.0 / n
                        lbl_v = 'φ min / φ max' if 'Phi' in mtype_display else 'θ min / θ max'
                        row_dict['v1_el'] = ui.number(lbl_v.split('/')[0].strip(),
                                                      value=round(idx * span, 1),
                                                      format='%.1f').props('dense dark outlined').style('width:80px')
                        row_dict['v2_el'] = ui.number(lbl_v.split('/')[1].strip(),
                                                      value=round((idx + 1) * span, 1),
                                                      format='%.1f').props('dense dark outlined').style('width:80px')
            mask_rows.append(row_dict)

    cmb_refs['rebuild_mask_rows'] = _rebuild_mask_rows

    # Rebuild mask rows when global type changes
    mask_type_global.on('update:model-value', lambda _: _rebuild_mask_rows())


async def _on_cmb_upload(e, lst, lbl, mask_col, mask_rows, cmb_refs):
    try:
        data = await e.file.read()
        P = load_pattern(data, filename=e.file.name)
        R = process_pattern(P)
        _state['cmb_patterns'].append({'name': P.name, 'R': R})
        n = len(_state['cmb_patterns'])
        lbl.set_text(f'{n} pattern(s)')

        with lst:
            with ui.item():
                with ui.item_section():
                    ui.item_label(P.name)
                    ui.item_label(
                        f'Peak {R.max_gain_dB:.2f} dBi  •  {R.dominant_pol}'
                    ).props('caption')

        # Rebuild mask rows for all patterns
        if cmb_refs.get('rebuild_mask_rows'):
            cmb_refs['rebuild_mask_rows']()

        # Add subplot preview
        subplot_row = cmb_refs.get('subplot_row')
        if subplot_row is not None:
            cmin, cmax = auto_clim(R.max_gain_dB)
            try:
                fig = plot_contour(R, 'Total Gain', cmin, cmax, show_peak=True)
                fig.update_layout(
                    title=dict(text=P.name, font=dict(size=10, color='#e0e0e0')),
                    margin=dict(l=30, r=10, t=30, b=30),
                )
                with subplot_row:
                    ui.plotly(fig).style('width:280px; height:240px; flex-shrink:0')
            except Exception:
                pass

        _notify(f'Loaded {P.name}')
    except Exception as ex:
        _notify_err(f'Load error ({e.file.name}): {ex}')


# ══════════════════════════════════════════════════════════════════════════════
# Entry point
# ══════════════════════════════════════════════════════════════════════════════
ui.run(
    host='0.0.0.0',
    port=5000,
    title='Antenna Pattern Analyzer',
    dark=True,
    reload=False,
)
