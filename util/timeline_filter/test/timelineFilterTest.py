# -*- coding: utf-8 -*-

# Copyright (c) 2021, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
# for power systems.

import os
import sys
import unittest
import filecmp

try:
    timelineFilter_dir = os.environ["DYNAWO_TIMELINE_FILTER_DIR"]
    sys.path.append(timelineFilter_dir)
    import timelineFilter
except:
    print ("Failed to import timeline filter")
    sys.exit(1)

class TestTimelineFilter(unittest.TestCase):
    def test_timeline_model_filter(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        if os.path.exists(os.path.join(dir_path, "filtered_timeline.log")):
            os.remove(os.path.join(dir_path,"filtered_timeline.log"))
        timelineFilter.main(["--timelineFile",os.path.join(dir_path, "timeline.log"),"--model", "GEN____8_SM"])
        self.assertEqual(True, os.path.exists(os.path.join(dir_path, "filtered_timeline.log")))
        self.assertEqual(True, filecmp.cmp(os.path.join(dir_path, "filtered_timeline.log"), os.path.join(dir_path, "filtered_timeline_model_ref.log"), shallow = False))

# the main function
if __name__ == "__main__":
    unittest.main()
