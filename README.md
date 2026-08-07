# claude-grok-offload

**Claude Code plugin** that offloads grill / verify / judge / impl / fanout / sweep work to the **Grok CLI** with portable sandbox profiles and a Ready-state check.

MIT License · Independent community product · **Not affiliated with xAI**

---

## Install (supported path)

Marketplace / local plugin path only. **skills.sh is not a supported install** for this product.

```bash
# 1) Add marketplace or clone this repo, then install the plugin in Claude Code
#    (exact marketplace UI labels vary by Claude Code version)
/plugin marketplace add msju199/claude-grok-offload
/plugin install claude-grok-offload

# 2) Install portable sandbox fragments into ~/.grok/sandbox.toml
bash "${CLAUDE_PLUGIN_ROOT}/scripts/install-sandbox-profiles.sh"
# or after install: /claude-grok-offload:install-sandbox

# 3) Ready-state check (writes cgo-env under plugin data)
bash "${CLAUDE_PLUGIN_ROOT}/scripts/cgo-check.sh"
# expect: Ready: yes

# 4) First-run grill (no args → package fixture)
bash "${CLAUDE_PLUGIN_ROOT}/scripts/invoke-grok.sh" --mode grill
# or: /claude-grok-offload:grill
```

Requires: **Grok CLI** on `PATH` (or `GROK_BINARY`), authenticated SuperGrok/xAI account, **Claude Code** plugin host, `git`, `bash`. Optional: `rsync`.

---

## Peer comparison

| | **xAI Grok Build plugin (CC)** | **claude-grok-offload (this repo)** |
|--|-------------------------------|-------------------------------------|
| Publisher | xAI (peer / upstream ecosystem) | Independent (MIT) |
| Role | Official-ish Grok Build bridge for Claude Code | Portable **offload contracts** + sandbox install + Ready check |
| Sandbox | Host / product profiles as documented by xAI | Installs `cgo_ro` + `cgo_impl` fragments; runtime uses **`$CGO_SANDBOX` / `$CGO_SANDBOX_WRITE`** |
| Maker≠checker | Per xAI docs | **Documented** procedure + RO defaults — **no** host deny-hook shipped |
| Non-goals | — | No personal path recipes · no vault merge · no skills.sh install · no `read-only` built-in as product profile |

See [NOTICE](./NOTICE) and [THIRD_PARTY.md](./THIRD_PARTY.md).

---

## Security model

| Axis | Behavior |
|------|----------|
| RO modes (grill/verify/judge/fanout-R/sweep) | `--sandbox "$CGO_SANDBOX"` → prefer **`cgo_ro`**, else **`strict` + staging** |
| Write modes (impl / fanout-W) | `--sandbox "$CGO_SANDBOX_WRITE"` → **`cgo_impl`** when installed; **refuse-to-start** if key missing |
| Forbidden | Product never uses built-in sandbox name **`read-only`** as a Ready value |
| Staging | Paths outside portable grants are copied into a per-run dir under plugin data |
| Worktree / staging prepare | Non-temp paths only; staging **rejects hardlink** flags (`--link`, `-H`) |
| Secrets | Do not print secret values; deny globs live in installed fragments |
| Maker≠checker | **Documented tier** (procedure + RO). Operators who need hard gates wire them in their own harness |

---

## S1 definition (success smoke)

**S1** = first-run path a cold machine can complete without personal files:

1. Plugin installed  
2. `install-sandbox-profiles.sh` succeeds (or documents skip)  
3. `cgo-check.sh` prints **`Ready: yes`**  
4. `invoke-grok.sh --mode grill` with **no user path** stages `fixtures/first-run-design.md` and returns grill text  

Evidence for dogfood: Ready:yes + fixture grill output.

---

## Commands (slash)

| Command | Mode |
|---------|------|
| `check` | Ready-state machine |
| `install-sandbox` | Install `cgo_ro` / `cgo_impl` fragments |
| `grill` | Adversarial design review (RO; fixture if no path) |
| `verify` | plan / code / fact (RO) |
| `judge` | Option ranking (RO) |
| `impl` | Write impl (5-kan + worktree/staging); **user-invoked** |
| `fanout` | Parallel R/W; **user-invoked** |
| `sweep` | Batch audit from targets file; **user-invoked** |
| `heavy-burn` | Volume playbook; **user-only** |

Write/user-only commands set `disable-model-invocation: true` so the model does not auto-fire them.

---

## Layout

```
plugins/claude-grok-offload/
  commands/   prompts/   scripts/   sandbox/   fixtures/   tests/
docs/REVERSE.md          # reverse Claude checker — document only
examples/                # sweep-targets + fanout-jobs templates
```

State file: `${CLAUDE_PLUGIN_DATA:-~/.claude/plugins/data/claude-grok-offload}/cgo-env`  
Keys: `CGO_SANDBOX` · `CGO_SANDBOX_WRITE` · `CGO_STAGING`

---

## Reverse checks

When **Grok** authored the design, use a separate **Claude** headless session for checker independence.  
See [docs/REVERSE.md](./docs/REVERSE.md) (document only — no reverse wrappers in this repo).

---

## Tests / CI

```bash
chmod +x plugins/claude-grok-offload/scripts/*.sh plugins/claude-grok-offload/tests/test-*.sh
for t in plugins/claude-grok-offload/tests/test-*.sh; do bash "$t"; done
```

GitHub Actions: `.github/workflows/ci.yml` (optional shellcheck, all `test-*.sh`, strip gate).

---

## Unsupported

- **skills.sh** install  
- Personal absolute paths baked into contracts  
- Host `precode-gate` / deny-until-grill hooks  
- Vault merge automation  

---

## License

MIT — see [LICENSE](./LICENSE). Attribution: [NOTICE](./NOTICE).
