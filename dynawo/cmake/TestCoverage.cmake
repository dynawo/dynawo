# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

if (NOT (CMAKE_BUILD_TYPE STREQUAL "Debug" OR BUILD_TESTS_COVERAGE))
    message(WARNING "Code coverage results with an optimized build may be misleading")
endif()

# Compilation flags
set(COVERAGE_CXX_FLAGS "-g -O0 -fprofile-arcs -ftest-coverage -D_DEBUG_")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${COVERAGE_CXX_FLAGS}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${COVERAGE_CXX_FLAGS}")

# Linker flags
set(COVERAGE_LINKER_FLAGS "--coverage")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${COVERAGE_LINKER_FLAGS}")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${COVERAGE_LINKER_FLAGS}")

# Test coverage options
set(LCOV_EXCLUDE_PATTERNS "" CACHE STRING "lcov exclude patterns.")
set(LCOV_OUTPUT_FILE "${CMAKE_BINARY_DIR}/coverage/coverage.info" CACHE STRING "lcov output file.")
set(GENHTML_OUTPUT_DIR "${CMAKE_BINARY_DIR}/coverage" CACHE STRING "genhtml output directory.")

if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
  find_program(GCOV_PATH gcov)
  if (NOT GCOV_PATH)
    message(FATAL_ERROR "gcov not found")
  endif()
  set(GCOV_TOOL "${GCOV_PATH}")
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
  find_program(LLVM-COV_PATH llvm-cov)
  if (NOT LLVM-COV_PATH)
    message(FATAL_ERROR "llvm-cov not found")
  endif()
  configure_file(cmake/llvm-gcov.in llvm-gcov @ONLY)
  install(PROGRAMS ${CMAKE_BINARY_DIR}/llvm-gcov DESTINATION ${CMAKE_BINARY_DIR}/coverage)
  set(GCOV_TOOL "${CMAKE_BINARY_DIR}/coverage/llvm-gcov")
endif()

set(GENHTML_OPTIONS "")
find_program(GENHTML_PATH genhtml)
if (NOT GENHTML_PATH)
  message(FATAL_ERROR "genhtml not found")
else()
  execute_process(COMMAND ${GENHTML_PATH} "--version" OUTPUT_VARIABLE GENHTML_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE)
  # version is written as genhtml: LCOV version <version>
  # works on string to keep only version
  set( VERSION ${GENHTML_VERSION} )
  separate_arguments(VERSION)
  list(GET VERSION -1 VERSION_NUMBER)

  set(GENHTML_OPTIONS "--no-function-coverage" )
endif()

find_program(LCOV_PATH lcov)
if (NOT LCOV_PATH)
  message(FATAL_ERROR "lcov not found")
endif()

function(add_test_coverage_common test-target)
  add_custom_target(${test-target}-coverage
    COMMAND ${GENHTML_PATH} ${GENHTML_OPTIONS} -o ${GENHTML_OUTPUT_DIR} ${LCOV_OUTPUT_FILE}
    DEPENDS ${test-target}-launch)
  add_dependencies(tests-coverage-run ${test-target}-launch)
endfunction()

function(add_test_coverage test-target extract_patterns)
   ## report generation for test
   add_custom_target(${test-target}-launch
     COMMAND ${LCOV_PATH} --directory ${CMAKE_CURRENT_BINARY_DIR}/../ --gcov-tool ${GCOV_TOOL} --capture --output-file ${LCOV_OUTPUT_FILE}.${test-target}
     COMMAND ${LCOV_PATH} --extract ${LCOV_OUTPUT_FILE}.${test-target} ${extract_patterns} --output-file ${LCOV_OUTPUT_FILE}.${test-target}.filtered
     COMMAND cat ${LCOV_OUTPUT_FILE}.${test-target}.filtered >> ${LCOV_OUTPUT_FILE}
     DEPENDS ${test-target})
   add_test_coverage_common(${test-target})
endfunction()

# Special function to handle solver fixed time step case with two directories added to the coverage
function(add_test_coverage_two_directories test-target extract_patterns)
  ## report generation for test
  add_custom_target(${test-target}-launch
    COMMAND ${LCOV_PATH} --directory ${CMAKE_CURRENT_BINARY_DIR}/../ --gcov-tool ${GCOV_TOOL} --capture --output-file ${LCOV_OUTPUT_FILE}.${test-target}
    COMMAND ${LCOV_PATH} --directory ${CMAKE_CURRENT_BINARY_DIR}/../../ --gcov-tool ${GCOV_TOOL} --capture --output-file ${LCOV_OUTPUT_FILE}.${test-target}
    COMMAND ${LCOV_PATH} --extract ${LCOV_OUTPUT_FILE}.${test-target} ${extract_patterns} --output-file ${LCOV_OUTPUT_FILE}.${test-target}.filtered
    COMMAND cat ${LCOV_OUTPUT_FILE}.${test-target}.filtered >> ${LCOV_OUTPUT_FILE}
    DEPENDS ${test-target})
  add_test_coverage_common(${test-target})
endfunction()

add_custom_target(reset-coverage
  COMMAND ${LCOV_PATH} --directory ${CMAKE_BINARY_DIR} --zerocounters
  COMMAND rm -f ${LCOV_OUTPUT_FILE}
  COMMAND ${CMAKE_COMMAND} -E make_directory ${GENHTML_OUTPUT_DIR})

add_custom_target(tests-coverage-run
  COMMENT "launch each unit test for coverage")

add_custom_target(export-coverage
  COMMAND ${GENHTML_PATH} ${GENHTML_OPTIONS} -o ${GENHTML_OUTPUT_DIR} ${LCOV_OUTPUT_FILE} )
