# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

This is **not an application** — it is the distributable source of a single **Claude
Code Skill** named `code-architecture-auditor`. There is nothing to build, lint, or
test in the conventional sense. The "product" is the Markdown content itself: when
installed, Claude reads these files and *becomes* a codebase-audit agent. Edits to
the prose directly change the skill's behavior, so treat content changes with the
same care as code changes.

## How the skill is consumed

- A user installs it by copying the whole folder into `~/.claude/skills/code-architecture-auditor/`
  (user-level) or `.claude/skills/code-architecture-auditor/` (project-level), then
  restarting Claude Code.
- The folder name **must** stay `code-architecture-auditor` — it has to match the
  `name:` in `SKILL.md` frontmatter or the skill won't load.
- It activates either explicitly (`/code-architecture-auditor`) or by trigger words
  in the `description` frontmatter (audit / review / refactor / dead code /
  dependencies / code health). The `description` is the *only* thing Claude sees when
  deciding whether to auto-trigger, so keep it trigger-rich and accurate.

## Architecture: progressive disclosure (the core design contract)

The content is deliberately split so the skill loads light and pulls detail on demand.
**Preserve this layering when editing:**

- `SKILL.md` — the always-loaded summary. Keep it lean: principles, the five-phase
  gate table, how-to-begin, and pointers. Do **not** inline long procedures here.
- `reference/*.md` — the heavy detail, loaded only when needed:
  - `workflow.md` — the readiness block, 7 competencies, and all 5 phases in full.
  - `risk-framework.md` — the Impact × Confidence gate that governs every change.
  - `dead-code-playbook.md` — the deprecate-before-delete disposition ladder and dead-code false-positive traps.
  - `report-sections.md` — exact audit-report layout and finding/removal block formats.
  - `standards.md` — quality bars + edge-case playbooks.
  - `security.md` — safety preconditions, the untrusted-input/prompt-injection rule, and secrets handling.
- `templates/{1_AUDIT_REPORT,2_IMPLEMENTATION_GUIDE,3_CLEANUP_CHECKLIST,4_VALIDATION_RESULTS}.md`
  — fill-in deliverables the skill emits into a `./<project>-audit/` folder at runtime.

**Invariant to maintain:** every `reference/` and `templates/` path named in `SKILL.md`
must exist, and any new reference file must be linked from `SKILL.md` or it will never
be loaded. When you move detail out of `SKILL.md`, add the pointer; when you rename a
reference file, update the pointer.

The skill's own runtime behavior is a **five-phase sequential gate** model
(Discovery → Analysis → Reporting → Refactoring → Validation), where it must establish
an output baseline before changing anything and never alter CRITICAL-impact code below
100% confidence.

**The safety model is the load-bearing contract, and it spans more than one file.**
It has two halves — the *evidence ladder* (confidence is earned tier-by-tier:
Unverified → Tentative → Strong → Verified, never a gut percentage) and
*deprecate-before-delete* (leave → deprecate → quarantine → delete). These must read
identically everywhere they appear: the principles in `SKILL.md`, the gate table in
`SKILL.md`, `reference/risk-framework.md`, `reference/dead-code-playbook.md`,
`reference/report-sections.md`, the emitted `templates/`, and the marketing copy in
`README.md`. The most common regression in this repo is editing the model in one place
(usually a reference doc) and leaving a template or the README describing the *old*
model — e.g. a template still emitting `CONFIDENCE: <100% safe | 95% safe>` after the
docs moved to the evidence ladder. When you touch the safety model, grep all surfaces
and update them together (see Consistency checks below).

## Licensing & identity constraints (do not casually change)

This repo is intentionally **source-available, not open-source**, to preserve the
author's commercial rights. When editing, respect these:

- License is **PolyForm Noncommercial 1.0.0** (`LICENSE`), not MIT/permissive. The
  `Required Notice:` line in `LICENSE` and the `NOTICE` file are legally load-bearing
  and must be preserved verbatim in any copy/derivative.
- Copyright holder is **Aaron Sed**; commercial-contact email **aaron@bluebirdsgroup.com**
  is intentionally public. Keep author name, copyright, and contact consistent across
  `LICENSE`, `NOTICE`, and `README.md` if any of them change.
- GitHub displays the license as **"Other"** — this is expected (PolyForm isn't in
  GitHub's SPDX auto-detection list), not a bug to fix.

## Git / publishing

- Remote: `https://github.com/aaron484/code-architecture-auditor` (public).
- The **maintainer's** commits must be authored as **Aaron Sed**. *Maintainer-only,
  and only on unpushed commits:* if the maintainer's own author identity drifts,
  re-stamp with `git rebase --root --exec 'git commit --amend --reset-author --no-edit'`.
  **Contributors keep their own authorship** — never rewrite history to change
  someone else's commits, and never run the re-stamp on a fork or a shared branch.
- Use `gh` for repo/topic management. Only commit or push when the user asks.

## Consistency checks (this repo's substitute for build/lint/test)

There is no build, linter, or test suite — the "tests" are structural invariants.
Run these from the repo root after any content edit:

```bash
# 1 · Folder name must equal the `name:` in SKILL.md frontmatter, or the skill won't load.
basename "$PWD"; grep -m1 '^name:' SKILL.md

# 2 · Every reference/ path pointed to from SKILL.md must exist (a dangling pointer = a
#     reference file that never loads).
grep -oE 'reference/[A-Za-z0-9_-]+\.md' SKILL.md | sort -u | \
  while read -r f; do test -f "$f" && echo "ok       $f" || echo "MISSING  $f"; done

# 3 · Safety-model regression guard: the old gut-percentage wording must be gone
#     everywhere. This should print nothing.
git grep -n "% safe" -- templates reference README.md
```

Then the manual smoke test: install into `~/.claude/skills/`, restart Claude Code, and
run `/code-architecture-auditor` (or a natural prompt like "audit this repo"). It should
post the readiness block and then ask the Phase 1 discovery questions before doing
anything — it must **not** start scanning or changing files on its own.
