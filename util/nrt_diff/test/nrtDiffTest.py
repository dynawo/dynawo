# -*- coding: utf-8 -*-

# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain
# simulation tool for power systems.

import os
import sys
import unittest


try:
    nrtDiff_dir = os.environ["DYNAWO_NRT_DIFF_DIR"]
    sys.path.append(nrtDiff_dir)
    import nrtDiff
except:
    print ("Failed to import non-regression test diff")
    sys.exit(1)

class TestnrtDiffCompareTwoFiles(unittest.TestCase):
    def test_log(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "dynawo.log"), '|', os.path.join(dir_path, "dynawo2.log"), '|')
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        self.assertEqual(message, "nrt_diff/test/dynawo.log: 2 differences")

    def test_curves_different(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "curves.csv"), '|', os.path.join(dir_path, "curves2.csv"), '|')
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        self.assertEqual(message, "nrt_diff/test/curves.csv: 5 absolute errors , GEN____8_SM_generator_UStatorPu , GEN____6_SM_voltageRegulator_EfdPu , GEN____8_SM_voltageRegulator_EfdPu , GEN____1_SM_voltageRegulator_EfdPu , GEN____2_SM_voltageRegulator_EfdPu")

    def test_curves_xml(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "curves.xml"), '|', os.path.join(dir_path, "curves2.xml"), '|')
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        self.assertEqual(message, "nrt_diff/test/curves.xml: 1 absolute errors , NETWORK_BELLAP41_U_value")

    def test_timeline_log(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "timeline.log"), '|', os.path.join(dir_path, "timeline2.log"), '|')
        self.assertEqual(return_value, nrtDiff.IDENTICAL)
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "timeline.log"), '|', os.path.join(dir_path, "timeline3.log"), '|')
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        self.assertEqual(message, "nrt_diff/test/timeline.log: 1 difference")

    def test_timeline_xml(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "timeline.xml"), '|', os.path.join(dir_path, "timeline2.xml"), '|')
        self.assertEqual(return_value, nrtDiff.IDENTICAL)
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "timeline.xml"), '|', os.path.join(dir_path, "timeline3.xml"), '|')
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        self.assertEqual(message, "nrt_diff/test/timeline.xml: 1 difference")

    def test_other_xml(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "result.xml"), '|', os.path.join(dir_path, "result2.xml"), '|')
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        self.assertEqual(message, "Problem with result.xml")

class TestnrtDiffDirectoryDiff(unittest.TestCase):
    def test_directory_diff(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (diff_statuses, return_message_str, file_names, left_paths, right_paths, diff_messages) = nrtDiff.DirectoryDiff (os.path.join(dir_path, "initValues"), os.path.join(dir_path, "initValues2"), True)
        for status in diff_statuses:
            self.assertEqual(status, nrtDiff.DIFFERENT)
        if return_message_str.startswith("globalInit/dumpInitValues-GEN____1_SM.txt") :
            self.assertEqual(return_message_str, "globalInit/dumpInitValues-GEN____1_SM.txt DIFFERENT (Problem with dumpInitValues-GEN____1_SM.txt)\nglobalInit/dumpInitValues-_LOAD___2_EC.txt DIFFERENT (Problem with dumpInitValues-_LOAD___2_EC.txt)\n(all other files are identical)\n")
        else:
            self.assertEqual(return_message_str, "globalInit/dumpInitValues-_LOAD___2_EC.txt DIFFERENT (Problem with dumpInitValues-_LOAD___2_EC.txt)\nglobalInit/dumpInitValues-GEN____1_SM.txt DIFFERENT (Problem with dumpInitValues-GEN____1_SM.txt)\n(all other files are identical)\n")
        for file in file_names:
            if "GEN" in file:
                self.assertEqual(file, "globalInit/dumpInitValues-GEN____1_SM.txt")
            elif "LOAD" in file:
                self.assertEqual(file, "globalInit/dumpInitValues-_LOAD___2_EC.txt")
            else:
                assert(0)
        i = 0
        for file in left_paths:
            self.assertEqual(file, os.path.join(dir_path, os.path.join("initValues",file_names[i])))
            i += 1
        i = 0
        for file in right_paths:
            self.assertEqual(file, os.path.join(dir_path, os.path.join("initValues2",file_names[i])))
            i += 1
        i = 0
        for msg in diff_messages:
            self.assertEqual(msg, "Problem with " + os.path.basename(file_names[i]))
            i += 1

# the main function
if __name__ == "__main__":
    unittest.main()
