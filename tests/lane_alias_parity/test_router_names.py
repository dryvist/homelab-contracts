import json
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
FIXTURES = Path(__file__).parent / "fixtures"
SCRIPT = ROOT / ".github/scripts/lane-alias-parity.py"
LANES = ROOT / "ansible/roles/llm_roles/files/lanes.json"
ROUTER_NAMES = FIXTURES / "servable-aliases.json"


def run_checker(names_file: Path, router_names: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [
            sys.executable,
            str(SCRIPT),
            "--lanes",
            str(LANES),
            "--names",
            str(names_file),
            "--router-names",
            str(router_names),
        ],
        check=False,
        capture_output=True,
        text=True,
    )


def test_valid_router_names_pass() -> None:
    result = run_checker(FIXTURES / "router-names-pass.json", ROUTER_NAMES)

    assert result.returncode == 0, result.stdout + result.stderr
    assert "PASS: all 4 router name(s) are allowed" in result.stdout
    assert "non-pending lane and harness alias name(s) are served" in result.stdout


def test_consumer_name_missing_from_router_fails() -> None:
    result = run_checker(FIXTURES / "router-names-fail.json", ROUTER_NAMES)

    assert result.returncode == 1
    assert "not-a-real-alias" in result.stdout
    assert "unknown router names" in result.stdout


def test_missing_router_names_key_fails_closed(tmp_path: Path) -> None:
    missing_contract = tmp_path / "missing-router-names.json"
    missing_contract.write_text(json.dumps({"schema_version": 1}), encoding="utf-8")

    result = run_checker(FIXTURES / "router-names-pass.json", missing_contract)

    assert result.returncode == 2
    assert "missing or invalid router_names object" in result.stderr


def test_unknown_schema_major_fails_closed(tmp_path: Path) -> None:
    contract = json.loads(ROUTER_NAMES.read_text(encoding="utf-8"))
    contract["schema_version"] = 2
    unsupported_contract = tmp_path / "unsupported-router-names.json"
    unsupported_contract.write_text(json.dumps(contract), encoding="utf-8")

    result = run_checker(FIXTURES / "router-names-pass.json", unsupported_contract)

    assert result.returncode == 2
    assert "unsupported schema_version major 2" in result.stderr


def test_empty_router_all_fails_closed(tmp_path: Path) -> None:
    contract = json.loads(ROUTER_NAMES.read_text(encoding="utf-8"))
    contract["router_names"] = {
        field: [] for field in ("aliases", "route_groups", "direct_routes", "roles", "all")
    }
    empty_contract = tmp_path / "empty-router-names.json"
    empty_contract.write_text(json.dumps(contract), encoding="utf-8")

    result = run_checker(FIXTURES / "router-names-pass.json", empty_contract)

    assert result.returncode == 2
    assert "router_names.all must not be empty" in result.stderr


def test_non_pending_lane_absent_from_router_fails(tmp_path: Path) -> None:
    contract = json.loads(ROUTER_NAMES.read_text(encoding="utf-8"))
    contract["router_names"]["route_groups"].remove("review-local")
    contract["router_names"]["all"].remove("review-local")
    incomplete_contract = tmp_path / "incomplete-router-names.json"
    incomplete_contract.write_text(json.dumps(contract), encoding="utf-8")

    result = run_checker(FIXTURES / "router-names-pass.json", incomplete_contract)

    assert result.returncode == 1
    assert "review-local" in result.stdout
    assert "non-pending lane and harness alias names missing" in result.stdout
