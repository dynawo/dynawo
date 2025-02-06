# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

# API version
set(API_CRV_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(API_CRV_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(API_CRV_SHARED
  xsd/curvesInput.xsd
  xsd/curvesOutput.xsd
  )

install(FILES ${API_CRV_SHARED} DESTINATION ${SHAREDIR_NAME}/xsd/)

set(API_CRV_SOURCES
  CRVCurve.cpp
  CRVCurveFactory.cpp
  CRVPoint.cpp
  CRVPointFactory.cpp
  CRVCurvesCollection.cpp
  CRVCurvesCollectionFactory.cpp
  CRVXmlHandler.cpp
  CRVXmlImporter.cpp
  CRVXmlExporter.cpp
  CRVCsvExporter.cpp
  )

set(API_CRV_INCLUDE_HEADERS
  CRVCurve.h
  CRVCurveFactory.h
  CRVPoint.h
  CRVPointFactory.h
  CRVCurvesCollection.h
  CRVCurvesCollectionFactory.h
  CRVImporter.h
  CRVXmlImporter.h
  CRVExporter.h
  CRVXmlExporter.h
  CRVCsvExporter.h
  )

add_library(dynawo_API_CRV SHARED ${API_CRV_SOURCES})

target_include_directories(dynawo_API_CRV
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )
target_include_directories(dynawo_API_CRV SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_API_CRV
  PUBLIC
    XMLSAXFormatter${LibXML_LINK_SUFFIX}
    XMLSAXParser${LibXML_LINK_SUFFIX}
  PRIVATE
    dynawo_Common
    Boost::system
  )

set_target_properties(dynawo_API_CRV PROPERTIES VERSION ${API_CRV_VERSION_STRING}
                                              SOVERSION ${API_CRV_VERSION_MAJOR})

install(TARGETS dynawo_API_CRV EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${API_CRV_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
