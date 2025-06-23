# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

set(SIM_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(SIM_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(SIM_SOURCES
      DYNSimulation.cpp
      DYNSimulationRT.cpp
      DYNSimulationLauncher.cpp
      DYNEventSubscriber.cpp
      DYNZmqPublisher.cpp
      )

set(SIM_INCLUDE_HEADERS
      DYNSimulation.h
      DYNSimulationRT.h
      DYNSimulationLauncher.h
      DYNEventSubscriber.h
      DYNZmqPublisher.h
      )

add_library(dynawo_Simulation SHARED ${SIM_SOURCES})


target_include_directories(dynawo_Simulation
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )

  find_package(ZMQPP REQUIRED)

  target_link_libraries(dynawo_Simulation
  PUBLIC
    dynawo_SolverCommon
    libZIP::libZIP
  PRIVATE
    dynawo_Common
    dynawo_SimulationCommon
    dynawo_API_JOB
    dynawo_API_CRV
    dynawo_API_FSV
    dynawo_API_CRT
    dynawo_API_PAR
    dynawo_API_TL
    dynawo_API_CSTR
    dynawo_API_LEQ
    dynawo_API_WSC
    dynawo_ModelerCommon
    dynawo_DataInterface
    dynawo_DataInterfaceFactory
    Boost::filesystem
    Boost::serialization
    ${ZMQPP_LIBRARIES}
  )

set_target_properties(dynawo_Simulation PROPERTIES VERSION ${SIM_VERSION_STRING}
                                                 SOVERSION ${SIM_VERSION_MAJOR})

install(TARGETS dynawo_Simulation EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${SIM_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})


set(SIMCOMMON_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(SIMCOMMON_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(SIMCOMMON_SOURCES
    DYNSignalHandler.cpp
    DYNSimulationContext.cpp
    DYNTimeManager.cpp
    )

set(SIMCOMMON_INCLUDE_HEADERS
    DYNSignalHandler.h
    DYNSimulationContext.h
    DYNTimeManager.h
    )

add_library(dynawo_SimulationCommon SHARED ${SIMCOMMON_SOURCES})

target_include_directories(dynawo_SimulationCommon
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    ${ZMQPP_INCLUDE_DIRS}
  )

target_link_libraries(dynawo_SimulationCommon
  PRIVATE
    dynawo_Interface
  )

set_target_properties(dynawo_SimulationCommon PROPERTIES VERSION ${SIMCOMMON_VERSION_STRING}
                                                       SOVERSION ${SIMCOMMON_VERSION_MAJOR})

install(TARGETS dynawo_SimulationCommon EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${SIMCOMMON_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
