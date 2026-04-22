# CV186 And BM1688

Use this reference when the user is targeting `CV186` or `BM1688`.

## Source Material

This reference is derived from `/home/jeff/projects/cvitek-skill/sdk-details.md` and the official materials page:

- `https://developer.sophgo.com/site/index/material/101/all.html`

## Entry Point

- Materials page: `https://developer.sophgo.com/site/index/material/101/all.html`

## Materials Visible On The Official Page

The materials page currently exposes BM1688 and CV186AH SDK releases plus document entrypoints. Live-checked page content on 2026-04-21 included:

### Release Track Visible On The Page

The BM1688 and CV186AH materials hub currently exposes these version entrypoints:

- `v2.1.0`
- `v2.0.0`
- `v1.9.0`
- `v1.8.0`
- `v1.7.0`
- `v1.6.0`
- `v1.5.1`

### SDK Packages

- `sophonsdk_edge_v2.1_official_release`
  edge-side BM1688 and CV186AH SDK package
- `sophonsdk_v2.1_source_code`
  source bundle covering edge and device code
- `sophonsdk_device_v2.1_official_release`
  device-side BM1688 and CV186AH SDK package

### Development Documents

- `SDK使用手册`
- `BSP开发参考手册`
- `LIBSOPHON 使用手册`
- `BMLIB 开发参考手册`
- `BMRuntime 开发参考手册`
- `BMCV开发参考手册`
- `MULTIMEDIA用户指南`
- `多媒体客户常见问题手册`
- `Multimedia Manual 使用手册`
- `TPU-MLIR快速入门指南`
- `TPU-MLIR开发参考手册`
- `SAIL使用手册`

### Related Official Docker Materials

The separate Docker materials page also provides BM1688 and TPU toolchain images:

- `https://developer.sophgo.com/site/index/material/86/all.html`
- `Docker开发镜像 for BM1688 SDK`
- `工具链 docker 镜像 for TPU-MLIR`
- `工具链 docker 镜像 for NNTC`
- older Ubuntu-based SDK images

Use the BM1688 and CV186AH materials hub as the primary doc-and-package index, and use the Docker page when the task is specifically about environment images.

## Public sophpi Bootstrap Evidence

Public `sophpi` documentation currently shows two different CV186 or BM1688-style flows:

### A2 release flow on `sg200x-evb`

- clone `sophpi` on branch `sg200x-evb`
- run `./sophpi/scripts/repo_clone.sh --gitclone sophpi/scripts/subtree_a2_release.xml`
- bootstrap with `source build/envsetup_soc.sh`
- example target: `defconfig device_wevb_emmc`
- build path shown in the README: `clean_device_all` then `build_device_all`

### Older `cv186ah-evb` branch flow

- clone `sophpi` on branch `cv186ah-evb`
- run `./scripts/repo_clone.sh --gitclone scripts/subtree.xml`
- bootstrap with `source build/cvisetup.sh`
- example target: `defconfig cv186ah_wevb_emmc`
- build path shown in the branch README: `clean_all` then `build_all`

## How To Use This Reference

- Use this page as the official doc and package hub when the user is working on BM1688 or CV186AH and no local repo has been validated yet.
- Treat the visible SDK package names and versions as page snapshots, not permanent constants.
- If the task moves into model conversion or TPU runtime selection, also load the TPU SDK reference.
- Treat the public `sophpi` examples as documented flows, not locally validated truth.

## Working Rules

- The current seed material only provides a high-level entry page.
- Do not assume the repo layout, build entrypoints, or packaging flow match CV184X.
- If a local repo is available, inspect it first and decide whether it follows a recognizably similar `envsetup + defconfig + build_*` workflow.
- If no repo is available, keep the guidance at the documentation and download-entry level.

## Current Boundary

At the current validation level:

- support documentation routing
- support repo triage if a real checkout is present
- avoid strong automation assumptions until a representative CV186 or BM1688 repo has been validated
- do not assume one canonical public bootstrap flow, because the visible `sg200x-evb` and `cv186ah-evb` examples already differ
