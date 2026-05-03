"""
Antenna Pattern Analyzer (APA) — unified Python/NiceGUI implementation.
Combines best features from APAv01, APA_v02, APA_v03.
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
                           plot_3d_spherical, plot_circular, plot_filled_polar,
                           plot_coverage_cdf, plot_batch_summary, auto_clim)

# ── Module-level state (single-user / single-process) ──────────────────────
_state = dict(
    P_single=None,
    R_single=None,
    rot_matrix=np.eye(3),
    batch_entries=[],
    cov_patterns=[],
    cov_runs=[],
    cmb_patterns=[],
    cmb_result=None,
)

COMPONENTS = ['Total Gain', 'RHCP Gain', 'LHCP Gain', 'Axial Ratio', 'PLF']
CUT_TYPES  = ['Phi Cut', 'Theta Cut']
PLOT_TYPES = ['Contour', 'Circular', '3D Spherical', 'Polar Cut', 'Rect Cut', 'Filled Polar']
FORMATS    = ['auto', 'xgtd', 'feko', 'hfss', 'cst', 'grasp', 'csv']
METHODS    = ['incoherent', 'coherent', 'envelope', 'regional_mask']


def _notify(msg: str, t: str = 'positive'):
    ui.notify(msg, type=t, position='top-right', timeout=3000)

def _notify_err(msg: str):
    ui.notify(msg, type='negative', position='top-right', timeout=6000)

# ──────────────────────────────────────────────────────────────────────────────
# UI HELPER — styled card wrapper
# ──────────────────────────────────────────────────────────────────────────────
class _Card:
    """Context manager that wraps children in a styled card with an optional title."""
    def __init__(self, title: str = ''):
        self._title = title

    def __enter__(self):
        self._card = ui.card().tight().style(
            'background:#161b22; border:1px solid #30363d; border-radius:8px; '
            'padding:10px; width:100%; gap:4px'
        ).classes('w-full')
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

        # ── Left control panel (fixed width) ─────────────────────────────
        with ui.column().style('width:272px; min-width:260px; gap:6px; flex-shrink:0'):

            with _card('Load Pattern'):
                fmt_dd = ui.select(FORMATS, value='auto', label='Format hint').props(
                    'dense dark outlined').classes('w-full')
                ui.upload(
                    label='Drop / click to upload',
                    auto_upload=True,
                    on_upload=lambda e: _on_upload_single(
                        e, lbl_status, plot_refs,
                        tbl_in, tbl_out, lbl_peak, lbl_pol, lbl_hpbw)
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
                    _do_process_single(
                        plot_refs, tbl_in, tbl_out,
                        lbl_peak, lbl_pol, lbl_hpbw,
                        pt_inp, loss_inp, rw_inp, dist_inp)

                ui.button('Re-process', on_click=_reprocess, icon='refresh').props(
                    'flat color=blue').classes('w-full')

            with _card('Metrics'):
                lbl_peak = ui.label('Peak Gain: —').style('color:#58a6ff; font-size:0.88rem')
                lbl_pol  = ui.label('Dominant Pol: —').style('color:#8b949e; font-size:0.8rem')
                lbl_hpbw = ui.label('HPBW E/H: —').style('color:#8b949e; font-size:0.8rem')

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
                            src_th.value, src_ph.value,
                            dst_th.value, dst_ph.value)
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
                    _notify('Rotation matrix reset. Re-upload to restore original directions.')

                with ui.row().classes('w-full gap-1'):
                    ui.button('Rotate', on_click=_do_rotate, icon='360').props(
                        'flat color=orange').classes('flex-1')
                    ui.button('Reset',  on_click=_reset_rot,  icon='undo').props(
                        'flat color=grey').classes('flex-1')

            with _card('Export'):
                def _export_csv():
                    R = _state['R_single']
                    if R is None:
                        _notify_err('Process a pattern first.'); return
                    rows = ['theta_deg,phi_deg,G_total_dBi,G_RHCP_dBic,G_LHCP_dBic,AR_dB,PLF_dB,EIRP_dBW']
                    for i in range(len(R.theta)):
                        rows.append(
                            f'{R.theta[i]:.3f},{R.phi[i]:.3f},'
                            f'{R.G_total_dB[i]:.4f},{R.G_RHCP_dB[i]:.4f},'
                            f'{R.G_LHCP_dB[i]:.4f},{R.AR_dB[i]:.4f},'
                            f'{R.PLF_dB[i]:.4f},{R.EIRP_dBW[i]:.4f}')
                    ui.download('\n'.join(rows).encode(), 'pattern_output.csv')
                    _notify('Downloading pattern_output.csv')

                ui.button('Export Output CSV', on_click=_export_csv, icon='download').props(
                    'flat color=teal').classes('w-full')

        # ── Right: plot area + data tables ───────────────────────────────
        with ui.column().classes('flex-1').style('gap:6px; min-width:0'):

            # Plot controls bar
            with ui.row().classes('w-full gap-2 items-center').style(
                    'background:#161b22; border-radius:6px; padding:6px 10px; '
                    'border:1px solid #30363d; flex-wrap:wrap'):
                comp_dd  = ui.select(COMPONENTS, value='Total Gain', label='Component').props(
                    'dense dark outlined').style('min-width:128px')
                plot_dd  = ui.select(PLOT_TYPES, value='Contour', label='Plot Type').props(
                    'dense dark outlined').style('min-width:128px')
                cut_type = ui.select(CUT_TYPES,  value='Phi Cut', label='Cut Type').props(
                    'dense dark outlined').style('min-width:106px')
                cut_val  = ui.number('Cut Value (°)', value=0.0, format='%.1f').props(
                    'dense dark outlined').style('min-width:106px')
                cmin_inp = ui.number('Cmin (dB)', value=-50.0, format='%.0f').props(
                    'dense dark outlined').style('min-width:88px')
                cmax_inp = ui.number('Cmax (dB)', value=0.0, format='%.0f').props(
                    'dense dark outlined').style('min-width:88px')
                cb_peak = ui.checkbox('Peak', value=True).props('dark color=blue').style('color:#e0e0e0')
                cb_hpbw = ui.checkbox('HPBW', value=True).props('dark color=blue').style('color:#e0e0e0')

                def _refresh_plot():
                    if _state['R_single'] is None: return
                    _update_single_plot(
                        plot_refs, comp_dd, plot_dd, cut_type, cut_val,
                        cmin_inp, cmax_inp, cb_peak, cb_hpbw)

                ui.button('Refresh', on_click=_refresh_plot, icon='refresh').props(
                    'flat color=blue size=sm')

            # Main plot
            main_plot = ui.plotly({}).classes('w-full').style('height:460px')
            plot_refs['main']     = main_plot
            plot_refs['comp_dd']  = comp_dd
            plot_refs['plot_dd']  = plot_dd
            plot_refs['cut_type'] = cut_type
            plot_refs['cut_val']  = cut_val
            plot_refs['cmin_inp'] = cmin_inp
            plot_refs['cmax_inp'] = cmax_inp
            plot_refs['cb_peak']  = cb_peak
            plot_refs['cb_hpbw']  = cb_hpbw
            plot_refs['fmt_dd']   = fmt_dd
            plot_refs['pt']       = pt_inp
            plot_refs['loss']     = loss_inp
            plot_refs['rw']       = rw_inp
            plot_refs['dist']     = dist_inp

            # Wire auto-refresh on control changes
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
                            {'name':'theta','label':'θ (°)',    'field':'theta','sortable':True},
                            {'name':'phi',  'label':'φ (°)',    'field':'phi',  'sortable':True},
                            {'name':'gth',  'label':'Gθ (dB)', 'field':'gth'},
                            {'name':'gph',  'label':'Gφ (dB)', 'field':'gph'},
                            {'name':'pth',  'label':'∠Eθ (°)', 'field':'pth'},
                            {'name':'pph',  'label':'∠Eφ (°)', 'field':'pph'},
                        ],
                        rows=[], row_key='theta',
                    ).props('dense dark flat virtual-scroll').style(
                        'max-height:220px').classes('w-full')

                with ui.tab_panel(dt_out):
                    tbl_out = ui.table(
                        columns=[
                            {'name':'metric','label':'Metric','field':'metric'},
                            {'name':'value', 'label':'Value', 'field':'value'},
                        ],
                        rows=[], row_key='metric',
                    ).props('dense dark flat virtual-scroll').style(
                        'max-height:220px').classes('w-full')


# ── Single-tab callbacks ────────────────────────────────────────────────────

def _on_upload_single(e, lbl_status, plot_refs, tbl_in, tbl_out,
                       lbl_peak, lbl_pol, lbl_hpbw):
    try:
        P = load_pattern(e.content.read(), filename=e.name,
                         format_hint=plot_refs['fmt_dd'].value)
        _state['P_single'] = P
        _state['rot_matrix'] = np.eye(3)
        h = P.header
        freq_str = f' | {P.freq_mhz:.1f} MHz' if np.isfinite(P.freq_mhz) else ''
        lbl_status.set_text(
            f'{P.name}  [{P.fmt}]{freq_str}\n'
            f'θ {h["theta_min"]:.0f}°–{h["theta_max"]:.0f}°  '
            f'φ {h["phi_min"]:.0f}°–{h["phi_max"]:.0f}°  '
            f'{h["n_theta"]}×{h["n_phi"]} pts'
        )
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

        # Auto colour limits
        cmin, cmax = auto_clim(R.max_gain_dB)
        plot_refs['cmin_inp'].set_value(cmin)
        plot_refs['cmax_inp'].set_value(cmax)

        # Metric labels
        dir_str = f'θ={R.max_gain_dir[0]:.1f}° φ={R.max_gain_dir[1]:.1f}°'
        d_str   = f'  D={R.directivity_dBi:.2f} dBi' if R.directivity_dBi else ''
        lbl_peak.set_text(f'Peak: {R.max_gain_dB:.2f} dBi  @  {dir_str}{d_str}')
        lbl_pol.set_text(f'Dom Pol: {R.dominant_pol}')
        he = f'{R.hpbw_e:.1f}°' if R.hpbw_e else 'N/A'
        hh = f'{R.hpbw_h:.1f}°' if R.hpbw_h else 'N/A'
        fb = f'   FBR={R.fbr_dB:.1f} dB' if R.fbr_dB else ''
        lbl_hpbw.set_text(f'HPBW  E:{he}  H:{hh}{fb}')

        # Input table (capped at 2 000 rows)
        MAX = 2000
        n = len(P.theta)
        idx = np.arange(min(n, MAX))
        Gth = 20*np.log10(np.abs(P.Eth[idx]) + 1e-30)
        Gph = 20*np.log10(np.abs(P.Eph[idx]) + 1e-30)
        pth = np.angle(P.Eth[idx], deg=True)
        pph = np.angle(P.Eph[idx], deg=True)
        tbl_in.rows = [
            dict(theta=f'{P.theta[i]:.2f}', phi=f'{P.phi[i]:.2f}',
                 gth=f'{Gth[k]:.3f}',       gph=f'{Gph[k]:.3f}',
                 pth=f'{pth[k]:.2f}',        pph=f'{pph[k]:.2f}')
            for k, i in enumerate(idx)
        ]
        if n > MAX:
            _notify(f'Input table: showing first {MAX} of {n} rows.', 'info')

        # Output metrics table
        tbl_out.rows = [{'metric': r[0], 'value': r[1]} for r in R.table_rows]

        # Refresh plot
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
    component = comp_dd.value
    plot_type = plot_dd.value
    c_type    = cut_type.value
    c_val     = float(cut_val.value)
    cmin      = float(cmin_inp.value)
    cmax      = float(cmax_inp.value)
    peak      = cb_peak.value
    hpbw      = cb_hpbw.value
    try:
        if   plot_type == 'Contour':
            fig = plot_contour(R, component, cmin, cmax, peak)
        elif plot_type == 'Circular':
            fig = plot_circular(R, component, cmin, cmax)
        elif plot_type == '3D Spherical':
            fig = plot_3d_spherical(R, component, cmin, cmax)
        elif plot_type == 'Polar Cut':
            fig = plot_polar_cut(R, c_type, c_val, component, cmin, cmax, hpbw)
        elif plot_type == 'Rect Cut':
            fig = plot_rect_cut(R, c_type, c_val, cmin, cmax, hpbw)
        elif plot_type == 'Filled Polar':
            fig = plot_filled_polar(R, component, cmin, cmax)
        else:
            fig = plot_contour(R, component, cmin, cmax, peak)
        plot_refs['main'].update_figure(fig)
    except Exception as ex:
        import traceback; traceback.print_exc()
        _notify_err(f'Plot error: {ex}')


# ══════════════════════════════════════════════════════════════════════════════
# TAB 2 — BATCH
# ══════════════════════════════════════════════════════════════════════════════
def _build_batch_tab():
    # We use a mutable container so inner callbacks can reach these widgets
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
                if not entries:
                    _notify_err('Upload files first.'); return
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
                _refresh_batch_list(refs['file_list'])
                _refresh_batch_summary(refs['summary_plot'])
                _notify(f'Batch complete: {ok}/{len(entries)} OK')

            def _export_batch_csv():
                entries = [e for e in _state['batch_entries'] if e.get('ok')]
                if not entries:
                    _notify_err('Run batch processing first.'); return
                rows = ['name,peak_gain_dBi,peak_theta,peak_phi,dominant_pol,'
                        'hpbw_e_deg,hpbw_h_deg,fbr_dB,directivity_dBi']
                for e in entries:
                    R = e['R']
                    rows.append(
                        f"{e['name']},{R.max_gain_dB:.4f},"
                        f"{R.max_gain_dir[0]:.2f},{R.max_gain_dir[1]:.2f},"
                        f"{R.dominant_pol},"
                        f"{R.hpbw_e if R.hpbw_e else ''},"
                        f"{R.hpbw_h if R.hpbw_h else ''},"
                        f"{R.fbr_dB if R.fbr_dB else ''},"
                        f"{R.directivity_dBi if R.directivity_dBi else ''}")
                ui.download('\n'.join(rows).encode(), 'batch_summary.csv')
                _notify('Downloading batch_summary.csv')

            with ui.row().classes('w-full gap-1'):
                ui.button('Run Batch', on_click=_run_batch, icon='play_arrow').props(
                    'flat color=green').classes('flex-1')
                ui.button('Export CSV', on_click=_export_batch_csv, icon='download').props(
                    'flat color=teal').classes('flex-1')

            with _card('Loaded Files'):
                file_list = ui.list().props('dense bordered').style(
                    'max-height:280px; overflow-y:auto; '
                    'background:#0d1117; border-radius:4px')
                refs['file_list'] = file_list

        with ui.column().classes('flex-1').style('gap:6px'):
            with _card('Peak Gain Summary'):
                summary_plot = ui.plotly({}).classes('w-full').style('height:260px')
                refs['summary_plot'] = summary_plot

            with _card('Quick Inspect'):
                with ui.row().classes('w-full gap-2 items-center'):
                    b_view = ui.select(['Contour','Circular','Polar Cut','3D Spherical'],
                                       value='Contour', label='View').props(
                        'dense dark outlined').style('min-width:120px')
                    b_comp = ui.select(COMPONENTS[:3], value='Total Gain', label='Comp').props(
                        'dense dark outlined').style('min-width:128px')
                    lbl_sel = ui.label('Click a file').style('color:#8b949e; font-size:0.78rem; flex:1')

                inspect_plot = ui.plotly({}).classes('w-full').style('height:360px')
                refs['inspect_plot'] = inspect_plot
                refs['lbl_sel']      = lbl_sel
                refs['b_view']       = b_view
                refs['b_comp']       = b_comp

    def _refresh_batch_list(lst):
        lst.clear()
        for ent in _state['batch_entries']:
            icon = '⏳'
            if ent.get('ok'):    icon = '✅'
            elif ent.get('err'): icon = '❌'
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


def _on_batch_upload(e, refs):
    try:
        P = load_pattern(e.content.read(), filename=e.name)
        _state['batch_entries'].append(
            {'name': P.name, 'P': P, 'R': None, 'ok': False, 'err': ''})
        n = len(_state['batch_entries'])
        refs['lbl_status'].set_text(f'{n} file(s) queued')
        refs['refresh_list'](refs['file_list'])
    except Exception as ex:
        _notify_err(f'Load error ({e.name}): {ex}')


def _select_entry(ent, refs):
    inspect_plot = refs['inspect_plot']
    lbl_sel      = refs['lbl_sel']
    if not ent.get('ok') or not ent.get('R'):
        lbl_sel.set_text(f'{ent["name"]}  — not yet processed'); return
    R = ent['R']
    lbl_sel.set_text(
        f'{ent["name"]}  |  Peak {R.max_gain_dB:.2f} dBi  |  {R.dominant_pol}')
    pt   = refs['b_view'].value
    cp   = refs['b_comp'].value
    cmin, cmax = auto_clim(R.max_gain_dB)
    try:
        if pt == 'Contour':
            fig = plot_contour(R, cp, cmin, cmax)
        elif pt == 'Circular':
            fig = plot_circular(R, cp, cmin, cmax)
        elif pt == 'Polar Cut':
            fig = plot_polar_cut(R, 'Phi Cut', R.max_gain_dir[0], cp, cmin, cmax)
        else:
            fig = plot_3d_spherical(R, cp, cmin, cmax)
        inspect_plot.update_figure(fig)
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
                    on_upload=lambda e: _on_cov_upload(e, cov_list, lbl_cov_n)
                ).props(
                    'accept=".fz,.uan,.ffe,.ffd,.ffs,.out,.cut,.csv,.txt,.dat"'
                    ' color=blue flat'
                ).classes('w-full')
                lbl_cov_n = ui.label('0 patterns loaded').style('color:#8b949e; font-size:0.78rem')
                cov_list = ui.list().props('dense bordered').style(
                    'max-height:160px; overflow-y:auto; '
                    'background:#0d1117; border-radius:4px')

                def _clear_cov():
                    _state['cov_patterns'].clear(); _state['cov_runs'].clear()
                    cov_list.clear(); lbl_cov_n.set_text('0 patterns loaded')
                    cov_plot.update_figure({})
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
                    thr_min  = ui.number('Min (dB)', value=-40.0, format='%.0f').props('dense dark outlined')
                    thr_max  = ui.number('Max (dB)', value=0.0,   format='%.0f').props('dense dark outlined')
                    thr_step = ui.number('Step (dB)',value=1.0,   format='%.1f').props('dense dark outlined')

            def _run_coverage():
                pats = _state['cov_patterns']
                if not pats:
                    _notify_err('Load at least one pattern first.'); return
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
                        _state['cov_runs'].append(
                            {'name': pat['name'], 'thr': thr, 'cov': cov})
                    except Exception as ex:
                        _notify_err(f'{pat["name"]}: {ex}')
                _refresh_cov_plot()
                _notify('Coverage computed.')

            def _export_cov():
                runs = _state['cov_runs']
                if not runs:
                    _notify_err('Run coverage first.'); return
                thr = runs[0]['thr']
                hdr = 'threshold_dBi,' + ','.join(r['name'] + '_%' for r in runs)
                rows = [hdr]
                for i, t in enumerate(thr):
                    vals = ','.join(f'{r["cov"][i]*100:.2f}' for r in runs)
                    rows.append(f'{t:.2f},{vals}')
                ui.download('\n'.join(rows).encode(), 'coverage.csv')
                _notify('Downloading coverage.csv')

            with ui.row().classes('w-full gap-1'):
                ui.button('Compute', on_click=_run_coverage, icon='radar').props(
                    'flat color=green').classes('flex-1')
                ui.button('Export CSV', on_click=_export_cov, icon='download').props(
                    'flat color=teal').classes('flex-1')

        with ui.column().classes('flex-1').style('gap:6px'):
            with _card('Coverage CDF  (% solid angle with gain ≥ threshold)'):
                cov_plot = ui.plotly({}).classes('w-full').style('height:500px')

    def _refresh_cov_plot():
        runs = _state['cov_runs']
        if not runs: return
        cov_plot.update_figure(
            plot_coverage_cdf(
                [r['thr'] for r in runs],
                [r['cov'] for r in runs],
                [r['name'] for r in runs]))


def _on_cov_upload(e, lst, lbl):
    try:
        P = load_pattern(e.content.read(), filename=e.name)
        R = process_pattern(P)
        _state['cov_patterns'].append({'name': P.name, 'R': R})
        n = len(_state['cov_patterns'])
        lbl.set_text(f'{n} pattern(s) loaded')
        with lst:
            with ui.item():
                with ui.item_section():
                    ui.item_label(P.name)
                    ui.item_label(
                        f'Peak {R.max_gain_dB:.2f} dBi  •  {R.dominant_pol}'
                    ).props('caption')
        _notify(f'Loaded {P.name}')
    except Exception as ex:
        _notify_err(f'Coverage load error ({e.name}): {ex}')


# ══════════════════════════════════════════════════════════════════════════════
# TAB 4 — COMBINE
# ══════════════════════════════════════════════════════════════════════════════
def _build_combine_tab():
    mask_rows = []

    with ui.row().classes('w-full gap-2').style('flex-wrap:nowrap'):

        with ui.column().style('width:320px; min-width:280px; gap:6px; flex-shrink:0'):

            with _card('Load Patterns to Combine'):
                ui.upload(
                    label='Upload pattern file(s)',
                    auto_upload=True, multiple=True,
                    on_upload=lambda e: _on_cmb_upload(e, cmb_list, lbl_cmb_n)
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
                    cmb_list.clear(); lbl_cmb_n.set_text('0 pattern(s)')
                    cmb_plot_el.update_figure({})
                ui.button('Clear All', on_click=_clear_cmb, icon='delete').props(
                    'flat color=red size=sm').classes('w-full')

            with _card('Combine Method'):
                cmb_method = ui.radio(METHODS, value='incoherent').props(
                    'dark color=blue').classes('w-full')

                ui.label(
                    'incoherent = power sum\n'
                    'coherent   = E-field amplitude sum\n'
                    'envelope   = max per direction\n'
                    'regional_mask = per-pattern sector selection'
                ).style('color:#8b949e; font-size:0.72rem; white-space:pre-line')

            with _card('Regional Masks  (patterns 2…N)'):
                with ui.column().classes('w-full gap-1') as mask_col:
                    pass

                def _add_mask_row():
                    k = len(mask_rows)
                    with mask_col:
                        with ui.row().classes('w-full gap-1 items-center'):
                            ui.label(f'Pat {k+2}:').style('color:#8b949e; min-width:42px; font-size:0.8rem')
                            m_type = ui.select(
                                ['phi_range','theta_range','hemisphere_upper','hemisphere_lower'],
                                value='phi_range').props('dense dark outlined').style('min-width:110px')
                            m_v1 = ui.number('V1', value=0.0,   format='%.1f').props('dense dark outlined').style('width:58px')
                            m_v2 = ui.number('V2', value=180.0, format='%.1f').props('dense dark outlined').style('width:58px')
                            mask_rows.append({'type_el': m_type, 'v1_el': m_v1, 'v2_el': m_v2})

                ui.button('+ Add Mask Row', on_click=_add_mask_row, icon='add').props(
                    'flat color=blue size=sm').classes('w-full')

            def _run_combine():
                pats = _state['cmb_patterns']
                if len(pats) < 2:
                    _notify_err('Load at least 2 patterns first.'); return
                method = cmb_method.value
                masks  = []
                if method == 'regional_mask':
                    for row in mask_rows:
                        masks.append({'type': row['type_el'].value,
                                      'v1':   row['v1_el'].value,
                                      'v2':   row['v2_el'].value})
                try:
                    R_comb = combine_patterns(
                        [p['R'] for p in pats], method=method, masks=masks)
                    _state['cmb_result'] = R_comb
                    cmin, cmax = auto_clim(R_comb.max_gain_dB)
                    cmb_plot_el.update_figure(
                        plot_contour(R_comb, 'Total Gain', cmin, cmax))
                    lbl_cmb_result.set_text(
                        f'Combined {len(pats)} patterns  |  method: {method}  |  '
                        f'Peak: {R_comb.max_gain_dB:.2f} dBi  |  '
                        f'{R_comb.dominant_pol}')
                    _notify('Combine complete.')
                except Exception as ex:
                    import traceback; traceback.print_exc()
                    _notify_err(f'Combine error: {ex}')

            def _export_combined():
                R = _state.get('cmb_result')
                if R is None:
                    _notify_err('Run combine first.'); return
                rows = ['theta_deg,phi_deg,G_total_dBi,G_RHCP_dBic,G_LHCP_dBic,AR_dB,PLF_dB']
                for i in range(len(R.theta)):
                    rows.append(
                        f'{R.theta[i]:.3f},{R.phi[i]:.3f},'
                        f'{R.G_total_dB[i]:.4f},{R.G_RHCP_dB[i]:.4f},'
                        f'{R.G_LHCP_dB[i]:.4f},{R.AR_dB[i]:.4f},{R.PLF_dB[i]:.4f}')
                ui.download('\n'.join(rows).encode(), 'combined_pattern.csv')
                _notify('Downloading combined_pattern.csv')

            with ui.row().classes('w-full gap-1'):
                ui.button('Combine', on_click=_run_combine, icon='merge').props(
                    'flat color=green').classes('flex-1')
                ui.button('Export CSV', on_click=_export_combined, icon='download').props(
                    'flat color=teal').classes('flex-1')

        # ── Right: combined plot ──────────────────────────────────────────
        with ui.column().classes('flex-1').style('gap:6px'):
            lbl_cmb_result = ui.label(
                'Upload at least 2 patterns and click Combine'
            ).style('color:#8b949e; font-size:0.82rem; padding:4px')

            with _card('Combined Pattern'):
                with ui.row().classes('w-full gap-2 items-center'):
                    cp_type = ui.select(PLOT_TYPES[:5], value='Contour', label='Plot').props(
                        'dense dark outlined').style('min-width:128px')
                    cp_comp = ui.select(COMPONENTS[:3], value='Total Gain', label='Comp').props(
                        'dense dark outlined').style('min-width:128px')

                    def _refresh_cmb_plot():
                        R = _state.get('cmb_result')
                        if R is None: return
                        pt = cp_type.value; cp = cp_comp.value
                        cmin, cmax = auto_clim(R.max_gain_dB)
                        try:
                            if   pt == 'Contour':
                                fig = plot_contour(R, cp, cmin, cmax)
                            elif pt == 'Circular':
                                fig = plot_circular(R, cp, cmin, cmax)
                            elif pt == '3D Spherical':
                                fig = plot_3d_spherical(R, cp, cmin, cmax)
                            elif pt == 'Polar Cut':
                                fig = plot_polar_cut(R, 'Phi Cut',
                                                     R.max_gain_dir[0], cp, cmin, cmax)
                            elif pt == 'Rect Cut':
                                fig = plot_rect_cut(R, 'Phi Cut',
                                                    R.max_gain_dir[0], cmin, cmax)
                            else:
                                fig = plot_contour(R, cp, cmin, cmax)
                            cmb_plot_el.update_figure(fig)
                        except Exception as ex:
                            _notify_err(f'Plot error: {ex}')

                    cp_type.on('update:model-value', lambda _: _refresh_cmb_plot())
                    cp_comp.on('update:model-value', lambda _: _refresh_cmb_plot())
                    ui.button('Refresh', on_click=_refresh_cmb_plot, icon='refresh').props(
                        'flat color=blue size=sm')

                cmb_plot_el = ui.plotly({}).classes('w-full').style('height:500px')


def _on_cmb_upload(e, lst, lbl):
    try:
        P = load_pattern(e.content.read(), filename=e.name)
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
        _notify(f'Loaded {P.name}')
    except Exception as ex:
        _notify_err(f'Load error ({e.name}): {ex}')


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
