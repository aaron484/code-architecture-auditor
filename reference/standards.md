# Standards & Edge-Case Playbooks

The quality bars the auditor holds code to, and how to handle the situations
that come up mid-audit.

---

## Professional standards

### Code quality
- Docstrings/comments explain **why**, not what.
- Functions are ≤ 50 lines (split if longer) and do one thing.
- Variable names are self-documenting.
- No magic numbers — use named constants.
- No commented-out code — it belongs in git history.
- DRY — no duplicated logic.

### Documentation
- README explains purpose, setup, and usage.
- Architecture documented with a diagram.
- Data flows documented.
- API contracts documented (for API projects).
- Configuration options documented.
- Troubleshooting section included.

### Testing
- All public functions tested.
- Edge cases and error conditions covered.
- Tests are isolated (no interdependencies) with clear names.
- Coverage ≥ 80% for core logic. *(If the project has no test suite, report
  coverage as `n/a` and raise the absence itself as a finding — don't score the
  project against a bar it can't meet.)*

### Configuration
- Secrets never in code — use `.env`. Secrets already committed must be
  **rotated**, not just relocated — git history keeps the old value
  (`reference/security.md`).
- Environment-specific configs separated (dev/staging/prod).
- All config options documented.
- `.env.example` provided as a template.
- Validate config on startup (fail fast if invalid).

---

## Edge-case playbooks

**Test suite fails after a change**
1. Revert that specific change. 2. Investigate root cause. 3. Fix the test or
the code. 4. Re-run. Never leave the suite red.

**Output doesn't match baseline**
1. Trace the code path. 2. Identify exactly what changed. 3. Decide if the
difference is acceptable. 4. Document it with justification. 5. Get user
approval before accepting it.

**Circular dependencies found**
1. Document every cycle. 2. Propose a refactor to break it (extract shared
module, invert dependency, introduce an interface). 3. Implement with careful
testing. 4. Verify no behavior change.

**External API calls fail**
1. Document endpoints and contracts. 2. Note auth requirements. 3. Flag as an
external-dependency risk. 4. Recommend timeout + retry/backoff logic. Do not
treat a transient external failure as a code defect.

**Missing requirements / dependencies**
1. Request from the user. 2. Document what's needed and why. 3. Do not proceed
on that thread until provided — note it as blocked.

---

## Interaction habits

Ask clarifying questions throughout:
- "Is this file supposed to be here, or is it orphaned?"
- "Can we remove this? It isn't referenced anywhere I can find."
- "Should we consolidate these similar functions?"
- "I see a discrepancy in this output — is the baseline correct?"

Be transparent about decisions:
- "I'm removing X because <reason>."
- "I'm NOT removing Y even though it looks dead because <reason>."
- "This refactor will <consequence> — is that acceptable?"
- "I need your approval before <risky change>."

Always explain the trade-off:
- "Improves readability but adds ~2 hours of work."
- "Safe, but requires re-running the suite."
- "Low-risk, but we should still validate output."

---

## Special instructions (the spine of every decision)

1. Always establish baseline output **before** making changes.
2. Never remove code without high confidence.
3. Always validate that the product still works.
4. Always document your reasoning.
5. Always ask for clarification if uncertain.
6. Always prioritize safety over speed.
7. Always provide evidence for recommendations.
8. Always be transparent about what you did and why.
