---
name: run-code-architecture-auditor
description: >-
  Run, validate, smoke-test, or build-check the code-architecture-auditor
  skill. Use to verify the skill loads and is internally consistent before
  publishing — checks frontmatter, that the folder name matches name:, that
  every reference/ pointer resolves, that no reference file is orphaned, that
  the deliverable templates exist, and that the safety model (evidence ladder
  + deprecate-before-delete) hasn't drifted. Also documents how to install and
  invoke the auditor live in Claude Code.
---

# Run: code-architecture-auditor

This unit is **not a runnable application** — it is a Markdown-only Claude Code
Skill. There is no server, GUI, CLI binary, or library to launch, so there is
nothing to screenshot. The only mechanical *"does it work?"* is **"does it load,
and is it internally consistent?"** — because a malformed skill silently
mis-loads, and a drifted one emits deliverables that contradict its own docs.

The driver is [`.claude/skills/run-code-architecture-auditor/smoke.sh`](smoke.sh):
a structural validation harness. It is the agent path. Invoking the auditor for
real (installing it and typing `/code-architecture-auditor` in a live Claude
session) is the human path — it needs an interactive session and can't be driven
headlessly.

> **Paths below are relative to the unit root** (`code-architecture-auditor/`),
> the directory that holds the auditor's own `SKILL.md`. The auditor's `SKILL.md`
> lives at the **repo root**, not under `.claude/skills/` — the repo *is* the
> skill; `.claude/skills/` here holds only this run-helper. Don't confuse the two.

## Prerequisites

None to install. The harness uses only `bash`, `grep`, and `sed`, which ship on
macOS and every Linux container. `git` is optional (used only by the manual
regression grep in CLAUDE.md, not by the harness). No `apt-get` line is needed —
verified on macOS (Darwin) this session.

## Run (agent path) — the validation harness

From the unit root:

```bash
.claude/skills/run-code-architecture-auditor/smoke.sh
```

It is location-independent (it resolves the unit root relative to its own path),
so this works identically from anywhere:

```bash
"/absolute/path/to/code-architecture-auditor/.claude/skills/run-code-architecture-auditor/smoke.sh"
```

It prints a `PASS`/`FAIL` line per check across six groups (manifest & folder
name, reference-pointer resolution, orphan reference files, deliverable
templates, safety-model consistency, runtime-behavior definition) and **exits 0
only if every check passes** (non-zero otherwise — CI-friendly). Colors
auto-disable when output is piped, so logs stay clean.

Expected tail on a healthy skill:

```
ALL CHECKS PASSED — skill is well-formed and internally consistent.
```

To confirm the harness actually has teeth (not a rubber stamp), it was run this
session against a deliberately broken copy — renamed folder, a deleted
referenced file, and injected `% safe` wording — and it failed all three checks
and exited 1. Re-prove it the same way: `cp -R` the unit elsewhere, break one
thing, run its `smoke.sh`.

## Run (human path) — install and invoke the auditor live

Install it as a user-level skill, then invoke it in an interactive Claude Code
session (this is the only way to exercise the actual audit behavior; it can't be
scripted or screenshotted headlessly):

```bash
mkdir -p ~/.claude/skills
cp -R "$PWD" ~/.claude/skills/code-architecture-auditor
```

Restart Claude Code, then either type `/code-architecture-auditor` or ask
naturally ("audit this repo for dead code"). A correct load posts the readiness
block and then asks the Phase 1 — Discovery questions; it must **not** start
scanning or changing files on its own. The `cp -R` copy mechanics were verified
this session against a throwaway staging dir (so the real `~/.claude` was left
untouched).

## Gotchas

- **There is no `driver.mjs` and no screenshot.** This is content, not an app.
  `smoke.sh` is the harness; if you came looking for a GUI driver, there isn't
  one and shouldn't be.
- **zsh aborts the skill-discovery probe when nothing matches.** The generator's
  probe (`grep ... "$d"/.claude/skills/*/SKILL.md`) uses an unquoted glob; under
  the default zsh `nomatch` option an unmatched glob is a **fatal error that
  kills the whole script**, not an empty result. Run that probe under `bash`
  (`bash -c '...'`) or `setopt NULL_GLOB` first. (Hit this live while building
  this skill — before this `SKILL.md` existed, the glob matched nothing and
  aborted the run.)
- **The auditor's `SKILL.md` is at the repo root, not in `.claude/skills/`.**
  When installed it goes to `~/.claude/skills/code-architecture-auditor/`. In the
  source repo, `.claude/skills/` contains only this run-helper. `smoke.sh`
  validates the **repo-root** skill (three levels up from itself), not its own
  sibling.
- **Renaming the repo folder breaks the auditor skill.** The folder basename
  must equal the frontmatter `name:` (`code-architecture-auditor`) or Claude
  won't load it. `smoke.sh` check 1 catches this.

## Troubleshooting

| Symptom | Cause / fix |
| ------- | ----------- |
| `(eval): no matches found: .../SKILL.md` | zsh `nomatch` on an unmatched glob. Run the probe under `bash`, or the glob genuinely matched no skill. |
| `FAIL  folder '<x>' != name: '...'` | The unit folder was renamed. Rename it back to `code-architecture-auditor`. |
| `FAIL  MISSING: reference/<f>.md` | A reference file pointed to by the root `SKILL.md` is gone. Restore it or remove the pointer. |
| `FAIL  orphan: reference/<f>.md ...` | A reference file exists but nothing in `SKILL.md` links it, so it would never load. Add the pointer or delete the file. |
| `FAIL  stale '% safe' wording found` | The safety model drifted — a template/doc still uses gut-percentage confidence. Replace with the evidence ladder (Unverified → Tentative → Strong → Verified). |
