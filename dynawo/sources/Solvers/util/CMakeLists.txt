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

INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIR}
                    ${LibXML_INCLUDE_DIR}
                    ${SUNDIALS_INCLUDE_DIR}
                    )

INCLUDE_DIRECTORIES(../Common
                    ../SolverIDA
                    ../SolverSIM
                    ../../Common
                    ../../Modeler/Common/
                    )

ADD_EXECUTABLE(dumpSolver ${DUMP_SOLVER_SOURCES})

TARGET_LINK_LIBRARIES(dumpSolver
                      XMLSAXFormatter${LibXML_LINK_SUFFIX}
                      XMLSAXParser${LibXML_LINK_SUFFIX}
                      dynawo_API_PAR
                      dynawo_Common
                      dynawo_SolverCommon
                      dynawo_SolverKINSOL
                      dynawo_API_TL
                      "-Wl,--whole-archive"
                      dynawo_Util
                      "-Wl,--no-whole-archive"
                      ${Boost_PROGRAM_OPTIONS_LIBRARY}
                      pthread
                      ${Boost_THREAD_LIBRARY}
                      "-rdynamic"
                      )

INSTALL(TARGETS dumpSolver DESTINATION ${sbindir})
