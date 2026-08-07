# Marketplace submission pack

## Status (2026-08-07)

| Channel | Status | Link |
|---------|--------|------|
| **Self marketplace** | Live | `msju199/claude-grok-offload` (this repo) |
| **Community catalog PR** | Open | https://github.com/jimmc414/claude-code-plugin-marketplace/pull/8 |
| **Anthropic directory form** | Needs owner browser login | https://clau.de/plugin-directory-submission |
| Official `claude-plugins-official` | Not auto — form review only | https://github.com/anthropics/claude-plugins-official |

PRs against `anthropics/claude-plugins-community` are **closed automatically** — submissions go through the form → nightly sync.

---

## A. Anthropic form — paste fields

Open: **https://clau.de/plugin-directory-submission**  
(Also listed as Console: https://platform.claude.com/plugins/submit for individual authors.)

| Field | Suggested value |
|-------|-----------------|
| Plugin name / slug | `claude-grok-offload` (**immutable** after publish) |
| Display name | Claude Grok Offload |
| Description | Claude Code plugin: offload grill/verify/impl/judge/fanout/sweep/heavy-burn to Grok Build with portable sandbox profiles and Ready check. MIT. Independent — not affiliated with xAI. |
| Repository URL | https://github.com/msju199/claude-grok-offload |
| Homepage | https://github.com/msju199/claude-grok-offload |
| License | MIT |
| Category | development / productivity (pick closest) |
| Version | 0.1.0 |
| Install (self) | `/plugin marketplace add msju199/claude-grok-offload` then `/plugin install claude-grok-offload@claude-grok-offload-mp` |
| Requirements | Grok Build CLI + login; Claude Code; bash/git |
| Security notes | Shells out to local `grok` only; installs named sandbox profiles `cgo_ro`/`cgo_impl`; no skills.sh path; no host deny-hooks |

**Pre-submit checklist**

- [x] `claude plugin validate` passed (local)
- [x] LICENSE MIT present
- [x] README install path clear
- [x] No secrets in tree
- [x] v0.1.0 release tag

After submit: wait for automated security scan + review; community mirror updates nightly if approved.

---

## B. Community PR (done)

- Repo: [jimmc414/claude-code-plugin-marketplace](https://github.com/jimmc414/claude-code-plugin-marketplace)  
- PR: https://github.com/jimmc414/claude-code-plugin-marketplace/pull/8  
- After merge, users can:

```text
/plugin marketplace add jimmc414/claude-code-plugin-marketplace
/plugin install claude-grok-offload@community-claude-plugins
```

(Exact marketplace name may match their `marketplace.json` `name` field: `community-claude-plugins`.)

---

## C. What we do **not** do

- Direct PR to `anthropics/claude-plugins-community` (auto-closed)  
- Claiming “official Anthropic plugin” before form approval  
