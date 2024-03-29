
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
#
set(SOLVER_TRAP_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(SOLVER_TRAP_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(SOLVER_TRAP_SOURCES
  DYNSolverTRAP.cpp
  )

set(SOLVER_TRAP_INCLUDE_HEADERS
  DYNSolverTRAP.h
  )

add_library(dynawo_SolverTRAP SHARED ${SOLVER_TRAP_SOURCES})

target_include_directories(dynawo_SolverTRAP
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    $<TARGET_PROPERTY:dynawo_SolverCommon,INTERFACE_INCLUDE_DIRECTORIES>
  PRIVATE
    $<TARGET_PROPERTY:dynawo_ModelerCommon,INTERFACE_INCLUDE_DIRECTORIES>
  PUBLIC
    $<TARGET_PROPERTY:Sundials::Sundials_NVECSERIAL,INTERFACE_INCLUDE_DIRECTORIES>
)
target_include_directories(dynawo_SolverTRAP SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_SolverTRAP
  PRIVATE
    dynawo_Common
    dynawo_API_PAR
    dynawo_API_TL
    dynawo_SolverCommon
    dynawo_SolverKINSOL
    dynawo_SolverCommonFixedTimeStep
  )

set_target_properties(dynawo_SolverTRAP PROPERTIES VERSION ${SOLVER_TRAP_VERSION_STRING}
                                                SOVERSION ${SOLVER_TRAP_VERSION_MAJOR}
                                                   PREFIX "")

install(TARGETS dynawo_SolverTRAP EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${SOLVER_TRAP_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

desc_solver(dynawo_SolverTRAP)

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
