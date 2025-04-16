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
set(API_STPO_VERSSTPON_STRING ${DYNAWO_VERSSTPON_STRING})
set(API_STPO_VERSSTPON_MAJOR ${DYNAWO_VERSSTPON_MAJOR})

# set(API_JOB_SHARED
#     xsd/jobs.xsd
#     )

# install(FILES ${API_STPO_SHARED} DESTINATSTPON ${SHAREDIR_NAME}/xsd/)

set(API_STPO_SOURCES
STPOOutputEntry.cpp
)

set(API_STPO_INCLUDE_HEADERS
STPOOutputEntry.h
)

add_library(dynawo_API_STPO SHARED ${API_STPO_SOURCES})

target_include_directories(dynawo_API_STPO
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )

target_include_directories(dynawo_API_STPO SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_API_STPO
  PUBLIC
    XMLSAXParser${LibXML_LINK_SUFFIX}
  PRIVATE
    dynawo_Common
    Boost::system
    )

set_target_properties(dynawo_API_STPO PROPERTIES VERSSTPON ${API_STPO_VERSSTPON_STRING}
                                              SOVERSSTPON ${API_STPO_VERSSTPON_MAJOR})

install(TARGETS dynawo_API_STPO EXPORT dynawo-targets DESTINATSTPON ${LIBDIR_NAME})
install(FILES ${API_STPO_INCLUDE_HEADERS} DESTINATSTPON ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
