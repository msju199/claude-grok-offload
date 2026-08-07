#!/usr/bin/env bash
# cgo-env — state file helpers for claude-grok-offload
# Keys: CGO_SANDBOX · CGO_SANDBOX_WRITE · CGO_STAGING
# Design: §4.5 state file under ${CLAUDE_PLUGIN_DATA}/cgo-env

# Default data dir when CLAUDE_PLUGIN_DATA is unset.
cgo_data_dir() {
  if [[ -n "${CLAUDE_PLUGIN_DATA:-}" ]]; then
    printf '%s\n' "$CLAUDE_PLUGIN_DATA"
  else
    printf '%s\n' "${HOME}/.claude/plugins/data/claude-grok-offload"
  fi
}

cgo_env_path() {
  printf '%s/cgo-env\n' "$(cgo_data_dir)"
}

# Remove the state file (Ready:no / invalid).
cgo_env_clear() {
  local path
  path="$(cgo_env_path)"
  rm -f "$path"
}

# Write or replace KEY=VAL. Usage: cgo_env_write KEY=VAL  OR  cgo_env_write KEY VAL
cgo_env_write() {
  local key val path dir tmp
  if [[ $# -lt 1 ]]; then
    echo "cgo_env_write: KEY=VAL required" >&2
    return 2
  fi
  if [[ "$1" == *=* ]]; then
    key="${1%%=*}"
    val="${1#*=}"
  else
    if [[ $# -lt 2 ]]; then
      echo "cgo_env_write: KEY VAL required" >&2
      return 2
    fi
    key="$1"
    val="$2"
  fi
  if [[ -z "$key" || "$key" == *"="* ]]; then
    echo "cgo_env_write: invalid key" >&2
    return 2
  fi
  dir="$(cgo_data_dir)"
  path="$(cgo_env_path)"
  mkdir -p "$dir"
  tmp="${path}.tmp.$$"
  if [[ -f "$path" ]]; then
    # Drop prior lines for this key (last write wins)
    grep -vE "^${key}=" "$path" >"$tmp" || true
  else
    : >"$tmp"
  fi
  printf '%s=%s\n' "$key" "$val" >>"$tmp"
  mv "$tmp" "$path"
}

# Print value for KEY; return 1 if missing.
cgo_env_read() {
  local key="$1" path line
  if [[ -z "$key" ]]; then
    return 2
  fi
  path="$(cgo_env_path)"
  if [[ ! -f "$path" ]]; then
    return 1
  fi
  line="$(grep -E "^${key}=" "$path" | tail -n 1 || true)"
  if [[ -z "$line" ]]; then
    return 1
  fi
  printf '%s\n' "${line#*=}"
}
