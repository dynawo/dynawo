# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libxml, a library to handle XML files parsing.

project(XML_formatter CXX)

set(CPACK_COMPONENT_SAX-FORMATTER_DISPLAY_NAME "XML formatter library")
set(CPACK_COMPONENT_SAX-FORMATTER_DISPLAY_DEPENDS sax-common)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/include/xml/sax/formatter/FormatterVersion.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/include/xml/sax/formatter/FormatterVersion.h
)

# Formatter targets
set(FORMATTER_SOURCES
  src/AttributeList.cpp
  src/FormatterException.cpp
  src/Formatter.cpp
  src/FormatterImpl.cpp
  src/Document.cpp
)


add_library(XMLSAXFormatter${LINK_SUFFIX_SHARED} SHARED ${FORMATTER_SOURCES})

target_include_directories(XMLSAXFormatter${LINK_SUFFIX_SHARED}
  PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<BUILD_INTERFACE:${XML_common_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:${LibXML_INSTALL_INCLUDE}>
  $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
)

set_target_properties(XMLSAXFormatter${LINK_SUFFIX_SHARED}
  PROPERTIES
    OUTPUT_NAME XMLSAXFormatter
    SOVERSION ${LIBXML_VERSION_MAJOR}
    VERSION ${LIBXML_VERSION}
    WINDOWS_EXPORT_ALL_SYMBOLS TRUE
)

install(TARGETS XMLSAXFormatter${LINK_SUFFIX_SHARED} EXPORT XMLSAXFormatter${LINK_SUFFIX_SHARED}-config
  PUBLIC_HEADER DESTINATION ${LibXML_INSTALL_INCLUDE}
  ARCHIVE DESTINATION ${LibXML_INSTALL_LIBRARIES}
  LIBRARY DESTINATION ${LibXML_INSTALL_LIBRARIES}
  RUNTIME DESTINATION ${LibXML_INSTALL_BINARIES}
  COMPONENT sax-formatter
)

# installed config file for find_package
install(EXPORT XMLSAXFormatter${LINK_SUFFIX_SHARED}-config
  DESTINATION ${LibXML_INSTALL_CMAKE}
  FILE libxml-sax-formatter${LINK_SUFFIX_SHARED}-targets.cmake
  COMPONENT sax-formatter
)

include(CMakePackageConfigHelpers)
configure_package_config_file(libxml-sax-formatter-config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/libxml-sax-formatter${LINK_SUFFIX_SHARED}-config.cmake
  INSTALL_DESTINATION ${LibXML_INSTALL_CMAKE}
  PATH_VARS
    LibXML_INSTALL_INCLUDE
    LibXML_INSTALL_LIBRARIES
    LibXML_INSTALL_BINARIES
  NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/libxml-sax-formatter${LINK_SUFFIX_SHARED}-config.cmake
  DESTINATION ${LibXML_INSTALL_CMAKE}
  COMPONENT sax-formatter
)

install(DIRECTORY include/xml/sax/formatter
  DESTINATION ${LibXML_INSTALL_INCLUDE}/xml/sax
  # MANDATORY
  COMPONENT sax-formatter
  FILES_MATCHING PATTERN "*.h"
)

if (LibXML_BUILD_TESTS)
  add_subdirectory(tests)
endif ()
