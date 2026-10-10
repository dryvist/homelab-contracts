#!/usr/bin/env bash
# Lints the shared roles and the converge_gate playbook.
set -euo pipefail

exec ansible-lint \
  ansible/roles/inventory_resolve \
  ansible/roles/docker_engine \
  ansible/roles/ntp \
  ansible/roles/ssh_ca_trust \
  ansible/roles/syslog_forwarder \
  ansible/roles/systemd_restart_policy \
  ansible/roles/openbao_secrets \
  ansible/roles/converge_gate \
  ansible/roles/llm_model_catalog \
  ansible/roles/llm_router_key_catalog \
  ansible/roles/llm_roles \
  ansible/playbooks/converge_gate.yml
