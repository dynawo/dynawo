# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

set(MODULE_NAME MODELER_UTILS_unittest)

set(MODULE_SOURCES
    TestDumpModel.cpp
    TestGeneratePreassembled.cpp
)

add_executable(${MODULE_NAME} ${MODULE_SOURCES})

target_include_directories(${MODULE_NAME}
        PRIVATE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../>
        )

target_link_libraries(${MODULE_NAME}
        dynawo_Common
        dynawo_Test)

add_custom_target(${MODULE_NAME}-tests
  COMMAND ${CMAKE_COMMAND} -E env "${runtime_tests_PATH}" "${runtime_PATH}" "DYNAWO_XSD_DIR=./"
    "DYNAWO_SCRIPTS_DIR=${sbindir}"
    "DYNAWO_DDB_DIR=./res"
    "DYNAWO_RESOURCES_DIR=${sharedir}"
    "DYNAWO_DICTIONARIES=dictionaries_mapping"
    "DYNAWO_INSTALL_DIR=${installdir}"
    "DYNAWO_ADEPT_INSTALL_DIR=${ADEPT_HOME}"
    "DYNAWO_INSTALL_OPENMODELICA=${INSTALL_OPENMODELICA}"
    "DYNAWO_XERCESC_INSTALL_DIR=${XERCESC_HOME}"
    "DYNAWO_SUITESPARSE_INSTALL_DIR=${SUITESPARSE_HOME}"
    "DYNAWO_SUNDIALS_INSTALL_DIR=${SUNDIALS_HOME}"
    "DYNAWO_BOOST_HOME=${BOOST_ROOT}"
    "DYNAWO_LIBXML_HOME=${LIBXML_HOME}"
    $<TARGET_FILE:${MODULE_NAME}>
  DEPENDS
    ${MODULE_NAME}-pre-tests
    ${MODULE_NAME}
  COMMENT "Running ${MODULE_NAME}...")

add_custom_target(${MODULE_NAME}-pre-tests
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/res ${CMAKE_CURRENT_BINARY_DIR}/res
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/../../../API/DYD/xsd/ ${CMAKE_CURRENT_BINARY_DIR}/
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/../../../API/EXTVAR/xsd/ ${CMAKE_CURRENT_BINARY_DIR}/
  )

if(BUILD_TESTS_COVERAGE)
  set(EXTRACT_PATTERNS "'*/sources/Modeler/util/DYN*'")

  add_test_coverage(${MODULE_NAME}-tests "${EXTRACT_PATTERNS}")
endif()

if(BUILD_TESTS)
  add_test(${MODULE_NAME}-tests)
endif()
