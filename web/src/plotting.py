"""
Plotly figure builders for all APA plot types.
"""
import numpy as np
import plotly.graph_objects as go
from scipy.interpolate import RegularGridInterpolator
from typing import Tuple
from .processing import ProcessedPattern, get_component_grid, get_cut


_COLORSCALE = 'Jet'
_BG         = '#1a1a2e'
_PAPER      = '#16213e'
_FONT_COLOR = '#e0e0e0'
_GRID_COLOR = '#334466'

_LAYOUT_BASE = dict(
    paper_bgcolor=_PAPER,
    plot_bgcolor=_BG,
    font=dict(color=_FONT_COLOR, size=11),
    margin=dict(l=50, r=20, t=40, b=40),
)


def _axis_style(**kw):
    return dict(gridcolor=_GRID_COLOR, zerolinecolor=_GRID_COLOR, showgrid=True, **kw)


def _3d_layout():
    base = {k: v for k, v in _LAYOUT_BASE.items() if k != 'margin'}
    base['margin'] = dict(l=0, r=0, t=40, b=0)
    return base


def _wrap_phi(R: ProcessedPattern, grid: np.ndarray):
    """Append phi=360 column so the seam closes — returns (phi_vec_w, grid_w)."""
    pv = R.phi_vec
    if pv[-1] < 359.9:
        pv_w    = np.append(pv, 360.0)
        grid_w  = np.concatenate([grid, grid[:, :1]], axis=1)
    else:
        pv_w, grid_w = pv, grid
    return pv_w, grid_w


def _cut_full360(R, cut_type, cut_value, component):
    """Return (angles, G_tot, G_R, G_L) for a full-360° cut.
    For Theta Cut: stitches forward (phi) + mirror (phi+180) halves.
    For Phi Cut:   just returns the standard phi sweep 0–360.
    """
    if cut_type == 'Theta Cut':
        a_f, Gt_f, Gr_f, Gl_f = get_cut(R, cut_type, cut_value)
        mirror = (cut_value + 180.0) % 360.0
        a_m, Gt_m, Gr_m, Gl_m = get_cut(R, cut_type, mirror)
        a_s   = 360.0 - a_m[::-1][1:]
        return (np.concatenate([a_f, a_s]),
                np.concatenate([Gt_f, Gt_m[::-1][1:]]),
                np.concatenate([Gr_f, Gr_m[::-1][1:]]),
                np.concatenate([Gl_f, Gl_m[::-1][1:]]))
    else:
        return get_cut(R, cut_type, cut_value)


def _xyz_axes(r_scale: float, colorX='#ff4444', colorY='#44ff44', colorZ='#4fc3f7'):
    """Return three Scatter3d traces for X, Y, Z principal axes."""
    axes = []
    for vec, col, lbl in [([r_scale, 0, 0], colorX, 'X'),
                           ([0, r_scale, 0], colorY, 'Y'),
                           ([0, 0, r_scale], colorZ, 'Z')]:
        axes.append(go.Scatter3d(
            x=[0, vec[0]], y=[0, vec[1]], z=[0, vec[2]],
            mode='lines+text',
            text=['', lbl],
            textfont=dict(color=col, size=12),
            textposition='top center',
            line=dict(color=col, width=4),
            showlegend=False, hoverinfo='skip',
        ))
    return axes


# ─────────────────────────────────────────────────────────────────────────────
# Contour (Heatmap) — phi (x) vs theta (y)
# ─────────────────────────────────────────────────────────────────────────────
def plot_contour(R: ProcessedPattern, component: str = 'Total Gain',
                 cmin: float = None, cmax: float = None,
                 show_peak: bool = True) -> go.Figure:
    grid, label = get_component_grid(R, component)
    if cmax is None: cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None: cmin = cmax - 50

    pv, gw = _wrap_phi(R, grid)   # close the phi=360 seam

    fig = go.Figure(go.Heatmap(
        x=pv, y=R.theta_vec, z=gw,
        zmin=cmin, zmax=cmax, colorscale=_COLORSCALE,
        colorbar=dict(title=label, tickfont=dict(color=_FONT_COLOR)),
        hovertemplate='φ=%{x:.1f}°<br>θ=%{y:.1f}°<br>' + label + '=%{z:.2f}<extra></extra>',
    ))

    if show_peak:
        fig.add_trace(go.Scatter(
            x=[R.max_gain_dir[1]], y=[R.max_gain_dir[0]],
            mode='markers+text',
            marker=dict(symbol='cross', size=12, color='white', line=dict(width=2)),
            text=[f'{R.max_gain_dB:.1f} dBi'], textposition='top right',
            textfont=dict(color='white', size=10),
            showlegend=False, name='Peak',
        ))

    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text=f'Contour — {label}', font=dict(color=_FONT_COLOR)),
        xaxis=_axis_style(
            title='φ (deg)',
            tickvals=list(range(0, 361, 30)),
            ticktext=[str(v) for v in range(0, 361, 30)],
            range=[0, 360],
        ),
        yaxis=_axis_style(
            title='θ (deg)',
            autorange='reversed',
            tickvals=list(range(0, 181, 15)),
            ticktext=[str(v) for v in range(0, 181, 15)],
            range=[180, 0],
        ),
    )
    return fig


# ─────────────────────────────────────────────────────────────────────────────
# Polar cut — single 1-D Scatterpolar trace
# ─────────────────────────────────────────────────────────────────────────────
def plot_polar_cut(R: ProcessedPattern, cut_type: str = 'Phi Cut',
                   cut_value: float = 0.0, component: str = 'Total Gain',
                   cmin: float = None, cmax: float = None,
                   show_hpbw: bool = False) -> go.Figure:
    if cmax is None: cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None: cmin = cmax - 50

    angles, G_tot, G_R, G_L = _cut_full360(R, cut_type, cut_value, component)
    comp_data = {'Total Gain': G_tot, 'RHCP Gain': G_R, 'LHCP Gain': G_L}
    G_plot    = comp_data.get(component, G_tot)
    r_vals    = np.clip(G_plot, cmin, cmax) - cmin

    tick_vals = list(range(0, int(cmax - cmin) + 10, 10))
    tick_text = [f'{v + cmin:.0f}' for v in tick_vals]

    fig = go.Figure(go.Scatterpolar(
        r=r_vals, theta=angles, mode='lines',
        line=dict(color='#4fc3f7', width=2), name=component,
        hovertemplate='%{theta:.1f}°: %{customdata:.2f} dB<extra></extra>',
        customdata=G_plot,
    ))
    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text=f'Polar Cut — {cut_type} @ {cut_value}°', font=dict(color=_FONT_COLOR)),
        polar=dict(
            bgcolor=_BG,
            angularaxis=dict(tickcolor=_FONT_COLOR, gridcolor=_GRID_COLOR,
                             direction='clockwise', rotation=90,
                             tickfont=dict(color=_FONT_COLOR)),
            radialaxis=dict(tickvals=tick_vals, ticktext=tick_text,
                            gridcolor=_GRID_COLOR, tickfont=dict(color=_FONT_COLOR),
                            range=[0, cmax - cmin]),
        ),
    )
    return fig


# ─────────────────────────────────────────────────────────────────────────────
# Rectangular cut
# ─────────────────────────────────────────────────────────────────────────────
def plot_rect_cut(R: ProcessedPattern, cut_type: str = 'Phi Cut',
                  cut_value: float = 0.0,
                  cmin: float = None, cmax: float = None,
                  show_hpbw: bool = True) -> go.Figure:
    if cmax is None: cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None: cmin = cmax - 50

    angles, G_tot, G_R, G_L = _cut_full360(R, cut_type, cut_value, 'Total Gain')
    x_label = ('θ (deg) — full 360° cut' if cut_type == 'Theta Cut'
                else 'φ (deg)')

    fig = go.Figure()
    for G, nm, col, dash in [(G_tot, 'Total', '#4fc3f7', 'solid'),
                              (G_R,   'RHCP',  '#ef5350', 'dash'),
                              (G_L,   'LHCP',  '#66bb6a', 'dot')]:
        fig.add_trace(go.Scatter(x=angles, y=G, mode='lines', name=nm,
                                 line=dict(color=col, width=2, dash=dash)))

    if show_hpbw and len(G_tot) > 2:
        half = float(G_tot.max()) - 3.0
        fig.add_hline(y=half, line=dict(color='white', dash='dot', width=1),
                      annotation_text='−3 dB', annotation_font_color='white')

    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text=f'Rect Cut — {cut_type} @ {cut_value}°', font=dict(color=_FONT_COLOR)),
        xaxis=_axis_style(title=x_label),
        yaxis=_axis_style(title='Gain (dB)', range=[cmin, cmax]),
        legend=dict(font=dict(color=_FONT_COLOR), bgcolor='rgba(0,0,0,0.3)'),
    )
    return fig


# ─────────────────────────────────────────────────────────────────────────────
# Filled Polar — filled version of a polar cut (single cut, full 360°)
# ─────────────────────────────────────────────────────────────────────────────
def plot_filled_polar(R: ProcessedPattern, component: str = 'Total Gain',
                      cut_type: str = 'Phi Cut', cut_value: float = 0.0,
                      cmin: float = None, cmax: float = None) -> go.Figure:
    if cmax is None: cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None: cmin = cmax - 50

    angles, G_tot, G_R, G_L = _cut_full360(R, cut_type, cut_value, component)
    comp_data = {'Total Gain': G_tot, 'RHCP Gain': G_R, 'LHCP Gain': G_L}
    G_plot    = comp_data.get(component, G_tot)
    r_vals    = np.clip(G_plot, cmin, cmax) - cmin

    # Close the polygon
    r_closed = np.append(r_vals, r_vals[0])
    a_closed = np.append(angles,  angles[0])

    tick_vals = list(range(0, int(cmax - cmin) + 10, 10))
    tick_text = [f'{v + cmin:.0f}' for v in tick_vals]

    fig = go.Figure()
    fig.add_trace(go.Scatterpolar(
        r=r_closed, theta=a_closed, mode='lines',
        fill='toself', fillcolor='rgba(79,195,247,0.22)',
        line=dict(color='#4fc3f7', width=2),
        name=component,
        hovertemplate='%{theta:.1f}°: %{customdata:.2f} dB<extra></extra>',
        customdata=np.append(G_plot, G_plot[0]),
    ))

    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text=f'Filled Polar — {cut_type} @ {cut_value}°', font=dict(color=_FONT_COLOR)),
        polar=dict(
            bgcolor=_BG,
            angularaxis=dict(tickcolor=_FONT_COLOR, gridcolor=_GRID_COLOR,
                             direction='clockwise', rotation=90,
                             tickfont=dict(color=_FONT_COLOR)),
            radialaxis=dict(tickvals=tick_vals, ticktext=tick_text,
                            gridcolor=_GRID_COLOR, tickfont=dict(color=_FONT_COLOR),
                            range=[0, cmax - cmin]),
        ),
    )
    return fig


# ─────────────────────────────────────────────────────────────────────────────
# 3-D Pattern — radius = gain
# ─────────────────────────────────────────────────────────────────────────────
def plot_3d_pattern(R: ProcessedPattern, component: str = 'Total Gain',
                    cmin: float = None, cmax: float = None) -> go.Figure:
    grid, label = get_component_grid(R, component)
    if cmax is None: cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None: cmin = cmax - 50

    pv, gw = _wrap_phi(R, grid)
    TH_deg, PH_deg = np.meshgrid(R.theta_vec, pv, indexing='ij')
    TH = np.deg2rad(TH_deg); PH = np.deg2rad(PH_deg)

    r = np.clip(gw, cmin, cmax) - cmin + 0.01
    X = r * np.sin(TH) * np.cos(PH)
    Y = r * np.sin(TH) * np.sin(PH)
    Z = r * np.cos(TH)

    r_max = float(r.max())
    hover_text = [
        [f'θ={TH_deg[i,j]:.1f}°  φ={PH_deg[i,j]:.1f}°  {label}={float(gw[i,j]):.2f}'
         for j in range(gw.shape[1])]
        for i in range(gw.shape[0])
    ]

    fig = go.Figure()
    fig.add_trace(go.Surface(
        x=X, y=Y, z=Z,
        surfacecolor=gw, cmin=cmin, cmax=cmax,
        colorscale=_COLORSCALE,
        colorbar=dict(title=label, tickfont=dict(color=_FONT_COLOR)),
        text=hover_text,
        hovertemplate='%{text}<extra></extra>',
    ))
    for ax in _xyz_axes(r_max * 1.25):
        fig.add_trace(ax)

    fig.update_layout(
        **_3d_layout(),
        title=dict(text=f'3D Pattern — {label}', font=dict(color=_FONT_COLOR)),
        scene=dict(
            xaxis=dict(showgrid=False, zeroline=False, showticklabels=False,
                       title='', showaxeslabels=False),
            yaxis=dict(showgrid=False, zeroline=False, showticklabels=False,
                       title='', showaxeslabels=False),
            zaxis=dict(showgrid=False, zeroline=False, showticklabels=False,
                       title='', showaxeslabels=False),
            bgcolor=_BG, aspectmode='data',
        ),
    )
    return fig


# ─────────────────────────────────────────────────────────────────────────────
# 3-D Spherical — unit sphere coloured by gain
# ─────────────────────────────────────────────────────────────────────────────
def plot_3d_sphere(R: ProcessedPattern, component: str = 'Total Gain',
                   cmin: float = None, cmax: float = None) -> go.Figure:
    grid, label = get_component_grid(R, component)
    if cmax is None: cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None: cmin = cmax - 50

    pv, gw = _wrap_phi(R, grid)
    TH_deg, PH_deg = np.meshgrid(R.theta_vec, pv, indexing='ij')
    TH = np.deg2rad(TH_deg); PH = np.deg2rad(PH_deg)

    X = np.sin(TH) * np.cos(PH)
    Y = np.sin(TH) * np.sin(PH)
    Z = np.cos(TH)

    hover_text = [
        [f'θ={TH_deg[i,j]:.1f}°  φ={PH_deg[i,j]:.1f}°  {label}={float(gw[i,j]):.2f}'
         for j in range(gw.shape[1])]
        for i in range(gw.shape[0])
    ]

    fig = go.Figure()
    fig.add_trace(go.Surface(
        x=X, y=Y, z=Z,
        surfacecolor=gw, cmin=cmin, cmax=cmax,
        colorscale=_COLORSCALE,
        colorbar=dict(title=label, tickfont=dict(color=_FONT_COLOR)),
        text=hover_text,
        hovertemplate='%{text}<extra></extra>',
    ))
    for ax in _xyz_axes(1.35):
        fig.add_trace(ax)

    fig.update_layout(
        **_3d_layout(),
        title=dict(text=f'3D Spherical — {label}', font=dict(color=_FONT_COLOR)),
        scene=dict(
            xaxis=dict(showgrid=False, zeroline=False, showticklabels=False,
                       title='', showaxeslabels=False),
            yaxis=dict(showgrid=False, zeroline=False, showticklabels=False,
                       title='', showaxeslabels=False),
            zaxis=dict(showgrid=False, zeroline=False, showticklabels=False,
                       title='', showaxeslabels=False),
            bgcolor=_BG, aspectmode='cube',
        ),
    )
    return fig


# backward-compat alias
def plot_3d_spherical(R, component='Total Gain', cmin=None, cmax=None):
    return plot_3d_pattern(R, component, cmin, cmax)


# ─────────────────────────────────────────────────────────────────────────────
# Circular (azimuthal equidistant) — phi=0 at top, clockwise
# x = θ·sin(φ),  y = θ·cos(φ)   →  φ=0 → top,  φ=90 → right  (CW)
# ─────────────────────────────────────────────────────────────────────────────
def plot_circular(R: ProcessedPattern, component: str = 'Total Gain',
                  cmin: float = None, cmax: float = None) -> go.Figure:
    grid, label = get_component_grid(R, component)
    if cmax is None: cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None: cmin = cmax - 50

    th_max = float(R.theta_vec.max())
    N = 400

    # Cartesian CW convention: x = θ·sin(φ),  y = θ·cos(φ)
    xi = np.linspace(-th_max, th_max, N)
    yi = np.linspace(-th_max, th_max, N)
    XI, YI = np.meshgrid(xi, yi)

    TH_i = np.sqrt(XI ** 2 + YI ** 2)
    # atan2(x, y) gives azimuth measured CW from +y (= north/top)
    PH_i = np.rad2deg(np.arctan2(XI, YI)) % 360.0

    # Interpolate on the regular (theta, phi) grid, seam-wrapped
    pv, gw = _wrap_phi(R, grid)
    interp = RegularGridInterpolator(
        (R.theta_vec, pv), gw,
        method='linear', bounds_error=False, fill_value=np.nan)

    pts  = np.column_stack([TH_i.ravel(), PH_i.ravel()])
    G_i  = interp(pts).reshape(N, N)
    G_i[TH_i > th_max] = np.nan

    fig = go.Figure(go.Heatmap(
        x=xi, y=yi, z=G_i,
        zmin=cmin, zmax=cmax, colorscale=_COLORSCALE,
        colorbar=dict(title=label, tickfont=dict(color=_FONT_COLOR)),
        hovertemplate='x=%{x:.1f}<br>y=%{y:.1f}<br>' + label + '=%{z:.2f}<extra></extra>',
    ))

    ph_ring = np.linspace(0, 2 * np.pi, 361)
    for thr_ring in [30, 60, 90, 120, 150, 180]:
        if thr_ring > th_max * 1.01: break
        # ring in CW coords: x=r*sin, y=r*cos
        fig.add_trace(go.Scatter(
            x=thr_ring * np.sin(ph_ring), y=thr_ring * np.cos(ph_ring),
            mode='lines', line=dict(color='rgba(255,255,255,0.18)', width=0.8),
            showlegend=False, hoverinfo='skip'))
        fig.add_annotation(x=0, y=thr_ring + 3, text=f'{thr_ring}°',
                           showarrow=False,
                           font=dict(color='rgba(255,255,255,0.55)', size=9))

    # Cardinal labels: phi=0 top, phi=90 right, phi=180 bottom, phi=270 left
    for ph_lbl, txt in [(0, 'φ=0°'), (90, 'φ=90°'), (180, 'φ=180°'), (270, 'φ=270°')]:
        r_lbl = th_max * 1.1
        fig.add_annotation(
            x=r_lbl * np.sin(np.deg2rad(ph_lbl)),
            y=r_lbl * np.cos(np.deg2rad(ph_lbl)),
            text=txt, showarrow=False,
            font=dict(color=_FONT_COLOR, size=9))

    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text=f'Circular (Azimuthal) — {label}', font=dict(color=_FONT_COLOR)),
        xaxis=_axis_style(title='θ·sin(φ)  [deg]', scaleanchor='y'),
        yaxis=_axis_style(title='θ·cos(φ)  [deg]'),
    )
    return fig


# ─────────────────────────────────────────────────────────────────────────────
# Coverage CDF
# ─────────────────────────────────────────────────────────────────────────────
def plot_coverage_cdf(thresholds, coverage_list: list, names: list) -> go.Figure:
    """thresholds: single ndarray or list of arrays; coverage_list: list of fraction arrays."""
    thr_list = [thresholds] * len(coverage_list) if isinstance(thresholds, np.ndarray) \
               else list(thresholds)

    colors = ['#4fc3f7', '#ef5350', '#66bb6a', '#ffa726', '#ab47bc',
              '#26c6da', '#d4e157', '#ff7043', '#78909c', '#ec407a']
    fig = go.Figure()
    for i, (thr, cov, nm) in enumerate(zip(thr_list, coverage_list, names)):
        fig.add_trace(go.Scatter(
            x=np.asarray(thr), y=np.asarray(cov) * 100,
            mode='lines', name=nm,
            line=dict(color=colors[i % len(colors)], width=2),
            hovertemplate='Thr=%{x:.1f} dBi<br>Coverage=%{y:.1f}%<extra></extra>',
        ))
    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text='Coverage vs Gain Threshold', font=dict(color=_FONT_COLOR)),
        xaxis=_axis_style(title='Gain Threshold (dBi)'),
        yaxis=_axis_style(title='Coverage (%)', range=[0, 100]),
        legend=dict(font=dict(color=_FONT_COLOR), bgcolor='rgba(0,0,0,0.3)'),
    )
    return fig


# ─────────────────────────────────────────────────────────────────────────────
# Batch summary bar
# ─────────────────────────────────────────────────────────────────────────────
def plot_batch_summary(names: list, peak_gains: list) -> go.Figure:
    fig = go.Figure(go.Bar(
        x=names, y=peak_gains, marker_color='#4fc3f7',
        hovertemplate='%{x}<br>Peak Gain=%{y:.2f} dBi<extra></extra>',
    ))
    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text='Batch — Peak Gain Summary', font=dict(color=_FONT_COLOR)),
        xaxis=_axis_style(title='Pattern', tickangle=-45),
        yaxis=_axis_style(title='Peak Gain (dBi)'),
    )
    return fig


# ─────────────────────────────────────────────────────────────────────────────
# Utility
# ─────────────────────────────────────────────────────────────────────────────
def auto_clim(max_gain_dB: float) -> Tuple[float, float]:
    cmax = float(np.ceil(max_gain_dB / 5) * 5)
    if cmax < max_gain_dB:
        cmax += 5
    return cmax - 50, cmax
