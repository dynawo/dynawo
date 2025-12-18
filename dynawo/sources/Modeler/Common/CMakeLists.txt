# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

#################################
#          libModeler           #
#################################
set(MODELER_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(MODELER_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(MODELER_SOURCES
    DYNCommonModeler.cpp
    DYNConnector.cpp
    DYNConnectorCalculatedDiscreteVariable.cpp
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
    DYNDelay.cpp
    DYNDelayManager.cpp
    DYNRingBuffer.cpp
    DYNAction.cpp
    DYNActionBuffer.cpp
    )

set(MODELER_INCLUDE_HEADERS
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
    DYNDelay.h
    DYNDelayManager.h
    DYNRingBuffer.h
    DYNAction.h
    DYNActionBuffer.h
    )

add_library(dynawo_ModelerCommon SHARED ${MODELER_SOURCES})

target_compile_definitions(dynawo_ModelerCommon PUBLIC $<$<BOOL:${MSVC}>:_USE_MATH_DEFINES>)

target_include_directories(dynawo_ModelerCommon
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    $<TARGET_PROPERTY:dynawo_API_EXTVAR,INTERFACE_INCLUDE_DIRECTORIES>
    $<TARGET_PROPERTY:dynawo_API_PAR,INTERFACE_INCLUDE_DIRECTORIES>
    $<TARGET_PROPERTY:dynawo_API_DYD,INTERFACE_INCLUDE_DIRECTORIES>
    $<TARGET_PROPERTY:dynawo_API_CSTR,INTERFACE_INCLUDE_DIRECTORIES>
    $<TARGET_PROPERTY:dynawo_API_TL,INTERFACE_INCLUDE_DIRECTORIES>
  PRIVATE
    $<TARGET_PROPERTY:dynawo_DataInterface,INTERFACE_INCLUDE_DIRECTORIES>
  )
target_include_directories(dynawo_ModelerCommon SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_ModelerCommon
  PUBLIC
    Boost::system
    Boost::filesystem
  PRIVATE
    dynawo_Common
    dynawo_API_PAR
    dynawo_API_DYD
    dynawo_API_CRV
    dynawo_API_TL
    dynawo_API_CSTR
    dynawo_API_EXTVAR
    ${CMAKE_DL_LIBS}
  )

set_target_properties(dynawo_ModelerCommon PROPERTIES VERSION ${MODELER_VERSION_STRING}
                                                    SOVERSION ${MODELER_VERSION_MAJOR})

install(TARGETS dynawo_ModelerCommon EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${MODELER_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
