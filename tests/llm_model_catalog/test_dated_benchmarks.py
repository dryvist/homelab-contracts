"""Admission and complete dossiers require model-specific dated benchmark rows."""

import unittest

import test_model_policy as policy
from test_dossier_status import validate_dossier_statuses


class DatedBenchmarkTest(unittest.TestCase):
    def setUp(self):
        self.fixture = policy.PolicyRegressionTest()
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)
        self.row = f"- Benchmark: {self.fixture.evidence('Benchmark')}"

    def write(self, row):
        self.fixture.dossier.write_text(
            self.fixture.complete_dossier.replace(self.row, row))

    def test_numeric_scores_and_source_continuations_pass(self):
        for score in ("0", "-1.25", ".5", "1e-3"):
            for separator in (" ", "\n  "):
                with self.subTest(score=score, separator=separator):
                    self.write(self.row.replace("score: 1;", f"score: {score};")
                               .replace(" source:", separator + "source:"))
                    self.fixture.check()
                    policy.validate_dossier(self.fixture.dossier.read_text(),
                                            "example", self.fixture.root)

    def test_incomplete_or_invalid_rows_fail_every_selection(self):
        invalid_rows = [
            "", self.row.replace("Fixture v1", ""),
            self.row.replace("score: 1;", ""),
            self.row.replace("score: 1;", "score: UNVERIFIED;"),
            self.row.replace("score: 1;", "score: NaN;"),
            self.row.replace("date: 2026-11-06;", ""),
            self.row.replace("2026-11-06", "2026-02-30"),
            self.row.replace("2026-11-06", "2026-11-07"),
            self.row.replace("2026-11-06", "20261106"),
            self.row.replace("source: https://example.test/benchmark", ""),
            self.row.replace("https://example.test/benchmark", "UNVERIFIED"),
            self.row.replace("https://example.test/benchmark", "benchmark"),
            self.row.replace("https://example.test/benchmark", "https:///benchmark"),
        ]
        for selection in ("global", "override", "resident", "swap"):
            self.fixture.select_model(selection)
            for row in invalid_rows:
                with self.subTest(selection=selection, row=row):
                    self.write(row)
                    with self.assertRaisesRegex(ValueError, "benchmark evidence"):
                        self.fixture.check()

    def test_complete_status_uses_the_same_benchmark_gate(self):
        for row in (self.row, self.row.replace("date: 2026-11-06;", "")):
            self.write(row)
            text = self.fixture.dossier.read_text()
            self.fixture.dossier.write_text("---\nstatus: complete\n---\n" + text)
            if row == self.row:
                validate_dossier_statuses(self.fixture.root)
            else:
                with self.assertRaisesRegex(ValueError, "benchmark evidence"):
                    validate_dossier_statuses(self.fixture.root)

    def test_markdown_autolink_source_passes(self):
        self.write(self.row.replace("https://example.test/benchmark",
                                    "<https://example.test/benchmark>"))
        self.fixture.check()

    def test_unassigned_policy_model_still_needs_benchmarks(self):
        self.fixture.roles["roles"] = {}
        self.write("")
        with self.assertRaisesRegex(ValueError, "benchmark evidence"):
            self.fixture.check()

    def test_one_valid_row_suffices_beside_incomplete_rows(self):
        self.write("- Benchmark: pending; score: UNVERIFIED\n" + self.row)
        self.fixture.check()

    def test_shared_defaults_cannot_supply_model_specific_scores(self):
        shared = self.fixture.dossier.parent / "_shared/runtime-and-evaluation.md"
        shared.parent.mkdir()
        shared.write_text("## 4. Evaluation and comparison\n" + self.row)
        self.write("[Shared evidence](_shared/runtime-and-evaluation.md)")
        with self.assertRaisesRegex(ValueError, "benchmark evidence"):
            policy.validate_dossier(self.fixture.dossier.read_text(), "example",
                                    self.fixture.root, admission_only=True)
