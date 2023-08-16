import os
import sys
import unittest
parent_dir = os.path.dirname(__file__)
utils_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../..'))
sys.path.append(utils_dir)

from utils import launch_test


class TestJob(unittest.TestCase):

    def test_multiple_job_files(self):
        test_dir_path = os.path.join(parent_dir, "res/multiple_job_files")
        update_XML_script = os.path.join(test_dir_path, "multiple_job_files.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

if __name__ == '__main__':
    unittest.main()
