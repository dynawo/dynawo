# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

set(COMMON_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(COMMON_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(COMMON_SOURCES
  DYNBitMask.cpp
  DYNEnumUtils.cpp
  DYNGraph.cpp
  DYNParameter.cpp
  DYNSparseMatrix.cpp
  )

set(COMMON_INCLUDE_HEADERS
  DYNBitMask.h
  DYNEnumUtils.h
  DYNGraph.h
  DYNParameter.h
  DYNSparseMatrix.h
  DYNParameter.hpp
  DYNInitXml.h
  )

add_library(dynawo_Common ${LIBRARY_TYPE} ${COMMON_SOURCES})

add_dependencies(dynawo_Common create_keys_files)

target_include_directories(dynawo_Common
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )
target_include_directories(dynawo_Common SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_Common
  PUBLIC
    dynawo_Interface
  INTERFACE
    dynawo_Util
  PRIVATE
    dynawo_Util
    ${CMAKE_DL_LIBS}
    Boost::filesystem
    Boost::log
  )

set_target_properties(dynawo_Common PROPERTIES VERSION ${COMMON_VERSION_STRING}
                                             SOVERSION ${COMMON_VERSION_MAJOR})

install(TARGETS dynawo_Common EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${COMMON_INCLUDE_HEADERS} ${UTIL_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
