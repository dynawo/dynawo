# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

set(SOLVER_IDA_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(SOLVER_IDA_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(SOLVER_IDA_SOURCES
  DYNSolverIDA.cpp
  )

set(SOLVER_IDA_INCLUDE_HEADERS
  DYNSolverIDA.h
  )

add_library(dynawo_SolverIDA SHARED ${SOLVER_IDA_SOURCES})

target_include_directories(dynawo_SolverIDA
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    $<TARGET_PROPERTY:Sundials::Sundials_NVECSERIAL,INTERFACE_INCLUDE_DIRECTORIES>
    $<TARGET_PROPERTY:dynawo_SolverCommon,INTERFACE_INCLUDE_DIRECTORIES>
  PRIVATE
    $<TARGET_PROPERTY:dynawo_API_PAR,INTERFACE_INCLUDE_DIRECTORIES>
    $<TARGET_PROPERTY:dynawo_ModelerCommon,INTERFACE_INCLUDE_DIRECTORIES>
)
target_include_directories(dynawo_SolverIDA SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_SolverIDA
  PRIVATE
    dynawo_Common
    dynawo_SolverCommon
    dynawo_SolverKINSOL
    Sundials::Sundials_NVECSERIAL
    Sundials::Sundials_SUNLINSOLKLU
    Sundials::Sundials_IDA
  )

set_target_properties(dynawo_SolverIDA PROPERTIES VERSION ${SOLVER_IDA_VERSION_STRING}
                                                SOVERSION ${SOLVER_IDA_VERSION_MAJOR}
                                                   PREFIX "")

install(TARGETS dynawo_SolverIDA EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${SOLVER_IDA_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

desc_solver(dynawo_SolverIDA)

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
