"""
Plotly figure builders for all APA plot types.
Contour, Polar Cut, Rect Cut, 3D Pattern, 3D Unit Sphere, Circular (azimuthal),
Filled Polar — all returning go.Figure objects for NiceGUI ui.plotly().
"""
import numpy as np
import plotly.graph_objects as go
from scipy.interpolate import RegularGridInterpolator
from typing import Optional, Tuple
from .processing import ProcessedPattern, get_component_grid, get_cut


_COLORSCALE = 'Jet'
_BG = '#1a1a2e'
_PAPER = '#16213e'
_FONT_COLOR = '#e0e0e0'
_GRID_COLOR = '#334466'

_LAYOUT_BASE = dict(
    paper_bgcolor=_PAPER,
    plot_bgcolor=_BG,
    font=dict(color=_FONT_COLOR, size=11),
    margin=dict(l=50, r=20, t=40, b=40),
)


def _axis_style(**kw):
    return dict(gridcolor=_GRID_COLOR, zerolinecolor=_GRID_COLOR,
                showgrid=True, **kw)


def _3d_layout_base():
    """_LAYOUT_BASE without margin, for 3-D scenes."""
    return {k: v for k, v in _LAYOUT_BASE.items() if k != 'margin'}


# ---------------------------------------------------------------------------
# Contour map: phi (x) vs theta (y), gain colour
# ---------------------------------------------------------------------------
def plot_contour(R: ProcessedPattern, component: str = 'Total Gain',
                 cmin: float = None, cmax: float = None,
                 show_peak: bool = True) -> go.Figure:
    grid, label = get_component_grid(R, component)
    if cmax is None:
        cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None:
        cmin = cmax - 50

    fig = go.Figure(go.Heatmap(
        x=R.phi_vec, y=R.theta_vec, z=grid,
        zmin=cmin, zmax=cmax,
        colorscale=_COLORSCALE,
        colorbar=dict(title=label, tickfont=dict(color=_FONT_COLOR)),
        hovertemplate='φ=%{x:.1f}°<br>θ=%{y:.1f}°<br>' + label + '=%{z:.2f}<extra></extra>',
    ))

    if show_peak:
        fig.add_trace(go.Scatter(
            x=[R.max_gain_dir[1]], y=[R.max_gain_dir[0]],
            mode='markers+text',
            marker=dict(symbol='cross', size=12, color='white', line=dict(width=2)),
            text=[f'{R.max_gain_dB:.1f} dBi'],
            textposition='top right',
            textfont=dict(color='white', size=10),
            showlegend=False, name='Peak',
        ))

    # Fixed ticks: phi 0–360 step 30, theta 0–180 step 15
    phi_ticks   = list(range(0, 361, 30))
    theta_ticks = list(range(0, 181, 15))

    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text=f'Contour — {label}', font=dict(color=_FONT_COLOR)),
        xaxis=_axis_style(
            title='φ (deg)',
            tickvals=phi_ticks,
            ticktext=[str(v) for v in phi_ticks],
            range=[0, 360],
        ),
        yaxis=_axis_style(
            title='θ (deg)',
            autorange='reversed',
            tickvals=theta_ticks,
            ticktext=[str(v) for v in theta_ticks],
            range=[180, 0],
        ),
    )
    return fig


# ---------------------------------------------------------------------------
# Polar cut: vary phi at fixed theta, or vary theta at fixed phi
# For Theta Cut, mirror the back side to create a full 360° cut.
# ---------------------------------------------------------------------------
def plot_polar_cut(R: ProcessedPattern, cut_type: str = 'Phi Cut',
                   cut_value: float = 0.0,
                   component: str = 'Total Gain',
                   cmin: float = None, cmax: float = None,
                   show_hpbw: bool = False) -> go.Figure:
    if cmax is None:
        cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None:
        cmin = cmax - 50

    comp_map_key = component

    if cut_type == 'Theta Cut':
        # Forward side: theta 0→180 at phi=cut_value
        angles_f, G_tot_f, G_R_f, G_L_f = get_cut(R, cut_type, cut_value)
        # Mirror side: theta 0→180 at phi=(cut_value+180)%360
        mirror_phi = (cut_value + 180.0) % 360.0
        angles_m, G_tot_m, G_R_m, G_L_m = get_cut(R, cut_type, mirror_phi)
        # Build full 360°: forward (0→180) then mirror reversed (180→360)
        # mirror reversed: theta 180→0 → polar angles 180→360
        ang_second  = 360.0 - angles_m[::-1][1:]
        angles  = np.concatenate([angles_f, ang_second])
        G_tot   = np.concatenate([G_tot_f, G_tot_m[::-1][1:]])
        G_R     = np.concatenate([G_R_f,   G_R_m[::-1][1:]])
        G_L     = np.concatenate([G_L_f,   G_L_m[::-1][1:]])
    else:
        angles, G_tot, G_R, G_L = get_cut(R, cut_type, cut_value)

    comp_data = {'Total Gain': G_tot, 'RHCP Gain': G_R, 'LHCP Gain': G_L}
    G_plot = comp_data.get(comp_map_key, G_tot)
    G_clipped = np.clip(G_plot, cmin, cmax)
    shift  = -cmin
    r_vals = G_clipped + shift

    fig = go.Figure()
    fig.add_trace(go.Scatterpolar(
        r=r_vals, theta=angles,
        mode='lines',
        line=dict(color='#4fc3f7', width=2),
        name=component,
        hovertemplate='%{theta:.1f}°: %{customdata:.2f} dB<extra></extra>',
        customdata=G_plot,
    ))

    tick_step = 10
    tick_vals = np.arange(0, (cmax - cmin) + tick_step, tick_step)
    tick_text = [f'{v + cmin:.0f}' for v in tick_vals]

    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text=f'Polar Cut — {cut_type} @ {cut_value}°', font=dict(color=_FONT_COLOR)),
        polar=dict(
            bgcolor=_BG,
            angularaxis=dict(tickcolor=_FONT_COLOR, gridcolor=_GRID_COLOR,
                             direction='clockwise', rotation=90,
                             tickfont=dict(color=_FONT_COLOR)),
            radialaxis=dict(tickvals=tick_vals.tolist(), ticktext=tick_text,
                            gridcolor=_GRID_COLOR,
                            tickfont=dict(color=_FONT_COLOR),
                            range=[0, cmax - cmin]),
        ),
    )
    return fig


# ---------------------------------------------------------------------------
# Rectangular cut: 1-D line plot — theta cut shows full 360° mirror
# ---------------------------------------------------------------------------
def plot_rect_cut(R: ProcessedPattern, cut_type: str = 'Phi Cut',
                  cut_value: float = 0.0,
                  cmin: float = None, cmax: float = None,
                  show_hpbw: bool = True) -> go.Figure:
    if cmax is None:
        cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None:
        cmin = cmax - 50

    if cut_type == 'Theta Cut':
        # Forward side
        angles_f, G_tot_f, G_R_f, G_L_f = get_cut(R, cut_type, cut_value)
        # Mirror side
        mirror_phi = (cut_value + 180.0) % 360.0
        angles_m, G_tot_m, G_R_m, G_L_m = get_cut(R, cut_type, mirror_phi)
        # Second half: theta going 180→0, angles 180→360
        ang_second = 360.0 - angles_m[::-1][1:]
        angles  = np.concatenate([angles_f, ang_second])
        G_tot   = np.concatenate([G_tot_f, G_tot_m[::-1][1:]])
        G_R     = np.concatenate([G_R_f,   G_R_m[::-1][1:]])
        G_L     = np.concatenate([G_L_f,   G_L_m[::-1][1:]])
        x_label = 'θ (deg) — full 360° cut'
    else:
        angles, G_tot, G_R, G_L = get_cut(R, cut_type, cut_value)
        x_label = 'φ (deg)' if cut_type == 'Phi Cut' else 'θ (deg)'

    fig = go.Figure()
    fig.add_trace(go.Scatter(x=angles, y=G_tot, mode='lines',
                             line=dict(color='#4fc3f7', width=2), name='Total'))
    fig.add_trace(go.Scatter(x=angles, y=G_R, mode='lines',
                             line=dict(color='#ef5350', width=1.5, dash='dash'), name='RHCP'))
    fig.add_trace(go.Scatter(x=angles, y=G_L, mode='lines',
                             line=dict(color='#66bb6a', width=1.5, dash='dot'), name='LHCP'))

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


# ---------------------------------------------------------------------------
# 3-D Antenna Pattern — radius = gain (shape shows radiation pattern)
# ---------------------------------------------------------------------------
def plot_3d_pattern(R: ProcessedPattern, component: str = 'Total Gain',
                    cmin: float = None, cmax: float = None) -> go.Figure:
    grid, label = get_component_grid(R, component)
    if cmax is None:
        cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None:
        cmin = cmax - 50

    TH_deg, PH_deg = np.meshgrid(R.theta_vec, R.phi_vec, indexing='ij')
    TH = np.deg2rad(TH_deg)
    PH = np.deg2rad(PH_deg)

    G_clipped = np.clip(grid, cmin, cmax)
    r = G_clipped - cmin + 0.01  # keep ≥ 0.01 so sphere doesn't collapse

    X = r * np.sin(TH) * np.cos(PH)
    Y = r * np.sin(TH) * np.sin(PH)
    Z = r * np.cos(TH)

    hover_text = np.array([
        [f'θ={TH_deg[i, j]:.1f}°  φ={PH_deg[i, j]:.1f}°  {label}={grid[i, j]:.2f}'
         for j in range(grid.shape[1])]
        for i in range(grid.shape[0])
    ])

    fig = go.Figure(go.Surface(
        x=X, y=Y, z=Z,
        surfacecolor=grid, cmin=cmin, cmax=cmax,
        colorscale=_COLORSCALE,
        colorbar=dict(title=label, tickfont=dict(color=_FONT_COLOR)),
        text=hover_text,
        hovertemplate='%{text}<extra></extra>',
    ))
    fig.update_layout(
        **_3d_layout_base(),
        title=dict(text=f'3D Pattern — {label}', font=dict(color=_FONT_COLOR)),
        scene=dict(
            xaxis=dict(showgrid=False, zeroline=False, showticklabels=False, title=''),
            yaxis=dict(showgrid=False, zeroline=False, showticklabels=False, title=''),
            zaxis=dict(showgrid=False, zeroline=False, showticklabels=False, title=''),
            bgcolor=_BG,
            aspectmode='data',
        ),
        margin=dict(l=0, r=0, t=40, b=0),
    )
    return fig


# ---------------------------------------------------------------------------
# 3-D Unit Sphere — projects pattern as colour on a unit sphere
# ---------------------------------------------------------------------------
def plot_3d_sphere(R: ProcessedPattern, component: str = 'Total Gain',
                   cmin: float = None, cmax: float = None) -> go.Figure:
    grid, label = get_component_grid(R, component)
    if cmax is None:
        cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None:
        cmin = cmax - 50

    TH_deg, PH_deg = np.meshgrid(R.theta_vec, R.phi_vec, indexing='ij')
    TH = np.deg2rad(TH_deg)
    PH = np.deg2rad(PH_deg)

    # Unit sphere
    X = np.sin(TH) * np.cos(PH)
    Y = np.sin(TH) * np.sin(PH)
    Z = np.cos(TH)

    hover_text = np.array([
        [f'θ={TH_deg[i, j]:.1f}°  φ={PH_deg[i, j]:.1f}°  {label}={grid[i, j]:.2f}'
         for j in range(grid.shape[1])]
        for i in range(grid.shape[0])
    ])

    fig = go.Figure(go.Surface(
        x=X, y=Y, z=Z,
        surfacecolor=grid, cmin=cmin, cmax=cmax,
        colorscale=_COLORSCALE,
        colorbar=dict(title=label, tickfont=dict(color=_FONT_COLOR)),
        text=hover_text,
        hovertemplate='%{text}<extra></extra>',
    ))
    fig.update_layout(
        **_3d_layout_base(),
        title=dict(text=f'3D Unit Sphere — {label}', font=dict(color=_FONT_COLOR)),
        scene=dict(
            xaxis=dict(showgrid=False, zeroline=False, showticklabels=False, title=''),
            yaxis=dict(showgrid=False, zeroline=False, showticklabels=False, title=''),
            zaxis=dict(showgrid=False, zeroline=False, showticklabels=False, title=''),
            bgcolor=_BG,
            aspectmode='cube',
        ),
        margin=dict(l=0, r=0, t=40, b=0),
    )
    return fig


# backward-compat alias
def plot_3d_spherical(R, component='Total Gain', cmin=None, cmax=None):
    return plot_3d_pattern(R, component, cmin, cmax)


# ---------------------------------------------------------------------------
# Circular (azimuthal equidistant) — polar projection where r=theta
# Uses RegularGridInterpolator → Heatmap for speed (no griddata crash).
# ---------------------------------------------------------------------------
def plot_circular(R: ProcessedPattern, component: str = 'Total Gain',
                  cmin: float = None, cmax: float = None) -> go.Figure:
    grid, label = get_component_grid(R, component)
    if cmax is None:
        cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None:
        cmin = cmax - 50

    th_max = float(R.theta_vec.max())
    N = 400  # Cartesian grid resolution

    # Cartesian axes (x = theta*cos(phi), y = theta*sin(phi))
    xi = np.linspace(-th_max, th_max, N)
    yi = np.linspace(-th_max, th_max, N)
    XI, YI = np.meshgrid(xi, yi)

    # Convert Cartesian → polar
    TH_i = np.sqrt(XI ** 2 + YI ** 2)
    PH_i = np.rad2deg(np.arctan2(YI, XI)) % 360.0  # [0, 360)

    # Fast bilinear interpolation on the regular (theta, phi) grid
    phi_vec_safe = R.phi_vec.copy()
    # Wrap phi so interpolator covers 0–360 seamlessly
    if phi_vec_safe[-1] < 359.9:
        phi_vec_safe = np.append(phi_vec_safe, 360.0)
        grid_wrap = np.concatenate([grid, grid[:, :1]], axis=1)
    else:
        grid_wrap = grid

    interp = RegularGridInterpolator(
        (R.theta_vec, phi_vec_safe), grid_wrap,
        method='linear', bounds_error=False, fill_value=np.nan)

    pts = np.column_stack([TH_i.ravel(), PH_i.ravel()])
    G_i = interp(pts).reshape(N, N)
    G_i[TH_i > th_max] = np.nan  # mask outside hemisphere

    fig = go.Figure(go.Heatmap(
        x=xi, y=yi, z=G_i,
        zmin=cmin, zmax=cmax,
        colorscale=_COLORSCALE,
        colorbar=dict(title=label, tickfont=dict(color=_FONT_COLOR)),
        hovertemplate='x=%{x:.1f}°<br>y=%{y:.1f}°<br>' + label + '=%{z:.2f}<extra></extra>',
    ))

    # Concentric theta rings + labels
    ph_ring = np.linspace(0, 2 * np.pi, 361)
    for thr_ring in [30, 60, 90, 120, 150, 180]:
        if thr_ring > th_max * 1.01:
            break
        fig.add_trace(go.Scatter(
            x=thr_ring * np.cos(ph_ring),
            y=thr_ring * np.sin(ph_ring),
            mode='lines',
            line=dict(color='rgba(255,255,255,0.18)', width=0.8),
            showlegend=False, hoverinfo='skip',
        ))
        fig.add_annotation(
            x=0, y=thr_ring + 3, text=f'{thr_ring}°',
            showarrow=False,
            font=dict(color='rgba(255,255,255,0.55)', size=9),
        )

    # Cardinal phi labels
    for ang_deg, txt in [(0, '0°'), (90, '90°'), (180, '180°'), (270, '270°')]:
        r_lbl = th_max * 1.08
        fig.add_annotation(
            x=r_lbl * np.cos(np.deg2rad(ang_deg)),
            y=r_lbl * np.sin(np.deg2rad(ang_deg)),
            text=txt, showarrow=False,
            font=dict(color=_FONT_COLOR, size=9),
        )

    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text=f'Circular (Azimuthal) — {label}', font=dict(color=_FONT_COLOR)),
        xaxis=_axis_style(title='x = θ·cos(φ)  [deg]', scaleanchor='y',
                          showticklabels=True),
        yaxis=_axis_style(title='y = θ·sin(φ)  [deg]', showticklabels=True),
    )
    return fig


# ---------------------------------------------------------------------------
# Filled polar (multiple phi cuts as fill traces)
# ---------------------------------------------------------------------------
def plot_filled_polar(R: ProcessedPattern, component: str = 'Total Gain',
                      cmin: float = None, cmax: float = None) -> go.Figure:
    grid, label = get_component_grid(R, component)
    if cmax is None:
        cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None:
        cmin = cmax - 50

    fig = go.Figure()
    n_traces = min(len(R.phi_vec), 36)
    step = max(1, len(R.phi_vec) // n_traces)
    cmap = _jet_colormap(n_traces)

    for i, k in enumerate(range(0, len(R.phi_vec), step)):
        ph = R.phi_vec[k]
        g = np.clip(grid[:, k], cmin, cmax) - cmin
        color = f'rgba({cmap[i][0]},{cmap[i][1]},{cmap[i][2]},0.6)'
        fig.add_trace(go.Scatterpolar(
            r=np.concatenate([[0], g, [0]]),
            theta=np.concatenate([[0], R.theta_vec, [0]]),
            mode='lines', fill='toself',
            fillcolor=color, line=dict(color=color, width=0.5),
            name=f'φ={ph:.0f}°', showlegend=(i < 6),
        ))

    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text=f'Filled Polar — {label}', font=dict(color=_FONT_COLOR)),
        polar=dict(
            bgcolor=_BG,
            angularaxis=dict(tickcolor=_FONT_COLOR, gridcolor=_GRID_COLOR,
                             tickfont=dict(color=_FONT_COLOR)),
            radialaxis=dict(gridcolor=_GRID_COLOR, tickfont=dict(color=_FONT_COLOR)),
        ),
        legend=dict(font=dict(color=_FONT_COLOR), bgcolor='rgba(0,0,0,0.3)'),
    )
    return fig


# ---------------------------------------------------------------------------
# Coverage CDF
# ---------------------------------------------------------------------------
def plot_coverage_cdf(thresholds, coverage_list: list,
                      names: list) -> go.Figure:
    """
    thresholds: a single np.ndarray (shared) or a list of arrays (one per pattern).
    coverage_list: list of arrays (fraction 0–1).
    names: list of str.
    """
    if isinstance(thresholds, np.ndarray):
        thr_list = [thresholds] * len(coverage_list)
    else:
        thr_list = list(thresholds)

    colors = ['#4fc3f7', '#ef5350', '#66bb6a', '#ffa726', '#ab47bc',
              '#26c6da', '#d4e157', '#ff7043', '#78909c', '#ec407a']
    fig = go.Figure()
    for i, (thr, cov, nm) in enumerate(zip(thr_list, coverage_list, names)):
        c = colors[i % len(colors)]
        fig.add_trace(go.Scatter(
            x=np.asarray(thr), y=np.asarray(cov) * 100,
            mode='lines', name=nm,
            line=dict(color=c, width=2),
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


# ---------------------------------------------------------------------------
# Batch summary bar chart
# ---------------------------------------------------------------------------
def plot_batch_summary(names: list, peak_gains: list) -> go.Figure:
    fig = go.Figure(go.Bar(
        x=names, y=peak_gains,
        marker_color='#4fc3f7',
        hovertemplate='%{x}<br>Peak Gain=%{y:.2f} dBi<extra></extra>',
    ))
    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text='Batch — Peak Gain Summary', font=dict(color=_FONT_COLOR)),
        xaxis=_axis_style(title='Pattern', tickangle=-45),
        yaxis=_axis_style(title='Peak Gain (dBi)'),
    )
    return fig


# ---------------------------------------------------------------------------
# Utility
# ---------------------------------------------------------------------------
def _jet_colormap(n: int) -> list:
    result = []
    for i in range(n):
        t = i / max(n - 1, 1)
        r = int(np.clip(1.5 - abs(4 * t - 3), 0, 1) * 255)
        g = int(np.clip(1.5 - abs(4 * t - 2), 0, 1) * 255)
        b = int(np.clip(1.5 - abs(4 * t - 1), 0, 1) * 255)
        result.append((r, g, b))
    return result


def auto_clim(max_gain_dB: float) -> Tuple[float, float]:
    cmax = float(np.ceil(max_gain_dB / 5) * 5)
    if cmax < max_gain_dB:
        cmax += 5
    return cmax - 50, cmax
