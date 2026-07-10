#!/usr/bin/env bash
# Compare every schema in schemas/ against its latest frozen snapshot in
# versions/. Any diff requires a corresponding versions/<vX.Y.Z>/<snapshot> or CI
# fails — this is the breaking-change gate (ADR 0003). versions/<vX.Y.Z>/ dirs are
# keyed per schema version, so each schema owns its own snapshot file and the two
# contract schemas version independently.
set -euo pipefail

# Diff one schema against the highest-versioned snapshot that carries it.
check_schema() {
  schema="$1"
  snap="$2"
  latest=""
  while IFS= read -r ver; do
    [ -f "versions/${ver}/${snap}" ] && latest="$ver"
  done < <(
    for dir in versions/v*; do
      [ -d "$dir" ] || continue
      printf '%s\n' "${dir#versions/}"
    done | sort -V
  )
  if [ -z "$latest" ]; then
    echo "FAIL: no versions/*/${snap} snapshot found for ${schema}" >&2
    return 1
  fi
  echo "# ${schema} vs versions/${latest}/${snap}"
  diff -u "versions/${latest}/${snap}" "$schema"
}

status=0
check_schema schemas/ansible-inventory-v1.json ansible-inventory.json || status=1
check_schema schemas/nautobot-export-v1.json nautobot-export.json || status=1
exit "$status"
