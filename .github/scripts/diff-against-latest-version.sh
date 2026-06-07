#!/usr/bin/env bash
# Compare schemas/ansible-inventory-v1.json against the latest snapshot in versions/.
# Any diff requires a corresponding versions/<vX.Y.Z>/ snapshot or CI fails — this
# is the breaking-change gate.
set -euo pipefail
latest=$(ls versions/ | sort -V | tail -1)
diff -u "versions/${latest}/ansible-inventory.json" schemas/ansible-inventory-v1.json
