# -*- coding: utf-8 -*-

# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain
# simulation tool for power systems.

import os
import sys
import unittest


nrtDiff_dir = os.environ["DYNAWO_NRT_DIFF_DIR"]
sys.path.append(nrtDiff_dir)
import nrtDiff
import settings

class TestnrtDiffCompareTwoFiles(unittest.TestCase):
    def test_log(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "dynawo.log"), '|', os.path.join(dir_path, "dynawo2.log"), '|')
        message = message.replace("<font color=\"red\">", "")
        message = message.replace("</font>", "")
        message = message.replace(":  ", ": ")
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        self.assertEqual(message, "nrt_diff/test/dynawo.log: 2 differences")

    def test_curves_different(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "curves.csv"), '|', os.path.join(dir_path, "curves2.csv"), '|')
        message = message.replace("<font color=\"red\">", "")
        message = message.replace("</font>", "")
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        self.assertEqual(set(message.split(' , ')), {"nrt_diff/test/curves.csv: 6 absolute errors coming from more than 5 curves"})

    def test_curves_xml(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "curves.xml"), '|', os.path.join(dir_path, "curves2.xml"), '|')
        message = message.replace("<font color=\"red\">", "")
        message = message.replace("</font>", "")
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        self.assertEqual(message, "nrt_diff/test/curves.xml: 1 absolute errors , NETWORK_BELLAP41_U_value")

    def test_curves_max_dtw(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        settings.dtw_exceptions = {"curves3.csv" : 73, "curves3.xml" : 50}
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "curves.csv"), '|', os.path.join(dir_path, "curves3.csv"), '|')
        message = message.replace("<font color=\"red\">", "")
        message = message.replace("</font>", "")
        self.assertEqual(return_value, nrtDiff.IDENTICAL)
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "curves.xml"), '|', os.path.join(dir_path, "curves3.xml"), '|')
        message = message.replace("<font color=\"red\">", "")
        message = message.replace("</font>", "")
        self.assertEqual(return_value, nrtDiff.IDENTICAL)
        settings.dtw_exceptions = {}
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "curves.csv"), '|', os.path.join(dir_path, "curves3.csv"), '|')
        message = message.replace("<font color=\"red\">", "")
        message = message.replace("</font>", "")
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        self.assertEqual(set(message.split(' , ')), {"nrt_diff/test/curves.csv: 6 absolute errors coming from more than 5 curves"})
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "curves.xml"), '|', os.path.join(dir_path, "curves3.xml"), '|')
        message = message.replace("<font color=\"red\">", "")
        message = message.replace("</font>", "")
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        self.assertEqual(message, "nrt_diff/test/curves.xml: 1 absolute errors , NETWORK_BELLAP41_U_value")


    def test_timeline_log(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "timeline.log"), '|', os.path.join(dir_path, "timeline2.log"), '|')
        self.assertEqual(return_value, nrtDiff.IDENTICAL)
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "timeline.log"), '|', os.path.join(dir_path, "timeline3.log"), '|')
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        message = message.replace("<font color=\"red\">", "")
        message = message.replace("</font>", "")
        message = message.replace(":  ", ": ")
        self.assertEqual(message, "nrt_diff/test/timeline.log: 1 difference")

    def test_timeline_xml(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "timeline.xml"), '|', os.path.join(dir_path, "timeline2.xml"), '|')
        self.assertEqual(return_value, nrtDiff.IDENTICAL)
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "timeline.xml"), '|', os.path.join(dir_path, "timeline3.xml"), '|')
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        message = message.replace("<font color=\"red\">", "")
        message = message.replace("</font>", "")
        message = message.replace(":  ", ": ")
        self.assertEqual(message, "nrt_diff/test/timeline.xml: 1 difference")

    def test_other_xml(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "result.xml"), '|', os.path.join(dir_path, "result2.xml"), '|')
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        message = message.replace("<font color=\"red\">", "")
        message = message.replace("</font>", "")
        self.assertEqual(message, "Problem with result.xml")

    def test_output_iidm(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "outputIIDM.xml"), '|', os.path.join(dir_path, "outputIIDM2.xml"), '|')
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        message = message.replace("<font color=\"red\">", "")
        message = message.replace("</font>", "")
        self.assertEqual(message, "nrt_diff/test/outputIIDM.xml: 2 different output values\n[ERROR] attribute bus of object BVIL7T 1 (type generator) value: FSLACK11 is not in the equivalent object on right side\n[ERROR] attribute v of object FF11 (type bus) has different values (delta = 1.0) \n")

    def test_output_iidm_powsybl(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "outputIIDMPowSybl.xml"), '|', os.path.join(dir_path, "outputIIDMPowSybl2.xml"), '|')
        self.assertEqual(return_value, nrtDiff.IDENTICAL)

    def test_constraints_xml(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "constraints.xml"), '|', os.path.join(dir_path, "constraints2.xml"), '|')
        self.assertEqual(return_value, nrtDiff.IDENTICAL)
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "constraints.xml"), '|', os.path.join(dir_path, "constraints3.xml"), '|')
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        message = message.replace("<font color=\"red\">", "")
        message = message.replace("</font>", "")
        self.assertEqual(message, "nrt_diff/test/constraints.xml: 13 different output values\n\
[ERROR] object BUS_DESC_DIFF_787_U < Umin is in left path but not in right one\n\
[ERROR] object BUS_NAME_DIFF_781_U < Umin is in left path but not in right one\n\
[ERROR] object BUS_TIME_DIFF_787_U < Umin is in left path but not in right one\n\
[ERROR] object BUS_DESC_DIFF_787_U < Umin2 is in right path but not in left one\n\
[ERROR] object BUS_NAME_DIFF2_781_U < Umin is in right path but not in left one\n\
[ERROR] object BUS_ONLY_ON_RIGHT_SIDE_778_U < Umin is in right path but not in left one\n\
[ERROR] object BUS_TIME_DIFF_789_U < Umin is in right path but not in left one\n\
[ERROR] object BUS_DURATION_DIFF_787_U < Umin has different acceptable durations in the two files\n\
[ERROR] object BUS_KIND_DIFF_787_U < Umin has different kinds in the two files\n\
[ERROR] object BUS_LIMIT_DIFF_787_U < Umin has different limits in the two files\n\
[ERROR] object BUS_SIDE_DIFF_787_U < Umin has different sides in the two files\n\
[ERROR] object BUS_TYPE_DIFF_787_U < Umin has different types in the two files\n\
[ERROR] values of object BUS_LARGE_VALUE_DIFF_778_U < Umin are different (delta = 2.0) \n")

    def test_constraints_txt(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "constraints.txt"), '|', os.path.join(dir_path, "constraints2.txt"), '|')
        self.assertEqual(return_value, nrtDiff.IDENTICAL)
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "constraints.txt"), '|', os.path.join(dir_path, "constraints3.txt"), '|')
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        message = message.replace("<font color=\"red\">", "")
        message = message.replace("</font>", "")
        self.assertEqual(message, "nrt_diff/test/constraints.txt: 17 different output values\n\
[ERROR] object BUS_DESC_DIFF_787_U &lt; Umin is in left path but not in right one\n\
[ERROR] object BUS_NAME_DIFF_781_U &lt; Umin is in left path but not in right one\n\
[ERROR] object BUS_TIME_DIFF_787_U &lt; Umin is in left path but not in right one\n\
[ERROR] object BUS_DESC_DIFF_787_U &lt; Umin2 is in right path but not in left one\n\
[ERROR] object BUS_NAME_DIFF2_781_U &lt; Umin is in right path but not in left one\n\
[ERROR] object BUS_ONLY_ON_RIGHT_SIDE_778_U &lt; Umin is in right path but not in left one\n\
[ERROR] object BUS_TIME_DIFF_789_U &lt; Umin is in right path but not in left one\n\
[ERROR] object BUS_DURATION_DIFF_787_U &lt; Umin has different acceptable durations in the two files\n\
[ERROR] object BUS_DURATION_DIFF_NO_TYPE_787_U &lt; Umin has different acceptable durations in the two files\n\
[ERROR] object BUS_KIND_DIFF_787_U &lt; Umin has different kinds in the two files\n\
[ERROR] object BUS_KIND_DIFF_NO_TYPE_787_U &lt; Umin has different kinds in the two files\n\
[ERROR] object BUS_LIMIT_DIFF_787_U &lt; Umin has different limits in the two files\n\
[ERROR] object BUS_LIMIT_DIFF_NO_TYPE_787_U &lt; Umin has different limits in the two files\n\
[ERROR] object BUS_SIDE_DIFF_787_U &lt; Umin has different sides in the two files\n\
[ERROR] object BUS_SIDE_DIFF_NO_TYPE_787_U &lt; Umin has different sides in the two files\n\
[ERROR] object BUS_TYPE_DIFF_787_U &lt; Umin has different types in the two files\n\
[ERROR] values of object BUS_LARGE_VALUE_DIFF_778_U &lt; Umin are different (delta = 2.0) \n")

    def test_fsv_xml(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "finalStateValues.xml"), '|', os.path.join(dir_path, "finalStateValues2.xml"), '|')
        self.assertEqual(return_value, nrtDiff.IDENTICAL)
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "finalStateValues.xml"), '|', os.path.join(dir_path, "finalStateValues3.xml"), '|')
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        message = message.replace("<font color=\"red\">", "")
        message = message.replace("</font>", "")
        self.assertEqual(message, "nrt_diff/test/finalStateValues.xml: 6 different output values\n\
[ERROR] object modelDifferentName_variable is in left path but not in right one\n\
[ERROR] object modelDifferentVariable_variable is in left path but not in right one\n\
[ERROR] object modelDifferentName2_variable is in right path but not in left one\n\
[ERROR] object modelDifferentVariable_variable2 is in right path but not in left one\n\
[ERROR] object modelNotThere_variable is in right path but not in left one\n\
[ERROR] values of object modelDifferentValue_variable are different (delta = 3.0) \n")

    def test_fsv_csv(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "finalStateValues.csv"), '|', os.path.join(dir_path, "finalStateValues2.csv"), '|')
        self.assertEqual(return_value, nrtDiff.IDENTICAL)
        (return_value, message) = nrtDiff.CompareTwoFiles(os.path.join(dir_path, "finalStateValues.csv"), '|', os.path.join(dir_path, "finalStateValues3.csv"), '|')
        self.assertEqual(return_value, nrtDiff.DIFFERENT)
        message = message.replace("<font color=\"red\">", "")
        message = message.replace("</font>", "")
        self.assertEqual(message, "nrt_diff/test/finalStateValues.csv: 6 different output values\n\
[ERROR] object modelDifferentName_variable is in left path but not in right one\n\
[ERROR] object modelDifferentVariable_variable is in left path but not in right one\n\
[ERROR] object modelDifferentName2_variable is in right path but not in left one\n\
[ERROR] object modelDifferentVariable_variable2 is in right path but not in left one\n\
[ERROR] object modelNotThere_variable is in right path but not in left one\n\
[ERROR] values of object modelDifferentValue_variable are different (delta = 3.0) \n")

class TestnrtDiffDirectoryDiff(unittest.TestCase):
    def test_directory_diff(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (diff_statuses, return_message_str, file_names, left_paths, right_paths, diff_messages) = nrtDiff.DirectoryDiff (os.path.join(dir_path, "initValues"), os.path.join(dir_path, "initValues2"), True)
        for i in range(len(file_names)):
            if file_names[i] == "globalInit/dumpInitValues-_LOAD___3_EC.txt":
                self.assertEqual(diff_statuses[i], nrtDiff.IDENTICAL)
            else:
                self.assertEqual(diff_statuses[i], nrtDiff.DIFFERENT)
        return_message_str = return_message_str.replace("<font color=\"red\">", "")
        return_message_str = return_message_str.replace("</font>", "")
        if return_message_str.startswith("globalInit/dumpInitValues-GEN____1_SM.txt") :
            self.assertEqual(return_message_str, "globalInit/dumpInitValues-GEN____1_SM.txt DIFFERENT (initValues/globalInit/dumpInitValues-GEN____1_SM.txt: 1 different initial values)\nglobalInit/dumpInitValues-_LOAD___2_EC.txt DIFFERENT (initValues/globalInit/dumpInitValues-_LOAD___2_EC.txt: 1 different initial values)\n(all other files are identical)\n")
        else:
            self.assertEqual(return_message_str, "globalInit/dumpInitValues-_LOAD___2_EC.txt DIFFERENT (initValues/globalInit/dumpInitValues-_LOAD___2_EC.txt: 1 different initial values)\nglobalInit/dumpInitValues-GEN____1_SM.txt DIFFERENT (initValues/globalInit/dumpInitValues-GEN____1_SM.txt: 1 different initial values)\n(all other files are identical)\n")
        self.assertEqual(len(file_names), 3)
        for file in file_names:
            if "GEN" in file:
                self.assertEqual(file, "globalInit/dumpInitValues-GEN____1_SM.txt")
            elif "LOAD___2" in file:
                self.assertEqual(file, "globalInit/dumpInitValues-_LOAD___2_EC.txt")
            elif "LOAD___3" in file:
                self.assertEqual(file, "globalInit/dumpInitValues-_LOAD___3_EC.txt")
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
            if len(msg) > 0:
                self.assertTrue("1 different initial values" in msg)
            i += 1

    def test_reference_diff(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        (diff_statuses, return_message_str) = nrtDiff.DirectoryDiffReferenceDataJob (os.path.join(dir_path, "test.jobs"))
        self.assertEqual(diff_statuses, nrtDiff.DIFFERENT)
        self.assertEqual(len(return_message_str), 1)
        return_message_str[0] = return_message_str[0].replace("<font color=\"red\">", "")
        return_message_str[0] = return_message_str[0].replace("</font>", "")
        if "output/Job2/curves.csv: 6 absolute errors coming from more than 5 curves" not in return_message_str[0]:
            self.assertTrue(False)


# the main function
if __name__ == "__main__":
    unittest.main()
