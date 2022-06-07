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
set(DATA_INTERFACE_IIDM_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(DATA_INTERFACE_IIDM_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(DATA_INTERFACE_IIDM_SOURCES
    DYNBatteryInterfaceIIDM.cpp
    DYNBusInterfaceIIDM.cpp
    DYNCalculatedBusInterfaceIIDM.cpp
    DYNSwitchInterfaceIIDM.cpp
    DYNLineInterfaceIIDM.cpp
    DYNTwoWTransformerInterfaceIIDM.cpp
    DYNThreeWTransformerInterfaceIIDM.cpp
    DYNLoadInterfaceIIDM.cpp
    DYNShuntCompensatorInterfaceIIDM.cpp
    DYNStaticVarCompensatorInterfaceIIDM.cpp
    DYNGeneratorInterfaceIIDM.cpp
    DYNDanglingLineInterfaceIIDM.cpp
    DYNNetworkInterfaceIIDM.cpp
    DYNPhaseTapChangerInterfaceIIDM.cpp
    DYNRatioTapChangerInterfaceIIDM.cpp
    DYNStepInterfaceIIDM.cpp
    DYNCurrentLimitInterfaceIIDM.cpp
    DYNDataInterfaceIIDM.cpp
    DYNVoltageLevelInterfaceIIDM.cpp
    DYNVscConverterInterfaceIIDM.cpp
    DYNLccConverterInterfaceIIDM.cpp
    DYNHvdcLineInterfaceIIDM.cpp
    DYNServiceManagerInterfaceIIDM.cpp
    )

set(DATA_INTERFACE_IIDM_INCLUDE_HEADERS
    DYNDataInterfaceIIDM.h
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
    dynawo_API_CRT
    dynawo_API_LEQ
  PUBLIC
    dynawo_DataInterface
    iidm-ext-activeseason-xml
    iidm-ext-activepowercontrol-xml
    iidm-ext-busbarsectionposition-xml
    iidm-ext-connectableposition-xml
    iidm-ext-currentlimitsperseason-xml
    iidm-ext-generatoractivepowercontrol-xml
    iidm-ext-generatorentsoecategory-xml
    iidm-ext-generatorstartup-xml
    iidm-ext-hvdcangledroopactivepowercontrol-xml
    iidm-ext-hvdcoperatoractivepowerrange-xml
    iidm-ext-loaddetail-xml
    iidm-ext-standbyautomaton-xml
  )

set_target_properties(dynawo_DataInterfaceIIDM PROPERTIES VERSION ${DATA_INTERFACE_IIDM_VERSION_STRING}
                                                    SOVERSION ${DATA_INTERFACE_IIDM_VERSION_MAJOR})

install(TARGETS dynawo_DataInterfaceIIDM EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${DATA_INTERFACE_IIDM_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
