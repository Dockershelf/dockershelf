"""Contract checks for the SHA-bound PR auto-merge workflow."""

from __future__ import annotations

import unittest
from pathlib import Path

WORKFLOW = Path(__file__).resolve().parents[1] / ".github" / "workflows" / "pr-auto-merge.yml"


class PrAutoMergeWorkflowContractTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.text = WORKFLOW.read_text(encoding="utf-8")
        cls.coordinate, _, cls.update = cls.text.partition("name: Update behind branch")

    def test_workflow_file_exists(self) -> None:
        self.assertTrue(WORKFLOW.is_file())

    def test_missing_pr_is_notice_not_failure(self) -> None:
        self.assertIn("No open pull request found for workflow run", self.text)
        self.assertNotIn(
            "core.setFailed('No open pull request found for workflow run')",
            self.text,
        )
        self.assertIn("core.notice('No open pull request found for workflow run')", self.text)
        self.assertIn("core.setOutput('eligible', 'false')", self.text)

    def test_expected_head_sha_guards(self) -> None:
        self.assertIn("expected_head_sha", self.text)
        self.assertIn("expectedHeadOid", self.text)
        self.assertIn("expected_head_sha: expectedHeadSha", self.text)
        self.assertIn("commit_id: expectedHeadSha", self.text)
        self.assertIn("sha: expectedHeadSha", self.text)
        self.assertIn("does not match workflow run head", self.text)
        self.assertIn("stale event, skipping", self.text)
        self.assertIn("review.commit_id === expectedHeadSha", self.text)
        self.assertNotIn("!review.commit_id", self.text)

    def test_job_outputs_passed_via_env_not_script_interpolation(self) -> None:
        self.assertIn("PULL_NUMBER: ${{ needs.gate.outputs.pull_number }}", self.text)
        self.assertIn("EXPECTED_HEAD_SHA: ${{ needs.gate.outputs.expected_head_sha }}", self.text)
        self.assertIn("Number(process.env.PULL_NUMBER)", self.text)
        self.assertIn("process.env.EXPECTED_HEAD_SHA", self.text)
        self.assertNotIn("Number('${{ needs.gate.outputs.pull_number }}')", self.text)
        self.assertNotIn("const expectedHeadSha = '${{ needs.gate.outputs.expected_head_sha }}'", self.text)

    def test_per_pr_concurrency_without_cancel(self) -> None:
        mutate_job = self.text.split("name: Coordinate pull request merge", 1)[1]
        self.assertIn(
            "group: pr-auto-merge-${{ needs.gate.outputs.pull_number }}",
            mutate_job,
        )
        self.assertIn("cancel-in-progress: false", mutate_job)

    def test_native_auto_merge_is_primary(self) -> None:
        self.assertIn("enablePullRequestAutoMerge", self.text)
        self.assertIn("mergeMethod: 'MERGE'", self.text)
        self.assertIn("armBehindAndUpdate", self.text)

    def test_behind_path_arms_then_updates(self) -> None:
        self.assertIn("core.setOutput('update_branch', 'true')", self.text)
        self.assertIn("steps.coordinate.outputs.update_branch == 'true'", self.text)
        self.assertIn("expected_head_sha: expectedHeadSha", self.text)
        self.assertIn("waiting for fresh Pull Request CI", self.text)
        self.assertIn(
            "REPO_PERSONAL_ACCESS_TOKEN is required to update behind PR branches",
            self.text,
        )
        self.assertIn("already up to date, skipping", self.text)

    def test_pat_only_on_update_behind_step(self) -> None:
        self.assertNotIn("REPO_PERSONAL_ACCESS_TOKEN", self.coordinate)
        self.assertIn("REPO_PERSONAL_ACCESS_TOKEN", self.update)
        self.assertIn("github.getOctokit(pat)", self.update)
        self.assertIn("updateBranch", self.update)
        # Approval and merge must use the default github (GITHUB_TOKEN) client.
        self.assertIn("await github.rest.pulls.createReview", self.coordinate)
        self.assertIn("await github.rest.pulls.merge", self.coordinate)
        self.assertNotIn("patGithub.rest.pulls.createReview", self.text)
        self.assertNotIn("patGithub.rest.pulls.merge", self.text)

    def test_direct_merge_requires_both_clean_signals(self) -> None:
        self.assertIn("SHA-guarded direct fallback", self.text)
        self.assertIn("mergeApprovedCleanHead", self.text)
        self.assertIn("merge_method: 'merge'", self.text)
        self.assertIn("result.merged", self.text)
        self.assertIn("node.reviewDecision === 'APPROVED'", self.text)
        self.assertIn("pull.mergeable_state === 'clean' &&", self.text)
        self.assertIn("node.mergeStateStatus === 'CLEAN'", self.text)
        self.assertIn("waitForKnownMergeState", self.text)

    def test_no_checkout_of_pr_code(self) -> None:
        self.assertNotIn("actions/checkout", self.text)

    def test_single_mutation_job(self) -> None:
        self.assertIn("name: Coordinate pull request merge", self.text)
        self.assertNotIn("name: Approve pull request", self.text)
        self.assertNotIn("name: Merge pull request", self.text)


if __name__ == "__main__":
    unittest.main()
