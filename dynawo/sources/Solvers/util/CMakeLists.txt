# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

#################################
#        dumpSolver              #
#################################
SET(DUMP_SOLVER_SOURCES
    DYNDumpSolver.cpp
    )

ADD_EXECUTABLE(dumpSolver ${DUMP_SOLVER_SOURCES})

TARGET_INCLUDE_DIRECTORIES(dumpSolver PRIVATE ${SUNDIALS_INCLUDE_DIR})

TARGET_LINK_LIBRARIES(dumpSolver
    dynawo_SolverCommon
    )

INSTALL(TARGETS dumpSolver EXPORT dynawo-targets DESTINATION ${SBINDIR_NAME})
