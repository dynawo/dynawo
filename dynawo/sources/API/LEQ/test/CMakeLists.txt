# Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite
# of simulation tools for power systems.

set(MODULE_NAME LEQ_unittest)

set(MODULE_SOURCES
  TestLostEquipment.cpp
  TestLostEquipmentsCollection.cpp
  )

add_executable(${MODULE_NAME} ${MODULE_SOURCES})

target_link_libraries(${MODULE_NAME}
  dynawo_API_LEQ
  dynawo_Test
  )

add_custom_target(${MODULE_NAME}-pre-tests
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/../xsd/ ${CMAKE_CURRENT_BINARY_DIR}/
  )

add_custom_target(${MODULE_NAME}-tests
  COMMAND ${CMAKE_COMMAND} -E env "${runtime_tests_PATH}" "DYNAWO_XSD_DIR=./" $<TARGET_FILE:${MODULE_NAME}>
  DEPENDS
    ${MODULE_NAME}-pre-tests
    ${MODULE_NAME}
  COMMENT "Running ${MODULE_NAME}..."
  )

if(BUILD_TESTS_COVERAGE)
  set(EXTRACT_PATTERNS "'*/API/LEQ/LEQ*'")

  add_test_coverage(${MODULE_NAME}-tests "${EXTRACT_PATTERNS}")
endif()

if(BUILD_TESTS)
  add_test_run(${MODULE_NAME}-tests)
endif()
