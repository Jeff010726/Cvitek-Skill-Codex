# Common TPU SDK Reference

Use this reference when the user needs TPU SDK materials for CV-series chips, including model conversion, docker setup, runtime packages, or sample/model bundles.

## Primary Source

- Official index: `https://developer.sophgo.com/thread/473.html`

This page was live-checked on 2026-04-21 and should still be re-checked if download details matter.

## What The Official Thread Provides

### 1. Documentation

The thread explicitly lists these documentation entries:

- `CVITEK_TPU_SDK开发指南`
- `TPU-MLIR开发参考手册`
- `TPU-MLIR快速入门指南`
- `TPU-MLIR Quick_Start`
- `TPU-MLIR Technical_Reference_Manual`

The thread states that TPU-MLIR documentation can also be read from the extracted `docs/` directory inside the TPU-MLIR package.

### 2. Docker Environment For Model Conversion

The thread says model conversion should be done inside the provided docker environment.

Documented options:

- load a downloaded image tarball such as `docker_tpuc_dev_v2.2.tar.gz`
- or pull from Docker Hub:
  `docker pull sophgo/tpuc_dev:latest`

The page warns that docker version suffixes can change over time.

### 3. TPU-MLIR Conversion Tool

The thread describes:

- the packaged `tpu-mlir` archive name contains a frequently changing version string
- the tool can also be fetched from:
  `https://github.com/sophgo/tpu-mlir/tags`
- documentation is available both from the official download area and from the extracted package itself

### 4. Runtime And Samples For Boards

The thread documents these package families:

- `cvitek_tpu_samples.tar.gz`
  sample program code, not board-specific
- `cvitek_tpu_sdk_cv18xx(处理器型号)_xxx(文件系统).tar.gz`
  board runtime SDK package
- `cvimodel_samples_cv18xx(处理器型号).tar.gz`
  sample model files

The page explicitly warns that the exact processor model and filesystem variant must match the board.

## Safety Rules

- Do not hardcode TPU package names without verifying the exact chip and filesystem.
- Do not assume TPU-MLIR package versions are stable; the thread says version strings change often.
- If a local SDK repo is present, use it to confirm runtime integration points after using this thread for downloads and tool selection.
- If precise credentials or download endpoints matter, re-open the official thread instead of trusting a cached copy.
