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
SET(API_DYD_VERSION_STRING ${DYNAWO_VERSION_STRING})
SET(API_DYD_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

SET(API_DYD_SHARED
   xsd/dyd.xsd
   )

INSTALL(FILES ${API_DYD_SHARED} DESTINATION ${sharedir}/xsd/)

SET(API_DYD_SOURCES
    DYDBlackBoxModelFactory.cpp
    DYDBlackBoxModelImpl.cpp
    DYDConnectorFactory.cpp
    DYDConnectorImpl.cpp
    DYDDynamicModelsCollectionFactory.cpp
    DYDDynamicModelsCollectionImpl.cpp
    DYDIdentifiableFactory.cpp
    DYDIterators.cpp
    DYDIteratorsImpl.cpp
    DYDMacroConnectFactory.cpp
    DYDMacroConnectImpl.cpp
    DYDMacroConnectionFactory.cpp
    DYDMacroConnectionImpl.cpp
    DYDMacroConnectorFactory.cpp
    DYDMacroConnectorImpl.cpp
    DYDModelicaModelFactory.cpp
    DYDModelicaModelImpl.cpp
    DYDModelImpl.cpp
    DYDModelTemplateFactory.cpp
    DYDModelTemplateImpl.cpp
    DYDModelTemplateExpansionFactory.cpp
    DYDModelTemplateExpansionImpl.cpp
    DYDXmlHandler.cpp
    DYDXmlImporter.cpp
    DYDStaticRefFactory.cpp
    DYDStaticRefImpl.cpp
    DYDMacroStaticRefImpl.cpp
    DYDMacroStaticRefFactory.cpp
    DYDMacroStaticReferenceImpl.cpp
    DYDMacroStaticReferenceFactory.cpp
    DYDUnitDynamicModelFactory.cpp
    DYDUnitDynamicModelImpl.cpp
    DYDXmlExporter.cpp
    )

SET(API_DYD_INCLUDE_HEADERS
    DYDBlackBoxModel.h
    DYDBlackBoxModelFactory.h
    DYDConnector.h
    DYDConnectorFactory.h
    DYDDynamicModelsCollection.h
    DYDDynamicModelsCollectionFactory.h
    DYDExport.h
    DYDExporter.h
    DYDIdentifiable.h
    DYDIdentifiableFactory.h
    DYDImporter.h
    DYDIterators.h
    DYDMacroConnect.h
    DYDMacroConnectFactory.h
    DYDMacroConnection.h
    DYDMacroConnectionFactory.h
    DYDMacroConnector.h
    DYDMacroConnectorFactory.h
    DYDModel.h
    DYDModelicaModel.h
    DYDModelicaModelFactory.h
    DYDModelTemplate.h
    DYDModelTemplateFactory.h
    DYDModelTemplateExpansion.h
    DYDModelTemplateExpansionFactory.h
    DYDXmlImporter.h
    DYDXmlExporter.h
    DYDStaticRef.h
    DYDStaticRefFactory.h
    DYDMacroStaticRef.h
    DYDMacroStaticRefFactory.h
    DYDMacroStaticReference.h
    DYDMacroStaticReferenceFactory.h
    DYDUnitDynamicModel.h
    DYDUnitDynamicModelFactory.h
    )

INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIR}
                    ${LibXML_INCLUDE_DIR}
                    )

INCLUDE_DIRECTORIES(../../Common)

ADD_LIBRARY(dynawo_API_DYD ${LIBRARY_TYPE} ${API_DYD_SOURCES})

TARGET_LINK_LIBRARIES(dynawo_API_DYD
    XMLSAXFormatter${LibXML_LINK_SUFFIX}
    XMLSAXParser${LibXML_LINK_SUFFIX}
    dynawo_Common
    pthread
    ${Boost_THREAD_LIBRARY}
    )
SET_TARGET_PROPERTIES(dynawo_API_DYD PROPERTIES VERSION ${API_DYD_VERSION_STRING}
                                           SOVERSION ${API_DYD_VERSION_MAJOR})

INSTALL(TARGETS dynawo_API_DYD DESTINATION ${libdir})
INSTALL(FILES ${API_DYD_INCLUDE_HEADERS} DESTINATION ${includedir})

