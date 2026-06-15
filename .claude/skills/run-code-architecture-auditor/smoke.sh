#!/usr/bin/env bash
# smoke.sh — validation harness for the code-architecture-auditor skill.
#
# This "app" is a Markdown-only Claude Code Skill: there is no binary, server,
# or GUI to launch. The only mechanical "does it work?" is "does it load, and
# is it internally consistent?" — because a skill that fails any check below
# will silently mis-load or emit a deliverable that contradicts its own docs.
#
# Run from anywhere; it locates the skill (the unit root) relative to itself.
# Exit 0 = green, non-zero = at least one check failed (CI-friendly).
set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
UNIT_ROOT=$(cd "$SCRIPT_DIR/../../.." && pwd)   # <unit>/.claude/skills/run-*/smoke.sh -> <unit>
cd "$UNIT_ROOT"

if [ -t 1 ]; then G=$'\033[32m'; R=$'\033[31m'; B=$'\033[1m'; N=$'\033[0m'; else G=; R=; B=; N=; fi
fail=0
pass() { printf '  %sPASS%s  %s\n' "$G" "$N" "$1"; }
err()  { printf '  %sFAIL%s  %s\n' "$R" "$N" "$1"; fail=1; }
info() { printf '\n%s%s%s\n' "$B" "$1" "$N"; }

SKILL="SKILL.md"
printf '%sValidating skill at: %s%s\n' "$B" "$UNIT_ROOT" "$N"

# ---- 1 · Manifest loads: frontmatter + folder name matches name: ----------
info "1 · Manifest loads (frontmatter + folder name)"
if [ ! -f "$SKILL" ]; then
  err "no SKILL.md at unit root — this is not a skill directory"
else
  name=$(grep -m1 '^name:' "$SKILL" | sed 's/^name:[[:space:]]*//')
  [ -n "$name" ] && pass "name: $name" || err "frontmatter missing 'name:'"
  grep -q '^description:' "$SKILL" && pass "description: present" \
    || err "frontmatter missing 'description:' (Claude can't auto-trigger without it)"
  base=$(basename "$UNIT_ROOT")
  if [ "$base" = "$name" ]; then
    pass "folder name matches name: ($base)"
  else
    err "folder '$base' != name: '$name' — the skill will NOT load"
  fi
fi

# ---- 2 · Every reference/ pointer in SKILL.md resolves ---------------------
info "2 · Reference pointers resolve (no dangling links)"
refs=$(grep -oE 'reference/[A-Za-z0-9_-]+\.md' "$SKILL" | sort -u)
[ -n "$refs" ] || err "SKILL.md points at no reference/ files — progressive disclosure broken"
for f in $refs; do
  [ -f "$f" ] && pass "exists: $f" || err "MISSING: $f (pointed to by SKILL.md)"
done

# ---- 3 · No orphan reference files (each must be linked from SKILL.md) -----
info "3 · No orphan reference files (each must be linked from SKILL.md)"
for f in reference/*.md; do
  grep -qF "$f" "$SKILL" && pass "linked: $f" \
    || err "orphan: $f exists but is never referenced in SKILL.md (will never load)"
done

# ---- 4 · Deliverable templates present -------------------------------------
info "4 · Deliverable templates present"
for t in 1_AUDIT_REPORT 2_IMPLEMENTATION_GUIDE 3_CLEANUP_CHECKLIST 4_VALIDATION_RESULTS; do
  [ -f "templates/$t.md" ] && pass "templates/$t.md" || err "missing templates/$t.md"
done

# ---- 5 · Safety model present and consistent ------------------------------
info "5 · Safety model present and consistent"
if grep -q 'Unverified' reference/risk-framework.md \
   && grep -q 'Tentative' reference/risk-framework.md \
   && grep -q 'Strong'    reference/risk-framework.md \
   && grep -q 'Verified'  reference/risk-framework.md; then
  pass "evidence ladder (Unverified->Tentative->Strong->Verified) defined"
else
  err "evidence ladder tiers missing from reference/risk-framework.md"
fi
if grep -qi 'deprecate' reference/dead-code-playbook.md \
   && grep -qi 'quarantine' reference/dead-code-playbook.md; then
  pass "deprecate-before-delete ladder defined"
else
  err "disposition ladder missing from reference/dead-code-playbook.md"
fi
# Regression guard: the old gut-percentage wording must be gone everywhere.
hits=$(grep -rn "% safe" templates reference README.md 2>/dev/null || true)
if [ -z "$hits" ]; then
  pass "no stale '% safe' gut-percentage wording in deliverables/docs"
else
  err "stale '% safe' wording found (safety model drifted):"
  printf '%s\n' "$hits" | sed 's/^/        /'
fi

# ---- 6 · Runtime behavior is defined --------------------------------------
info "6 · Runtime behavior defined"
grep -q 'READY' reference/workflow.md \
  && pass "readiness block present in reference/workflow.md" \
  || err "no readiness block in reference/workflow.md"
grep -qi 'Phase 1' reference/workflow.md \
  && pass "Phase 1 (Discovery) procedure present" \
  || err "no Phase 1 procedure in reference/workflow.md"

# ---- verdict --------------------------------------------------------------
echo
if [ "$fail" -eq 0 ]; then
  printf '%sALL CHECKS PASSED%s — skill is well-formed and internally consistent.\n' "$G" "$N"
else
  printf '%sSMOKE TEST FAILED%s — fix the above before publishing.\n' "$R" "$N"
fi
exit $fail
