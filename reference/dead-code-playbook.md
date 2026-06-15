# Dead-Code Playbook — Deprecate Before You Delete

Removing "dead" code that turns out to be live is the single most common way an
audit breaks a product. This playbook makes removal **reversible by default**.
The default disposition is **deprecate or quarantine — not delete.** A hard
delete is the last rung of a ladder, taken only with 100% evidence and approval.

Apply this together with the Risk Assessment Framework
(`reference/risk-framework.md`): the evidence checklist there is what earns the
confidence a removal requires.

---

## Step 1 — Prove it is actually dead

A symbol with no obvious caller is a *candidate*, not a verdict. Before flagging
anything, run the full evidence checklist in `reference/risk-framework.md`
(static search, dynamic-reference check, git history, validation). Code is dead
**only** when every check confirms it.

### False-positive traps — "looks dead, is live"

Static call-graph analysis misses all of these. Rule each one out explicitly:

- **Dynamic dispatch / reflection** — `getattr`, `eval`, method lookup by
  string, `__getattr__`, Java/C# reflection, Ruby `send`.
- **String-based / config-driven loading** — class paths in YAML/JSON/env,
  dependency-injection containers, plugin registries, service locators.
- **Build/runtime globs** — files pulled in by `import *`, autoload, glob
  patterns, `__init__.py` re-exports, barrel `index.ts` files.
- **External entry points** — CLI commands, cron/scheduler targets, CI job
  scripts, webhook/HTTP handlers, message-queue consumers, Lambda handlers.
  Nothing *inside* the repo calls them; something *outside* does.
- **Public/exported API surface** — anything another repo, package consumer, or
  downstream service imports. If the project is a library, exported = live.
- **Framework conventions** — Django signals/management commands, pytest
  fixtures and `conftest.py`, Rails callbacks, serializer/migration classes,
  event handlers wired by decorator or naming convention.
- **Generated or contract-bound code** — protobuf/OpenAPI stubs, ORM models
  mapped to live tables, i18n message keys, DB migrations (never "dead", even
  when their code path is gone — they encode history).
- **Test-only helpers** — used only by tests is *not* dead; it is test support.

> If a candidate could plausibly hit any trap above and you cannot rule it out
> with evidence, it is **not** dead. Report it as *suspected-dead, unverified*
> and ask the owner — do not remove it.

---

## Step 2 — Choose the lightest reversible disposition

Pick the **highest rung you can fully justify**, and prefer a lighter rung when
in doubt. Every disposition is its own atomic, single-purpose commit so it can
be reverted alone.

| Rung | Disposition | When | Reversibility |
| ---- | ----------- | ---- | ------------- |
| **0** | **Leave + flag** | Suspected dead but a trap can't be ruled out, or Impact is CRITICAL/HIGH below 100% confidence | Nothing changes; reported only |
| **1** | **Deprecate in place** | Confirmed dead, but it is public API, recently touched, or risky to move | Instant — annotation only |
| **2** | **Quarantine** | Confirmed dead, internal, safe to relocate | Instant — `git revert` of one commit |
| **3** | **Delete** | Confirmed dead, 100% evidence, observed/approved, validation green | Recoverable from git history only |

### Rung 1 — Deprecate in place
Mark it, don't move it. Add the language's deprecation marker (`@deprecated`,
`@Deprecated`, `warnings.warn(..., DeprecationWarning)`, a `// DEPRECATED:`
banner) plus a one-line reason and the date. The code still runs, so nothing
breaks; you have signalled intent and started the clock.

### Rung 2 — Quarantine
Move the code, unchanged, into a clearly-named holding area in a single commit:
a `deprecated/` or `_graveyard/` directory, or behind a default-off feature
flag. Update imports so the product still builds. Because behavior is unchanged
and the move is one commit, a single `git revert` restores it instantly if
something downstream was depending on it after all. This is the **preferred**
disposition for confirmed-dead internal code.

### Rung 3 — Delete
Only when **all** hold:
- The `reference/risk-framework.md` evidence checklist is fully green (100%).
- A self-verification pass (see that file) re-confirms the removal.
- Either the code has sat quarantined through an agreed observation window, **or**
  the user has explicitly approved deleting it outright.
- Validation/tests pass with it gone.

Delete in an isolated commit whose message names what was removed and why
("git history is the backup"). Never bundle a delete with unrelated changes.

---

## Step 3 — Record the disposition

In the audit report's removal section (`reference/report-sections.md` → 3C),
every candidate carries a `DISPOSITION:` of `leave | deprecate | quarantine |
delete` with the evidence that justifies that rung. Anything at rung 3 also
shows the self-verification result.

## Guardrails

- **Never delete on first pass.** Discovery and reporting never delete; only an
  approved Phase 4 does, and even then quarantine is the default.
- **One removal per commit.** Bundled removals can't be reverted surgically.
- **CRITICAL-impact code is never deleted below 100% confidence** — it is
  reported, per the risk framework's `DO NOT CHANGE` rule.
- **Migrations, generated code, and i18n keys are out of scope for deletion**
  unless the owner confirms — they often look dead and are not.
