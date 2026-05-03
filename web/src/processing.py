"""
Antenna Pattern Processing — metrics, grid cache, HPBW, directivity.
Combines best logic from APAv01 (HPBW/FBR, polarisation), APA_v02 (grid cache,
directivity, auto-clamp), APA_v03 (solid-angle weights, principal orientation).
"""
import numpy as np
from dataclasses import dataclass, field
from typing import Optional, Tuple
from .parsers import PatternData


@dataclass
class ProcessedPattern:
    # Flat arrays (same index as input theta/phi)
    theta: np.ndarray
    phi: np.ndarray
    G_total_dB: np.ndarray
    G_RHCP_dB: np.ndarray
    G_LHCP_dB: np.ndarray
    AR_dB: np.ndarray
    PLF_dB: np.ndarray
    EIRP_dBW: np.ndarray
    PFD_Wm2: np.ndarray

    # Scalars
    max_gain_dB: float
    max_gain_dir: Tuple[float, float]   # (theta, phi)
    dominant_pol: str
    hpbw_e: Optional[float]
    hpbw_h: Optional[float]
    fbr_dB: Optional[float]
    directivity_dBi: Optional[float]

    # Grid cache (2-D arrays on regular theta×phi grid)
    theta_vec: np.ndarray
    phi_vec: np.ndarray
    G_grid: np.ndarray
    RHCP_grid: np.ndarray
    LHCP_grid: np.ndarray
    AR_grid: np.ndarray
    PLF_grid: np.ndarray
    is_regular: bool = True

    # Summary table rows (for display)
    table_rows: list = field(default_factory=list)
    table_cols: list = field(default_factory=list)


def process_pattern(P: PatternData, params: dict = None) -> ProcessedPattern:
    """Full metrics pipeline from a parsed PatternData."""
    if params is None:
        params = {}

    Pt_dBW  = float(params.get('Pt_dBW', 0.0))
    Loss_dB = float(params.get('Loss_dB', 0.0))
    Rw_dB   = float(params.get('Rw_dB', 0.0))
    dist_m  = float(params.get('dist_m', 1.0))
    pol_ref_theta = float(params.get('pol_ref_theta', 0.0))  # reference pol for PLF
    pol_ref_phi   = float(params.get('pol_ref_phi', 0.0))

    theta = P.theta; phi = P.phi
    Eth = P.Eth; Eph = P.Eph

    # ---- Gain total ----
    if P.is_gain_only and P.raw_data is not None:
        G_total_dB = P.raw_data[:, P.gain_col_index].copy()
        # RHCP/LHCP not available for gain-only
        G_RHCP_dB = G_total_dB - 3.0
        G_LHCP_dB = G_total_dB - 3.0
        AR_dB = np.zeros_like(G_total_dB)
        Eth_used = 10.0 ** (G_total_dB / 20.0)
        Eph_used = np.zeros_like(Eth_used)
    else:
        mag_th = np.abs(Eth); mag_ph = np.abs(Eph)
        # Power = |Eth|^2 + |Eph|^2  (proportional, not absolute W/sr)
        P_total = mag_th**2 + mag_ph**2
        P_total = np.maximum(P_total, 1e-30)
        G_total_dB = 10.0 * np.log10(P_total)
        # Shift so peak is max_gain from header (if known) — or leave relative
        peak_raw = G_total_dB.max()
        peak_header = P.header.get('maximum_gain', float('nan'))
        if np.isfinite(peak_header):
            G_total_dB += (peak_header - peak_raw)
        # RHCP / LHCP
        E_RHCP = (Eth - 1j * Eph) / np.sqrt(2)
        E_LHCP = (Eth + 1j * Eph) / np.sqrt(2)
        G_RHCP_dB = G_total_dB + 20.0 * np.log10(np.abs(E_RHCP) / np.sqrt(P_total) + 1e-15)
        G_LHCP_dB = G_total_dB + 20.0 * np.log10(np.abs(E_LHCP) / np.sqrt(P_total) + 1e-15)
        # Axial Ratio  (dB, 0 = circular, large = linear)
        with np.errstate(divide='ignore', invalid='ignore'):
            ar_lin = (np.abs(E_RHCP) + np.abs(E_LHCP)) / (np.maximum(np.abs(np.abs(E_RHCP) - np.abs(E_LHCP)), 1e-30))
        AR_dB = 20.0 * np.log10(np.clip(ar_lin, 1.0, 1e6))
        Eth_used = mag_th; Eph_used = mag_ph

    # ---- PLF (polarisation loss factor vs reference linear pol) ----
    ref_th = np.deg2rad(pol_ref_theta); ref_ph = np.deg2rad(pol_ref_phi)
    E_ref = np.array([np.sin(ref_th) * np.cos(ref_ph),
                      np.sin(ref_th) * np.sin(ref_ph),
                      np.cos(ref_th)])
    # Simplified: PLF = |cos(angle between dominant E and ref)|^2
    mag_dom = np.maximum(Eth_used, Eph_used)
    PLF_lin = np.clip(mag_dom / (np.maximum(np.sqrt(Eth_used**2 + Eph_used**2), 1e-30)), 0, 1)**2
    PLF_dB = 10.0 * np.log10(np.maximum(PLF_lin, 1e-10))

    # ---- EIRP, PFD ----
    EIRP_dBW = Pt_dBW - Loss_dB + G_total_dB
    # PFD = EIRP - 20log10(4π r)  [dBW/m²]
    PFD_dBWm2 = EIRP_dBW - 20.0 * np.log10(4 * np.pi * max(dist_m, 0.001))
    PFD_Wm2 = 10.0 ** (PFD_dBWm2 / 10.0)

    # ---- Peak ----
    i_peak = int(np.argmax(G_total_dB))
    max_gain_dB = float(G_total_dB[i_peak])
    max_gain_dir = (float(theta[i_peak]), float(phi[i_peak]))

    # ---- Dominant polarisation ----
    mean_Eth = float(np.mean(Eth_used))
    mean_Eph = float(np.mean(Eph_used))
    dominant_pol = 'θ-pol (linear)' if mean_Eth >= mean_Eph else 'φ-pol (linear)'
    # Check RHCP vs LHCP dominance
    if not P.is_gain_only:
        if np.mean(G_RHCP_dB) > np.mean(G_LHCP_dB) + 1.0:
            dominant_pol = 'RHCP'
        elif np.mean(G_LHCP_dB) > np.mean(G_RHCP_dB) + 1.0:
            dominant_pol = 'LHCP'

    # ---- HPBW (E & H planes through peak) ----
    hpbw_e, hpbw_h, fbr_dB = _compute_hpbw_fbr(theta, phi, G_total_dB,
                                                  max_gain_dir[0], max_gain_dir[1])

    # ---- Directivity ----
    directivity_dBi = _compute_directivity(theta, phi, G_total_dB)

    # ---- Build grid cache ----
    (theta_vec, phi_vec, G_grid, RHCP_grid, LHCP_grid, AR_grid, PLF_grid,
     is_regular) = _build_grid_cache(theta, phi, G_total_dB, G_RHCP_dB, G_LHCP_dB, AR_dB, PLF_dB)

    # ---- Summary table ----
    table_cols = ['Metric', 'Value']
    table_rows = [
        ['Peak Gain', f'{max_gain_dB:.2f} dBi'],
        ['Peak Direction', f'θ={max_gain_dir[0]:.1f}°, φ={max_gain_dir[1]:.1f}°'],
        ['Dominant Pol', dominant_pol],
        ['HPBW (E-plane)', f'{hpbw_e:.1f}°' if hpbw_e else 'N/A'],
        ['HPBW (H-plane)', f'{hpbw_h:.1f}°' if hpbw_h else 'N/A'],
        ['F/B Ratio', f'{fbr_dB:.1f} dB' if fbr_dB else 'N/A'],
        ['Directivity', f'{directivity_dBi:.2f} dBi' if directivity_dBi else 'N/A'],
        ['EIRP (peak)', f'{float(EIRP_dBW.max()):.2f} dBW'],
        ['Freq', f'{P.freq_mhz:.1f} MHz' if np.isfinite(P.freq_mhz) else 'N/A'],
        ['Format', P.fmt],
        ['Grid', f'{len(np.unique(theta))} × {len(np.unique(phi))} pts'],
    ]

    return ProcessedPattern(
        theta=theta, phi=phi,
        G_total_dB=G_total_dB, G_RHCP_dB=G_RHCP_dB, G_LHCP_dB=G_LHCP_dB,
        AR_dB=AR_dB, PLF_dB=PLF_dB, EIRP_dBW=EIRP_dBW, PFD_Wm2=PFD_Wm2,
        max_gain_dB=max_gain_dB, max_gain_dir=max_gain_dir,
        dominant_pol=dominant_pol,
        hpbw_e=hpbw_e, hpbw_h=hpbw_h, fbr_dB=fbr_dB,
        directivity_dBi=directivity_dBi,
        theta_vec=theta_vec, phi_vec=phi_vec,
        G_grid=G_grid, RHCP_grid=RHCP_grid, LHCP_grid=LHCP_grid,
        AR_grid=AR_grid, PLF_grid=PLF_grid,
        is_regular=is_regular,
        table_rows=table_rows, table_cols=table_cols,
    )


def get_component_grid(R: ProcessedPattern, component: str) -> Tuple[np.ndarray, str]:
    """Return (grid, label) for the given component name."""
    comp_map = {
        'Total Gain':    (R.G_grid,    'Total Gain (dBi)'),
        'RHCP Gain':     (R.RHCP_grid, 'RHCP Gain (dBic)'),
        'LHCP Gain':     (R.LHCP_grid, 'LHCP Gain (dBic)'),
        'Axial Ratio':   (R.AR_grid,   'Axial Ratio (dB)'),
        'PLF':           (R.PLF_grid,  'PLF (dB)'),
    }
    return comp_map.get(component, (R.G_grid, 'Total Gain (dBi)'))


def get_cut(R: ProcessedPattern, cut_type: str, cut_value: float):
    """Extract a 1-D pattern cut.
    cut_type: 'Phi Cut'   → vary phi at fixed theta=cut_value
              'Theta Cut' → vary theta at fixed phi=cut_value
    Returns (angles, G_total, G_RHCP, G_LHCP) all in dB.
    """
    eps = 1.0
    if cut_type == 'Phi Cut':
        mask = np.abs(R.theta - cut_value) < eps
        angles = R.phi[mask]
    else:
        mask = np.abs(R.phi - cut_value) < eps
        angles = R.theta[mask]
    if mask.sum() < 2:
        # Nearest slice
        if cut_type == 'Phi Cut':
            nearest = R.theta_vec[np.argmin(np.abs(R.theta_vec - cut_value))]
            mask = np.abs(R.theta - nearest) < eps
            angles = R.phi[mask]
        else:
            nearest = R.phi_vec[np.argmin(np.abs(R.phi_vec - cut_value))]
            mask = np.abs(R.phi - nearest) < eps
            angles = R.theta[mask]
    order = np.argsort(angles)
    return (angles[order],
            R.G_total_dB[mask][order],
            R.G_RHCP_dB[mask][order],
            R.G_LHCP_dB[mask][order])


# ---------------------------------------------------------------------------
# Internal helpers
# ---------------------------------------------------------------------------

def _compute_hpbw_fbr(theta, phi, G_dB, peak_theta, peak_phi):
    """Compute HPBW in E-plane (phi=peak_phi) and H-plane (phi=peak_phi+90),
    and F/B ratio."""
    half_power = G_dB.max() - 3.0
    eps = 2.0

    def _hpbw_from_cut(angles, gain):
        if len(gain) < 3:
            return None
        above = gain >= half_power
        crossings = np.where(np.diff(above.astype(int)) != 0)[0]
        if len(crossings) < 2:
            return None
        a1 = float(angles[crossings[0]])
        a2 = float(angles[crossings[-1]])
        return abs(a2 - a1)

    # E-plane: phi cut at phi=peak_phi, vary theta
    mask_e = np.abs(phi - peak_phi) < eps
    if mask_e.sum() > 2:
        ord_e = np.argsort(theta[mask_e])
        hpbw_e = _hpbw_from_cut(theta[mask_e][ord_e], G_dB[mask_e][ord_e])
    else:
        hpbw_e = None

    # H-plane: phi+90
    h_phi = (peak_phi + 90) % 360
    mask_h = np.abs(phi - h_phi) < eps
    if mask_h.sum() > 2:
        ord_h = np.argsort(theta[mask_h])
        hpbw_h = _hpbw_from_cut(theta[mask_h][ord_h], G_dB[mask_h][ord_h])
    else:
        hpbw_h = None

    # F/B ratio
    back_theta = 180.0 - peak_theta
    back_phi = (peak_phi + 180) % 360
    mask_back = (np.abs(theta - back_theta) < eps) & (np.abs(phi - back_phi) < eps)
    if mask_back.sum() > 0:
        G_back = float(G_dB[mask_back].max())
        fbr_dB = G_dB.max() - G_back
    else:
        fbr_dB = None

    return hpbw_e, hpbw_h, fbr_dB


def _compute_directivity(theta, phi, G_dB):
    """Estimate directivity using solid-angle weights (exact spherical integration).
    D = 4π × G_peak / ∫ G(θ,φ) sin(θ) dθ dφ
    Uses gridSolidAngleWeights idea from v03."""
    try:
        th_u = np.unique(theta)
        ph_u = np.unique(phi)
        if len(th_u) < 3 or len(ph_u) < 3:
            return None

        # Build regular grid
        nTh, nPh = len(th_u), len(ph_u)
        TH, PH = np.meshgrid(th_u, ph_u, indexing='ij')

        # Interpolate gain onto grid
        from scipy.interpolate import griddata
        G_lin = 10.0 ** (G_dB / 10.0)
        G_grid = griddata((theta, phi), G_lin,
                          (TH.ravel(), PH.ravel()), method='linear',
                          fill_value=float(np.nanmin(G_lin)))
        G_grid = G_grid.reshape(nTh, nPh)

        # Solid-angle weights: sin(theta) dTheta dPhi
        dTh = np.deg2rad(np.gradient(th_u))
        dPh = np.deg2rad(np.gradient(ph_u))
        sinTH = np.sin(np.deg2rad(th_u))
        W = np.outer(sinTH * dTh, dPh)  # (nTh, nPh)

        total_radiated = float(np.sum(G_grid * W))
        if total_radiated <= 0:
            return None
        D_lin = 4 * np.pi * 10.0 ** (G_dB.max() / 10.0) / total_radiated
        return float(10.0 * np.log10(max(D_lin, 1e-10)))
    except Exception:
        return None


def _build_grid_cache(theta, phi, G_total, G_RHCP, G_LHCP, AR, PLF):
    """Build 2-D (theta×phi) grid arrays.
    Fast path: reshape if data is already on a regular grid.
    Slow path: scipy.interpolate.griddata for scattered data."""
    th_u = np.unique(theta)
    ph_u = np.unique(phi)
    nTh, nPh = len(th_u), len(ph_u)
    n_data = len(theta)

    is_regular = False
    if nTh * nPh == n_data or nTh * (nPh - 1) == n_data:
        is_regular = True
    # Guard against geometry explosion (post-rotation irregular data)
    if nTh > 800 or nPh > 800:
        is_regular = False

    if is_regular and nTh * nPh == n_data:
        order = np.lexsort((phi, theta))
        def _reshape(arr):
            # theta-major: nTh rows (theta), nPh cols (phi) — need phi-major sort
            s = arr[order].reshape(nTh, nPh)
            # Verify sorted order matches th_u × ph_u
            return s
        try:
            # phi-major sort for reshape
            order2 = np.lexsort((theta, phi))
            def _reshp2(arr):
                s = arr[order2].reshape(nPh, nTh).T
                return s
            G_grid    = _reshp2(G_total)
            RHCP_grid = _reshp2(G_RHCP)
            LHCP_grid = _reshp2(G_LHCP)
            AR_grid   = _reshp2(AR)
            PLF_grid  = _reshp2(PLF)
            is_regular = True
        except Exception:
            is_regular = False

    if not is_regular:
        from scipy.interpolate import griddata
        TH, PH = np.meshgrid(th_u, ph_u, indexing='ij')
        pts = (theta, phi)
        xi = (TH.ravel(), PH.ravel())
        pad_phi = np.concatenate([phi, phi - 360, phi + 360])
        pad_th  = np.concatenate([theta, theta, theta])

        def _gd(arr):
            pa = np.concatenate([arr, arr, arr])
            return griddata((pad_th, pad_phi), pa,
                            (TH.ravel(), PH.ravel()),
                            method='linear',
                            fill_value=float(np.nanmin(arr))).reshape(nTh, nPh)
        G_grid    = _gd(G_total)
        RHCP_grid = _gd(G_RHCP)
        LHCP_grid = _gd(G_LHCP)
        AR_grid   = _gd(AR)
        PLF_grid  = _gd(PLF)

    return th_u, ph_u, G_grid, RHCP_grid, LHCP_grid, AR_grid, PLF_grid, is_regular


# ---------------------------------------------------------------------------
# Rotation — SO(3) cumulative rotation (v01/v02 RotMatrix approach)
# ---------------------------------------------------------------------------

def rotation_matrix_from_vectors(src_th, src_ph, dst_th, dst_ph):
    """Build a 3×3 rotation matrix that rotates unit vector at (src_th, src_ph)
    onto (dst_th, dst_ph) using Rodrigues' rotation formula."""
    def sph_to_cart(th_deg, ph_deg):
        th = np.deg2rad(th_deg); ph = np.deg2rad(ph_deg)
        return np.array([np.sin(th)*np.cos(ph), np.sin(th)*np.sin(ph), np.cos(th)])

    u = sph_to_cart(src_th, src_ph)
    v = sph_to_cart(dst_th, dst_ph)

    axis = np.cross(u, v)
    sin_a = np.linalg.norm(axis)
    cos_a = np.dot(u, v)
    if sin_a < 1e-12:
        if cos_a > 0:
            return np.eye(3)
        else:
            # 180° rotation around any perpendicular axis
            perp = np.array([1, 0, 0]) if abs(u[0]) < 0.9 else np.array([0, 1, 0])
            axis = np.cross(u, perp); axis /= np.linalg.norm(axis)
            sin_a = 1.0; cos_a = 0.0
    else:
        axis = axis / sin_a

    K = np.array([[0, -axis[2], axis[1]],
                  [axis[2], 0, -axis[0]],
                  [-axis[1], axis[0], 0]])
    R = cos_a * np.eye(3) + sin_a * K + (1 - cos_a) * np.outer(axis, axis)
    return R


def apply_rotation(P, R_mat: np.ndarray):
    """Rotate all (theta, phi) direction vectors in PatternData by R_mat.
    Returns new theta, phi arrays."""
    th = np.deg2rad(P.theta); ph = np.deg2rad(P.phi)
    x = np.sin(th) * np.cos(ph)
    y = np.sin(th) * np.sin(ph)
    z = np.cos(th)
    xyz = R_mat @ np.stack([x, y, z], axis=0)   # (3, N)
    x2, y2, z2 = xyz[0], xyz[1], xyz[2]
    th2 = np.arccos(np.clip(z2, -1, 1))
    ph2 = np.arctan2(y2, x2) % (2 * np.pi)
    return np.rad2deg(th2), np.rad2deg(ph2)


# ---------------------------------------------------------------------------
# Coverage computation
# ---------------------------------------------------------------------------

def compute_coverage(R: ProcessedPattern, thresholds: np.ndarray,
                     mode: str = 'spherical',
                     cone_axis_th: float = 0.0,
                     cone_axis_ph: float = 0.0,
                     cone_half_angle: float = 90.0) -> np.ndarray:
    """Compute fraction of sphere (or conical region) where gain ≥ threshold.
    Returns coverage fraction array (same shape as thresholds).
    Uses exact solid-angle weights: dΩ = sin(θ) dθ dφ"""
    th = np.deg2rad(R.theta_vec)
    ph = np.deg2rad(R.phi_vec)
    nTh, nPh = len(th), len(ph)
    TH, PH = np.meshgrid(th, ph, indexing='ij')

    # Solid-angle weights
    dTh = np.gradient(th)
    dPh = np.gradient(ph)
    sinTH = np.sin(TH)
    W = sinTH * np.outer(dTh, dPh)   # (nTh, nPh)

    G = R.G_grid

    if mode == 'conical':
        ax_th = np.deg2rad(cone_axis_th); ax_ph = np.deg2rad(cone_axis_ph)
        ax = np.array([np.sin(ax_th)*np.cos(ax_ph),
                       np.sin(ax_th)*np.sin(ax_ph), np.cos(ax_th)])
        X = np.sin(TH)*np.cos(PH); Y = np.sin(TH)*np.sin(PH); Z = np.cos(TH)
        dot = ax[0]*X + ax[1]*Y + ax[2]*Z
        sep_deg = np.rad2deg(np.arccos(np.clip(dot, -1, 1)))
        cone_mask = sep_deg <= cone_half_angle
        W_region = W * cone_mask
    else:
        cone_mask = np.ones((nTh, nPh), dtype=bool)
        W_region = W

    total_sa = float(W_region.sum())
    if total_sa < 1e-30:
        return np.zeros_like(thresholds)

    coverage = np.zeros(len(thresholds))
    for i, thr in enumerate(thresholds):
        coverage[i] = float(np.sum(W_region * (G >= thr))) / total_sa

    return coverage


# ---------------------------------------------------------------------------
# Pattern combination
# ---------------------------------------------------------------------------

def combine_patterns(patterns_R: list, method: str = 'incoherent',
                     masks: list = None) -> ProcessedPattern:
    """Combine a list of ProcessedPattern objects.
    method: 'coherent' | 'incoherent' | 'envelope' | 'regional_mask'
    masks: list of dicts {type, value} for regional_mask
    """
    if not patterns_R:
        raise ValueError("No patterns to combine.")
    if len(patterns_R) == 1:
        return patterns_R[0]

    # Reference grid from first pattern
    R0 = patterns_R[0]
    th_vec = R0.theta_vec
    ph_vec = R0.phi_vec
    TH, PH = np.meshgrid(th_vec, ph_vec, indexing='ij')

    # Interpolate all patterns onto reference grid
    grids = []
    for R in patterns_R:
        if np.array_equal(R.theta_vec, th_vec) and np.array_equal(R.phi_vec, ph_vec):
            grids.append(R.G_grid.copy())
        else:
            from scipy.interpolate import RegularGridInterpolator
            try:
                itp = RegularGridInterpolator(
                    (R.theta_vec, R.phi_vec), R.G_grid, method='linear',
                    bounds_error=False, fill_value=float(R.G_grid.min()))
                grids.append(itp((TH, PH)))
            except Exception:
                grids.append(R.G_grid[:len(th_vec), :len(ph_vec)])

    G_lin = [10.0 ** (g / 10.0) for g in grids]

    if method == 'coherent':
        # Coherent sum: sqrt(sum(|E_i|^2))  (power sense, ignore phase for simplicity)
        G_comb_lin = np.zeros_like(G_lin[0])
        for gl in G_lin:
            G_comb_lin += np.sqrt(np.maximum(gl, 0))
        G_comb_lin = G_comb_lin ** 2
    elif method == 'incoherent':
        G_comb_lin = sum(G_lin)
    elif method == 'envelope':
        G_comb_lin = G_lin[0].copy()
        for gl in G_lin[1:]:
            G_comb_lin = np.maximum(G_comb_lin, gl)
    elif method == 'regional_mask':
        G_comb_lin = G_lin[0].copy()
        for k, gl in enumerate(G_lin[1:], start=1):
            if masks and k - 1 < len(masks):
                mask_def = masks[k - 1]
                m = _build_regional_mask(TH, PH, mask_def)
            else:
                m = np.ones_like(G_comb_lin, dtype=bool)
            G_comb_lin = np.where(m, gl, G_comb_lin)
    else:
        G_comb_lin = sum(G_lin)

    G_comb_dB = 10.0 * np.log10(np.maximum(G_comb_lin, 1e-30))

    # Flatten for ProcessedPattern
    theta_flat = TH.ravel(); phi_flat = PH.ravel()
    G_flat = G_comb_dB.ravel()

    from .parsers import PatternData as PD
    P_fake = PD(theta=theta_flat, phi=phi_flat,
                Eth=np.sqrt(np.maximum(G_flat, 0)) + 0j,
                Eph=np.zeros(len(G_flat)) + 0j,
                name='combined', fmt='combined',
                is_gain_only=True,
                raw_data=np.column_stack([theta_flat, phi_flat, G_flat]),
                gain_col_index=2)
    P_fake._build_header()
    P_fake.header['maximum_gain'] = float(G_comb_dB.max())
    params = {}
    R_comb = process_pattern(P_fake, params)
    return R_comb


def _build_regional_mask(TH_rad, PH_rad, mask_def: dict) -> np.ndarray:
    """Build boolean mask array for regional combine."""
    mask_type = mask_def.get('type', 'phi_range')
    v1 = float(mask_def.get('v1', 0))
    v2 = float(mask_def.get('v2', 180))
    TH_d = np.rad2deg(TH_rad); PH_d = np.rad2deg(PH_rad)
    if mask_type == 'phi_range':
        return (PH_d >= v1) & (PH_d <= v2)
    elif mask_type == 'theta_range':
        return (TH_d >= v1) & (TH_d <= v2)
    elif mask_type == 'hemisphere_upper':
        return TH_d <= 90
    elif mask_type == 'hemisphere_lower':
        return TH_d >= 90
    else:
        return np.ones_like(TH_rad, dtype=bool)
