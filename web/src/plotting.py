"""
Plotly figure builders for all APA plot types.
"""
import numpy as np
import plotly.graph_objects as go
from scipy.interpolate import RegularGridInterpolator
from typing import Tuple
from .processing import ProcessedPattern, get_component_grid, get_cut


_COLORSCALE = 'Jet'
_BG         = '#ffffff'
_PAPER      = '#f5f7fa'
_FONT_COLOR = '#24292f'
_GRID_COLOR = '#c0c8d8'

# Fixed per-component colours (Total=blue, RHCP=red, LHCP=green) — preserved across all cut plots
_COMP_STYLES = {
    'Total Gain': dict(color='#4fc3f7', dash='solid', short='Total'),
    'RHCP Gain':  dict(color='#ef5350', dash='dash',  short='RHCP'),
    'LHCP Gain':  dict(color='#66bb6a', dash='dot',   short='LHCP'),
}
_ALL_COMPS = ['Total Gain', 'RHCP Gain', 'LHCP Gain']

_LAYOUT_BASE = dict(
    paper_bgcolor=_PAPER,
    plot_bgcolor=_BG,
    font=dict(color=_FONT_COLOR, size=11),
    margin=dict(l=50, r=20, t=40, b=40),
)


def set_plot_theme(dark: bool) -> None:
    """Switch all subsequent plot builds to dark or light palette."""
    global _BG, _PAPER, _FONT_COLOR, _GRID_COLOR
    if dark:
        _BG = '#1a1a2e'; _PAPER = '#16213e'
        _FONT_COLOR = '#e0e0e0'; _GRID_COLOR = '#334466'
    else:
        _BG = '#ffffff'; _PAPER = '#f5f7fa'
        _FONT_COLOR = '#24292f'; _GRID_COLOR = '#c0c8d8'
    _LAYOUT_BASE.update(
        paper_bgcolor=_PAPER,
        plot_bgcolor=_BG,
        font=dict(color=_FONT_COLOR, size=11),
    )


def _ar_colorscale(N: int = 64) -> list:
    """OriginPro-style Red-White-Blue thermometer colorscale for Axial Ratio.
    Replicates MATLAB:
      [N*ones(1,N), N:-1:0; 0:N-1, N:-1:0; 0:N, N*ones(1,N)].' / N
    Red(1,0,0) at index 0 → White(1,1,1) at midpoint → Blue(0,0,1) at end.
    """
    R_v = np.concatenate([np.full(N, N), np.arange(N, -1, -1)]).astype(float) / N
    G_v = np.concatenate([np.arange(N),  np.arange(N, -1, -1)]).astype(float) / N
    B_v = np.concatenate([np.arange(N + 1), np.full(N, N)]).astype(float)    / N
    pos = np.linspace(0.0, 1.0, 2 * N + 1)
    return [[float(pos[i]),
             f'rgb({int(R_v[i]*255)},{int(G_v[i]*255)},{int(B_v[i]*255)})']
            for i in range(2 * N + 1)]


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


def _cut_full360(R, cut_type, cut_value, component='Total Gain'):
    """Return (angles, G_tot, G_R, G_L) for a full-360° cut, loop-closed.
    Theta Cut: stitches forward (phi=cut_value) + mirror (phi=cut_value+180) halves.
    Phi Cut:   full phi sweep 0-360° at fixed theta=cut_value, seam closed.
    """
    if cut_type == 'Theta Cut':
        a_f, Gt_f, Gr_f, Gl_f = get_cut(R, cut_type, cut_value)
        mirror = (cut_value + 180.0) % 360.0
        a_m, Gt_m, Gr_m, Gl_m = get_cut(R, cut_type, mirror)
        a_s = 360.0 - a_m[::-1][1:]
        angles = np.concatenate([a_f, a_s])
        Gt = np.concatenate([Gt_f, Gt_m[::-1][1:]])
        Gr = np.concatenate([Gr_f, Gr_m[::-1][1:]])
        Gl = np.concatenate([Gl_f, Gl_m[::-1][1:]])
    else:
        angles, Gt, Gr, Gl = get_cut(R, cut_type, cut_value)

    # Close the loop: append first point at 360° if not already at 360
    if len(angles) > 1 and angles[0] < 5.0 and angles[-1] < 359.5:
        angles = np.append(angles, 360.0)
        Gt = np.append(Gt, Gt[0])
        Gr = np.append(Gr, Gr[0])
        Gl = np.append(Gl, Gl[0])
    return angles, Gt, Gr, Gl


def _find_hpbw_crossings(angles: np.ndarray, G: np.ndarray):
    """Return (crossings, r_cross) where crossings are angles at G_max−3 dB."""
    if len(G) < 3:
        return [], []
    peak = float(G.max())
    half = peak - 3.0
    crossings, r_cross = [], []
    for i in range(len(angles) - 1):
        g0, g1 = float(G[i]), float(G[i + 1])
        if (g0 >= half) != (g1 >= half):
            frac = (half - g0) / (g1 - g0 + 1e-30)
            crossings.append(float(angles[i]) + frac * float(angles[i + 1] - angles[i]))
            r_cross.append(half)
    return crossings, r_cross


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
def _ar_clim(grid):
    """Auto Cmin/Cmax for Axial Ratio: always starts at 0, ceiling at next 5."""
    raw_max = float(np.nanmax(grid))
    cmax = float(np.ceil(max(raw_max, 1.0) / 5) * 5)
    return 0.0, cmax


def plot_contour(R: ProcessedPattern, component: str = 'Total Gain',
                 cmin: float = None, cmax: float = None,
                 show_peak: bool = True) -> go.Figure:
    grid, label = get_component_grid(R, component)
    if component == 'Axial Ratio':
        if cmin is None or cmax is None:
            _c0, _c1 = _ar_clim(grid)
            if cmin is None: cmin = _c0
            if cmax is None: cmax = _c1
    else:
        if cmax is None: cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
        if cmin is None: cmin = cmax - 50

    pv, gw = _wrap_phi(R, grid)

    cs = _ar_colorscale() if component == 'Axial Ratio' else _COLORSCALE
    fig = go.Figure(go.Heatmap(
        x=pv, y=R.theta_vec, z=gw,
        zmin=cmin, zmax=cmax, colorscale=cs,
        colorbar=dict(title=label, tickfont=dict(color=_FONT_COLOR)),
        hovertemplate='φ=%{x:.1f}°  θ=%{y:.1f}°  ' + label + '=%{z:.2f}<extra></extra>',
    ))

    if show_peak:
        fig.add_trace(go.Scatter(
            x=[R.max_gain_dir[1]], y=[R.max_gain_dir[0]],
            mode='markers+text',
            marker=dict(symbol='cross', size=12, color=_FONT_COLOR, line=dict(width=2)),
            text=[f'{R.max_gain_dB:.1f} dBi'], textposition='top right',
            textfont=dict(color=_FONT_COLOR, size=10),
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
# Polar cut — supports single component, list of components, or 'All'
# ─────────────────────────────────────────────────────────────────────────────
def _resolve_comps(component):
    """Normalise component arg → list of component name strings."""
    if component == 'All' or component is None:
        return _ALL_COMPS
    if isinstance(component, (list, tuple)):
        comps = [c for c in _ALL_COMPS if c in component]
        return comps if comps else _ALL_COMPS
    return [component] if component in _COMP_STYLES else _ALL_COMPS


def plot_polar_cut(R: ProcessedPattern, cut_type: str = 'Phi Cut',
                   cut_value: float = 0.0, component='Total Gain',
                   cmin: float = None, cmax: float = None,
                   show_hpbw: bool = False) -> go.Figure:
    if cmax is None: cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None: cmin = cmax - 50

    angles, G_tot, G_R, G_L = _cut_full360(R, cut_type, cut_value, 'Total Gain')
    comp_data = {'Total Gain': G_tot, 'RHCP Gain': G_R, 'LHCP Gain': G_L}
    shift     = -cmin
    tick_max  = int(cmax - cmin) + 10
    tick_vals = list(range(0, tick_max, 10))
    tick_text = [f'{v + cmin:.0f}' for v in tick_vals]
    comps     = _resolve_comps(component)

    fig = go.Figure()
    for comp_name in comps:
        st  = _COMP_STYLES[comp_name]
        G   = comp_data[comp_name]
        r_v = np.clip(G, cmin, cmax) + shift
        fig.add_trace(go.Scatterpolar(
            r=r_v, theta=angles, mode='lines',
            line=dict(color=st['color'], width=2), name=st['short'],
            hovertemplate='%{theta:.1f}°: %{customdata:.2f} dB<extra></extra>',
            customdata=G,
        ))

    G_plot = comp_data.get(comps[0], G_tot)   # first selected for HPBW

    if show_hpbw:
        crossings, _ = _find_hpbw_crossings(angles, G_plot)
        r_hpbw = float(np.clip(G_plot.max() - 3.0, cmin, cmax)) + shift
        for ang in crossings:
            fig.add_trace(go.Scatterpolar(
                r=[0, r_hpbw], theta=[ang, ang],
                mode='lines',
                line=dict(color='#ffd600', dash='dash', width=1.5),
                showlegend=False, hoverinfo='skip',
            ))
        if len(crossings) >= 2:
            hpbw_val = abs(crossings[1] - crossings[0])
            if hpbw_val > 180: hpbw_val = 360 - hpbw_val
            fig.add_annotation(
                text=f'HPBW ≈ {hpbw_val:.1f}°',
                xref='paper', yref='paper', x=0.5, y=1.04,
                showarrow=False, font=dict(color='#ffd600', size=11))

    comp_label = '+'.join(_COMP_STYLES[c]['short'] for c in comps)
    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text=f'Polar Cut — {cut_type} @ {cut_value:.1f}°  [{comp_label}]',
                   font=dict(color=_FONT_COLOR)),
        polar=dict(
            bgcolor=_BG,
            angularaxis=dict(tickcolor=_FONT_COLOR, gridcolor=_GRID_COLOR,
                             direction='clockwise', rotation=90,
                             tickfont=dict(color=_FONT_COLOR)),
            radialaxis=dict(tickvals=tick_vals, ticktext=tick_text,
                            gridcolor=_GRID_COLOR, tickfont=dict(color=_FONT_COLOR),
                            range=[0, cmax - cmin]),
        ),
        showlegend=(len(comps) > 1),
        legend=dict(font=dict(color=_FONT_COLOR), bgcolor='rgba(0,0,0,0.3)'),
    )
    return fig


# ─────────────────────────────────────────────────────────────────────────────
# Rectangular cut — supports single component, list, or 'All'
# ─────────────────────────────────────────────────────────────────────────────
def plot_rect_cut(R: ProcessedPattern, cut_type: str = 'Phi Cut',
                  cut_value: float = 0.0, component='All',
                  cmin: float = None, cmax: float = None,
                  show_hpbw: bool = False) -> go.Figure:
    if cmax is None: cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None: cmin = cmax - 50

    angles, G_tot, G_R, G_L = _cut_full360(R, cut_type, cut_value, 'Total Gain')
    comp_data = {'Total Gain': G_tot, 'RHCP Gain': G_R, 'LHCP Gain': G_L}
    x_label   = ('θ (deg) — full 360° cut' if cut_type == 'Theta Cut' else 'φ (deg)')
    comps     = _resolve_comps(component)

    fig = go.Figure()
    for comp_name in comps:
        st = _COMP_STYLES[comp_name]
        G  = comp_data[comp_name]
        fig.add_trace(go.Scatter(
            x=angles, y=G, mode='lines', name=st['short'],
            line=dict(color=st['color'], width=2, dash=st['dash']),
        ))

    if show_hpbw and len(G_tot) > 2:
        G_ref = comp_data.get(comps[0], G_tot)
        peak  = float(G_ref.max())
        half  = peak - 3.0
        fig.add_hline(y=half, line=dict(color='#ffd600', dash='dot', width=1.5),
                      annotation_text='−3 dB', annotation_font_color='#ffd600')
        crossings, _ = _find_hpbw_crossings(angles, G_ref)
        for ang in crossings:
            fig.add_vline(x=ang, line=dict(color='#ffd600', dash='dash', width=1.2))
        if len(crossings) >= 2:
            hpbw_val = abs(crossings[1] - crossings[0])
            if hpbw_val > 180: hpbw_val = 360 - hpbw_val
            fig.add_annotation(
                text=f'HPBW ≈ {hpbw_val:.1f}°',
                xref='paper', yref='paper', x=0.5, y=1.05,
                showarrow=False, font=dict(color='#ffd600', size=11))

    comp_label = '+'.join(_COMP_STYLES[c]['short'] for c in comps)
    _ticks30 = list(range(0, 361, 30))
    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text=f'Rect Cut — {cut_type} @ {cut_value:.1f}°  [{comp_label}]',
                   font=dict(color=_FONT_COLOR)),
        xaxis=_axis_style(
            title=x_label,
            range=[0, 360],
            tickvals=_ticks30,
            ticktext=[str(v) for v in _ticks30],
        ),
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
    """Balanis-style filled polar: interior colored by gain, like a 2-D pattern filled
    with a Jet colormap (blue=low, red=high), outline drawn on top."""
    if component == 'Axial Ratio':
        grid_ar, _ = get_component_grid(R, component)
        if cmin is None or cmax is None:
            _c0, _c1 = _ar_clim(grid_ar)
            if cmin is None: cmin = _c0
            if cmax is None: cmax = _c1
    else:
        if cmax is None: cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
        if cmin is None: cmin = cmax - 50

    angles, G_tot, G_R, G_L = _cut_full360(R, cut_type, cut_value, component)
    comp_data = {'Total Gain': G_tot, 'RHCP Gain': G_R, 'LHCP Gain': G_L}
    G_plot = comp_data.get(component, G_tot)

    # ── Build Cartesian raster: color(x,y) = G(phi) if inside pattern, else NaN ──
    N = 500
    G_clipped = np.clip(G_plot, cmin, cmax) - cmin       # radius in [0, cmax-cmin]
    r_max = float(G_clipped.max()) + 1e-6

    xi = np.linspace(-r_max, r_max, N)
    yi = np.linspace(-r_max, r_max, N)
    XI, YI = np.meshgrid(xi, yi)

    # Angle at each pixel (phi from top, clockwise — matches polar convention)
    A_pix = np.rad2deg(np.arctan2(XI, YI)) % 360.0      # 0° = top, 90° = right
    R_pix = np.sqrt(XI**2 + YI**2)                       # radial distance

    # Interpolate pattern boundary and gain onto pixel angles
    # Wrap for continuous interpolation across 0°/360°
    ang_wrap = np.concatenate([angles - 360, angles, angles + 360])
    G_wrap   = np.concatenate([G_clipped, G_clipped, G_clipped])
    from scipy.interpolate import interp1d
    boundary_fn = interp1d(ang_wrap, G_wrap, kind='linear',
                            bounds_error=False, fill_value=0.0)
    G_boundary = boundary_fn(A_pix)                       # radius of pattern at each pixel angle

    # dB value at each pixel = G(phi) for pixels inside the pattern boundary
    G_val = np.where(R_pix <= G_boundary, boundary_fn(A_pix) + cmin, np.nan)

    # ── Colorscale: AR uses Red-White-Blue thermometer; others use Jet ──
    if component == 'Axial Ratio':
        colorscale = _ar_colorscale()
    else:
        def _jet_rgba(val, vmin, vmax):
            t = np.clip((val - vmin) / max(vmax - vmin, 1e-6), 0.0, 1.0)
            r = np.clip(1.5 - np.abs(4.0*t - 3.0), 0.0, 1.0)
            g = np.clip(1.5 - np.abs(4.0*t - 2.0), 0.0, 1.0)
            b = np.clip(1.5 - np.abs(4.0*t - 1.0), 0.0, 1.0)
            return np.stack([r, g, b], axis=-1)
        n_cs = 64
        t_arr = np.linspace(0, 1, n_cs)
        cs_rgb = _jet_rgba(t_arr, 0.0, 1.0)
        colorscale = [[float(t_arr[i]),
                       f'rgb({int(cs_rgb[i,0]*255)},{int(cs_rgb[i,1]*255)},{int(cs_rgb[i,2]*255)})']
                      for i in range(n_cs)]

    fig = go.Figure()

    # Heatmap — the colored fill
    fig.add_trace(go.Heatmap(
        x=xi, y=yi, z=G_val,
        zmin=cmin, zmax=cmax,
        colorscale=colorscale,
        zsmooth='best',
        colorbar=dict(
            title=dict(text=f'{component} (dB)', font=dict(color=_FONT_COLOR)),
            tickfont=dict(color=_FONT_COLOR),
        ),
        hovertemplate='φ=%{customdata:.1f}°<br>' + component + '=%{z:.2f} dB<extra></extra>',
        customdata=A_pix,
        showscale=True,
    ))

    # Outline — the exact pattern boundary (theme-aware line on top)
    ang_rad = np.deg2rad(angles)
    x_bnd = G_clipped * np.sin(ang_rad)
    y_bnd = G_clipped * np.cos(ang_rad)
    x_bnd = np.append(x_bnd, x_bnd[0])
    y_bnd = np.append(y_bnd, y_bnd[0])
    G_hover = np.append(G_plot, G_plot[0])
    ang_hover = np.append(angles, angles[0])
    fig.add_trace(go.Scatter(
        x=x_bnd, y=y_bnd,
        mode='lines',
        line=dict(color=_FONT_COLOR, width=1.5),
        name='Boundary',
        customdata=np.stack([ang_hover, G_hover], axis=-1),
        hovertemplate='φ=%{customdata[0]:.1f}°<br>' + component + '=%{customdata[1]:.2f} dB<extra></extra>',
        showlegend=False,
    ))

    # Concentric dB rings
    ring_r = np.linspace(0, 2*np.pi, 361)
    for db_val in range(int(cmin), int(cmax)+1, 10):
        rr = db_val - cmin
        if rr <= 0: continue
        fig.add_trace(go.Scatter(
            x=rr * np.sin(ring_r), y=rr * np.cos(ring_r),
            mode='lines', line=dict(color=_GRID_COLOR, width=0.7),
            showlegend=False, hoverinfo='skip'))
        if rr <= r_max:
            fig.add_annotation(x=rr * 0.04, y=rr,
                               text=f'{db_val}dB', showarrow=False,
                               font=dict(color=_GRID_COLOR, size=7))

    # Phi angle labels
    lbl_r = r_max * 1.10
    for ph_d in range(0, 360, 30):
        ph_r = np.deg2rad(ph_d)
        fig.add_annotation(x=lbl_r * np.sin(ph_r), y=lbl_r * np.cos(ph_r),
                           text=f'{ph_d}°', showarrow=False,
                           font=dict(color=_FONT_COLOR, size=9))

    _ax_bare = dict(gridcolor=_GRID_COLOR, zerolinecolor=_GRID_COLOR,
                    showgrid=False, zeroline=False, showticklabels=False, title='')
    pad = r_max * 1.18
    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text=f'Filled Polar — {cut_type} @ {cut_value:.1f}°  [{component}]',
                   font=dict(color=_FONT_COLOR)),
        xaxis={**_ax_bare, 'scaleanchor': 'y', 'range': [-pad, pad]},
        yaxis={**_ax_bare, 'range': [-pad, pad]},
    )
    return fig


# ─────────────────────────────────────────────────────────────────────────────
# 3-D Pattern — radius = gain
# ─────────────────────────────────────────────────────────────────────────────
def plot_3d_pattern(R: ProcessedPattern, component: str = 'Total Gain',
                    cmin: float = None, cmax: float = None) -> go.Figure:
    grid, label = get_component_grid(R, component)
    if component == 'Axial Ratio':
        if cmin is None or cmax is None:
            _c0, _c1 = _ar_clim(grid)
            if cmin is None: cmin = _c0
            if cmax is None: cmax = _c1
    else:
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
    # customdata shape (nTh, nPh, 3): [theta_deg, phi_deg, gain_dB]
    cd = np.stack([TH_deg, PH_deg, gw], axis=-1)

    _no_axis = dict(showgrid=False, zeroline=False, showticklabels=False,
                    title='', showaxeslabels=False, showbackground=False,
                    showspikes=False)

    fig = go.Figure()
    cs3d = _ar_colorscale() if component == 'Axial Ratio' else _COLORSCALE
    fig.add_trace(go.Surface(
        x=X, y=Y, z=Z,
        surfacecolor=gw, cmin=cmin, cmax=cmax,
        colorscale=cs3d,
        colorbar=dict(title=label, tickfont=dict(color=_FONT_COLOR)),
        customdata=cd,
        hovertemplate=(
            'θ=%{customdata[0]:.1f}°  φ=%{customdata[1]:.1f}°<br>'
            + label + '=%{customdata[2]:.2f}<extra></extra>'
        ),
    ))
    for ax in _xyz_axes(r_max * 1.25):
        fig.add_trace(ax)

    fig.update_layout(
        **_3d_layout(),
        title=dict(text=f'3D Pattern — {label}', font=dict(color=_FONT_COLOR)),
        scene=dict(
            xaxis=_no_axis, yaxis=_no_axis, zaxis=_no_axis,
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
    if component == 'Axial Ratio':
        if cmin is None or cmax is None:
            _c0, _c1 = _ar_clim(grid)
            if cmin is None: cmin = _c0
            if cmax is None: cmax = _c1
    else:
        if cmax is None: cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
        if cmin is None: cmin = cmax - 50

    pv, gw = _wrap_phi(R, grid)
    TH_deg, PH_deg = np.meshgrid(R.theta_vec, pv, indexing='ij')
    TH = np.deg2rad(TH_deg); PH = np.deg2rad(PH_deg)

    X = np.sin(TH) * np.cos(PH)
    Y = np.sin(TH) * np.sin(PH)
    Z = np.cos(TH)

    cd = np.stack([TH_deg, PH_deg, gw], axis=-1)

    _no_axis = dict(showgrid=False, zeroline=False, showticklabels=False,
                    title='', showaxeslabels=False, showbackground=False,
                    showspikes=False)

    cs_sph = _ar_colorscale() if component == 'Axial Ratio' else _COLORSCALE
    fig = go.Figure()
    fig.add_trace(go.Surface(
        x=X, y=Y, z=Z,
        surfacecolor=gw, cmin=cmin, cmax=cmax,
        colorscale=cs_sph,
        colorbar=dict(title=label, tickfont=dict(color=_FONT_COLOR)),
        customdata=cd,
        hovertemplate=(
            'θ=%{customdata[0]:.1f}°  φ=%{customdata[1]:.1f}°<br>'
            + label + '=%{customdata[2]:.2f}<extra></extra>'
        ),
    ))
    for ax in _xyz_axes(1.35):
        fig.add_trace(ax)

    fig.update_layout(
        **_3d_layout(),
        title=dict(text=f'3D Spherical — {label}', font=dict(color=_FONT_COLOR)),
        scene=dict(
            xaxis=_no_axis, yaxis=_no_axis, zaxis=_no_axis,
            bgcolor=_BG, aspectmode='cube',
        ),
    )
    return fig


# ─────────────────────────────────────────────────────────────────────────────
# Circular (azimuthal equidistant) — φ=0 at top, clockwise
# x = θ·sin(φ),  y = θ·cos(φ)
# ─────────────────────────────────────────────────────────────────────────────
def plot_circular(R: ProcessedPattern, component: str = 'Total Gain',
                  cmin: float = None, cmax: float = None) -> go.Figure:
    grid, label = get_component_grid(R, component)
    if cmax is None: cmax = float(np.ceil(R.max_gain_dB / 5) * 5)
    if cmin is None: cmin = cmax - 50

    th_max = float(R.theta_vec.max())
    N = 600

    xi = np.linspace(-th_max, th_max, N)
    yi = np.linspace(-th_max, th_max, N)
    XI, YI = np.meshgrid(xi, yi)

    TH_i = np.sqrt(XI ** 2 + YI ** 2)
    PH_i = np.rad2deg(np.arctan2(XI, YI)) % 360.0

    pv, gw = _wrap_phi(R, grid)
    interp = RegularGridInterpolator(
        (R.theta_vec, pv), gw,
        method='linear', bounds_error=False, fill_value=np.nan)

    pts    = np.column_stack([TH_i.ravel(), PH_i.ravel()])
    G_i    = interp(pts).reshape(N, N)
    mask_out = TH_i > th_max
    G_i[mask_out] = np.nan

    th_cd = TH_i.copy(); ph_cd = PH_i.copy()
    th_cd[mask_out] = np.nan; ph_cd[mask_out] = np.nan
    customdata = np.stack([th_cd, ph_cd], axis=-1)

    fig = go.Figure(go.Heatmap(
        x=xi, y=yi, z=G_i,
        zmin=cmin, zmax=cmax, colorscale=_COLORSCALE,
        zsmooth='best',
        customdata=customdata,
        colorbar=dict(title=label, tickfont=dict(color=_FONT_COLOR)),
        hovertemplate=(
            'θ=%{customdata[0]:.1f}°  φ=%{customdata[1]:.1f}°<br>'
            + label + '=%{z:.2f}<extra></extra>'
        ),
    ))

    # ── Concentric theta rings ────────────────────────────────────────────
    ph_ring = np.linspace(0, 2 * np.pi, 361)
    for thr_ring in [30, 60, 90, 120, 150, 180]:
        if thr_ring > th_max * 1.01:
            break
        fig.add_trace(go.Scatter(
            x=thr_ring * np.sin(ph_ring), y=thr_ring * np.cos(ph_ring),
            mode='lines', line=dict(color='rgba(255,255,255,0.18)', width=0.8),
            showlegend=False, hoverinfo='skip'))
        fig.add_annotation(x=thr_ring * 0.07, y=thr_ring + th_max * 0.025,
                           text=f'{thr_ring}°', showarrow=False,
                           font=dict(color='rgba(255,255,255,0.50)', size=8))

    # ── Phi tick marks & labels at every 30° ─────────────────────────────
    tick_inner = th_max * 0.93
    tick_outer = th_max
    lbl_r      = th_max * 1.13
    for ph_deg in range(0, 360, 30):
        ph_rad = np.deg2rad(ph_deg)
        sx, sy = np.sin(ph_rad), np.cos(ph_rad)
        # Radial spoke (faint guide line)
        fig.add_trace(go.Scatter(
            x=[0, th_max * sx], y=[0, th_max * sy],
            mode='lines',
            line=dict(color='rgba(255,255,255,0.10)', width=0.6),
            showlegend=False, hoverinfo='skip'))
        # Tick mark segment at boundary
        fig.add_trace(go.Scatter(
            x=[tick_inner * sx, tick_outer * sx],
            y=[tick_inner * sy, tick_outer * sy],
            mode='lines',
            line=dict(color='rgba(255,255,255,0.55)', width=1.2),
            showlegend=False, hoverinfo='skip'))
        # Label
        fig.add_annotation(
            x=lbl_r * sx, y=lbl_r * sy,
            text=f'{ph_deg}°', showarrow=False,
            font=dict(color=_FONT_COLOR, size=9))

    # ── Clean circular edge: mask outside the circle with background ──────
    # Path = reversed circle (CCW, +1 winding) + CW square (-1 winding)
    # Inside circle: +1 + (-1) = 0 → NOT filled (transparent, shows data)
    # Between circle and square: 0 + (-1) = -1 → filled with _BG ✓
    n_circ = 360
    a_arr  = np.linspace(0, 2 * np.pi, n_circ, endpoint=False)[::-1]  # CCW
    cx = th_max * np.sin(a_arr)
    cy = th_max * np.cos(a_arr)
    circ_path = (f'M {cx[0]:.3f},{cy[0]:.3f} ' +
                 ' '.join(f'L {cx[k]:.3f},{cy[k]:.3f}' for k in range(1, n_circ)) +
                 ' Z')
    SQ = th_max * 2.5
    sq_path = f'M {SQ},{SQ} L {SQ},{-SQ} L {-SQ},{-SQ} L {-SQ},{SQ} Z'
    fig.add_shape(
        type='path',
        path=circ_path + ' ' + sq_path,
        fillcolor=_BG,
        line=dict(color=_BG, width=0),
        layer='above',
    )
    # Thin border ring on top of mask
    fig.add_shape(
        type='circle',
        xref='x', yref='y',
        x0=-th_max, y0=-th_max, x1=th_max, y1=th_max,
        line=dict(color='rgba(255,255,255,0.35)', width=1),
        layer='above',
    )

    pad = th_max * 1.25
    _ax_bare = dict(gridcolor=_GRID_COLOR, zerolinecolor=_GRID_COLOR,
                    showgrid=False, zeroline=False, showticklabels=False, title='')
    fig.update_layout(
        **_LAYOUT_BASE,
        title=dict(text=f'Circular — {label}', font=dict(color=_FONT_COLOR)),
        xaxis={**_ax_bare, 'scaleanchor': 'y', 'range': [-pad, pad]},
        yaxis={**_ax_bare, 'range': [-pad, pad]},
    )
    return fig


# ─────────────────────────────────────────────────────────────────────────────
# Coverage CDF
# ─────────────────────────────────────────────────────────────────────────────
def plot_coverage_cdf(thresholds, coverage_list: list, names: list) -> go.Figure:
    thr_list = ([thresholds] * len(coverage_list) if isinstance(thresholds, np.ndarray)
                else list(thresholds))

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
