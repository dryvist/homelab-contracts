"""Every complete dossier uses the shared evidence gate, including unassigned ones."""

import re
import unittest

import test_model_policy as policy


def validate_dossier_statuses(root=policy.ROOT):
    """Check real dossiers; shared defaults are evidence fragments, not models."""
    for path in sorted((root / policy.FILES / "dossiers").rglob("*.md")):
        if (path.name in {"index.md", "log.md"}
                or "_shared" in path.relative_to(root / policy.FILES / "dossiers").parts):
            continue
        text = path.read_text()
        frontmatter = re.match(r"\A---\n(.*?)\n---(?:\n|\Z)", text, re.DOTALL)
        statuses = re.findall(r"^status:[ \t]*(.*)$", frontmatter[1], re.MULTILINE) \
            if frontmatter else []
        if len(statuses) != 1 or not re.fullmatch(
                r"(?:started|complete|'started'|'complete'|\"started\"|\"complete\")"
                r"[ \t]*(?:#.*)?", statuses[0]):
            raise ValueError(f"invalid dossier status: {path.name}")
        status = statuses[0].split("#", 1)[0].strip().strip("'\"")
        if status == "complete":
            policy.validate_dossier(text, path.stem, root)


class CommittedDossierStatusTest(unittest.TestCase):
    def test_committed_dossier_statuses(self):
        validate_dossier_statuses()


class DossierStatusTest(unittest.TestCase):
    def setUp(self):
        self.fixture = policy.PolicyRegressionTest()
        self.fixture.setUp()
        self.addCleanup(self.fixture.doCleanups)

    def write(self, status, body=None):
        self.fixture.dossier.write_text(
            f"---\nstatus: {status}\n---\n" + (
                self.fixture.complete_dossier if body is None else body))

    def check(self):
        validate_dossier_statuses(self.fixture.root)

    def test_complete_dossier_passes(self):
        for status in ("complete", "'complete'", '"complete" # reviewed'):
            with self.subTest(status=status):
                self.write(status)
                self.check()

    def test_complete_unverified_required_field_fails(self):
        for fields in policy.DOSSIER_FIELDS.values():
            for field in policy.required_fields(fields):
                with self.subTest(field=field):
                    self.write("complete", self.fixture.complete_dossier.replace(
                        f"- {field}: {self.fixture.evidence(field)}",
                        f"- {field}: UNVERIFIED"))
                    with self.assertRaisesRegex(ValueError, "unverified dossier|benchmark evidence"):
                        self.check()

    def test_complete_missing_section_fails(self):
        for heading in policy.DOSSIER_FIELDS:
            with self.subTest(heading=heading):
                self.write("complete", self.fixture.complete_dossier.replace(
                    f"## {heading}", "## Other section"))
                with self.assertRaisesRegex(ValueError, "missing dossier section"):
                    self.check()

    def test_started_can_have_incomplete_evidence(self):
        self.write("started", "- Release date: UNVERIFIED")
        self.check()

    def test_unknown_or_missing_status_fails(self):
        for status in ("ready", "", "null", "[complete]", "Complete",
                       "started\nstatus: complete"):
            with self.subTest(status=status):
                self.write(status)
                with self.assertRaisesRegex(ValueError, "invalid dossier status"):
                    self.check()
        self.fixture.dossier.write_text(self.fixture.complete_dossier)
        with self.assertRaisesRegex(ValueError, "invalid dossier status"):
            self.check()

    def test_shared_fragments_are_not_model_dossiers(self):
        self.write("started")
        shared = self.fixture.dossier.parent / "_shared/runtime-and-evaluation.md"
        shared.parent.mkdir()
        shared.write_text("## Fragment\n\nUNVERIFIED")
        self.check()

    def test_bundle_navigation_and_history_are_not_model_dossiers(self):
        self.write("started")
        for name in ("index.md", "log.md"):
            with self.subTest(name=name):
                (self.fixture.dossier.parent / name).write_text("# Bundle metadata\n")
                self.check()
