# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

set(MODULE_NAME SOLVERIDA_unittest)

set(MODULE_SOURCES
  TestBasics.cpp
)

add_executable(${MODULE_NAME} ${MODULE_SOURCES})

target_link_libraries(${MODULE_NAME}
  dynawo_ModelerCommon
  dynawo_API_PAR
  dynawo_API_TL
  dynawo_SolverIDA
  dynawo_SolverCommon
  dynawo_API_DYD
  dynawo_CPPModelsCommon
  IIDM::iidm
  dynawo_Test
)

target_link_libraries(${MODULE_NAME}
  dynawo_DataInterfaceIIDM
  dynawo_DataInterface
)

add_custom_target(${MODULE_NAME}-tests
  COMMAND ${CMAKE_COMMAND} -E env "${runtime_tests_PATH}" "${runtime_PATH}" "DYNAWO_XSD_DIR=./"
    "DYNAWO_INSTALL_DIR=${installdir}"
    "DYNAWO_DDB_DIR=${ddbdir}"
    "DYNAWO_SCRIPTS_DIR=${sbindir}"
    "DYNAWO_RESOURCES_DIR=${sharedir}"
    "DYNAWO_DICTIONARIES=dictionaries_mapping"
    "DYNAWO_ADEPT_INSTALL_DIR=${ADEPT_HOME}"
    "DYNAWO_INSTALL_OPENMODELICA=${INSTALL_OPENMODELICA}"
    "OPENMODELICAHOME=${OPENMODELICAHOME}"
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
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/jobs ${CMAKE_CURRENT_BINARY_DIR}/jobs
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/../../../../API/DYD/xsd/ ${CMAKE_CURRENT_BINARY_DIR}/
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/../../../../API/PAR/xsd/ ${CMAKE_CURRENT_BINARY_DIR}/
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/../../../../API/EXTVAR/xsd/ ${CMAKE_CURRENT_BINARY_DIR}/
  )

if(BUILD_TESTS_COVERAGE)
  set(EXTRACT_PATTERNS "'*/sources/Solvers/SolverIDA/DYN*'")

  add_test_coverage(${MODULE_NAME}-tests "${EXTRACT_PATTERNS}")
endif()

if(BUILD_TESTS)
  add_test_run(${MODULE_NAME}-tests)
endif()
