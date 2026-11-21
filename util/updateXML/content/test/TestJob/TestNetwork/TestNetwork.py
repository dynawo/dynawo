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


class TestNetwork(unittest.TestCase):

    def test_add_network_parameter(self):
        test_dir_path = os.path.join(parent_dir, "res/add_network_parameter")
        update_XML_script = os.path.join(test_dir_path, "add_network_parameter.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_change_network_parameter_name(self):
        test_dir_path = os.path.join(parent_dir, "res/change_network_parameter_name")
        update_XML_script = os.path.join(test_dir_path, "change_network_parameter_name.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)

    def test_remove_network_parameter(self):
        test_dir_path = os.path.join(parent_dir, "res/remove_network_parameter")
        update_XML_script = os.path.join(test_dir_path, "remove_network_parameter.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path)
