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
sys.path.append(sources_dir)

from utils import launch_test


class TestFinalStateValues(unittest.TestCase):

    def test_change_final_state_values_variable_name(self):
        test_dir_path = os.path.join(parent_dir, "res/change_final_state_values_variable_name")
        update_XML_script = os.path.join(test_dir_path, "change_final_state_values_variable_name.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path, test_crv=False, test_fsv=True)

    def test_remove_final_state_values_variable(self):
        test_dir_path = os.path.join(parent_dir, "res/remove_final_state_values_variable")
        update_XML_script = os.path.join(test_dir_path, "remove_final_state_values_variable.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path, test_crv=False, test_fsv=True)
