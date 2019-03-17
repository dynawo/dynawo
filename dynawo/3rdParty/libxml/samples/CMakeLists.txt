# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libxml, a library to handle XML files parsing.

set(RESOURCES
    res/example_nok.xml
    res/example_ok.xml
    res/example.xsd)
file(COPY ${RESOURCES} DESTINATION res)


if(LibXML_SAX_BUILD_PARSER)
  add_executable(sampleFormatter sampleFormatter.cpp)
  target_link_libraries(sampleFormatter XMLSAXFormatter${LINK_SUFFIX_TEST})
  target_include_directories(sampleFormatter
    PUBLIC
      $<BUILD_INTERFACE:${XML_formatter_SOURCE_DIR}/include>
      $<BUILD_INTERFACE:${XML_common_SOURCE_DIR}/include>)

  add_executable(sampleFormatter2 sampleFormatter2.cpp)
  target_link_libraries(sampleFormatter2 XMLSAXFormatter${LINK_SUFFIX_TEST})
  target_include_directories(sampleFormatter2
    PUBLIC
      $<BUILD_INTERFACE:${XML_formatter_SOURCE_DIR}/include>
      $<BUILD_INTERFACE:${XML_common_SOURCE_DIR}/include>)

  add_executable(sampleFormatterWithException sampleFormatterWithException.cpp)
  target_link_libraries(sampleFormatterWithException XMLSAXFormatter${LINK_SUFFIX_TEST})
  target_include_directories(sampleFormatter2
    PUBLIC
      $<BUILD_INTERFACE:${XML_formatter_SOURCE_DIR}/include>
      $<BUILD_INTERFACE:${XML_common_SOURCE_DIR}/include>)

  add_executable(sampleFormatterWithException2 sampleFormatterWithException2.cpp)
  target_link_libraries(sampleFormatterWithException2 XMLSAXFormatter${LINK_SUFFIX_TEST})
  target_include_directories(sampleFormatterWithException2
    PUBLIC
      $<BUILD_INTERFACE:${XML_formatter_SOURCE_DIR}/include>
      $<BUILD_INTERFACE:${XML_common_SOURCE_DIR}/include>)
endif()

if(LibXML_SAX_BUILD_PARSER)
  # add_executable(sampleParser sampleParser.cpp sampleXmlHandler.cpp)
  # target_link_libraries(sampleParser XMLSAXParser "-framework CoreFoundation -framework CoreServices")

  add_executable(sampleChainHandler sampleChainHandler.cpp)
  target_link_libraries(sampleChainHandler XMLSAXParser${LINK_SUFFIX_TEST} pthread "-framework CoreFoundation -framework CoreServices")

  add_executable(sampleChainHandler-boost sampleChainHandler-boost.cpp)
  target_link_libraries(sampleChainHandler-boost XMLSAXParser${LINK_SUFFIX_TEST} pthread "-framework CoreFoundation -framework CoreServices")

  if(COMPILER_SUPPORTS_CXX11 OR COMPILER_SUPPORTS_CXX14)
    add_executable(sampleChainHandler-c11 sampleChainHandler-c11.cpp)
    target_link_libraries(sampleChainHandler-c11 XMLSAXParser${LINK_SUFFIX_TEST} pthread "-framework CoreFoundation -framework CoreServices")
  endif()

endif()

if(LibXML_SAX_BUILD_PARSER)
  add_executable(tree_test tree_test.cpp)
  target_link_libraries(tree_test XMLSAXParser${LINK_SUFFIX_TEST})
  target_include_directories(tree_test
    PUBLIC
      $<BUILD_INTERFACE:${XML_parser_SOURCE_DIR}/include>
      $<BUILD_INTERFACE:${XML_common_SOURCE_DIR}/include>)

  add_executable(tree2_test tree2_test.cpp)
  target_link_libraries(tree2_test XMLSAXParser${LINK_SUFFIX_TEST})
  target_include_directories(tree2_test
    PUBLIC
      $<BUILD_INTERFACE:${XML_parser_SOURCE_DIR}/include>
      $<BUILD_INTERFACE:${XML_common_SOURCE_DIR}/include>)
endif()

if(LibXML_SAX_BUILD_PARSER AND LibXML_SAX_BUILD_PARSER)

endif()
