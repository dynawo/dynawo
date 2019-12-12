# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

SET(SOLVER_SIM_VERSION_STRING ${DYNAWO_VERSION_STRING})
SET(SOLVER_SIM_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

SET(SOLVER_SIM_SOURCES
  DYNSolverSIM.cpp
  )

SET(SOLVER_SIM_INCLUDE_HEADERS
  DYNSolverSIM.h
  )

ADD_LIBRARY(dynawo_SolverSIM SHARED ${SOLVER_SIM_SOURCES})

TARGET_INCLUDE_DIRECTORIES(dynawo_SolverSIM
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
)

TARGET_LINK_LIBRARIES(dynawo_SolverSIM
  dynawo_SolverKINSOL
)

SET_TARGET_PROPERTIES(dynawo_SolverSIM PROPERTIES VERSION ${SOLVER_SIM_VERSION_STRING}
                                                SOVERSION ${SOLVER_SIM_VERSION_MAJOR}
                                                   PREFIX "")

INSTALL(TARGETS dynawo_SolverSIM EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
INSTALL(FILES ${SOLVER_SIM_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

DESC_SOLVER(dynawo_SolverSIM)
