# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
# 
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

SET(SOLVER_IDA_VERSION_STRING ${DYNAWO_VERSION_STRING})
SET(SOLVER_IDA_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

SET(SOLVER_IDA_SOURCES
    DYNSolverIDA.cpp
    )

SET(SOLVER_IDA_INCLUDE_HEADERS
    DYNSolverIDA.h
    )

INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIR}
                    ${KLU_INCLUDE_DIR}
                    ${SUNDIALS_INCLUDE_DIR}
                    )

INCLUDE_DIRECTORIES(../../API/PAR
                    ../../Common
                    ../../Modeler/Common
                    ../Common
                    ../SolverKINSOL
                    )

ADD_LIBRARY(dynawo_SolverIDA SHARED ${SOLVER_IDA_SOURCES})

TARGET_LINK_LIBRARIES(dynawo_SolverIDA
                      dynawo_API_PAR
                      dynawo_Common
                      dynawo_SolverKINSOL
                      ${SUNDIALS_IDA_LIBRARY}
                      ${SUNDIALS_NVECSERIAL_LIBRARY}
                      ${SUITESPARSE_LIBRARIES}
                      )

IF(${NICSLU_FOUND})
  TARGET_LINK_LIBRARIES(dynawo_SolverIDA ${NICSLU_LIBRARY})
ENDIF()

SET_TARGET_PROPERTIES(dynawo_SolverIDA PROPERTIES VERSION ${SOLVER_IDA_VERSION_STRING}
                                           SOVERSION ${SOLVER_IDA_VERSION_MAJOR})

INSTALL(TARGETS dynawo_SolverIDA DESTINATION ${libdir})
INSTALL(FILES ${SOLVER_IDA_INCLUDE_HEADERS} DESTINATION ${includedir})

DESC_SOLVER(dynawo_SolverIDA)
