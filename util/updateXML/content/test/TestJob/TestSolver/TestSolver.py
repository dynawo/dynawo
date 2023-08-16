import os
import sys
import unittest
parent_dir = os.path.dirname(__file__)
sources_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..'))
sys.path.append(sources_dir)

from utils import launch_test


class TestSolver(unittest.TestCase):

    def test_change_solver_library_name(self):
        test_dir_path = os.path.join(parent_dir, "res/change_solver_library_name")
        update_XML_script = os.path.join(test_dir_path, "change_solver_library_name.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_add_solver_parameter(self):
        test_dir_path = os.path.join(parent_dir, "res/add_solver_parameter")
        update_XML_script = os.path.join(test_dir_path, "add_solver_parameter.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_change_solver_parameter_name(self):
        test_dir_path = os.path.join(parent_dir, "res/change_solver_parameter_name")
        update_XML_script = os.path.join(test_dir_path, "change_solver_parameter_name.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_remove_solver_parameter(self):
        test_dir_path = os.path.join(parent_dir, "res/remove_solver_parameter")
        update_XML_script = os.path.join(test_dir_path, "remove_solver_parameter.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)
