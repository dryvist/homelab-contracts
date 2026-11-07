"""Selected artifacts must have evidence for the catalog's pinned revision."""

import copy
import unittest

import test_model_policy as policy


class ArtifactRevisionTest(unittest.TestCase):
    def setUp(self):
        self.fixture = policy.PolicyRegressionTest()
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)
        self.revision = "0123456789012345678901234567890123456789"
        self.text = self.fixture.complete_dossier.replace(
            "- Immutable artifact revision: synthetic regression evidence",
            f"- Immutable artifact revision: `{self.revision}` (`sha`).")
        self.fixture.dossier.write_text(self.text)

    def catalog_entries(self):
        entry = self.fixture.catalog["llm_model_catalog_models"][0]
        yield dict(entry, hf_revision=self.revision)
        for converted in (False, True):
            source = {"repo_id": "example/quant", "revision": self.revision}
            stage0 = {"source_checkpoint": source}
            if converted:
                stage0 = {
                    "source_checkpoint": {"repo_id": "example/upstream",
                                          "revision": "a" * 40},
                    "serving": {"converted_artifact": source},
                }
            yield {"name": "local", "aliases": ["alias"], "stage0": stage0}

    def test_catalog_pins_match_for_aliases_routes_and_host_selections(self):
        for entry in self.catalog_entries():
            self.fixture.catalog["llm_model_catalog_models"][0] = entry
            for name in ("local", "alias", "local-route", "example/quant"):
                self.fixture.roles["models"]["active"]["id"] = name
                for selection in ("global", "override", "resident", "swap"):
                    self.fixture.select_model(selection)
                    with self.subTest(entry=entry, name=name, selection=selection):
                        self.fixture.dossier.write_text(self.text)
                        self.fixture.check()
                        self.fixture.dossier.write_text(
                            self.text.replace(self.revision, "b" * 40))
                        with self.assertRaisesRegex(ValueError, "artifact revision mismatch"):
                            self.fixture.check()

    def test_other_artifact_revision_cannot_satisfy_catalog_pin(self):
        self.fixture.catalog["llm_model_catalog_models"][0]["hf_revision"] = self.revision
        artifact = policy.dossier_sections(self.text, "example")["2. Artifact evidence"]
        self.fixture.dossier.write_text(self.text.replace(
            artifact, f"### example/other\n{artifact}\n### example/quant\n"
            + artifact.replace(self.revision, "b" * 40)))
        with self.assertRaisesRegex(ValueError, "artifact revision mismatch"):
            self.fixture.check()

    def test_repository_reference_rejects_ambiguous_catalog_selections(self):
        entries = self.fixture.catalog["llm_model_catalog_models"]
        entries.append(dict(entries[0], name="other", aliases=[],
                            hf_revision="b" * 40))
        self.fixture.roles["models"]["active"]["id"] = "example/quant"
        with self.assertRaisesRegex(ValueError, "ambiguous catalog repository"):
            self.fixture.check()

    def test_each_catalog_selection_keeps_its_own_pin(self):
        entries = self.fixture.catalog["llm_model_catalog_models"]
        entries[0]["hf_revision"] = self.revision
        other = dict(copy.deepcopy(entries[0]), name="other", aliases=[],
                     hf_revision="b" * 40)
        entries.append(other)
        self.fixture.check()
        self.fixture.roles["models"]["active"]["id"] = "other"
        with self.assertRaisesRegex(ValueError, "artifact revision mismatch"):
            self.fixture.check()
