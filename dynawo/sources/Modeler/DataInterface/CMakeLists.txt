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

set(DATA_INTERFACE_SOURCES
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
    DYNComponentInterface.cpp
    DYNCurrentLimitInterfaceIIDM.cpp
    DYNStateVariable.cpp
    DYNStaticParameter.cpp
    DYNDataInterfaceIIDM.cpp
    DYNVoltageLevelInterfaceIIDM.cpp
    DYNVscConverterInterfaceIIDM.cpp
    DYNLccConverterInterfaceIIDM.cpp
    DYNHvdcLineInterfaceIIDM.cpp
    )

set(DATA_INTERFACE_INCLUDE_HEADERS
    DYNDataInterface.h
    DYNDataInterfaceIIDM.h
    )

add_library(dynawo_DataInterface ${LIBRARY_TYPE} ${DATA_INTERFACE_SOURCES})

target_include_directories(dynawo_DataInterface
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )

target_link_libraries(dynawo_DataInterface
  PRIVATE
    dynawo_Common
    dynawo_ModelerCommon
    iidm-ext-activeseason-xml
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

set_target_properties(dynawo_DataInterface PROPERTIES VERSION ${DATA_INTERFACE_VERSION_STRING}
                                                    SOVERSION ${DATA_INTERFACE_VERSION_MAJOR})

install(TARGETS dynawo_DataInterface EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${DATA_INTERFACE_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
