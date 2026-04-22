# CV184X

Use this reference when the user targets `cv184x`, or when the local SDK repo looks like the validated CV184X-style build system.

## Source Material

This reference combines `/home/jeff/projects/cvitek-skill/sdk-details.md`, the official pages:

- `https://developer.sophgo.com/thread/813.html`
- `https://developer.sophgo.com/thread/822.html`
- `https://github.com/sophgo/sophpi`

and the validated local repo at `/home/jeff/projects/SDK_CV184X`.

## Downloads And Docs

- Toolchain: `https://sophon-file.sophon.cn/sophon-prod-s3/drive/23/03/07/16/host-tools.tar.gz`
- SDK repo: `https://github.com/sophgo/sophpi`
- SDK docs: `https://developer.sophgo.com/thread/813.html`
- HDK docs: `https://developer.sophgo.com/thread/822.html`
- TPU SDK docs: `https://developer.sophgo.com/thread/473.html`

## Software Document Catalog Visible On The Official SDK Page

The official CV184X software page exposes these document entrypoints:

- `LDC调试使用手册`
- `Linux 开发环境使用手册`
- `MIPI 使用手册`
- `SDK 网络安全二次开发使用手册`
- `Sensor 调试使用手册`
- `SPINAND 烧录器预烧使用手册`
- `开机画面使用手册`
- `U-BOOT 移植使用手册`
- `MPI 媒体软件开发使用手册`
- `Wi-Fi 使用手册`
- `屏幕对接使用手册`
- `安全启动使用手册`
- `处理器码率控制使用手册`
- `外围设备驱动使用手册`
- `智能编码使用手册`
- `RTC 使用手册`
- `音频质量调试使用手册`
- `ISP 开发使用手册`
- `SDK 编译使用手册`
- `ISP 图像调优使用手册`
- `Flash 分区工具使用手册`
- `ISP 图像质量调试工具使用手册`
- `eFuse 使用手册`
- `量产烧写使用手册`
- `GFBG 开发指南`
- `AliOS 编译和使用手册`
- `IPCM 客制化通信使用手册`
- `CIPHER API 使用手册`
- `下载所有文档`

## Hardware Package Catalog Visible On The Official HDK Page

The official HDK page exposes these downloadable archive families:

- `CV184xC_QFN88.7z`
- `CV184xH_BGA205.7z`

## Public sophpi Bootstrap Evidence

The public `sophpi` `sg200x-evb` branch README shows this documented CV184X bootstrap example:

- clone `sophpi` on branch `sg200x-evb`
- run `./sophpi/scripts/repo_clone.sh --gitclone sophpi/scripts/subtree_cv184x-v6.x.xml`
- bootstrap with `source build/envsetup_soc.sh`
- example board: `defconfig cv1842cp_wevb_0015a_spinor`
- the README then shows `clean_all` and `build_all`, but the safer skill default remains targeted `build_*`

## Validated Repo Pattern

The local CV184X repo shows this pattern:

1. `source build/envsetup_soc.sh`
2. `defconfig <chip|board>`
3. optional `menuconfig`
4. targeted `build_*` functions
5. full `build_all` only when complete packaging is required
6. artifacts under `install/soc_*`

## When To Trust This Pattern

Trust this pattern when the repo contains:

- `build/envsetup_soc.sh`
- `build/common_functions.sh`
- `build/README.md`
- `build/boards/`

If these are missing or renamed, shift back to repo discovery mode before recommending commands.

## Priority Guidance

- Prefer `build_kernel`, `build_uboot`, `build_osdrv`, and other local targets over `build_all`.
- Use the repo files as the source of truth for exact board names and available build functions.
- If the user asks for a full firmware image or upgrade package, verify that the repo still exposes the packaging functions before proposing them.
- For documentation requests, answer from the official CV184X software and HDK catalogs first, then align the answer with the validated local repo if the question becomes repo-specific.
- If README snippets disagree with live `defconfig` output or the current scripts, trust the current repo.
