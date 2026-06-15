# Implementation Guide — <PROJECT NAME>

> How to deploy the refactored code safely, and how to undo it if needed.

## Changes made
<!-- High-level list of what changed and why. Link to commits. -->
- <change> — <reason> — commit `<sha>`

## Deployment steps
1. <step>
2. <step>
3. <step>

## Migration steps (if any)
- <data/schema/config migration, in order; note anything irreversible>

## Testing procedure
1. <how to run the test suite / validation checklist>
2. <expected result>
3. <how to confirm output matches baseline>

## Rollback procedure
1. <exact steps to revert — e.g. `git revert <sha>` / redeploy previous tag>
2. <how to confirm rollback restored the baseline>

## Validation results
- Tests: <pass/fail + coverage>
- Output vs. baseline: <match | diff + justification>
- Performance: <before → after>
