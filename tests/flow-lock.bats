#!/usr/bin/env bats
# CLI-contract tests for bin/flow-lock and bin/deployment-json.
# No live OpenBao/S3: these pin argument parsing, lease/CAS behavior, refusal
# paths, exit codes, and bootstrap-mode behavior.

setup() {
  FLOW_LOCK="$BATS_TEST_DIRNAME/../bin/flow-lock"
  DEPLOYMENT_JSON="$BATS_TEST_DIRNAME/../bin/deployment-json"
  export PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
  # ensure no ambient config leaks in
  unset BAO_ADDR BAO_TOKEN FLOW_LOCK_ROLE_ID FLOW_LOCK_SECRET_ID
  unset OPENBAO_APPROLE_APPROLE_ISSUER_ROLE_ID OPENBAO_APPROLE_APPROLE_ISSUER_SECRET_ID
  unset FLOW_LOCK_BOOTSTRAP FLOW_LOCK_LEASE_ID
  unset S3_ENDPOINT S3_ACCESS_KEY S3_SECRET_KEY
}

fake_flow_lock_openbao() {
  STUB="$BATS_TEST_TMPDIR/stub"
  mkdir -p "$STUB"
  cat > "$STUB/curl" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
method=GET
url=""
config=""
request_body=""
request_data=""
read_body=false
while [ "$#" -gt 0 ]; do
  case "$1" in
    -X) method="$2"; shift 2 ;;
    -H) shift 2 ;;
    -w) shift 2 ;;
    --config) config="$2"; shift 2 ;;
    --data-binary) read_body=true; shift 2 ;;
    -d) request_data="$2"; shift 2 ;;
    -s|-S|-sS) shift ;;
    */v1/*) url="$1"; shift ;;
    *) shift ;;
  esac
done
auth_token=-
if [ "$config" = "-" ]; then
  while IFS= read -r config_line; do
    case "$config_line" in
      'header = "X-Vault-Token: '*)
        auth_token="${config_line#*X-Vault-Token: }"
        auth_token="${auth_token%\"}"
        ;;
    esac
  done
elif [ -n "$config" ]; then
  while IFS= read -r config_line; do
    case "$config_line" in
      'header = "X-Vault-Token: '*)
        auth_token="${config_line#*X-Vault-Token: }"
        auth_token="${auth_token%\"}"
        ;;
    esac
  done < "$config"
fi
if [ "$read_body" = true ]; then
  request_body="$(cat)"
fi
path="${url#*/v1/}"
fixture_secret_id_response() {
  if [ -n "${FLOW_LOCK_FIXTURE_NUM_USES:-}" ]; then
    jq -nc --arg s "$1" --arg a "$2" --argjson n "$FLOW_LOCK_FIXTURE_NUM_USES" \
      '{data:{secret_id:$s,secret_id_accessor:$a,secret_id_num_uses:$n}}'
  else
    jq -nc --arg s "$1" --arg a "$2" '{data:{secret_id:$s,secret_id_accessor:$a}}'
  fi
}
fixture_lease_response() {
  jq -nc --arg lease_id "$1" --argjson version "$2" --argjson expires_at "$3" \
    '{data:{metadata:{version:$version},data:{lease_id:$lease_id,holder:{user:"test",host:"fixture",pid:1},flow:"test",repo:"test",expires_at:$expires_at,renewals:0}}}'
}
fixture_store_lease() {
  local version="$1" lease_id
  lease_id="$(jq -er '.data.lease_id' <<<"$request_data")"
  printf '%s\n' "$lease_id" > "$FLOW_LOCK_FIXTURE_LEASE_ID"
  printf '%s\n' "$version" > "$FLOW_LOCK_FIXTURE_VERSION_FILE"
  response="$(jq -nc --argjson version "$version" '{data:{version:$version}}')"
  status=200
}
fixture_cas_conflict() {
  response='{"errors":["check-and-set parameter did not match the current version"]}'
  status=400
}
role=-
response='{"errors":["fixture did not match"]}'
status=500
case "$path" in
  auth/approle/login)
    if [[ "$request_body" == *issuer-secret* ]]; then
      role=issuer
      response='{"auth":{"client_token":"issuer-token"}}'
      status=200
    elif [[ "$request_body" == *flow-lock-secret* ]]; then
      role=flow-lock
      response='{"auth":{"client_token":"flow-lock-token"}}'
      status=200
    elif [[ "$request_body" == *reconcile-secret* ]]; then
      role=openbao-reconcile
      if [ "${FLOW_LOCK_FIXTURE_REJECT_RECONCILE:-}" = 1 ]; then
        response='{"errors":["invalid role or secret ID"]}'
        status=400
      else
        response='{"auth":{"client_token":"reconcile-token"}}'
        status=200
      fi
    fi
    ;;
  auth/approle/role/flow-lock/role-id)
    response='{"data":{"role_id":"flow-lock-role-id"}}'
    status=200
    ;;
  auth/approle/role/flow-lock/secret-id)
    response="$(fixture_secret_id_response flow-lock-secret flow-lock-accessor)"
    status=200
    ;;
  auth/approle/role/openbao-reconcile/role-id)
    response='{"data":{"role_id":"reconcile-role-id"}}'
    status=200
    ;;
  auth/approle/role/openbao-reconcile/secret-id)
    response="$(fixture_secret_id_response reconcile-secret reconcile-accessor)"
    status=200
    ;;
  auth/approle/role/flow-lock/secret-id-accessor/destroy|auth/approle/role/openbao-reconcile/secret-id-accessor/destroy)
    if [ "${FLOW_LOCK_FIXTURE_DESTROY_ALREADY_GONE:-}" = 1 ]; then
      response='{"errors":["1 error occurred:\n\t* failed to find accessor entry for secret_id_accessor: \"fixture-accessor\""]}'
      status=500
    else
      response="${FLOW_LOCK_FIXTURE_DESTROY_RESPONSE:-}"
      status="${FLOW_LOCK_FIXTURE_DESTROY_STATUS:-204}"
    fi
    ;;
  secret/data/locks/global)
    if [ "$method" = POST ]; then
      cas="$(jq -r '.options.cas' <<<"$request_data")"
      mode="${FLOW_LOCK_FIXTURE_MODE:-absent}"
      printf '%s\t%s\t%s\n' "$method" "$path" "$cas" >> "$FLOW_LOCK_FIXTURE_CAS_LOG"
      case "$mode" in
        absent)
          if [ "$cas" = 0 ] && [ ! -f "$FLOW_LOCK_FIXTURE_LEASE_ID" ]; then
            fixture_store_lease 1
          else
            fixture_cas_conflict
          fi
          ;;
        soft-deleted|soft-deleted-stuck|soft-deleted-retry)
          version="${FLOW_LOCK_FIXTURE_SOFT_DELETED_VERSION:-7}"
          if [ "$cas" = "$version" ] && [ "$mode" != soft-deleted-stuck ] && \
            { [ "$mode" != soft-deleted-retry ] || \
              [ "$(grep -Fc $'POST\tsecret/data/locks/global\t7' "$FLOW_LOCK_FIXTURE_CAS_LOG")" -ge 2 ]; }; then
            fixture_store_lease "$((version + 1))"
          else
            fixture_cas_conflict
          fi
          ;;
        expired|expired-stuck)
          version="${FLOW_LOCK_FIXTURE_EXPIRED_VERSION:-4}"
          if [ "$mode" = expired ] && [ "$cas" = "$version" ]; then
            fixture_store_lease "$((version + 1))"
          else
            fixture_cas_conflict
          fi
          ;;
        held|timeout)
          fixture_cas_conflict
          ;;
        *)
          fixture_cas_conflict
          ;;
      esac
    elif [ "$method" = GET ]; then
      mode="${FLOW_LOCK_FIXTURE_MODE:-absent}"
      if [ -f "$FLOW_LOCK_FIXTURE_LEASE_ID" ]; then
        lease_id="$(cat "$FLOW_LOCK_FIXTURE_LEASE_ID")"
        version="$(cat "$FLOW_LOCK_FIXTURE_VERSION_FILE")"
        response="$(fixture_lease_response "$lease_id" "$version" "$(( $(date +%s) + 600 ))")"
        status=200
      else
        case "$mode" in
          soft-deleted|soft-deleted-stuck|soft-deleted-retry)
            version="${FLOW_LOCK_FIXTURE_SOFT_DELETED_VERSION:-7}"
            response="$(jq -nc --argjson version "$version" '{data:{metadata:{version:$version,deletion_time:"2026-10-18T00:00:00Z"}}}')"
            status=404
            ;;
          held|timeout)
            version="${FLOW_LOCK_FIXTURE_HELD_VERSION:-4}"
            response="$(fixture_lease_response held-lease "$version" "$(( $(date +%s) + 600 ))")"
            status=200
            ;;
          expired|expired-stuck)
            version="${FLOW_LOCK_FIXTURE_EXPIRED_VERSION:-4}"
            response="$(fixture_lease_response expired-lease "$version" "$(( $(date +%s) - 1 ))")"
            status=200
            ;;
          *)
            response='{"errors":["not found"]}'
            status=404
            ;;
        esac
      fi
    else
      fixture_cas_conflict
    fi
    ;;
  secret/data/locks/audit/*)
    printf '%s\n' "$request_data" > "$FLOW_LOCK_FIXTURE_AUDIT_BODY"
    response='{"data":{"version":1}}'
    status=200
    ;;
  secret/metadata/locks/global)
    response=''
    status=204
    ;;
esac
printf '%s\t%s\t%s\t%s\n' "$method" "$path" "$auth_token" "$role" >> "$FLOW_LOCK_API_LOG"
printf '%s\n%s\n' "$response" "$status"
SH
  chmod +x "$STUB/curl"
  cat > "$STUB/sleep" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >> "$FLOW_LOCK_SLEEP_LOG"
if [ "${FLOW_LOCK_FIXTURE_FAST_SLEEP:-0}" = 1 ]; then exit 0; fi
exec /bin/sleep "$@"
SH
  chmod +x "$STUB/sleep"
  export FLOW_LOCK_API_LOG="$BATS_TEST_TMPDIR/openbao-calls"
  export FLOW_LOCK_FIXTURE_LEASE_ID="$BATS_TEST_TMPDIR/lease-id"
  export FLOW_LOCK_FIXTURE_VERSION_FILE="$BATS_TEST_TMPDIR/lease-version"
  export FLOW_LOCK_FIXTURE_CAS_LOG="$BATS_TEST_TMPDIR/cas-calls"
  export FLOW_LOCK_FIXTURE_AUDIT_BODY="$BATS_TEST_TMPDIR/audit-body.json"
  export FLOW_LOCK_SLEEP_LOG="$BATS_TEST_TMPDIR/sleep-calls"
  : > "$FLOW_LOCK_API_LOG"
  : > "$FLOW_LOCK_FIXTURE_CAS_LOG"
  : > "$FLOW_LOCK_SLEEP_LOG"
  export PATH="$STUB:$PATH"
}

# ---- flow-lock --------------------------------------------------------------

@test "flow-lock with no args prints usage and exits 64" {
  run "$FLOW_LOCK"
  [ "$status" -eq 64 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "flow-lock help exits 0" {
  run "$FLOW_LOCK" help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Force-break"* ]]
  [[ "$output" == *"flow-lock approle-token ROLE"* ]]
}

@test "flow-lock unknown subcommand exits 64" {
  run "$FLOW_LOCK" frobnicate
  [ "$status" -eq 64 ]
}

@test "flow-lock run without a command exits 64" {
  run "$FLOW_LOCK" run --flow test
  [ "$status" -eq 64 ]
  [[ "$output" == *"no command given"* ]]
}

@test "flow-lock run without BAO_ADDR exits 64" {
  run "$FLOW_LOCK" run -- true
  [ "$status" -eq 64 ]
  [[ "$output" == *"BAO_ADDR"* ]]
}

@test "flow-lock run rejects an invalid --ttl" {
  BAO_ADDR=http://127.0.0.1:1 run "$FLOW_LOCK" run --ttl bogus -- true
  [ "$status" -eq 64 ]
  [[ "$output" == *"invalid duration"* ]]
}

@test "flow-lock status mints a one-use credential through approle-issuer once" {
  fake_flow_lock_openbao
  export BAO_ADDR=https://fixture
  export OPENBAO_APPROLE_APPROLE_ISSUER_ROLE_ID=issuer-role-id
  export OPENBAO_APPROLE_APPROLE_ISSUER_SECRET_ID=issuer-secret

  run "$FLOW_LOCK" status

  [ "$status" -eq 0 ]
  [[ "$output" == *"flow-lock: free (no lease held)"* ]]
  [ "$(wc -l < "$FLOW_LOCK_API_LOG" | tr -d ' ')" -eq 6 ]
  grep -Fx $'POST\tauth/approle/login\t-\tissuer' "$FLOW_LOCK_API_LOG"
  grep -Fx $'GET\tauth/approle/role/flow-lock/role-id\tissuer-token\t-' "$FLOW_LOCK_API_LOG"
  grep -Fx $'POST\tauth/approle/role/flow-lock/secret-id\tissuer-token\t-' "$FLOW_LOCK_API_LOG"
  grep -Fx $'POST\tauth/approle/login\t-\tflow-lock' "$FLOW_LOCK_API_LOG"
  grep -Fx $'POST\tauth/approle/role/flow-lock/secret-id-accessor/destroy\tissuer-token\t-' "$FLOW_LOCK_API_LOG"
  grep -Fx $'GET\tsecret/data/locks/global\tflow-lock-token\t-' "$FLOW_LOCK_API_LOG"
}

@test "approle-token mints a fresh credential for the requested role" {
  fake_flow_lock_openbao
  export BAO_ADDR=https://fixture
  export BAO_TOKEN=unrelated-runner-token
  export OPENBAO_APPROLE_APPROLE_ISSUER_ROLE_ID=issuer-role-id
  export OPENBAO_APPROLE_APPROLE_ISSUER_SECRET_ID=issuer-secret

  run "$FLOW_LOCK" approle-token openbao-reconcile

  [ "$status" -eq 0 ]
  [ "$output" = "reconcile-token" ]
  grep -Fx $'POST\tauth/approle/login\t-\tissuer' "$FLOW_LOCK_API_LOG"
  grep -Fx $'GET\tauth/approle/role/openbao-reconcile/role-id\tissuer-token\t-' "$FLOW_LOCK_API_LOG"
  grep -Fx $'POST\tauth/approle/role/openbao-reconcile/secret-id\tissuer-token\t-' "$FLOW_LOCK_API_LOG"
  grep -Fx $'POST\tauth/approle/login\t-\topenbao-reconcile' "$FLOW_LOCK_API_LOG"
  grep -Fx $'POST\tauth/approle/role/openbao-reconcile/secret-id-accessor/destroy\tissuer-token\t-' "$FLOW_LOCK_API_LOG"
}

@test "approle-token revokes its secret id when the target login fails" {
  fake_flow_lock_openbao
  export BAO_ADDR=https://fixture
  export OPENBAO_APPROLE_APPROLE_ISSUER_ROLE_ID=issuer-role-id
  export OPENBAO_APPROLE_APPROLE_ISSUER_SECRET_ID=issuer-secret
  export FLOW_LOCK_FIXTURE_REJECT_RECONCILE=1

  run "$FLOW_LOCK" approle-token openbao-reconcile

  [ "$status" -eq 70 ]
  [[ "$output" == *"invalid role or secret ID"* ]]
  grep -Fx $'POST\tauth/approle/role/openbao-reconcile/secret-id-accessor/destroy\tissuer-token\t-' "$FLOW_LOCK_API_LOG"
}

approle_env() {
  fake_flow_lock_openbao
  export BAO_ADDR=https://fixture
  export OPENBAO_APPROLE_APPROLE_ISSUER_ROLE_ID=issuer-role-id
  export OPENBAO_APPROLE_APPROLE_ISSUER_SECRET_ID=issuer-secret
}

DESTROY_RECONCILE=$'POST\tauth/approle/role/openbao-reconcile/secret-id-accessor/destroy\tissuer-token\t-'

@test "approle-token skips the destroy when the secret id is single-use and login succeeded" {
  approle_env
  export FLOW_LOCK_FIXTURE_NUM_USES=1

  run "$FLOW_LOCK" approle-token openbao-reconcile

  [ "$status" -eq 0 ]
  [ "$output" = "reconcile-token" ]
  grep -Fx $'POST\tauth/approle/login\t-\topenbao-reconcile' "$FLOW_LOCK_API_LOG"
  ! grep -F 'secret-id-accessor/destroy' "$FLOW_LOCK_API_LOG"
}

@test "approle-token still destroys the secret id when num_uses is absent, 0 or above 1" {
  approle_env
  run "$FLOW_LOCK" approle-token openbao-reconcile
  [ "$status" -eq 0 ]
  grep -Fx "$DESTROY_RECONCILE" "$FLOW_LOCK_API_LOG"

  for uses in 0 5; do
    : > "$FLOW_LOCK_API_LOG"
    FLOW_LOCK_FIXTURE_NUM_USES="$uses" run "$FLOW_LOCK" approle-token openbao-reconcile
    [ "$status" -eq 0 ]
    grep -Fx "$DESTROY_RECONCILE" "$FLOW_LOCK_API_LOG"
  done
}

@test "approle-token destroys the secret id and fails when login fails with num_uses 1" {
  approle_env
  export FLOW_LOCK_FIXTURE_NUM_USES=1
  export FLOW_LOCK_FIXTURE_REJECT_RECONCILE=1

  run "$FLOW_LOCK" approle-token openbao-reconcile

  [ "$status" -eq 70 ]
  grep -Fx "$DESTROY_RECONCILE" "$FLOW_LOCK_API_LOG"
}

@test "approle-token fails when the destroy is required and the server rejects it" {
  approle_env
  export FLOW_LOCK_FIXTURE_NUM_USES=5
  export FLOW_LOCK_FIXTURE_DESTROY_STATUS=500

  run "$FLOW_LOCK" approle-token openbao-reconcile

  [ "$status" -eq 70 ]
  [[ "$output" == *"revocation failed (HTTP 500)"* ]]
  [ "$(grep -Fc "$DESTROY_RECONCILE" "$FLOW_LOCK_API_LOG")" -eq 1 ]
}

@test "approle-token accepts OpenBao's missing accessor response as already revoked" {
  approle_env
  export FLOW_LOCK_FIXTURE_NUM_USES=5
  export FLOW_LOCK_FIXTURE_DESTROY_ALREADY_GONE=1

  run "$FLOW_LOCK" approle-token openbao-reconcile

  [ "$status" -eq 0 ]
  [ "$output" = "reconcile-token" ]
  [ "$(grep -Fc "$DESTROY_RECONCILE" "$FLOW_LOCK_API_LOG")" -eq 1 ]
}

@test "flow-lock status skips the destroy when the secret id is single-use" {
  approle_env
  export FLOW_LOCK_FIXTURE_NUM_USES=1

  run "$FLOW_LOCK" status

  [ "$status" -eq 0 ]
  [[ "$output" == *"flow-lock: free (no lease held)"* ]]
  grep -Fx $'POST\tauth/approle/login\t-\tflow-lock' "$FLOW_LOCK_API_LOG"
  grep -Fx $'GET\tsecret/data/locks/global\tflow-lock-token\t-' "$FLOW_LOCK_API_LOG"
  ! grep -F 'secret-id-accessor/destroy' "$FLOW_LOCK_API_LOG"
}

@test "approle-token rejects malformed role names before calling OpenBao" {
  fake_flow_lock_openbao
  export BAO_ADDR=https://fixture
  export OPENBAO_APPROLE_APPROLE_ISSUER_ROLE_ID=issuer-role-id
  export OPENBAO_APPROLE_APPROLE_ISSUER_SECRET_ID=issuer-secret

  run "$FLOW_LOCK" approle-token 'role/secret-id'

  [ "$status" -eq 64 ]
  [ ! -s "$FLOW_LOCK_API_LOG" ]
}

@test "flow-lock status treats a supplied BAO_TOKEN as issuer authority" {
  fake_flow_lock_openbao
  BAO_ADDR=https://fixture BAO_TOKEN=issuer-token run "$FLOW_LOCK" status

  [ "$status" -eq 0 ]
  [[ "$output" == *"flow-lock: free (no lease held)"* ]]
  [ "$(wc -l < "$FLOW_LOCK_API_LOG" | tr -d ' ')" -eq 5 ]
  grep -Fx $'GET\tauth/approle/role/flow-lock/role-id\tissuer-token\t-' "$FLOW_LOCK_API_LOG"
  grep -Fx $'POST\tauth/approle/role/flow-lock/secret-id-accessor/destroy\tissuer-token\t-' "$FLOW_LOCK_API_LOG"
}

@test "flow-lock status refuses the obsolete static flow-lock pair" {
  BAO_ADDR=https://fixture FLOW_LOCK_ROLE_ID=old-role FLOW_LOCK_SECRET_ID=old-secret run "$FLOW_LOCK" status

  [ "$status" -eq 64 ]
  [[ "$output" == *"OPENBAO_APPROLE_APPROLE_ISSUER_ROLE_ID/SECRET_ID"* ]]
}

@test "flow-lock run reuses the scoped token and withholds issuer inputs from the child" {
  fake_flow_lock_openbao
  export BAO_ADDR=https://fixture
  export OPENBAO_APPROLE_APPROLE_ISSUER_ROLE_ID=issuer-role-id
  export OPENBAO_APPROLE_APPROLE_ISSUER_SECRET_ID=issuer-secret

  run "$FLOW_LOCK" run --ttl 3s --timeout 0 -- sh -c 'test -z "${FLOW_LOCK_ROLE_ID:-}" && test -z "${FLOW_LOCK_SECRET_ID:-}" && test -z "${OPENBAO_APPROLE_APPROLE_ISSUER_ROLE_ID:-}" && test -z "${OPENBAO_APPROLE_APPROLE_ISSUER_SECRET_ID:-}" && test -z "${BAO_TOKEN:-}"'

  [ "$status" -eq 0 ]
  [ "$(grep -c 'auth/approle/login' "$FLOW_LOCK_API_LOG")" -eq 2 ]
  [ "$(grep -F -c $'POST\tauth/approle/role/flow-lock/secret-id\t' "$FLOW_LOCK_API_LOG")" -eq 1 ]
  [ "$(grep -F -c $'POST\tauth/approle/role/flow-lock/secret-id-accessor/destroy\t' "$FLOW_LOCK_API_LOG")" -eq 1 ]
  [ "$(grep -c $'POST\tsecret/data/locks/global\tflow-lock-token' "$FLOW_LOCK_API_LOG")" -eq 1 ]
  [ "$(grep -c $'GET\tsecret/data/locks/global\tflow-lock-token' "$FLOW_LOCK_API_LOG")" -eq 1 ]
  grep -Fx $'DELETE\tsecret/metadata/locks/global\tflow-lock-token\t-' "$FLOW_LOCK_API_LOG"
}

@test "flow-lock run acquires an absent key with cas=0" {
  approle_env

  run "$FLOW_LOCK" run --ttl 3s --timeout 2s -- sh -c '[ "$FLOW_LOCK_VERSION" = 1 ]'

  [ "$status" -eq 0 ]
  grep -Fx $'POST\tsecret/data/locks/global\t0' "$FLOW_LOCK_FIXTURE_CAS_LOG"
  grep -Fx $'DELETE\tsecret/metadata/locks/global\tflow-lock-token\t-' "$FLOW_LOCK_API_LOG"
}

@test "flow-lock run takes over a soft-deleted key with the observed CAS version" {
  approle_env
  export FLOW_LOCK_FIXTURE_MODE=soft-deleted

  run "$FLOW_LOCK" run --ttl 3s --timeout 2s -- sh -c '[ "$FLOW_LOCK_VERSION" = 8 ]'

  [ "$status" -eq 0 ]
  grep -Fx $'POST\tsecret/data/locks/global\t0' "$FLOW_LOCK_FIXTURE_CAS_LOG"
  grep -Fx $'POST\tsecret/data/locks/global\t7' "$FLOW_LOCK_FIXTURE_CAS_LOG"
  grep -Fx $'DELETE\tsecret/metadata/locks/global\tflow-lock-token\t-' "$FLOW_LOCK_API_LOG"
}

@test "flow-lock run sleeps and retries after a soft-deleted CAS conflict" {
  approle_env
  export FLOW_LOCK_FIXTURE_MODE=soft-deleted-retry
  export FLOW_LOCK_FIXTURE_FAST_SLEEP=1

  run "$FLOW_LOCK" run --ttl 3s --timeout 2s -- sh -c '[ "$FLOW_LOCK_VERSION" = 8 ]'

  [ "$status" -eq 0 ]
  [ "$(grep -Fc $'POST\tsecret/data/locks/global\t7' "$FLOW_LOCK_FIXTURE_CAS_LOG")" -eq 2 ]
  # the renewer's stubbed sleep also logs here, so assert a retry sleep happened rather than an exact count
  [ -s "$FLOW_LOCK_SLEEP_LOG" ]
}

@test "flow-lock run reports a held lease and returns EX_TEMPFAIL at its deadline" {
  approle_env
  export FLOW_LOCK_FIXTURE_MODE=held
  timeout_bin="$(command -v timeout || command -v gtimeout)"

  run "$timeout_bin" 3 "$FLOW_LOCK" run --timeout 0 -- true

  [ "$status" -eq 75 ]
  [[ "$output" == *"waiting: held by test@fixture"* ]]
  [[ "$output" == *"timed out after 0s"* ]]
  [ ! -s "$FLOW_LOCK_SLEEP_LOG" ]
}

@test "flow-lock run takes over an expired lease with the observed CAS version" {
  approle_env
  export FLOW_LOCK_FIXTURE_MODE=expired

  run "$FLOW_LOCK" run --ttl 3s --timeout 2s -- sh -c '[ "$FLOW_LOCK_VERSION" = 5 ]'

  [ "$status" -eq 0 ]
  [[ "$output" == *"took over an EXPIRED lease"* ]]
  grep -Fx $'POST\tsecret/data/locks/global\t4' "$FLOW_LOCK_FIXTURE_CAS_LOG"
}

@test "flow-lock run bounds retries after an expired-lease CAS conflict" {
  approle_env
  export FLOW_LOCK_FIXTURE_MODE=expired-stuck
  timeout_bin="$(command -v timeout || command -v gtimeout)"

  run "$timeout_bin" 3 "$FLOW_LOCK" run --timeout 0 -- true

  [ "$status" -eq 75 ]
  grep -Fx $'POST\tsecret/data/locks/global\t4' "$FLOW_LOCK_FIXTURE_CAS_LOG"
  [[ "$output" == *"timed out after 0s"* ]]
  [ ! -s "$FLOW_LOCK_SLEEP_LOG" ]
}

@test "flow-lock run bounds retries after a soft-deleted CAS conflict" {
  approle_env
  export FLOW_LOCK_FIXTURE_MODE=soft-deleted-stuck
  timeout_bin="$(command -v timeout || command -v gtimeout)"

  run "$timeout_bin" 3 "$FLOW_LOCK" run --timeout 0 -- true

  [ "$status" -eq 75 ]
  grep -Fx $'POST\tsecret/data/locks/global\t7' "$FLOW_LOCK_FIXTURE_CAS_LOG"
  [[ "$output" == *"timed out after 0s"* ]]
  [ ! -s "$FLOW_LOCK_SLEEP_LOG" ]
}

@test "flow-lock break clears and audits a soft-deleted key" {
  approle_env
  export FLOW_LOCK_FIXTURE_MODE=soft-deleted

  run "$FLOW_LOCK" break --reason "clear tombstone" --yes

  [ "$status" -eq 0 ]
  [[ "$output" == *"FORCE-BREAK soft-deleted lease version 7"* ]]
  grep -Fx $'DELETE\tsecret/metadata/locks/global\tflow-lock-token\t-' "$FLOW_LOCK_API_LOG"
  jq -e '.data.action == "force-break" and .data.version == 7 and .data.victim == null' \
    "$FLOW_LOCK_FIXTURE_AUDIT_BODY"
}

@test "bootstrap mode runs the child without mint credentials and passes exit code through" {
  FLOW_LOCK_BOOTSTRAP=1 OPENBAO_APPROLE_APPROLE_ISSUER_ROLE_ID=issuer-role \
    OPENBAO_APPROLE_APPROLE_ISSUER_SECRET_ID=issuer-secret BAO_TOKEN=issuer-token \
    run "$FLOW_LOCK" run -- sh -c 'test -z "${OPENBAO_APPROLE_APPROLE_ISSUER_ROLE_ID:-}" && test -z "${OPENBAO_APPROLE_APPROLE_ISSUER_SECRET_ID:-}" && test -z "${BAO_TOKEN:-}" && exit 7'
  [ "$status" -eq 7 ]
  [[ "$output" == *"BOOTSTRAP MODE"* ]]
}

@test "bootstrap mode does not export FLOW_LOCK_LEASE_ID" {
  FLOW_LOCK_BOOTSTRAP=1 run "$FLOW_LOCK" run -- sh -c 'test -z "${FLOW_LOCK_LEASE_ID:-}"'
  [ "$status" -eq 0 ]
}

@test "flow-lock break requires --reason" {
  run "$FLOW_LOCK" break
  [ "$status" -eq 64 ]
  [[ "$output" == *"--reason is required"* ]]
}

@test "flow-lock release requires --lease-id" {
  run "$FLOW_LOCK" release
  [ "$status" -eq 64 ]
  [[ "$output" == *"--lease-id is required"* ]]
}

# ---- deployment-json --------------------------------------------------------

@test "deployment-json with no args prints usage and exits 64" {
  run "$DEPLOYMENT_JSON"
  [ "$status" -eq 64 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "deployment-json edit refuses without a flow-lock lease" {
  run "$DEPLOYMENT_JSON" edit --schema /dev/null
  [ "$status" -eq 64 ]
  [[ "$output" == *"no FLOW_LOCK_LEASE_ID"* ]]
}

@test "deployment-json put refuses without a flow-lock lease" {
  tmp="$BATS_TEST_TMPDIR/d.json"
  echo '{}' > "$tmp"
  run "$DEPLOYMENT_JSON" put "$tmp" --schema /dev/null
  [ "$status" -eq 64 ]
  [[ "$output" == *"no FLOW_LOCK_LEASE_ID"* ]]
}

@test "deployment-json put under a lease still requires store creds" {
  tmp="$BATS_TEST_TMPDIR/d.json"
  echo '{}' > "$tmp"
  FLOW_LOCK_LEASE_ID=test-lease run "$DEPLOYMENT_JSON" put "$tmp" --schema /dev/null
  [ "$status" -eq 64 ]
  [[ "$output" == *"S3_ENDPOINT"* ]]
}

@test "deployment-json fetch without store creds exits 64" {
  run "$DEPLOYMENT_JSON" fetch
  [ "$status" -eq 64 ]
  [[ "$output" == *"S3_ENDPOINT"* ]]
}

# ---- put: containers.* deletion guard ---------------------------------------
#
# These stub the store: a fake `aws` serves a fixture for `s3 cp` and accepts
# `s3api put-object`, and a fake `check-jsonschema` passes validation. That
# keeps the guard's real logic (fetch -> compare -> refuse) under test offline.

fake_store() {
  local published="$1"
  STUB="$BATS_TEST_TMPDIR/stub"
  mkdir -p "$STUB"
  {
    echo '#!/usr/bin/env bash'
    # s3() calls: aws --endpoint-url URL s3 cp SRC DEST --quiet  -> DEST is $6
    echo 'if [ "$3" = "s3" ] && [ "$4" = "cp" ]; then cp "'"$published"'" "$6"; exit 0; fi'
    echo 'exit 0'
  } > "$STUB/aws"
  printf '#!/usr/bin/env bash\nexit 0\n' > "$STUB/check-jsonschema"
  chmod +x "$STUB/aws" "$STUB/check-jsonschema"
  # validate() requires a real regular file; the stubbed checker ignores it
  SCHEMA="$BATS_TEST_TMPDIR/schema.json"
  echo '{}' > "$SCHEMA"
  export PATH="$STUB:$PATH"
  export S3_ENDPOINT=http://stub S3_ACCESS_KEY=k S3_SECRET_KEY=s
  export DEPLOYMENT_JSON_S3_URI="s3://bucket/deployment.json"
  export FLOW_LOCK_LEASE_ID=test-lease
}

@test "the object location defaults instead of demanding an env prefix" {
  pub="$BATS_TEST_TMPDIR/pub.json"
  echo '{"containers":{"keep":{}}}' > "$pub"
  fake_store "$pub"
  # The one thing this guards: unset, it must still resolve a location rather
  # than dying on a missing variable. Every caller used to restate the same
  # constant, which is a constant that can be typo'd at each call site.
  unset DEPLOYMENT_JSON_S3_URI
  run "$DEPLOYMENT_JSON" fetch "$BATS_TEST_TMPDIR/out.json"
  [ "$status" -eq 0 ]
  [[ "$output" != *"missing DEPLOYMENT_JSON_S3_URI"* ]]
}

@test "deployment-json edit succeeds after an upload and cleans up safely" {
  pub="$BATS_TEST_TMPDIR/pub.json"
  echo '{"containers":{"keep":{}}}' > "$pub"
  fake_store "$pub"
  run "$DEPLOYMENT_JSON" edit --schema "$SCHEMA" --patch '.'
  [ "$status" -eq 0 ]
  [[ "$output" == *"uploaded"* ]]
  [[ "$output" != *"unbound variable"* ]]
}

@test "put REFUSES when a containers key would vanish" {
  pub="$BATS_TEST_TMPDIR/pub.json"
  new="$BATS_TEST_TMPDIR/new.json"
  echo '{"containers":{"keep":{},"doomed":{}}}' > "$pub"
  echo '{"containers":{"keep":{}}}' > "$new"
  fake_store "$pub"
  run "$DEPLOYMENT_JSON" put "$new" --schema "$SCHEMA"
  [ "$status" -eq 65 ]
  [[ "$output" == *"would DELETE"* ]]
  [[ "$output" == *"doomed"* ]]
  [[ "$output" == *"--allow-delete doomed"* ]]
  [[ "$output" != *"uploaded"* ]]
}

@test "put proceeds when every vanishing key is named in --allow-delete" {
  pub="$BATS_TEST_TMPDIR/pub.json"
  new="$BATS_TEST_TMPDIR/new.json"
  echo '{"containers":{"keep":{},"a":{},"b":{}}}' > "$pub"
  echo '{"containers":{"keep":{}}}' > "$new"
  fake_store "$pub"
  run "$DEPLOYMENT_JSON" put "$new" --schema "$SCHEMA" --allow-delete a,b
  [ "$status" -eq 0 ]
  [[ "$output" == *"uploaded"* ]]
}

@test "put still REFUSES when --allow-delete names only some vanishing keys" {
  pub="$BATS_TEST_TMPDIR/pub.json"
  new="$BATS_TEST_TMPDIR/new.json"
  echo '{"containers":{"a":{},"b":{}}}' > "$pub"
  echo '{"containers":{}}' > "$new"
  fake_store "$pub"
  run "$DEPLOYMENT_JSON" put "$new" --schema "$SCHEMA" --allow-delete a
  [ "$status" -eq 65 ]
  [[ "$output" == *"b"* ]]
  [[ "$output" != *"uploaded"* ]]
}

@test "put allows a pure addition with no --allow-delete" {
  pub="$BATS_TEST_TMPDIR/pub.json"
  new="$BATS_TEST_TMPDIR/new.json"
  echo '{"containers":{"keep":{}}}' > "$pub"
  echo '{"containers":{"keep":{},"added":{}}}' > "$new"
  fake_store "$pub"
  run "$DEPLOYMENT_JSON" put "$new" --schema "$SCHEMA"
  [ "$status" -eq 0 ]
  [[ "$output" == *"uploaded"* ]]
}

@test "put REFUSES when the published object has no readable containers map" {
  pub="$BATS_TEST_TMPDIR/pub.json"
  new="$BATS_TEST_TMPDIR/new.json"
  echo '{"not_containers":1}' > "$pub"
  echo '{"containers":{"keep":{}}}' > "$new"
  fake_store "$pub"
  run "$DEPLOYMENT_JSON" put "$new" --schema "$SCHEMA"
  [ "$status" -eq 70 ]
  [[ "$output" == *"no readable .containers"* ]]
  [[ "$output" != *"uploaded"* ]]
}

@test "put REFUSES when the published object is empty (blank must never destroy)" {
  pub="$BATS_TEST_TMPDIR/pub.json"
  new="$BATS_TEST_TMPDIR/new.json"
  : > "$pub"
  echo '{"containers":{"keep":{}}}' > "$new"
  fake_store "$pub"
  run "$DEPLOYMENT_JSON" put "$new" --schema "$SCHEMA"
  [ "$status" -eq 70 ]
  [[ "$output" == *"EMPTY"* ]]
  [[ "$output" != *"uploaded"* ]]
}

@test "bootstrap mode skips the deletion guard" {
  pub="$BATS_TEST_TMPDIR/pub.json"
  new="$BATS_TEST_TMPDIR/new.json"
  echo '{"containers":{"keep":{},"doomed":{}}}' > "$pub"
  echo '{"containers":{"keep":{}}}' > "$new"
  fake_store "$pub"
  FLOW_LOCK_BOOTSTRAP=1 run "$DEPLOYMENT_JSON" put "$new" --schema "$SCHEMA"
  [ "$status" -eq 0 ]
  [[ "$output" == *"skipping the container-deletion guard"* ]]
}
