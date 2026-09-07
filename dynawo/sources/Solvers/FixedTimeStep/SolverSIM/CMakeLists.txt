# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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
set(SOLVER_SIM_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(SOLVER_SIM_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(SOLVER_SIM_SOURCES
  DYNSolverSIM.cpp
  )

set(SOLVER_SIM_INCLUDE_HEADERS
  DYNSolverSIM.h
  )

add_library(dynawo_SolverSIM SHARED ${SOLVER_SIM_SOURCES})

target_include_directories(dynawo_SolverSIM
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    $<TARGET_PROPERTY:dynawo_SolverCommon,INTERFACE_INCLUDE_DIRECTORIES>
  PRIVATE
    $<TARGET_PROPERTY:dynawo_ModelerCommon,INTERFACE_INCLUDE_DIRECTORIES>
  PUBLIC
    $<TARGET_PROPERTY:Sundials::Sundials_NVECSERIAL,INTERFACE_INCLUDE_DIRECTORIES>
)
target_include_directories(dynawo_SolverSIM SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_SolverSIM
  PRIVATE
    dynawo_Common
    dynawo_API_PAR
    dynawo_API_TL
    dynawo_SolverCommon
    dynawo_SolverKINSOL
    dynawo_SolverCommonFixedTimeStep
  )

set_target_properties(dynawo_SolverSIM PROPERTIES VERSION ${SOLVER_SIM_VERSION_STRING}
                                                SOVERSION ${SOLVER_SIM_VERSION_MAJOR}
                                                   PREFIX "")

install(TARGETS dynawo_SolverSIM EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${SOLVER_SIM_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

desc_solver(dynawo_SolverSIM)

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
