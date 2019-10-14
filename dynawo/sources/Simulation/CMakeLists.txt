# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

SET(SIM_VERSION_STRING ${DYNAWO_VERSION_STRING})
SET(SIM_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

SET(SIM_SOURCES
    DYNSimulation.cpp
    DYNSimulationLauncher.cpp
    )

SET(SIM_INCLUDE_HEADERS
    DYNSimulation.h
    DYNSimulationLauncher.h
    )

ADD_LIBRARY(dynawo_Simulation ${LIBRARY_TYPE} ${SIM_SOURCES})

TARGET_INCLUDE_DIRECTORIES(dynawo_Simulation
    INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../>
        $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    )

TARGET_LINK_LIBRARIES(dynawo_Simulation
    PUBLIC
      dynawo_SimulationCommon
      dynawo_API_CSTR
      dynawo_API_JOB
      dynawo_SolverCommon
      dynawo_DataInterface
      libZIP::libZIP
      LibArchive::LibArchive
      ZLIB::ZLIB
    )

SET_TARGET_PROPERTIES(dynawo_Simulation PROPERTIES VERSION ${SIM_VERSION_STRING}
                                                 SOVERSION ${SIM_VERSION_MAJOR})

INSTALL(TARGETS dynawo_Simulation EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
INSTALL(FILES ${SIM_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})


SET(SIMCOMMON_VERSION_STRING ${DYNAWO_VERSION_STRING})
SET(SIMCOMMON_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

SET(SIMCOMMON_SOURCES
    DYNSignalHandler.cpp
    DYNSimulationContext.cpp
    )

SET(SIMCOMMON_INCLUDE_HEADERS
    DYNSignalHandler.h
    DYNSimulationContext.h
    )

ADD_LIBRARY(dynawo_SimulationCommon ${LIBRARY_TYPE} ${SIMCOMMON_SOURCES})

TARGET_INCLUDE_DIRECTORIES(dynawo_SimulationCommon
    INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    )

SET_TARGET_PROPERTIES(dynawo_SimulationCommon PROPERTIES VERSION ${SIMCOMMON_VERSION_STRING}
                                                       SOVERSION ${SIMCOMMON_VERSION_MAJOR})

INSTALL(TARGETS dynawo_SimulationCommon EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
INSTALL(FILES ${SIMCOMMON_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
