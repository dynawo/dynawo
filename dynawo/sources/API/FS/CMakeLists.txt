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
SET(API_FS_VERSION_STRING ${DYNAWO_VERSION_STRING})
SET(API_FS_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

SET(API_FS_SHARED
    xsd/finalStateInput.xsd
    xsd/finalStateOutput.xsd
    )

INSTALL(FILES ${API_FS_SHARED} DESTINATION ${SHAREDIR_NAME}/xsd/)

SET(API_FS_SOURCES
    FSFinalStateCollectionImpl.cpp
    FSFinalStateCollectionFactory.cpp
    FSModelImpl.cpp
    FSModelFactory.cpp
    FSVariableImpl.cpp
    FSVariableFactory.cpp
    FSXmlExporter.cpp
    FSXmlHandler.cpp
    FSXmlImporter.cpp
    FSIterators.cpp
    FSIteratorsImpl.cpp
    )

SET(API_FS_INCLUDE_HEADERS
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

ADD_LIBRARY(dynawo_API_FS ${LIBRARY_TYPE} ${API_FS_SOURCES})

TARGET_INCLUDE_DIRECTORIES(dynawo_API_FS
    INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    )

TARGET_LINK_LIBRARIES(dynawo_API_FS
    XMLSAXFormatter${LibXML_LINK_SUFFIX}
    XMLSAXParser${LibXML_LINK_SUFFIX}
    dynawo_Common
    )

SET_TARGET_PROPERTIES(dynawo_API_FS PROPERTIES VERSION ${API_FS_VERSION_STRING}
                                             SOVERSION ${API_FS_VERSION_MAJOR})

INSTALL(TARGETS dynawo_API_FS EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
INSTALL(FILES ${API_FS_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
