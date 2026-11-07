"""Admission facts and complete trial evidence share one field contract."""

import unittest

import test_model_policy as policy


class DossierAdmissionTest(unittest.TestCase):
    def setUp(self):
        self.fixture = policy.PolicyRegressionTest()
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)

    def test_admission_preserves_unfinished_trial_evidence(self):
        text = "\n\n".join(
            f"## {heading}\n\n" + "\n".join(
                f"- {field}: " + (
                    self.fixture.evidence(field) if gate == "admission"
                    else "UNVERIFIED")
                for field, gate in fields.items())
            for heading, fields in policy.DOSSIER_FIELDS.items())
        self.fixture.dossier.write_text(text)
        self.fixture.check()
        with self.assertRaisesRegex(ValueError, "unverified dossier"):
            policy.validate_dossier(text, "example", self.fixture.root)

    def test_optional_converter_revision_is_never_blocking(self):
        for value in (None, "UNVERIFIED", "not published by converter; base_model: example/upstream"):
            with self.subTest(value=value):
                text = self.fixture.complete_dossier.replace(
                    "- Upstream source revision: synthetic regression evidence",
                    "" if value is None else f"- Upstream source revision: {value}")
                self.fixture.dossier.write_text(text)
                self.fixture.check()
                policy.validate_dossier(text, "example", self.fixture.root)

    def test_calibration_free_method_records_not_applicable_and_source(self):
        text = self.fixture.complete_dossier.replace(
            "- Calibration provenance: synthetic regression evidence",
            "- Calibration provenance: not applicable; MLX affine 4-bit, "
            "[pinned config](https://huggingface.co/example/quant/blob/"
            "0123456789012345678901234567890123456789/config.json), "
            "observed 2026-11-06")
        self.fixture.dossier.write_text(text)
        self.fixture.check()
        policy.validate_dossier(text, "example", self.fixture.root)

    def test_selected_artifact_cannot_borrow_other_artifact_evidence(self):
        text = self.fixture.complete_dossier
        sections = policy.dossier_sections(text, "example")
        heading = "2. Artifact evidence"
        artifact = sections[heading]
        for replacement in ("", "- Artifact publisher: UNVERIFIED"):
            with self.subTest(replacement=replacement):
                incomplete = artifact.replace(
                    "- Artifact publisher: synthetic regression evidence", replacement)
                dossier = text.replace(artifact,
                                       f"### example/other\n{artifact}\n"
                                       f"### example/quant\n{incomplete}\n")
                self.fixture.dossier.write_text(dossier)
                with self.assertRaisesRegex(ValueError, "dossier"):
                    self.fixture.check()
                with self.assertRaisesRegex(ValueError, "dossier"):
                    policy.validate_dossier(dossier, "example", self.fixture.root)

    def test_missing_or_duplicate_selected_artifact_fails_closed(self):
        for headings in (("other",), ("quant", "quant")):
            with self.subTest(headings=headings):
                text = self.fixture.complete_dossier
                artifact = policy.dossier_sections(text, "example")["2. Artifact evidence"]
                dossier = text.replace(artifact, "\n".join(
                    f"### example/{name}\n{artifact}" for name in headings))
                self.fixture.dossier.write_text(dossier)
                with self.assertRaisesRegex(ValueError, "artifact evidence"):
                    self.fixture.check()
