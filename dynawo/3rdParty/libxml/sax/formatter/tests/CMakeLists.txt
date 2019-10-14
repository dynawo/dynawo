# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libxml, a library to handle XML files parsing.

project(XML_formatter_test CXX)

set(CPACK_COMPONENT_SAX-FORMATTER-TESTS_DISPLAY_NAME "XML formatter library tests")
set(CPACK_COMPONENT_SAX-FORMATTER-TESTS_DEPENDS sax-common sax-formatter)

# workaround to find GTest 1.8.1 even in Debug
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  find_package(GTest QUIET)
  if(NOT GTEST_FOUND)
    set(GTEST_LIBRARY ${GTEST_LIBRARY_DEBUG})
    set(GTEST_MAIN_LIBRARY ${GTEST_MAIN_LIBRARY_DEBUG})
  endif()
endif()
find_package(GTest REQUIRED)

# tests programs.
# each <name>.cpp file defining a test is transformed as:
# a program <name> or <name>.exe,
# the related build target (<name>)
# a test target (test-<name>) to use as "make test-<name>"
# a test target (test-<name>) to use as "make test-<name>"
set(FORMATTER_TESTS
  AttributeList
  Formatter
  Document
)

set(FORMATTER_TESTS_SUPPORT)

add_custom_target(tests-sax-formatter)
add_dependencies(tests tests-sax-formatter)


if('${CMAKE_CXX_COMPILER_ID}' STREQUAL 'GNU')
  if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.9)
    # those are gtest 1.8 warnings in g++ 4.8.5
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-long-long -Wno-variadic-macros -Wno-pedantic")
  endif()
endif()

# for each of PARSER_TESTS
foreach(TEST IN LISTS FORMATTER_TESTS)
  add_executable(${TEST}
    ${TEST}.test.cpp
    ${FORMATTER_TESTS_SUPPORT}
  )

  target_include_directories(${TEST}
    PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../common/tests/include>
    $<INSTALL_INTERFACE:${LibXML_INSTALL_INCLUDE}>
    ${Boost_INCLUDE_DIRS}
    ${GTEST_INCLUDE_DIRS}
  )

  target_link_libraries(${TEST}
    XMLSAXFormatter${LINK_SUFFIX_TEST}
    ${GTEST_BOTH_LIBRARIES}
    $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:pthread>
  )

  add_custom_target(test-${TEST}
    DEPENDS ${TEST}
    COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${TEST}
    COMMENT "executing tests for ${TEST}"
  )
  add_dependencies(tests-sax-formatter test-${TEST})
endforeach(TEST)
