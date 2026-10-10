#!/usr/bin/env bash
# worktree-prepare.sh — non-temp path + basic create
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$PLUGIN_ROOT/../.." && pwd)"
WT_PREP="$PLUGIN_ROOT/scripts/worktree-prepare.sh"

pass=0
fail=0

assert_true() {
  local name="$1"
  if eval "$2"; then
    pass=$((pass + 1))
  else
    echo "FAIL [$name]" >&2
    fail=$((fail + 1))
  fi
}

assert_exit() {
  local name="$1" want="$2" got="$3"
  if [[ "$want" == "$got" ]]; then
    pass=$((pass + 1))
  else
    echo "FAIL [$name]: exit want=$want got=$got" >&2
    fail=$((fail + 1))
  fi
}

# worktree-prepare rejects every path under /tmp or /private/tmp, including
# the default <repo>/.cgo-worktrees. A mktemp fixture (Linux CI /tmp, or
# macOS when TMPDIR is /tmp) makes that default root look temporary and
# case 1 exits 1. Build the fixture outside those roots and always remove it.
under_temp_root() {
  case "$1" in
    /tmp|/tmp/*|/private/tmp|/private/tmp/*)
      return 0
      ;;
    /var/folders|/var/folders/*|/private/var/folders|/private/var/folders/*)
      return 0
      ;;
  esac
  return 1
}

physical_dir() {
  (cd "$1" && pwd -P)
}

pick_fixture_parent() {
  local candidate physical nongit="" gitparent=""
  # Prefer $HOME so the fixture is not nested in this checkout. A directory
  # under the checkout is the fallback when HOME is missing or temporary.
  for candidate in "${HOME:-}" "$REPO_ROOT" "$PLUGIN_ROOT"; do
    [[ -n "$candidate" && -d "$candidate" && -w "$candidate" ]] || continue
    physical="$(physical_dir "$candidate")" || continue
    under_temp_root "$physical" && continue
    # A parent git repo would make "$TMP/notgit" look like a work tree.
    if git -C "$physical" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      [[ -z "$gitparent" ]] && gitparent="$physical"
      continue
    fi
    nongit="$physical"
    break
  done
  if [[ -n "$nongit" ]]; then
    printf '%s\n' "$nongit"
    return 0
  fi
  if [[ -n "$gitparent" ]]; then
    printf '%s\n' "$gitparent"
    return 0
  fi
  echo "test-worktree: no non-temp parent for the fixture repo" >&2
  return 1
}

FIXTURE_PARENT="$(pick_fixture_parent)"
TMP="$(mktemp -d "${FIXTURE_PARENT}/.cgo-wt-test.XXXXXX")"
trap 'rm -rf "$TMP"' EXIT
# Keep git discovery inside the fixture even if the parent is a repository
# (checkout fallback, or a dotfiles HOME).
export GIT_CEILING_DIRECTORIES="$TMP"

# Fixture repo
REPO="$TMP/sample-repo"
mkdir -p "$REPO"
git -C "$REPO" init -q
git -C "$REPO" config user.email "test@example.com"
git -C "$REPO" config user.name "test"
printf 'hello\n' >"$REPO/README.md"
git -C "$REPO" add README.md
git -C "$REPO" commit -qm "init"
assert_true "fixture-outside-temp" "! under_temp_root \"$TMP\""

# Case 1: worktree under repo/.cgo-worktrees
set +e
out1="$("$WT_PREP" "$REPO" 2>&1)"
rc1=$?
set -e
assert_exit "case1-exit" "0" "$rc1"
assert_true "case1-path-exists" "[[ -d \"$out1\" ]]"
assert_true "case1-has-marker" "[[ \"$out1\" == *\".cgo-worktrees\"* ]]"
# macOS may print /private/var/... — require .cgo-worktrees segment and that parent is the repo tree
assert_true "case1-under-repo" "[[ \"$(basename "$(dirname "$out1")")\" == \".cgo-worktrees\" ]]"
repo_base="$(basename "$REPO")"
assert_true "case1-repo-name" "[[ \"$out1\" == *\"/${repo_base}/.cgo-worktrees/\"* ]]"

# Case 2: CGO_WORKTREE_ROOT under a temp root must fail
# Force /tmp root (product must refuse — sandbox temp rules)
export CGO_WORKTREE_ROOT="/tmp/cgo-worktree-test-$$"
set +e
out2="$("$WT_PREP" "$REPO" 2>&1)"
rc2=$?
set -e
assert_exit "case2-temp-root-fail" "1" "$rc2"
assert_true "case2-msg" "printf '%s' \"$out2\" | grep -qi temp"
unset CGO_WORKTREE_ROOT
rm -rf "/tmp/cgo-worktree-test-$$" 2>/dev/null || true

# Case 3: missing repo
set +e
out3="$("$WT_PREP" "$TMP/no-such-repo" 2>&1)"
rc3=$?
set -e
assert_exit "case3-missing" "1" "$rc3"

# Case 4: non-git dir
mkdir -p "$TMP/notgit"
set +e
out4="$("$WT_PREP" "$TMP/notgit" 2>&1)"
rc4=$?
set -e
assert_exit "case4-nongit" "1" "$rc4"

# Case 5: usage
set +e
out5="$("$WT_PREP" 2>&1)"
rc5=$?
set -e
assert_exit "case5-usage" "2" "$rc5"

if [[ "$fail" -gt 0 ]]; then
  echo "FAILED: $fail assertion(s), $pass passed" >&2
  exit 1
fi
echo "OK test-worktree ($pass assertions)"
exit 0
