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
import filecmp
import subprocess
parent_dir = os.path.dirname(__file__)
sources_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..'))
sys.path.append(sources_dir)


class TestTicket(unittest.TestCase):

    def test_select_tickets(self):
        test_dir_path = os.path.join(parent_dir, "res/select_tickets")
        update_XML_script = os.path.join(test_dir_path, "select_tickets.py")
        input_job_file_path = os.path.join(test_dir_path, "inputs/fic_JOB.xml")
        output_dyd_file_path = os.path.join(test_dir_path, "outputs1.4.0/fic_DYD.xml")
        ref_dyd_file_path = os.path.join(test_dir_path, "reference/fic_DYD.xml")
        project_env = dict(os.environ)
        project_env['PYTHONPATH'] = os.path.abspath(os.path.join(os.path.dirname(__file__), '../..'))
        subprocess.run(["python", update_XML_script,
                        "--job", input_job_file_path,
                        "--origin", "1.3.0",
                        "--version", "1.4.0",
                        "--tickets", "11,33,66",
                        "-o", test_dir_path], stdout=subprocess.DEVNULL, env=project_env)
        self.assertTrue(filecmp.cmp(output_dyd_file_path, ref_dyd_file_path))
