# Copyright (c) 2023, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite
# of simulation tools for power systems.


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


class TestModelTemplateExpansion(unittest.TestCase):

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

    def test_add_parameter(self):
        test_dir_path = os.path.join(parent_dir, "res/add_parameter")
        update_XML_script = os.path.join(test_dir_path, "add_parameter.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_get_connects(self):
        job_parent_dir = os.path.join(parent_dir, "res/get_connects")
        dyd_path = os.path.join(job_parent_dir, "fic_DYD.xml")
        dyds = Dyds()
        dyds._dyds_collection[dyd_path] = DydData(dyd_path, job_parent_dir, dict(), dict(), dict())
        model_template_expansion = dyds.get_model_template_expansions(
            lambda model_template_expansion: model_template_expansion.get_id() == "GEN____1_SM"
        )
        gen_connects = model_template_expansion[0].connects.get_connects()
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
