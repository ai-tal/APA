# Antenna Pattern Analyzer — Code Browser

## Overview

A **NiceGUI**-based web/desktop code browser for the **Antenna Pattern Analyzer (APA)** MATLAB App Designer project. Since MATLAB cannot run natively in Replit, this app provides a rich, interactive interface to browse all three versions of the MATLAB source code.

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
└── web/                 # NiceGUI application
    └── app.py           # Main app — NiceGUI server on port 5000
```

## Technology Stack

- **Framework**: NiceGUI (Python, FastAPI/Starlette + Vue/Quasar under the hood)
- **UI**: Quasar components via NiceGUI (dark theme, tabs, tree, code viewer)
- **Port**: 5000

## Running

```bash
python web/app.py
```

Runs as a web app on `http://0.0.0.0:5000`. Can also be launched as a native desktop app by changing `ui.run(native=True)`.

## Features

- **3-version tabs**: APA v1, v2, v3 with live tree switching
- **File tree**: NiceGUI `ui.tree()` with namespace badges (I/O, Plot, Proc)
- **Code viewer**: Syntax-highlighted MATLAB via `ui.code(language='matlab')`
- **Copy button**: Copies full file content to clipboard
- **Version info bar**: Description and file count per version

## What the MATLAB App Does

Loads antenna far-field radiation patterns from simulation tools (HFSS, GRASP, CST, FEKO, XGTD) in formats like `.ffd`, `.ffe`, `.ffs`, `.fz`, `.out` and provides:

- Gain, EIRP, axial ratio, PLF, HPBW calculations
- Pattern rotation and combination
- 2D/3D visualization: polar cuts, contour maps, spherical plots, filled polar
- Export to CSV, FFD, FFE, FFS, FZ, UAN formats

## Deployment

Configured as `autoscale` with `python web/app.py`.
