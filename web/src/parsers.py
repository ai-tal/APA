"""
Antenna Pattern Parsers — unified format dispatcher.
Supports: .fz/.uan (XGTD), .ffe (FEKO), .ffd (HFSS), .ffs (CST),
          .out (GRASP), .csv/.txt/.dat (gain-only or full)
"""
import numpy as np
import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional, List


@dataclass
class PatternData:
    theta: np.ndarray       # degrees, flat (N,)
    phi: np.ndarray         # degrees, flat (N,)
    Eth: np.ndarray         # complex, flat (N,)  – zeros if gain_only
    Eph: np.ndarray         # complex, flat (N,)  – zeros if gain_only
    name: str
    fmt: str
    freq_mhz: float = float('nan')
    is_gain_only: bool = False
    num_cols: int = 6
    gain_col_index: int = 2
    raw_data: Optional[np.ndarray] = None
    header: dict = field(default_factory=dict)

    def __post_init__(self):
        if 'theta_min' not in self.header:
            self._build_header()

    def _build_header(self):
        th, ph = self.theta, self.phi
        th_u = np.unique(th)
        ph_u = np.unique(ph)
        th_inc = float(np.median(np.diff(th_u))) if len(th_u) > 1 else 1.0
        ph_inc = float(np.median(np.diff(ph_u))) if len(ph_u) > 1 else 1.0
        G = 20 * np.log10(np.abs(self.Eth) + 1e-20) if not self.is_gain_only else self.raw_data[:, self.gain_col_index]
        self.header = dict(
            theta_min=float(th.min()), theta_max=float(th.max()), theta_inc=th_inc,
            phi_min=float(ph.min()), phi_max=float(ph.max()), phi_inc=ph_inc,
            maximum_gain=float(np.max(G)),
            n_theta=int(len(th_u)), n_phi=int(len(ph_u)),
        )


def load_pattern(path_or_bytes, filename: str = '', format_hint: str = 'auto') -> PatternData:
    """Load an antenna pattern from a file path or bytes object."""
    if isinstance(path_or_bytes, (str, Path)):
        path = Path(path_or_bytes)
        content = path.read_bytes()
        name = path.stem
        ext = path.suffix.lower()
    else:
        content = path_or_bytes
        name = Path(filename).stem
        ext = Path(filename).suffix.lower()

    text = content.decode('utf-8', errors='replace')
    lines = text.splitlines()

    parsers = {
        '.fz': _parse_fz, '.uan': _parse_fz,
        '.ffe': _parse_ffe,
        '.ffd': _parse_ffd,
        '.ffs': _parse_ffs,
        '.out': _parse_grasp_out,
        '.csv': _parse_csv, '.txt': _parse_csv, '.dat': _parse_csv,
    }

    if format_hint != 'auto':
        ext = {
            'xgtd': '.fz', 'feko': '.ffe', 'hfss': '.ffd',
            'cst': '.ffs', 'grasp': '.out', 'csv': '.csv',
        }.get(format_hint.lower(), ext)

    if ext not in parsers:
        raise ValueError(f"Unsupported format: '{ext}'. Supported: {list(parsers.keys())}")

    P = parsers[ext](lines, name)
    P = _cleanse_coordinates(P)
    return P


# ---------------------------------------------------------------------------
# Internal helpers
# ---------------------------------------------------------------------------

def _mag_db_phase_to_complex(mag_dB: np.ndarray, phase_deg: np.ndarray) -> np.ndarray:
    mag_lin = 10.0 ** (mag_dB / 20.0)
    return mag_lin * np.exp(1j * np.deg2rad(phase_deg))


def _parse_numeric_block(lines: list, min_cols: int = 2) -> np.ndarray:
    rows = []
    for ln in lines:
        ln = ln.strip()
        if not ln or ln.startswith(('#', '%', '!', '/')):
            continue
        try:
            vals = [float(x) for x in ln.replace(',', ' ').split()]
            if len(vals) >= min_cols:
                rows.append(vals)
        except ValueError:
            continue
    if not rows:
        raise ValueError("No numeric data found in file.")
    # Pad rows to same length
    max_len = max(len(r) for r in rows)
    arr = np.zeros((len(rows), max_len))
    for i, r in enumerate(rows):
        arr[i, :len(r)] = r
    return arr


def _extract_freq_mhz(lines: list) -> float:
    """Try to extract frequency from header lines."""
    for ln in lines[:40]:
        m = re.search(r'freq(?:uency)?\s*[=:]\s*([\d.eE+\-]+)\s*(GHz|MHz|Hz)?', ln, re.I)
        if m:
            val = float(m.group(1))
            unit = (m.group(2) or 'MHz').upper()
            if unit == 'GHZ':
                return val * 1e3
            elif unit == 'HZ':
                return val / 1e6
            return val
    return float('nan')


# ---------------------------------------------------------------------------
# .fz / .uan — XGTD far-zone / universal antenna
# ---------------------------------------------------------------------------
def _parse_fz(lines: List[str], name: str) -> PatternData:
    freq = _extract_freq_mhz(lines)
    # Find data block after header markers
    start = 0
    for i, ln in enumerate(lines):
        lo = ln.lower()
        if 'end_<parameters>' in lo or 'end_parameters' in lo:
            start = i + 1
            break
    # Fallback: first line with >=6 numeric tokens
    if start == 0:
        for i, ln in enumerate(lines):
            parts = ln.split()
            if len(parts) >= 6:
                try:
                    [float(x) for x in parts[:6]]
                    start = i
                    break
                except ValueError:
                    continue

    data = _parse_numeric_block(lines[start:], 6)
    theta = data[:, 0]
    phi   = data[:, 1]
    Eth   = _mag_db_phase_to_complex(data[:, 2], data[:, 4])
    Eph   = _mag_db_phase_to_complex(data[:, 3], data[:, 5])
    return PatternData(theta=theta, phi=phi, Eth=Eth, Eph=Eph,
                       name=name, fmt='XGTD FZ', freq_mhz=freq)


# ---------------------------------------------------------------------------
# .ffe — FEKO far-field export
# ---------------------------------------------------------------------------
def _parse_ffe(lines: List[str], name: str) -> PatternData:
    freq = float('nan')
    theta_list, phi_list, gth_list, gph_list, pth_list, pph_list = [], [], [], [], [], []
    in_data = False
    for ln in lines:
        lo = ln.lower().strip()
        if lo.startswith('#frequencies'):
            pass
        m = re.match(r'#\s*frequency\s*=\s*([\d.eE+\-]+)', ln, re.I)
        if m:
            freq = float(m.group(1)) / 1e6
        if lo.startswith('#end') or lo.startswith('end') or lo == '':
            in_data = False
        if lo.startswith('#result'):
            in_data = True
            continue
        if in_data:
            parts = ln.split()
            if len(parts) >= 4:
                try:
                    vals = [float(x) for x in parts]
                    theta_list.append(vals[0]); phi_list.append(vals[1])
                    if len(vals) >= 6:
                        gth_list.append(vals[2]); pth_list.append(vals[3])
                        gph_list.append(vals[4]); pph_list.append(vals[5])
                    else:
                        gth_list.append(vals[2]); pth_list.append(0.0)
                        gph_list.append(vals[3] if len(vals)>3 else 0.0); pph_list.append(0.0)
                except ValueError:
                    continue

    if not theta_list:
        # Fallback: raw numeric parse assuming theta phi Gth Pth Gph Pph
        data = _parse_numeric_block(lines, 4)
        theta_list = list(data[:, 0]); phi_list = list(data[:, 1])
        if data.shape[1] >= 6:
            gth_list = list(data[:, 2]); pth_list = list(data[:, 3])
            gph_list = list(data[:, 4]); pph_list = list(data[:, 5])
        else:
            gth_list = list(data[:, 2]); pth_list = [0.0]*len(gth_list)
            gph_list = list(data[:, 3] if data.shape[1]>3 else np.zeros(len(gth_list)))
            pph_list = [0.0]*len(gph_list)

    theta = np.array(theta_list); phi = np.array(phi_list)
    Eth = _mag_db_phase_to_complex(np.array(gth_list), np.array(pth_list))
    Eph = _mag_db_phase_to_complex(np.array(gph_list), np.array(pph_list))
    return PatternData(theta=theta, phi=phi, Eth=Eth, Eph=Eph,
                       name=name, fmt='FEKO FFE', freq_mhz=freq)


# ---------------------------------------------------------------------------
# .ffd — HFSS far-field data (ASCII, potentially multi-frequency)
# ---------------------------------------------------------------------------
def _parse_ffd(lines: List[str], name: str) -> PatternData:
    # HFSS FFD: header block with [Version], [Data], etc., then numeric data
    freq = float('nan')
    for ln in lines[:20]:
        m = re.search(r'freq(?:uency)?\s+([\d.eE+\-]+)\s*(GHz|MHz|Hz)', ln, re.I)
        if m:
            v = float(m.group(1)); u = (m.group(2) or 'GHz').upper()
            freq = v*1e3 if u=='GHZ' else v if u=='MHZ' else v/1e6

    # Find [Data] block
    start = 0
    for i, ln in enumerate(lines):
        if re.search(r'\[data\]', ln, re.I):
            start = i + 1; break

    data = _parse_numeric_block(lines[start:], 3)
    # HFSS: phi theta re(Eth) im(Eth) re(Eph) im(Eph)  or  theta phi Gth_dB Pth_deg Gph_dB Pph_deg
    theta = data[:, 1]; phi = data[:, 0]
    if data.shape[1] >= 6:
        # Could be re/im or mag/phase — detect by range
        if np.max(np.abs(data[:, 2])) < 400:  # likely dB values
            Eth = _mag_db_phase_to_complex(data[:, 2], data[:, 3])
            Eph = _mag_db_phase_to_complex(data[:, 4], data[:, 5])
        else:
            Eth = data[:, 2] + 1j * data[:, 3]
            Eph = data[:, 4] + 1j * data[:, 5]
    else:
        Eth = _mag_db_phase_to_complex(data[:, 2], np.zeros(len(data)))
        Eph = np.zeros(len(data), dtype=complex)

    return PatternData(theta=theta, phi=phi, Eth=Eth, Eph=Eph,
                       name=name, fmt='HFSS FFD', freq_mhz=freq)


# ---------------------------------------------------------------------------
# .ffs — CST far-field source
# ---------------------------------------------------------------------------
def _parse_ffs(lines: List[str], name: str) -> PatternData:
    freq = float('nan')
    for ln in lines[:30]:
        m = re.search(r'//\s*Frequency:\s*([\d.eE+\-]+)', ln)
        if m:
            freq = float(m.group(1))  # usually MHz in CST
        m2 = re.search(r'#\s*frequency\s*=\s*([\d.eE+\-]+)', ln, re.I)
        if m2:
            freq = float(m2.group(1))

    data = _parse_numeric_block(lines, 4)
    # CST FFS: theta phi re(Eth) im(Eth) re(Eph) im(Eph) or mag/phase
    theta = data[:, 0]; phi = data[:, 1]
    if data.shape[1] >= 6:
        Eth = data[:, 2] + 1j * data[:, 3]
        Eph = data[:, 4] + 1j * data[:, 5]
    elif data.shape[1] >= 4:
        Eth = data[:, 2] + 1j * data[:, 3]
        Eph = np.zeros(len(theta), dtype=complex)
    else:
        Eth = _mag_db_phase_to_complex(data[:, 2], np.zeros(len(theta)))
        Eph = np.zeros(len(theta), dtype=complex)
    return PatternData(theta=theta, phi=phi, Eth=Eth, Eph=Eph,
                       name=name, fmt='CST FFS', freq_mhz=freq)


# ---------------------------------------------------------------------------
# .out — GRASP far-field output
# ---------------------------------------------------------------------------
def _parse_grasp_out(lines: List[str], name: str) -> PatternData:
    freq = _extract_freq_mhz(lines)
    data = _parse_numeric_block(lines, 3)
    # GRASP .out: theta phi G_co G_cx  or  theta phi Gth_dB Gph_dB Pth Pph
    theta = data[:, 0]; phi = data[:, 1]
    if data.shape[1] >= 6:
        Eth = _mag_db_phase_to_complex(data[:, 2], data[:, 4])
        Eph = _mag_db_phase_to_complex(data[:, 3], data[:, 5])
    elif data.shape[1] >= 4:
        Eth = _mag_db_phase_to_complex(data[:, 2], np.zeros(len(theta)))
        Eph = _mag_db_phase_to_complex(data[:, 3], np.zeros(len(theta)))
    else:
        Eth = _mag_db_phase_to_complex(data[:, 2], np.zeros(len(theta)))
        Eph = np.zeros(len(theta), dtype=complex)
    return PatternData(theta=theta, phi=phi, Eth=Eth, Eph=Eph,
                       name=name, fmt='GRASP OUT', freq_mhz=freq)


# ---------------------------------------------------------------------------
# .csv/.txt/.dat — gain-only or full (theta phi [Gth Pth Gph Pph])
# ---------------------------------------------------------------------------
def _parse_csv(lines: List[str], name: str) -> PatternData:
    freq = _extract_freq_mhz(lines)
    data = _parse_numeric_block(lines, 3)
    num_cols = data.shape[1]

    col1, col2 = data[:, 0], data[:, 1]
    # Auto-detect theta/phi ordering
    if col1.max() > 185 and col2.max() <= 185:
        theta, phi = col2, col1
    else:
        theta, phi = col1, col2

    if num_cols >= 6:
        Eth = _mag_db_phase_to_complex(data[:, 2], data[:, 4])
        Eph = _mag_db_phase_to_complex(data[:, 3], data[:, 5])
        is_gain_only = False
        gain_col = 2
    else:
        # Gain-only
        Eth = np.zeros(len(theta), dtype=complex)
        Eph = np.zeros(len(theta), dtype=complex)
        is_gain_only = True
        gain_col = 2

    return PatternData(theta=theta, phi=phi, Eth=Eth, Eph=Eph,
                       name=name, fmt='CSV', freq_mhz=freq,
                       is_gain_only=is_gain_only,
                       gain_col_index=gain_col,
                       num_cols=num_cols,
                       raw_data=data)


# ---------------------------------------------------------------------------
# Coordinate cleansing (v02: phi seam closure, dedup, sort)
# ---------------------------------------------------------------------------
def _cleanse_coordinates(P: PatternData) -> PatternData:
    theta = P.theta.copy()
    phi   = P.phi.copy()
    Eth   = P.Eth.copy()
    Eph   = P.Eph.copy()

    # Normalize phi to [0, 360)
    phi = phi % 360.0

    # Remove duplicates
    _, idx = np.unique(np.stack([theta, phi], axis=1), axis=0, return_index=True)
    idx = np.sort(idx)
    theta, phi, Eth, Eph = theta[idx], phi[idx], Eth[idx], Eph[idx]
    if P.raw_data is not None:
        raw = P.raw_data[idx]
    else:
        raw = None

    # Sort theta-major
    order = np.lexsort((phi, theta))
    theta = theta[order]; phi = phi[order]
    Eth = Eth[order]; Eph = Eph[order]
    if raw is not None:
        raw = raw[order]

    P.theta = theta; P.phi = phi
    P.Eth = Eth; P.Eph = Eph
    P.raw_data = raw
    P._build_header()
    return P
