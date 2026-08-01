# Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

# API version
set(API_CRT_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(API_CRT_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(API_CRT_SHARED
  xsd/criteria.xsd
  )

install(FILES ${API_CRT_SHARED} DESTINATION ${SHAREDIR_NAME}/xsd/)

set(API_CRT_SOURCES
  CRTCriteriaParams.cpp
  CRTCriteriaParamsFactory.cpp
  CRTCriteriaParamsVoltageLevel.cpp
  CRTCriteria.cpp
  CRTCriteriaFactory.cpp
  CRTCriteriaCollection.cpp
  CRTCriteriaCollectionFactory.cpp
  CRTXmlHandler.cpp
  CRTXmlImporter.cpp
  )

set(API_CRT_INCLUDE_HEADERS
  CRTCriteriaParams.h
  CRTCriteriaParamsFactory.h
  CRTCriteriaParamsVoltageLevel.h
  CRTCriteria.h
  CRTCriteriaFactory.h
  CRTCriteriaCollection.h
  CRTCriteriaCollectionFactory.h
  CRTImporter.h
  CRTXmlImporter.h
  )

add_library(dynawo_API_CRT SHARED ${API_CRT_SOURCES})

target_include_directories(dynawo_API_CRT
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )
target_include_directories(dynawo_API_CRT SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_API_CRT
  PUBLIC
    XMLSAXFormatter${LibXML_LINK_SUFFIX}
    XMLSAXParser${LibXML_LINK_SUFFIX}
  PRIVATE
    dynawo_Common
  )

set_target_properties(dynawo_API_CRT PROPERTIES VERSION ${API_CRT_VERSION_STRING}
                                              SOVERSION ${API_CRT_VERSION_MAJOR})

install(TARGETS dynawo_API_CRT EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${API_CRT_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
