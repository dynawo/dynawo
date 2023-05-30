# Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
set(DATA_INTERFACE_IIDM_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(DATA_INTERFACE_IIDM_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(DATA_INTERFACE_IIDM_SOURCES
  DYNBatteryInterfaceIIDM.cpp
  DYNBusInterfaceIIDM.cpp
  DYNCalculatedBusInterfaceIIDM.cpp
  DYNCurrentLimitInterfaceIIDM.cpp
  DYNDanglingLineInterfaceIIDM.cpp
  DYNDataInterfaceIIDM.cpp
  DYNFictBusInterfaceIIDM.cpp
  DYNFictTwoWTransformerInterfaceIIDM.cpp
  DYNFictVoltageLevelInterfaceIIDM.cpp
  DYNGeneratorInterfaceIIDM.cpp
  DYNHvdcLineInterfaceIIDM.cpp
  DYNLccConverterInterfaceIIDM.cpp
  DYNLineInterfaceIIDM.cpp
  DYNLoadInterfaceIIDM.cpp
  DYNNetworkInterfaceIIDM.cpp
  DYNPhaseTapChangerInterfaceIIDM.cpp
  DYNRatioTapChangerInterfaceIIDM.cpp
  DYNShuntCompensatorInterfaceIIDM.cpp
  DYNStaticVarCompensatorInterfaceIIDM.cpp
  DYNStepInterfaceIIDM.cpp
  DYNSwitchInterfaceIIDM.cpp
  DYNThreeWTransformerInterfaceIIDM.cpp
  DYNTwoWTransformerInterfaceIIDM.cpp
  DYNVoltageLevelInterfaceIIDM.cpp
  DYNVscConverterInterfaceIIDM.cpp
  DYNServiceManagerInterfaceIIDM.cpp
  DYNIIDMExtensionsTraits.cpp
  DYNIIDMExtensions.cpp
)

set(DATA_INTERFACE_IIDM_HEADERS
  DYNStaticVarCompensatorInterfaceIIDMExtension.h
  DYNActiveSeasonIIDMExtension.h
  DYNCurrentLimitsPerSeasonIIDMExtension.h
  DYNGeneratorActivePowerControlIIDMExtension.h
  )

add_library(dynawo_DataInterfaceIIDM SHARED ${DATA_INTERFACE_IIDM_SOURCES})

target_include_directories(dynawo_DataInterfaceIIDM
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )

target_include_directories(dynawo_DataInterfaceIIDM SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_DataInterfaceIIDM
  PRIVATE
    dynawo_Common
    dynawo_ModelerCommon
    dynawo_DataInterface
    dynawo_API_CRT
    dynawo_API_LEQ
    ${CMAKE_DL_LIBS}
  PUBLIC
    IIDM::iidm
    IIDM::ext-iidm
  )

set_target_properties(dynawo_DataInterfaceIIDM PROPERTIES VERSION ${DATA_INTERFACE_IIDM_VERSION_STRING}
                                                    SOVERSION ${DATA_INTERFACE_IIDM_VERSION_MAJOR})

install(TARGETS dynawo_DataInterfaceIIDM EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${DATA_INTERFACE_IIDM_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
