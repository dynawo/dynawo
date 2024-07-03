# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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
set(SOLVER_SIMI_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(SOLVER_SIMI_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(SOLVER_SIMI_SOURCES
  DYNSolverSIMi.cpp
  )

set(SOLVER_SIMI_INCLUDE_HEADERS
  DYNSolverSIMi.h
  )

add_library(dynawo_SolverSIMi SHARED ${SOLVER_SIMI_SOURCES})

target_include_directories(dynawo_SolverSIMi
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    $<TARGET_PROPERTY:dynawo_SolverCommon,INTERFACE_INCLUDE_DIRECTORIES>
  PRIVATE
    $<TARGET_PROPERTY:dynawo_ModelerCommon,INTERFACE_INCLUDE_DIRECTORIES>
  PUBLIC
    $<TARGET_PROPERTY:Sundials::Sundials_NVECSERIAL,INTERFACE_INCLUDE_DIRECTORIES>
)
target_include_directories(dynawo_SolverSIMi SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_SolverSIMi
  PRIVATE
    dynawo_Common
    dynawo_API_PAR
    dynawo_API_TL
    dynawo_SolverCommon
    dynawo_SolverKINSOL
    dynawo_SolverSIM
    dynawo_SolverCommonFixedTimeStep
  )

set_target_properties(dynawo_SolverSIMi PROPERTIES VERSION ${SOLVER_SIMI_VERSION_STRING}
                                                SOVERSION ${SOLVER_SIMI_VERSION_MAJOR}
                                                   PREFIX "")

install(TARGETS dynawo_SolverSIMi EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${SOLVER_SIMI_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

desc_solver(dynawo_SolverSIMi)

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
