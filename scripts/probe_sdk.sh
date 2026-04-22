#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: probe_sdk.sh [--path <dir>] [--boards-limit <n>]

Read-only probe for CVitek/Sophgo SDK repos.
Prints a compact summary that helps choose the right workflow and references.
EOF
}

target_dir="${PWD}"
boards_limit=8

while [[ $# -gt 0 ]]; do
  case "$1" in
    --path)
      [[ $# -ge 2 ]] || { echo "missing value for --path" >&2; exit 2; }
      target_dir="$2"
      shift 2
      ;;
    --boards-limit)
      [[ $# -ge 2 ]] || { echo "missing value for --boards-limit" >&2; exit 2; }
      boards_limit="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

[[ -d "$target_dir" ]] || { echo "path is not a directory: $target_dir" >&2; exit 2; }
[[ "$boards_limit" =~ ^[0-9]+$ ]] || { echo "boards limit must be an integer" >&2; exit 2; }

abspath() {
  local path="$1"
  if command -v realpath >/dev/null 2>&1; then
    realpath "$path"
  else
    cd "$path" && pwd -P
  fi
}

join_by() {
  local sep="$1"
  shift || true
  local out=""
  local item
  for item in "$@"; do
    if [[ -z "$out" ]]; then
      out="$item"
    else
      out="${out}${sep}${item}"
    fi
  done
  printf '%s' "$out"
}

bool_flag() {
  if [[ "$1" == "1" ]]; then
    printf 'yes'
  else
    printf 'no'
  fi
}

find_repo_root() {
  local dir="$1"
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/build/envsetup_soc.sh" || -f "$dir/build/common_functions.sh" || -f "$dir/build/README.md" || -d "$dir/build/boards" ]]; then
      printf '%s' "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

guess_family_from_name() {
  local value
  value="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
  if [[ "$value" == *cv184* ]]; then
    printf 'cv184x'
  elif [[ "$value" == *cv181* ]]; then
    printf 'cv181x'
  elif [[ "$value" == *cv180* ]]; then
    printf 'cv180x'
  elif [[ "$value" == *cv186* ]]; then
    printf 'cv186'
  elif [[ "$value" == *bm1688* ]]; then
    printf 'bm1688'
  else
    printf 'unknown'
  fi
}

target_dir="$(abspath "$target_dir")"
repo_root=""
if repo_root="$(find_repo_root "$target_dir")"; then
  :
else
  repo_root=""
fi

has_repo_root=0
has_envsetup=0
has_common_functions=0
has_build_readme=0
has_boards_dir=0
has_boards_scan=0
repo_layout="unknown"
family_hint="unknown"
board_family_dirs=""
board_count="0"
board_sample=""
build_target_count="0"
build_targets_sample=""
menu_target_count="0"
menu_targets_sample=""
pack_target_count="0"
pack_targets_sample=""
recommended_reference="references/repo-workflow-common.md"
recommended_bootstrap="inspect local repo layout first"
next_step="inspect build entry files before proposing commands"
output_hint="repo-specific; confirm from README or build scripts"

if [[ -n "$repo_root" ]]; then
  has_repo_root=1

  [[ -f "$repo_root/build/envsetup_soc.sh" ]] && has_envsetup=1
  [[ -f "$repo_root/build/common_functions.sh" ]] && has_common_functions=1
  [[ -f "$repo_root/build/README.md" ]] && has_build_readme=1
  [[ -d "$repo_root/build/boards" ]] && has_boards_dir=1
  [[ -f "$repo_root/build/scripts/boards_scan.py" ]] && has_boards_scan=1

  if [[ "$has_envsetup" == "1" && "$has_common_functions" == "1" && "$has_build_readme" == "1" && "$has_boards_dir" == "1" ]]; then
    repo_layout="full-sdk"
  elif [[ "$has_envsetup" == "1" || "$has_common_functions" == "1" || "$has_boards_dir" == "1" ]]; then
    repo_layout="partial-build-tree"
  else
    repo_layout="component-or-unknown"
  fi

  if [[ "$has_boards_dir" == "1" ]]; then
    mapfile -t family_dirs < <(find "$repo_root/build/boards" -mindepth 1 -maxdepth 1 -type d ! -name default -printf '%f\n' | sort)
    if [[ "${#family_dirs[@]}" -gt 0 ]]; then
      board_family_dirs="$(join_by "," "${family_dirs[@]}")"
    fi

    mapfile -t board_dirs < <(find "$repo_root/build/boards" -mindepth 2 -maxdepth 2 -type d ! -path '*/default/*' -printf '%f\n' | sort)
    board_count="${#board_dirs[@]}"
    if [[ "${#board_dirs[@]}" -gt 0 ]]; then
      if (( boards_limit < ${#board_dirs[@]} )); then
        board_sample="$(join_by "," "${board_dirs[@]:0:boards_limit}")"
      else
        board_sample="$(join_by "," "${board_dirs[@]}")"
      fi
    fi
  fi

  if [[ "$has_envsetup" == "1" || "$has_common_functions" == "1" ]]; then
    mapfile -t build_targets < <(
      grep -hE '^function build_[a-zA-Z0-9_]+(\(\))?$' \
        "$repo_root/build/envsetup_soc.sh" "$repo_root/build/common_functions.sh" 2>/dev/null \
        | sed -E 's/^function ([^ (]+)(\(\))?$/\1/' | sort -u
    )
    mapfile -t menu_targets < <(
      grep -hE '^function (menuconfig(_[a-zA-Z0-9_]+)?|defconfig|olddefconfig|oldconfig)(\(\))?$' \
        "$repo_root/build/envsetup_soc.sh" "$repo_root/build/common_functions.sh" 2>/dev/null \
        | sed -E 's/^function ([^ (]+)(\(\))?$/\1/' | sort -u
    )
    mapfile -t pack_targets < <(
      grep -hE '^function (pack_[a-zA-Z0-9_]+|copy_tools)(\(\))?$' \
        "$repo_root/build/envsetup_soc.sh" "$repo_root/build/common_functions.sh" 2>/dev/null \
        | sed -E 's/^function ([^ (]+)(\(\))?$/\1/' | sort -u
    )

    build_target_count="${#build_targets[@]}"
    menu_target_count="${#menu_targets[@]}"
    pack_target_count="${#pack_targets[@]}"

    if [[ "${#build_targets[@]}" -gt 0 ]]; then
      if (( boards_limit < ${#build_targets[@]} )); then
        build_targets_sample="$(join_by "," "${build_targets[@]:0:boards_limit}")"
      else
        build_targets_sample="$(join_by "," "${build_targets[@]}")"
      fi
    fi
    if [[ "${#menu_targets[@]}" -gt 0 ]]; then
      if (( boards_limit < ${#menu_targets[@]} )); then
        menu_targets_sample="$(join_by "," "${menu_targets[@]:0:boards_limit}")"
      else
        menu_targets_sample="$(join_by "," "${menu_targets[@]}")"
      fi
    fi
    if [[ "${#pack_targets[@]}" -gt 0 ]]; then
      if (( boards_limit < ${#pack_targets[@]} )); then
        pack_targets_sample="$(join_by "," "${pack_targets[@]:0:boards_limit}")"
      else
        pack_targets_sample="$(join_by "," "${pack_targets[@]}")"
      fi
    fi
  fi

  if [[ -n "$board_family_dirs" ]]; then
    if [[ "$board_family_dirs" == *","* ]]; then
      family_hint="multi-family"
    else
      family_hint="$board_family_dirs"
    fi
  else
    family_hint="$(guess_family_from_name "$(basename "$repo_root")")"
  fi

  case "$family_hint" in
    cv184x)
      recommended_reference="references/local-cv184x-build.md"
      recommended_bootstrap="source build/envsetup_soc.sh"
      next_step="run defconfig <chip|board>, then prefer targeted build_* functions"
      output_hint="install/soc_*"
      ;;
    cv180x|cv181x)
      recommended_reference="references/family-180x-181x.md"
      recommended_bootstrap="inspect repo and source build/envsetup_soc.sh if present"
      next_step="confirm repo entrypoints, then use defconfig instead of guessing boards"
      ;;
    cv186|bm1688)
      recommended_reference="references/family-cv186-bm1688.md"
      recommended_bootstrap="inspect repo layout before assuming CV184X-style commands"
      next_step="stay in discovery mode until envsetup, boards, and build functions are confirmed"
      ;;
    multi-family)
      recommended_reference="references/repo-workflow-common.md"
      recommended_bootstrap="source the repo environment only after confirming the target family"
      next_step="pick the target family first, then follow that family's reference"
      ;;
    *)
      if [[ "$has_envsetup" == "1" ]]; then
        recommended_reference="references/repo-workflow-common.md"
        recommended_bootstrap="source build/envsetup_soc.sh"
        next_step="inspect defconfig and available build_* targets before acting"
      fi
      ;;
  esac
fi

printf 'target_dir: %s\n' "$target_dir"
printf 'repo_root_found: %s\n' "$(bool_flag "$has_repo_root")"
printf 'repo_root: %s\n' "${repo_root:-not-found}"
printf 'repo_layout: %s\n' "$repo_layout"
printf 'has_envsetup_soc: %s\n' "$(bool_flag "$has_envsetup")"
printf 'has_common_functions: %s\n' "$(bool_flag "$has_common_functions")"
printf 'has_build_readme: %s\n' "$(bool_flag "$has_build_readme")"
printf 'has_boards_dir: %s\n' "$(bool_flag "$has_boards_dir")"
printf 'has_boards_scan: %s\n' "$(bool_flag "$has_boards_scan")"
printf 'family_hint: %s\n' "$family_hint"
printf 'board_family_dirs: %s\n' "${board_family_dirs:-none}"
printf 'board_count: %s\n' "$board_count"
printf 'board_sample: %s\n' "${board_sample:-none}"
printf 'menu_target_count: %s\n' "$menu_target_count"
printf 'menu_targets_sample: %s\n' "${menu_targets_sample:-none}"
printf 'build_target_count: %s\n' "$build_target_count"
printf 'build_targets_sample: %s\n' "${build_targets_sample:-none}"
printf 'pack_target_count: %s\n' "$pack_target_count"
printf 'pack_targets_sample: %s\n' "${pack_targets_sample:-none}"
printf 'recommended_reference: %s\n' "$recommended_reference"
printf 'recommended_bootstrap: %s\n' "$recommended_bootstrap"
printf 'next_step: %s\n' "$next_step"
printf 'output_hint: %s\n' "$output_hint"
