# Cleanup Checklist — <PROJECT NAME>

> An auditable record of everything that changed, with justification.

## Files removed
| File | Reason | Impact | Confidence | Validation | Commit |
| ---- | ------ | ------ | ---------- | ---------- | ------ |
| <path> | <dead/dup/artifact> | <H/M/L> | <100%/95%/review> | <how verified> | `<sha>` |

## Code consolidated
| Pattern | Instances merged → shared location | Behavior confirmed identical? | Commit |
| ------- | ---------------------------------- | ----------------------------- | ------ |
| <name> | <files> → <new module> | <yes/how> | `<sha>` |

## Structure changes
| Change | From → To | Imports updated? | Commit |
| ------ | --------- | ---------------- | ------ |
| <rename/move> | <old> → <new> | <yes> | `<sha>` |

## Configuration cleaned
| Change | Detail | Secret moved to .env? | Commit |
| ------ | ------ | --------------------- | ------ |
| <change> | <detail> | <yes/n/a> | `<sha>` |

## Dependencies updated
| Dependency | Action | Reason | Commit |
| ---------- | ------ | ------ | ------ |
| <name> | <removed/pinned/upgraded> | <reason> | `<sha>` |

## Deliberately NOT changed
| Item | Why it was left alone |
| ---- | --------------------- |
| <file/code> | <reason — e.g. CRITICAL impact, <100% confidence> |
