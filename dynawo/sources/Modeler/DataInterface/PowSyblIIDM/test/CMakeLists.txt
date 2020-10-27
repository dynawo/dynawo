# Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

set(MODULE_NAME MODELER_DATAINTERFACEIIDM_unittest)

set(MODULE_SOURCES
  TestBusInterface.cpp
#  TestBusBarSectionInterface.cpp
#  TestCalculatedBusInterface.cpp
  TestCurrentLimitInterface.cpp
  TestInjectorInterface.cpp
  TestLineInterface.cpp
  TestLoadInterface.cpp
  TestRatioTapChangerInterface.cpp
  TestStepInterface.cpp
  TestSwitchInterface.cpp
  TestVscConverterInterface.cpp
)

add_executable(${MODULE_NAME} ${MODULE_SOURCES})

target_link_libraries(${MODULE_NAME}
  dynawo_API_PAR
  dynawo_API_CRT
  dynawo_ModelerCommon
  dynawo_DataInterfaceIIDM
  dynawo_DataInterface
  IIDM::iidm
  dynawo_Test)

add_custom_target(${MODULE_NAME}-tests
  COMMAND ${CMAKE_COMMAND} -E env "${runtime_tests_PATH}" $<TARGET_FILE:${MODULE_NAME}>
  DEPENDS
    ${MODULE_NAME}
  COMMENT "Running ${MODULE_NAME}...")

if(CMAKE_BUILD_TYPE STREQUAL "TestCoverage")
  set(EXTRACT_PATTERNS "'*/sources/Modeler/DataInterface/PowSyblIIDM/DYN*'")

  add_test_coverage(${MODULE_NAME}-tests "${EXTRACT_PATTERNS}")
endif()

if(CMAKE_BUILD_TYPE STREQUAL "Tests")
  add_test(${MODULE_NAME}-tests)
endif()
