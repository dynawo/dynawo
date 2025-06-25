# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# API version
set(API_TL_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(API_TL_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(API_TL_SHARED
    xsd/timeline.xsd
    )

install(FILES ${API_TL_SHARED} DESTINATION ${SHAREDIR_NAME}/xsd/)

set(API_TL_SOURCES
    TLTimeline.cpp
    TLTimelineFactory.cpp
    TLEvent.cpp
    TLEventFactory.cpp
    TLTxtExporter.cpp
    TLCsvExporter.cpp
    TLXmlExporter.cpp
    TLJsonExporter.cpp
    )

set(API_TL_INCLUDE_HEADERS
    TLEvent.h
    TLEventFactory.h
    TLTimeline.h
    TLTimelineFactory.h
    TLExporter.h
    TLTxtExporter.h
    TLCsvExporter.h
    TLXmlExporter.h
    TLJsonExporter.h
    )

add_library(dynawo_API_TL SHARED ${API_TL_SOURCES})

target_include_directories(dynawo_API_TL
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )
target_include_directories(dynawo_API_TL SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_API_TL
  PUBLIC
    XMLSAXFormatter${LibXML_LINK_SUFFIX}
  PRIVATE
    dynawo_Common
    Boost::system
    )

set_target_properties(dynawo_API_TL PROPERTIES VERSION ${API_TL_VERSION_STRING}
                                             SOVERSION ${API_TL_VERSION_MAJOR})

install(TARGETS dynawo_API_TL EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${API_TL_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
