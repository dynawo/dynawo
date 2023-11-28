# Copyright (c) 2023, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite
# of simulation tools for power systems.


import os
import sys
import unittest
parent_dir = os.path.dirname(__file__)
sources_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..'))
utils_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../..'))
sys.path.append(sources_dir)
sys.path.append(utils_dir)

from sources.utils.Common import *
from sources.Dyd.DydData import DydData
from sources.Dyd.Dyds import Dyds
from sources.Par.Parset import Parset

from utils import launch_test


class TestPar(unittest.TestCase):

    def test_add_parameter(self):
        test_dir_path = os.path.join(parent_dir, "res/add_parameter")
        update_XML_script = os.path.join(test_dir_path, "add_parameter.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_add_reference(self):
        test_dir_path = os.path.join(parent_dir, "res/add_reference")
        update_XML_script = os.path.join(test_dir_path, "add_reference.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_change_parameter_and_reference_name(self):
        test_dir_path = os.path.join(parent_dir, "res/change_parameter_and_reference_name")
        update_XML_script = os.path.join(test_dir_path, "change_parameter_and_reference_name.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_change_parameter_value(self):
        test_dir_path = os.path.join(parent_dir, "res/change_parameter_value")
        update_XML_script = os.path.join(test_dir_path, "change_parameter_value.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_remove_parameter_and_reference(self):
        test_dir_path = os.path.join(parent_dir, "res/remove_parameter_and_reference")
        update_XML_script = os.path.join(test_dir_path, "remove_parameter_and_reference.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_check_if_param_exists(self):
        job_parent_dir = os.path.join(parent_dir, "res/check_if_param_exists")
        dyd_path = os.path.join(job_parent_dir, "fic_DYD.xml")
        dyds = Dyds()
        dyds._dyds_collection[dyd_path] = DydData(dyd_path, job_parent_dir, dict(), dict(), dict())
        loads = dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LoadAlphaBeta")
        for load in loads:
            does_load_alpha_exist = load.parset.check_if_param_exists("load_alpha")
            self.assertTrue(does_load_alpha_exist)
            does_non_existent_load_exist = load.parset.check_if_param_exists("non_existent_load")
            self.assertFalse(does_non_existent_load_exist)

    def test_check_if_ref_exists(self):
        job_parent_dir = os.path.join(parent_dir, "res/check_if_ref_exists")
        dyd_path = os.path.join(job_parent_dir, "fic_DYD.xml")
        dyds = Dyds()
        dyds._dyds_collection[dyd_path] = DydData(dyd_path, job_parent_dir, dict(), dict(), dict())
        loads = dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LoadAlphaBeta")
        for load in loads:
            does_load_P0Pu_exist = load.parset.check_if_ref_exists("load_P0Pu")
            self.assertTrue(does_load_P0Pu_exist)
            does_non_existent_load_exist = load.parset.check_if_ref_exists("non_existent_load")
            self.assertFalse(does_non_existent_load_exist)

    def test_get_param_value(self):
        job_parent_dir = os.path.join(parent_dir, "res/get_param_value")
        par_path = os.path.join(job_parent_dir, "fic_PAR.xml")
        parset_tree_1 = get_parset(par_path, 1, dict())
        parset_tree_2 = get_parset(par_path, 2, dict())
        parset_tree_3 = get_parset(par_path, 3, dict())
        parset1 = Parset(parset_tree_1)
        parset2 = Parset(parset_tree_2)
        parset3 = Parset(parset_tree_3)
        self.assertTrue(parset1.get_param_value("load_isControllable"))
        self.assertEqual(parset2.get_param_value("load_name"), "myLoad2")
        self.assertEqual(parset2.get_param_value("load_beta"), 22)
        self.assertEqual(parset3.get_param_value("load_gamma"), 333.5)

    def test_no_parset(self):
        parset = Parset(None)
        with self.assertRaises(ParsetDoesNotExistError):
            parset.add_param("DOUBLE", "generator_mq", 0.215)
        with self.assertRaises(ParsetDoesNotExistError):
            parset.add_ref("DOUBLE", "load_U0Pu", "IIDM", "v_pu")
        with self.assertRaises(ParsetDoesNotExistError):
            parset.remove_param_or_ref("load_alpha")
        with self.assertRaises(ParsetDoesNotExistError):
            parset.change_param_or_ref_name("load_beta", "load_beta_NAME_CHANGED")
        with self.assertRaises(ParsetDoesNotExistError):
            parset.get_param_value("load_gamma")
        with self.assertRaises(ParsetDoesNotExistError):
            parset.change_param_value("load_alpha", 42)
        with self.assertRaises(ParsetDoesNotExistError):
            parset.check_if_param_exists("load_alpha")
        with self.assertRaises(ParsetDoesNotExistError):
            parset.check_if_ref_exists("load_alpha")
