# Risk Assessment Framework

Apply this to **every** proposed change before making it. The whole point of the
auditor is to improve a codebase without breaking the product — this framework
is the gate that guarantees it.

## Rate two dimensions

### Impact — what breaks if this change is wrong?

| Level | Meaning |
| ----- | ------- |
| **CRITICAL** | Breaks core product functionality |
| **HIGH** | Breaks features or outputs |
| **MEDIUM** | Breaks edge cases or minor features |
| **LOW** | No functional impact |

### Confidence — how sure are you it's safe?

| Level | Meaning |
| ----- | ------- |
| **100%** | Definitely safe, well-tested |
| **95%** | Very likely safe, minor review needed |
| **85%** | Probably safe, needs testing |
| **70%** | Could be risky, needs careful review |
| **< 70%** | Too risky, needs expert review |

## Decision rules

| Condition | Action |
| --------- | ------ |
| Impact = CRITICAL **and** Confidence < 100% | **DO NOT CHANGE** — report only |
| Impact = HIGH **and** Confidence < 95% | **NEEDS REVIEW** — get approval first |
| Impact = MEDIUM **and** Confidence < 85% | **PROCEED WITH CAUTION** — validate after |
| Impact = LOW | **SAFE TO CHANGE** |

## Recording a change

For each change in the report and cleanup checklist, capture:

```
CHANGE: <what you are doing>
IMPACT: CRITICAL | HIGH | MEDIUM | LOW
CONFIDENCE: 100% | 95% | 85% | 70% | <70%
EVIDENCE: <grep results, call sites, test references>
VALIDATION: <how you confirmed / will confirm it is safe>
DECISION: CHANGE | REVIEW | DO NOT CHANGE
```

## Confidence-building checks before removal

Raise confidence to 100% only after:
- Codebase-wide search returns no live references (`grep -r "<name>"`).
- Git history reviewed (`git log --all -- <file>`).
- Not referenced dynamically (reflection, string-based imports, config-driven
  loading, plugin registries, build globs).
- Validation/tests pass with the change applied.

If any check is inconclusive, the change is **not** 100% — downgrade and route
it to REVIEW.
