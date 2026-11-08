# lxc_mount_masks

Masks container-incompatible mount units in an unprivileged, non-nested LXC
guest, then clears their failed state. The guard requires all of the
following; on anything else the role does nothing:

- virtualization type `lxc` — the `ansible_virtualization_type` fact, or
  `systemd-detect-virt --container` when the fact is missing,
- an unprivileged uid map — `/proc/self/uid_map` maps container root to a
  non-zero host uid,
- no nesting feature visible from inside — the LXC nesting bind mounts at
  `/dev/.lxc` are absent.

Virtual machines, bare metal, privileged containers, and nested containers
are left untouched. Run the role in the guest play with privilege escalation
enabled:

```yaml
roles:
  - role: dryvist.homelab.lxc_mount_masks
    become: true
```

## Variables

| Variable | Default | Purpose |
| --- | --- | --- |
| `lxc_mount_masks_enabled` | `true` | Set to `false` to skip the role entirely, detection included. |
| `lxc_mount_masks_units` | `["tmp.mount"]` | Mount units to mask and reset. Add further container-incompatible units, such as `dev-mqueue.mount`. |
| `lxc_mount_masks_uid_map_path` | `/proc/self/uid_map` | Probe path for the uid map; overridable so tests can pose privileged and unprivileged guests. |
| `lxc_mount_masks_nesting_path` | `/dev/.lxc` | Probe path for the nesting bind mounts; overridable so tests can pose a nested guest. |

The role exports `lxc_mount_masks_target_guest`, true when the guard matched,
so consumer plays can branch on the same decision the role made.

The contract test lives in `tests/lxc_mount_masks/`; it proves masking and
failed-state reset on an unprivileged, non-nested guest and a skip on every
other shape.
