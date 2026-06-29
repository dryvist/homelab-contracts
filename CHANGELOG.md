# Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
Releases are managed automatically by [release-please](https://github.com/googleapis/release-please).

## [1.8.1](https://github.com/dryvist/homelab-schemas/compare/v1.8.0...v1.8.1) (2026-06-29)


### Bug Fixes

* **renovate:** drop stale shadowed renovate.json5 ([#15](https://github.com/dryvist/homelab-schemas/issues/15)) ([0fcf006](https://github.com/dryvist/homelab-schemas/commit/0fcf006de92519cda184c7ece41d371837b96d2d))

## [1.8.0](https://github.com/dryvist/homelab-schemas/compare/v1.7.0...v1.8.0) (2026-06-14)


### Features

* accept DHCP-first container fields (mac, reserved_ip, FQDN ip) ([#7](https://github.com/dryvist/homelab-schemas/issues/7)) ([cc1b7a0](https://github.com/dryvist/homelab-schemas/commit/cc1b7a02dad07545d8308198aa55649db2b7697f))
* initial schema for ansible_inventory.json v1.0.0 ([#1](https://github.com/dryvist/homelab-schemas/issues/1)) ([8063581](https://github.com/dryvist/homelab-schemas/commit/8063581a7fc6503a23203e7850c2d615f4db18eb))

## [1.7.0](https://github.com/dryvist/homelab-schemas/compare/v1.6.0...v1.7.0) (2026-06-12)


### Features

* accept DHCP-first container fields (mac, reserved_ip, FQDN ip) ([#7](https://github.com/dryvist/homelab-schemas/issues/7)) ([cc1b7a0](https://github.com/dryvist/homelab-schemas/commit/cc1b7a02dad07545d8308198aa55649db2b7697f))
* initial schema for ansible_inventory.json v1.0.0 ([#1](https://github.com/dryvist/homelab-schemas/issues/1)) ([8063581](https://github.com/dryvist/homelab-schemas/commit/8063581a7fc6503a23203e7850c2d615f4db18eb))

## [1.6.0](https://github.com/dryvist/homelab-schemas/compare/v1.5.0...v1.6.0) (2026-06-12)


### Features

* accept DHCP-first container fields (mac, reserved_ip, FQDN ip) ([#7](https://github.com/dryvist/homelab-schemas/issues/7)) ([cc1b7a0](https://github.com/dryvist/homelab-schemas/commit/cc1b7a02dad07545d8308198aa55649db2b7697f))
* initial schema for ansible_inventory.json v1.0.0 ([#1](https://github.com/dryvist/homelab-schemas/issues/1)) ([8063581](https://github.com/dryvist/homelab-schemas/commit/8063581a7fc6503a23203e7850c2d615f4db18eb))

## [1.5.0](https://github.com/dryvist/homelab-schemas/compare/v1.4.0...v1.5.0) (2026-06-12)


### Features

* accept DHCP-first container fields (mac, reserved_ip, FQDN ip) ([#7](https://github.com/dryvist/homelab-schemas/issues/7)) ([cc1b7a0](https://github.com/dryvist/homelab-schemas/commit/cc1b7a02dad07545d8308198aa55649db2b7697f))
* initial schema for ansible_inventory.json v1.0.0 ([#1](https://github.com/dryvist/homelab-schemas/issues/1)) ([8063581](https://github.com/dryvist/homelab-schemas/commit/8063581a7fc6503a23203e7850c2d615f4db18eb))

## [1.4.0](https://github.com/dryvist/homelab-schemas/compare/v1.3.0...v1.4.0) (2026-06-12)


### Features

* accept DHCP-first container fields (mac, reserved_ip, FQDN ip) ([#7](https://github.com/dryvist/homelab-schemas/issues/7)) ([cc1b7a0](https://github.com/dryvist/homelab-schemas/commit/cc1b7a02dad07545d8308198aa55649db2b7697f))
* initial schema for ansible_inventory.json v1.0.0 ([#1](https://github.com/dryvist/homelab-schemas/issues/1)) ([8063581](https://github.com/dryvist/homelab-schemas/commit/8063581a7fc6503a23203e7850c2d615f4db18eb))

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
