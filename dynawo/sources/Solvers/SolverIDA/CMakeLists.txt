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

ADD_LIBRARY(dynawo_SolverIDA SHARED ${SOLVER_IDA_SOURCES})

TARGET_INCLUDE_DIRECTORIES(dynawo_SolverIDA
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
)

TARGET_LINK_LIBRARIES(dynawo_SolverIDA
  PUBLIC
    dynawo_SolverKINSOL
    Sundials::Sundials_IDA
)

SET_TARGET_PROPERTIES(dynawo_SolverIDA PROPERTIES VERSION ${SOLVER_IDA_VERSION_STRING}
                                                SOVERSION ${SOLVER_IDA_VERSION_MAJOR}
                                                   PREFIX "")

INSTALL(TARGETS dynawo_SolverIDA EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
INSTALL(FILES ${SOLVER_IDA_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

DESC_SOLVER(dynawo_SolverIDA)
