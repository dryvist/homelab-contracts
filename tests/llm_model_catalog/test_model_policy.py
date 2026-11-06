"""Offline contract checks for the shared self-hosted model policy."""

import copy
import datetime
import json
from pathlib import Path
import re
import tempfile
import unittest
from unittest import mock


ROOT = Path(__file__).resolve().parents[2]
FILES = Path("ansible/roles/llm_model_catalog/files")


def validate_policy(policy, catalog, role_map, root=ROOT):
    """Require explicit coverage and eligible, documented role assignments."""
    def require(condition, message):
        if not condition:
            raise ValueError(message)

    groups = {}
    for group in ("models", "deny", "exempt_hosted"):
        entries = policy[group]
        groups[group] = {entry["id"]: entry for entry in entries}
        require(len(groups[group]) == len(entries), f"duplicate {group} id")
    models, denied, hosted = (groups[g] for g in groups)
    require(not (models.keys() & denied.keys()), "model is denied")
    require(not (hosted.keys() & (models.keys() | denied.keys())),
            "hosted exemption overlaps self-hosted policy")
    today = datetime.datetime.now(datetime.timezone.utc).date()
    require(0 < policy["max_age_days"] <= 365, "invalid maximum age")
    for model_id, model in models.items():
        require(model["upstream_id"] not in denied, f"denied upstream: {model_id}")
        require(bool(model.get("upstream_created")), f"undated: {model_id}")
        created = datetime.date.fromisoformat(model["upstream_created"])
        require(0 <= (today - created).days <= policy["max_age_days"],
                f"upstream age: {model_id}")
        dossier = model.get("dossier", "")
        require(bool(re.fullmatch(
            r"ansible/roles/llm_model_catalog/files/dossiers/[A-Za-z0-9_-]+\.md",
            dossier)), f"invalid dossier: {model_id}")
        path = root / dossier
        require(path.is_file() and bool(path.read_text().strip()),
                f"missing dossier: {model_id}")
        benchmarks = re.finditer(
            r"^- Benchmark: [^;\n]+; score: -?\d+(?:\.\d+)?; "
            r"date: (\d{4}-\d{2}-\d{2});[ \t]*(?:\n[ \t]+)?"
            r"source: https?://[^\s;]+\s*$",
            path.read_text(), re.MULTILINE)
        evidenced = False
        for benchmark in benchmarks:
            if "UNVERIFIED" in benchmark.group().upper():
                continue
            try:
                measured = datetime.date.fromisoformat(benchmark[1])
            except ValueError:
                continue
            if measured <= today:
                evidenced = True
                break
        require(evidenced, f"missing dated benchmark evidence: {model_id}")

    entries = {}
    for entry in catalog["llm_model_catalog_models"]:
        for name in [entry["name"], *entry.get("aliases", [])]:
            require(name not in entries, f"duplicate catalog name: {name}")
            entries[name] = entry

    def identity(name, seen=()):
        require(name not in seen, f"catalog reference cycle: {name}")
        if name not in entries:
            return name
        entry = entries[name]
        if "catalog_model" in entry:
            target = entry["catalog_model"]
            require(target in entries, f"unknown catalog reference: {target}")
            return identity(target, (*seen, name))
        stage0 = entry.get("stage0", {})
        artifact = stage0.get("serving", {}).get("converted_artifact", {})
        model_id = (entry.get("hf_repo") or artifact.get("repo_id")
                    or stage0.get("source_checkpoint", {}).get("repo_id")
                    or entry["name"])
        local = ("hf_repo" in entry or bool(stage0)
                 or "mlx" in entry.get("profiles", {})
                 or entry["name"].startswith(("mlx-community/", "IFM/")))
        require(not (local and (name in hosted or model_id in hosted)),
                f"self-hosted exemption: {name}")
        return model_id

    def coverage(model_id):
        require(model_id in models or model_id in denied or model_id in hosted,
                f"missing policy entry: {model_id}")

    for name in entries:
        coverage(identity(name))
    for model in role_map["models"].values():
        coverage(identity(model["id"]))

    assignments = list(role_map["roles"].values())
    for host in role_map["hosts"].values():
        assignments.extend(host.get("roles", {}).values())
    for assignment in assignments:
        key = assignment["model"]
        if key is None:
            continue
        require(key in role_map["models"], f"unknown role model: {key}")
        name = role_map["models"][key]["id"]
        model_id = identity(name)
        require(name not in denied and model_id not in denied,
                f"denied role model: {model_id}")
        require(model_id in hosted or model_id in models,
                f"ineligible role model: {model_id}")


class CommittedPolicyTest(unittest.TestCase):
    def test_committed_data(self):
        policy = json.loads((ROOT / FILES / "model-policy.json").read_text())
        catalog = json.loads((ROOT / FILES / "model-catalog.json").read_text())
        roles = json.loads((ROOT / "ansible/roles/llm_roles/files/model-roles.json")
                           .read_text())
        validate_policy(policy, catalog, roles)


class PolicyRegressionTest(unittest.TestCase):
    def setUp(self):
        self.instant = datetime.datetime(2026, 11, 6, tzinfo=datetime.timezone.utc)
        clock = mock.patch(f"{__name__}.datetime.datetime")
        self.clock = clock.start()
        self.addCleanup(clock.stop)
        self.clock.now.return_value = self.instant
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.dossier = self.root / FILES / "dossiers/example-upstream.md"
        self.dossier.parent.mkdir(parents=True)
        self.benchmark = (
            "- Benchmark: Example v1; score: 61.36; date: 2026-11-06; "
            "source: https://example.test/results")
        self.dossier.write_text(self.benchmark + "\n")
        self.policy = {
            "version": 1, "as_of": "2026-11-06", "max_age_days": 365,
            "models": [{
                "id": "example/quant", "upstream_id": "example/upstream",
                "upstream_created": "2025-11-06",
                "dossier": str(FILES / "dossiers/example-upstream.md"),
            }],
            "deny": [{"id": "example/old", "reason": "undated"}],
            "exempt_hosted": [{"id": "provider/auto", "reason": "hosted provider"}],
        }
        self.catalog = {"llm_model_catalog_models": [
            {"name": "local", "hf_repo": "example/quant", "aliases": ["alias"]},
            {"name": "local-route", "catalog_model": "local"},
            {"name": "example/old"}, {"name": "provider/auto"},
        ]}
        self.roles = {"models": {"active": {"id": "alias"}},
                      "roles": {"default": {"model": "active"},
                                "unbound": {"model": None}}, "hosts": {}}

    def check(self):
        validate_policy(self.policy, self.catalog, self.roles, root=self.root)

    def test_boundary_alias_deny_inventory_and_hosted_selector(self):
        self.check()
        self.clock.now.assert_called_once_with(datetime.timezone.utc)

    def test_policy_snapshot_does_not_freeze_model_age(self):
        self.clock.now.return_value = self.instant + datetime.timedelta(days=1)
        for as_of in ("2026-11-06", "2026-11-07", "2027-11-06"):
            with self.subTest(as_of=as_of):
                self.policy["as_of"] = as_of
                with self.assertRaisesRegex(ValueError, "upstream age"):
                    self.check()

    def test_reject_missing_catalog_or_role_model(self):
        for target in ("catalog", "role"):
            with self.subTest(target=target):
                catalog, roles = copy.deepcopy(self.catalog), copy.deepcopy(self.roles)
                if target == "catalog":
                    catalog["llm_model_catalog_models"].append({"name": "example/new"})
                else:
                    roles["models"]["unassigned"] = {"id": "example/new"}
                with self.assertRaisesRegex(ValueError, "missing policy entry"):
                    validate_policy(self.policy, catalog, roles, root=self.root)

    def test_reject_missing_or_invalid_upstream_date(self):
        for value in (None, "", "2026-02-30", "2026-11-07", "2025-11-05"):
            with self.subTest(value=value), self.assertRaises(ValueError):
                self.policy["models"][0]["upstream_created"] = value
                self.check()
        del self.policy["models"][0]["upstream_created"]
        with self.assertRaisesRegex(ValueError, "undated"):
            self.check()

    def test_quantization_does_not_renew_age(self):
        self.catalog["llm_model_catalog_models"][0]["createdAt"] = "2026-11-06"
        self.policy["models"][0]["upstream_created"] = "2025-11-05"
        with self.assertRaisesRegex(ValueError, "upstream age"):
            self.check()

    def test_reject_denied_role_globally_and_in_host_override(self):
        for scope in ("global", "host"):
            with self.subTest(scope=scope):
                roles = copy.deepcopy(self.roles)
                roles["models"]["old"] = {"id": "example/old"}
                if scope == "global":
                    roles["roles"]["default"]["model"] = "old"
                else:
                    roles["hosts"]["server"] = {"roles": {"fast": {"model": "old"}}}
                with self.assertRaisesRegex(ValueError, "denied role model"):
                    validate_policy(self.policy, self.catalog, roles, root=self.root)

    def test_reject_denied_alias_and_upstream(self):
        for name in ("alias", "example/quant", "example/upstream"):
            with self.subTest(name=name):
                policy = copy.deepcopy(self.policy)
                policy["deny"].append({"id": name, "reason": "denied"})
                with self.assertRaisesRegex(ValueError, "denied"):
                    validate_policy(policy, self.catalog, self.roles, root=self.root)

    def test_reject_absent_empty_unsafe_or_missing_dossier(self):
        for value in (None, "", "../outside.md", str(FILES / "dossiers/absent.md")):
            with self.subTest(value=value), self.assertRaises(ValueError):
                if value is None:
                    self.policy["models"][0].pop("dossier", None)
                else:
                    self.policy["models"][0]["dossier"] = value
                self.check()

    def test_reject_dossier_without_dated_benchmark_evidence(self):
        for text in (
            "# Model dossiers\n\n- [Example](https://example.test/results)",
            "## Evaluation\n\n- Expected quality: UNVERIFIED",
            self.benchmark.replace("Example v1", "UNVERIFIED"),
            self.benchmark.replace("61.36", "UNVERIFIED"),
            self.benchmark.replace("2026-11-06", "UNVERIFIED"),
            self.benchmark.replace("2026-11-06", "2026-02-30"),
            self.benchmark.replace("2026-11-06", "2026-11-07"),
            self.benchmark.replace("https://example.test/results", "UNVERIFIED"),
            self.benchmark.replace("https://example.test/results", "results.md"),
            self.benchmark.replace("; date: 2026-11-06", ""),
            self.benchmark.replace("; source: https://example.test/results", ""),
            self.benchmark.replace("; score: 61.36", ""),
            self.benchmark.replace("; date:", "\n- date:"),
        ):
            with self.subTest(text=text):
                self.dossier.write_text(text)
                with self.assertRaisesRegex(ValueError, "missing dated benchmark"):
                    self.check()

    def test_index_is_not_benchmark_evidence(self):
        index = self.dossier.with_name("index.md")
        index.write_text((ROOT / FILES / "dossiers/index.md").read_text())
        self.policy["models"][0]["dossier"] = str(FILES / "dossiers/index.md")
        with self.assertRaisesRegex(ValueError, "missing dated benchmark"):
            self.check()

    def test_accept_wrapped_benchmark_source(self):
        self.dossier.write_text(self.benchmark.replace("; source:", ";\n  source:"))
        self.check()

    def test_wrapped_source_requires_complete_evidence(self):
        wrapped = self.benchmark.replace("; source:", ";\n  source:")
        for text in (
            wrapped.replace("61.36", "UNVERIFIED"),
            wrapped.replace("2026-11-06", "UNVERIFIED"),
            wrapped.replace("https://example.test/results", "UNVERIFIED"),
            wrapped.replace("\n  source:", "\n- source:"),
            wrapped.replace("\n  source:", "\n\n  source:"),
        ):
            with self.subTest(text=text):
                self.dossier.write_text(text)
                with self.assertRaisesRegex(ValueError, "missing dated benchmark"):
                    self.check()

    def test_verified_benchmark_can_coexist_with_unverified_gaps(self):
        self.dossier.write_text(
            "## 4. Evaluation and comparison\n\n"
            "- Benchmark: Other; score: UNVERIFIED; date: 2026-11-06; "
            "source: https://example.test/other\n"
            + self.benchmark + "\n- Local latency: UNVERIFIED\n")
        self.check()

    def test_reject_duplicate_ids_and_overlapping_exemptions(self):
        for group in ("models", "deny", "exempt_hosted"):
            with self.subTest(group=group):
                policy = copy.deepcopy(self.policy)
                policy[group].append(copy.deepcopy(policy[group][0]))
                with self.assertRaisesRegex(ValueError, "duplicate"):
                    validate_policy(policy, self.catalog, self.roles, root=self.root)
        self.policy["exempt_hosted"].append({"id": "example/quant"})
        with self.assertRaisesRegex(ValueError, "overlaps"):
            self.check()

    def test_reject_exempting_self_hosted_artifacts(self):
        self.policy["models"] = []
        self.policy["exempt_hosted"].append({"id": "example/quant"})
        with self.assertRaisesRegex(ValueError, "self-hosted exemption"):
            self.check()

    def test_stage0_uses_converted_artifact_identity(self):
        self.catalog["llm_model_catalog_models"][0] = {
            "name": "local", "aliases": ["alias"], "stage0": {
                "source_checkpoint": {"repo_id": "example/upstream"},
                "serving": {"converted_artifact": {"repo_id": "example/quant"}},
            },
        }
        self.check()
        self.catalog["llm_model_catalog_models"][0]["stage0"]["serving"] = {}
        with self.assertRaisesRegex(ValueError, "missing policy entry"):
            self.check()

    def test_reject_unknown_or_cyclic_catalog_references(self):
        for target in ("absent", "local-route"):
            with self.subTest(target=target), self.assertRaisesRegex(
                    ValueError, "catalog reference"):
                self.catalog["llm_model_catalog_models"][1]["catalog_model"] = target
                self.check()

    def test_reject_unknown_role_reference(self):
        self.roles["roles"]["default"]["model"] = "absent"
        with self.assertRaisesRegex(ValueError, "unknown role model"):
            self.check()
