# 🏛️ Code Architecture Auditor

> A professional **Claude Code Skill** that audits, reviews, and safely refactors
> any codebase — language- and framework-agnostic — and produces a
> production-ready report plus clean, validated code.

[![Skill](https://img.shields.io/badge/Claude-Skill-7C3AED)](https://docs.claude.com/en/docs/claude-code/skills)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)
[![Scope](https://img.shields.io/badge/scope-language--agnostic-blue)]()

The Code Architecture Auditor turns Claude into a **Senior Architecture, Code
Quality & Systems Design Auditor**. Point it at any project and it works through
a disciplined five-phase process — never changing code without establishing a
baseline, assessing risk, and validating that the product still works.

---

## ✨ What it does

- **Audits architecture** — structure, separation of concerns, data flow,
  scalability, single points of failure.
- **Assesses code quality** — dead code, duplication, complexity, naming, error
  handling, test coverage, docs.
- **Maps dependencies** — import graphs, circular deps, external integrations,
  version pinning.
- **Finds dead code safely** — every removal is grep-verified, git-checked, and
  risk-rated before it's touched.
- **Refactors with a safety net** — an Impact × Confidence gate blocks any risky
  change; CRITICAL code is never changed below 100% confidence.
- **Validates against a baseline** — output must match before sign-off.
- **Ships deliverables** — audit report, implementation guide, cleanup
  checklist, and validation results, all from templates.

---

## 📦 Installation

This is a [Claude Code Skill](https://docs.claude.com/en/docs/claude-code/skills).
Install it at the **user level** (available in every project) or the **project
level** (shared with a repo via version control).

### Option A — user-level (recommended)

```bash
git clone https://github.com/<your-org>/code-architecture-auditor.git
mkdir -p ~/.claude/skills
cp -R code-architecture-auditor ~/.claude/skills/code-architecture-auditor
```

### Option B — project-level

```bash
mkdir -p .claude/skills
cp -R code-architecture-auditor .claude/skills/code-architecture-auditor
```

Restart Claude Code (or start a new session). The skill auto-loads — its folder
name must stay `code-architecture-auditor` to match the `name` in `SKILL.md`.

> Works in Claude Code (CLI, VS Code, JetBrains) and anywhere Claude Skills are
> supported.

---

## 🚀 Usage

Invoke it explicitly:

```
/code-architecture-auditor
```

…or just ask naturally and it triggers on its own:

- "Audit the architecture of this repo."
- "Review my codebase for dead code and tech debt."
- "Is this project production-ready? Give me a health report."
- "Clean up and refactor this service safely."

It will confirm readiness, then ask the **Phase 1 — Discovery** questions
(repository, context, output baseline, known issues, constraints) before doing
anything.

> **Tip:** Want analysis only, no code changes? Say *"report only."* It stops
> after the audit report with prioritized recommendations.

---

## 🔄 How it works — the five phases

| Phase | What happens |
| ----- | ------------ |
| **1 · Discovery** | Gathers context and locks down what "correct output" means. |
| **2 · Analysis** | Repo scan, structure, data flow, quality, dependencies, dead code, baseline capture. |
| **3 · Reporting** | Delivers the audit report with severities, metrics, and removal candidates. |
| **4 · Refactoring** | Applies only **approved** changes, each through the risk gate. |
| **5 · Validation** | Runs tests, compares output to baseline, signs off. |

Each phase is a **gate** — it finishes and confirms before the next begins.

### The safety model

Every proposed change is rated on **Impact** (Critical→Low) and **Confidence**
(100%→<70%). The decision rules:

| Condition | Action |
| --------- | ------ |
| CRITICAL impact & < 100% confidence | **Do not change** — report only |
| HIGH impact & < 95% confidence | Needs review |
| MEDIUM impact & < 85% confidence | Proceed with caution + validate |
| LOW impact | Safe to change |

Full detail in [`reference/risk-framework.md`](./reference/risk-framework.md).

---

## 🗂️ Repository layout

```
code-architecture-auditor/
├── SKILL.md                      # Skill definition (frontmatter + summary)
├── README.md                     # This file
├── LICENSE                       # MIT
├── reference/                    # Progressive-disclosure detail
│   ├── workflow.md               # 7 competencies + all 5 phases
│   ├── risk-framework.md         # Impact × Confidence gate
│   ├── report-sections.md        # Audit-report structure
│   └── standards.md              # Quality bars + edge-case playbooks
└── templates/                    # Fill-in deliverables
    ├── 1_AUDIT_REPORT.md
    ├── 2_IMPLEMENTATION_GUIDE.md
    ├── 3_CLEANUP_CHECKLIST.md
    └── 4_VALIDATION_RESULTS.md
```

---

## 📤 Deliverables produced

For each audit, the skill generates (in a `./<project>-audit/` folder):

1. **Audit report** — findings, metrics, health score, prioritized recs.
2. **Refactored code** — atomic, clearly-messaged commits (only if approved).
3. **Implementation guide** — deploy, migrate, rollback, test procedures.
4. **Cleanup checklist** — what changed and why (plus what was deliberately left).
5. **Validation results** — test results, output comparison, sign-off.

---

## 🤝 Contributing

Issues and PRs welcome. Keep `SKILL.md` concise — put detail in `reference/` so
the skill stays light and loads detail on demand (progressive disclosure).

## 📄 License

[MIT](./LICENSE) © Aaron Sed
