"""Shared scaffolding for the converge-telemetry test modules.

Not a test module itself. The plugin is split into a callback-lifecycle half
and a pure event-construction half; the tests follow that split, and this
holds the loader, the fixture configuration and the stubbed callback both
sides need so neither file has to grow a copy of the other's setup.

The plugin lives in this collection, so it is loaded the same way a real
converge loads it: through Ansible's own collection finder, by FQCN, not by
constructing a module from a bare file path. `install_collection_finder()`
points that finder at THIS repo's `ansible/` directory via a throwaway
`ansible_collections/dryvist/homelab` symlink -- the layout `ansible-galaxy`
would produce after installing this repo as a collection.
"""

import tempfile
from pathlib import Path

from ansible.utils.collection_loader._collection_finder import _AnsibleCollectionFinder

ROOT = Path(__file__).resolve().parents[1]
ANSIBLE_ROOT = ROOT / "ansible"


def install_collection_finder():
    collections_root = Path(tempfile.gettempdir()) / "homelab-contracts-collection-test"
    link = collections_root / "ansible_collections" / "dryvist" / "homelab"
    link.parent.mkdir(parents=True, exist_ok=True)
    if not link.is_symlink():
        link.symlink_to(ANSIBLE_ROOT, target_is_directory=True)
    _AnsibleCollectionFinder(paths=[str(collections_root)])._install()


install_collection_finder()

from ansible_collections.dryvist.homelab.plugins.callback import (  # noqa: E402
    converge_telemetry as telemetry,
)


CONFIG = {
    "hec_url": "https://splunk.example.test:8088/services/collector/event",
    "index": "ansible",
    "git_sha": "0123456789abcdef0123456789abcdef01234567",
    # Every consumer of this collection publishes its own repo name via
    # set_stats -- see converge_telemetry.py's DOCUMENTATION. Fixed here so a
    # test that asserts on it is pinning real behavior, not the fallback.
    "repo": "ansible-proxmox-test",
    "roster": ["alpha", "bravo", "charlie"],
    "fqdns": {
        "alpha": "alpha.example.test",
        "bravo": "bravo.example.test",
        "charlie": "charlie.example.test",
    },
}


def summary(**kwargs):
    base = {
        "ok": 10,
        "changed": 2,
        "skipped": 3,
        "failures": 0,
        "unreachable": 0,
        "rescued": 0,
        "ignored": 0,
    }
    base.update(kwargs)
    return base


class RecordingCallback(telemetry.CallbackModule):
    """The real callback with only its Ansible plumbing stubbed out."""

    def __init__(self):
        telemetry.CallbackModule.__init__(self)
        self._plugin_options = {"enabled": True, "hec_token": "unit-test-token"}

    def get_option(self, name):
        return self._plugin_options[name]
