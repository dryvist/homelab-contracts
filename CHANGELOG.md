# Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
Releases are managed automatically by [release-please](https://github.com/googleapis/release-please).

## [3.7.0](https://github.com/dryvist/homelab-contracts/compare/v3.6.1...v3.7.0) (2026-10-07)


### Features

* add shared router key catalog ([d9b1dd9](https://github.com/dryvist/homelab-contracts/commit/d9b1dd94d1f36030b82d4e9390c74fb786ab9877))
* add shared router key catalog ([6c7769c](https://github.com/dryvist/homelab-contracts/commit/6c7769c74c0f509adca2cca7a573ba177eb6205b))

## [3.6.1](https://github.com/dryvist/homelab-contracts/compare/v3.6.0...v3.6.1) (2026-10-07)


### Bug Fixes

* **cribl_edge:** apply the queued restart before cribl_packs ends the host ([#127](https://github.com/dryvist/homelab-contracts/issues/127)) ([b6ca769](https://github.com/dryvist/homelab-contracts/commit/b6ca7699875cc885a749cb3e7003fc0a718aa981))

## [3.6.0](https://github.com/dryvist/homelab-contracts/compare/v3.5.2...v3.6.0) (2026-10-07)


### Features

* **cribl_edge:** opt-in scrape of local node_exporter hardware sensors ([#125](https://github.com/dryvist/homelab-contracts/issues/125)) ([469cd58](https://github.com/dryvist/homelab-contracts/commit/469cd58dbf3c8d94eab341c1dceff0a41354aede))

## [3.5.2](https://github.com/dryvist/homelab-contracts/compare/v3.5.1...v3.5.2) (2026-10-06)


### Bug Fixes

* **catalog:** restore lineage for squashed mlx profile commit 2f397694 ([960c483](https://github.com/dryvist/homelab-contracts/commit/960c4831bafe07cb696158ac5308965dccf0ce9d))

## [3.5.1](https://github.com/dryvist/homelab-contracts/compare/v3.5.0...v3.5.1) (2026-10-06)


### Bug Fixes

* **flow-lock:** skip revoking a single-use secret_id the login consumed ([#121](https://github.com/dryvist/homelab-contracts/issues/121)) ([a7b738a](https://github.com/dryvist/homelab-contracts/commit/a7b738aa99e0d84d7b536d91f8f6e287c4c6be8b))

## [3.5.0](https://github.com/dryvist/homelab-contracts/compare/v3.4.2...v3.5.0) (2026-10-05)


### Features

* **flow-lock:** add per-call AppRole token command ([#119](https://github.com/dryvist/homelab-contracts/issues/119)) ([86bd2a7](https://github.com/dryvist/homelab-contracts/commit/86bd2a767fb53c538db7e3f5199b2212086ea9aa))

## [3.4.2](https://github.com/dryvist/homelab-contracts/compare/v3.4.1...v3.4.2) (2026-10-05)


### Bug Fixes

* mint flow-lock credentials through approle-issuer ([62b7250](https://github.com/dryvist/homelab-contracts/commit/62b72502177895f302c27755cea7ff8b80ea07d0))

## [3.4.1](https://github.com/dryvist/homelab-contracts/compare/v3.4.0...v3.4.1) (2026-10-05)


### Bug Fixes

* **catalog:** validate backend capacity profiles ([#114](https://github.com/dryvist/homelab-contracts/issues/114)) ([850d4b6](https://github.com/dryvist/homelab-contracts/commit/850d4b60aa661ac55ea5884693266f78cc4bf307))

## [3.4.0](https://github.com/dryvist/homelab-contracts/compare/v3.3.0...v3.4.0) (2026-10-04)


### Features

* publish the shared model catalog as JSON profiles ([#112](https://github.com/dryvist/homelab-contracts/issues/112)) ([8e66995](https://github.com/dryvist/homelab-contracts/commit/8e669950f9387ab6e4597b0521ecf070af39b9cd))

## [3.3.0](https://github.com/dryvist/homelab-contracts/compare/v3.2.2...v3.3.0) (2026-10-04)


### Features

* add shared model limits to the catalog ([#110](https://github.com/dryvist/homelab-contracts/issues/110)) ([3f613aa](https://github.com/dryvist/homelab-contracts/commit/3f613aadadc0c44e97b8a1e316e100ec085bd815))

## [3.2.2](https://github.com/dryvist/homelab-contracts/compare/v3.2.1...v3.2.2) (2026-10-04)


### Bug Fixes

* **cribl-packs:** wrap release URL expression ([#108](https://github.com/dryvist/homelab-contracts/issues/108)) ([97bfd2e](https://github.com/dryvist/homelab-contracts/commit/97bfd2e1b004ff36e2f2b7ff37064bb4789ac3d9))

## [3.2.1](https://github.com/dryvist/homelab-contracts/compare/v3.2.0...v3.2.1) (2026-10-04)


### Bug Fixes

* route Edge traces to Langfuse and Phoenix ([#106](https://github.com/dryvist/homelab-contracts/issues/106)) ([ded7355](https://github.com/dryvist/homelab-contracts/commit/ded735510ac3d706b19c90d830a96e03f1a08e14))

## [3.2.0](https://github.com/dryvist/homelab-contracts/compare/v3.1.0...v3.2.0) (2026-10-04)


### Features

* **cribl:** add Cribl version catalog ([#104](https://github.com/dryvist/homelab-contracts/issues/104)) ([2dfae71](https://github.com/dryvist/homelab-contracts/commit/2dfae712ff90e16d73dfc95ec504000dd644dc6e))

## [3.1.0](https://github.com/dryvist/homelab-contracts/compare/v3.0.0...v3.1.0) (2026-10-03)


### Features

* **openbao_secrets:** read generic SECRET_STORE_* names first ([b7de356](https://github.com/dryvist/homelab-contracts/commit/b7de356116ff69b4324be1cdfd9530f99082acd2))
* **openbao_secrets:** read generic SECRET_STORE_* names first ([77b91e1](https://github.com/dryvist/homelab-contracts/commit/77b91e1c50ca99348a86cdfbeee75c48daacde95))

## [3.0.0](https://github.com/dryvist/homelab-contracts/compare/v2.12.0...v3.0.0) (2026-10-03)


### ⚠ BREAKING CHANGES

* **ansible:** remove service_deadman from the collection ([#98](https://github.com/dryvist/homelab-contracts/issues/98))

### Bug Fixes

* **ansible:** remove service_deadman from the collection ([#98](https://github.com/dryvist/homelab-contracts/issues/98)) ([dd4e317](https://github.com/dryvist/homelab-contracts/commit/dd4e3171840071ef4db31969549744e2a21850a9))
* **converge_gate:** keep the cap task name within 120 columns ([#101](https://github.com/dryvist/homelab-contracts/issues/101)) ([4193022](https://github.com/dryvist/homelab-contracts/commit/41930223c704c571f9c0f97856a0b9624ae58765))
* **openbao_secrets:** resolve OPENBAO_APPROLE_&lt;DOMAIN&gt; pairs before the legacy names ([#100](https://github.com/dryvist/homelab-contracts/issues/100)) ([8454c14](https://github.com/dryvist/homelab-contracts/commit/8454c141b4417b6bc387a41ff5dcfad19d596444))

## [2.12.0](https://github.com/dryvist/homelab-contracts/compare/v2.11.0...v2.12.0) (2026-10-02)


### Features

* **llm-roles:** judge role egress none -&gt; estate ([#96](https://github.com/dryvist/homelab-contracts/issues/96)) ([8204ff0](https://github.com/dryvist/homelab-contracts/commit/8204ff0ba00e5d88f1e5100f637e930063b88b27))

## [2.11.0](https://github.com/dryvist/homelab-contracts/compare/v2.10.0...v2.11.0) (2026-10-02)


### Features

* **inventory:** add workstation_connections and ingress fqdn/host_aliases/tls_domains ([#94](https://github.com/dryvist/homelab-contracts/issues/94)) ([324b59d](https://github.com/dryvist/homelab-contracts/commit/324b59dd70c5bd5f145f28ea6ab4aa070f55fae9))

## [2.10.0](https://github.com/dryvist/homelab-contracts/compare/v2.9.0...v2.10.0) (2026-10-02)


### Features

* **llm_roles:** add canonical model-role map role and schema ([#92](https://github.com/dryvist/homelab-contracts/issues/92)) ([51589f6](https://github.com/dryvist/homelab-contracts/commit/51589f6ae819bdf1d50870801c9e6ac87a44e0de))

## [2.9.0](https://github.com/dryvist/homelab-contracts/compare/v2.8.0...v2.9.0) (2026-10-01)


### Features

* **ansible:** add shared converge wall-clock budget gate ([#89](https://github.com/dryvist/homelab-contracts/issues/89)) ([5325b85](https://github.com/dryvist/homelab-contracts/commit/5325b85229e7d310fc996793559a3e0997f46b89))
* **cribl_edge:** enable GPU metrics and add a Stream S2S metrics output ([#87](https://github.com/dryvist/homelab-contracts/issues/87)) ([2895b6c](https://github.com/dryvist/homelab-contracts/commit/2895b6c41b89e0a4d02bc3c4d91cddecb7023346))
* **cribl_edge:** optional UniFi IPS/IDS fan-out to Slack and Zammad ([#91](https://github.com/dryvist/homelab-contracts/issues/91)) ([63396ad](https://github.com/dryvist/homelab-contracts/commit/63396adbfd51e2bfff099749faade70548525d97))
* **llm_model_catalog:** add shared GGUF catalog role ([#90](https://github.com/dryvist/homelab-contracts/issues/90)) ([767b8ff](https://github.com/dryvist/homelab-contracts/commit/767b8ff7c77ab188ca5dbb92289683b902c39bec))

## [2.8.0](https://github.com/dryvist/homelab-contracts/compare/v2.7.4...v2.8.0) (2026-09-24)


### Features

* **converge_telemetry:** add a shared converge-freshness callback plugin ([#86](https://github.com/dryvist/homelab-contracts/issues/86)) ([ee8d1dd](https://github.com/dryvist/homelab-contracts/commit/ee8d1ddc387bf4877a2b4ef7ea25cb26dd1cf181))
* **openbao_secrets:** accept an operator AppRole pair as the last fallback ([#84](https://github.com/dryvist/homelab-contracts/issues/84)) ([1722a3b](https://github.com/dryvist/homelab-contracts/commit/1722a3b28192b04449be19c376704f2db6ac95bb))

## [2.7.4](https://github.com/dryvist/homelab-contracts/compare/v2.7.3...v2.7.4) (2026-09-20)


### Bug Fixes

* **inventory:** ingress rows may carry response_header_timeout ([#78](https://github.com/dryvist/homelab-contracts/issues/78)) ([9ad5ba2](https://github.com/dryvist/homelab-contracts/commit/9ad5ba235509d5c123cfc7a453b40afd9fed6014))

## [2.7.3](https://github.com/dryvist/homelab-contracts/compare/v2.7.2...v2.7.3) (2026-09-19)


### Bug Fixes

* **docker_engine:** re-align the shared role with its ansible-proxmox-apps copy ([8c5a044](https://github.com/dryvist/homelab-contracts/commit/8c5a044c8f6d1e357354fc250542fa2274eeeaf2))
* **docker_engine:** re-align the shared role with its ansible-proxmox-apps copy ([3bcf3b6](https://github.com/dryvist/homelab-contracts/commit/3bcf3b66ac47c0f5db090cc57dff3eb8cbc63b0d))

## [2.7.2](https://github.com/dryvist/homelab-contracts/compare/v2.7.1...v2.7.2) (2026-09-12)


### Bug Fixes

* **service_deadman:** build the ntfy URL from the ingress subdomain ([5830aa4](https://github.com/dryvist/homelab-contracts/commit/5830aa4121857d748b3903e628e26b91d2d90a81))
* **service_deadman:** build the ntfy URL from the ingress subdomain ([c803a0c](https://github.com/dryvist/homelab-contracts/commit/c803a0ca88c898b83a11d65b63eb886ac32ee2bc))

## [2.7.1](https://github.com/dryvist/homelab-contracts/compare/v2.7.0...v2.7.1) (2026-08-31)


### Bug Fixes

* **deployment-json:** preserve edit cleanup state ([#53](https://github.com/dryvist/homelab-contracts/issues/53)) ([#70](https://github.com/dryvist/homelab-contracts/issues/70)) ([80ebe92](https://github.com/dryvist/homelab-contracts/commit/80ebe92a7de92f472f54dc4695adcebac9eb5e12))

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
