#!/usr/bin/env bash
# Single-line CLI pass-through. No logic. Add orchestration to .github/workflows/ci.yml instead.
exec nix run nixpkgs#check-jsonschema -- --schemafile schemas/ansible-inventory-v1.json examples/ansible_inventory.json
