"""Shared admission and complete-dossier evidence rules."""

import datetime
import json
from pathlib import Path
import re
from urllib.parse import urlsplit


ROOT = Path(__file__).resolve().parents[2]
FILES = Path("ansible/roles/llm_model_catalog/files")
DOSSIER_FIELDS = json.loads(Path(__file__).with_name("dossier-fields.json").read_text())


def required_fields(fields, *, admission_only=False):
    """Keep admission and complete-evidence requirements in one contract."""
    return [field for field, gate in fields.items()
            if gate == "admission" or (gate == "complete" and not admission_only)]


def dossier_sections(text, model_id):
    """Read dossier sections, rejecting ambiguous duplicate headings."""
    sections = {}
    heading = None
    for line in text.splitlines():
        if line.startswith("## "):
            heading = line[3:].strip()
            if heading in sections:
                raise ValueError(f"duplicate dossier section: {model_id}: {heading}")
            sections[heading] = []
        elif heading is not None:
            sections[heading].append(line)
    return {heading: "\n".join(lines) for heading, lines in sections.items()}


def validate_benchmarks(body, model_id, *, today=None):
    """Require one model-specific numeric result, dated and linked to its source."""
    if today is None:
        today = datetime.datetime.now(datetime.timezone.utc).date()
    entries = re.findall(r"^- Benchmark:([^\n]*(?:\n[ \t]+\S[^\n]*)*)",
                         body, re.MULTILINE)
    for entry in entries:
        if re.search(r"\bUNVERIFIED\b", entry, re.IGNORECASE):
            continue
        match = re.fullmatch(
            r"\s*([^;]+);\s*score:\s*[+-]?(?:\d+(?:\.\d*)?|\.\d+)"
            r"(?:[eE][+-]?\d+)?;\s*date:\s*(\d{4}-\d{2}-\d{2});"
            r"\s*source:\s*<?(https?://[^\s;<>]+)>?\s*", entry)
        if match is None or not match[1].strip():
            continue
        try:
            date = datetime.date.fromisoformat(match[2])
            source = urlsplit(match[3])
            if date <= today and source.hostname:
                return
        except ValueError:
            continue
    raise ValueError(f"missing or invalid dated benchmark evidence: {model_id}")


def validate_dossier(text, model_id, root=ROOT, *, admission_only=False,
                     expected_revision=None, today=None):
    """Validate local evidence and explicitly referenced shared defaults."""
    sections = dossier_sections(text, model_id)
    reference = "[Shared evidence](_shared/runtime-and-evaluation.md)"
    shared = {}
    if reference in text:
        path = root / FILES / "dossiers/_shared/runtime-and-evaluation.md"
        shared = dossier_sections(path.read_text(), model_id)
    for heading, fields in DOSSIER_FIELDS.items():
        if heading not in sections and heading not in shared:
            raise ValueError(f"missing dossier section: {model_id}: {heading}")
        body = sections.get(heading, "")
        bodies = [body]
        if heading == "2. Artifact evidence":
            artifacts = re.findall(r"^### ([^\n]+)\n(.*?)(?=^### |\Z)",
                                   body, re.MULTILINE | re.DOTALL)
            if artifacts:
                bodies = [evidence for name, evidence in artifacts
                          if not admission_only or name == model_id]
                if (len({name for name, _ in artifacts}) != len(artifacts)
                        or (admission_only and len(bodies) != 1)):
                    raise ValueError(f"missing or duplicate artifact evidence: {model_id}")
        for body in bodies:
            if heading == "2. Artifact evidence" and expected_revision is not None:
                revision = re.search(
                    r"^- Immutable artifact revision:[ \t]*`([a-f0-9]{40})`",
                    body, re.MULTILINE)
                if revision is None or revision[1] != expected_revision:
                    raise ValueError(f"artifact revision mismatch: {model_id}")
            for field in required_fields(fields, admission_only=admission_only):
                if field == "Benchmark":
                    validate_benchmarks(body, model_id, today=today)
                    continue
                pattern = (rf"^- {re.escape(field)}:[ \t]*(?:\n[ \t]+)?\S[^\n]*"
                           r"(?:\n[ \t]+\S[^\n]*)*")
                evidence = re.search(pattern, body, re.MULTILINE)
                if evidence is None and reference in text:
                    evidence = re.search(pattern, shared.get(heading, ""), re.MULTILINE)
                if evidence is None:
                    raise ValueError(f"missing dossier field: {model_id}: {field}")
                if re.search(r"\bUNVERIFIED\b", evidence.group(), re.IGNORECASE):
                    raise ValueError(f"unverified dossier evidence: {model_id}: {heading}")
            if not admission_only:
                # Optional converter metadata cannot block complete evidence.
                for field, gate in fields.items():
                    if gate == "optional":
                        body = re.sub(
                            rf"^- {re.escape(field)}:[^\n]*(?:\n[ \t]+[^\n]*)*",
                            "", body, flags=re.MULTILINE)
                if re.search(r"\bUNVERIFIED\b", body, re.IGNORECASE):
                    raise ValueError(f"unverified dossier evidence: {model_id}: {heading}")
