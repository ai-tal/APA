# Antenna Pattern Analyzer — Code Browser

## Overview

A web-based code browser for the **Antenna Pattern Analyzer (APA)** MATLAB App Designer project. Since MATLAB cannot run natively in Replit, this app provides a clean web interface to browse and read all three versions of the MATLAB source code.

## Project Structure

```
/
├── APAv01/              # APA v1 — full library with io, plt, proc packages
│   ├── APA_v01.m        # Main App Designer class
│   └── lib/
│       ├── +io/         # File parsers (FZ, FFE, FFD, FFS, GRASP, CSV)
│       ├── +plt/        # Plotting functions (contour, polar, 3D, spherical)
│       └── +proc/       # Pattern processing (gain, HPBW, rotation, combine)
├── APA_v02.m            # APA v2 — standalone monolithic app file
├── APA_v03/             # APA v3 — extended I/O, regional masking
│   ├── APA_v01.m        # Main App Designer class (v3)
│   └── lib/
│       ├── +io/         # Extended loaders (HFSS, CST, FEKO, XGTD, GRASP)
│       └── +proc/       # Extended processing (regional masks, solid angle weights)
└── web/                 # Flask web code browser
    ├── app.py           # Flask server (serves on port 5000)
    └── templates/
        └── index.html   # Single-page code browser UI
```

## Technology Stack

- **Backend**: Python 3, Flask
- **Frontend**: Vanilla HTML/CSS/JS (single template, no framework)
- **Port**: 5000

## Running

```bash
python web/app.py
```

## What the MATLAB App Does

The APA app loads antenna far-field radiation patterns from simulation tools (HFSS, GRASP, CST, FEKO, XGTD) in formats like `.ffd`, `.ffe`, `.ffs`, `.fz`, `.out` and provides:

- Gain, EIRP, axial ratio, PLF, HPBW calculations
- Pattern rotation and combination
- 2D/3D visualization: polar cuts, contour maps, spherical plots, filled polar
- Export to CSV, FFD, FFE, FFS, FZ, UAN formats

## Deployment

Configured as `autoscale` static-style with gunicorn for production.
