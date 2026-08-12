"""Contract checks for generated Hub workflows and the release-gate push workflow."""

from __future__ import annotations

import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
WORKFLOWS = ROOT / ".github" / "workflows"
UPDATE_PY = ROOT / "update.py"

REMOVED = (
    "push-master.yml",
    "push-master.yml.template",
    "trigger-develop.yml",
    "trigger-develop.yml.template",
    "clean-develop.yml",
    "clean-develop.yml.template",
)

KEPT_TEMPLATES = (
    "trigger-master.yml.template",
    "clean-master.yml.template",
    "schedule-master.yml.template",
)

KEPT_GENERATED = (
    "trigger-master.yml",
    "clean-master.yml",
    "schedule-master.yml",
)


class GhaWorkflowsContractTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.update_py = UPDATE_PY.read_text(encoding="utf-8")
        cls.push_yml = (WORKFLOWS / "push.yml").read_text(encoding="utf-8")
        cls.pr_yml = (WORKFLOWS / "pr.yml").read_text(encoding="utf-8")

    def test_removed_hub_workflows_are_gone(self) -> None:
        for name in REMOVED:
            self.assertFalse((WORKFLOWS / name).exists(), name)

    def test_update_py_does_not_mention_removed_workflows(self) -> None:
        for needle in (
            "push-master",
            "trigger-develop",
            "clean-develop",
        ):
            self.assertNotIn(needle, self.update_py)

    def test_remaining_templates_exist_with_matrix_placeholder(self) -> None:
        for name in KEPT_TEMPLATES:
            path = WORKFLOWS / name
            self.assertTrue(path.is_file(), name)
            self.assertIn("%%MATRIX%%", path.read_text(encoding="utf-8"))

    def test_remaining_generated_workflows_exist(self) -> None:
        for name in KEPT_GENERATED:
            self.assertTrue((WORKFLOWS / name).is_file(), name)

    def test_update_py_still_writes_remaining_templates(self) -> None:
        for name in KEPT_TEMPLATES:
            self.assertIn(name, self.update_py)

    def test_push_yml_is_release_branches_only(self) -> None:
        on_section = self.push_yml.split("jobs:", 1)[0]
        self.assertIn('"release/**"', on_section)
        self.assertNotIn("- develop", on_section)
        self.assertNotIn("- master", on_section)
        self.assertIn("name: Release Gate", self.push_yml)
        self.assertIn("name: Ruby bundle (publish runtime)", self.push_yml)
        self.assertIn("name: Production Build", self.push_yml)

    def test_pr_yml_still_runs_on_develop(self) -> None:
        on_section = self.pr_yml.split("jobs:", 1)[0]
        self.assertIn("- develop", on_section)


if __name__ == "__main__":
    unittest.main()
