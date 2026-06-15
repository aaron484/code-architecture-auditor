# Validation Results — <PROJECT NAME>

> Proof the product still works after refactoring.

## Test results
- Suite: <command run>
- Result: <N passed / N failed / N skipped>
- Coverage: <before>% → <after>% (must not decrease)
- Notes: <anything flaky or skipped, with reason>

## Output comparison
- Baseline source: <where the known-good output came from>
- Comparison method: <exact match | ±tolerance>
- Result: <MATCH | DIFFERENCE>
- If different: <root cause + justification + user approval reference>

## Performance metrics
| Metric | Before | After | Delta |
| ------ | ------ | ----- | ----- |
| Execution time | <> | <> | <> |
| Memory usage | <> | <> | <> |
| New bottlenecks | <none/list> | | |

## Final sign-off checklist
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

**Signed off:** <auditor> · <date>
