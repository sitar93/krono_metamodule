Krono — MetaModule plugin (.mmplugin)
=====================================

Build output
------------
  Krono.mmplugin

What it is
----------
  A MetaModule Plugin package (.mmplugin): it contains the Krono module
  built for MetaModule hardware (ARM), plus the metadata and assets required
  for the device to load it.

  End users typically install only this file to run Krono on a MetaModule,
  following the firmware / MetaModule documentation (4ms).

Module information
------------------
  Display name:     Krono
  Module slug:      Krono
  Brand (VCV/MM):   Jolin
  Plugin version:   2.1.0
  Description:      Multi-modal rhythm generator (VCV Rack port for MetaModule).

  License (plugin): CC-BY-NC-SA-4.0

Typical contents of the .mmplugin
---------------------------------
  Produced by the MetaModule Plugin SDK; the archive generally includes:
    • Krono.so          — plugin binary for MetaModule (ARM)
    • plugin.json       — VCV Rack manifest (brand, slug, modules, version)
    • plugin-mm.json    — MetaModule-specific manifest (exposed modules, UI text)
    • assets/           — graphics (e.g. PNG) used by the module

Requirements
------------
  • A MetaModule running firmware that supports .mmplugin-format plugins
  • Optional preset or bank packs, if distributed separately, are not required
    for basic module operation.

Build (developer reference)
-----------------------------
  CMake project in krono_metamodule; SDK: metamodule-plugin-sdk (4ms).
  Toolchain recommended by the SDK: arm-none-eabi-gcc 12.2 or 12.3.
  Build output directory: this folder (metamodule-plugins).

Links
-----
  MetaModule build (this plugin): https://github.com/sitar93/krono_metamodule
  MetaModule Plugin SDK:         https://github.com/4ms/metamodule-plugin-sdk
  Brand / info:                  https://jolin.tech
  Eurorack firmware / manual:    https://github.com/sitar93/krono
  VCV Rack plugin source:        https://github.com/sitar93/krono_vcv
