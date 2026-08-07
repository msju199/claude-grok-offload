# Reverse checks (Grok orchestrates → Claude headless checker)

**Document only.** This product ships Grok-as-checker contracts (`grill` / `verify` / `judge` / …).  
When **Grok is the orchestrator** that *wrote* a design or plan, maker≠checker still requires a **separate session** checker. The natural reverse is Claude Code headless — **not implemented as product scripts** in this repository.

## Why reverse exists

Independence is primarily **session / context separation**, not “different vendor.”  
Same-session self-review is weaker than a fresh session review. Vendor diversity alone is not a substitute for that separation.

## What operators should do

1. Keep Grok product modes for Claude-orchestrated work (this plugin).  
2. When Grok TUI/headless authored the artifact, run a **Claude** read-only check in a **new** process with plan/permission locks.  
3. Do not treat reverse Claude checks as a substitute for product RO sandbox keys (`$CGO_SANDBOX`).

## Suggested Claude headless shape (operator-owned)

These flags are illustrative; pin versions and tool names to your Claude Code release:

```bash
# Adversarial design review (mirror of product grill intent)
cd /tmp && claude -p "$(cat <<'EOF'
You did not author this design. Assume defects. Read-only — report findings and stop.
Target: /absolute/path/to/design.md
SSOT: /absolute/path/to/source1 ...
Score fact contrast, side effects, disposition gaps, internal consistency.
Verdict: PASS or REVISE.
EOF
)" --permission-mode plan \
  --disallowedTools "Edit,Write,NotebookEdit,Bash,MultiEdit,WebSearch,WebFetch"
```

```bash
# Plan / code / fact verify (mirror of product verify intent)
cd /tmp && claude -p "Verify (plan|code|fact): /path/to/target. Read-only. PASS or REVISE with evidence." \
  --permission-mode plan \
  --disallowedTools "Edit,Write,NotebookEdit,Bash,MultiEdit,WebSearch,WebFetch"
```

Notes:

- Prefer `cd` to a neutral directory so accidental relative writes are less harmful; still use permission-mode + disallowed tools.  
- **Auto-run is not recommended** for reverse Claude on Max plans — reverse is high-cost; invoke deliberately.  
- Host deny-gates that require “grill evidence before code” are **out of product scope** (documented maker≠checker only).

## What this repo does *not* ship

- `claude-grill` / `claude-verify` executable wrappers  
- Log detectors that accept reverse evidence for host gates  
- Hardcoded personal principle files for reverse axis-5 scoring  

Operators who need reverse automation keep it in their private harness.
