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
    import nrtUtils
except:
    print("Failed to import non-regression test diff")
    sys.exit(1)


class TestBasicNrtUtils(unittest.TestCase):
    def test_launch(self):
        case_path = os.path.join(os.path.dirname(__file__), "cases")
        test = nrtUtils.TestCase("case_0", "cases", "Test case", os.path.join(
            case_path, "IEEE14.jobs"), 1, "ALLOWED", [0])
        test.launch(1)


# the main function
if __name__ == "__main__":
    unittest.main()
