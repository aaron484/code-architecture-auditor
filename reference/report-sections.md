# Report Sections — Audit Report Structure

The Phase 3 audit report (`templates/1_AUDIT_REPORT.md`) must contain these
sections, in this order. Use the exact block formats below so reports are
consistent and machine-scannable.

## 3A · Executive summary
- Project name & purpose.
- Codebase size (files, lines of code, languages).
- Overall health score (1–10) with one-line justification.
- Top 3 issues.
- Estimated effort to fix.

## 3B · Detailed findings

One block per finding:

```
CATEGORY:       Dead Code | Architecture | Quality | Dependencies | Security | Config
SEVERITY:       CRITICAL | HIGH | MEDIUM | LOW
ISSUE:          <brief description>
LOCATION:       <file path : line numbers>
EVIDENCE:       <why this is an issue — concrete proof>
RECOMMENDATION: <how to fix it>
RISK:           <what could break if we fix this>
EFFORT:         <1 hour | 1 day | 1 week>
```

Order findings by severity (CRITICAL first), then by effort (quick wins first
within a severity).

## 3C · Files recommended for removal

One block per file:

```
FILE:       path/to/file
REASON:     Dead code | Duplicate | Test artifact | Deprecated | Generated
IMPACT:     HIGH | MEDIUM | LOW   (what breaks if removed)
CONFIDENCE: 100% safe | 95% safe | Needs review
VALIDATION: <how to verify it is safe to remove>
```

## 3D · Code-quality metrics

```
Metric                          Current    Target    Status
─────────────────────────────────────────────────────────
Files with docstrings           __%        90%       ❌/⚠️/✅
Test coverage                   __%        80%       ❌/⚠️/✅
Cyclomatic complexity avg       __         < 5       ❌/⚠️/✅
Code duplication rate           __%        < 5%      ❌/⚠️/✅
Unused dependencies             __         0         ❌/⚠️/✅
Dead code files                 __         0         ❌/⚠️/✅
```

Fill real measured numbers. If a metric can't be measured with available
tooling, write `n/a` and say why — never invent a number.

## 3E · Architecture assessment

```
Aspect                  Status         Issues
────────────────────────────────────────────
Separation of concerns  ✅/⚠️/❌        <list>
Scalability             ✅/⚠️/❌        <list>
Error handling          ✅/⚠️/❌        <notes>
Data flow clarity       ✅/⚠️/❌        <list>
Documentation           ✅/⚠️/❌        <list>
```

## 3F · Dependency analysis

```
Dependency Type        Count    Health
──────────────────────────────────────
Production deps        __       ✅/⚠️/❌
Dev deps               __       ✅/⚠️/❌
Circular imports       __       ✅/⚠️/❌
Outdated packages      __       ✅/⚠️/❌
Unused imports         __       ✅/⚠️/❌
```

## 3G · Prioritized recommendations
Rank by impact ÷ effort. Each item: what to do, why, expected benefit, risk
level, and the phase/order to do it in. Separate **quick wins** (safe, low
effort) from **strategic** (higher effort or risk, needs review).
