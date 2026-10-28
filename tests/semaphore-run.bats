#!/usr/bin/env bats
# CLI-contract tests for scripts/semaphore-run. No live OpenBao or Semaphore:
# curl, flow-lock and sleep are stubbed on PATH. The curl stub logs every call
# (method, path, auth header name, token, full URL) and answers from fixtures.

setup() {
  SEMAPHORE_RUN="$BATS_TEST_DIRNAME/../scripts/semaphore-run"
  unset BAO_TOKEN PROXMOX_SUBDOMAIN FLOW_LOCK_BOOTSTRAP
  export BAO_ADDR=http://bao.fixture
  export SEMAPHORE_ADDR=https://sem.fixture
  unset SEMAPHORE_SECRET_STATUS FIXTURE_TASK_STATUSES FIXTURE_TASK_PROJECT
  unset FIXTURE_TASK_HTTP FIXTURE_REVOKE_STATUS FIXTURE_NO_SEM_FIELD FIXTURE_FLOW_LOCK_FAIL

  STUB="$BATS_TEST_TMPDIR/stub"
  mkdir -p "$STUB"
  cat > "$STUB/curl" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
original_args="$*"
method=GET
url=""
body=""
config=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    -X) method="$2"; shift 2 ;;
    -H|-w|--max-time) shift 2 ;;
    --config) config="$2"; shift 2 ;;
    --data-binary) body="$2"; shift 2 ;;
    -sS|-s|-S) shift ;;
    http*) url="$1"; shift ;;
    *) shift ;;
  esac
done
printf '%s\n' "$original_args" >> "$FIXTURE_ARGV_LOG"
header_name="-"
token="-"
if [ "$config" = "-" ]; then
  prefix='header = "'
  while IFS= read -r line; do
    case "$line" in
      "$prefix"*)
        inner="${line#"$prefix"}"
        inner="${inner%\"}"
        header_name="${inner%%: *}"
        token="${inner#*: }"
        ;;
    esac
  done
fi
rest="${url#*://}"
path="/${rest#*/}"
printf '%s\t%s\t%s\t%s\t%s\n' "$method" "$path" "$header_name" "$token" "$url" >> "$FIXTURE_API_LOG"
status=200
response='{}'
case "$method $path" in
  "GET /v1/secret/data/apps/semaphore")
    if [ -n "${FIXTURE_SECRET_STATUS:-}" ]; then
      status="$FIXTURE_SECRET_STATUS"; response='{"errors":["denied"]}'
    elif [ -n "${FIXTURE_NO_SEM_FIELD:-}" ]; then
      response='{"data":{"data":{"other":"x"}}}'
    else
      response='{"data":{"data":{"semaphore_api_token":"sem-fixture-token"}}}'
    fi
    ;;
  "POST /v1/auth/token/revoke-self")
    status="${FIXTURE_REVOKE_STATUS:-204}"; response=''
    ;;
  "GET /api/projects")
    response='[{"id":1,"name":"homelab-apps"},{"id":2,"name":"homelab-pve"},{"id":3,"name":"homelab-secrets"}]'
    ;;
  "GET /api/project/1/templates")
    response='[{"id":7,"name":"apps-zammad"},{"id":8,"name":"apps-site"}]'
    ;;
  "GET /api/project/2/templates")
    response='[{"id":13,"name":"pve-converge"}]'
    ;;
  "GET /api/project/"*"/tasks/"*"/output")
    response='[{"output":"alpha"},{"output":"beta\ngamma"}]'
    ;;
  "POST /api/project/"*"/tasks/"*"/stop")
    printf '%s' "$body" > "$FIXTURE_BODY_FILE"; status=204; response=''
    ;;
  "POST /api/project/"*"/tasks")
    printf '%s' "$body" > "$FIXTURE_BODY_FILE"; status=201; response='{"id":42}'
    ;;
  "GET /api/project/"*"/tasks/"*)
    task_id="${path##*/}"
    project_id="${path#/api/project/}"; project_id="${project_id%%/*}"
    if [ -n "${FIXTURE_TASK_HTTP:-}" ]; then
      status="$FIXTURE_TASK_HTTP"; response='{"error":"fixture"}'
    elif [ "$task_id" = 42 ] && [ "$project_id" = "${FIXTURE_TASK_PROJECT:-1}" ]; then
      seq="${FIXTURE_TASK_STATUSES:-success}"
      IFS=',' read -r -a seq_arr <<<"$seq"
      n=0
      if [ -f "$FIXTURE_COUNTER" ]; then n="$(cat "$FIXTURE_COUNTER")"; fi
      idx="$n"
      if [ "$idx" -ge "${#seq_arr[@]}" ]; then idx=$(( ${#seq_arr[@]} - 1 )); fi
      printf '%s' "$(( n + 1 ))" > "$FIXTURE_COUNTER"
      response="{\"id\":42,\"status\":\"${seq_arr[$idx]}\"}"
    else
      status=404; response='{"error":"not found"}'
    fi
    ;;
  *)
    status=404; response='{"error":"no fixture route"}'
    ;;
esac
printf '%s\n%s\n' "$response" "$status"
SH
  chmod +x "$STUB/curl"

  cat > "$STUB/flow-lock" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >> "$FIXTURE_FLOW_LOCK_LOG"
if [ "${FIXTURE_FLOW_LOCK_FAIL:-}" = 1 ]; then
  echo "flow-lock: fixture failure" >&2
  exit 70
fi
if [ "$*" = "approle-token openbao-reconcile" ]; then
  printf '%s' "reconcile-token"
  exit 0
fi
exit 64
SH
  chmod +x "$STUB/flow-lock"

  cat > "$STUB/sleep" <<'SH'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$FIXTURE_SLEEP_LOG"
exit 0
SH
  chmod +x "$STUB/sleep"

  export FIXTURE_API_LOG="$BATS_TEST_TMPDIR/api-calls"
  export FIXTURE_ARGV_LOG="$BATS_TEST_TMPDIR/argv-calls"
  export FIXTURE_BODY_FILE="$BATS_TEST_TMPDIR/request-body.json"
  export FIXTURE_FLOW_LOCK_LOG="$BATS_TEST_TMPDIR/flow-lock-calls"
  export FIXTURE_SLEEP_LOG="$BATS_TEST_TMPDIR/sleep-calls"
  export FIXTURE_COUNTER="$BATS_TEST_TMPDIR/task-poll-count"
  : > "$FIXTURE_API_LOG"
  : > "$FIXTURE_ARGV_LOG"
  : > "$FIXTURE_BODY_FILE"
  : > "$FIXTURE_FLOW_LOCK_LOG"
  : > "$FIXTURE_SLEEP_LOG"
  rm -f "$FIXTURE_COUNTER"
  export PATH="$STUB:$PATH"
}

# ---- usage and argument handling --------------------------------------------

@test "no arguments prints usage and exits 64" {
  run "$SEMAPHORE_RUN"
  [ "$status" -eq 64 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "help exits 0 and names every subcommand" {
  run "$SEMAPHORE_RUN" help
  [ "$status" -eq 0 ]
  [[ "$output" == *"semaphore-run start --project"* ]]
  [[ "$output" == *"semaphore-run wait ID"* ]]
  [[ "$output" == *"semaphore-run stop ID"* ]]
}

@test "unknown subcommand exits 64" {
  run "$SEMAPHORE_RUN" frobnicate
  [ "$status" -eq 64 ]
}

@test "without SEMAPHORE_ADDR or PROXMOX_SUBDOMAIN the CLI refuses before any call" {
  unset SEMAPHORE_ADDR
  run "$SEMAPHORE_RUN" list
  [ "$status" -eq 64 ]
  [[ "$output" == *"SEMAPHORE_ADDR"* ]]
  [ ! -s "$FIXTURE_API_LOG" ]
  [ ! -s "$FIXTURE_FLOW_LOCK_LOG" ]
}

@test "PROXMOX_SUBDOMAIN builds the default base URL when SEMAPHORE_ADDR is unset" {
  unset SEMAPHORE_ADDR
  PROXMOX_SUBDOMAIN=fixture.test run "$SEMAPHORE_RUN" list
  [ "$status" -eq 0 ]
  cut -f5 "$FIXTURE_API_LOG" | grep -Fx 'https://semaphore.fixture.test/api/projects'
}

@test "SEMAPHORE_ADDR takes precedence over PROXMOX_SUBDOMAIN" {
  PROXMOX_SUBDOMAIN=fixture.test run "$SEMAPHORE_RUN" list
  [ "$status" -eq 0 ]
  cut -f5 "$FIXTURE_API_LOG" | grep -Fx 'https://sem.fixture/api/projects'
}

@test "missing BAO_ADDR exits 64 before any call" {
  unset BAO_ADDR
  run "$SEMAPHORE_RUN" list
  [ "$status" -eq 64 ]
  [[ "$output" == *"BAO_ADDR"* ]]
  [ ! -s "$FIXTURE_FLOW_LOCK_LOG" ]
}

@test "start without --project exits 64 before any call" {
  run "$SEMAPHORE_RUN" start pve-converge
  [ "$status" -eq 64 ]
  [[ "$output" == *"--project"* ]]
  [ ! -s "$FIXTURE_API_LOG" ]
}

@test "--timeout is rejected outside wait" {
  run "$SEMAPHORE_RUN" log 42 --timeout 5m
  [ "$status" -eq 64 ]
  [[ "$output" == *"only applies to wait"* ]]
}

@test "ANSIBLE_ARGS are rejected outside start" {
  run "$SEMAPHORE_RUN" wait 42 -- --limit web01
  [ "$status" -eq 64 ]
  [[ "$output" == *"only start takes ANSIBLE_ARGS"* ]]
}

@test "wait rejects a non-numeric task id" {
  run "$SEMAPHORE_RUN" wait latest
  [ "$status" -eq 64 ]
  [[ "$output" == *"numeric task ID"* ]]
}

@test "wait rejects a malformed --timeout" {
  run "$SEMAPHORE_RUN" wait 42 --timeout soon
  [ "$status" -eq 64 ]
  [[ "$output" == *"invalid duration"* ]]
}

# ---- list -------------------------------------------------------------------

@test "list with no project prints every project as id and name" {
  run "$SEMAPHORE_RUN" list
  [ "$status" -eq 0 ]
  [[ "$output" == *$'1\thomelab-apps'* ]]
  [[ "$output" == *$'2\thomelab-pve'* ]]
  [[ "$output" == *$'3\thomelab-secrets'* ]]
}

@test "list --project prints that project's templates" {
  run "$SEMAPHORE_RUN" list --project homelab-pve
  [ "$status" -eq 0 ]
  [ "$output" = $'13\tpve-converge' ]
}

# ---- start ------------------------------------------------------------------

@test "start encodes ANSIBLE_ARGS once as a JSON array string" {
  run "$SEMAPHORE_RUN" start --project homelab-pve pve-converge -- --limit web01 --tags "a b"
  [ "$status" -eq 0 ]
  [ "$output" = "42" ]
  jq -e '.arguments == "[\"--limit\",\"web01\",\"--tags\",\"a b\"]"' "$FIXTURE_BODY_FILE"
  jq -e '.template_id == 13 and .project_id == 2' "$FIXTURE_BODY_FILE"
  jq -e 'has("limit") | not' "$FIXTURE_BODY_FILE"
}

@test "start without ANSIBLE_ARGS sends no arguments field" {
  run "$SEMAPHORE_RUN" start --project 2 pve-converge
  [ "$status" -eq 0 ]
  jq -e 'has("arguments") | not' "$FIXTURE_BODY_FILE"
}

@test "start resolves the template by numeric id and the project by id" {
  run "$SEMAPHORE_RUN" start --project 2 13
  [ "$status" -eq 0 ]
  jq -e '.template_id == 13 and .project_id == 2' "$FIXTURE_BODY_FILE"
}

@test "start refuses an unknown template and posts nothing" {
  run "$SEMAPHORE_RUN" start --project 2 no-such-template
  [ "$status" -eq 64 ]
  [[ "$output" == *"no template named no-such-template"* ]]
  [ ! -s "$FIXTURE_BODY_FILE" ]
}

@test "start refuses an unknown project" {
  run "$SEMAPHORE_RUN" start --project no-such-project pve-converge
  [ "$status" -eq 64 ]
  [[ "$output" == *"no project named no-such-project"* ]]
}

# ---- wait -------------------------------------------------------------------

@test "wait exits 0 once the task reaches success, polling in between" {
  export FIXTURE_TASK_STATUSES="waiting,running,success"
  run "$SEMAPHORE_RUN" wait 42 --project homelab-apps
  [ "$status" -eq 0 ]
  [ "$output" = "task 42 success" ]
  [ "$(wc -l < "$FIXTURE_SLEEP_LOG" | tr -d ' ')" -eq 2 ]
}

@test "wait exits 1 for error, stopped and rejected tasks" {
  for final in error stopped rejected; do
    rm -f "$FIXTURE_COUNTER"
    : > "$FIXTURE_API_LOG"
    export FIXTURE_TASK_STATUSES="running,$final"
    run "$SEMAPHORE_RUN" wait 42 --project 1
    [ "$status" -eq 1 ]
    [ "$output" = "task 42 $final" ]
  done
}

@test "wait exits 75 at its deadline while the task still runs" {
  export FIXTURE_TASK_STATUSES="running"
  run "$SEMAPHORE_RUN" wait 42 --project homelab-apps --timeout 0
  [ "$status" -eq 75 ]
  [[ "$output" == *"timed out after 0"* ]]
  [ ! -s "$FIXTURE_SLEEP_LOG" ]
}

@test "wait finds the task in whichever project holds it when --project is absent" {
  export FIXTURE_TASK_PROJECT=2
  run "$SEMAPHORE_RUN" wait 42
  [ "$status" -eq 0 ]
  grep -Fx $'GET\t/api/project/1/tasks/42\tAuthorization\tBearer sem-fixture-token\thttps://sem.fixture/api/project/1/tasks/42' "$FIXTURE_API_LOG"
  grep -Fx $'GET\t/api/project/2/tasks/42\tAuthorization\tBearer sem-fixture-token\thttps://sem.fixture/api/project/2/tasks/42' "$FIXTURE_API_LOG"
}

@test "a task that no project holds exits 64" {
  run "$SEMAPHORE_RUN" wait 99
  [ "$status" -eq 64 ]
  [[ "$output" == *"not in any project"* ]]
}

@test "wait exits 70 when reading the task fails" {
  export FIXTURE_TASK_HTTP=500
  run "$SEMAPHORE_RUN" wait 42 --project 1
  [ "$status" -eq 70 ]
  [[ "$output" == *"HTTP 500"* ]]
}

# ---- log and stop -----------------------------------------------------------

@test "log prints the last N output lines" {
  run "$SEMAPHORE_RUN" log 42 1 --project 1
  [ "$status" -eq 0 ]
  [ "$output" = "gamma" ]
}

@test "log defaults to 40 lines" {
  run "$SEMAPHORE_RUN" log 42 --project 1
  [ "$status" -eq 0 ]
  [ "$output" = $'alpha\nbeta\ngamma' ]
}

@test "stop posts an empty object to the task's stop endpoint" {
  run "$SEMAPHORE_RUN" stop 42 --project 1
  [ "$status" -eq 0 ]
  [ "$output" = "task 42 stop requested" ]
  grep -F $'POST\t/api/project/1/tasks/42/stop\t' "$FIXTURE_API_LOG"
  [ "$(cat "$FIXTURE_BODY_FILE")" = '{}' ]
}

# ---- credentials ------------------------------------------------------------

@test "without BAO_TOKEN one reconcile token is minted, used for the one secret read, then revoked" {
  run "$SEMAPHORE_RUN" list
  [ "$status" -eq 0 ]
  [ "$(grep -c 'approle-token openbao-reconcile' "$FIXTURE_FLOW_LOCK_LOG")" -eq 1 ]
  [ "$(sed -n 1p "$FIXTURE_API_LOG" | cut -f1-4)" = $'GET\t/v1/secret/data/apps/semaphore\tX-Vault-Token\treconcile-token' ]
  [ "$(sed -n 2p "$FIXTURE_API_LOG" | cut -f1-4)" = $'POST\t/v1/auth/token/revoke-self\tX-Vault-Token\treconcile-token' ]
  [ "$(sed -n 3p "$FIXTURE_API_LOG" | cut -f1-4)" = $'GET\t/api/projects\tAuthorization\tBearer sem-fixture-token' ]
}

@test "a BAO_TOKEN in the environment is used as-is, never minted and never revoked" {
  export BAO_TOKEN=given-token
  run "$SEMAPHORE_RUN" list
  [ "$status" -eq 0 ]
  [ ! -s "$FIXTURE_FLOW_LOCK_LOG" ]
  [ "$(sed -n 1p "$FIXTURE_API_LOG" | cut -f1-4)" = $'GET\t/v1/secret/data/apps/semaphore\tX-Vault-Token\tgiven-token' ]
  ! grep -F 'revoke-self' "$FIXTURE_API_LOG"
}

@test "tokens never reach argv" {
  run "$SEMAPHORE_RUN" start --project 2 pve-converge -- --limit web01
  [ "$status" -eq 0 ]
  ! grep -F 'sem-fixture-token' "$FIXTURE_ARGV_LOG"
  ! grep -F 'reconcile-token' "$FIXTURE_ARGV_LOG"
}

@test "a failed mint exits 70 and makes no Semaphore call" {
  export FIXTURE_FLOW_LOCK_FAIL=1
  run "$SEMAPHORE_RUN" list
  [ "$status" -eq 70 ]
  [ ! -s "$FIXTURE_API_LOG" ]
}

@test "a secret without semaphore_api_token exits 70 and still revokes the minted token" {
  export FIXTURE_NO_SEM_FIELD=1
  run "$SEMAPHORE_RUN" list
  [ "$status" -eq 70 ]
  [[ "$output" == *"no semaphore_api_token field"* ]]
  grep -F $'POST\t/v1/auth/token/revoke-self\tX-Vault-Token\treconcile-token' "$FIXTURE_API_LOG"
  ! grep -F 'api/projects' "$FIXTURE_API_LOG"
}

@test "a failed secret read exits 70 and does not print the response" {
  export FIXTURE_SECRET_STATUS=403
  run "$SEMAPHORE_RUN" list
  [ "$status" -eq 70 ]
  [[ "$output" == *"HTTP 403"* ]]
  [[ "$output" != *"denied"* ]]
}

@test "a failed revoke exits 70" {
  export FIXTURE_REVOKE_STATUS=500
  run "$SEMAPHORE_RUN" list
  [ "$status" -eq 70 ]
  [[ "$output" == *"revoking the minted OpenBao token failed (HTTP 500)"* ]]
}
