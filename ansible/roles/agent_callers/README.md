# agent_callers

This role loads the canonical harness gateway identity and memory trust-tier
registry from `files/callers.json`. Consumers read this file rather than keep a
second caller list.

Deployment-specific trust changes are JSON deltas. A consumer merges
`deployment.caller_overrides[id].trust_tier` over this file for that caller id.
An id may be owned by either this registry or the Tofu container roster, never
both; consumers assert that the two sources have no collision.

The default tier is `untrusted`, the safe tier for a caller without a more
specific trust assignment.
