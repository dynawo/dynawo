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


class TestModelicaModel(unittest.TestCase):

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

    def test_remove_unit_dynamic_model_macro_connect(self):
        test_dir_path = os.path.join(parent_dir, "res/remove_unit_dynamic_model_macro_connect")
        update_XML_script = os.path.join(test_dir_path, "remove_unit_dynamic_model_macro_connect.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_modelica_model_get_connects(self):
        job_parent_dir = os.path.join(parent_dir, "res/modelica_model_get_connects")
        dyd_path = os.path.join(job_parent_dir, "fic_DYD.xml")
        dyds = Dyds()
        dyds._dyds_collection[dyd_path] = DydData(dyd_path, job_parent_dir, dict(), dict(), dict())
        modelica_model = dyds.get_modelica_models(lambda modelica_model: modelica_model.get_id() == "GEN____1_SM")
        gen_connects = modelica_model[0].connects.get_connects()
        self.assertEqual(len(gen_connects), 2)
        for gen_connect in gen_connects:
            self.assertEqual(gen_connect.tag, xmlns('connect'))
        gen_connect_1 = gen_connects[0]
        self.assertEqual(gen_connect_1.attrib['id1'], 'GEN____1_SM')
        self.assertEqual(gen_connect_1.attrib['var1'], 'generator_terminal')
        self.assertEqual(gen_connect_1.attrib['id2'], 'NETWORK')
        self.assertEqual(gen_connect_1.attrib['var2'], '@_GEN____1_SM@@NODE@_ACPIN')
        gen_connect_2 = gen_connects[1]
        self.assertEqual(gen_connect_2.attrib['id1'], 'NETWORK')
        self.assertEqual(gen_connect_2.attrib['var1'], '@_GEN____1_SM@@NODE@_switchOff')
        self.assertEqual(gen_connect_2.attrib['id2'], 'GEN____1_SM')
        self.assertEqual(gen_connect_2.attrib['var2'], 'generator_switchOffSignal1')

    def test_unit_dynamic_model_get_connects(self):
        job_parent_dir = os.path.join(parent_dir, "res/unit_dynamic_model_get_connects")
        dyd_path = os.path.join(job_parent_dir, "fic_DYD.xml")
        dyds = Dyds()
        dyds._dyds_collection[dyd_path] = DydData(dyd_path, job_parent_dir, dict(), dict(), dict())
        modelica_model = dyds.get_modelica_models(lambda modelica_model: modelica_model.get_id() == "GEN____1_SM")
        unit_dynamic_model = modelica_model[0].get_unit_dynamic_models(lambda unit_dynamic_model: unit_dynamic_model.get_id() == "governor")
        gen_connects = unit_dynamic_model[0].connects.get_connects()
        self.assertEqual(len(gen_connects), 2)
        for gen_connect in gen_connects:
            self.assertEqual(gen_connect.tag, xmlns('connect'))
        gen_connect_1 = gen_connects[0]
        self.assertEqual(gen_connect_1.attrib['id1'], 'governor')
        self.assertEqual(gen_connect_1.attrib['var1'], 'omegaPu')
        self.assertEqual(gen_connect_1.attrib['id2'], 'generator')
        self.assertEqual(gen_connect_1.attrib['var2'], 'omegaPu.value')
        gen_connect_2 = gen_connects[1]
        self.assertEqual(gen_connect_2.attrib['id1'], 'generator')
        self.assertEqual(gen_connect_2.attrib['var1'], 'PmPu.value')
        self.assertEqual(gen_connect_2.attrib['id2'], 'governor')
        self.assertEqual(gen_connect_2.attrib['var2'], 'PmPu')

    def test_unit_dynamic_model_get_init_connects(self):
        job_parent_dir = os.path.join(parent_dir, "res/unit_dynamic_model_get_init_connects")
        dyd_path = os.path.join(job_parent_dir, "fic_DYD.xml")
        dyds = Dyds()
        dyds._dyds_collection[dyd_path] = DydData(dyd_path, job_parent_dir, dict(), dict(), dict())
        modelica_model = dyds.get_modelica_models(lambda modelica_model: modelica_model.get_id() == "GEN____1_SM")
        unit_dynamic_model = modelica_model[0].get_unit_dynamic_models(lambda unit_dynamic_model: unit_dynamic_model.get_id() == "voltageRegulator")
        gen_init_connects = unit_dynamic_model[0].init_connects.get_init_connects()
        self.assertEqual(len(gen_init_connects), 2)
        for gen_init_connect in gen_init_connects:
            self.assertEqual(gen_init_connect.tag, xmlns('initConnect'))
        gen_init_connect_1 = gen_init_connects[0]
        self.assertEqual(gen_init_connect_1.attrib['id1'], 'voltageRegulator')
        self.assertEqual(gen_init_connect_1.attrib['var1'], 'Efd0PuLF')
        self.assertEqual(gen_init_connect_1.attrib['id2'], 'generator')
        self.assertEqual(gen_init_connect_1.attrib['var2'], 'Efd0Pu')
        gen_init_connect_2 = gen_init_connects[1]
        self.assertEqual(gen_init_connect_2.attrib['id1'], 'generator')
        self.assertEqual(gen_init_connect_2.attrib['var1'], 'UStator0Pu')
        self.assertEqual(gen_init_connect_2.attrib['id2'], 'voltageRegulator')
        self.assertEqual(gen_init_connect_2.attrib['var2'], 'Us0Pu')
