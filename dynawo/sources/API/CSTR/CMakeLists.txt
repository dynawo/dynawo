# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# API Version
set(API_CSTR_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(API_CSTR_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(API_CSTR_SHARED
    xsd/constraints.xsd
    )

install(FILES ${API_CSTR_SHARED} DESTINATION ${SHAREDIR_NAME}/xsd/)

set(API_CSTR_SOURCES
    CSTRConstraint.cpp
    CSTRConstraintFactory.cpp
    CSTRConstraintsCollection.cpp
    CSTRConstraintsCollectionFactory.cpp
    CSTRXmlExporter.cpp
    CSTRTxtExporter.cpp
    CSTRJsonExporter.cpp
    )

set(API_CSTR_INCLUDE_HEADERS
    CSTRConstraint.h
    CSTRConstraintFactory.h
    CSTRConstraintCommon.h
    CSTRConstraintsCollection.h
    CSTRConstraintsCollectionFactory.h
    CSTRExporter.h
    CSTRXmlExporter.h
    CSTRTxtExporter.h
    CSTRJsonExporter.h
    )

add_library(dynawo_API_CSTR SHARED ${API_CSTR_SOURCES})

target_include_directories(dynawo_API_CSTR
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )
target_include_directories(dynawo_API_CSTR SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_API_CSTR
  PUBLIC
    XMLSAXFormatter${LibXML_LINK_SUFFIX}
  PRIVATE
    dynawo_Common
    )

set_target_properties(dynawo_API_CSTR PROPERTIES VERSION ${API_CSTR_VERSION_STRING}
                                               SOVERSION ${API_CSTR_VERSION_MAJOR})

install(TARGETS dynawo_API_CSTR EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${API_CSTR_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
