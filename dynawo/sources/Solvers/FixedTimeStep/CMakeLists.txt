
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

set(SOLVER_COMMON_FIXED_TIME_STEP_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(SOLVER_COMMON_FIXED_TIME_STEP_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(SOLVER_COMMON_FIXED_TIME_STEP_SOURCES
  DYNSolverCommonFixedTimeStep.cpp
  )

set(SOLVER_COMMON_FIXED_TIME_STEP_INCLUDE_HEADERS
  DYNSolverCommonFixedTimeStep.h
  )

add_library(dynawo_SolverCommonFixedTimeStep SHARED ${SOLVER_COMMON_FIXED_TIME_STEP_SOURCES})

target_include_directories(dynawo_SolverCommonFixedTimeStep
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    $<TARGET_PROPERTY:dynawo_SolverCommon,INTERFACE_INCLUDE_DIRECTORIES>
  PRIVATE
    $<TARGET_PROPERTY:dynawo_ModelerCommon,INTERFACE_INCLUDE_DIRECTORIES>
  PUBLIC
    $<TARGET_PROPERTY:Sundials::Sundials_NVECSERIAL,INTERFACE_INCLUDE_DIRECTORIES>
)
target_include_directories(dynawo_SolverCommonFixedTimeStep SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_SolverCommonFixedTimeStep
  PRIVATE
    dynawo_Common
    dynawo_API_PAR
    dynawo_API_TL
    dynawo_SolverCommon
    dynawo_SolverKINSOL
  )

set_target_properties(dynawo_SolverCommonFixedTimeStep PROPERTIES VERSION ${SOLVER_COMMON_FIXED_TIME_STEP_VERSION_STRING}
                                                SOVERSION ${SOLVER_COMMON_FIXED_TIME_STEP_VERSION_MAJOR})

install(TARGETS dynawo_SolverCommonFixedTimeStep EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${SOLVER_COMMON_FIXED_TIME_STEP_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

add_subdirectory(SolverSIM)
add_subdirectory(SolverTRAP)
