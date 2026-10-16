# llm_router_key_catalog

Single-source catalog for the OpenBao field used by the shared LiteLLM
`inference-direct-only` virtual key.

## What it loads

The role reads `files/router-key-catalog.json` and publishes:

- `llm_router_key_catalog_facts.llm_router_key_catalog_source` — the source
  field name for direct inference.
- `llm_router_key_catalog_facts.openbao_router_key_catalog` — the single
  direct-inference field grouped under `inference-direct-only` for OpenBao
  seeding.

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

The OpenBao generator stores the field in its application entry; router
consumers read it through `bao_apps_secrets`.
