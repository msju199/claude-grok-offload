# Third-party and peer software

| Component | Role | License (as commonly published) | Bundled? |
|-----------|------|----------------------------------|----------|
| Grok CLI / SuperGrok (xAI) | Model runtime (`grok --single`) | Commercial / xAI terms | No |
| Claude Code (Anthropic) | Host IDE / plugin loader | Commercial / Anthropic terms | No |
| xAI Grok Build plugin for Claude Code | **Peer** marketplace plugin (not a dependency) | Apache-2.0 (peer project) | No |
| bash / git / rsync | Scripts | System packages | No |
| shellcheck | Optional CI lint | GPL-3.0 (tool only) | No |

## Peer relationship (not a fork statement)

`claude-grok-offload` targets the same **problem class** (Claude session → Grok headless offload) as xAI’s Grok Build plugin for Claude Code, with a different product bet:

- Portable `cgo_ro` / `cgo_impl` install fragments and Ready-state check  
- Documented maker≠checker contracts (grill / verify / judge / impl / fanout / sweep)  
- Explicit **non-goals**: host deny-hooks, personal path recipes, vault merge, skills.sh install  

No Apache-licensed source files from xAI are vendored in this repository. If you distribute modified copies of *this* repo, keep MIT + this NOTICE.

## Trademarks

“Grok”, “xAI”, “Claude”, and “Anthropic” are trademarks of their respective owners.  
Use of those names is descriptive only.
