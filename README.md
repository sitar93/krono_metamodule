# Krono — MetaModule

**Repository:** [github.com/sitar93/krono_metamodule](https://github.com/sitar93/krono_metamodule)

Build files for **[Krono](https://jolin.tech/krono)**, a multi-modal rhythm generator, as a **MetaModule** plugin (`.mmplugin`). Module logic is shared with the [VCV Rack plugin](https://github.com/sitar93/krono_vcv), aligned with [KRONO Eurorack firmware](https://github.com/sitar93/krono).

## Related repositories

| Role | Repository |
|------|------------|
| **This repo** — MetaModule `.mmplugin` build | [sitar93/krono_metamodule](https://github.com/sitar93/krono_metamodule) |
| **VCV Rack** plugin source | [sitar93/krono_vcv](https://github.com/sitar93/krono_vcv) |
| **Hardware** — Eurorack firmware / reference | [sitar93/krono](https://github.com/sitar93/krono) |

| | |
|---|---|
| **Brand** | Jolin |
| **Module** | Krono |
| **Plugin version** | 2.1.0 (see `../krono_vcv/plugin.json` when using sibling layout) |
| **License** | [CC BY-NC-SA 4.0](LICENSE) |

## MetaModule hardware testing

**This plugin has not been verified on a physical MetaModule.** We do not currently have access to the hardware, so behavior on device (audio, UI, performance, compatibility with a given firmware revision) is **unconfirmed**.

If you run **`Krono.mmplugin`** on a MetaModule and find problems—or have a fix or reproduction steps—please **open an [issue](https://github.com/sitar93/krono_metamodule/issues)** in this repository so we can track and address it.

## End users

Install **`Krono.mmplugin`** on a compatible MetaModule (see [4ms MetaModule](https://www.4mscompany.com/metamodule.html) documentation). You do **not** need this repository unless you want to build from source.

Pre-built packages (e.g. **`Krono-v1.0.0.mmplugin`**) are published as assets on [GitHub Releases](https://github.com/sitar93/krono_metamodule/releases); see the `releases/` folder for `release_notes.txt`, checksums, and naming. Names must follow 4ms rules: **`[BrandSlug]-v[version].mmplugin`** (BrandSlug = top-level **`slug`** in `plugin.json`, here **Krono**). The CMake build still writes **`metamodule-plugins/Krono.mmplugin`** — rename when cutting a release.

## Requirements (from source)

- [CMake](https://cmake.org/) 3.22+
- [MSYS2](https://www.msys2.org/) with **MINGW64** environment (Windows)
- [ARM GNU Toolchain](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads) **arm-none-eabi** — the MetaModule SDK is tested with **GCC 12.2 / 12.3**; other versions may work with warnings
- [Python](https://www.python.org/) 3.6+ (used by the SDK build)
- Optional: [`jq`](https://jqlang.org/) (validates `plugin-mm.json`)

Upstream SDK docs: [metamodule-plugin-sdk README](https://github.com/4ms/metamodule-plugin-sdk/blob/main/README.md).

## Repository layout

- **`metamodule-plugin-sdk/`** — [MetaModule Plugin SDK](https://github.com/4ms/metamodule-plugin-sdk) (clone with submodules).
- **`assets/`** — Panel and UI assets for the MetaModule build.
- **`plugin-mm.json`** — MetaModule plugin manifest.
- **`CMakeLists.txt`** — Finds Rack sources and `plugin.json` from:
  - `../plugin.json` (MetaModule nested under the VCV repo), or
  - `../krono_vcv/plugin.json` (sibling checkout; **recommended** for this tree).
- **`metamodule-plugins/`** — CMake writes **`Krono.mmplugin`** here when the build succeeds.

## Clone and submodules

```bash
git clone https://github.com/sitar93/krono_metamodule.git
cd krono_metamodule
git submodule update --init --recursive
```

If `metamodule-plugin-sdk` is not a submodule in your fork yet, add it per the [SDK installation instructions](https://github.com/4ms/metamodule-plugin-sdk/blob/main/README.md), then run `git submodule update --init --recursive` inside `metamodule-plugin-sdk/` as required.

Place **[krono_vcv](https://github.com/sitar93/krono_vcv)** next to this folder so that `../krono_vcv/plugin.json` exists, **or** adjust paths / use a single repo that contains both trees.

## Build (Windows)

1. Install MSYS2 and the ARM toolchain; ensure `arm-none-eabi-gcc` is on `PATH`, **or** set `TOOLCHAIN_BASE_DIR` to the toolchain `bin` directory (see `build_metamodule.cmd`).
2. Run **`build_metamodule.cmd`** (edit `MSYS_ROOT` inside if MSYS2 is not under `C:\msys64`).
3. Output: **`metamodule-plugins/Krono.mmplugin`**.

For a full reconfigure from scratch you can set `KRONO_MM_BUILD_ARGS=fresh` before calling the script (see comments in `build_metamodule.cmd`).

## Clean build artifacts

**`clean_metamodule.cmd`** removes **`build/`** and **`.cache/`** only. It does **not** delete `metamodule-plugins/Krono.mmplugin` or the SDK.

## GitHub release checklist

1. Bump version in **`../krono_vcv/plugin.json`** (and `CMakeLists.txt` `project(VERSION ...)` if you keep them in sync).
2. Rebuild **`Krono.mmplugin`**; test on hardware when available (see [MetaModule hardware testing](#metamodule-hardware-testing) above) or on a simulator if you use one.
3. Create a **tag** (e.g. MetaModule packaging **`v1.0.0`**) and a **Release**; upload **`Krono-v1.0.0.mmplugin`** (and checksum) from **`releases/`**, or rename **`metamodule-plugins/Krono.mmplugin`** to match **`Krono-vX.Y.Z.mmplugin`**.
4. To appear on the official plugin list, contact 4ms (see **Publishing on metamodule.info** below).
5. In the release notes, link [krono_metamodule](https://github.com/sitar93/krono_metamodule), [krono_vcv](https://github.com/sitar93/krono_vcv), [krono](https://github.com/sitar93/krono) (firmware reference), and [jolin.tech/krono](https://jolin.tech/krono).

## Publishing on metamodule.info

The official plugin directory is **[metamodule.info/plugins](https://metamodule.info/plugins)**. 4ms does **not** host your repo: you publish the **`.mmplugin` on GitHub Releases**, then ask them to list it.

**Steps (free plugin):**

1. **[Create a GitHub Release](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository)** on [sitar93/krono_metamodule](https://github.com/sitar93/krono_metamodule): tag (e.g. `v1.0.0`), **do not** mark it as **pre-release** (pre-releases are ignored by their scanner).
2. Attach **`Krono-v1.0.0.mmplugin`** (and optionally the `.sha256`). The file name must follow **`[BrandSlug]-v[version].mmplugin`** — see [Releasing a plugin](https://github.com/4ms/metamodule-plugin-sdk/blob/main/docs/release.md) in the MetaModule Plugin SDK docs.
3. Ensure **`plugin-mm.json`** is complete (maintainer, description, modules); add **`MetaModulePluginMaintainerEmail`** if you want to match the [documented example](https://github.com/4ms/metamodule-plugin-sdk/blob/main/docs/release.md) exactly.
4. Email **4ms@4mscompany.com** or post on the **[MetaModule forum](https://forum.4ms.info/)** with the **URL of your GitHub repository** (they use Releases to detect updates).

**References:** [docs/release.md](https://github.com/4ms/metamodule-plugin-sdk/blob/main/docs/release.md) · [Licensing and permissions](https://github.com/4ms/metamodule-plugin-sdk/blob/main/docs/licensing_permissions.md)

## License

This project’s Krono-specific build metadata and scripts are under **[CC BY-NC-SA 4.0](LICENSE)**. The **MetaModule Plugin SDK** retains its own licenses inside **`metamodule-plugin-sdk/`**. Krono DSP/UI source is in **[krono_vcv](https://github.com/sitar93/krono_vcv)** under the same SPDX license string as that repo’s `plugin.json`.

## Links

| Resource | URL |
|----------|-----|
| This repository | https://github.com/sitar93/krono_metamodule |
| MetaModule Plugin SDK | https://github.com/4ms/metamodule-plugin-sdk |
| Krono VCV Rack source | https://github.com/sitar93/krono_vcv |
| Krono Eurorack firmware / docs | https://github.com/sitar93/krono |
| Jolin | https://jolin.tech |
