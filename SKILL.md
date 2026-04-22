---
name: cvitek-sdk
description: Use when working with CVitek or Sophgo SDKs for cv180x, cv181x, cv184x, cv186, or BM1688, including toolchain and documentation lookup, repo triage, board defconfig and menuconfig flows, targeted build_* actions, output discovery, and cautious diagnosis of SDK build workflows.
---

# CVitek SDK

## When To Use

Use this skill when the user is working with a CVitek or Sophgo SDK, wants to find the right SDK or HDK materials for a chip family, or needs help navigating an SDK repo for board selection, build entrypoints, packaging, or first-pass failure diagnosis.

## First Checks

1. If a local repo is present, run `scripts/probe_sdk.sh` first from the current directory or with `--path <dir>`.
2. Use the probe output to classify the repo before proposing commands.
3. Prefer local repo inspection over static assumptions. Look first for:
   - `build/envsetup_soc.sh`
   - `build/common_functions.sh`
   - `build/README.md`
   - `build/boards/`
4. If `build/envsetup_soc.sh` exists, treat the repo as the primary source of truth.
5. If the repo shape is unclear or there is no local SDK checkout, route by chip family and load the matching reference file.

## Core Workflow

For repo-based work, follow this order unless the repo clearly requires another flow:

1. Identify the SDK family and repo entrypoints.
2. Run `scripts/probe_sdk.sh` and interpret `family_hint`, `recommended_reference`, and the available target samples.
3. Source the environment script before reasoning about shell functions.
4. Use `defconfig <chip|board>` to enumerate or select targets.
5. Prefer targeted `build_*` functions over `build_all`.
6. Use `menuconfig` only when the task actually requires config edits.
7. Check `install/` or the repo-specific output directory for generated artifacts.
8. When builds fail, classify the failure by stage before proposing fixes.

For documentation-heavy requests:

1. Load [references/source-map.md](references/source-map.md) first to map the user request to the right official family entrypoints.
2. Load the matching family reference to see the document catalog that is visible on the official index page.
3. Load [references/tpu-sdk-common.md](references/tpu-sdk-common.md) whenever the task involves TPU model conversion, TPU runtime, docker setup, or TPU sample packages.
4. Keep dynamic download details conservative when an official page says versions or package names can change.

Default safety rules:

- Do not assume all CVitek or Sophgo families share the same workflow.
- Do not default to `clean_all` or `build_all` unless the user explicitly wants a full rebuild or packaging pass.
- If a family is only partially documented in this skill, stay in discovery mode and avoid strong assumptions.

## Load These References

- Run [scripts/probe_sdk.sh](scripts/probe_sdk.sh) first for local repo triage.
- Load [references/source-map.md](references/source-map.md) when the task originates from `sdk-details.md` or starts from official entrypoint selection.
- Load [references/repo-workflow-common.md](references/repo-workflow-common.md) for shared repo triage, build hygiene, and failure classification rules.
- Load [references/local-cv184x-build.md](references/local-cv184x-build.md) when the local repo matches the CV184X-style `envsetup + defconfig + build_*` workflow.
- Load [references/family-180x-181x.md](references/family-180x-181x.md) for cv180x or cv181x download and documentation entrypoints.
- Load [references/family-184x.md](references/family-184x.md) for cv184x materials and the strongest currently validated local workflow pattern.
- Load [references/family-cv186-bm1688.md](references/family-cv186-bm1688.md) for CV186 or BM1688 entrypoints, but keep assumptions conservative until a real repo confirms the workflow.
- Load [references/tpu-sdk-common.md](references/tpu-sdk-common.md) for TPU SDK documents, docker, TPU-MLIR, runtime package selection, and sample/model package rules.
