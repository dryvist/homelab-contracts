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
  unset FLOW_LOCK_BOOTSTRAP FLOW_LOCK_LEASE_ID
  unset S3_ENDPOINT S3_ACCESS_KEY S3_SECRET_KEY
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

@test "bootstrap mode runs the child with no lease and passes exit code through" {
  FLOW_LOCK_BOOTSTRAP=1 run "$FLOW_LOCK" run -- sh -c 'exit 7'
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
