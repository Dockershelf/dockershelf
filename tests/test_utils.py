import unittest

from packaging.version import Version

from scripts.utils import debian_suites, node_suites, python_suites


class UtilsMetadataTest(unittest.TestCase):
    def test_suite_lists_are_non_empty(self):
        self.assertTrue(len(debian_suites) > 0)
        self.assertTrue(len(node_suites) > 0)
        self.assertTrue(len(python_suites) > 0)

    def test_packaging_version_parses(self):
        self.assertEqual(str(Version("3.12.0")), "3.12.0")


if __name__ == "__main__":
    unittest.main()
