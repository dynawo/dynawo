# Copyright (c) 2026, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

# API version
set(API_MANDATORYPARAM_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(API_MANDATORYPARAM_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(API_MANDATORYPARAM_SHARED
    xsd/mandatoryParam.xsd
    )

install(FILES ${API_MANDATORYPARAM_SHARED} DESTINATION ${SHAREDIR_NAME}/xsd/)

set(API_MANDATORYPARAM_SOURCES
    MANDATORYPARAMParameter.cpp
    MANDATORYPARAMCollection.cpp
    MANDATORYPARAMXmlHandler.cpp
    MANDATORYPARAMXmlImporter.cpp
    MANDATORYPARAMXmlExporter.cpp
    )

set(API_MANDATORYPARAM_INCLUDE_HEADERS
    MANDATORYPARAMParameter.h
    MANDATORYPARAMCollection.h
    MANDATORYPARAMXmlHandler.h
    MANDATORYPARAMXmlImporter.h
    MANDATORYPARAMXmlExporter.h
    )

add_library(dynawo_API_MANDATORYPARAM SHARED ${API_MANDATORYPARAM_SOURCES})

target_include_directories(dynawo_API_MANDATORYPARAM
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )
target_include_directories(dynawo_API_MANDATORYPARAM SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_API_MANDATORYPARAM
  PUBLIC
    XMLSAXFormatter${LibXML_LINK_SUFFIX}
    XMLSAXParser${LibXML_LINK_SUFFIX}
  PRIVATE
    dynawo_Common
    Boost::system
    )

set_target_properties(dynawo_API_MANDATORYPARAM PROPERTIES VERSION ${API_MANDATORYPARAM_VERSION_STRING}
                                                           SOVERSION ${API_MANDATORYPARAM_VERSION_MAJOR})

install(TARGETS dynawo_API_MANDATORYPARAM EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${API_MANDATORYPARAM_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
