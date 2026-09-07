# -*- coding: utf-8 -*-

# Copyright (c) 2021, RTE (http://www.rte-france.com)
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


try:
    nrtDiff_dir = os.environ["DYNAWO_NRT_DIFF_DIR"]
    sys.path.append(nrtDiff_dir)
    import defineTestReference
    import nrtUtils
    import nrtDiff
except:
    print("Failed to import non-regression test diff")
    sys.exit(1)


class TestDefineReference(unittest.TestCase):
    def test_find_output(self):
        test_case = nrtDiff.TestCase("test")
        test_case.directory_ = os.path.dirname(__file__)
        test_case.jobs_file_ = os.path.join(os.path.dirname(
            __file__), "defineTestReference", "IEEE14.jobs")
        list = defineTestReference.findOutputFile(test_case)
        self.assertEqual(list, ['outputs/timeLine/timeline.log',
                          'outputs/curves/curves.csv', 'outputs/logs/dynawo.log'])


# the main function
if __name__ == "__main__":
    unittest.main()
