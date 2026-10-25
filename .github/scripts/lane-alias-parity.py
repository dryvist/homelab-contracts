#!/usr/bin/env python3
"""Check consumer names against shared lane and optional router contracts."""

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


def load_lanes(path: Path) -> tuple[set[str], set[str], set[str]]:
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

    return (
        set(vocabulary) | set(pending) | set(harness_aliases),
        set(pending),
        (set(vocabulary) - set(pending)) | set(harness_aliases),
    )


def load_router_names(path: Path) -> set[str]:
    document = read_json(path)
    if not isinstance(document, dict):
        raise ValueError(f"{path}: router names contract must be a JSON object")

    version = document.get("schema_version")
    if type(version) is int:
        major = version
    elif isinstance(version, str):
        parts = version.split(".")
        if not parts or any(not part.isdecimal() for part in parts):
            raise ValueError(
                f"{path}: schema_version must be an integer or dotted numeric version; got {version!r}"
            )
        major = int(parts[0])
    else:
        raise ValueError(
            f"{path}: schema_version must be an integer or dotted numeric version; got {version!r}"
        )
    if major != 1:
        raise ValueError(f"{path}: unsupported schema_version major {major}; supported major is 1")

    router_names = document.get("router_names")
    if not isinstance(router_names, dict):
        raise ValueError(f"{path}: missing or invalid router_names object")

    fields = ("aliases", "route_groups", "direct_routes", "roles", "all")
    values: dict[str, list[str]] = {}
    for field in fields:
        names = string_list(router_names.get(field), f"router_names.{field}", path)
        if names != sorted(set(names)):
            raise ValueError(f"{path}: router_names.{field} must be sorted and contain no duplicates")
        values[field] = names

    all_names = set(values["all"])
    if not all_names:
        raise ValueError(f"{path}: router_names.all must not be empty")
    categories = set().union(*(set(values[field]) for field in fields[:-1]))
    if all_names != categories:
        missing = sorted(categories - all_names)
        extra = sorted(all_names - categories)
        details = []
        if missing:
            details.append(f"missing from all: {', '.join(missing)}")
        if extra:
            details.append(f"not present in a category: {', '.join(extra)}")
        raise ValueError(f"{path}: router_names.all must be the union of categories ({'; '.join(details)})")
    return all_names


def load_names(path: Path) -> tuple[str, list[str]]:
    document = read_json(path)
    if not isinstance(document, dict):
        raise ValueError(f"{path}: names file must be a JSON object")
    source = document.get("source")
    if not isinstance(source, str) or not source.strip():
        raise ValueError(f"{path}: source must be a non-empty string")
    names = string_list(document.get("names"), "names", path)
    return source, names


def report_source(
    source: str,
    names: list[str],
    allowed: set[str],
    pending: set[str],
    name_kind: str = "lane-class",
) -> bool:
    unique_names = set(names)
    unknown = sorted(unique_names - allowed)
    pending_names = sorted(unique_names & pending)

    print(f"{source}:")
    if unknown:
        print(f"  FAIL: unknown {name_kind} names:")
        for name in unknown:
            print(f"    - {name}")
        print(f"  Allowed {name_kind} names ({len(allowed)}):")
        for name in sorted(allowed):
            print(f"    + {name}")
    else:
        print(f"  PASS: all {len(unique_names)} {name_kind} name(s) are allowed")

    if pending_names:
        print("  WARN: pending lane-class names (allowed, but unresolved):")
        for name in pending_names:
            print(f"    ! {name}")
    return not unknown


def report_lane_coverage(required: set[str], router_names: set[str]) -> bool:
    missing = sorted(required - router_names)
    print("lanes.json:")
    if missing:
        print("  FAIL: non-pending lane and harness alias names missing from router_names.all:")
        for name in missing:
            print(f"    - {name}")
        return False
    print(f"  PASS: all {len(required)} non-pending lane and harness alias name(s) are served")
    return True


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
    parser.add_argument(
        "--router-names",
        type=Path,
        help="optional servable-aliases.json router names contract",
    )
    args = parser.parse_args()

    try:
        allowed, pending, lane_names = load_lanes(args.lanes)
        router_names = load_router_names(args.router_names) if args.router_names else None
        inputs = [load_names(path) for path in args.names]
    except ValueError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2

    name_allowlist = router_names if router_names is not None else allowed
    name_kind = "router" if router_names is not None else "lane-class"
    results = [
        report_source(source, names, name_allowlist, pending, name_kind)
        for source, names in inputs
    ]
    if router_names is not None:
        results.append(report_lane_coverage(lane_names, router_names))
    return 0 if all(results) else 1


if __name__ == "__main__":
    raise SystemExit(main())
