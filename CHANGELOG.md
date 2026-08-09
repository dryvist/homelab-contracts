# Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
Releases are managed automatically by [release-please](https://github.com/googleapis/release-please).

## [2.7.0](https://github.com/dryvist/homelab-contracts/compare/v2.6.0...v2.7.0) (2026-08-09)


### Features

* **ansible:** promote seven shared roles into the collection ([#66](https://github.com/dryvist/homelab-contracts/issues/66)) ([2d03604](https://github.com/dryvist/homelab-contracts/commit/2d036041a2c4d871a57a3babfceb604803749226))


### Bug Fixes

* **openbao_secrets:** stop the delegated publish escalating on the control node ([#68](https://github.com/dryvist/homelab-contracts/issues/68)) ([ab9c784](https://github.com/dryvist/homelab-contracts/commit/ab9c78429195c98da52cb45c964e41ca825e9986))

## [2.6.0](https://github.com/dryvist/homelab-contracts/compare/v2.5.0...v2.6.0) (2026-08-04)


### Features

* **inventory_resolve:** detect when an apply is owed before a converge ([#62](https://github.com/dryvist/homelab-contracts/issues/62)) ([eb4d69b](https://github.com/dryvist/homelab-contracts/commit/eb4d69b489e8ad1e49f65d2dfc91d170ca7a77cb))

## [2.5.0](https://github.com/dryvist/homelab-contracts/compare/v2.4.1...v2.5.0) (2026-07-31)


### Features

* **cribl_edge:** decompose the os catch-all index by host ([#54](https://github.com/dryvist/homelab-contracts/issues/54)) ([1e5bac0](https://github.com/dryvist/homelab-contracts/commit/1e5bac0088693091e7ccbc7e794229addf5eea17))
* **cribl_edge:** route host metrics to Splunk via the Edge's own collector ([#56](https://github.com/dryvist/homelab-contracts/issues/56)) ([3356d60](https://github.com/dryvist/homelab-contracts/commit/3356d6095040f59887e553948e6cd0a84cb85bc5))


### Bug Fixes

* **deployment-json:** default the object location instead of demanding it ([#59](https://github.com/dryvist/homelab-contracts/issues/59)) ([3454b7d](https://github.com/dryvist/homelab-contracts/commit/3454b7dccb763cd61a91df476b97880343562e4d))
* **inventory_resolve:** report the real reason, on every failure path ([#58](https://github.com/dryvist/homelab-contracts/issues/58)) ([c5e139c](https://github.com/dryvist/homelab-contracts/commit/c5e139cb7ccb286016020dd85c2f1d9c3b5a376f))
* **inventory_resolve:** say what actually failed instead of guessing ([#57](https://github.com/dryvist/homelab-contracts/issues/57)) ([d700771](https://github.com/dryvist/homelab-contracts/commit/d7007718f1532fb29dc920e7e53664676fe31734))

## [2.4.1](https://github.com/dryvist/homelab-contracts/compare/v2.4.0...v2.4.1) (2026-07-27)


### Bug Fixes

* **ansible:** install Cribl Edge from the rolling latest release ([#50](https://github.com/dryvist/homelab-contracts/issues/50)) ([6ac94ab](https://github.com/dryvist/homelab-contracts/commit/6ac94ab28b6d546d105e08a7b585aee8e22d97f6))
* **ansible:** resolve Cribl latest via the dl/latest CDN pointer ([#52](https://github.com/dryvist/homelab-contracts/issues/52)) ([5cdb9f0](https://github.com/dryvist/homelab-contracts/commit/5cdb9f0131ee38ab3fa6c113e5b17de517b056c4))

## [2.4.0](https://github.com/dryvist/homelab-contracts/compare/v2.3.0...v2.4.0) (2026-07-27)


### Features

* **ansible:** promote cribl_edge and cribl_packs to shared roles ([#48](https://github.com/dryvist/homelab-contracts/issues/48)) ([01e42fa](https://github.com/dryvist/homelab-contracts/commit/01e42fafa33ec0a2be62d2f4225ad2029153e06a))

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
