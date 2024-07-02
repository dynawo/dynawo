# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

#####################################
#              libData              #
#####################################
set(DATA_INTERFACE_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(DATA_INTERFACE_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(DATA_INTERFACE_FACTORY_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(DATA_INTERFACE_FACTORY_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(DATA_INTERFACE_SOURCES
    DYNComponentInterface.cpp
    DYNStateVariable.cpp
    DYNStaticParameter.cpp
    DYNCriteria.cpp
    DYNDataInterfaceImpl.cpp
    )

set(DATA_INTERFACE_INCLUDE_HEADERS
    DYNDataInterface.h
    DYNNetworkInterface.h
    DYNLineInterface.h
    DYNTwoWTransformerInterface.h
    DYNThreeWTransformerInterface.h
    DYNVoltageLevelInterface.h
    DYNHvdcLineInterface.h
    DYNBusInterface.h
    DYNCurrentLimitInterface.h
    DYNSwitchInterface.h
    DYNLoadInterface.h
    DYNGeneratorInterface.h
    DYNStaticVarCompensatorInterface.h
    DYNShuntCompensatorInterface.h
    DYNVscConverterInterface.h
    DYNLccConverterInterface.h
    DYNBusInterface.h
    DYNPhaseTapChangerInterface.h
    DYNRatioTapChangerInterface.h
    DYNDanglingLineInterface.h
    DYNComponentInterface.h
    DYNComponentInterface.hpp
    DYNStepInterface.h
    DYNStateVariable.h
    DYNStateVariable.hpp
    DYNStaticParameter.h
    DYNStaticParameter.hpp
    DYNConverterInterface.h
    DYNServiceManagerInterface.h
    DYNCurrentLimits.h
    DYNReactiveCurvePointsInterface.h
    DYNDataInterfaceImpl.h
    DYNCriteria.h
    )

set(DATA_INTERFACE_FACTORY_SOURCES
    DYNDataInterfaceFactory.cpp
    )

set(DATA_INTERFACE_FACTORY_INCLUDE_HEADERS
    DYNDataInterfaceFactory.h
    )

add_library(dynawo_DataInterface SHARED ${DATA_INTERFACE_SOURCES})

target_include_directories(dynawo_DataInterface
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    $<TARGET_PROPERTY:dynawo_API_CRT,INTERFACE_INCLUDE_DIRECTORIES>
  PUBLIC
    $<TARGET_PROPERTY:dynawo_API_LEQ,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_include_directories(dynawo_DataInterface SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_DataInterface
  PUBLIC
    Boost::system
  PRIVATE
    dynawo_Common
    dynawo_ModelerCommon
    dynawo_API_CRT
    dynawo_API_TL
  )

set_target_properties(dynawo_DataInterface PROPERTIES VERSION ${DATA_INTERFACE_VERSION_STRING}
                                                    SOVERSION ${DATA_INTERFACE_VERSION_MAJOR})

add_library(dynawo_DataInterfaceFactory SHARED ${DATA_INTERFACE_FACTORY_SOURCES})

target_link_libraries(dynawo_DataInterfaceFactory
  PUBLIC
    dynawo_Common
    dynawo_DataInterface
    dynawo_DataInterfaceIIDM
  PRIVATE
    dynawo_ModelerCommon
)

set_target_properties(dynawo_DataInterfaceFactory PROPERTIES VERSION ${DATA_INTERFACE_FACTORY_VERSION_STRING}
                                                             SOVERSION ${DATA_INTERFACE_VERSION_MAJOR})

install(TARGETS dynawo_DataInterface dynawo_DataInterfaceFactory EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${DATA_INTERFACE_INCLUDE_HEADERS} ${DATA_INTERFACE_FACTORY_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()

add_subdirectory(PowSyblIIDM)
