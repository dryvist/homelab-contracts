# Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
Releases are managed automatically by [release-please](https://github.com/googleapis/release-please).

## [2.3.0](https://github.com/dryvist/homelab-contracts/compare/v2.2.0...v2.3.0) (2026-07-24)


### Features

* **deployment-json:** refuse a put that drops containers keys ([#46](https://github.com/dryvist/homelab-contracts/issues/46)) ([c866606](https://github.com/dryvist/homelab-contracts/commit/c8666062465076c5565693954947fdc4bfa25eee))

## [2.2.0](https://github.com/dryvist/homelab-contracts/compare/v2.1.0...v2.2.0) (2026-07-13)


### Features

* migrate inventory resolution to OpenBao and RustFS ([#38](https://github.com/dryvist/homelab-contracts/issues/38)) ([285f428](https://github.com/dryvist/homelab-contracts/commit/285f428a30c39edcbba513165389bac43bb2b92f))

## [2.1.0](https://github.com/dryvist/homelab-contracts/compare/v2.0.0...v2.1.0) (2026-07-10)


### Features

* accept DHCP-first container fields (mac, reserved_ip, FQDN ip) ([#7](https://github.com/dryvist/homelab-contracts/issues/7)) ([cc1b7a0](https://github.com/dryvist/homelab-contracts/commit/cc1b7a02dad07545d8308198aa55649db2b7697f))
* add review-thread-resolver caller for instant bot-thread resolution ([#20](https://github.com/dryvist/homelab-contracts/issues/20)) ([b686a9b](https://github.com/dryvist/homelab-contracts/commit/b686a9bfc98f1fb7a9e0b18ec2cb836d0bcbe515))
* flow-lock global lease tooling + shared inventory_resolve role ([#19](https://github.com/dryvist/homelab-contracts/issues/19)) ([132758f](https://github.com/dryvist/homelab-contracts/commit/132758f9c069b1ab41adbec2ce362597085477a5))
* initial schema for ansible_inventory.json v1.0.0 ([#1](https://github.com/dryvist/homelab-contracts/issues/1)) ([8063581](https://github.com/dryvist/homelab-contracts/commit/8063581a7fc6503a23203e7850c2d615f4db18eb))
* **schemas:** reconcile ansible-inventory v2 and add nautobot-export-v1 ([096ee54](https://github.com/dryvist/homelab-contracts/commit/096ee54151e0df774a71cb91e80bdf79839e130f))


### Bug Fixes

* **renovate:** drop stale shadowed renovate.json5 ([#15](https://github.com/dryvist/homelab-contracts/issues/15)) ([0fcf006](https://github.com/dryvist/homelab-contracts/commit/0fcf006de92519cda184c7ece41d371837b96d2d))
* **schemas:** resync service-ports.yaml with terraform-proxmox constants ([#17](https://github.com/dryvist/homelab-contracts/issues/17)) ([96273d8](https://github.com/dryvist/homelab-contracts/commit/96273d83cf350ae51d0091e79172a1c0062e0ec0))

## [1.10.0](https://github.com/dryvist/homelab-contracts/compare/v1.9.0...v1.10.0) (2026-07-04)


### Features

* flow-lock global lease tooling + shared inventory_resolve role ([#19](https://github.com/dryvist/homelab-contracts/issues/19)) ([132758f](https://github.com/dryvist/homelab-contracts/commit/132758f9c069b1ab41adbec2ce362597085477a5))

## [1.9.0](https://github.com/dryvist/homelab-contracts/compare/v1.8.2...v1.9.0) (2026-07-03)


### Features

* add review-thread-resolver caller for instant bot-thread resolution ([#20](https://github.com/dryvist/homelab-contracts/issues/20)) ([b686a9b](https://github.com/dryvist/homelab-contracts/commit/b686a9bfc98f1fb7a9e0b18ec2cb836d0bcbe515))

## [1.8.2](https://github.com/dryvist/homelab-schemas/compare/v1.8.1...v1.8.2) (2026-07-02)


### Bug Fixes

* **schemas:** resync service-ports.yaml with terraform-proxmox constants ([#17](https://github.com/dryvist/homelab-schemas/issues/17)) ([96273d8](https://github.com/dryvist/homelab-schemas/commit/96273d83cf350ae51d0091e79172a1c0062e0ec0))

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
