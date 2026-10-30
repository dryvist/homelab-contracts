#!/usr/bin/env bats
# CLI-contract tests for bao-approle. No live OpenBao or GitHub token endpoint.

setup() {
  BAO_APPROLE="$BATS_TEST_DIRNAME/../bin/bao-approle"
  export BAO_ADDR=https://bao.fixture
  export FIXTURE_CASE=success
  export FIXTURE_ARGV_LOG="$BATS_TEST_TMPDIR/curl-argv.log"
  : > "$FIXTURE_ARGV_LOG"

  STUB="$BATS_TEST_TMPDIR/stub"
  mkdir -p "$STUB"
  cat > "$STUB/curl" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$@" >> "$FIXTURE_ARGV_LOG"
method=GET
url=""
write_out=""
read_body=false
while [ "$#" -gt 0 ]; do
  case "$1" in
    -X) method="$2"; shift 2 ;;
    -H|--max-time|--cacert) shift 2 ;;
    -w) write_out="$2"; shift 2 ;;
    --data-binary)
      if [ "$2" = "@-" ]; then
        read_body=true
      else
        body="$2"
      fi
      shift 2
      ;;
    -*) shift ;;
    *) url="$1"; shift ;;
  esac
done
body=""
if [ "$read_body" = true ]; then
  body=$(cat)
fi
path="/${url#*://*/}"
response='{}'
status=200
case "$method $path" in
  "POST /v1/auth/approle/login")
    [ "$(jq -r '.role_id' <<<"$body")" != null ]
    [ "$(jq -r '.secret_id' <<<"$body")" != null ]
    case "$FIXTURE_CASE" in
      login-forbidden)
        response='{"errors":["invalid role or secret ID"]}'
        status=403
        ;;
      login-missing-token) response='{"auth":{}}' ;;
      *) response='{"auth":{"client_token":"client-token-fixture"}}' ;;
    esac
    ;;
  "POST /v1/auth/token/revoke-self")
    status=204
    response=""
    ;;
  "POST /v1/github-apps/token/review")
    if [ "$FIXTURE_CASE" = gh-forbidden ]; then
      response='{"errors":["permission denied"]}'
      status=403
    else
      response='{"data":{"token":"github-installation-token-fixture"}}'
    fi
    ;;
  *)
    response='{"errors":["fixture did not match"]}'
    status=500
    ;;
esac
printf '%s' "$response"
[ -z "$write_out" ] || printf '\n%s' "$status"
SH
  chmod +x "$STUB/curl"
  export PATH="$STUB:$BATS_TEST_DIRNAME/../bin:$PATH"
}

teardown() {
  unset BAO_APPROLE_ROLE_ID BAO_APPROLE_SECRET_ID BAO_TOKEN
}

@test "login reads 0600 credential files and prints only the client token" {
  role_file="$BATS_TEST_TMPDIR/role-id"
  secret_file="$BATS_TEST_TMPDIR/secret-id"
  printf 'role-fixture\n' > "$role_file"
  printf 'secret-fixture\n' > "$secret_file"
  chmod 600 "$role_file" "$secret_file"

  run "$BAO_APPROLE" login --role-id-file "$role_file" --secret-id-file "$secret_file" --addr "$BAO_ADDR" --cacert cert.pem

  [ "$status" -eq 0 ]
  [ "$output" = "client-token-fixture" ]
  ! grep -Fq 'secret-fixture' "$FIXTURE_ARGV_LOG"
  grep -Fq -- '--data-binary' "$FIXTURE_ARGV_LOG"
  grep -Fq -- '--cacert' "$FIXTURE_ARGV_LOG"
}

@test "login returns the OpenBao error and HTTP refusal code" {
  export BAO_APPROLE_ROLE_ID=role-fixture BAO_APPROLE_SECRET_ID=secret-fixture FIXTURE_CASE=login-forbidden

  run "$BAO_APPROLE" login

  [ "$status" -eq 22 ]
  [[ "$output" == *"invalid role or secret ID"* ]]
  ! [[ "$output" == *"secret-fixture"* ]]
  ! grep -Fq 'secret-fixture' "$FIXTURE_ARGV_LOG"
}

@test "login follows redirects only when asked" {
  export BAO_APPROLE_ROLE_ID=role-fixture BAO_APPROLE_SECRET_ID=secret-fixture

  run "$BAO_APPROLE" login

  [ "$status" -eq 0 ]
  ! grep -Fx -- '-L' "$FIXTURE_ARGV_LOG"

  : > "$FIXTURE_ARGV_LOG"
  run "$BAO_APPROLE" login --follow-redirects

  [ "$status" -eq 0 ]
  grep -Fx -- '-L' "$FIXTURE_ARGV_LOG"
}

@test "login fails when the response has no client token" {
  export BAO_APPROLE_ROLE_ID=role-fixture BAO_APPROLE_SECRET_ID=secret-fixture FIXTURE_CASE=login-missing-token

  run "$BAO_APPROLE" login

  [ "$status" -eq 1 ]
  [[ "$output" == *"did not contain a client token"* ]]
  ! [[ "$output" == *"secret-fixture"* ]]
}

@test "revoke-self accepts its token from the environment" {
  export BAO_TOKEN=bao-token-fixture

  run "$BAO_APPROLE" revoke-self

  [ "$status" -eq 0 ]
  [ -z "$output" ]
  ! grep -Fq 'bao-token-fixture' "$FIXTURE_ARGV_LOG"
}

@test "revoke-self accepts its token from stdin" {
  unset BAO_TOKEN
  revoke_from_stdin() {
    printf 'bao-token-fixture\n' | "$BAO_APPROLE" revoke-self
  }

  run revoke_from_stdin

  [ "$status" -eq 0 ]
  [ -z "$output" ]
  ! grep -Fq 'bao-token-fixture' "$FIXTURE_ARGV_LOG"
}

@test "gh-token prints only the installation token" {
  export BAO_TOKEN=bao-token-fixture

  run "$BAO_APPROLE" gh-token github-apps review

  [ "$status" -eq 0 ]
  [ "$output" = "github-installation-token-fixture" ]
  ! grep -Fq 'bao-token-fixture' "$FIXTURE_ARGV_LOG"
  grep -Fq '/v1/auth/token/revoke-self' "$FIXTURE_ARGV_LOG"
}

@test "gh-token reports OpenBao failures without printing a token" {
  export BAO_TOKEN=bao-token-fixture FIXTURE_CASE=gh-forbidden

  run "$BAO_APPROLE" gh-token github-apps review

  [ "$status" -eq 22 ]
  [[ "$output" == *"permission denied"* ]]
  ! [[ "$output" == *"bao-token-fixture"* ]]
  ! [[ "$output" == *"github-installation-token-fixture"* ]]
  grep -Fq '/v1/auth/token/revoke-self' "$FIXTURE_ARGV_LOG"
}

@test "token requests accept loopback http addresses" {
  export BAO_TOKEN=bao-token-fixture BAO_ADDR=http://127.0.0.1:8200

  run "$BAO_APPROLE" revoke-self

  [ "$status" -eq 0 ]
  [ -z "$output" ]

  export BAO_ADDR=http://localhost
  run "$BAO_APPROLE" revoke-self

  [ "$status" -eq 0 ]
  [ -z "$output" ]

  export BAO_ADDR='http://[::1]:8200/'
  run "$BAO_APPROLE" revoke-self

  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "token requests reject non-loopback http addresses before contacting OpenBao" {
  export BAO_TOKEN=bao-token-fixture BAO_ADDR=http://127.0.0.1.evil.example

  run "$BAO_APPROLE" gh-token github-apps review

  [ "$status" -eq 64 ]
  [[ "$output" == *"BAO_ADDR must be an https URL for token requests"* ]]
  [ ! -s "$FIXTURE_ARGV_LOG" ]

  export BAO_ADDR=http://localhost.evil.example
  run "$BAO_APPROLE" gh-token github-apps review

  [ "$status" -eq 64 ]
  [[ "$output" == *"BAO_ADDR must be an https URL for token requests"* ]]
  [ ! -s "$FIXTURE_ARGV_LOG" ]

  export BAO_ADDR=http://192.0.2.5
  run "$BAO_APPROLE" gh-token github-apps review

  [ "$status" -eq 64 ]
  [[ "$output" == *"BAO_ADDR must be an https URL for token requests"* ]]
  [ ! -s "$FIXTURE_ARGV_LOG" ]

  export BAO_ADDR=http://example.com
  run "$BAO_APPROLE" gh-token github-apps review

  [ "$status" -eq 64 ]
  [[ "$output" == *"BAO_ADDR must be an https URL for token requests"* ]]
  [ ! -s "$FIXTURE_ARGV_LOG" ]
}
