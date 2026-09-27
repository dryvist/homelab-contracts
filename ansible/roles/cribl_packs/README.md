# cribl_packs

Install Cribl `.crbl` packs onto Cribl Edge and Cribl Stream LXC containers
from a published RustFS (S3-compatible) manifest.

## What it does

For each host the role detects whether it belongs to `cribl_edge` or
`cribl_stream_group` (set up by inventory loading), fetches
`cribl_packs_manifest_url` (a `manifest.json` published by the consuming
repo's `sync-cribl-packs.yml` playbook — see below), and installs the
corresponding pack list — by name only — under the right Cribl mode
directory:

- Edge LXCs (`cribl_edge` group) → `/opt/cribl/local/edge/packs/<pack-name>/`
- Stream LXCs (`cribl_stream_group`) → `/opt/cribl/local/cribl/packs/<pack-name>/`

Hosts in neither group are skipped (no-op).

## Where the packs come from

Every pack a group selects must be published in the manifest, keyed by pack
name, each entry carrying `{version, key, sha256}`. A downstream repo mirrors
`dryvist/cc-*` GitHub release assets into RustFS and publishes this manifest
(see `playbooks/sync-cribl-packs.yml` in `ansible-proxmox-apps`). This role
never talks to GitHub and never hardcodes a version or a repo owner — the
manifest is the only source of truth for what "latest" is.

## Idempotency

Each pack installation drops a sentinel file `.<version>.installed` inside the
pack directory. Re-runs where the sentinel already matches the manifest
version skip the download. A manifest version bump removes the prior pack
directory, redownloads (verifying the downloaded asset's sha256 against the
manifest before extracting), unarchives — then notifies the appropriate
`Restart cribl` handler.

## Installation

This role ships in `homelab-contracts` (`ansible/roles/cribl_packs`) as part
of the `dryvist.homelab` collection, referenced by FQCN
(`dryvist.homelab.cribl_packs`) from a consumer's `requirements.yml` — there
is no Galaxy install step.

It depends on `cribl_edge` or `cribl_stream` having already installed the
Cribl binary and started the service, so run it after both in `site.yml`.

## Usage

```yaml
- name: Install Cribl packs
  hosts: cribl_edge:cribl_stream_group
  become: true
  roles:
    - dryvist.homelab.cribl_packs
```

Set the object-storage endpoint and the per-group pack selection in
inventory/group_vars — see `defaults/main.yml` for the exact variable names.
Neither has a default value: the endpoint is per-estate infrastructure and
the pack list is deliberately empty until a consumer opts in.

## Variables

See `defaults/main.yml` for the full list. `cribl_packs_manifest_override`
(undocumented there on purpose) lets a test inject a manifest dict directly
and skip the HTTP fetch — see `tests/cribl_packs/`.

## License

MIT (matches the parent repo).
