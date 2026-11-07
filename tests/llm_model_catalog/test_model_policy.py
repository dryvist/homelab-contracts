"""Offline contract checks for the shared self-hosted model policy."""

import copy
import datetime
import json
from pathlib import Path
import re
import tempfile
import unittest
from unittest import mock


from dossier_evidence import (
    DOSSIER_FIELDS, FILES, ROOT, dossier_sections, required_fields,
    validate_benchmarks, validate_dossier,
)


def validate_policy(policy, catalog, role_map, root=ROOT, *, today=None):
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
    as_of = datetime.date.fromisoformat(policy["as_of"])
    if today is None:
        today = datetime.datetime.now(datetime.timezone.utc).date()
    require(0 <= (today - as_of).days <= 30, "stale or future policy as_of")
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
        validate_benchmarks(dossier_sections(path.read_text(), model_id).get(
            "4. Evaluation and comparison", ""), model_id, today=today)

    entries = {}
    for entry in catalog["llm_model_catalog_models"]:
        for name in [entry["name"], *entry.get("aliases", [])]:
            require(name not in entries, f"duplicate catalog name: {name}")
            entries[name] = entry

    def repository_id(entry):
        stage0 = entry.get("stage0", {})
        artifact = stage0.get("serving", {}).get("converted_artifact", {})
        return (entry.get("hf_repo") or artifact.get("repo_id")
                or stage0.get("source_checkpoint", {}).get("repo_id")
                or entry["name"])

    def catalog_entry(name, seen=()):
        require(name not in seen, f"catalog reference cycle: {name}")
        if name not in entries:
            matches = [entry for entry in catalog["llm_model_catalog_models"]
                       if repository_id(entry) == name]
            require(len(matches) <= 1, f"ambiguous catalog repository: {name}")
            return matches[0] if matches else {}
        entry = entries[name]
        if "catalog_model" in entry:
            target = entry["catalog_model"]
            require(target in entries, f"unknown catalog reference: {target}")
            return catalog_entry(target, (*seen, name))
        return entry

    def identity(name):
        entry = catalog_entry(name)
        if not entry:
            return name
        stage0 = entry.get("stage0", {})
        model_id = repository_id(entry)
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
        for selection in ("resident", "swap"):
            assignments.extend({"model": key} for key in host.get(selection, []))
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
        if model_id in models:
            entry = catalog_entry(name)
            stage0 = entry.get("stage0", {})
            artifact = (stage0.get("serving", {}).get("converted_artifact")
                        or stage0.get("source_checkpoint", {}))
            revision = (entry.get("hf_revision") if entry.get("hf_repo")
                        else artifact.get("revision"))
            validate_dossier((root / models[model_id]["dossier"]).read_text(),
                             model_id, root, admission_only=True,
                             expected_revision=revision, today=today)


class CommittedPolicyTest(unittest.TestCase):
    def test_glm47_inherits_upstream_age_and_expires_after_day_365(self):
        policy = json.loads((ROOT / FILES / "model-policy.json").read_text())
        model = next(entry for entry in policy["models"]
                     if entry["id"] == "mlx-community/GLM-4.7-REAP-50-mxfp4")
        self.assertEqual(model["upstream_id"], "zai-org/GLM-4.7")
        self.assertEqual(model["upstream_created"], "2025-12-22")
        policy["models"] = [model]
        catalog = {"llm_model_catalog_models": []}
        roles = {"models": {}, "roles": {}, "hosts": {}}
        for day in (datetime.date(2026, 11, 7), datetime.date(2026, 12, 22)):
            with self.subTest(day=day):
                policy["as_of"] = day.isoformat()
                validate_policy(policy, catalog, roles, today=day)
        policy["as_of"] = "2026-12-23"
        with self.assertRaisesRegex(ValueError, "upstream age"):
            validate_policy(policy, catalog, roles,
                            today=datetime.date(2026, 12, 23))

    def test_committed_data(self):
        policy = json.loads((ROOT / FILES / "model-policy.json").read_text())
        catalog = json.loads((ROOT / FILES / "model-catalog.json").read_text())
        roles = json.loads((ROOT / "ansible/roles/llm_roles/files/model-roles.json")
                           .read_text())
        validate_policy(policy, catalog, roles)


class PolicyRegressionTest(unittest.TestCase):
    def setUp(self):
        self.today = datetime.date(2026, 11, 6)
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.dossier = self.root / FILES / "dossiers/example-upstream.md"
        self.dossier.parent.mkdir(parents=True)
        self.complete_dossier = "\n\n".join(
            f"## {heading}\n\n" + "\n".join(
                f"- {field}: {self.evidence(field)}" for field in fields)
            for heading, fields in DOSSIER_FIELDS.items())
        self.dossier.write_text(self.complete_dossier)
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
        validate_policy(self.policy, self.catalog, self.roles,
                        root=self.root, today=self.today)

    @staticmethod
    def evidence(field):
        if field == "Benchmark":
            return ("Fixture v1; score: 1; date: 2026-11-06; "
                    "source: https://example.test/benchmark")
        return "synthetic regression evidence"

    def select_model(self, selection):
        self.roles["roles"] = {}
        self.roles["hosts"] = {"server": {}}
        assignment = {"default": {"model": "active"}}
        if selection == "global":
            self.roles["roles"] = assignment
        elif selection == "override":
            self.roles["hosts"]["server"]["roles"] = assignment
        else:
            self.roles["hosts"]["server"][selection] = ["active"]

    def test_default_clock_uses_today_in_utc(self):
        instant = datetime.datetime(2026, 11, 7, tzinfo=datetime.timezone.utc)
        with mock.patch(f"{__name__}.datetime.datetime") as clock:
            clock.now.return_value = instant
            with self.assertRaisesRegex(ValueError, "upstream age"):
                validate_policy(self.policy, self.catalog, self.roles, root=self.root)
            clock.now.assert_called_once_with(datetime.timezone.utc)

    def test_policy_freshness_boundary(self):
        self.policy["as_of"] = (self.today - datetime.timedelta(days=30)).isoformat()
        self.check()
        for age in (31, -1):
            with self.subTest(age=age), self.assertRaisesRegex(
                    ValueError, "stale or future policy as_of"):
                self.policy["as_of"] = (
                    self.today - datetime.timedelta(days=age)).isoformat()
                self.check()

    def test_policy_snapshot_does_not_freeze_model_age(self):
        self.today += datetime.timedelta(days=1)
        with self.assertRaisesRegex(ValueError, "upstream age"):
            self.check()

    def test_boundary_alias_deny_inventory_and_hosted_selector(self):
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
                    validate_policy(self.policy, catalog, roles,
                                    root=self.root, today=self.today)

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
                    validate_policy(self.policy, self.catalog, roles,
                                    root=self.root, today=self.today)

    def test_reject_denied_alias_and_upstream(self):
        for name in ("alias", "example/quant", "example/upstream"):
            with self.subTest(name=name):
                policy = copy.deepcopy(self.policy)
                policy["deny"].append({"id": name, "reason": "denied"})
                with self.assertRaisesRegex(ValueError, "denied"):
                    validate_policy(policy, self.catalog, self.roles,
                                    root=self.root, today=self.today)

    def test_host_resident_and_swap_use_role_eligibility(self):
        for selection in ("resident", "swap"):
            with self.subTest(selection=selection):
                self.roles["hosts"] = {"server": {selection: ["active"]}}
                self.check()
                for key, message in (("old", "denied role model"),
                                     ("absent", "unknown role model")):
                    self.roles["models"]["old"] = {"id": "example/old"}
                    self.roles["hosts"]["server"][selection] = [key]
                    with self.assertRaisesRegex(ValueError, message):
                        self.check()

    def test_reject_absent_empty_unsafe_or_missing_dossier(self):
        for value in (None, "", "../outside.md", str(FILES / "dossiers/absent.md")):
            with self.subTest(value=value), self.assertRaises(ValueError):
                if value is None:
                    self.policy["models"][0].pop("dossier", None)
                else:
                    self.policy["models"][0]["dossier"] = value
                self.check()

    def test_reject_missing_dossier_sections_and_fields(self):
        for heading, fields in DOSSIER_FIELDS.items():
            with self.subTest(heading=heading):
                self.dossier.write_text(self.complete_dossier.replace(
                    f"## {heading}", "## Unrelated section"))
                with self.assertRaisesRegex(ValueError, "missing dossier section|benchmark evidence"):
                    self.check()
            for field in required_fields(fields, admission_only=True):
                with self.subTest(field=field):
                    self.dossier.write_text(self.complete_dossier.replace(
                        f"- {field}: {self.evidence(field)}", f"- {field}:"))
                    with self.assertRaisesRegex(ValueError, "missing dossier field|benchmark evidence"):
                        self.check()

    def test_reject_unverified_evidence_for_every_selection(self):
        for selection in ("global", "override", "resident", "swap"):
            self.select_model(selection)
            for fields in DOSSIER_FIELDS.values():
                for field in required_fields(fields, admission_only=True):
                    with self.subTest(selection=selection, field=field):
                        self.dossier.write_text(self.complete_dossier.replace(
                            f"- {field}: {self.evidence(field)}",
                            f"- {field}:\n  UNVERIFIED"))
                        with self.assertRaisesRegex(ValueError, "unverified dossier|benchmark evidence"):
                            self.check()

    def test_unassigned_dossier_can_remain_in_progress(self):
        self.roles["roles"] = {}
        sections = dossier_sections(self.complete_dossier, "example")
        self.dossier.write_text("## 1. Upstream evidence\n\n- Release date: UNVERIFIED\n"
                                "## 4. Evaluation and comparison\n"
                                + sections["4. Evaluation and comparison"])
        self.check()

    def test_reject_duplicate_ids_and_overlapping_exemptions(self):
        for group in ("models", "deny", "exempt_hosted"):
            with self.subTest(group=group):
                policy = copy.deepcopy(self.policy)
                policy[group].append(copy.deepcopy(policy[group][0]))
                with self.assertRaisesRegex(ValueError, "duplicate"):
                    validate_policy(policy, self.catalog, self.roles,
                                    root=self.root, today=self.today)
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
