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
set(API_EXTVAR_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(API_EXTVAR_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(API_EXTVAR_SHARED
    xsd/extVar.xsd
    )

install(FILES ${API_EXTVAR_SHARED} DESTINATION ${SHAREDIR_NAME}/xsd/)

set(API_EXTVAR_SOURCES
    EXTVARVariablesCollectionFactory.cpp
    EXTVARVariablesCollection.cpp
    EXTVARVariableFactory.cpp
    EXTVARVariable.cpp
    EXTVARXmlExporter.cpp
    EXTVARXmlHandler.cpp
    EXTVARXmlImporter.cpp
    )

set(API_EXTVAR_INCLUDE_HEADERS
    EXTVARExporter.h
    EXTVARImporter.h
    EXTVARVariable.h
    EXTVARVariablesCollection.h
    EXTVARVariablesCollectionFactory.h
    EXTVARVariableFactory.h
    EXTVARXmlExporter.h
    EXTVARXmlImporter.h
    )

add_library(dynawo_API_EXTVAR SHARED ${API_EXTVAR_SOURCES})

target_include_directories(dynawo_API_EXTVAR
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )
target_include_directories(dynawo_API_EXTVAR SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_API_EXTVAR
  PUBLIC
    XMLSAXFormatter${LibXML_LINK_SUFFIX}
    XMLSAXParser${LibXML_LINK_SUFFIX}
  PRIVATE
    dynawo_Common
    Boost::system
    )

set_target_properties(dynawo_API_EXTVAR PROPERTIES VERSION ${API_EXTVAR_VERSION_STRING}
                                                 SOVERSION ${API_EXTVAR_VERSION_MAJOR})

install(TARGETS dynawo_API_EXTVAR EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${API_EXTVAR_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
