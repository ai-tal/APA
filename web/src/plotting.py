"""
Plotly figure builders for all APA plot types.
Contour, Polar Cut, Rect Cut, 3D Spherical, Circular (azimuthal),
Filled Polar — all returning go.Figure objects for NiceGUI ui.plotly().
"""
import numpy as np
import plotly.graph_objects as go
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
        hovertemplate='φ=%{x:.1f}°<br>θ=%{y:.1f}°<br>'+label+'=%{z:.2f}<extra></extra>',
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

    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text=f'Contour — {label}', font=dict(color=_FONT_COLOR)),
        xaxis=_axis_style(title='φ (deg)'),
        yaxis=_axis_style(title='θ (deg)', autorange='reversed'),
    )
    return fig


# ---------------------------------------------------------------------------
# Polar cut: vary phi at fixed theta, or vary theta at fixed phi
# ---------------------------------------------------------------------------
def plot_polar_cut(R: ProcessedPattern, cut_type: str = 'Phi Cut',
                   cut_value: float = 0.0,
                   component: str = 'Total Gain',
                   cmin: float = None, cmax: float = None,
                   show_hpbw: bool = False) -> go.Figure:
    angles, G_tot, G_R, G_L = get_cut(R, cut_type, cut_value)
    if cmax is None:
        cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None:
        cmin = cmax - 50

    comp_map = {'Total Gain': G_tot, 'RHCP Gain': G_R, 'LHCP Gain': G_L}
    G_plot = comp_map.get(component, G_tot)
    G_plot_clipped = np.clip(G_plot, cmin, cmax)
    # Shift to non-negative for polar radius
    shift = -cmin
    r_vals = G_plot_clipped + shift

    fig = go.Figure()
    fig.add_trace(go.Scatterpolar(
        r=r_vals, theta=angles,
        mode='lines',
        line=dict(color='#4fc3f7', width=2),
        name=component,
        hovertemplate='%{theta:.1f}°: %{customdata:.2f} dB<extra></extra>',
        customdata=G_plot,
    ))

    # Tick labels showing actual dB values
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
# Rectangular cut: 1-D line plot
# ---------------------------------------------------------------------------
def plot_rect_cut(R: ProcessedPattern, cut_type: str = 'Phi Cut',
                  cut_value: float = 0.0,
                  cmin: float = None, cmax: float = None,
                  show_hpbw: bool = True) -> go.Figure:
    angles, G_tot, G_R, G_L = get_cut(R, cut_type, cut_value)
    if cmax is None:
        cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None:
        cmin = cmax - 50

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
# 3-D spherical surface — radius = gain (linear re-scaled)
# ---------------------------------------------------------------------------
def plot_3d_spherical(R: ProcessedPattern, component: str = 'Total Gain',
                      cmin: float = None, cmax: float = None) -> go.Figure:
    grid, label = get_component_grid(R, component)
    if cmax is None:
        cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None:
        cmin = cmax - 50

    TH_deg, PH_deg = np.meshgrid(R.theta_vec, R.phi_vec, indexing='ij')
    TH = np.deg2rad(TH_deg); PH = np.deg2rad(PH_deg)

    # Radius = normalised gain (linear, shifted to ≥0)
    G_clipped = np.clip(grid, cmin, cmax)
    r = G_clipped - cmin + 0.01  # ≥0.01 so sphere doesn't collapse

    X = r * np.sin(TH) * np.cos(PH)
    Y = r * np.sin(TH) * np.sin(PH)
    Z = r * np.cos(TH)

    fig = go.Figure(go.Surface(
        x=X, y=Y, z=Z,
        surfacecolor=grid, cmin=cmin, cmax=cmax,
        colorscale=_COLORSCALE,
        colorbar=dict(title=label, tickfont=dict(color=_FONT_COLOR)),
        hovertemplate='θ=%{customdata[0]:.1f}°<br>φ=%{customdata[1]:.1f}°<br>'+label+'=%{surfacecolor:.2f}<extra></extra>',
        customdata=np.stack([TH_deg, PH_deg], axis=-1),
    ))
    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text=f'3D Spherical — {label}', font=dict(color=_FONT_COLOR)),
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
# Circular (azimuthal equidistant) — polar projection where r=theta
# ---------------------------------------------------------------------------
def plot_circular(R: ProcessedPattern, component: str = 'Total Gain',
                  cmin: float = None, cmax: float = None) -> go.Figure:
    grid, label = get_component_grid(R, component)
    if cmax is None:
        cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None:
        cmin = cmax - 50

    TH_deg, PH_deg = np.meshgrid(R.theta_vec, R.phi_vec, indexing='ij')
    PH = np.deg2rad(PH_deg)
    r = TH_deg  # radius = theta

    X = r * np.cos(PH)
    Y = r * np.sin(PH)

    fig = go.Figure(go.Contour(
        x=X.ravel(), y=Y.ravel(), z=grid.ravel(),
        zmin=cmin, zmax=cmax,
        colorscale=_COLORSCALE,
        colorbar=dict(title=label, tickfont=dict(color=_FONT_COLOR)),
        contours=dict(coloring='heatmap'),
        line_smoothing=0.85,
        ncontours=30,
    ))

    # Concentric theta rings
    for thr in [30, 60, 90, 120, 150]:
        ph_ring = np.linspace(0, 2*np.pi, 200)
        fig.add_trace(go.Scatter(x=thr*np.cos(ph_ring), y=thr*np.sin(ph_ring),
                                 mode='lines', line=dict(color='rgba(255,255,255,0.15)', width=0.8),
                                 showlegend=False, hoverinfo='skip'))
        fig.add_annotation(x=0, y=thr, text=f'{thr}°',
                           showarrow=False, font=dict(color='rgba(255,255,255,0.5)', size=9))

    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text=f'Circular — {label}', font=dict(color=_FONT_COLOR)),
        xaxis=_axis_style(title='', scaleanchor='y', showticklabels=False),
        yaxis=_axis_style(title='', showticklabels=False),
    )
    return fig


# ---------------------------------------------------------------------------
# Filled polar (theta vs phi as bar-like fill)
# ---------------------------------------------------------------------------
def plot_filled_polar(R: ProcessedPattern, component: str = 'Total Gain',
                      cmin: float = None, cmax: float = None) -> go.Figure:
    grid, label = get_component_grid(R, component)
    if cmax is None:
        cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None:
        cmin = cmax - 50

    # Plot multiple phi cuts as filled polar traces
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
def plot_coverage_cdf(thresholds: np.ndarray, coverage_list: list,
                      names: list) -> go.Figure:
    colors = ['#4fc3f7', '#ef5350', '#66bb6a', '#ffa726', '#ab47bc',
              '#26c6da', '#d4e157', '#ff7043', '#78909c', '#ec407a']
    fig = go.Figure()
    for i, (thr, cov, nm) in enumerate(zip(
            [thresholds]*len(coverage_list), coverage_list, names)):
        c = colors[i % len(colors)]
        fig.add_trace(go.Scatter(
            x=thr, y=cov * 100,
            mode='lines', name=nm,
            line=dict(color=c, width=2),
            hovertemplate='Thr=%{x:.1f} dB<br>Coverage=%{y:.1f}%<extra></extra>',
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
    """Return n RGB tuples approximating the Jet colormap."""
    result = []
    for i in range(n):
        t = i / max(n - 1, 1)
        r = int(np.clip(1.5 - abs(4*t - 3), 0, 1) * 255)
        g = int(np.clip(1.5 - abs(4*t - 2), 0, 1) * 255)
        b = int(np.clip(1.5 - abs(4*t - 1), 0, 1) * 255)
        result.append((r, g, b))
    return result


def auto_clim(max_gain_dB: float) -> Tuple[float, float]:
    cmax = float(np.ceil(max_gain_dB / 5) * 5)
    if cmax < max_gain_dB:
        cmax += 5
    return cmax - 50, cmax
