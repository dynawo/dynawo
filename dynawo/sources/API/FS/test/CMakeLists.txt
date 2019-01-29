# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
# 
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

SET(MODULE_NAME FS_unittest)

SET(MODULE_SOURCES
    TestFinalStateCollection.cpp
    TestModel.cpp
    TestVariable.cpp
    TestXmlImporter.cpp
)

INCLUDE_DIRECTORIES(SYSTEM ${UNITTEST_INCLUDE_DIRS}
                    ${Boost_INCLUDE_DIR}
                    )

INCLUDE_DIRECTORIES(../
                    ../../../Common/
                    )

ADD_EXECUTABLE(${MODULE_NAME} ${MODULE_SOURCES})

TARGET_LINK_LIBRARIES(${MODULE_NAME} dynawo_API_FS ${UNITTEST_LIBRARIES})

ADD_CUSTOM_TARGET(${MODULE_NAME}-pre-tests
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/res ${CMAKE_CURRENT_BINARY_DIR}/res
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/../xsd/ ${CMAKE_CURRENT_BINARY_DIR}/
  )

ADD_CUSTOM_TARGET(${MODULE_NAME}-tests ${MODULE_NAME}
  DEPENDS
    ${MODULE_NAME}-pre-tests
    ${MODULE_NAME}
  COMMENT "Running ${MODULE_NAME}...")

IF(CMAKE_BUILD_TYPE STREQUAL "TestCoverage")
  SET(EXTRACT_PATTERNS "'*/API/FS/FS*'")

  ADD_TEST_COVERAGE(${MODULE_NAME}-tests "${EXTRACT_PATTERNS}")
ENDIF()

IF(CMAKE_BUILD_TYPE STREQUAL "Tests")
  ADD_TEST(${MODULE_NAME}-tests)
ENDIF()

