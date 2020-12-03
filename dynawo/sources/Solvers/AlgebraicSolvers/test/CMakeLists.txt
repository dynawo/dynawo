# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

set(MODULE_NAME SOLVERKINSOL_unittest)

set(MODULE_SOURCES
    TestBasics.cpp
)

add_executable(${MODULE_NAME} ${MODULE_SOURCES})

target_include_directories(${MODULE_NAME}
  PRIVATE
    $<TARGET_PROPERTY:Sundials::Sundials_KINSOL,INTERFACE_INCLUDE_DIRECTORIES>
    $<TARGET_PROPERTY:Sundials::Sundials_SUNLINSOLKLU,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(${MODULE_NAME}
  dynawo_Test
  dynawo_SolverKINSOL
  dynawo_ModelerCommon
  dynawo_API_DYD
  dynawo_API_TL
  dynawo_DataInterface)

add_custom_target(${MODULE_NAME}-tests
  COMMAND ${CMAKE_COMMAND} -E env "${runtime_tests_PATH}" "DYNAWO_XSD_DIR=./" $<TARGET_FILE:${MODULE_NAME}>
  DEPENDS
    ${MODULE_NAME}-pre-tests
    ${MODULE_NAME}
  COMMENT "Running ${MODULE_NAME}...")

add_custom_target(${MODULE_NAME}-pre-tests
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/dyd ${CMAKE_CURRENT_BINARY_DIR}/dyd
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/../../../API/DYD/xsd/ ${CMAKE_CURRENT_BINARY_DIR}/
  )

if(DYNAWO_BUILD_TESTS_COVERAGE)
  set(EXTRACT_PATTERNS "'*/sources/Solvers/AlgebraicSolvers/DYN*'")

  add_test_coverage(${MODULE_NAME}-tests "${EXTRACT_PATTERNS}")
endif()

if(DYNAWO_BUILD_TESTS)
  add_test(${MODULE_NAME}-tests)
endif()
