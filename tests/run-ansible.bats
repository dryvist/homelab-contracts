#!/usr/bin/env bats
# Tests for scripts/run-ansible. No live OpenBao, SSH agent, Nix or Ansible: curl, ssh-keygen, ssh-agent, ssh-add,
# nix, sleep and ansible-playbook are stubbed on PATH. The curl stub logs each request (method and URL only) and
# answers the OpenBao endpoints from fixtures. The ansible-playbook stub logs its arguments and the environment it
# receives. Real git runs for the checkout guard and the pinned checkout.

setup() {
  RUN_ANSIBLE="$BATS_TEST_DIRNAME/../scripts/run-ansible"
  unset BAO_ADDR SECRET_STORE_ADDR BAO_TOKEN SSH_CA_MOUNT SSH_CERT_TTL SSH_SIGNER_ROLE SSH_SIGNER_ROLE_ID
  unset SSH_SIGNER_SECRET_ID SSH_KNOWN_HOSTS PROXMOX_SSH_KEY_PATH PROXMOX_SSH_PRIVATE_KEY NIX_SHELL
  unset ALLOW_STALE_CHECKOUT ANSIBLE_SSH_COMMON_ARGS
  unset OPENBAO_APPROLE_SEMAPHORE_ROLE_ID OPENBAO_APPROLE_SEMAPHORE_SECRET_ID
  unset OPENBAO_APPROLE_ANSIBLE_ROLE_ID OPENBAO_APPROLE_ANSIBLE_SECRET_ID
  unset RUN_ANSIBLE_IDENTITIES RUN_ANSIBLE_STATIC_KEY_FALLBACK RUN_ANSIBLE_SSH_AGENT RUN_ANSIBLE_MERGE_KNOWN_HOSTS
  unset RUN_ANSIBLE_REVOKE_ATTEMPTS RUN_ANSIBLE_CHECKOUT_GUARD RUN_ANSIBLE_PIN_FILE RUN_ANSIBLE_PIN_DIR
  unset RUN_ANSIBLE_PIN_URL RUN_ANSIBLE_PIN_OPTIONAL RUN_ANSIBLE_LIMIT_LOCALHOST RUN_ANSIBLE_RECAP_CHECK
  unset RUN_ANSIBLE_LOG_DIR FIXTURE_REFUSED_ROLE FIXTURE_SIGN_FAIL FIXTURE_SIGN_FAIL_ROLE FIXTURE_REVOKE_FAILS FIXTURE_RECAP
  unset RUN_ANSIBLE_FALLBACK_ON_ERROR RUN_ANSIBLE_REQUIRE_RECAP RUN_ANSIBLE_RETIRING_IDENTITIES RUN_ANSIBLE_WARN_NO_ISSUER
  unset OPENBAO_APPROLE_APPROLE_ISSUER_ROLE_ID OPENBAO_APPROLE_APPROLE_ISSUER_SECRET_ID OPENBAO_PROVISIONING_TOKEN
  unset FIXTURE_ANSIBLE_EXIT

  export HOME="$BATS_TEST_TMPDIR/home"
  mkdir -p "$HOME"
  export TMPDIR="$BATS_TEST_TMPDIR/tmp"
  mkdir -p "$TMPDIR"
  export FIXTURE_LOG="$BATS_TEST_TMPDIR/requests.log"
  export FIXTURE_RUN_LOG="$BATS_TEST_TMPDIR/run.log"
  export FIXTURE_REVOKE_LEFT="$BATS_TEST_TMPDIR/revoke-left"
  : > "$FIXTURE_LOG"

  STUB="$BATS_TEST_TMPDIR/stub"
  mkdir -p "$STUB"
  cat > "$STUB/curl" <<'SH'
#!/usr/bin/env bash
# Answers OpenBao endpoints from fixtures. Header values (tokens) are never logged.
set -euo pipefail
method=GET
url=""
data=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    -X) method="$2"; shift 2 ;;
    -H|--max-time|--output) shift 2 ;;
    --data) method=POST; data=$(cat); shift 2 ;;
    -*) shift ;;
    *) url="$1"; shift ;;
  esac
done
path="/${url#*://*/}"
printf '%s %s\n' "$method" "$url" >> "$FIXTURE_LOG"
case "$method $path" in
  "POST /v1/auth/approle/login")
    role=$(jq -r '.role_id' <<<"$data")
    if [ "$role" = "${FIXTURE_REFUSED_ROLE:-}" ]; then
      exit 22
    fi
    printf '{"auth":{"client_token":"token-%s"}}\n' "$role"
    ;;
  "POST /v1/"*"/sign/"*)
    printf 'SIGN %s ttl=%s\n' "$path" "$(jq -r '.ttl' <<<"$data")" >> "$FIXTURE_LOG"
    if [ -n "${FIXTURE_SIGN_FAIL:-}" ] || [ "${path##*/}" = "${FIXTURE_SIGN_FAIL_ROLE:-}" ]; then
      exit 22
    fi
    printf '{"data":{"signed_key":"cert-for-%s"}}\n' "${path##*/}"
    ;;
  "POST /v1/auth/token/revoke-self")
    left=${FIXTURE_REVOKE_FAILS:-0}
    if [ -f "$FIXTURE_REVOKE_LEFT" ]; then
      left=$(cat "$FIXTURE_REVOKE_LEFT")
    fi
    if [ "$left" -gt 0 ]; then
      echo $((left - 1)) > "$FIXTURE_REVOKE_LEFT"
      exit 22
    fi
    echo 0 > "$FIXTURE_REVOKE_LEFT"
    printf '{}\n'
    ;;
  *) exit 22 ;;
esac
SH
  cat > "$STUB/ssh-keygen" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
out=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    -f) out="$2"; shift 2 ;;
    *) shift ;;
  esac
done
printf 'PRIVATE-KEY-FIXTURE\n' > "$out"
printf 'ssh-ed25519 AAAAFIXTURE run-ansible\n' > "$out.pub"
SH
  cat > "$STUB/ssh-agent" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
if [ "${1:-}" = "-k" ]; then
  printf 'ssh-agent -k\n' >> "$FIXTURE_LOG"
  exit 0
fi
printf 'SSH_AUTH_SOCK=/tmp/run-ansible-agent-fixture; export SSH_AUTH_SOCK;\n'
printf 'ssh-agent -s\n' >> "$FIXTURE_LOG"
SH
  cat > "$STUB/ssh-add" <<'SH'
#!/usr/bin/env bash
cat > /dev/null
printf 'ssh-add\n' >> "$FIXTURE_LOG"
SH
  cat > "$STUB/nix" <<'SH'
#!/usr/bin/env bash
printf 'nix' >> "$FIXTURE_LOG"
printf ' [%s]' "$@" >> "$FIXTURE_LOG"
printf '\n' >> "$FIXTURE_LOG"
SH
  cat > "$STUB/ansible-playbook" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
{
  printf 'ansible-playbook'
  printf ' [%s]' "$@"
  printf '\n'
  printf 'key=%s\n' "${PROXMOX_SSH_KEY_PATH:-}"
  printf 'common=%s\n' "${ANSIBLE_SSH_COMMON_ARGS:-}"
  printf 'bao_token=%s\n' "${BAO_TOKEN:+set}"
  printf 'host_key_checking=%s\n' "${ANSIBLE_HOST_KEY_CHECKING:-}"
  printf 'known_hosts_file=%s\n' "${SSH_KNOWN_HOSTS_FILE:-}"
} >> "$FIXTURE_RUN_LOG"
printf 'PLAYBOOK-OUTPUT\n'
printf '%b' "${FIXTURE_RECAP:-}"
exit "${FIXTURE_ANSIBLE_EXIT:-0}"
SH
  cat > "$STUB/sleep" <<'SH'
#!/usr/bin/env bash
exit 0
SH
  chmod +x "$STUB"/*
  export PATH="$STUB:$PATH"

  REPO="$BATS_TEST_TMPDIR/repo"
  git init -q -b main "$REPO"
  printf 'tracked\n' > "$REPO/tracked.txt"
  git -C "$REPO" add tracked.txt
  git -C "$REPO" -c user.name=test -c user.email=test@example.test commit -q -m init
  cd "$REPO"
}

static_key() {
  printf 'static-key\n' > "$BATS_TEST_TMPDIR/static_key"
  export PROXMOX_SSH_KEY_PATH="$BATS_TEST_TMPDIR/static_key"
}

signer_env() {
  export BAO_ADDR=http://bao.fixture SSH_SIGNER_ROLE_ID=signer-role SSH_SIGNER_SECRET_ID=signer-secret
  export SSH_CA_MOUNT=ssh-client-ca SSH_SIGNER_ROLE=automation-signer
}

semaphore_env() {
  export BAO_ADDR=http://bao.fixture
  export OPENBAO_APPROLE_SEMAPHORE_ROLE_ID=semaphore-role OPENBAO_APPROLE_SEMAPHORE_SECRET_ID=semaphore-secret
}

ansible_env() {
  export BAO_ADDR=http://bao.fixture
  export OPENBAO_APPROLE_ANSIBLE_ROLE_ID=ansible-role OPENBAO_APPROLE_ANSIBLE_SECRET_ID=ansible-secret
}

with_origin() {
  git init -q --bare "$BATS_TEST_TMPDIR/origin.git"
  git -C "$REPO" remote add origin "$BATS_TEST_TMPDIR/origin.git"
  git -C "$REPO" push -q origin main
}

@test "no arguments prints usage and exits 64" {
  run "$RUN_ANSIBLE"
  [ "$status" -eq 64 ]
  [[ $output == *"Usage:"* ]]
}

@test "no identity and no static key refuses before running ansible" {
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 1 ]
  [[ $output == *"no SSH auth available"* ]]
  [ ! -s "$FIXTURE_RUN_LOG" ]
}

@test "a static key file runs the playbook with that key and does not contact OpenBao" {
  static_key
  run "$RUN_ANSIBLE" site.yml --limit vms
  [ "$status" -eq 0 ]
  grep -Fqx "key=$BATS_TEST_TMPDIR/static_key" "$FIXTURE_RUN_LOG"
  [ ! -s "$FIXTURE_LOG" ]
}

@test "the signer identity mints a certificate, runs with it, and removes it on exit" {
  signer_env
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  [[ $output == *"authenticated as: signer"* ]]
  grep -Fq 'POST http://bao.fixture/v1/auth/approle/login' "$FIXTURE_LOG"
  grep -Fqx 'SIGN /v1/ssh-client-ca/sign/automation-signer ttl=1h' "$FIXTURE_LOG"
  grep -Fq 'POST http://bao.fixture/v1/auth/token/revoke-self' "$FIXTURE_LOG"
  key=$(sed -n 's/^key=//p' "$FIXTURE_RUN_LOG")
  [ -n "$key" ]
  [ ! -e "$key" ]
}

@test "the signer identity without SSH_CA_MOUNT is refused" {
  signer_env
  unset SSH_CA_MOUNT
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 1 ]
  [[ $output == *"SSH_CA_MOUNT"* ]]
}

@test "the semaphore identity signs with automation-semaphore" {
  semaphore_env
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  grep -Fqx 'SIGN /v1/ssh-client-ca/sign/automation-semaphore ttl=1h' "$FIXTURE_LOG"
}

@test "a refused login stops the run unless the identity is marked to fall through" {
  semaphore_env
  ansible_env
  export FIXTURE_REFUSED_ROLE=semaphore-role
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 1 ]
  [[ $output == *"AppRole login refused for identity: semaphore"* ]]
  [ ! -s "$FIXTURE_RUN_LOG" ]
  ! grep -Fq 'automation-ansible' "$FIXTURE_LOG"
}

@test "a refused login falls through to the next identity when its name is marked with a question mark" {
  semaphore_env
  ansible_env
  export FIXTURE_REFUSED_ROLE=semaphore-role RUN_ANSIBLE_IDENTITIES='signer,semaphore?,ansible'
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  [[ $output == *"WARNING: AppRole login refused for identity: semaphore"* ]]
  [[ $output == *"authenticated as: ansible"* ]]
  grep -Fqx 'SIGN /v1/ssh-client-ca/sign/automation-ansible ttl=1h' "$FIXTURE_LOG"
}

@test "a certificate signing failure stops the run before ansible-playbook" {
  semaphore_env
  export FIXTURE_SIGN_FAIL=1
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 1 ]
  [[ $output == *"could not be minted"* ]]
  [ ! -s "$FIXTURE_RUN_LOG" ]
}

@test "RUN_ANSIBLE_STATIC_KEY_FALLBACK runs with the static key after a failed mint" {
  semaphore_env
  static_key
  export FIXTURE_SIGN_FAIL=1 RUN_ANSIBLE_STATIC_KEY_FALLBACK=1
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  [[ $output == *"using PROXMOX_SSH_KEY_PATH"* ]]
  grep -Fqx "key=$BATS_TEST_TMPDIR/static_key" "$FIXTURE_RUN_LOG"
}

@test "SECRET_STORE_ADDR takes precedence over BAO_ADDR" {
  semaphore_env
  export BAO_ADDR=http://old.fixture SECRET_STORE_ADDR=http://bao.fixture
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  ! grep -Fq 'old.fixture' "$FIXTURE_LOG"
  grep -Fq 'http://bao.fixture/v1/auth/approle/login' "$FIXTURE_LOG"
}

@test "a caller BAO_TOKEN is kept and only the runner token is revoked" {
  signer_env
  export BAO_TOKEN=caller-token
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  [ "$(grep -c 'revoke-self' "$FIXTURE_LOG")" -eq 1 ]
  grep -Fqx 'bao_token=set' "$FIXTURE_RUN_LOG"
}

@test "SSH_KNOWN_HOSTS pins host keys with strict checking and never reads the user's known_hosts" {
  static_key
  export SSH_KNOWN_HOSTS='pin.example ssh-ed25519 AAAAPIN'
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  grep -Fq 'StrictHostKeyChecking=yes' "$FIXTURE_RUN_LOG"
  grep -Fq 'GlobalKnownHostsFile=/dev/null' "$FIXTURE_RUN_LOG"
  [ ! -e "$HOME/.ssh/known_hosts" ]
}

@test "SSH_KNOWN_HOSTS forces Ansible host key checking on" {
  static_key
  export SSH_KNOWN_HOSTS='pin.example ssh-ed25519 AAAAPIN' ANSIBLE_HOST_KEY_CHECKING=False
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  grep -Fxq 'host_key_checking=True' "$FIXTURE_RUN_LOG"
}

@test "an invalid RUN_ANSIBLE_REVOKE_ATTEMPTS fails before the playbook runs" {
  static_key
  export RUN_ANSIBLE_REVOKE_ATTEMPTS=abc
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 1 ]
  [[ $output == *"must be a positive integer"* ]]
  [ ! -s "$FIXTURE_RUN_LOG" ]
}

@test "RUN_ANSIBLE_MERGE_KNOWN_HOSTS replaces a stale pinned line and keeps other lines once" {
  static_key
  mkdir -p "$HOME/.ssh"
  printf 'pin.example ssh-ed25519 STALE\nother.example ssh-ed25519 KEEP\nother.example ssh-ed25519 KEEP\n' \
    > "$HOME/.ssh/known_hosts"
  export SSH_KNOWN_HOSTS='pin.example ssh-ed25519 FRESH' RUN_ANSIBLE_MERGE_KNOWN_HOSTS=1
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  [ "$(grep -c 'pin.example' "$HOME/.ssh/known_hosts")" -eq 1 ]
  grep -Fqx 'pin.example ssh-ed25519 FRESH' "$HOME/.ssh/known_hosts"
  [ "$(grep -c 'other.example' "$HOME/.ssh/known_hosts")" -eq 1 ]
}

@test "PROXMOX_SSH_PRIVATE_KEY is ignored unless RUN_ANSIBLE_SSH_AGENT is set" {
  export PROXMOX_SSH_PRIVATE_KEY=fixture-private-key
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 1 ]
  [[ $output == *"no SSH auth available"* ]]
  [ ! -s "$FIXTURE_LOG" ]
}

@test "RUN_ANSIBLE_SSH_AGENT loads the key into a private agent and stops the agent on exit" {
  export PROXMOX_SSH_PRIVATE_KEY=fixture-private-key RUN_ANSIBLE_SSH_AGENT=1
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  grep -Fqx 'ssh-add' "$FIXTURE_LOG"
  grep -Fqx 'ssh-agent -k' "$FIXTURE_LOG"
  grep -Fqx 'key=' "$FIXTURE_RUN_LOG"
}

@test "RUN_ANSIBLE_REVOKE_ATTEMPTS retries a failed revoke until one succeeds" {
  signer_env
  export FIXTURE_REVOKE_FAILS=2 RUN_ANSIBLE_REVOKE_ATTEMPTS=3
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  [ "$(grep -c 'revoke-self' "$FIXTURE_LOG")" -eq 3 ]
}

@test "a failed revoke with the default single attempt only warns and keeps the exit status" {
  signer_env
  export FIXTURE_REVOKE_FAILS=1
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  [[ $output == *"could not revoke the runner-owned OpenBao token"* ]]
  [ "$(grep -c 'revoke-self' "$FIXTURE_LOG")" -eq 1 ]
}

@test "the checkout guard is off by default, so a dirty checkout still runs" {
  static_key
  printf 'edit\n' >> tracked.txt
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
}

@test "the checkout guard refuses tracked edits unless ALLOW_STALE_CHECKOUT is set" {
  static_key
  with_origin
  printf 'edit\n' >> tracked.txt
  export RUN_ANSIBLE_CHECKOUT_GUARD=1
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 1 ]
  [[ $output == *"uncommitted changes to tracked files"* ]]
  [ ! -s "$FIXTURE_RUN_LOG" ]
  export ALLOW_STALE_CHECKOUT=1
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
}

@test "the checkout guard refuses a checkout that is behind origin" {
  static_key
  with_origin
  printf 'second\n' >> tracked.txt
  git -C "$REPO" -c user.name=test -c user.email=test@example.test commit -q -a -m second
  git -C "$REPO" push -q origin main
  git -C "$REPO" reset -q --hard HEAD~1
  export RUN_ANSIBLE_CHECKOUT_GUARD=1
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 1 ]
  [[ $output == *"1 behind, 0 ahead"* ]]
}

@test "RUN_ANSIBLE_PIN_FILE checks out the pinned commit into the pin directory" {
  static_key
  pinsource="$BATS_TEST_TMPDIR/pin-source"
  git init -q -b main "$pinsource"
  printf 'pinned\n' > "$pinsource/content.txt"
  git -C "$pinsource" add content.txt
  git -C "$pinsource" -c user.name=test -c user.email=test@example.test commit -q -m pinned
  sha=$(git -C "$pinsource" rev-parse HEAD)
  printf '%s\n' "$sha" > "$REPO/pinned-file"
  export RUN_ANSIBLE_PIN_FILE=pinned-file RUN_ANSIBLE_PIN_DIR=pinned-checkout RUN_ANSIBLE_PIN_URL="$pinsource"
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  [ "$(git -C "$REPO/pinned-checkout" rev-parse HEAD)" = "$sha" ]
  [ -f "$REPO/pinned-checkout/content.txt" ]
}

@test "a malformed pin file fails the run, and RUN_ANSIBLE_PIN_OPTIONAL only warns" {
  static_key
  printf 'not-a-commit\n' > "$REPO/bad-pin"
  export RUN_ANSIBLE_PIN_FILE=bad-pin RUN_ANSIBLE_PIN_DIR=bad-checkout RUN_ANSIBLE_PIN_URL="$BATS_TEST_TMPDIR/none"
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 1 ]
  [[ $output == *"40-character lowercase hexadecimal"* ]]
  export RUN_ANSIBLE_PIN_OPTIONAL=1
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  [[ $output == *"continuing without it"* ]]
}

@test "RUN_ANSIBLE_LIMIT_LOCALHOST appends localhost to the final --limit" {
  static_key
  export RUN_ANSIBLE_LIMIT_LOCALHOST=1
  run "$RUN_ANSIBLE" site.yml --limit vms
  [ "$status" -eq 0 ]
  grep -Fqx 'ansible-playbook [site.yml] [--limit] [vms] [--limit] [vms,localhost]' "$FIXTURE_RUN_LOG"
}

@test "without RUN_ANSIBLE_LIMIT_LOCALHOST the arguments pass through unchanged" {
  static_key
  run "$RUN_ANSIBLE" site.yml --limit vms
  [ "$status" -eq 0 ]
  grep -Fqx 'ansible-playbook [site.yml] [--limit] [vms]' "$FIXTURE_RUN_LOG"
}

@test "the recap check fails when a non-localhost limit matched no host" {
  static_key
  export RUN_ANSIBLE_RECAP_CHECK=1
  export FIXTURE_RECAP='PLAY RECAP *********\nlocalhost : ok=2 changed=0 unreachable=0 failed=0\n'
  run "$RUN_ANSIBLE" site.yml --limit vms
  [ "$status" -eq 1 ]
  [[ $output == *"asked for hosts beyond localhost"* ]]
}

@test "the recap check passes when the limited host appears in the recap" {
  static_key
  export RUN_ANSIBLE_RECAP_CHECK=1
  export FIXTURE_RECAP='PLAY RECAP *********\nvms : ok=3 changed=0 unreachable=0 failed=0\n'
  run "$RUN_ANSIBLE" site.yml --limit vms
  [ "$status" -eq 0 ]
}

@test "the recap check fails when a host reports failed or unreachable" {
  static_key
  export RUN_ANSIBLE_RECAP_CHECK=1
  export FIXTURE_RECAP='PLAY RECAP *********\nvms : ok=1 changed=0 unreachable=0 failed=1\n'
  run "$RUN_ANSIBLE" site.yml --limit vms
  [ "$status" -eq 1 ]
  [[ $output == *"failed or unreachable hosts"* ]]
}

@test "the recap check fails a limited run that printed no play recap" {
  static_key
  export RUN_ANSIBLE_RECAP_CHECK=1
  run "$RUN_ANSIBLE" site.yml --limit vms
  [ "$status" -eq 1 ]
  [[ $output == *"before Ansible printed a play recap"* ]]
}

@test "RUN_ANSIBLE_LOG_DIR keeps the run output in a log file" {
  static_key
  export RUN_ANSIBLE_LOG_DIR="$BATS_TEST_TMPDIR/logs"
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  log=$(ls "$RUN_ANSIBLE_LOG_DIR"/*-site.log)
  grep -Fq 'PLAYBOOK-OUTPUT' "$log"
  [[ $output == *"Run log: $RUN_ANSIBLE_LOG_DIR"* ]]
}

@test "NIX_SHELL runs ansible-playbook through nix develop" {
  static_key
  export NIX_SHELL="$BATS_TEST_TMPDIR/flake"
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  grep -Fqx "nix [develop] [$NIX_SHELL] [--command] [ansible-playbook] [site.yml]" "$FIXTURE_LOG"
}

@test "the playbook exit status is returned" {
  static_key
  export FIXTURE_ANSIBLE_EXIT=4
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 4 ]
}

@test "RUN_ANSIBLE_IDENTITIES rejects a name that is not a lowercase identifier" {
  static_key
  export RUN_ANSIBLE_IDENTITIES='signer,Bad_Name'
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 1 ]
  [[ $output == *"must be a lowercase name"* ]]
}

@test "RUN_ANSIBLE_FALLBACK_ON_ERROR lets a marked identity fall through on a signing failure" {
  semaphore_env
  ansible_env
  export FIXTURE_SIGN_FAIL_ROLE=automation-semaphore RUN_ANSIBLE_IDENTITIES='signer,semaphore?,ansible'
  export RUN_ANSIBLE_FALLBACK_ON_ERROR=1
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  [[ $output == *"certificate mint failed for identity: semaphore"* ]]
  grep -Fqx 'SIGN /v1/ssh-client-ca/sign/automation-ansible ttl=1h' "$FIXTURE_LOG"
}

@test "without RUN_ANSIBLE_FALLBACK_ON_ERROR a signing failure stops even a marked identity" {
  semaphore_env
  ansible_env
  export FIXTURE_SIGN_FAIL_ROLE=automation-semaphore RUN_ANSIBLE_IDENTITIES='signer,semaphore?,ansible'
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 1 ]
  [ ! -s "$FIXTURE_RUN_LOG" ]
}

@test "RUN_ANSIBLE_RETIRING_IDENTITIES warns when a retiring identity mints the certificate" {
  ansible_env
  export RUN_ANSIBLE_RETIRING_IDENTITIES=ansible
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  [[ $output == *"converging as the ansible AppRole, which is being retired"* ]]
}

@test "RUN_ANSIBLE_WARN_NO_ISSUER warns when the issuer pair is missing" {
  semaphore_env
  export RUN_ANSIBLE_WARN_NO_ISSUER=1
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  [[ $output == *"no AppRole issuer credentials in this environment"* ]]
}

@test "RUN_ANSIBLE_REQUIRE_RECAP fails an unlimited run that printed no play recap" {
  static_key
  export RUN_ANSIBLE_RECAP_CHECK=1 RUN_ANSIBLE_REQUIRE_RECAP=1
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 1 ]
  [[ $output == *"ended before Ansible printed a play recap"* ]]
}

@test "SSH_KNOWN_HOSTS exports the per-run pin file path" {
  static_key
  export SSH_KNOWN_HOSTS='pin.example ssh-ed25519 AAAAPIN'
  run "$RUN_ANSIBLE" site.yml
  [ "$status" -eq 0 ]
  grep -Eq '^known_hosts_file=.+/known_hosts$' "$FIXTURE_RUN_LOG"
}
