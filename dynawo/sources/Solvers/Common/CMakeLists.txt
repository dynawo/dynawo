# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

set(SOLVER_COMMON_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(SOLVER_COMMON_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(SOLVER_COMMON_SOURCES
    DYNSolverImpl.cpp
    DYNSolverFactory.cpp
    DYNSolverCommon.cpp
    DYNParameterSolver.cpp
    )

set(SOLVER_COMMON_INCLUDE_HEADERS
    DYNSolver.h
    DYNSolverFactory.h
    DYNSolverCommon.h
    DYNParameterSolver.h
    DYNParameterSolver.hpp
    )

add_library(dynawo_SolverCommon ${LIBRARY_TYPE} ${SOLVER_COMMON_SOURCES})

target_include_directories(dynawo_SolverCommon
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  PUBLIC
    $<TARGET_PROPERTY:dynawo_ModelerCommon,INTERFACE_INCLUDE_DIRECTORIES>
    $<TARGET_PROPERTY:dynawo_API_PAR,INTERFACE_INCLUDE_DIRECTORIES>
)

target_link_libraries(dynawo_SolverCommon
  PUBLIC
    dynawo_Util
    dynawo_API_TL
    Sundials::Sundials_NVECSERIAL
    Sundials::Sundials_SUNLINSOLKLU
    SuiteSparse::SuiteSparse_KLU
)

if(${NICSLU_FOUND})
  target_link_libraries(dynawo_SolverCommon
    PUBLIC
      Sundials::Sundials_SUNLINSOLNICSLU
      Sundials::Sundials_SUNMATRIXSPARSE
      NICSLU::NICSLU
      NICSLU::NICSLU_Util
  )
endif()

set_target_properties(dynawo_SolverCommon PROPERTIES VERSION ${SOLVER_COMMON_VERSION_STRING}
                                                   SOVERSION ${SOLVER_COMMON_VERSION_MAJOR})

install(TARGETS dynawo_SolverCommon EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${SOLVER_COMMON_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

set(SOLVER_SHARED solvers.par)

install(FILES ${SOLVER_SHARED} DESTINATION ${SHAREDIR_NAME})
