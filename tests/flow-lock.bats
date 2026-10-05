#!/usr/bin/env bats
# CLI-contract tests for bin/flow-lock and bin/deployment-json.
# No live OpenBao/S3: these pin argument parsing, refusal paths, exit codes,
# and bootstrap-mode behavior. Lease/CAS behavior is covered by the live
# verification suite (docs runbook), not unit tests.

setup() {
  FLOW_LOCK="$BATS_TEST_DIRNAME/../bin/flow-lock"
  DEPLOYMENT_JSON="$BATS_TEST_DIRNAME/../bin/deployment-json"
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
    fi
    ;;
  auth/approle/role/flow-lock/role-id)
    response='{"data":{"role_id":"flow-lock-role-id"}}'
    status=200
    ;;
  auth/approle/role/flow-lock/secret-id)
    response='{"data":{"secret_id":"flow-lock-secret"}}'
    status=200
    ;;
  secret/data/locks/global)
    if [ "$method" = POST ]; then
      jq -r '.data.lease_id' <<<"$request_data" > "$FLOW_LOCK_FIXTURE_LEASE_ID"
      response='{"data":{"version":1}}'
      status=200
    elif [ "$method" = GET ] && [ -f "$FLOW_LOCK_FIXTURE_LEASE_ID" ]; then
      lease_id="$(cat "$FLOW_LOCK_FIXTURE_LEASE_ID")"
      response="$(jq -nc --arg lease_id "$lease_id" '{data:{metadata:{version:1},data:{lease_id:$lease_id,holder:{user:"test",host:"",pid:1},flow:"test",repo:"test",expires_at:(now|floor+600),renewals:0}}}')"
      status=200
    else
      response='{"errors":["not found"]}'
      status=404
    fi
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
  export FLOW_LOCK_API_LOG="$BATS_TEST_TMPDIR/openbao-calls"
  export FLOW_LOCK_FIXTURE_LEASE_ID="$BATS_TEST_TMPDIR/lease-id"
  : > "$FLOW_LOCK_API_LOG"
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
  export BAO_ADDR=fixture
  export OPENBAO_APPROLE_APPROLE_ISSUER_ROLE_ID=issuer-role-id
  export OPENBAO_APPROLE_APPROLE_ISSUER_SECRET_ID=issuer-secret

  run "$FLOW_LOCK" status

  [ "$status" -eq 0 ]
  [[ "$output" == *"flow-lock: free (no lease held)"* ]]
  [ "$(wc -l < "$FLOW_LOCK_API_LOG" | tr -d ' ')" -eq 5 ]
  grep -Fx $'POST\tauth/approle/login\t-\tissuer' "$FLOW_LOCK_API_LOG"
  grep -Fx $'GET\tauth/approle/role/flow-lock/role-id\tissuer-token\t-' "$FLOW_LOCK_API_LOG"
  grep -Fx $'POST\tauth/approle/role/flow-lock/secret-id\tissuer-token\t-' "$FLOW_LOCK_API_LOG"
  grep -Fx $'POST\tauth/approle/login\t-\tflow-lock' "$FLOW_LOCK_API_LOG"
  grep -Fx $'GET\tsecret/data/locks/global\tflow-lock-token\t-' "$FLOW_LOCK_API_LOG"
}

@test "flow-lock status treats a supplied BAO_TOKEN as issuer authority" {
  fake_flow_lock_openbao
  BAO_ADDR=fixture BAO_TOKEN=issuer-token run "$FLOW_LOCK" status

  [ "$status" -eq 0 ]
  [[ "$output" == *"flow-lock: free (no lease held)"* ]]
  [ "$(wc -l < "$FLOW_LOCK_API_LOG" | tr -d ' ')" -eq 4 ]
  grep -Fx $'GET\tauth/approle/role/flow-lock/role-id\tissuer-token\t-' "$FLOW_LOCK_API_LOG"
}

@test "flow-lock status refuses the obsolete static flow-lock pair" {
  BAO_ADDR=fixture FLOW_LOCK_ROLE_ID=old-role FLOW_LOCK_SECRET_ID=old-secret run "$FLOW_LOCK" status

  [ "$status" -eq 64 ]
  [[ "$output" == *"OPENBAO_APPROLE_APPROLE_ISSUER_ROLE_ID/SECRET_ID"* ]]
}

@test "flow-lock run reuses the scoped token and withholds issuer inputs from the child" {
  fake_flow_lock_openbao
  export BAO_ADDR=fixture
  export OPENBAO_APPROLE_APPROLE_ISSUER_ROLE_ID=issuer-role-id
  export OPENBAO_APPROLE_APPROLE_ISSUER_SECRET_ID=issuer-secret

  run "$FLOW_LOCK" run --ttl 3s --timeout 0 -- sh -c 'test -z "${FLOW_LOCK_ROLE_ID:-}" && test -z "${FLOW_LOCK_SECRET_ID:-}" && test -z "${OPENBAO_APPROLE_APPROLE_ISSUER_ROLE_ID:-}" && test -z "${OPENBAO_APPROLE_APPROLE_ISSUER_SECRET_ID:-}" && test -z "${BAO_TOKEN:-}"'

  [ "$status" -eq 0 ]
  [ "$(grep -c 'auth/approle/login' "$FLOW_LOCK_API_LOG")" -eq 2 ]
  [ "$(grep -c 'auth/approle/role/flow-lock/secret-id' "$FLOW_LOCK_API_LOG")" -eq 1 ]
  [ "$(grep -c $'POST\tsecret/data/locks/global\tflow-lock-token' "$FLOW_LOCK_API_LOG")" -eq 1 ]
  [ "$(grep -c $'GET\tsecret/data/locks/global\tflow-lock-token' "$FLOW_LOCK_API_LOG")" -eq 1 ]
  grep -Fx $'DELETE\tsecret/metadata/locks/global\tflow-lock-token\t-' "$FLOW_LOCK_API_LOG"
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
