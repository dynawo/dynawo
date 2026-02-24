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
set(API_PAR_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(API_PAR_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(API_PAR_SHARED
    xsd/parameters.xsd
    )

install(FILES ${API_PAR_SHARED} DESTINATION ${SHAREDIR_NAME}/xsd/)

set(API_PAR_SOURCES
    PARParameter.cpp
    PARParameterFactory.cpp
    PARReference.cpp
    PARReferenceFactory.cpp
    PARParametersSet.cpp
    PARParametersSetCollection.cpp
    PARParametersSetCollectionFactory.cpp
    PARParametersSetFactory.cpp
    PARXmlExporter.cpp
    PARXmlHandler.cpp
    PARXmlImporter.cpp
    PARMacroParameterSet.cpp
    PARMacroParSet.cpp
    )

set(API_PAR_INCLUDE_HEADERS
    PARParameter.h
    PARParameterFactory.h
    PARReference.h
    PARReferenceFactory.h
    PARParametersSet.h
    PARParametersSetCollection.h
    PARParametersSetCollectionFactory.h
    PARParametersSetFactory.h
    PARXmlExporter.h
    PARXmlImporter.h
    PARExporter.h
    PARImporter.h
    PARMacroParameterSet.h
    PARMacroParSet.h
    )

add_library(dynawo_API_PAR SHARED ${API_PAR_SOURCES})

target_include_directories(dynawo_API_PAR
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )
target_include_directories(dynawo_API_PAR SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_API_PAR
  PUBLIC
    XMLSAXFormatter${LibXML_LINK_SUFFIX}
    XMLSAXParser${LibXML_LINK_SUFFIX}
  PRIVATE
    dynawo_Common
    )

set_target_properties(dynawo_API_PAR PROPERTIES VERSION ${API_PAR_VERSION_STRING}
                                              SOVERSION ${API_PAR_VERSION_MAJOR})

install(TARGETS dynawo_API_PAR EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${API_PAR_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
