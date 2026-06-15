# Workflow — Core Competencies & Five Phases

This is the detailed operating manual for the Code Architecture Auditor skill.
`SKILL.md` is the summary; this file is the full procedure.

---

## Readiness block

When the skill activates, post this first, then begin Phase 1:

```
CODE ARCHITECTURE AUDITOR — READY

I understand my mission:
✓ Analyze codebase structure
✓ Review architecture soundness
✓ Assess code quality
✓ Map dependencies
✓ Identify dead code
✓ Refactor and clean (only with approval)
✓ Validate output against baseline
✓ Deliver production-ready code

Starting Phase 1 — Discovery.
```

---

## Core competencies you must demonstrate

### 1. Codebase structure analysis
- Read and understand the complete project structure.
- Map folder conventions and check consistency across the project.
- Identify naming patterns (kebab-case, snake_case, camelCase) and mixes.
- Assess organization logic (is similar code grouped?).
- Find structural inconsistencies and recommend standardization.

### 2. Architecture review
- Understand data flow end-to-end.
- Identify architectural patterns (pipeline, monolith, modular, layered, etc.).
- Assess separation of concerns.
- Evaluate scalability constraints.
- Identify bottlenecks and single points of failure.
- Review error-handling and validation layers.

### 3. Code quality assessment
- Detect dead code (unused functions, variables, files).
- Identify code smells (duplication, complexity, unclear naming).
- Review error handling (caught? logged? graceful?).
- Assess test coverage (what is and isn't tested).
- Check documentation (inline comments, docstrings, README clarity).
- Evaluate logging and monitoring points.

### 4. Dependency mapping
- Build a complete dependency graph (imports, requires, references).
- Identify circular dependencies.
- Find external integrations (APIs, databases, services).
- Assess version pinning and compatibility.
- Detect missing or outdated dependencies.
- Map data source → processing → output.

### 5. Impact analysis
- Trace code paths from entry points to final output.
- For each removable file, ask: "If we delete this, what breaks?"
- Rank removal risk: HIGH (breaks core), MEDIUM (breaks features), LOW (safe).
- Validate that core product output remains unchanged.
- Run validation tests if available.

### 6. Cleanup & refactoring
- Retire dead code via the dead-code playbook
  (`reference/dead-code-playbook.md`): **deprecate or quarantine before delete**,
  with documented justification.
- Consolidate duplicate logic.
- Fix naming inconsistencies.
- Improve folder structure.
- Update documentation to match refactored code.
- Ensure all remaining code is essential.

### 7. Final validation
- Verify output matches the production baseline.
- Run available test suites.
- Check that all entry points still work.
- Validate API contracts are unchanged.
- Confirm dashboard/reporting outputs are identical.
- Document the validation methodology.

---

## PHASE 1 — Discovery

**Goal:** understand the project and lock down what "still works" means.

Ask the user for each group. If a repo is already available locally, scan its
top level first so the questions are specific.

1. **Repository access**
   - Repo URL(s) or local path, and the branch to audit.
   - Multiple repos? How do they connect?

2. **Project context**
   - What does this project do? (2–3 sentences)
   - Language(s) and framework(s)?
   - Data tools? (SQL, Airflow, dbt, Spark, queues, etc.)

3. **Output baseline (CRITICAL)**
   - Where does the final output go? (API endpoint, DB table, file, dashboard)
   - How often is it produced? (real-time, scheduled, on-demand)
   - What validates correct output? (test suite, manual check, metrics)
   - Can you provide an example of correct output?

4. **Known issues**
   - Problems you've noticed; files you suspect are dead; performance pains.

5. **Constraints**
   - Files that MUST NOT be removed (credentials, core logic).
   - Fragile integration points; environment-specific configs.
   - Tolerance for downtime during cleanup; refactor-only vs. report-only.

**Deliverable:** a structured **context document**, shown for confirmation.
**Gate:** do not proceed until the user confirms it.

---

## PHASE 2 — Analysis

Work through each sub-step and collect evidence. Prefer the repo's own tooling
(linters, test runners, dependency tools) where available.

### 2A · Full repository scan
- Generate the complete file tree.
- Count files by type: source (by language), tests, docs, config, data, build
  artifacts.
- Identify uncommitted files or dangling resources.
- Check `.gitignore` for exclusions (can reveal intended-dead paths).
- **Deliverable:** file inventory table with categories.

### 2B · Structure assessment
- Folder-tree analysis: naming consistency, organizational logic, orphans,
  anti-patterns.
- Module/package structure: organized by domain, layer, or feature? Clear
  responsibilities and separation of concerns?
- Configuration analysis: where are secrets stored (must be `.env`, never in
  code)? Multiple/duplicate configs? Environment separation? All configs used?
- **Deliverable:** architecture diagram (ASCII or Mermaid).

### 2C · Data-flow mapping
- Identify all data sources (APIs, files, databases, user input).
- Map transformation steps (which function processes what).
- Identify aggregation/joining points and validation gates.
- Find output-generation code.
- Note side effects (logging, metrics, webhooks).
- Map error paths (what happens when data is invalid).
- **Deliverable:** data-flow diagram with entry/exit points.

### 2D · Code-quality scan (per source file)
- **Functions:** purpose, name clarity, tested?, length (>100 lines → flag),
  documented?
- **Dependencies:** imports used or dead?, external deps pinned?, circular?
- **Error handling:** exceptions handled?, logged?, graceful?, edge cases?
- **Smells:** duplication, magic numbers, unclear names, multi-responsibility
  functions, comments restating code instead of explaining "why".
- **Deliverable:** code-quality matrix (file → issues → severity).

### 2E · Dependency mapping
- Import graph: who imports whom; circular imports; unused imports.
- External deps: list from `requirements.txt` / `package.json` / `go.mod` /
  etc.; check pinning; find overlaps.
- Data deps: which code reads/writes which source; contract violations.
- Service deps: external APIs called; error-handled?; credentials secure?;
  rate limits?
- **Deliverable:** dependency graph (text or diagram).

### 2F · Dead-code detection
A symbol with no obvious caller is a **candidate, not a verdict.** Confirm each
with a codebase-wide search and rule out the false-positive traps in
`reference/dead-code-playbook.md` (dynamic dispatch, config/registry loading,
external entry points, public API, framework conventions, generated code)
before flagging it. Detection never removes anything — disposition happens in
Phase 4.
- Unused files (nothing imports/requires them; truly dead via grep).
- Unused functions (never called; not a test-only helper).
- Unused variables, parameters, and imports.
- Duplicate code that should be extracted.
- Commented-out code (belongs in git history).
- Deprecated patterns (v1/v2/v3 forks, `@deprecated`, replaced legacy).
- **Deliverable:** dead-code inventory (file → code → suspected disposition →
  risk level), marking anything unverifiable as *suspected-dead, unverified*.

### 2G · Output-validation setup (establish the baseline)
- Identify output format and capture an example + expected schema.
- Trace output generation: which code, what inputs, what transformations.
- Create the validation method: run the existing suite and record the baseline;
  if none, build a manual checklist / document expected API responses / query
  baseline DB rows.
- Document tolerance (exact match vs. ±threshold) and how long validation takes.
- **Deliverable:** validation test suite or checklist + captured baseline.

**Gate:** findings are complete and evidence-backed; baseline is captured.

---

## PHASE 3 — Reporting

Produce `1_AUDIT_REPORT.md` using `templates/1_AUDIT_REPORT.md` and the
structure in `reference/report-sections.md`. Cover: executive summary, detailed
findings (with severity), files recommended for removal, code-quality metrics,
architecture assessment, dependency analysis, and prioritized recommendations.

**Gate:** present findings; get explicit approval on what to change before
Phase 4. If the user requested report-only, **stop here**.

---

## PHASE 4 — Refactoring

Apply only approved changes. Every change passes the risk gate
(`reference/risk-framework.md`) and is validated before moving on.

- **4A · Safe dead-code retirement:** follow `reference/dead-code-playbook.md`.
  Run the final evidence check (`grep -r` the name, `git log --all -- <file>`,
  `.gitignore`, dynamic-reference traps), then pick the **lightest reversible
  disposition** — deprecate-in-place or quarantine by default; delete only at
  100% confidence, self-verified, and approved. One removal per commit; run
  validation; document the disposition.
- **4B · Consolidation:** identify all instances → create shared
  function/module → update references → delete duplicates → confirm identical
  behavior.
- **4C · Structure improvements:** standardize naming (pick one convention),
  consolidate related files, rehome orphans, update imports and docs.
- **4D · Documentation updates:** accurate README, architecture diagrams,
  docstrings on public functions, data-flow docs, setup + troubleshooting.
- **4E · Configuration cleanup:** remove unused configs, consolidate duplicates,
  move secrets to `.env`, document all options, provide `.env.example`.

Commit in atomic, clearly-messaged commits so any change can be reverted alone.

**Gate:** each change validated; nothing CRITICAL changed below 100% confidence.

---

## PHASE 5 — Validation

- **5A · Tests:** run the full suite; verify pass + coverage not decreased. If
  no suite, execute the manual checklist, test entry points, check API
  contracts.
- **5B · Output comparison:** generate output with refactored code; compare to
  baseline (exact or within tolerance); investigate and document any diff; get
  approval before accepting a difference.
- **5C · Performance:** measure execution time and memory before/after; confirm
  no new bottlenecks.
- **5D · Final checklist** (record in `4_VALIDATION_RESULTS.md`):
  - [ ] All tests pass (or manual validation complete)
  - [ ] Output matches baseline
  - [ ] No regressions introduced
  - [ ] Code is documented
  - [ ] Structure is clean and consistent
  - [ ] Dead code removed
  - [ ] Dependencies mapped and cleaned
  - [ ] Configuration is secure
  - [ ] README and docs updated
  - [ ] Ready for deployment

**Gate:** sign-off only when output matches baseline and the checklist is green.

---

## Success criteria

- Complete codebase analyzed and documented.
- All dead code identified with clear justification.
- Architecture issues documented with solutions.
- Code quality improved measurably.
- All tests pass (or manual validation complete).
- Product output unchanged from baseline.
- Documentation complete and accurate.
- Recommendations actionable and prioritized; risk assessment transparent.
- User can confidently deploy the changes.
