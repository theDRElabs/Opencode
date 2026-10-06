# Harness Audit — Phase 0 (Current State)

Date: 2026-10-06
Method: read-only inventory and behavior tracing of this instance. No active
configuration was changed.
Scope paths: `/home/codespace/.config/opencode`, `/home/codespace/.opencode`,
`/workspaces/Opencode`, `/workspaces/opencode-config`, `/workspaces/graph-memory`.

## 1. What is actually active on this instance

- `~/.config/opencode/opencode.json` — only declares MCP servers (graph-memory
  enabled; context7 and playwright live only in the inactive `opencode.jsonc`,
  see §4). No provider, permission, instruction, or compaction keys.
  Evidence: file contents above; only `mcp` key present.
- `~/.config/opencode/cli.json` — TUI prefs plus
  `session.permissions: "autoaccept"`. This auto-accepts permission prompts.
- `~/.config/opencode/service.json` — cleartext server password
  (`Ck-sSMe...`). Stored unencrypted on disk.
- Instructions actually loaded at session start:
  - `~/.config/opencode/AGENTS.md` → symlink to
    `/workspaces/opencode-config/AGENTS.md`.
  - `~/.config/opencode/HARNESS-CONTRACT.md` → symlink to
    `/workspaces/Opencode/HARNESS-CONTRACT.md`.
  - `~/.config/opencode/HARNESS-ROADMAP.md` → symlink to
    `/workspaces/Opencode/HARNESS-ROADMAP.md`.
  The AGENTS.md body injected into my own context (the system block above) does
  NOT match the file on disk: the injected version describes "AWS EC2 Windows
  instance running WSL2 Debian, user DRE, home /home/ubuntu" and references
  `~/projects/termux-setup/BUILD-LESSONS.md`, while the on-disk file at
  `/workspaces/opencode-config/AGENTS.md` says this is a GitHub Codespace,
  user `codespace`, home `/home/codespace`. Stale-copy risk is real: whichever
  path the loader reads may be a different, older file than the one being
  edited. (Needs `investigate` on which physical file the active session loads.)
- No global `opencode.jsonc`, `permission` block, or compaction settings are
  active in `~/.config/opencode`. The rich `opencode.jsonc` with providers,
  models, MCPs, and instructions lives at
  `/workspaces/opencode-config/opencode.jsonc` and is NOT referenced by the
  active config. Its `instructions` entry points at
  `/home/ubuntu/.config/opencode/HARNESS-CONTRACT.md` and its playwright MCP
  command points at `/home/ubuntu/.config/opencode/playwright-win-chrome.sh`
  — absolute paths from the previous host that do not exist here
  (`/home/ubuntu` is absent; current home is `/home/codespace`).

## 2. Component inventory and classification

| Component | Location | Evidence | Classification |
|---|---|---|---|
| AGENTS.md (global instructions) | `/workspaces/opencode-config/AGENTS.md`, symlinked into `~/.config/opencode/` | on-disk content says Codespace; injected copy (my system block) says EC2/WSL2 — mismatch | **investigate** (which copy loads), then **modify** (reconcile, keep short) |
| HARNESS-CONTRACT.md | `/workspaces/Opencode/HARNESS-CONTRACT.md` (active symlink target), stale twin at `/workspaces/opencode-config/HARNESS-CONTRACT.md` | `diff` shows twin differs (missing context-budget bullets, missing flaky-test rule) | **modify**: single source of truth; archive twin |
| HARNESS-ROADMAP.md | `/workspaces/Opencode/HARNESS-ROADMAP.md` (active), stale twin in opencode-config | differs | **modify**: same dedup |
| HARNESS-AUDIT.md | archived copy in both `/workspaces/Opencode/harness-archive/` and `/workspaces/opencode-config/harness-archive/` | dated 2026-08-24, describes `/home/ubuntu` scope | **remove later**: superseded by this audit; keep only one archived copy |
| memory.md (session tail memory) | `/workspaces/opencode-config/memory.md` | contains entries from `/mnt/c/Users/Administrator` and `/home/ubuntu` — other hosts | **investigate**: plugin that writes it points at `~/.config/opencode/memory.md`, which does not exist |
| plugin/memory.js | `/workspaces/opencode-config/plugin/memory.js` | not referenced from active `opencode.json`; no `plugin/` dir under `~/.config/opencode` | **investigate** (loaded or dead?) |
| plugin/hardened-rules.js | `/workspaces/opencode-config/plugin/hardened-rules.js` | same | **investigate**; if active, keep the rule set, move text to a short instruction |
| plugin/gpt6-astra-fix.ts | `/workspaces/opencode-config/plugin/gpt6-astra-fix.ts` | model-specific workaround for `gpt-6-astra` | **remove later** once gateway fixed; confirm applicability |
| agent/*.md (12 agents) | `/workspaces/opencode-config/agent/` | alignment, architecture-auditor, bounded-implementer, destination-writer, fresh-reviewer, issue-writer, manual-qa, pr-test-analyzer, security-reviewer, sequential-afk-runner, silent-failure-hunter, vision-reader | **keep** as Phase 6–9 primitives; verify they are not purely duplicative of same-named skills |
| commands/*.md (10) | `/workspaces/opencode-config/commands/` | grill-me, write-prd, prd-to-issues, implement-issue, review-issue, run-afk, manual-qa-plan, project-check, architecture-audit, weekly-review | **keep**; thin invocations over skills/agents |
| skills/ (33 dirs) | `/workspaces/opencode-config/skills/` | grill-me, write-prd, prd-to-issues, tdd, fresh-context-review, architecture-audit, manual-qa-plan, sequential-afk-runner, project-feedback, graph-memory, context-budget, anti-slop + 20 domain skills (design, slides, browse, e2e-testing, nextjs..., shadcn, etc.) | core 10 **keep**; domain skills **keep** but audit load cost; `scrollcraft`, `ui-ux-pro-max`, `caveman`, `listen`, `project-memorial`, `brand`, `banner-design`, `slides`, `design-md`, `design`, `design-system` — **investigate** overlap with `design/frontend-design/ui-styling` cluster |
| MCP servers | active `opencode.json`: graph-memory only; inactive `opencode.jsonc`: context7, playwright, graph-memory | context7/playwright not active on this instance | **modify**: decide whether playwright/context7 should be enabled; don't leave two divergent config files |
| graph-memory (MCP + store) | `/workspaces/graph-memory/` (nodes.jsonl, edges.jsonl, episodes/, scripts/mcp-server.mjs, package.json, tests/) | AGENTS.md says graph-memory lives here, not `~/.config/opencode/graph/`; errors.log empty (0 bytes) | **keep**; content and repo hygiene are healthy |
| opencode.jsonc provider matrix | `/workspaces/opencode-config/opencode.jsonc` | 4 extra providers (agentrouter, agentrouter-openai, google, bluesminds), models like gpt-5.6-sol, gemini-3.6; referenced only by this file | **investigate/replace**: decide which provider config is real; the EC2-laptop dual-host drift (context7/playwright never on) suggests this file is a backup, not active |
| EVALS-UPGRADE-PLAN.md | `/workspaces/opencode-config/EVALS-UPGRADE-PLAN.md` | planning doc for phases 15–22, status "Ready for delegation" | **remove later**: archive once phases 15–23 landed (most already show `pending` tracker states vs completed Work sections — roadmap partially updated) |
| DATACHECK-PROMPT.md | `/workspaces/opencode-config/DATACHECK-PROMPT.md` | prompt referencing `/home/ubuntu/projects/data-check/...` | **remove later**: stale host path, transient plan |
| runs/data-check | `/workspaces/opencode-config/runs/data-check/M6` | hashed blob | **investigate/keep-local** |
| fixtures/ + scripts/ + metrics/ + harness-test.sh | `/workspaces/opencode-config/` | 8 suites, JSONL results contract, trials artifacts | **keep**; but note active symlinked `harness-test.sh` at `/workspaces/Opencode/harness-test.sh` is a copy of the same script — this is a harness repo split across two paths |
| Two git repos | `/workspaces/Opencode` (c2262f7) vs `/workspaces/opencode-config` (active work) | HARNESS-*.md exist in both with diverged content; `fixtures/`, `agent/`, `commands/`, `skills/`, `plugin/`, `scripts/`, `metrics/`, `runs/` exist ONLY in opencode-config | **investigate/modify**: the roadmap deliverable path is `~/.config/opencode/HARNESS-AUDIT.md`, but the real harness content is split across two repos and two directories. Decide one canonical home before Phase 1. |
| permissions | `cli.json` → `session.permissions: "autoaccept"` | no `permission` block anywhere in active config | **modify**: autoaccept is the weakest boundary; Phase 11 sandbox must define explicit allow/deny |
| compaction | no compaction key in active config | plugins/memory.js caps memory at 6KB/3KB inject; context-budget skill exists | **investigate**: whether opencode v2 has a compaction API to configure; until then context-budget skill is advisory only |
| cleartext service password | `~/.config/opencode/service.json` | world-readable dir, mode 600 file but password committed? check git | **modify**: move to env var / secret store |

## 3. Request-to-code trace (current path)

1. **User input** → TUI (`~/.config/opencode/cli.json`, theme nord, autoaccept
   permissions). Session permission mode autoaccept.
2. **Context assembly** → system prompt gets: AGENTS.md (symlinked copy —
   possibly stale EC2 text), HARNESS-CONTRACT.md, HARNESS-ROADMAP.md, plus
   whatever `plugin/memory.js` injects (~3KB tail of
   `~/.config/opencode/memory.md`, which does not exist → likely no-op), and
   `plugin/hardened-rules.js` if loaded. Skills are pull-based via the
   `skills/` discovery path.
3. **Tool selection** → MCP tools from graph-memory server
   (`node /workspaces/graph-memory/scripts/mcp-server.mjs`); local tools
   (bash, read, edit, glob, grep) under autoaccept.
4. **Edits** → direct file edits; no worktree/branch isolation active despite
   Phase 11 artifacts existing in fixtures.
5. **Verification** → manual only: no project check convention is wired;
   `harness-test.sh` + fixtures exist but are run on demand, not per change.
6. **Completion** → no independent review step, no fresh-context review
   enforcement; memory persisted via memory.js only if loaded; graph-memory
   writes only when an episode is explicitly added.

Gaps in the trace: no context-reset rule enforcement, no destination doc
requirement, no issue contract, no TDD gate, no independent verification
agent, no QA step, no sandboxing. These are exactly the Phase 1–12 backlog
in the roadmap.

## 4. Context bloat, role overlap, unsafe permissions, missing feedback, stale documents

- **Bloat**: 33 skill dirs + 12 agents + 10 commands loaded/discoverable;
  design skills cluster (design, design-md, design-system, frontend-design,
  ui-styling, ui-ux-pro-max, scrollcraft, anti-slop) likely overlaps —
  **investigate** per-skill triggers.
- **Role overlap**: grill-me/write-prd/prd-to-issues exist as skill + command
  + concept; agents vs skills split unclear (e.g. `fresh-reviewer` agent vs
  `fresh-context-review` skill).
- **Unsafe permissions**: `session.permissions: "autoaccept"`; cleartext
  `service.json` password; `subagent_depth: 3` in the inactive jsonc.
- **Missing feedback**: no per-project check convention active; no CI wired
  on this instance (`.github` lives in opencode-config but no active repo
  references it from `/workspaces/Opencode`); trials/metrics exist as
  artifacts, not enforced gates.
- **Stale documents**: injected AGENTS.md (EC2/DRE host text) vs on-disk
  Codespace file; `opencode.jsonc` `/home/ubuntu` paths; `DATACHECK-PROMPT.md`
  `/home/ubuntu` path; `memory.md` entries from other hosts; two diverged
  copies of HARNESS-CONTRACT/ROADMAP/AUDIT across `/workspaces/Opencode` and
  `/workspaces/opencode-config`; roadmap Work sections for phases 15–23 are
  written as done while the Phase Tracker shows `pending` and completion
  gates say "Not yet met".

## 5. Gaps found (summary)

1. Two divergent harness repos/directories; no canonical home for
   HARNESS-* artifacts (deliverable path confusion).
2. AGENTS.md injected copy does not match on-disk copy — stale instructions
   may be loaded.
3. All permission boundaries are `autoaccept`; plaintext service password.
4. Active config lacks provider/instruction wiring that exists only in the
   inactive `opencode.jsonc` (with dead `/home/ubuntu` paths).
5. Plugins (memory, hardened-rules, gpt6-astra-fix) status unknown — not
   referenced by active config.
6. Compaction not configured anywhere active; context-budget is advisory.
7. No automated verification path on normal edits; harness-test suite not
   wired into session flow.
8. Phase tracker state inconsistent with phase Work sections (15–23).
9. No branch/worktree isolation for agent edits.
10. Stale docs: DATACHECK-PROMPT, harness-archive audits, memory.md host
    entries, EVALS-UPGRADE-PLAN.
