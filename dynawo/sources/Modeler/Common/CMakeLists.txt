# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
# 
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

#################################
#          libModeler           #
#################################
SET(MODELER_VERSION_STRING ${DYNAWO_VERSION_STRING})
SET(MODELER_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

SET(MODELER_SOURCES
    DYNCommonModeler.cpp
    DYNConnector.cpp
    DYNConnectorCalculatedVariable.cpp
    DYNDynamicData.cpp
    DYNModeler.cpp
    DYNModelMulti.cpp
    DYNParameterModeler.cpp
    DYNSubModel.cpp
    DYNSubModelFactory.cpp
    DYNVariable.cpp
    DYNVariableAlias.cpp
    DYNVariableAliasFactory.cpp
    DYNVariableMultiple.cpp
    DYNVariableMultipleFactory.cpp
    DYNVariableNative.cpp
    DYNVariableNativeFactory.cpp
    DYNCompiler.cpp
    DYNModelUtil.cpp
    )

SET(MODELER_INCLUDE_HEADERS
    DYNConnectInterface.h
    DYNDynamicData.h
    DYNElement.h
    DYNModelDescription.h
    DYNModeler.h
    DYNModelMulti.h
    DYNModel.h
    DYNParameterModeler.h
    DYNParameterModeler.hpp
    DYNSubModel.h
    DYNSubModel.hpp
    DYNSubModelFactory.h
    DYNVariable.h
    DYNVariableAlias.h
    DYNVariableAliasFactory.h
    DYNVariableMultiple.h
    DYNVariableMultipleFactory.h
    DYNVariableNative.h
    DYNVariableNativeFactory.h
    DYNVariableForModel.h
    DYNCompiler.h
    DYNModelUtil.h
    DYNCommonModeler.h
    DYNModelConstants.h
    DYNConnectorCalculatedVariable.h
    DYNConnector.h
    DYNStaticRefInterface.h
    )

INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIR}
                    ${LIBXML_INCLUDE_DIR}
                    )

INCLUDE_DIRECTORIES(../../API/PAR
              	    ../../API/TL
                    ../../API/CRV
                    ../../API/FS
                    ../../API/CSTR
                    ../../API/DYD
                    ../../API/EXTVAR
                    ../../Common
                    ../Common
                    ../DataInterface
                    ../../Common
                    )

ADD_LIBRARY(dynawo_ModelerCommon SHARED ${MODELER_SOURCES})

TARGET_LINK_LIBRARIES(dynawo_ModelerCommon
                      ${LIBXML_LIBRARY_FORMATTER}
                      ${LIBXML_LIBRARY_PARSER}
                      dynawo_API_PAR
                      dynawo_API_TL
                      dynawo_API_CRV
                      dynawo_API_FS
                      dynawo_API_CSTR
                      dynawo_API_EXTVAR
                      dynawo_API_DYD
                      dl
                      dynawo_Common
                      dynawo_DataInterface
                      )
SET_TARGET_PROPERTIES(dynawo_ModelerCommon PROPERTIES VERSION ${MODELER_VERSION_STRING}
                                         SOVERSION ${MODELER_VERSION_MAJOR})

INSTALL(TARGETS dynawo_ModelerCommon DESTINATION ${libdir})
INSTALL(FILES ${MODELER_INCLUDE_HEADERS} DESTINATION ${includedir})
