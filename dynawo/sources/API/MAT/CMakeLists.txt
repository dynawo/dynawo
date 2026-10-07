# Copyright (c) 2026, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite
# of simulation tools for power systems.


# API Version
set(API_MAT_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(API_MAT_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(API_MAT_SOURCES
  MATLinearizedSystem.cpp
  MATMatrix.cpp
  MATSparseMatrixConversion.cpp
  MATTxtExporter.cpp
  )

set(API_MAT_INCLUDE_HEADERS
  MATExporter.h
  MATLinearizedSystem.h
  MATMatrix.h
  MATSparseMatrixConversion.h
  MATTxtExporter.h
  )

add_library(dynawo_API_MAT SHARED ${API_MAT_SOURCES})

target_include_directories(dynawo_API_MAT
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )
target_include_directories(dynawo_API_MAT SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_API_MAT
  PRIVATE
    dynawo_Common
  )

set_target_properties(dynawo_API_MAT PROPERTIES VERSION ${API_MAT_VERSION_STRING}
                                               SOVERSION ${API_MAT_VERSION_MAJOR})

install(TARGETS dynawo_API_MAT EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${API_MAT_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
