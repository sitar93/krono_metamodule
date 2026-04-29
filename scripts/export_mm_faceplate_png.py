#!/usr/bin/env python3
"""Build assets/KronoPanel.png at 240px height for MetaModule (SDK docs/graphics.md).

Uses krono_vcv/res/KronoPanel.jpg (156×1024) via Pillow — same aspect as the desktop letterbox.

For a vector-first pipeline, run manually from the SDK (Inkscape on PATH):

  python metamodule-plugin-sdk/scripts/SvgToPng.py --input ../krono_vcv/res/KronoPanel.svg \\
    --output assets --height=240

(On Windows, set INKSCAPE_BIN_PATH if the path contains spaces and SvgToPng fails.)
"""
from __future__ import annotations

import sys
from pathlib import Path

MM_HEIGHT = 240


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    krono_vcv = root.parent / "krono_vcv"
    jpg = krono_vcv / "res" / "KronoPanel.jpg"
    out = root / "assets" / "KronoPanel.png"

    try:
        from PIL import Image
    except ImportError:
        print("Need Pillow: pip install Pillow", file=sys.stderr)
        return 1
    if not jpg.is_file():
        print("Missing:", jpg, file=sys.stderr)
        return 1
    out.parent.mkdir(parents=True, exist_ok=True)
    im = Image.open(jpg)
    w = max(1, round(im.width * MM_HEIGHT / im.height))
    im.resize((w, MM_HEIGHT), Image.Resampling.LANCZOS).save(out, "PNG")
    print(out, (w, MM_HEIGHT))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
