"""
Antenna Pattern Analyzer (APA) — unified Python/NiceGUI implementation.
"""
import sys, os, traceback
sys.path.insert(0, os.path.dirname(__file__))

import asyncio
import numpy as np
from nicegui import ui, app

from src.parsers import load_pattern
from src.processing import (process_pattern, combine_patterns, compute_coverage,
                             rotation_matrix_from_vectors, apply_rotation,
                             rotate_processed_pattern,
                             get_component_grid, get_cut, detect_boresight)
from src.plotting import (plot_contour, plot_polar_cut, plot_rect_cut,
                           plot_3d_pattern, plot_3d_sphere,
                           plot_circular, plot_filled_polar,
                           plot_coverage_cdf, plot_batch_summary, auto_clim,
                           set_plot_theme)

# ── Orientation presets (matches MATLAB DropDown_InitOri) ────────────────────
_ORI_PRESETS = {
    '+Z (Overhead)': (0.0,   0.0),
    '-Z (Deck)':     (180.0, 0.0),
    '+X (Forward)':  (90.0,  0.0),
    '-X (Aft)':      (90.0,  180.0),
    '+Y (Stbd)':     (90.0,  90.0),
    '-Y (Port)':     (90.0,  270.0),
    'Custom...':     None,
}
_BORESIGHT_TO_ORI = {
    '+Z': '+Z (Overhead)', '-Z': '-Z (Deck)',
    '+X': '+X (Forward)',  '-X': '-X (Aft)',
    '+Y': '+Y (Stbd)',     '-Y': '-Y (Port)',
}

# ── Module-level state ───────────────────────────────────────────────────────
_state = dict(
    P_single=None, R_single=None, R_single_base=None, rot_matrix=np.eye(3),
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

FULL_PLOT_TYPES = ['Contour', 'Circular', '3D Pattern', '3D Spherical']
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
        self._card = ui.card().tight().props('bordered').classes('w-full').style(
            'border-radius:8px; padding:10px; width:100%; gap:4px')
        self._card.__enter__()
        if self._title:
            ui.label(self._title).classes('text-caption text-grey-6').style(
                'font-weight:600; text-transform:uppercase; '
                'letter-spacing:0.08em; margin-bottom:2px')
        return self._card

    def __exit__(self, *a):
        self._card.__exit__(*a)


def _card(title=''):
    return _Card(title)


def _render_plot(R, plot_type, component, cut_type, cut_value, cmin, cmax,
                 show_peak=True, show_hpbw=False, cut_component='All'):
    if plot_type == 'Contour':
        return plot_contour(R, component, cmin, cmax, show_peak)
    elif plot_type == 'Circular':
        return plot_circular(R, component, cmin, cmax)
    elif plot_type == '3D Pattern':
        return plot_3d_pattern(R, component, cmin, cmax)
    elif plot_type == '3D Spherical':
        return plot_3d_sphere(R, component, cmin, cmax)
    elif plot_type == 'Polar Cut':
        return plot_polar_cut(R, cut_type, cut_value, cut_component, cmin, cmax, show_hpbw)
    elif plot_type == 'Rect Cut':
        return plot_rect_cut(R, cut_type, cut_value, cut_component, cmin, cmax, show_hpbw)
    elif plot_type == 'Filled Polar':
        return plot_filled_polar(R, component, cut_type, cut_value, cmin, cmax)
    else:
        return plot_contour(R, component, cmin, cmax, show_peak)


# ══════════════════════════════════════════════════════════════════════════════
# MAIN PAGE
# ══════════════════════════════════════════════════════════════════════════════
_MOON_SVG = (
    '<svg viewBox="0 0 24 24" width="18" height="18" fill="none" '
    'stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">'
    '<path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>'
    '</svg>'
)
_SUN_SVG = (
    '<svg viewBox="0 0 24 24" width="18" height="18" fill="none" '
    'stroke="#ffd600" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">'
    '<circle cx="12" cy="12" r="5"/>'
    '<line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/>'
    '<line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/>'
    '<line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/>'
    '<line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/>'
    '<line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/>'
    '<line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>'
    '</svg>'
)


@ui.page('/')
def main_page():
    ui.query('body').style('font-family:Roboto,sans-serif')

    ui.add_head_html('''<script>
function _apaRelayoutPlotly(bgPaper, bgPlot, fontColor) {
  if (typeof Plotly === 'undefined') return;
  document.querySelectorAll('.js-plotly-plot').forEach(div => {
    try {
      const isLight = fontColor === '#24292f';
      Plotly.relayout(div, {
        paper_bgcolor: bgPaper, plot_bgcolor: bgPlot,
        'font.color': fontColor, 'title.font.color': fontColor,
        'scene.bgcolor': bgPlot, 'polar.bgcolor': bgPlot,
        'polar.angularaxis.tickcolor': fontColor,
        'polar.angularaxis.tickfont.color': fontColor,
        'polar.radialaxis.tickfont.color': fontColor,
        'polar.radialaxis.gridcolor': isLight ? '#c0c8d8' : '#334466',
        'xaxis.gridcolor': isLight ? '#c0c8d8' : '#334466',
        'yaxis.gridcolor': isLight ? '#c0c8d8' : '#334466',
        'xaxis.zerolinecolor': isLight ? '#c0c8d8' : '#334466',
        'yaxis.zerolinecolor': isLight ? '#c0c8d8' : '#334466',
        'xaxis.tickfont.color': fontColor, 'yaxis.tickfont.color': fontColor,
        'xaxis.title.font.color': fontColor, 'yaxis.title.font.color': fontColor,
        'legend.font.color': fontColor,
        'legend.bgcolor': isLight ? 'rgba(240,242,245,0.85)' : 'rgba(0,0,0,0.3)',
      });
    } catch(e) {}
  });
}
</script>''')

    _dark = ui.dark_mode(value=False)
    _theme = {'dark': False}

    with ui.header(elevated=True).classes('items-center').style('padding:4px 12px; gap:0'):
        ui.label('📡 APA').style(
            'font-size:1.1rem; font-weight:700; letter-spacing:1px; '
            'flex-shrink:0; margin-right:8px').classes('text-white')

        with ui.tabs().props('dense indicator-color=white align=center').classes('flex-1') as tabs:
            t_single   = ui.tab('Single',   icon='tune')
            t_batch    = ui.tab('Batch',    icon='folder_open')
            t_coverage = ui.tab('Coverage', icon='radar')
            t_combine  = ui.tab('Combine',  icon='merge')

        def _toggle_theme():
            _theme['dark'] = not _theme['dark']
            if _theme['dark']:
                _dark.enable()
                set_plot_theme(True)
                _theme_icon.set_content(_SUN_SVG)
                ui.run_javascript('_apaRelayoutPlotly("#16213e","#1a1a2e","#e0e0e0")')
            else:
                _dark.disable()
                set_plot_theme(False)
                _theme_icon.set_content(_MOON_SVG)
                ui.run_javascript('_apaRelayoutPlotly("#f5f7fa","#f0f2f5","#24292f")')

        with ui.button(on_click=_toggle_theme).props('flat round dense').style(
                'width:34px; height:34px; padding:0; min-width:0; '
                'flex-shrink:0; margin-left:8px') as _theme_btn:
            _theme_icon = ui.html(_MOON_SVG)

    _ui_tabs['tabs']       = tabs
    _ui_tabs['t_single']   = t_single
    _ui_tabs['t_coverage'] = t_coverage
    _ui_tabs['t_combine']  = t_combine

    with ui.tab_panels(tabs, value=t_single).classes('w-full').style('padding:0'):
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

        # ── Left controls ──────────────────────────────────────────────────
        with ui.column().style('width:272px; min-width:260px; gap:6px; flex-shrink:0'):

            with _card('Load Pattern'):
                fmt_dd = ui.select(FORMATS, value='auto', label='Format hint').props(
                    'dense outlined').classes('w-full')
                ui.upload(
                    label='Drop / click to upload', auto_upload=True,
                    on_upload=lambda e: _on_upload_single(
                        e, lbl_status, plot_refs, tbl_in, tbl_data, tbl_out,
                        lbl_peak, lbl_pol, lbl_hpbw)
                ).props(
                    'accept=".fz,.uan,.ffe,.ffd,.ffs,.out,.cut,.csv,.txt,.dat"'
                    ' color=blue flat'
                ).classes('w-full')
                lbl_status = ui.label('No file loaded').style(
                    'color:#8b949e; font-size:0.78rem; word-break:break-all')

            with _card('Parameters'):
                with ui.grid(columns=2).classes('w-full gap-1'):
                    pt_inp   = ui.number('Tx Power (dBW)', value=0.0, format='%.1f').props('dense outlined')
                    loss_inp = ui.number('Loss (dB)',       value=0.0, format='%.1f').props('dense outlined')
                    rw_inp   = ui.number('Rw (dB)',         value=0.0, format='%.1f').props('dense outlined')
                    dist_inp = ui.number('Distance (m)',    value=1.0, format='%.2f').props('dense outlined')

                def _reprocess():
                    if _state['P_single'] is None:
                        _notify_err('Load a file first.'); return
                    _do_process_single(plot_refs, tbl_in, tbl_data, tbl_out,
                                       lbl_peak, lbl_pol, lbl_hpbw,
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
                            _notify(f'"{P.name}" already in Coverage.', 'warning')
                            _ui_tabs['tabs'].set_value(_ui_tabs['t_coverage'])
                            return
                    pat_entry = {'name': P.name, 'R': R, 'enabled': True}
                    _state['cov_patterns'].append(pat_entry)
                    # Refresh the coverage list UI if callback is registered
                    if _ui_tabs.get('refresh_cov_list'):
                        _ui_tabs['refresh_cov_list'](pat_entry)
                    _notify(f'Sent "{P.name}" → Coverage tab')
                    _ui_tabs['tabs'].set_value(_ui_tabs['t_coverage'])

                def _send_to_combine():
                    if _state['R_single'] is None:
                        _notify_err('Process a pattern first.'); return
                    P = _state['P_single']; R = _state['R_single']
                    for p in _state['cmb_patterns']:
                        if p['name'] == P.name:
                            _notify(f'"{P.name}" already in Combine.', 'warning')
                            _ui_tabs['tabs'].set_value(_ui_tabs['t_combine'])
                            return
                    _state['cmb_patterns'].append({'name': P.name, 'R': R})
                    if _ui_tabs.get('refresh_cmb_list'):
                        _ui_tabs['refresh_cmb_list']({'name': P.name, 'R': R})
                    _notify(f'Sent "{P.name}" → Combine tab')
                    _ui_tabs['tabs'].set_value(_ui_tabs['t_combine'])

                with ui.row().classes('w-full gap-1'):
                    ui.button('→ Coverage', on_click=_send_to_coverage, icon='radar').props(
                        'flat color=green size=sm').classes('flex-1')
                    ui.button('→ Combine',  on_click=_send_to_combine,  icon='merge').props(
                        'flat color=purple size=sm').classes('flex-1')

            with _card('Rotation (cumulative SO(3))'):
                # Source orientation preset dropdown
                src_ori = ui.select(
                    list(_ORI_PRESETS.keys()),
                    value='+Z (Overhead)',
                    label='Source Orientation',
                ).props('dense outlined').classes('w-full')

                with ui.grid(columns=2).classes('w-full gap-1'):
                    src_th = ui.number('Src θ (°)', value=0.0).props('dense outlined')
                    src_ph = ui.number('Src φ (°)', value=0.0).props('dense outlined')
                    dst_th = ui.number('Dst θ (°)', value=0.0).props('dense outlined')
                    dst_ph = ui.number('Dst φ (°)', value=0.0).props('dense outlined')

                def _sync_src_spinners(_e=None):
                    coords = _ORI_PRESETS.get(src_ori.value)
                    if coords is not None:
                        src_th.set_value(coords[0])
                        src_ph.set_value(coords[1])

                def _on_src_spinner(_e=None):
                    src_ori.set_value('Custom...')

                def _auto_detect_src():
                    if _state['R_single'] is None:
                        _notify_err('Process a pattern first.'); return
                    d = detect_boresight(_state['R_single'])
                    label = _BORESIGHT_TO_ORI.get(d, 'Custom...')
                    src_ori.set_value(label)
                    coords = _ORI_PRESETS.get(label)
                    if coords:
                        src_th.set_value(coords[0])
                        src_ph.set_value(coords[1])
                    _notify(f'Detected source boresight: {d}')

                src_ori.on('update:model-value', _sync_src_spinners)
                src_th.on('update:model-value', _on_src_spinner)
                src_ph.on('update:model-value', _on_src_spinner)

                # Store ref so _do_process_single can trigger auto-detect after load
                plot_refs['src_ori'] = src_ori
                plot_refs['src_th']  = src_th
                plot_refs['src_ph']  = src_ph

                def _do_rotate():
                    if _state['R_single_base'] is None:
                        _notify_err('Process a pattern first.'); return
                    try:
                        R_mat = rotation_matrix_from_vectors(
                            float(src_th.value), float(src_ph.value),
                            float(dst_th.value), float(dst_ph.value))
                        _state['rot_matrix'] = _state['rot_matrix'] @ R_mat
                        _state['R_single'] = rotate_processed_pattern(
                            _state['R_single'], R_mat)
                        R = _state['R_single']
                        # Dst becomes new Src after rotation
                        src_th.set_value(float(dst_th.value))
                        src_ph.set_value(float(dst_ph.value))
                        src_ori.set_value('Custom...')
                        dir_str = f'θ={R.max_gain_dir[0]:.1f}° φ={R.max_gain_dir[1]:.1f}°'
                        lbl_peak.set_text(f'Peak: {R.max_gain_dB:.2f} dBi  @  {dir_str}')
                        _update_single_plot(
                            plot_refs,
                            plot_refs['comp_dd'], plot_refs['plot_dd'],
                            plot_refs['cut_type'], plot_refs['cut_val'],
                            plot_refs['cmin_inp'], plot_refs['cmax_inp'],
                            plot_refs['cb_peak'],  plot_refs['cb_hpbw'],
                            plot_refs['cut_comp'])
                        _notify('Rotation applied.')
                    except Exception as ex:
                        traceback.print_exc()
                        _notify_err(f'Rotation error: {ex}')

                def _reset_rot():
                    _state['rot_matrix'] = np.eye(3)
                    if _state['R_single_base'] is not None:
                        _state['R_single'] = _state['R_single_base']
                        _update_single_plot(
                            plot_refs,
                            plot_refs['comp_dd'], plot_refs['plot_dd'],
                            plot_refs['cut_type'], plot_refs['cut_val'],
                            plot_refs['cmin_inp'], plot_refs['cmax_inp'],
                            plot_refs['cb_peak'],  plot_refs['cb_hpbw'],
                            plot_refs['cut_comp'])
                    # Re-run auto-detect on the base pattern
                    if _state['R_single_base'] is not None:
                        d = detect_boresight(_state['R_single_base'])
                        label = _BORESIGHT_TO_ORI.get(d, '+Z (Overhead)')
                        src_ori.set_value(label)
                        coords = _ORI_PRESETS.get(label, (0.0, 0.0))
                        src_th.set_value(coords[0])
                        src_ph.set_value(coords[1])
                    _notify('Rotation reset to original.')

                with ui.row().classes('w-full gap-1'):
                    ui.button('Auto-detect', on_click=_auto_detect_src,
                              icon='my_location').props('flat color=teal size=sm').classes('flex-1')
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

        # ── Right: plot + tables ────────────────────────────────────────────
        with ui.column().classes('flex-1').style('gap:6px; min-width:0'):

            # Plot controls bar
            with ui.row().classes('w-full gap-2 items-center').style(
                    'border-radius:6px; padding:6px 10px; flex-wrap:wrap'):
                comp_dd  = ui.select(COMPONENTS, value='Total Gain', label='Component').props(
                    'dense outlined').style('min-width:128px')
                plot_dd  = ui.select(PLOT_TYPES, value='Contour', label='Plot Type').props(
                    'dense outlined').style('min-width:140px')
                cut_type = ui.select(CUT_TYPES, value='Phi Cut', label='Cut Type').props(
                    'dense outlined').style('min-width:106px')
                cut_val  = ui.number('Cut Value (°)', value=0.0, format='%.1f').props(
                    'dense outlined').style('min-width:106px')
                _CUT_COMPS = ['Total Gain', 'RHCP Gain', 'LHCP Gain']
                cut_comp = ui.select(
                    _CUT_COMPS, value=_CUT_COMPS, multiple=True,
                    label='Cut Components').props(
                    'dense outlined use-chips').style('min-width:160px')
                cmin_inp = ui.number('Cmin (dB)', value=-50.0, format='%.0f').props(
                    'dense outlined').style('min-width:88px')
                cmax_inp = ui.number('Cmax (dB)', value=0.0,   format='%.0f').props(
                    'dense outlined').style('min-width:88px')
                cb_peak = ui.checkbox('Peak', value=True).props('color=blue')
                cb_hpbw = ui.checkbox('HPBW', value=False).props('color=yellow')

                def _update_controls_visibility():
                    is_cut = plot_dd.value in CUT_PLOT_TYPES
                    is_1d_cut = plot_dd.value in ('Polar Cut', 'Rect Cut')
                    cut_type.set_visibility(is_cut)
                    cut_val.set_visibility(is_cut)
                    cut_comp.set_visibility(is_1d_cut)
                    cb_hpbw.set_visibility(is_1d_cut)

                # Initial visibility (Contour = no cut controls)
                cut_type.set_visibility(False)
                cut_val.set_visibility(False)
                cut_comp.set_visibility(False)
                cb_hpbw.set_visibility(False)

                def _refresh_plot():
                    _update_controls_visibility()
                    if _state['R_single'] is None: return
                    _update_single_plot(
                        plot_refs, comp_dd, plot_dd, cut_type, cut_val,
                        cmin_inp, cmax_inp, cb_peak, cb_hpbw, cut_comp)

                ui.button('Refresh', on_click=_refresh_plot, icon='refresh').props(
                    'flat color=blue size=sm')

            main_plot = ui.plotly({}).classes('w-full').style('height:460px')
            plot_refs.update(dict(
                main=main_plot, comp_dd=comp_dd, plot_dd=plot_dd,
                cut_type=cut_type, cut_val=cut_val, cut_comp=cut_comp,
                cmin_inp=cmin_inp, cmax_inp=cmax_inp,
                cb_peak=cb_peak, cb_hpbw=cb_hpbw,
                fmt_dd=fmt_dd,
                pt=pt_inp, loss=loss_inp, rw=rw_inp, dist=dist_inp,
            ))

            for ctrl in [comp_dd, plot_dd, cut_type, cut_val, cut_comp, cmin_inp, cmax_inp]:
                ctrl.on('update:model-value', lambda _: _refresh_plot())
            cb_peak.on('update:model-value', lambda _: _refresh_plot())
            cb_hpbw.on('update:model-value', lambda _: _refresh_plot())

            # ── Data tables (2 tabs — metrics are in the left panel) ──────────
            with ui.tabs().props('dense indicator-color=blue').classes('w-full') as dtabs:
                dt_in   = ui.tab('Input Data')
                dt_data = ui.tab('Output Data')

            with ui.tab_panels(dtabs, value=dt_in).classes('w-full'):

                with ui.tab_panel(dt_in):
                    _IN_COLS = [
                        {'name': 'row_num', 'label': '#',        'field': 'row_num', 'align': 'right',  'style': 'width:46px; color:#57606a'},
                        {'name': 'theta',   'label': 'θ (°)',    'field': 'theta',   'sortable': True},
                        {'name': 'phi',     'label': 'φ (°)',    'field': 'phi',     'sortable': True},
                        {'name': 'gth',     'label': '|Eθ| dB', 'field': 'gth',     'sortable': True},
                        {'name': 'gph',     'label': '|Eφ| dB', 'field': 'gph',     'sortable': True},
                        {'name': 'pth',     'label': '∠Eθ (°)', 'field': 'pth'},
                        {'name': 'pph',     'label': '∠Eφ (°)', 'field': 'pph'},
                    ]
                    tbl_in = ui.table(
                        columns=_IN_COLS, rows=[], row_key='row_num',
                    ).props('dense flat virtual-scroll sticky-header').style(
                        'height:240px').classes('w-full')

                with ui.tab_panel(dt_data):
                    _DATA_COLS = [
                        {'name': 'row_num', 'label': '#',              'field': 'row_num', 'align': 'right', 'style': 'width:46px; color:#57606a'},
                        {'name': 'theta',   'label': 'θ (°)',          'field': 'theta',   'sortable': True},
                        {'name': 'phi',     'label': 'φ (°)',          'field': 'phi',     'sortable': True},
                        {'name': 'gtot',    'label': 'G_tot (dBi)',    'field': 'gtot',    'sortable': True},
                        {'name': 'grhcp',   'label': 'G_RHCP (dBic)', 'field': 'grhcp',   'sortable': True},
                        {'name': 'glhcp',   'label': 'G_LHCP (dBic)', 'field': 'glhcp',   'sortable': True},
                        {'name': 'ar',      'label': 'AR (dB)',        'field': 'ar',      'sortable': True},
                        {'name': 'plf',     'label': 'PLF (dB)',       'field': 'plf',     'sortable': True},
                        {'name': 'eirp',    'label': 'EIRP (dBW)',     'field': 'eirp',    'sortable': True},
                    ]
                    tbl_data = ui.table(
                        columns=_DATA_COLS, rows=[], row_key='row_num',
                    ).props('dense flat virtual-scroll sticky-header').style(
                        'height:240px').classes('w-full')

            # Dummy table for backward compat (tbl_out.rows still updated in callback)
            tbl_out = ui.table(columns=[], rows=[]).props('dense').style('display:none')
            # Store count labels in plot_refs so _do_process_single can update them


# ── Single-tab callbacks ──────────────────────────────────────────────────────

async def _on_upload_single(e, lbl_status, plot_refs, tbl_in, tbl_data, tbl_out,
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
        _do_process_single(plot_refs, tbl_in, tbl_data, tbl_out,
                           lbl_peak, lbl_pol, lbl_hpbw,
                           plot_refs['pt'], plot_refs['loss'],
                           plot_refs['rw'],  plot_refs['dist'])
    except Exception as ex:
        traceback.print_exc()
        _notify_err(f'Load error: {ex}')
        lbl_status.set_text(f'Error: {ex}')


def _do_process_single(plot_refs, tbl_in, tbl_data, tbl_out,
                        lbl_peak, lbl_pol, lbl_hpbw,
                        pt_inp, loss_inp, rw_inp, dist_inp):
    P = _state['P_single']
    if P is None: return
    try:
        params = dict(Pt_dBW=float(pt_inp.value), Loss_dB=float(loss_inp.value),
                      Rw_dB=float(rw_inp.value), dist_m=float(dist_inp.value))
        R = process_pattern(P, params)
        # Save unrotated base; apply any accumulated rotation on top
        _state['R_single_base'] = R
        rot = _state['rot_matrix']
        if not np.allclose(rot, np.eye(3)):
            R = rotate_processed_pattern(R, rot)
        _state['R_single'] = R

        # Auto-detect boresight and update source spinners
        if 'src_ori' in plot_refs:
            d = detect_boresight(R)
            label = _BORESIGHT_TO_ORI.get(d, '+Z (Overhead)')
            coords = _ORI_PRESETS.get(label, (0.0, 0.0))
            plot_refs['src_ori'].set_value(label)
            plot_refs['src_th'].set_value(coords[0])
            plot_refs['src_ph'].set_value(coords[1])

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

        n   = len(P.theta)
        idx = np.arange(n)

        # ── Input data table — ALL rows ────────────────────────────────────
        Gth = 20 * np.log10(np.abs(P.Eth) + 1e-30)
        Gph = 20 * np.log10(np.abs(P.Eph) + 1e-30)
        pth = np.angle(P.Eth, deg=True)
        pph = np.angle(P.Eph, deg=True)
        tbl_in.rows = [
            dict(row_num=str(i + 1),
                 theta=f'{P.theta[i]:.2f}', phi=f'{P.phi[i]:.2f}',
                 gth=f'{Gth[i]:.3f}', gph=f'{Gph[i]:.3f}',
                 pth=f'{pth[i]:.2f}', pph=f'{pph[i]:.2f}')
            for i in idx
        ]
        tbl_in.update()

        # ── Output data table — ALL rows ────────────────────────────────────
        tbl_data.rows = [
            dict(row_num=str(i + 1),
                 theta=f'{R.theta[i]:.2f}', phi=f'{R.phi[i]:.2f}',
                 gtot=f'{R.G_total_dB[i]:.3f}',
                 grhcp=f'{R.G_RHCP_dB[i]:.3f}',
                 glhcp=f'{R.G_LHCP_dB[i]:.3f}',
                 ar=f'{R.AR_dB[i]:.3f}',
                 plf=f'{R.PLF_dB[i]:.3f}',
                 eirp=f'{R.EIRP_dBW[i]:.3f}')
            for i in idx
        ]
        tbl_data.update()

        # ── Output metrics table ──────────────────────────────────────────
        tbl_out.rows = [{'metric': r[0], 'value': r[1]} for r in R.table_rows]
        tbl_out.update()

        _update_single_plot(
            plot_refs,
            plot_refs['comp_dd'], plot_refs['plot_dd'],
            plot_refs['cut_type'], plot_refs['cut_val'],
            plot_refs['cmin_inp'], plot_refs['cmax_inp'],
            plot_refs['cb_peak'],  plot_refs['cb_hpbw'],
            plot_refs['cut_comp'])

        _notify(f'Processed  {P.name}  [{P.fmt}]')
    except Exception as ex:
        traceback.print_exc()
        _notify_err(f'Processing error: {ex}')


def _update_single_plot(plot_refs, comp_dd, plot_dd, cut_type, cut_val,
                         cmin_inp, cmax_inp, cb_peak, cb_hpbw, cut_comp=None):
    R = _state['R_single']
    if R is None: return
    try:
        # Multi-select value is a list; fall back to all 3 if empty
        cc = cut_comp.value if cut_comp is not None else ['Total Gain', 'RHCP Gain', 'LHCP Gain']
        if isinstance(cc, list) and len(cc) == 0:
            cc = ['Total Gain', 'RHCP Gain', 'LHCP Gain']
        fig = _render_plot(
            R, plot_type=plot_dd.value, component=comp_dd.value,
            cut_type=cut_type.value, cut_value=float(cut_val.value),
            cmin=float(cmin_inp.value), cmax=float(cmax_inp.value),
            show_peak=cb_peak.value, show_hpbw=cb_hpbw.value,
            cut_component=cc,
        )
        plot_refs['main'].update_figure(fig)
    except Exception as ex:
        traceback.print_exc()
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
                    b_pt   = ui.number('Tx Power (dBW)', value=0.0).props('dense outlined')
                    b_loss = ui.number('Loss (dB)',       value=0.0).props('dense outlined')
                    b_rw   = ui.number('Rw (dB)',         value=0.0).props('dense outlined')
                    b_dist = ui.number('Distance (m)',    value=1.0).props('dense outlined')

            async def _run_batch():
                entries = _state['batch_entries']
                if not entries: _notify_err('Upload files first.'); return
                params = dict(Pt_dBW=b_pt.value, Loss_dB=b_loss.value,
                              Rw_dB=b_rw.value, dist_m=b_dist.value)
                ok = 0
                loop = asyncio.get_event_loop()
                for ent in entries:
                    if ent.get('P') and not ent.get('R'):
                        try:
                            P, par = ent['P'], params
                            ent['R'] = await loop.run_in_executor(
                                None, lambda p=P, pa=par: process_pattern(p, pa))
                            ent['ok'] = True; ok += 1
                        except Exception as ex:
                            ent['ok'] = False; ent['err'] = str(ex)
                refs['refresh_list'](refs['file_list'])
                refs['refresh_summary'](refs['summary_plot'])
                _notify(f'Batch complete: {ok}/{len(entries)} OK')

            def _export_batch_csv():
                import zipfile, io
                entries = [e for e in _state['batch_entries'] if e.get('ok')]
                if not entries: _notify_err('Run batch processing first.'); return
                buf = io.BytesIO()
                with zipfile.ZipFile(buf, 'w', zipfile.ZIP_DEFLATED) as zf:
                    for e in entries:
                        R = e['R']
                        rows = ['theta_deg,phi_deg,G_total_dBi,G_RHCP_dBic,'
                                'G_LHCP_dBic,AR_dB,PLF_dB,EIRP_dBW']
                        for i in range(len(R.theta)):
                            rows.append(
                                f'{R.theta[i]:.4f},{R.phi[i]:.4f},'
                                f'{R.G_total_dB[i]:.4f},{R.G_RHCP_dB[i]:.4f},'
                                f'{R.G_LHCP_dB[i]:.4f},{R.AR_dB[i]:.4f},'
                                f'{R.PLF_dB[i]:.4f},{R.EIRP_dBW[i]:.4f}')
                        safe_name = e['name'].rsplit('.', 1)[0] + '_processed.csv'
                        zf.writestr(safe_name, '\n'.join(rows))
                buf.seek(0)
                ui.download(buf.read(), 'batch_patterns.zip')
                _notify(f'Downloading {len(entries)} pattern CSV(s) as zip')

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
                    'max-height:260px; overflow-y:auto')
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
                        'dense outlined').style('min-width:120px')
                    b_comp = ui.select(COMPONENTS[:3], value='Total Gain', label='Comp').props(
                        'dense outlined').style('min-width:128px')
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
                with ui.item().style('padding:2px 4px; min-height:0'):
                    with ui.item_section():
                        with ui.row().classes('w-full items-center gap-1').style('flex-wrap:nowrap'):
                            with ui.column().classes('flex-1').style(
                                    'gap:1px; cursor:pointer; overflow:hidden').on(
                                    'click', lambda _, e=ent: _select_entry(e, refs)):
                                name_lbl = ui.label(f'{icon} {ent["name"]}').style(
                                    'font-size:0.82rem; overflow:hidden; '
                                    'text-overflow:ellipsis; white-space:nowrap')
                                if ent.get('ok') and ent.get('R'):
                                    R = ent['R']
                                    ui.label(
                                        f'Peak {R.max_gain_dB:.2f} dBi  •  {R.dominant_pol}'
                                    ).classes('text-caption text-grey-6')
                                elif ent.get('err'):
                                    ui.label(ent['err'][:80]).style(
                                        'font-size:0.72rem; color:#ef5350')

                            def _batch_rename(e=ent, lbl=name_lbl, icon_str=icon):
                                with ui.dialog() as dlg, ui.card().props('bordered').style(
                                        'padding:14px; gap:8px'):
                                    ui.label('Rename Pattern').classes(
                                        'text-subtitle2 text-weight-medium')
                                    inp = ui.input(value=e['name']).props(
                                        'dense outlined').classes('w-full').style('min-width:240px')
                                    with ui.row().classes('gap-1'):
                                        def _save(entry=e, label=lbl, d=dlg,
                                                  inpt=inp, ic=icon_str):
                                            v = inpt.value.strip()
                                            if v: entry['name'] = v; label.set_text(f'{ic} {v}')
                                            d.close()
                                        ui.button('Save', on_click=_save).props(
                                            'flat color=blue size=sm')
                                        ui.button('Cancel', on_click=dlg.close).props(
                                            'flat color=grey size=sm')
                                dlg.open()
                            ui.button(icon='edit', on_click=_batch_rename).props(
                                'flat round dense size=xs color=grey')

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

            with _card('Loaded Patterns'):
                lbl_cov_n = ui.label('0 patterns loaded').style(
                    'color:#8b949e; font-size:0.78rem')
                with ui.scroll_area().style('max-height:200px; width:100%'):
                    cov_list_col = ui.column().classes('w-full').style(
                        'gap:2px; padding:4px')

                ui.upload(
                    label='Upload pattern file(s)',
                    auto_upload=True, multiple=True,
                    on_upload=lambda e: _on_cov_upload(e, cov_list_col, lbl_cov_n,
                                                        _refresh_cov_plot)
                ).props(
                    'accept=".fz,.uan,.ffe,.ffd,.ffs,.out,.cut,.csv,.txt,.dat"'
                    ' color=blue flat'
                ).classes('w-full')

                def _clear_cov():
                    _state['cov_patterns'].clear(); _state['cov_runs'].clear()
                    cov_list_col.clear(); lbl_cov_n.set_text('0 patterns loaded')
                    cov_plot.update_figure({})
                    cov_results_tbl.columns = []; cov_results_tbl.rows = []
                ui.button('Clear All', on_click=_clear_cov, icon='delete').props(
                    'flat color=red size=sm').classes('w-full')

            with _card('Coverage Parameters'):
                cov_mode = ui.radio(['Spherical', 'Conical'], value='Spherical').props(
                    'inline color=blue').classes('w-full')

                with ui.column().classes('w-full gap-1') as cone_col:
                    cone_ori = ui.select(
                        list(_ORI_PRESETS.keys()),
                        value='+Z (Overhead)',
                        label='Cone Axis Orientation',
                    ).props('dense outlined').classes('w-full')
                    cone_th  = ui.number('Cone axis θ (°)', value=0.0,  format='%.1f').props('dense outlined')
                    cone_ph  = ui.number('Cone axis φ (°)', value=0.0,  format='%.1f').props('dense outlined')
                    cone_ang = ui.number('Half-angle (°)',  value=60.0, format='%.1f').props('dense outlined')

                    def _sync_cone_spinners(_e=None):
                        coords = _ORI_PRESETS.get(cone_ori.value)
                        if coords is not None:
                            cone_th.set_value(coords[0])
                            cone_ph.set_value(coords[1])

                    def _on_cone_spinner(_e=None):
                        cone_ori.set_value('Custom...')

                    def _auto_detect_cone():
                        pats = [p for p in _state['cov_patterns'] if p.get('enabled', True)]
                        if not pats: _notify_err('Load a pattern first.'); return
                        d = detect_boresight(pats[0]['R'])
                        label = _BORESIGHT_TO_ORI.get(d, 'Custom...')
                        cone_ori.set_value(label)
                        coords = _ORI_PRESETS.get(label)
                        if coords:
                            cone_th.set_value(coords[0])
                            cone_ph.set_value(coords[1])
                        _notify(f'Cone axis auto-detected: {d}')

                    cone_ori.on('update:model-value', _sync_cone_spinners)
                    cone_th.on('update:model-value', _on_cone_spinner)
                    cone_ph.on('update:model-value', _on_cone_spinner)

                    ui.button('Auto-detect cone axis', on_click=_auto_detect_cone,
                              icon='my_location').props('flat color=teal size=sm').classes('w-full')

                cone_col.set_visibility(False)

                def _on_mode_change(_e=None):
                    cone_col.set_visibility(cov_mode.value == 'Conical')
                cov_mode.on('update:model-value', _on_mode_change)

                ui.separator()
                with ui.grid(columns=3).classes('w-full gap-1'):
                    thr_min  = ui.number('Min (dB)',  value=-40.0, format='%.0f').props('dense outlined')
                    thr_max  = ui.number('Max (dB)',  value=0.0,   format='%.0f').props('dense outlined')
                    thr_step = ui.number('Step (dB)', value=1.0,   format='%.1f').props('dense outlined')

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
                ui.button('Compute',    on_click=_run_coverage, icon='radar').props(
                    'flat color=green').classes('flex-1')
                ui.button('Export CSV', on_click=_export_cov,   icon='download').props(
                    'flat color=teal').classes('flex-1')

        with ui.column().classes('flex-1').style('gap:6px'):
            with _card('Coverage CDF  (% solid angle ≥ threshold)'):
                cov_plot = ui.plotly({}).classes('w-full').style('height:380px')

            with _card('Coverage Results  (threshold × patterns)'):
                cov_results_tbl = ui.table(
                    columns=[], rows=[], row_key='threshold',
                ).props('dense flat virtual-scroll').style(
                    'max-height:220px').classes('w-full')

    # ── Helpers ──────────────────────────────────────────────────────────────
    def _add_cov_row_to_list(pat_entry):
        """Add one pattern row to the cov_list_col column widget."""
        n = len(_state['cov_patterns'])
        lbl_cov_n.set_text(f'{n} pattern(s) loaded')
        with cov_list_col:
            with ui.row().classes('w-full items-center gap-1').style('flex-wrap:nowrap'):
                def _on_cov_cb_change(e, p=pat_entry):
                    p.update({'enabled': e.value})
                    _refresh_cov_plot()
                cb = ui.checkbox(
                    value=pat_entry.get('enabled', True),
                    on_change=_on_cov_cb_change,
                ).props('color=blue size=xs')
                name_lbl = ui.label(pat_entry['name']).style(
                    'font-size:0.8rem; flex:1; overflow:hidden; text-overflow:ellipsis')
                ui.label(f'{pat_entry["R"].max_gain_dB:.1f} dBi').style(
                    'font-size:0.75rem; color:#8b949e; white-space:nowrap')

                def _cov_rename(p=pat_entry, lbl=name_lbl):
                    with ui.dialog() as dlg, ui.card().style('padding:14px; gap:8px').props('bordered'):
                        ui.label('Rename Pattern').classes('text-subtitle2 text-weight-medium')
                        inp = ui.input(value=p['name']).props(
                            'dense outlined').classes('w-full').style('min-width:240px')
                        with ui.row().classes('gap-1'):
                            def _save(entry=p, label=lbl, d=dlg, inpt=inp):
                                v = inpt.value.strip()
                                if v: entry['name'] = v; label.set_text(v)
                                d.close()
                            ui.button('Save',   on_click=_save).props('flat color=blue size=sm')
                            ui.button('Cancel', on_click=dlg.close).props('flat color=grey size=sm')
                    dlg.open()
                ui.button(icon='edit', on_click=_cov_rename).props(
                    'flat round dense size=xs').style('color:#8b949e; flex-shrink:0')

    def _refresh_cov_plot():
        all_runs = _state['cov_runs']
        if not all_runs: return
        # Filter to only patterns currently enabled in the list
        enabled = {p['name'] for p in _state['cov_patterns'] if p.get('enabled', True)}
        runs = [r for r in all_runs if r['name'] in enabled]
        if not runs:
            cov_plot.update_figure({})
            cov_results_tbl.columns = []; cov_results_tbl.rows = []
            cov_results_tbl.update()
            return

        cov_plot.update_figure(
            plot_coverage_cdf(
                [r['thr'] for r in runs],
                [r['cov'] for r in runs],
                [r['name'] for r in runs],
            )
        )

        thr_arr = np.asarray(runs[0]['thr'])
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

    # Register the list-row-adder so Single tab "→ Coverage" can call it
    _ui_tabs['refresh_cov_list'] = _add_cov_row_to_list

    # Rebuild list rows for any patterns already in state (e.g. sent before tab built)
    for pat_entry in _state['cov_patterns']:
        _add_cov_row_to_list(pat_entry)


async def _on_cov_upload(e, lst_col, lbl, refresh_plot_fn):
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
                def _cov_cb(ev, p=pat_entry):
                    p.update({'enabled': ev.value})
                    refresh_plot_fn()
                cb = ui.checkbox(value=True, on_change=_cov_cb).props('color=blue size=xs')
                name_lbl2 = ui.label(P.name).style(
                    'font-size:0.8rem; flex:1; overflow:hidden; text-overflow:ellipsis')
                ui.label(f'{R.max_gain_dB:.1f} dBi').style(
                    'font-size:0.75rem; color:#8b949e; white-space:nowrap')
                def _cov_upload_rename(p=pat_entry, lbl=name_lbl2):
                    with ui.dialog() as dlg, ui.card().style('padding:14px; gap:8px').props('bordered'):
                        ui.label('Rename Pattern').classes('text-subtitle2 text-weight-medium')
                        inp = ui.input(value=p['name']).props(
                            'dense outlined').classes('w-full').style('min-width:240px')
                        with ui.row().classes('gap-1'):
                            def _save(entry=p, label=lbl, d=dlg, inpt=inp):
                                v = inpt.value.strip()
                                if v: entry['name'] = v; label.set_text(v)
                                d.close()
                            ui.button('Save',   on_click=_save).props('flat color=blue size=sm')
                            ui.button('Cancel', on_click=dlg.close).props('flat color=grey size=sm')
                    dlg.open()
                ui.button(icon='edit', on_click=_cov_upload_rename).props(
                    'flat round dense size=xs').style('color:#8b949e; flex-shrink:0')

        _notify(f'Loaded {P.name}')
    except Exception as ex:
        traceback.print_exc()
        _notify_err(f'Coverage load error ({e.file.name}): {ex}')


# ══════════════════════════════════════════════════════════════════════════════
# TAB 4 — COMBINE
# ══════════════════════════════════════════════════════════════════════════════
def _build_combine_tab():
    mask_rows = []      # list of {'v1_el', 'v2_el'} or {'phi_min_el', ...}
    cmb_refs  = {}

    with ui.row().classes('w-full gap-2').style('flex-wrap:nowrap'):

        with ui.column().style('width:360px; min-width:320px; gap:6px; flex-shrink:0'):

            with _card('Load Patterns to Combine'):
                ui.upload(
                    label='Upload pattern file(s)',
                    auto_upload=True, multiple=True,
                    on_upload=lambda e: _on_cmb_upload(
                        e, cmb_list, lbl_cmb_n, mask_col, mask_rows, cmb_refs,
                        subplot_row_ref)
                ).props(
                    'accept=".fz,.uan,.ffe,.ffd,.ffs,.out,.cut,.csv,.txt,.dat"'
                    ' color=blue flat'
                ).classes('w-full')
                lbl_cmb_n = ui.label('0 pattern(s)').style('color:#8b949e; font-size:0.78rem')
                cmb_list = ui.list().props('dense bordered').style(
                    'max-height:150px; overflow-y:auto')

                def _clear_cmb():
                    _state['cmb_patterns'].clear(); _state['cmb_result'] = None
                    mask_rows.clear(); cmb_list.clear(); mask_col.clear()
                    lbl_cmb_n.set_text('0 pattern(s)')
                    cmb_plot_el.update_figure({})
                    lbl_cmb_result.set_text('Upload ≥ 2 patterns and click Combine')
                    subplot_row_ref[0].clear()
                ui.button('Clear All', on_click=_clear_cmb, icon='delete').props(
                    'flat color=red size=sm').classes('w-full')

            with _card('Combine Method'):
                cmb_method = ui.radio(METHODS_DISPLAY, value='Incoherent').props(
                    'color=blue').classes('w-full')
                ui.label(
                    'Incoherent = power sum  |  Coherent = E-field sum\n'
                    'Envelope = max per direction  |  Regional Mask = sector selection'
                ).style('color:#8b949e; font-size:0.72rem; white-space:pre-line')

        with ui.column().classes('flex-1').style('gap:6px; min-width:0'):
            with _card('Loaded Patterns Preview'):
                loaded_scroll = ui.scroll_area().style('width:100%; height:280px')
                with loaded_scroll:
                    subplot_row = ui.row().classes('gap-2').style(
                        'flex-wrap:nowrap; padding:6px; align-items:flex-start')
            subplot_row_ref = [subplot_row]   # list so it's mutable from closures

            lbl_cmb_result = ui.label(
                'Upload ≥ 2 patterns and click Combine'
            ).style('color:#8b949e; font-size:0.82rem; padding:4px')

            with _card('Combined Pattern'):
                with ui.row().classes('w-full gap-2 items-center').style('flex-wrap:wrap'):
                    cp_type = ui.select(
                        ['Contour', 'Circular', '3D Pattern', '3D Spherical',
                         'Polar Cut', 'Rect Cut'],
                        value='Contour', label='Plot').props(
                        'dense outlined').style('min-width:140px')
                    cp_comp = ui.select(COMPONENTS[:3], value='Total Gain', label='Comp').props(
                        'dense outlined').style('min-width:128px')
                    cp_cmin = ui.number('Cmin (dB)', value=-50.0, format='%.0f').props(
                        'dense outlined').style('width:100px')
                    cp_cmax = ui.number('Cmax (dB)', value=0.0, format='%.0f').props(
                        'dense outlined').style('width:100px')

                    def _refresh_cmb_plot():
                        R = _state.get('cmb_result')
                        if R is None: return
                        c0, c1 = auto_clim(R.max_gain_dB)
                        cmin = cp_cmin.value if cp_cmin.value is not None else c0
                        cmax = cp_cmax.value if cp_cmax.value is not None else c1
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
                    cp_cmin.on('update:model-value', lambda _: _refresh_cmb_plot())
                    cp_cmax.on('update:model-value', lambda _: _refresh_cmb_plot())
                    ui.button('Refresh', on_click=_refresh_cmb_plot, icon='refresh').props(
                        'flat color=blue size=sm')

                cmb_plot_el = ui.plotly({}).classes('w-full').style('height:460px')

    # ── Regional Mask panel ────────────────────────────────────────────────
    with ui.column().classes('w-full').style('gap:6px') as mask_outer:
        with ui.card().tight().props('bordered').classes('w-full').style(
                'border-radius:8px; padding:10px; width:100%; gap:6px'):
            ui.label('REGIONAL MASKS').classes('text-caption text-grey-6').style(
                'font-weight:600; text-transform:uppercase; letter-spacing:0.08em')

            with ui.row().classes('w-full items-center gap-2'):
                ui.label('Mask type (all patterns):').style(
                    'font-size:0.82rem; white-space:nowrap')
                mask_type_global = ui.select(
                    MASK_TYPE_DISPLAY, value='Phi / Azimuthal',
                    label='Type').props('dense outlined').style('min-width:200px')

            ui.separator()

            with ui.scroll_area().style('max-height:280px; width:100%'):
                mask_col = ui.column().classes('w-full').style('gap:4px')

            ui.label(
                'Tip: each zone covers the range [min, max]. '
                'Changing a zone\'s upper limit auto-updates the next zone\'s lower limit (+1°).'
            ).style('color:#8b949e; font-size:0.72rem; font-style:italic')

    mask_outer.set_visibility(False)

    def _on_method_change(e):
        mask_outer.set_visibility(cmb_method.value == 'Regional Mask')
    cmb_method.on('update:model-value', _on_method_change)

    # ── Combine / Export buttons ────────────────────────────────────────────
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
                            'phi_min':   float(row['phi_min_el'].value),
                            'phi_max':   float(row['phi_max_el'].value),
                            'theta_min': float(row['th_min_el'].value),
                            'theta_max': float(row['th_max_el'].value),
                        })
                    else:
                        masks.append({
                            'type': mtype_key,
                            'v1':   float(row['v1_el'].value),
                            'v2':   float(row['v2_el'].value),
                        })
            try:
                R_comb = combine_patterns(
                    [p['R'] for p in pats], method=method_key, masks=masks)
                _state['cmb_result'] = R_comb
                cmin, cmax = auto_clim(R_comb.max_gain_dB)
                cp_cmin.set_value(cmin); cp_cmax.set_value(cmax)
                cmb_plot_el.update_figure(plot_contour(R_comb, 'Total Gain', cmin, cmax))
                lbl_cmb_result.set_text(
                    f'Combined {len(pats)} patterns  |  {cmb_method.value}  |  '
                    f'Peak: {R_comb.max_gain_dB:.2f} dBi  |  {R_comb.dominant_pol}')
                _notify('Combine complete.')
            except Exception as ex:
                traceback.print_exc()
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

        ui.button('Combine',    on_click=_run_combine,    icon='merge').props('flat color=green')
        ui.button('Export CSV', on_click=_export_combined, icon='download').props('flat color=teal')

    # ── Mask row builder ────────────────────────────────────────────────────
    def _rebuild_mask_rows():
        mask_col.clear()
        mask_rows.clear()
        n_pats   = len(_state['cmb_patterns'])
        if n_pats == 0:
            return
        mtype_display = mask_type_global.value
        is_custom     = (mtype_display == 'Custom (Phi + Theta)')
        is_theta      = (mtype_display == 'Theta / Elevation')

        total   = 180.0 if is_theta else 360.0
        span    = total / n_pats
        # Non-overlapping defaults: zone k = [k*span, (k+1)*span] with 1° gap for all but last
        # Gap of 1° means upper limit = (k+1)*span  and next lower = (k+1)*span + 1
        # Simplification: lower[k] = k*span,  upper[k] = (k+1)*span - (1 if k < n-1 else 0)

        for idx in range(n_pats):
            row_dict = {}
            pat_name = _state['cmb_patterns'][idx]['name'][:20]
            v1_default = round(idx * span, 1)
            v2_default = round((idx + 1) * span - (1.0 if idx < n_pats - 1 else 0.0), 1)

            with mask_col:
                with ui.row().classes('w-full gap-1 items-center').style('flex-wrap:wrap'):
                    ui.label(f'Pat {idx + 1}: {pat_name}').style(
                        'color:#8b949e; min-width:120px; font-size:0.8rem')

                    if is_custom:
                        phi_span = 360.0 / n_pats
                        row_dict['phi_min_el'] = ui.number(
                            'φ min', value=round(idx * phi_span, 1),
                            format='%.1f').props('dense outlined').style('width:72px')
                        row_dict['phi_max_el'] = ui.number(
                            'φ max',
                            value=round((idx+1)*phi_span - (1.0 if idx < n_pats-1 else 0.0), 1),
                            format='%.1f').props('dense outlined').style('width:72px')
                        th_span = 180.0 / n_pats
                        row_dict['th_min_el'] = ui.number(
                            'θ min', value=round(idx * th_span, 1),
                            format='%.1f').props('dense outlined').style('width:66px')
                        row_dict['th_max_el'] = ui.number(
                            'θ max',
                            value=round((idx+1)*th_span - (1.0 if idx < n_pats-1 else 0.0), 1),
                            format='%.1f').props('dense outlined').style('width:66px')
                    else:
                        lbl_v1, lbl_v2 = (('θ min', 'θ max') if is_theta else ('φ min', 'φ max'))
                        row_dict['v1_el'] = ui.number(
                            lbl_v1, value=v1_default,
                            format='%.1f').props('dense outlined').style('width:88px')
                        row_dict['v2_el'] = ui.number(
                            lbl_v2, value=v2_default,
                            format='%.1f').props('dense outlined').style('width:88px')

            mask_rows.append(row_dict)

        # Wire dynamic cascade: changing v2 of row k updates v1 of row k+1
        def _make_cascade(k):
            def _cascade(e):
                if k + 1 < len(mask_rows):
                    next_row = mask_rows[k + 1]
                    next_v1  = next_row.get('v1_el') or next_row.get('phi_min_el')
                    if next_v1 is not None:
                        try:
                            raw = e.args if hasattr(e, 'args') else getattr(e, 'value', None)
                            next_v1.set_value(round(float(raw) + 1.0, 1))
                        except (TypeError, ValueError):
                            pass
            return _cascade

        for k, row_dict in enumerate(mask_rows):
            v2 = row_dict.get('v2_el') or row_dict.get('phi_max_el')
            if v2 is not None:
                v2.on('update:model-value', _make_cascade(k))

    cmb_refs['rebuild_mask_rows'] = _rebuild_mask_rows

    mask_type_global.on('update:model-value', lambda _: _rebuild_mask_rows())

    # Register a callback so Single tab "→ Combine" can add a row
    def _add_cmb_list_item(pat_entry):
        with cmb_list:
            with ui.row().classes('w-full items-center gap-1').style(
                    'padding:4px 6px; flex-wrap:nowrap'):
                with ui.column().classes('flex-1').style('gap:1px; overflow:hidden'):
                    cmb_name_lbl = ui.item_label(pat_entry['name']).style(
                        'overflow:hidden; text-overflow:ellipsis; white-space:nowrap')
                    ui.item_label(
                        f'Peak {pat_entry["R"].max_gain_dB:.2f} dBi  •  {pat_entry["R"].dominant_pol}'
                    ).props('caption')

                def _cmb_rename(p=pat_entry, lbl=cmb_name_lbl):
                    with ui.dialog() as dlg, ui.card().style('padding:14px; gap:8px').props('bordered'):
                        ui.label('Rename Pattern').classes('text-subtitle2 text-weight-medium')
                        inp = ui.input(value=p['name']).props(
                            'dense outlined').classes('w-full').style('min-width:240px')
                        with ui.row().classes('gap-1'):
                            def _save(entry=p, label=lbl, d=dlg, inpt=inp):
                                v = inpt.value.strip()
                                if v: entry['name'] = v; label.set_text(v)
                                d.close()
                            ui.button('Save',   on_click=_save).props('flat color=blue size=sm')
                            ui.button('Cancel', on_click=dlg.close).props('flat color=grey size=sm')
                    dlg.open()
                ui.button(icon='edit', on_click=_cmb_rename).props(
                    'flat round dense size=xs').style('color:#8b949e; flex-shrink:0')
        lbl_cmb_n.set_text(f'{len(_state["cmb_patterns"])} pattern(s)')
        _rebuild_mask_rows()
        # Add subplot preview
        try:
            R = pat_entry['R']
            cmin, cmax = auto_clim(R.max_gain_dB)
            fig = plot_contour(R, 'Total Gain', cmin, cmax, show_peak=True)
            fig.update_layout(
                title=dict(text=pat_entry['name'], font=dict(size=10, color='#e0e0e0')),
                margin=dict(l=30, r=10, t=30, b=30))
            with subplot_row_ref[0]:
                ui.plotly(fig).style('width:280px; height:240px; flex-shrink:0')
        except Exception:
            pass

    _ui_tabs['refresh_cmb_list'] = _add_cmb_list_item

    # Populate from existing state (patterns sent before this tab was built)
    for pat in _state['cmb_patterns']:
        _add_cmb_list_item(pat)


async def _on_cmb_upload(e, lst, lbl, mask_col, mask_rows, cmb_refs, subplot_row_ref):
    try:
        data = await e.file.read()
        P = load_pattern(data, filename=e.file.name)
        R = process_pattern(P)
        pat_entry = {'name': P.name, 'R': R}
        _state['cmb_patterns'].append(pat_entry)
        n = len(_state['cmb_patterns'])
        lbl.set_text(f'{n} pattern(s)')

        with lst:
            with ui.row().classes('w-full items-center gap-1').style(
                    'padding:4px 6px; flex-wrap:nowrap'):
                with ui.column().classes('flex-1').style('gap:1px; overflow:hidden'):
                    cmb_ul_lbl = ui.item_label(P.name).style(
                        'overflow:hidden; text-overflow:ellipsis; white-space:nowrap')
                    ui.item_label(
                        f'Peak {R.max_gain_dB:.2f} dBi  •  {R.dominant_pol}'
                    ).props('caption')
                def _cmb_ul_rename(p=pat_entry, lbl=cmb_ul_lbl):
                    with ui.dialog() as dlg, ui.card().style('padding:14px; gap:8px').props('bordered'):
                        ui.label('Rename Pattern').classes('text-subtitle2 text-weight-medium')
                        inp = ui.input(value=p['name']).props(
                            'dense outlined').classes('w-full').style('min-width:240px')
                        with ui.row().classes('gap-1'):
                            def _save(entry=p, label=lbl, d=dlg, inpt=inp):
                                v = inpt.value.strip()
                                if v: entry['name'] = v; label.set_text(v)
                                d.close()
                            ui.button('Save',   on_click=_save).props('flat color=blue size=sm')
                            ui.button('Cancel', on_click=dlg.close).props('flat color=grey size=sm')
                    dlg.open()
                ui.button(icon='edit', on_click=_cmb_ul_rename).props(
                    'flat round dense size=xs').style('color:#8b949e; flex-shrink:0')

        if cmb_refs.get('rebuild_mask_rows'):
            cmb_refs['rebuild_mask_rows']()

        # Subplot preview
        cmin, cmax = auto_clim(R.max_gain_dB)
        try:
            fig = plot_contour(R, 'Total Gain', cmin, cmax, show_peak=True)
            fig.update_layout(
                title=dict(text=P.name, font=dict(size=10, color='#e0e0e0')),
                margin=dict(l=30, r=10, t=30, b=30))
            with subplot_row_ref[0]:
                ui.plotly(fig).style('width:280px; height:240px; flex-shrink:0')
        except Exception:
            pass

        _notify(f'Loaded {P.name}')
    except Exception as ex:
        traceback.print_exc()
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
