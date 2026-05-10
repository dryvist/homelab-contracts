#!/usr/bin/env bash
# Re-render every docs/assets/*.mmd to its sibling .svg using mermaid-cli via nix.
# Used by .github/workflows/mermaid-render-check.yml; CI fails the PR if `git diff`
# reports any uncommitted .svg changes after this runs.
set -euo pipefail
for src in docs/assets/*.mmd; do
  nix run nixpkgs#mermaid-cli -- -i "$src" -o "${src%.mmd}.svg" --quiet
done
