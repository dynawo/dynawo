# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libxml, a library to handle XML files parsing.

project(XML_parser CXX)

set(CPACK_COMPONENT_SAX-PARSER_DISPLAY_NAME "XML parser library")
set(CPACK_COMPONENT_SAX-PARSER_DEPENDS sax-common)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/include/xml/sax/parser/ParserVersion.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/include/xml/sax/parser/ParserVersion.h
)

find_package(XercesC REQUIRED)

# disabling some gcc warnings with old XercesC.
if(XercesC_VERSION VERSION_LESS "3.0.0")
  if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-overflow -Wno-cast-qual")
  endif()
endif()


# Formatter targets
set(PARSER_SOURCES
  src/ElementName.cpp
  src/Attributes.cpp

  src/ComposableBase.cpp

  src/DocumentHandler.cpp
  src/ComposableDocumentHandler.cpp

  src/ElementHandler.cpp
  src/ComposableElementHandler.cpp
  src/SimpleElementHandler.cpp

  src/CDataCollector.cpp

  src/ParserException.cpp
  src/ParserFactory.cpp
  src/Parser.cpp
  src/XercescParser.cpp
  src/XercescStreamInputSource.cpp
)

# see README
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-parentheses -Wno-sign-compare")


if (LibXML_SAX_BUILD_SHARED)
  add_library(XMLSAXParser${LINK_SUFFIX_SHARED} SHARED ${PARSER_SOURCES})

  target_include_directories(XMLSAXParser${LINK_SUFFIX_SHARED}
    PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${XML_common_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/${LibXML_INSTALL_INCLUDE}>
    ${Boost_INCLUDE_DIRS}
    PRIVATE
    ${XercesC_INCLUDE_DIRS}
  )

  target_link_libraries(XMLSAXParser${LINK_SUFFIX_SHARED}
    ${XercesC_LIBRARIES}

  )

  set_target_properties(XMLSAXParser${LINK_SUFFIX_SHARED}
    PROPERTIES
      SOVERSION ${LIBXML_VERSION_MAJOR}
      VERSION ${LIBXML_VERSION}
  )

  install(TARGETS XMLSAXParser${LINK_SUFFIX_SHARED} EXPORT XMLSAXParser${LINK_SUFFIX_SHARED}-config
    PUBLIC_HEADER DESTINATION ${LibXML_INSTALL_INCLUDE}
    ARCHIVE DESTINATION ${LibXML_INSTALL_LIBRARIES}
    LIBRARY DESTINATION ${LibXML_INSTALL_LIBRARIES}
    RUNTIME DESTINATION ${LibXML_INSTALL_BINARIES}
    COMPONENT sax-parser
  )

  # installed config file for find_package
  install(EXPORT XMLSAXParser${LINK_SUFFIX_SHARED}-config
    DESTINATION ${LibXML_INSTALL_CMAKE}
    FILE libxml-sax-parser${LINK_SUFFIX_SHARED}-targets.cmake
    COMPONENT sax-parser
  )

  include(CMakePackageConfigHelpers)
  configure_package_config_file(libxml-sax-parser${LINK_SUFFIX_SHARED}-config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/libxml-sax-parser${LINK_SUFFIX_SHARED}-config.cmake
    INSTALL_DESTINATION ${LibXML_INSTALL_CMAKE}
    PATH_VARS
      LibXML_INSTALL_INCLUDE
      LibXML_INSTALL_LIBRARIES
      LibXML_INSTALL_BINARIES
    NO_CHECK_REQUIRED_COMPONENTS_MACRO
  )

  install(FILES ${CMAKE_CURRENT_BINARY_DIR}/libxml-sax-parser${LINK_SUFFIX_SHARED}-config.cmake
    DESTINATION ${LibXML_INSTALL_CMAKE}
    COMPONENT sax-parser
  )

endif ()

if (LibXML_SAX_BUILD_STATIC)
  find_package(CURL REQUIRED)
  find_package(ICU REQUIRED COMPONENTS i18n uc data)

  add_library(XMLSAXParser${LINK_SUFFIX_STATIC} STATIC ${PARSER_SOURCES})

  target_include_directories(XMLSAXParser${LINK_SUFFIX_STATIC}
    PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${XML_common_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/${LibXML_INSTALL_INCLUDE}>
    ${Boost_INCLUDE_DIRS}
    PRIVATE
    ${XercesC_INCLUDE_DIRS}
  )

  set_target_properties(XMLSAXParser${LINK_SUFFIX_STATIC}
    PROPERTIES
      OUTPUT_NAME XMLParser
      SOVERSION ${LIBXML_VERSION_MAJOR}
      VERSION ${LIBXML_VERSION}
  )

  target_link_libraries(XMLSAXParser${LINK_SUFFIX_STATIC}
    ${XercesC_LIBRARIES}
    ${CURL_LIBRARIES}
    ${ICU_LIBRARIES}
  )

  install(TARGETS XMLSAXParser${LINK_SUFFIX_STATIC} EXPORT XMLSAXParser${LINK_SUFFIX_STATIC}-config
    PUBLIC_HEADER DESTINATION ${LibXML_INSTALL_INCLUDE}
    ARCHIVE DESTINATION ${LibXML_INSTALL_LIBRARIES}
    LIBRARY DESTINATION ${LibXML_INSTALL_LIBRARIES}
    RUNTIME DESTINATION ${LibXML_INSTALL_BINARIES}
    COMPONENT sax-parser
  )

  # installed config file for find_package
  install(EXPORT XMLSAXParser${LINK_SUFFIX_STATIC}-config
    DESTINATION ${LibXML_INSTALL_CMAKE}
    FILE libxml-sax-parser${LINK_SUFFIX_STATIC}-targets.cmake
    COMPONENT sax-parser
  )

  include(CMakePackageConfigHelpers)
  configure_package_config_file(libxml-sax-parser-config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/libxml-sax-parser${LINK_SUFFIX_STATIC}-config.cmake
    INSTALL_DESTINATION ${LibXML_INSTALL_CMAKE}
    PATH_VARS
      LibXML_INSTALL_INCLUDE
      LibXML_INSTALL_LIBRARIES
      LibXML_INSTALL_BINARIES
    NO_CHECK_REQUIRED_COMPONENTS_MACRO
  )

  install(FILES ${CMAKE_CURRENT_BINARY_DIR}/libxml-sax-parser${LINK_SUFFIX_STATIC}-config.cmake
    DESTINATION ${LibXML_INSTALL_CMAKE}
    COMPONENT sax-parser
  )

endif ()

if (LibXML_SAX_BUILD_SHARED OR LibXML_SAX_BUILD_STATIC)
  install(DIRECTORY include/xml/sax/parser
    DESTINATION ${LibXML_INSTALL_INCLUDE}/xml/sax
    # MANDATORY
    COMPONENT sax-parser
    FILES_MATCHING PATTERN "*.h"
  )
endif ()

if (LibXML_BUILD_TESTS)
  add_subdirectory(tests)
endif ()
