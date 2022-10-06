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

# files and directories filters
directories_included = [("*", "*")]
directories_excluded = [(".svn", "*"), ("*", ".svn"), ("*", "BDD"), ("compilation", "*")]
files_included = ["*.csv", "*.log", "*.xml", "*.h", "*.c", "*.cpp", "*.txt"]
files_excluded = []

# comparison
logs_default_separator = "|"
logs_pattern_to_avoid = ['| DYNAWO VERSION  :     ', '| DYNAWO REVISION :', '=====================================', 'REVISION DYNAWO :'] # logs file patterns to avoid
max_DTW = 0.1 # None to avoid checking
max_iidm_cmp_tol=1e-6
max_nb_iidm_outputs=10

# strict maximum number of threads
maximum_threads_nb = 4

# log destination
logs_destination = "text file" # "console" or "text file"
logs_file_path = os.path.join(os.path.dirname(__file__), "nrtDiff.txt")

dtw_exceptions = {}
