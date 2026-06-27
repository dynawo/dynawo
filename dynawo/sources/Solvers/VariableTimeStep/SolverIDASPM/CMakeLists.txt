# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

set(SOLVER_IDASPM_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(SOLVER_IDASPM_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(SOLVER_IDASPM_SOURCES
  DYNSolverIDASPM.cpp
  )

set(SOLVER_IDASPM_INCLUDE_HEADERS
  DYNSolverIDASPM.h
  )

add_library(dynawo_SolverIDASPM SHARED ${SOLVER_IDASPM_SOURCES})

target_include_directories(dynawo_SolverIDASPM
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    $<TARGET_PROPERTY:Sundials::Sundials_NVECSERIAL,INTERFACE_INCLUDE_DIRECTORIES>
    $<TARGET_PROPERTY:dynawo_SolverCommon,INTERFACE_INCLUDE_DIRECTORIES>
  PRIVATE
    $<TARGET_PROPERTY:dynawo_API_PAR,INTERFACE_INCLUDE_DIRECTORIES>
    $<TARGET_PROPERTY:dynawo_ModelerCommon,INTERFACE_INCLUDE_DIRECTORIES>
)
target_include_directories(dynawo_SolverIDASPM SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_SolverIDASPM
  PRIVATE
    dynawo_Common
    dynawo_SolverCommon
    dynawo_SolverKINSOL
    Sundials::Sundials_NVECSERIAL
    Sundials::Sundials_SUNLINSOLKLU
    Sundials::Sundials_IDA
  )

set_target_properties(dynawo_SolverIDASPM PROPERTIES VERSION ${SOLVER_IDASPM_VERSION_STRING}
                                                SOVERSION ${SOLVER_IDASPM_VERSION_MAJOR}
                                                   PREFIX "")

install(TARGETS dynawo_SolverIDASPM EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${SOLVER_IDASPM_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

desc_solver(dynawo_SolverIDASPM)

