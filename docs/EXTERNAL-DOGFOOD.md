# External dogfood (S1) — 외부 1인 검증 가이드

**Goal:** Someone who is **not** the author completes install → check → grill on their machine.

**Success (S1):**

1. Plugin installed  
2. `install-sandbox` OK  
3. `check` prints **`Ready: yes`**  
4. `grill` (no path) returns grill text (PASS or REVISE both count)

---

## Invite (copy-paste · English)

```text
Hey — I published a small Claude Code plugin that offloads work to Grok Build
(grill/verify/impl, etc.). Could you try a 10-minute smoke test?

Repo: https://github.com/msju199/claude-grok-offload
Release: https://github.com/msju199/claude-grok-offload/releases/tag/v0.1.0

You need: Claude Code + Grok CLI logged in (`grok models` works).

In Claude Code:
  /plugin marketplace add msju199/claude-grok-offload
  /plugin install claude-grok-offload@claude-grok-offload-mp
  /reload-plugins
  /claude-grok-offload:install-sandbox
  /claude-grok-offload:check
  /claude-grok-offload:grill

Please reply with:
  1) Ready: yes or no (paste the check lines)
  2) Did grill print a PASS/REVISE-style review? (yes/no + OS)
  3) Any error text

Thanks — that closes my "one external user" success bar.
```

## 초대 (복붙 · 한국어)

```text
클로드 코드 플러그인 하나 공개했어. Grok Build로 grill/verify/impl 같은 걸 넘기는 팩이야.
10분 정도 스모크만 도와주면 좋겠어.

repo: https://github.com/msju199/claude-grok-offload

전제: Claude Code + Grok CLI 로그인 (`grok models` 됨)

Claude Code에서:
  /plugin marketplace add msju199/claude-grok-offload
  /plugin install claude-grok-offload@claude-grok-offload-mp
  /reload-plugins
  /claude-grok-offload:install-sandbox
  /claude-grok-offload:check
  /claude-grok-offload:grill

회신 부탁:
  1) check에 Ready: yes 나왔는지 (그 줄 붙여줘)
  2) grill 결과(PASS/REVISE 비슷한 텍스트) 나왔는지 · OS
  3) 에러 있으면 전문

외부 1인 성공 지표라 한 번만 되면 충분해. 고마워.
```

---

## Feedback template (tester fills)

| Field | Value |
|-------|--------|
| Date | |
| OS | macOS / Linux / other |
| Claude Code version | |
| Grok CLI version | `grok --version` |
| Ready line | |
| Grill ran? | yes / no |
| Errors | |

Open a GitHub issue with label `dogfood` or reply privately.

---

## Author tracking

When S1 succeeds, append one line to `~/Claude/logs/cgo-dogfood.log`:

```text
ts=ISO · external=yes · os=… · ready=yes · grill=ok · note=…
```
