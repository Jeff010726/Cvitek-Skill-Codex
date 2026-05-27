# Local CV184X Build Workflow

Use this reference when working in `/home/jeff/projects/SDK_CV184X` or another repo with the same build layout.

## Validated Entry Files

- `build/README.md`
- `build/common_functions.sh`
- `build/envsetup_soc.sh`

## Validated Flow

1. Source the environment:

```sh
source build/envsetup_soc.sh
```

2. Enumerate or select boards with `defconfig`:

```sh
defconfig cv184x
defconfig <board-name>
```

3. If the task needs config edits, use:

```sh
menuconfig
menuconfig_kernel
menuconfig_uboot
```

4. Prefer targeted builds:

```sh
build_kernel
build_uboot
build_osdrv
build_middleware
```

5. For local rebuilds after source changes, use the paired clean/build target only when needed:

```sh
clean_uboot && build_uboot
clean_kernel && build_kernel
clean_osdrv && build_osdrv && pack_rootfs
clean_middleware && build_middleware && pack_rootfs
```

6. Packaging-related functions are part of the same shell-function surface:

```sh
pack_cfg
pack_rootfs
pack_data
pack_system
copy_tools
pack_upgrade
```

7. Use full build only for complete image generation:

```sh
build_all
```

8. Check output under:

```sh
install/soc_<project>
```

## Key Local Facts

- `defconfig()` and `menuconfig()` are provided by `build/common_functions.sh`.
- `build_all()` orchestrates kernel, u-boot, osdrv, middleware, packaging, and upgrade generation in `build/envsetup_soc.sh`.
- Board enumeration is backed by `build/scripts/boards_scan.py`, so prefer discovery over hardcoding board names.
- The repo README documents the expected high-level flow and example output layout.
- `build_all()` does not cover every packaging helper. Functions such as `pack_boot`, `pack_gpt`, `pack_pq`, and `pack_prog_img` remain explicit actions outside the default composed flow.
- CV184X documentation repeatedly uses board-specific paths under `build/boards/cv184x/<board>/...`; always verify the selected board directory before quoting exact filenames.
- Some partial-build guidance assumes at least one successful full build has already produced dependencies and output directories. Check current artifacts before promising a partial target is enough.

## Safe Usage Rules

- Do not recommend shell functions before the environment script is sourced.
- Do not guess board names when `defconfig <chip>` can enumerate them.
- Use targeted build functions unless the user explicitly needs a packaged full image.
- If the task is only about packaging, confirm the required build artifacts exist before jumping straight to `pack_*`.
- Do not mix top-level images in `install/soc_<project>` with raw images in `install/soc_<project>/rawimages`; burning tools may require one or the other.
- If README examples and live script behavior disagree, trust `envsetup_soc.sh`, `common_functions.sh`, and live `defconfig` output.
