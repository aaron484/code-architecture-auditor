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

### Confidence — earned by evidence, never felt

Confidence is **not a gut percentage.** It is the set of checks you have
actually completed. You may claim a tier only when **every box at that tier and
below is ticked.** If one box is unchecked, you are at most the tier beneath it
— **no rounding up.** The percentages are labels for the tiers, not a feeling to
dial in.

| Tier | Earned when… (all boxes below it, plus its own) |
| ---- | ----------------------------------------------- |
| **Unverified** (<85%) — *default* | You have a hunch or only partial evidence. **Never act.** |
| **Tentative** (~85%) | ☐ Static search done — `grep -r "<name>"` / IDE find-references shows no live caller. ☐ Reasoning written down (what it is, why it looks safe). |
| **Strong** (~95%) | ☐ Dynamic-reference traps ruled out (reflection, string/config-driven loading, DI/plugin registries, build globs, external entry points, public/exported API — see `reference/dead-code-playbook.md`). ☐ Git history reviewed — `git log --all -- <path>`. ☐ Change is reversible: isolated atomic commit, and for dead code the lightest disposition (deprecate/quarantine over delete). |
| **Verified** (100%) | ☐ Validation/tests pass with the change **applied**. ☐ A **self-verification pass** (below) independently re-confirms it. |

## Decision rules

A change may proceed only when its earned tier meets the bar for its Impact.

| Impact | Minimum earned tier to change | If below that |
| ------ | ----------------------------- | ------------- |
| **CRITICAL** | **Verified** (100%) | **DO NOT CHANGE** — report only |
| **HIGH** | **Strong** (~95%) | **NEEDS REVIEW** — get approval first |
| **MEDIUM** | **Tentative** (~85%) | **PROCEED WITH CAUTION** — validate after |
| **LOW** | — | **SAFE TO CHANGE** |

## Self-verification pass

Required before any **CRITICAL-impact** change, any **delete**, and before a
finding is reported at **CRITICAL** severity. It is a deliberate attempt to
*disprove* your own conclusion — fresh eyes, not a re-read.

1. **Re-derive from scratch.** Independently re-establish the claim without
   reusing your earlier notes. If you can't reproduce it, it isn't solid.
2. **Try to break it.** State the one thing that, if true, would make this wrong
   (a hidden caller, a dynamic reference, a config that flips behavior) and go
   look for it. Check the false-positive traps in `dead-code-playbook.md`.
3. **Re-confirm the evidence.** Re-run the searches/tests; verify the file and
   line numbers still say what you claimed.
4. **Record the result.** Add a `VERIFIED:` line — what you re-checked and the
   outcome. If the pass surfaced any doubt, drop a tier and route to REVIEW.

## Recording a change

For each change in the report and cleanup checklist, capture:

```
CHANGE:     <what you are doing>
IMPACT:     CRITICAL | HIGH | MEDIUM | LOW
CONFIDENCE: Verified | Strong | Tentative | Unverified  (list the ticked boxes)
EVIDENCE:   <grep results, call sites, git history, test references>
VERIFIED:   <self-verification result — required for CRITICAL changes & deletes>
VALIDATION: <how you confirmed / will confirm it is safe>
DECISION:   CHANGE | REVIEW | DO NOT CHANGE
```

If any required box is unticked, the change is **not** at that tier — downgrade
it and route to REVIEW or DO NOT CHANGE per the decision rules.
