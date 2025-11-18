# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

set(MODULE_NAME JOB_unittest)

set(MODULE_SOURCES
  TestAppenderEntry.cpp
  TestChannelEntry.cpp
  TestChannelsEntry.cpp
  TestClockEntry.cpp
  TestConstraintsEntry.cpp
  TestCurvesEntry.cpp
  TestDynModelsEntry.cpp
  TestFinalStateEntry.cpp
  TestFinalStateValuesEntry.cpp
  TestFinalValuesEntry.cpp
  TestInitialStateEntry.cpp
  TestInitValuesEntry.cpp
  TestInteractiveSettingsEntry.cpp
  TestJobCollection.cpp
  TestJobEntry.cpp
  TestLocalInitEntry.cpp
  TestLogsEntry.cpp
  TestLostEquipmentsEntry.cpp
  TestModelerEntry.cpp
  TestModelsDirEntry.cpp
  TestNetworkEntry.cpp
  TestOutputsEntry.cpp
  TestSimulationEntry.cpp
  TestSolverEntry.cpp
  TestStreamEntry.cpp
  TestStreamsEntry.cpp
  TestTimelineEntry.cpp
  TestXmlImporter.cpp
  )

add_executable(${MODULE_NAME} ${MODULE_SOURCES})

target_link_libraries(${MODULE_NAME}
        dynawo_API_JOB
        dynawo_Test)

add_custom_target(${MODULE_NAME}-pre-tests
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/res ${CMAKE_CURRENT_BINARY_DIR}/res
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/../xsd/ ${CMAKE_CURRENT_BINARY_DIR}/
  )

add_custom_target(${MODULE_NAME}-tests
  COMMAND ${CMAKE_COMMAND} -E env "${runtime_tests_PATH}" "DYNAWO_XSD_DIR=./" "DYNAWO_USE_XSD_VALIDATION=true" $<TARGET_FILE:${MODULE_NAME}>
  DEPENDS
    ${MODULE_NAME}-pre-tests
    ${MODULE_NAME}
  COMMENT "Running ${MODULE_NAME}...")

if(BUILD_TESTS_COVERAGE)
  set(EXTRACT_PATTERNS "'*/API/JOB/JOB*'")

  add_test_coverage(${MODULE_NAME}-tests "${EXTRACT_PATTERNS}")
endif()

if(BUILD_TESTS)
  add_test_run(${MODULE_NAME}-tests)
endif()
