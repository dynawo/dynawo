# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

SET(MODULE_NAME MODELS_MODELNETWORK_unittest)

SET(MODULE_SOURCES
    TestIIDMInitializationFlow.cpp
    TestDerivatives.cpp
    TestBus.cpp
    TestSwitch.cpp
    TestDanglingLine.cpp
    TestCurrentLimits.cpp
    TestGenerator.cpp
    TestHvdcLink.cpp
    TestLine.cpp
    TestTapChanger.cpp
)

ADD_EXECUTABLE(${MODULE_NAME} ${MODULE_SOURCES})

TARGET_INCLUDE_DIRECTORIES(${MODULE_NAME}
        PRIVATE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../>
        )

TARGET_LINK_LIBRARIES(${MODULE_NAME}
        dynawo_DataInterface
        DYNModelNetwork
        dynawo_API_CSTR
        dynawo_Test)

ADD_CUSTOM_TARGET(${MODULE_NAME}-tests
  COMMAND ${CMAKE_COMMAND} -E env "${runtime_tests_PATH}" $<TARGET_FILE:${MODULE_NAME}>
  DEPENDS
    ${MODULE_NAME}
  COMMENT "Running ${MODULE_NAME}...")

IF(CMAKE_BUILD_TYPE STREQUAL "TestCoverage")
  SET(EXTRACT_PATTERNS "'*/sources/Models/CPP/ModelNetwork/DYN*'")

  ADD_TEST_COVERAGE(${MODULE_NAME}-tests "${EXTRACT_PATTERNS}")
ENDIF()

IF(CMAKE_BUILD_TYPE STREQUAL "Tests")
  ADD_TEST(${MODULE_NAME}-tests)
ENDIF()
