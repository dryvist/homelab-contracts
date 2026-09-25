# cribl_edge

Deploy Cribl Edge log ingestion and processing node.

## Purpose

Installs and configures Cribl Edge to receive syslog data on ports 1514-1518,
process it, and forward to Splunk via HEC. Persists data to 100GB mounted
queue disk at `/opt/cribl/data`.

## Requirements

- Debian-based OS
- 100GB persistent disk mounted at `/opt/cribl/data`
- Network access to Splunk HEC endpoint
- Doppler secrets for HEC token

## Role Variables

All variables in `defaults/main.yml` are user-configurable.

### Key Variables

| Variable | Default | Purpose |
| --- | --- | --- |
| `cribl_edge_service_state` | started | Service state |
| `cribl_edge_service_enabled` | true | Enable on boot |
| `cribl_edge_listen_ports` | 1514-1518 | Syslog listener ports |
| `cribl_edge_hec_token` | (from Doppler) | Splunk HEC auth |
| `cribl_edge_gpu_mode` | disabled | System Metrics GPU group mode (disabled/basic/all/custom); set to `custom` per-host to enable |
| `cribl_edge_gpu_per_gpu` | true | Per-GPU metric events (custom mode) |
| `cribl_edge_gpu_detail` | false | Full/detailed GPU metric set (custom mode) |
| `cribl_edge_stream_s2s_metrics_host` | `syslog.<PROXMOX_SUBDOMAIN>` | Cribl Stream S2S metrics receiver FQDN |

## Examples

### Basic Deployment

```yaml
- name: Deploy Cribl Edge
  hosts: cribl_edge
  roles:
    - cribl_edge
```

### Custom HEC Endpoint

```yaml
- name: Deploy with custom endpoint
  hosts: cribl_edge
  vars:
    cribl_edge_hec_url: https://splunk.internal:8088
    cribl_edge_hec_token: "{{ vault_hec_token }}"
  roles:
    - cribl_edge
```

## Post-Installation Configuration

After Ansible deployment, configure listeners and outputs via Cribl Web UI:

1. Access `http://cribl-edge-1:9000` and `http://cribl-edge-2:9000`
2. Configure syslog listeners on ports 1514-1518
3. Configure Splunk HEC output (endpoint and token already set by Ansible)
4. Test log flow

## Tasks

- Install Cribl Edge package
- Ensure service is running
- Configure persistent queue location
- Set HEC output credentials
- Configure network listeners (via templates)

## Handlers

- `restart cribl edge`: Restart the Cribl Edge service
