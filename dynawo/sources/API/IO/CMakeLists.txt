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
set(API_IO_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(API_IO_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

# set(API_JOB_SHARED
#     xsd/jobs.xsd
#     )

# install(FILES ${API_IO_SHARED} DESTINATION ${SHAREDIR_NAME}/xsd/)

set(API_IO_SOURCES
IODefaultModelOutputEntry.cpp
IOModelOutputEntry.cpp
IOOutputEntry.cpp
)

set(API_IO_INCLUDE_HEADERS
IODefaultModelOutputEntry.h
IOModelOutputEntry.h
IOOutputEntry.h
)

add_library(dynawo_API_IO SHARED ${API_IO_SOURCES})

target_include_directories(dynawo_API_IO
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )

target_include_directories(dynawo_API_IO SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_API_IO
  PUBLIC
    XMLSAXParser${LibXML_LINK_SUFFIX}
  PRIVATE
    dynawo_Common
    Boost::system
    )

set_target_properties(dynawo_API_IO PROPERTIES VERSION ${API_IO_VERSION_STRING}
                                              SOVERSION ${API_IO_VERSION_MAJOR})

install(TARGETS dynawo_API_IO EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${API_IO_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
