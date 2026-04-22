# CVitek SDK Skill for Codex

This repository contains a Codex skill for working with CVitek and Sophgo SDKs.

The skill is designed to help inspect local SDK checkouts, identify chip families,
locate the correct build entrypoints, and guide safer next steps for board
selection, targeted builds, packaging, and first-pass failure diagnosis.

## Covers

- CV180X
- CV181X
- CV184X
- CV186
- BM1688

## Repository Layout

```text
.
├── SKILL.md
├── agents/
├── references/
└── scripts/
```

- `SKILL.md`: trigger metadata and core workflow
- `agents/openai.yaml`: UI-facing metadata
- `references/`: family-specific notes and workflow references
- `scripts/probe_sdk.sh`: local SDK probe script used for repo triage

## What The Skill Does

- Detect whether a local checkout looks like a full CVitek or Sophgo SDK
- Inspect the repo before making assumptions about build flow
- Prefer `defconfig`-based board discovery over hardcoded board guesses
- Prefer targeted `build_*` commands over full rebuilds
- Separate repo triage, build guidance, packaging guidance, and documentation lookup

## Quick Start

Clone this repository into your Codex skills directory as `cvitek-sdk`:

```bash
git clone https://github.com/Jeff010726/Cvitek-Skill-Codex.git ~/.codex/skills/cvitek-sdk
```

Then use it in Codex with:

```text
$cvitek-sdk 帮我看看这份 sdk
```

Or for a more specific task:

```text
$cvitek-sdk 帮我确认这份 SDK 应该先 source 哪个 envsetup，再列出可选板型
```

## Notes

- The runtime behavior is defined by `SKILL.md`.
- The references are loaded on demand to keep the active context small.
- The probe script is intended to be run against a local SDK checkout, not this repository itself.
