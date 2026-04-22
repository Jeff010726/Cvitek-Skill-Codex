# Common Repo Workflow

Use this reference when the user is operating inside a local CVitek or Sophgo SDK repo and the repo needs to be classified before recommending commands.

## Repo Triage

Start with the bundled probe script when you have filesystem access:

```sh
scripts/probe_sdk.sh
scripts/probe_sdk.sh --path /path/to/repo
```

Check for these first:

- `build/envsetup_soc.sh`
- `build/common_functions.sh`
- `build/README.md`
- `build/boards/`
- top-level `Makefile` or build subdirectories such as `linux_*`, `u-boot-*`, `osdrv`, `ramdisk`, `cvi_mpi`

These signals usually tell you:

- whether the repo is a full SDK checkout or only a subcomponent
- whether the build entrypoints are shell functions or plain make targets
- whether board discovery is centralized or fragmented

The probe output is designed to answer the same questions quickly:

- `repo_layout` tells you whether the checkout looks like a full SDK or only part of one.
- `family_hint` tells you whether the repo looks like `cv184x`, `cv180x`, `cv181x`, `cv186`, `bm1688`, or a multi-family tree.
- `recommended_reference` tells you which bundled reference to read next.
- `menu_targets_sample`, `build_targets_sample`, and `pack_targets_sample` tell you whether the shell-function workflow is actually present.

## Default Operating Order

1. Find the repo root.
2. Run the probe script and read the build entry README and environment script.
3. Prefer board discovery and `defconfig` over guessing board names.
4. Prefer targeted builds over a full build.
5. Only suggest packaging after the build surface is confirmed.

## Build Hygiene

- Avoid defaulting to `clean_all`.
- Avoid defaulting to `build_all`.
- Do not assume a family-specific output path until the repo confirms it.
- When a task is limited to one component, stay local to that component.
- When a probe already shows the needed build targets, use that to narrow the next command instead of reading the entire tree blindly.
- If a repo is managed by a manifest helper such as `repo_clone.sh`, inspect its refresh mode before recommending it. Public Sophgo helpers may perform `git clean -dfx` and hard resets during pull-style operations.

## Failure Classification

Classify failures before suggesting fixes:

- environment setup: missing `source`, missing exported vars, wrong shell context
- board selection: unknown board, defconfig mismatch, missing board folder
- toolchain: missing compiler prefix, wrong host tools, bad sysroot
- component build: kernel, u-boot, middleware, osdrv, or userspace target failure
- packaging: rootfs, data, system image, or upgrade package generation failure

The goal is to narrow the stage first, then read the closest source file or script that owns that stage.
