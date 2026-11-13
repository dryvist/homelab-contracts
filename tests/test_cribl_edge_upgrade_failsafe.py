#!/usr/bin/env python3
"""Structural checks for the Cribl Edge versioned upgrade and recovery path."""

import unittest
from pathlib import Path

import yaml


ROOT = Path(__file__).resolve().parent.parent
ROLE = ROOT / "ansible" / "roles" / "cribl_edge"
MAIN = ROLE / "tasks" / "main.yml"
UPGRADE = ROLE / "tasks" / "upgrade.yml"


def _module(task):
    return next(
        (key for key in task if key.startswith("ansible.builtin.")),
        None,
    )


def _find(tasks, name):
    return next(task for task in tasks if task.get("name") == name)


class CriblEdgeUpgrade(unittest.TestCase):
    def setUp(self):
        self.main = yaml.safe_load(MAIN.read_text())
        self.tasks = yaml.safe_load(UPGRADE.read_text())
        self.upgrade = _find(self.tasks, "Upgrade Cribl Edge to the catalog version")
        self.upgrade_block = self.upgrade["block"]
        self.replace_block = _find(self.upgrade_block, "Stop, replace and restart Cribl Edge")

    def test_installed_version_difference_gates_upgrade(self):
        version_read = _find(self.tasks, "Read the installed Cribl Edge version")
        self.assertEqual(_module(version_read), "ansible.builtin.command")
        self.assertEqual(
            version_read["ansible.builtin.command"]["cmd"],
            "{{ cribl_edge_install_dir }}/bin/cribl version",
        )
        conditions = " ".join(self.upgrade["when"])
        self.assertIn("cribl_edge_running_version is match(", conditions)
        self.assertIn("cribl_edge_version", conditions)
        self.assertIn("cribl_edge_running_release", conditions)

    def test_equal_version_is_a_noop_and_newer_version_is_reported(self):
        conditions = " ".join(self.upgrade["when"])
        self.assertIn("not (cribl_edge_running_version is match(", conditions)
        newer = _find(self.tasks, "Keep a newer Cribl Edge version without downgrading")
        self.assertEqual(_module(newer), "ansible.builtin.debug")
        self.assertIn("version(", newer["when"])
        self.assertIn("'>'", newer["when"])
        self.assertIn("version_type='semver'", newer["when"])

    def test_fresh_install_and_upgrade_use_catalog_checksum_sidecar(self):
        download = _find(self.main, "Download Cribl Edge tarball with checksum verification")
        self.assertEqual(_module(download), "ansible.builtin.get_url")
        self.assertEqual(
            download["ansible.builtin.get_url"]["checksum"],
            "sha256:{{ cribl_edge_tarball_url }}.sha256",
        )
        upgrade_download = _find(
            self.replace_block["block"],
            "Download the catalog Cribl Edge tarball with checksum verification",
        )
        self.assertEqual(_module(upgrade_download), "ansible.builtin.get_url")
        self.assertEqual(
            upgrade_download["ansible.builtin.get_url"]["checksum"],
            "sha256:{{ cribl_edge_tarball_url }}.sha256",
        )

    def test_preflight_checks_both_objects_before_stopping(self):
        names = [task.get("name", "") for task in self.upgrade_block]
        stop_block_at = next(i for i, task in enumerate(self.upgrade_block) if "block" in task)
        preflight = [
            task for task in self.upgrade_block[:stop_block_at]
            if _module(task) == "ansible.builtin.uri"
            and task["ansible.builtin.uri"].get("method") == "HEAD"
        ]
        self.assertEqual(len(preflight), 1, f"missing artifact preflight: {names}")
        self.assertEqual(
            preflight[0]["loop"],
            ["{{ cribl_edge_tarball_url }}", "{{ cribl_edge_tarball_url }}.sha256"],
        )

    def test_backup_and_extract_preserve_the_existing_install_tree(self):
        stop_block = self.replace_block["block"]
        stop_index = next(
            i for i, task in enumerate(stop_block)
            if _module(task) == "ansible.builtin.systemd"
            and task["ansible.builtin.systemd"].get("state") == "stopped"
        )
        backup_index = next(
            i for i, task in enumerate(stop_block)
            if task.get("name") == "Back up local/ before upgrading"
        )
        extract = _find(stop_block, "Extract the new version over the existing Cribl Edge install")
        self.assertLess(stop_index, backup_index)
        self.assertIn("local", stop_block[backup_index]["ansible.builtin.command"]["argv"])
        self.assertEqual(extract["ansible.builtin.unarchive"]["dest"], "{{ cribl_edge_install_dir | dirname }}")
        destructive = [
            task for task in stop_block
            if _module(task) == "ansible.builtin.file"
            and task["ansible.builtin.file"].get("state") == "absent"
            and "cribl_edge_install_dir" in str(task["ansible.builtin.file"].get("path", ""))
        ]
        self.assertEqual(destructive, [], "the upgrade must not remove install-path directories")

    def test_restart_health_and_catalog_version_are_verified(self):
        stop_block = self.replace_block["block"]
        start = _find(stop_block, "Start Cribl Edge after upgrading")
        health = _find(stop_block, "Wait for Cribl Edge health after the upgrade")
        version = _find(stop_block, "Read the Cribl Edge version after upgrading")
        verify = _find(stop_block, "Verify Cribl Edge reports the catalog version")
        self.assertEqual(start["ansible.builtin.systemd"]["state"], "started")
        self.assertEqual(health["ansible.builtin.uri"]["status_code"], [200])
        self.assertIn("cribl_edge_version", str(verify["ansible.builtin.assert"]["that"]))
        self.assertIn("check_mode", version)

    def test_failure_restarts_then_fails(self):
        rescue = self.replace_block.get("rescue", [])
        self.assertGreaterEqual(len(rescue), 2, "the stopped service needs a restart and failed run")
        self.assertEqual(_module(rescue[0]), "ansible.builtin.systemd")
        self.assertEqual(rescue[0]["ansible.builtin.systemd"]["state"], "started")
        self.assertEqual(_module(rescue[-1]), "ansible.builtin.fail")


if __name__ == "__main__":
    unittest.main()
