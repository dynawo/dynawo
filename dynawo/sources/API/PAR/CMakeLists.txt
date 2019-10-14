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
SET(API_PAR_VERSION_STRING ${DYNAWO_VERSION_STRING})
SET(API_PAR_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

SET(API_PAR_SHARED
    xsd/parameters.xsd
    )

INSTALL(FILES ${API_PAR_SHARED} DESTINATION ${SHAREDIR_NAME}/xsd/)

SET(API_PAR_SOURCES
    PARParameterImpl.cpp
    PARParameterFactory.cpp
    PARReferenceImpl.cpp
    PARReferenceFactory.cpp
    PARParametersSet.cpp
    PARParametersSetImpl.cpp
    PARParametersSetFactory.cpp
    PARParametersSetCollection.cpp
    PARParametersSetCollectionImpl.cpp
    PARParametersSetCollectionFactory.cpp
    PARXmlExporter.cpp
    PARXmlHandler.cpp
    PARXmlImporter.cpp
    )

SET(API_PAR_INCLUDE_HEADERS
    PARParameter.h
    PARParameterFactory.h
    PARReference.h
    PARReferenceFactory.h
    PARParametersSet.h
    PARParametersSetFactory.h
    PARParametersSetCollection.h
    PARParametersSetCollectionFactory.h
    PARXmlExporter.h
    PARXmlImporter.h
    PARExporter.h
    PARImporter.h
    )

ADD_LIBRARY(dynawo_API_PAR ${LIBRARY_TYPE} ${API_PAR_SOURCES})

TARGET_INCLUDE_DIRECTORIES(dynawo_API_PAR
    INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    )

TARGET_LINK_LIBRARIES(dynawo_API_PAR
    XMLSAXFormatter${LibXML_LINK_SUFFIX}
    XMLSAXParser${LibXML_LINK_SUFFIX}
    dynawo_Common
    )

SET_TARGET_PROPERTIES(dynawo_API_PAR PROPERTIES VERSION ${API_PAR_VERSION_STRING}
                                              SOVERSION ${API_PAR_VERSION_MAJOR})

INSTALL(TARGETS dynawo_API_PAR EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
INSTALL(FILES ${API_PAR_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
