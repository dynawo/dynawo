# Copyright (c) 2021, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

# API version
set(API_FSV_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(API_FSV_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(API_FSV_SHARED
  xsd/finalStateValuesInput.xsd
  xsd/finalStateValuesOutput.xsd
  )

install(FILES ${API_FSV_SHARED} DESTINATION ${SHAREDIR_NAME}/xsd/)

set(API_FSV_SOURCES
  FSVCsvExporter.cpp
  FSVFinalStateValue.cpp
  FSVFinalStateValueFactory.cpp
  FSVFinalStateValuesCollection.cpp
  FSVFinalStateValuesCollectionFactory.cpp
  FSVTxtExporter.cpp
  FSVXmlHandler.cpp
  FSVXmlExporter.cpp
  FSVXmlImporter.cpp
  )

set(API_FSV_INCLUDE_HEADERS
  FSVCsvExporter.h
  FSVExporter.h
  FSVFinalStateValue.h
  FSVFinalStateValueFactory.h
  FSVFinalStateValuesCollection.h
  FSVFinalStateValuesCollectionFactory.h
  FSVTxtExporter.h
  FSVXmlHandler.h
  FSVXmlExporter.h
  FSVXmlImporter.h
  )

add_library(dynawo_API_FSV SHARED ${API_FSV_SOURCES})

target_include_directories(dynawo_API_FSV
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )
target_include_directories(dynawo_API_FSV SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_API_FSV
  PUBLIC
    XMLSAXFormatter${LibXML_LINK_SUFFIX}
    XMLSAXParser${LibXML_LINK_SUFFIX}
  PRIVATE
    dynawo_Common
    Boost::system
  )

set_target_properties(dynawo_API_FSV PROPERTIES VERSION ${API_FSV_VERSION_STRING}
                                              SOVERSION ${API_FSV_VERSION_MAJOR})

install(TARGETS dynawo_API_FSV EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${API_FSV_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
