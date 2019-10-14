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

ADD_LIBRARY(dynawo_ModelerCommon ${LIBRARY_TYPE} ${MODELER_SOURCES})

TARGET_COMPILE_DEFINITIONS(dynawo_ModelerCommon PUBLIC $<$<BOOL:${MSVC}>:_USE_MATH_DEFINES>)

TARGET_INCLUDE_DIRECTORIES(dynawo_ModelerCommon
    INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    PUBLIC
        $<TARGET_PROPERTY:dynawo_API_TL,INTERFACE_INCLUDE_DIRECTORIES>
        $<TARGET_PROPERTY:dynawo_API_CSTR,INTERFACE_INCLUDE_DIRECTORIES>
        $<TARGET_PROPERTY:dynawo_DataInterface,INTERFACE_INCLUDE_DIRECTORIES>
    )

TARGET_LINK_LIBRARIES(dynawo_ModelerCommon
    dynawo_API_PAR
    dynawo_API_CRV
    dynawo_API_FS
    dynawo_API_EXTVAR
    dynawo_API_DYD
    dynawo_Util
    )

SET_TARGET_PROPERTIES(dynawo_ModelerCommon PROPERTIES VERSION ${MODELER_VERSION_STRING}
                                                    SOVERSION ${MODELER_VERSION_MAJOR})

INSTALL(TARGETS dynawo_ModelerCommon EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
INSTALL(FILES ${MODELER_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
