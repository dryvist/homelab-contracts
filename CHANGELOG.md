# Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
Releases are managed automatically by [release-please](https://github.com/googleapis/release-please).

## [1.3.0](https://github.com/dryvist/homelab-schemas/compare/v1.2.0...v1.3.0) (2026-06-09)


### Features

* initial schema for ansible_inventory.json v1.0.0 ([#1](https://github.com/dryvist/homelab-schemas/issues/1)) ([8063581](https://github.com/dryvist/homelab-schemas/commit/8063581a7fc6503a23203e7850c2d615f4db18eb))

## [1.2.0](https://github.com/dryvist/homelab-schemas/compare/v1.1.0...v1.2.0) (2026-06-09)


### Features

* initial schema for ansible_inventory.json v1.0.0 ([#1](https://github.com/dryvist/homelab-schemas/issues/1)) ([8063581](https://github.com/dryvist/homelab-schemas/commit/8063581a7fc6503a23203e7850c2d615f4db18eb))

## [1.1.0](https://github.com/dryvist/homelab-schemas/compare/v1.0.0...v1.1.0) (2026-06-07)


### Features

* initial schema for ansible_inventory.json v1.0.0 ([#1](https://github.com/dryvist/homelab-schemas/issues/1)) ([8063581](https://github.com/dryvist/homelab-schemas/commit/8063581a7fc6503a23203e7850c2d615f4db18eb))

## [Unreleased]

### Added

- Initial v1.0.0 JSON Schema for `ansible_inventory.json`
- Initial `service-ports.yaml` constants (extracted from `JacobPEvans/terraform-proxmox/locals.tf:pipeline_constants`)
- Reference example `examples/ansible_inventory.json`
- One-line `tests/validate.sh` invoking `check-jsonschema`
- CI workflow with semver-bump validation
- ADRs covering rationale, format choice, and versioning policy
- Mermaid diagrams: ecosystem-context, schema-versioning, consumers
