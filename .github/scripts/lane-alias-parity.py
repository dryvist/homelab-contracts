#!/usr/bin/env python3
"""Check consumer lane-class names against the shared lanes contract."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any


def read_json(path: Path) -> Any:
    try:
        with path.open(encoding="utf-8") as stream:
            return json.load(stream)
    except (OSError, json.JSONDecodeError) as exc:
        raise ValueError(f"cannot read JSON file {path}: {exc}") from exc


def string_list(value: Any, field: str, path: Path) -> list[str]:
    if not isinstance(value, list):
        raise ValueError(f"{path}: {field} must be a JSON array of strings")
    if any(not isinstance(item, str) or not item.strip() for item in value):
        raise ValueError(f"{path}: {field} must contain only non-empty strings")
    return value


def load_lanes(path: Path) -> tuple[set[str], set[str]]:
    document = read_json(path)
    if not isinstance(document, dict):
        raise ValueError(f"{path}: lanes contract must be a JSON object")
    version = document.get("schema_version")
    if type(version) is not int or version != 1:
        raise ValueError(f"{path}: schema_version must be integer 1; got {version!r}")

    vocabulary = string_list(document.get("vocabulary"), "vocabulary", path)
    pending = string_list(document.get("pending"), "pending", path)
    harness_aliases = string_list(document.get("harness_aliases"), "harness_aliases", path)
    if len(vocabulary) != len(set(vocabulary)):
        raise ValueError(f"{path}: vocabulary contains duplicate names")

    unresolved = sorted((set(pending) | set(harness_aliases)) - set(vocabulary))
    if unresolved:
        raise ValueError(
            f"{path}: pending and harness_aliases must resolve into vocabulary; "
            f"unresolved: {', '.join(unresolved)}"
        )

    return set(vocabulary) | set(pending) | set(harness_aliases), set(pending)


def load_names(path: Path) -> tuple[str, list[str]]:
    document = read_json(path)
    if not isinstance(document, dict):
        raise ValueError(f"{path}: names file must be a JSON object")
    source = document.get("source")
    if not isinstance(source, str) or not source.strip():
        raise ValueError(f"{path}: source must be a non-empty string")
    names = string_list(document.get("names"), "names", path)
    return source, names


def report_source(source: str, names: list[str], allowed: set[str], pending: set[str]) -> bool:
    unique_names = set(names)
    unknown = sorted(unique_names - allowed)
    pending_names = sorted(unique_names & pending)

    print(f"{source}:")
    if unknown:
        print("  FAIL: unknown lane-class names:")
        for name in unknown:
            print(f"    - {name}")
        print(f"  Allowed lane-class names ({len(allowed)}):")
        for name in sorted(allowed):
            print(f"    + {name}")
    else:
        print(f"  PASS: all {len(unique_names)} lane-class name(s) are allowed")

    if pending_names:
        print("  WARN: pending lane-class names (allowed, but unresolved):")
        for name in pending_names:
            print(f"    ! {name}")
    return not unknown


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--lanes", required=True, type=Path, help="shared lanes.json contract")
    parser.add_argument(
        "--names",
        action="append",
        required=True,
        type=Path,
        help="consumer JSON object with source and names fields (repeatable)",
    )
    args = parser.parse_args()

    try:
        allowed, pending = load_lanes(args.lanes)
        inputs = [load_names(path) for path in args.names]
    except ValueError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2

    results = [report_source(source, names, allowed, pending) for source, names in inputs]
    return 0 if all(results) else 1


if __name__ == "__main__":
    raise SystemExit(main())
