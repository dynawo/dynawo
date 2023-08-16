import os
import sys
import unittest
parent_dir = os.path.dirname(__file__)
sources_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..'))
utils_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../..'))
sys.path.append(sources_dir)
sys.path.append(utils_dir)

from sources.Dyd.DydData import DydData
from sources.Dyd.Dyds import Dyds
from sources.utils.Common import xmlns

from utils import launch_test


class TestModelTemplate(unittest.TestCase):

    def test_remove_static_ref(self):
        test_dir_path = os.path.join(parent_dir, "res/remove_static_ref")
        update_XML_script = os.path.join(test_dir_path, "remove_static_ref.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_change_static_ref_var_name(self):
        test_dir_path = os.path.join(parent_dir, "res/change_static_ref_var_name")
        update_XML_script = os.path.join(test_dir_path, "change_static_ref_var_name.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_remove_macro_static_ref(self):
        test_dir_path = os.path.join(parent_dir, "res/remove_macro_static_ref")
        update_XML_script = os.path.join(test_dir_path, "remove_macro_static_ref.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_change_unit_dynamic_model_id(self):
        test_dir_path = os.path.join(parent_dir, "res/change_unit_dynamic_model_id")
        update_XML_script = os.path.join(test_dir_path, "change_unit_dynamic_model_id.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_change_unit_dynamic_model_name(self):
        test_dir_path = os.path.join(parent_dir, "res/change_unit_dynamic_model_name")
        update_XML_script = os.path.join(test_dir_path, "change_unit_dynamic_model_name.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_change_unit_dynamic_model_connect_var_name(self):
        test_dir_path = os.path.join(parent_dir, "res/change_unit_dynamic_model_connect_var_name")
        update_XML_script = os.path.join(test_dir_path, "change_unit_dynamic_model_connect_var_name.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_remove_unit_dynamic_model_connect(self):
        test_dir_path = os.path.join(parent_dir, "res/remove_unit_dynamic_model_connect")
        update_XML_script = os.path.join(test_dir_path, "remove_unit_dynamic_model_connect.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_remove_unit_dynamic_model_macro_connect(self):
        test_dir_path = os.path.join(parent_dir, "res/remove_unit_dynamic_model_macro_connect")
        update_XML_script = os.path.join(test_dir_path, "remove_unit_dynamic_model_macro_connect.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_unit_dynamic_model_get_connects(self):
        job_parent_dir = os.path.join(parent_dir, "res/unit_dynamic_model_get_connects")
        dyd_path = os.path.join(job_parent_dir, "fic_DYD.xml")
        dyds = Dyds()
        dyds._dyds_collection[dyd_path] = DydData(dyd_path, job_parent_dir, dict(), dict(), dict())
        model_templates = dyds.get_model_templates(
            lambda model_template: model_template.get_id() == "MachineThreeWindingsTemplate"
        )
        for model_template in model_templates:
            unit_dynamic_models = model_template.get_unit_dynamic_models(
                lambda unit_dynamic_model: unit_dynamic_model.get_id() == "voltageRegulator"
            )
            for unit_dynamic_model in unit_dynamic_models:
                voltage_regulator_connects = unit_dynamic_model.connects.get_connects()
                self.assertEqual(len(voltage_regulator_connects), 2)
                for voltage_regulator_connect in voltage_regulator_connects:
                    self.assertEqual(voltage_regulator_connect.tag, xmlns('connect'))
                voltage_regulator_connect_1 = voltage_regulator_connects[0]
                self.assertEqual(voltage_regulator_connect_1.attrib['id1'], 'voltageRegulator')
                self.assertEqual(voltage_regulator_connect_1.attrib['var1'], 'EfdPu')
                self.assertEqual(voltage_regulator_connect_1.attrib['id2'], 'generator')
                self.assertEqual(voltage_regulator_connect_1.attrib['var2'], 'efdPu.value')
                voltage_regulator_connect_2 = voltage_regulator_connects[1]
                self.assertEqual(voltage_regulator_connect_2.attrib['id1'], 'generator')
                self.assertEqual(voltage_regulator_connect_2.attrib['var1'], 'UStatorPu.value')
                self.assertEqual(voltage_regulator_connect_2.attrib['id2'], 'voltageRegulator')
                self.assertEqual(voltage_regulator_connect_2.attrib['var2'], 'UsPu')

    def test_unit_dynamic_model_get_init_connects(self):
        job_parent_dir = os.path.join(parent_dir, "res/unit_dynamic_model_get_init_connects")
        dyd_path = os.path.join(job_parent_dir, "fic_DYD.xml")
        dyds = Dyds()
        dyds._dyds_collection[dyd_path] = DydData(dyd_path, job_parent_dir, dict(), dict(), dict())
        model_templates = dyds.get_model_templates(
            lambda model_template: model_template.get_id() == "MachineThreeWindingsTemplate"
        )
        for model_template in model_templates:
            unit_dynamic_models = model_template.get_unit_dynamic_models(
                lambda unit_dynamic_model: unit_dynamic_model.get_id() == "voltageRegulator"
            )
            for unit_dynamic_model in unit_dynamic_models:
                voltage_regulator_init_connects = unit_dynamic_model.init_connects.get_init_connects()
                self.assertEqual(len(voltage_regulator_init_connects), 2)
                for voltage_regulator_init_connect in voltage_regulator_init_connects:
                    self.assertEqual(voltage_regulator_init_connect.tag, xmlns('initConnect'))
                voltage_regulator_init_connect_1 = voltage_regulator_init_connects[0]
                self.assertEqual(voltage_regulator_init_connect_1.attrib['id1'], 'voltageRegulator')
                self.assertEqual(voltage_regulator_init_connect_1.attrib['var1'], 'Efd0PuLF')
                self.assertEqual(voltage_regulator_init_connect_1.attrib['id2'], 'generator')
                self.assertEqual(voltage_regulator_init_connect_1.attrib['var2'], 'Efd0Pu')
                voltage_regulator_init_connect_2 = voltage_regulator_init_connects[1]
                self.assertEqual(voltage_regulator_init_connect_2.attrib['id1'], 'generator')
                self.assertEqual(voltage_regulator_init_connect_2.attrib['var1'], 'UStator0Pu')
                self.assertEqual(voltage_regulator_init_connect_2.attrib['id2'], 'voltageRegulator')
                self.assertEqual(voltage_regulator_init_connect_2.attrib['var2'], 'Us0Pu')
