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
SET(API_EXTVAR_VERSION_STRING ${DYNAWO_VERSION_STRING})
SET(API_EXTVAR_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

SET(API_EXTVAR_SHARED
    xsd/extVar.xsd
    )

INSTALL(FILES ${API_EXTVAR_SHARED} DESTINATION ${SHAREDIR_NAME}/xsd/)

SET(API_EXTVAR_SOURCES
    EXTVARIterators.cpp
    EXTVARIteratorsImpl.cpp
    EXTVARVariablesCollectionFactory.cpp
    EXTVARVariablesCollectionImpl.cpp
    EXTVARVariableFactory.cpp
    EXTVARVariableImpl.cpp
    EXTVARXmlExporter.cpp
    EXTVARXmlHandler.cpp
    EXTVARXmlImporter.cpp
    )

SET(API_EXTVAR_INCLUDE_HEADERS
    EXTVARExporter.h
    EXTVARImporter.h
    EXTVARIterators.h
    EXTVARVariable.h
    EXTVARVariablesCollection.h
    EXTVARVariablesCollectionFactory.h
    EXTVARVariableFactory.h
    EXTVARXmlExporter.h
    EXTVARXmlImporter.h
    )

ADD_LIBRARY(dynawo_API_EXTVAR ${LIBRARY_TYPE} ${API_EXTVAR_SOURCES})

TARGET_INCLUDE_DIRECTORIES(dynawo_API_EXTVAR
    INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    )

TARGET_LINK_LIBRARIES(dynawo_API_EXTVAR
    XMLSAXFormatter${LibXML_LINK_SUFFIX}
    XMLSAXParser${LibXML_LINK_SUFFIX}
    dynawo_Common
    )

SET_TARGET_PROPERTIES(dynawo_API_EXTVAR PROPERTIES VERSION ${API_EXTVAR_VERSION_STRING}
                                                 SOVERSION ${API_EXTVAR_VERSION_MAJOR})

INSTALL(TARGETS dynawo_API_EXTVAR EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
INSTALL(FILES ${API_EXTVAR_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
