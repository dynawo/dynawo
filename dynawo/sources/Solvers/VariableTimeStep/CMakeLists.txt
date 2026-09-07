
# Copyright (c) 2021, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools
# for power systems.

#
# Custom target for describing solvers
#
add_custom_target(variable_time_step
    DEPENDS VARIABLE_TIME_STEP_FILES_INSTALL
    COMMENT "Describing IDA solver"
    )

#
# Target used to install solvers files in ddbdir
# (.so and .desc.xml)
#
add_custom_target(VARIABLE_TIME_STEP_FILES_INSTALL
    COMMENT "Installing variable time step IDA solver"
    )

add_subdirectory(SolverIDA)
