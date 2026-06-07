#!/usr/bin/env bash
# Re-render every docs/assets/*.mmd to a sibling .svg using the
# minlag/mermaid-cli docker image. Same image is used in CI; same image is
# used locally; SVG output stays byte-identical so the diff gate is trustable.
set -euo pipefail

IMAGE="${MERMAID_CLI_IMAGE:-minlag/mermaid-cli:latest}"

for src in docs/assets/*.mmd; do
  [ -f "$src" ] || continue
  echo "rendering $src"
  docker run --rm -u "$(id -u):$(id -g)" -v "$PWD:/data" "$IMAGE" \
    -i "/data/$src" -o "/data/${src%.mmd}.svg" --quiet
done
