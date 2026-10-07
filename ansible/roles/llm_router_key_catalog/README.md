# llm_router_key_catalog

Single-source catalog for the OpenBao field used by the shared LiteLLM
benchmark virtual key.

## What it loads

The role reads `files/router-key-catalog.json` and publishes:

- `llm_router_key_catalog_facts.llm_router_key_catalog_source` — the benchmark
  field name.
- `llm_router_key_catalog_facts.openbao_router_key_catalog` — the single
  benchmark field grouped under `benchmark` for OpenBao seeding.

The router carries per-request attribution through its existing request
metadata fields. The catalog contains only the OpenBao field name.

## Usage

Include this role before a consumer that reads its facts, or declare it as a
role dependency:

```yaml
roles:
  - role: dryvist.homelab.llm_router_key_catalog
  - role: openbao
```

The OpenBao generator stores the fields under `secret/apps/benchmark`; router
consumers read those fields through `bao_apps_secrets`.
