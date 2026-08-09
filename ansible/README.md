# `dryvist.homelab` Ansible collection

Shared Ansible roles consumed by more than one homelab repo. A role lands here
only when a second repo genuinely needs it — this is not a dumping ground for
every role in the estate.

This directory is the collection root: `galaxy.yml` sits beside `roles/`.

## Roles

| Role | Purpose | Consumers |
| --- | --- | --- |
| `cribl_edge` | Install and configure Cribl Edge (native, non-Docker) | `ansible-proxmox` (hosts), `ansible-proxmox-apps` (LXC) |
| `cribl_packs` | Install versioned `.crbl` pack assets onto Edge/Stream | `ansible-proxmox`, `ansible-proxmox-apps` |
| `inventory_resolve` | Resolve the published OpenTofu inventory (RustFS/S3) | `ansible-proxmox`, `ansible-proxmox-apps` |
| `docker_engine` | Bootstrap Docker CE + compose plugin in an LXC | `ansible-proxmox-apps`, `ansible-servarr` |
| `ntp` | Time synchronization via chrony | `ansible-proxmox-apps`, `ansible-servarr` |
| `ssh_ca_trust` | Guest-side pinned-fingerprint SSH CA trust | `ansible-proxmox-apps`, `ansible-servarr` |
| `syslog_forwarder` | Forward host + service logs to the central syslog pipeline | `ansible-proxmox-apps`, `ansible-servarr` |
| `systemd_restart_policy` | systemd unit override enforcing a restart policy | `ansible-proxmox-apps`, `ansible-servarr` |
| `service_deadman` | Timer-driven deadman watchdog alerting on keystone service failure | `ansible-proxmox-apps`, `ansible-servarr` |
| `openbao_secrets` | Controller-side pre-play fetching per-domain OpenBao KV secrets | `ansible-proxmox-apps`, `ansible-servarr` |

## Installation

`ansible-galaxy role install` cannot address a role that lives in a repo
subdirectory — it installs the repo ROOT as the role. A collection can be
installed from a subdirectory, which is why these roles ship as one.

In a consumer's `requirements.yml`:

```yaml
collections:
  - name: https://github.com/dryvist/homelab-contracts.git#/ansible/
    type: git
    version: <commit SHA>
```

Then:

```sh
ansible-galaxy collection install -r requirements.yml
```

No `ansible-galaxy role install` step is needed for these roles.

## Usage

Reference roles by their fully-qualified collection name:

```yaml
roles:
  - role: dryvist.homelab.cribl_edge
  - role: dryvist.homelab.cribl_packs
```

Role variable names are unaffected by the collection move — `cribl_edge_*`,
`cribl_packs_*`, and `inventory_resolve_*` keep their existing names.

## License

MIT — see [`LICENSE`](../LICENSE) at the repository root.
