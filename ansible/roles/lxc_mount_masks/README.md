# lxc_mount_masks

Masks configured mount units that have failed in an LXC guest, then clears their
failed state. Other container types, virtual machines, and bare metal are left
unchanged. Run the role in the guest play with privilege escalation enabled.

```yaml
roles:
  - role: dryvist.homelab.lxc_mount_masks
    become: true
```

`lxc_mount_masks_enabled` defaults to `true`. `lxc_mount_masks_units` defaults to
`tmp.mount`, `dev-mqueue.mount`, and `run-lock.mount`. Only units already in the
failed state are masked; a unit that has not yet failed is left alone.
