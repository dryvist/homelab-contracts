"""Shared dossier defaults retain the complete-evidence selection gate."""

import unittest

import test_model_policy as policy


class SharedDossierTest(unittest.TestCase):
    def setUp(self):
        self.fixture = policy.PolicyRegressionTest()
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)
        self.shared = (self.fixture.dossier.parent
                       / "_shared/runtime-and-evaluation.md")
        self.shared.parent.mkdir()
        sections = policy.dossier_sections(self.fixture.complete_dossier, "example")
        self.shared_headings = list(policy.DOSSIER_FIELDS)[2:]
        self.shared_text = "\n\n".join(
            f"## {heading}\n{sections[heading]}"
            for heading in self.shared_headings)
        self.shared.write_text(self.shared_text)
        reference = "[Shared evidence](_shared/runtime-and-evaluation.md)"
        self.local_text = "\n\n".join(
            f"## {heading}\n" + (
                reference if heading in self.shared_headings else sections[heading])
            for heading in policy.DOSSIER_FIELDS)
        self.fixture.dossier.write_text(self.local_text)

    def test_complete_shared_evidence(self):
        self.fixture.check()

    def test_reference_is_required_in_each_inheriting_section(self):
        self.fixture.dossier.write_text(self.local_text.replace(
            "[Shared evidence](_shared/runtime-and-evaluation.md)", "", 1))
        with self.assertRaisesRegex(ValueError, "missing dossier field"):
            self.fixture.check()

    def test_missing_shared_file_fails_closed(self):
        self.shared.rename(self.shared.with_name("absent.md"))
        with self.assertRaises(FileNotFoundError):
            self.fixture.check()

    def test_missing_and_unverified_inherited_fields_fail_closed(self):
        for heading in self.shared_headings:
            for field in policy.DOSSIER_FIELDS[heading]:
                for replacement, message in (
                        (f"- {field}:", "missing dossier field"),
                        (f"- {field}:\n  UNVERIFIED", "unverified dossier evidence")):
                    with self.subTest(field=field, replacement=replacement):
                        self.shared.write_text(self.shared_text.replace(
                            f"- {field}: synthetic regression evidence", replacement))
                        with self.assertRaisesRegex(ValueError, message):
                            self.fixture.check()

    def test_local_evidence_overrides_only_its_shared_field(self):
        heading = self.shared_headings[0]
        field = policy.DOSSIER_FIELDS[heading][0]
        self.shared.write_text(self.shared_text.replace(
            f"- {field}: synthetic regression evidence", f"- {field}: UNVERIFIED"))
        self.fixture.dossier.write_text(self.local_text.replace(
            f"## {heading}\n", f"## {heading}\n- {field}: local evidence\n"))
        self.fixture.check()
        self.fixture.dossier.write_text(self.local_text)
        with self.assertRaisesRegex(ValueError, "unverified dossier evidence"):
            self.fixture.check()

    def test_local_unverified_evidence_is_not_hidden_by_shared_defaults(self):
        self.fixture.dossier.write_text(self.local_text + "\n- Note: UNVERIFIED\n")
        with self.assertRaisesRegex(ValueError, "unverified dossier evidence"):
            self.fixture.check()
