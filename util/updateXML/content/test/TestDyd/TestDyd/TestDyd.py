import os
import sys
import unittest
import filecmp
import subprocess
parent_dir = os.path.dirname(__file__)
utils_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../..'))
sys.path.append(utils_dir)

from utils import launch_test


class TestDyd(unittest.TestCase):

    def test_remove_macro_connector(self):
        test_dir_path = os.path.join(parent_dir, "res/remove_macro_connector")
        update_XML_script = os.path.join(test_dir_path, "remove_macro_connector.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_remove_macro_static_reference(self):
        test_dir_path = os.path.join(parent_dir, "res/remove_macro_static_reference")
        update_XML_script = os.path.join(test_dir_path, "remove_macro_static_reference.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_multiple_dyd_files(self):
        test_dir_path = os.path.join(parent_dir, "res/multiple_dyd_files")
        update_XML_script = os.path.join(test_dir_path, "multiple_dyd_files.py")
        input_job_file_path = os.path.join(test_dir_path, "inputs/fic_JOB.xml")
        output_dyd_file_1_path = os.path.join(test_dir_path, "outputs1.4.0/fic_DYD_1.xml")
        output_dyd_file_2_path = os.path.join(test_dir_path, "outputs1.4.0/fic_DYD_2.xml")
        output_par_file_path = os.path.join(test_dir_path, "outputs1.4.0/fic_PAR.xml")
        ref_dyd_file_1_path = os.path.join(test_dir_path, "reference/fic_DYD_1.xml")
        ref_dyd_file_2_path = os.path.join(test_dir_path, "reference/fic_DYD_2.xml")
        ref_par_file_path = os.path.join(test_dir_path, "reference/fic_PAR.xml")
        project_env = dict(os.environ)
        project_env['PYTHONPATH'] = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..'))
        subprocess.run(["python", update_XML_script,
                        "--job", input_job_file_path,
                        "--origin", "1.3.0",
                        "--version", "1.4.0",
                        "-o", test_dir_path], env=project_env)
        self.assertTrue(filecmp.cmp(output_dyd_file_1_path, ref_dyd_file_1_path))
        self.assertTrue(filecmp.cmp(output_dyd_file_2_path, ref_dyd_file_2_path))
        self.assertTrue(filecmp.cmp(output_par_file_path, ref_par_file_path))


if __name__ == '__main__':
    unittest.main()
