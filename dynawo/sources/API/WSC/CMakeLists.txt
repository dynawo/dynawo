# Copyright (c) 2024, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# API version
set(API_WSC_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(API_WSC_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

# set(API_JOB_SHARED
#     xsd/jobs.xsd
#     )

# install(FILES ${API_WSC_SHARED} DESTINATION ${SHAREDIR_NAME}/xsd/)

set(API_WSC_SOURCES
    WSCServer.cpp
    )

set(API_WSC_INCLUDE_HEADERS
    WSCServer.h
    )

    add_library(dynawo_API_WSC SHARED ${API_WSC_SOURCES})

target_include_directories(dynawo_API_WSC
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )

target_include_directories(dynawo_API_WSC SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_API_WSC
  PUBLIC
    XMLSAXParser${LibXML_LINK_SUFFIX}
  PRIVATE
    dynawo_Common
    Boost::system
    )

set_target_properties(dynawo_API_WSC PROPERTIES VERSION ${API_WSC_VERSION_STRING}
                                              SOVERSION ${API_WSC_VERSION_MAJOR})

install(TARGETS dynawo_API_WSC EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${API_WSC_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
