# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libxml, a library to handle XML files parsing.

project(XML_parser_test CXX)

set(CPACK_COMPONENT_SAX-PARSER-TESTS_DISPLAY_NAME "XML parser library tests")
set(CPACK_COMPONENT_SAX-PARSER-TESTS_DEPENDS sax-common sax-parser)

find_package(GTest REQUIRED)

# tests programs.
# each <name>.cpp file defining a test is transformed as:
# a program <name> or <name>.exe,
# the related build target (<name>)
# a test target (test-<name>) to use as "make test-<name>"
# a test target (test-<name>) to use as "make test-<name>"
set(PARSER_TESTS
  ElementName
  Attributes
  Path
  PathTree

	DocumentHandler

  ElementHandler
  SimpleElementHandler
	CDataCollector

  ComposableBase
	ComposableDocumentHandler

  Parser
)

set(PARSER_TESTS_SUPPORT)

add_custom_target(tests-sax-parser)
add_dependencies(tests tests-sax-parser)

# disabling some gcc warnings with old XercesC.
if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
  # one test raises this error without needs (only copies doubles and compares original and copy)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-float-equal")

  if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.9)
    # those are gtest 1.8 warnings in g++ 4.8.5
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-long-long -Wno-variadic-macros -Wno-pedantic")
  endif()
endif()


# for each of PARSER_TESTS
foreach(TEST IN LISTS PARSER_TESTS)
  add_executable(${TEST}
    ${TEST}.test.cpp
    ${PARSER_TESTS_SUPPORT}
  )
  
  target_include_directories(${TEST}
    PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../common/tests/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/${LibXML_INSTALL_INCLUDE}>
    ${Boost_INCLUDE_DIRS}
    ${GTEST_INCLUDE_DIRS}
  )

  target_link_libraries(${TEST}
    XMLSAXParser${LINK_SUFFIX_TEST}
    ${GTEST_BOTH_LIBRARIES}
    pthread
    "-framework CoreFoundation -framework CoreServices"
  )

  add_custom_target(test-${TEST}
    DEPENDS ${TEST}
    COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${TEST}
    COMMENT "executing tests for ${TEST}"
  )
  add_dependencies(tests-sax-parser test-${TEST})
endforeach(TEST)
