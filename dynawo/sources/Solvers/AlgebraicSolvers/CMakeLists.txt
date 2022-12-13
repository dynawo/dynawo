# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

set(SOLVER_KINSOL_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(SOLVER_KINSOL_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

add_library(dynawo_SolverKINCommon SHARED DYNSolverKINCommon.cpp)

target_include_directories(dynawo_SolverKINCommon
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    $<TARGET_PROPERTY:Sundials::Sundials_NVECSERIAL,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_SolverKINCommon
  PUBLIC
    dynawo_Common
    Sundials::Sundials_KINSOL
    Sundials::Sundials_NVECSERIAL
    Sundials::Sundials_SUNLINSOLKLU
    $<$<BOOL:${NICSLU_FOUND}>:Sundials::Sundials_SUNLINSOLNICSLU>
  )

add_library(dynawo_SolverKINSubModel SHARED DYNSolverKINSubModel.cpp)

target_include_directories(dynawo_SolverKINSubModel
  PRIVATE
    $<TARGET_PROPERTY:dynawo_ModelerCommon,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_SolverKINSubModel
  PUBLIC
    dynawo_SolverKINCommon
  PRIVATE
    dynawo_SolverCommon
    dynawo_API_PAR
  )

set(SOLVER_KINSOL_SOURCES
  DYNSolverKINAlgRestoration.cpp
  DYNSolverKINEuler.cpp
)

set(SOLVER_KINSOL_INCLUDE_HEADERS
  DYNSolverKINCommon.h
  DYNSolverKINAlgRestoration.h
  DYNSolverKINEuler.h
  DYNSolverKINSubModel.h
)

add_library(dynawo_SolverKINSOL SHARED ${SOLVER_KINSOL_SOURCES})

target_include_directories(dynawo_SolverKINSOL
  PRIVATE
    $<TARGET_PROPERTY:dynawo_ModelerCommon,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_SolverKINSOL
  PUBLIC
    dynawo_SolverKINCommon
  PRIVATE
    dynawo_SolverCommon
  )

set_target_properties(dynawo_SolverKINCommon dynawo_SolverKINSubModel dynawo_SolverKINSOL
  PROPERTIES VERSION ${SOLVER_KINSOL_VERSION_STRING}
             SOVERSION ${SOLVER_KINSOL_VERSION_MAJOR})

install(TARGETS dynawo_SolverKINCommon dynawo_SolverKINSubModel dynawo_SolverKINSOL
  EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${SOLVER_KINSOL_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
