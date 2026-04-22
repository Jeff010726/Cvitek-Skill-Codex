# CV180X And CV181X

Use this reference when the user is targeting `cv180x` or `cv181x`, or asks for toolchain, SDK, HDK, or TPU SDK entrypoints for those families.

## Source Material

This reference is derived from `/home/jeff/projects/cvitek-skill/sdk-details.md` and the official pages:

- `https://developer.sophgo.com/thread/471.html`
- `https://developer.sophgo.com/thread/472.html`
- `https://github.com/sophgo/sophpi`

## Downloads And Docs

- Toolchain: `https://sophon-file.sophon.cn/sophon-prod-s3/drive/23/03/07/16/host-tools.tar.gz`
- SDK repo: `https://github.com/sophgo/sophpi`
- SDK docs: `https://developer.sophgo.com/thread/471.html`
- HDK docs: `https://developer.sophgo.com/thread/472.html`
- TPU SDK docs: `https://developer.sophgo.com/thread/473.html`

## Software Document Catalog Visible On The Official SDK Page

The official software document index exposes at least these topics, each with Chinese and English `html` and `pdf` variants unless noted otherwise:

- `CIPHER API 使用手册`
- `IVE API 使用手册`
- `LDC调试使用手册`
- `MIPI 使用手册`
- `Sensor 调试使用手册`
- `开机画面使用手册`
- `MPI 媒体软件开发使用手册`
- `屏幕对接使用手册`
- `处理器码率控制使用手册`
- `智能编码使用手册`
- `音频质量调试使用手册`
- `SDK 编译使用手册`
- `Flash 分区工具使用手册`
- `eFuse 使用手册`
- `Linux 开发环境使用手册`
- `SDK 网络安全二次开发使用手册`
- `SPINAND 烧录器预烧使用手册`
- `U-BOOT 移植使用手册`
- `Wi-Fi 使用手册`
- `安全启动使用手册`
- `外围设备驱动使用手册`
- `RTC 使用手册`
- `ISP 开发使用手册`
- `ISP 图像调优使用手册`
- `ISP 图像质量调试工具使用手册`
- `MIPI 屏幕时钟时序计算器`
- `量产烧写使用手册`
- `软件 CviSysLink 使用手册`
- `下载所有文档`

## Hardware Package Catalog Visible On The Official HDK Page

The official HDK page lists these package families and both Chinese and English zip archives:

- `CV180xB_QFN68`
- `CV180xC_QFN88`
- `CV181xC_QFN88`
- `CV181xH_BGA205`

## Public sophpi Bootstrap Evidence

The public `sophpi` `sg200x-evb` branch README shows that CV180X and CV181X do not have one single public bootstrap path.

Documented flows visible in the README:

- `V410 SDK`
  - clone `sophpi` on branch `sg200x-evb`
  - run `./sophpi/scripts/repo_clone.sh --gitclone sophpi/scripts/subtree.xml`
  - bootstrap with `source build/envsetup_soc.sh`
  - example board: `defconfig sg2002_wevb_riscv64_sd`
- `V420 SDK`
  - clone `sophpi` on branch `sg200x-evb`
  - run `./sophpi/scripts/repo_clone.sh --gitclone sophpi/scripts/subtree_cv18xx-v4.2.x.xml`
  - bootstrap with `source build/envsetup_soc.sh`
  - example board: `defconfig cv180zb_wevb_0008a_spinor`

This means the skill should classify CV180X and CV181X checkouts by manifest or repo shape before presenting one canonical workflow.

## repo_clone.sh Behaviors That Matter

The public `repo_clone.sh` script supports:

- `--gitclone`
- `--gitpull`
- `--normal`
- `--reproduce`

Important boundaries:

- `--reproduce` is the safest documented route when the user wants to match a published manifest state exactly.
- `--gitpull` is not a light refresh. The script uses `git checkout .`, `git clean -dfx .`, `git fetch`, and branch hard reset logic in each managed repo.
- Official bootstrap examples use `git@github.com:sophgo/...`, so SSH access may be required unless manifests are rewritten.

## How To Use This Reference In The Skill

- Use the SDK page as the document catalog for software bring-up, BSP, MPI, security, ISP, screen, storage, and production-flow questions.
- Use the HDK page when the user needs package-level board hardware documents rather than software manuals.
- Use the TPU SDK reference separately; do not mix TPU model-conversion guidance into the BSP workflow unless the user is explicitly crossing into TPU work.

## Working Rules

- Treat these URLs as entrypoints, not proof that the local repo workflow matches CV184X exactly.
- If a local repo exists, inspect it before recommending build commands.
- If the repo exposes `build/envsetup_soc.sh`, `defconfig`, and `build_*` functions, reuse the common workflow reference.
- If the repo shape differs, classify the difference first and keep recommendations local to what is actually present.

## What To Avoid

- Do not assume `build_all` is the right default.
- Do not infer board names, output paths, or packaging steps from the CV184X repo without verification.
- Do not assume every document visible on the official index exists in the local repo checkout.
- Do not assume `git clone sophpi` alone gives a buildable SDK tree.
