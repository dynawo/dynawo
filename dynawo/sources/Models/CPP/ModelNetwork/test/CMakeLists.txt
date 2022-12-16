# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

set(MODULE_NAME MODELS_MODELNETWORK_unittest)

set(MODULE_SOURCES
    TestIIDMInitializationFlow.cpp
    TestDerivatives.cpp
    TestBus.cpp
    TestSwitch.cpp
    TestDanglingLine.cpp
    TestCurrentLimits.cpp
    TestGenerator.cpp
    TestHvdcLink.cpp
    TestLine.cpp
    TestLoad.cpp
    TestTapChanger.cpp
    TestShuntCompensator.cpp
    TestStaticVarCompensator.cpp
    TestThreeWindingsTransformer.cpp
    TestTwoWindingsTransformer.cpp
)

add_executable(${MODULE_NAME} ${MODULE_SOURCES})

target_include_directories(${MODULE_NAME}
  PRIVATE
    $<TARGET_PROPERTY:IIDM::iidm,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(${MODULE_NAME}
  dynawo_DataInterfaceIIDM
  dynawo_DataInterface
  dynawo_ModelerCommon
  DYNModelNetwork
  dynawo_API_CSTR
  dynawo_API_TL
  IIDM::iidm
  dynawo_Test)

add_custom_target(${MODULE_NAME}-tests
  COMMAND ${CMAKE_COMMAND} -E env "${runtime_tests_PATH}" $<TARGET_FILE:${MODULE_NAME}>
  DEPENDS
    ${MODULE_NAME}
  COMMENT "Running ${MODULE_NAME}...")

if(BUILD_TESTS_COVERAGE)
  set(EXTRACT_PATTERNS "'*/sources/Models/CPP/ModelNetwork/DYN*'")

  add_test_coverage(${MODULE_NAME}-tests "${EXTRACT_PATTERNS}")
endif()

if(BUILD_TESTS)
  add_test(${MODULE_NAME}-tests)
endif()
