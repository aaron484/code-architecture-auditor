# Cleanup Checklist — <PROJECT NAME>

> An auditable record of everything that changed, with justification.

## Files retired
<!-- Disposition per reference/dead-code-playbook.md: deprecate/quarantine by default; delete only at Verified (100%) + self-verified. -->
| File | Reason | Impact | Disposition | Confidence | Validation | Commit |
| ---- | ------ | ------ | ----------- | ---------- | ---------- | ------ |
| <path> | <dead/dup/artifact> | <H/M/L> | <deprecate/quarantine/delete> | <Tentative/Strong/Verified> | <how verified> | `<sha>` |

## Code consolidated
| Pattern | Instances merged → shared location | Behavior confirmed identical? | Commit |
| ------- | ---------------------------------- | ----------------------------- | ------ |
| <name> | <files> → <new module> | <yes/how> | `<sha>` |

## Structure changes
| Change | From → To | Imports updated? | Commit |
| ------ | --------- | ---------------- | ------ |
| <rename/move> | <old> → <new> | <yes> | `<sha>` |

## Configuration cleaned
| Change | Detail | Secret rotated + moved to .env? | Commit |
| ------ | ------ | ------------------------------- | ------ |
| <change> | <detail> | <rotated+moved / n/a> | `<sha>` |

## Dependencies updated
| Dependency | Action | Reason | Commit |
| ---------- | ------ | ------ | ------ |
| <name> | <removed/pinned/upgraded> | <reason> | `<sha>` |

## Deliberately NOT changed
| Item | Why it was left alone |
| ---- | --------------------- |
| <file/code> | <reason — e.g. CRITICAL impact below Verified confidence> |
