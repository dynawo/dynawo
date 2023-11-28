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
sys.path.append(sources_dir)

from utils import launch_test


class TestCurves(unittest.TestCase):

    def test_change_curves_variable_name(self):
        test_dir_path = os.path.join(parent_dir, "res/change_curves_variable_name")
        update_XML_script = os.path.join(test_dir_path, "change_curves_variable_name.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path, test_crv=True)

    def test_remove_curves_variable(self):
        test_dir_path = os.path.join(parent_dir, "res/remove_curves_variable")
        update_XML_script = os.path.join(test_dir_path, "remove_curves_variable.py")
        launch_test(self, test_dir_path, update_XML_script, test_dir_path, test_crv=True)
