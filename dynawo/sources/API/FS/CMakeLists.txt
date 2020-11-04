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
set(API_FS_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(API_FS_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(API_FS_SHARED
    xsd/finalStateInput.xsd
    xsd/finalStateOutput.xsd
    )

install(FILES ${API_FS_SHARED} DESTINATION ${SHAREDIR_NAME}/xsd/)

set(API_FS_SOURCES
    FSFinalStateCollection.cpp
    FSFinalStateCollectionFactory.cpp
    FSModel.cpp
    FSModelFactory.cpp
    FSVariable.cpp
    FSVariableFactory.cpp
    FSXmlExporter.cpp
    FSXmlHandler.cpp
    FSXmlImporter.cpp
    FSIterators.cpp
    )

set(API_FS_INCLUDE_HEADERS
    FSFinalStateCollection.h
    FSFinalStateCollectionFactory.h
    FSModel.h
    FSModelFactory.h
    FSVariable.h
    FSVariableFactory.h
    FSImporter.h
    FSXmlExporter.h
    FSIterators.h
    FSExporter.h
    FSXmlImporter.h
    )

add_library(dynawo_API_FS ${LIBRARY_TYPE} ${API_FS_SOURCES})

target_include_directories(dynawo_API_FS
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )
target_include_directories(dynawo_API_FS SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_API_FS
  PUBLIC
    XMLSAXFormatter${LibXML_LINK_SUFFIX}
    XMLSAXParser${LibXML_LINK_SUFFIX}
  PRIVATE
    dynawo_Common
    dynawo_Util
    )

set_target_properties(dynawo_API_FS PROPERTIES VERSION ${API_FS_VERSION_STRING}
                                             SOVERSION ${API_FS_VERSION_MAJOR})

install(TARGETS dynawo_API_FS EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${API_FS_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
