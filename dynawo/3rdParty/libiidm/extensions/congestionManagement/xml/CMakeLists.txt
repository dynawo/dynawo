# Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libiidm, a library to model IIDM networks and allows importing and exporting them to files.

project(libiidm_ext_congestionmanagement_xml CXX)

set(CPACK_COMPONENTS_ALL ${CPACK_COMPONENTS_ALL} "iidm-ext-congestionmanagement-xml" PARENT_SCOPE)

set(CPACK_COMPONENT_IIDM-EXT-CONGESTIONMANAGEMENT-XML_DISPLAY_NAME "CongestionManagement XML")
set(CPACK_COMPONENT_IIDM-EXT-CONGESTIONMANAGEMENT-XML_DESCRIPTION "XML support library for the CongestionManagement extension.")

set(CPACK_COMPONENT_IIDM-EXT-CONGESTIONMANAGEMENT-XML_GROUP iidm-extensions)
set(CPACK_COMPONENT_IIDM-EXT-CONGESTIONMANAGEMENT-XML_DEPENDS iidm-ext-congestionmanagement iidm-xml)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/extensions/congestionManagement/xml/version.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/extensions/congestionManagement/xml/version.h
)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/include/internals/config.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/include/internals/config.h
)


set(IIDM_EXT_CONGESTIONMANAGEMENT_XML_SOURCES
  src/CongestionManagementHandler.cpp
  src/CongestionManagementFormatter.cpp
)

add_library(iidm-ext-congestionmanagement-xml ${IIDM_EXT_CONGESTIONMANAGEMENT_XML_SOURCES})

target_include_directories(iidm-ext-congestionmanagement-xml
  PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/${LibIIDM_INSTALL_INCLUDE}>
)

target_link_libraries(iidm-ext-congestionmanagement-xml
  iidm-ext-congestionmanagement
  iidm-xml
)

set_target_properties(iidm-ext-congestionmanagement-xml
  PROPERTIES
    VERSION ${IIDM_VERSION_STRING}
    SOVERSION ${IIDM_VERSION_MAJOR}
)

install(TARGETS iidm-ext-congestionmanagement-xml EXPORT iidm-ext-congestionmanagement-xml-config
  PUBLIC_HEADER DESTINATION ${LibIIDM_INSTALL_INCLUDE}
  ARCHIVE DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
  LIBRARY DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
  RUNTIME DESTINATION ${LibIIDM_INSTALL_BINARIES}
  RESOURCE DESTINATION ${IIDM_SHARE_PATH}
  OPTIONAL
  COMPONENT iidm-ext-congestionmanagement-xml
)

install(DIRECTORY include/IIDM
  DESTINATION ${LibIIDM_INSTALL_INCLUDE}
  OPTIONAL
  COMPONENT iidm-ext-congestionmanagement-xml
  FILES_MATCHING PATTERN "*.h"
)

#install(DIRECTORY ...) append the last part of input paths to the destination path. Adding a "/" prevents this.
install(DIRECTORY share/
  DESTINATION ${IIDM_SHARE_PATH}
  OPTIONAL
  COMPONENT iidm-ext-congestionmanagement-xml
)

install(EXPORT iidm-ext-congestionmanagement-xml-config
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  FILE libiidm-ext-congestionmanagement-xml-targets.cmake
  OPTIONAL
  COMPONENT iidm-ext-congestionmanagement-xml
)

include(CMakePackageConfigHelpers)
configure_package_config_file(libiidm-ext-congestionmanagement-xml-config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/libiidm-ext-congestionmanagement-xml-config.cmake
  INSTALL_DESTINATION ${LibIIDM_INSTALL_CMAKE}
  PATH_VARS
    LibIIDM_INSTALL_INCLUDE
    LibIIDM_INSTALL_LIBRARIES
    LibIIDM_INSTALL_BINARIES
  NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/libiidm-ext-congestionmanagement-xml-config.cmake
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  OPTIONAL
  COMPONENT iidm-ext-congestionmanagement-xml
)

# create a target to install this extension (and dependencies).
add_custom_target(install-congestionmanagement-xml
  DEPENDS iidm-ext-congestionmanagement-xml
  COMMAND
    "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=iidm-ext-congestionmanagement-xml
    -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
)

# Make extensions and install-extensions target depends on this extension
add_dependencies(extensions-xml iidm-ext-congestionmanagement-xml)
add_dependencies(install-extensions-xml install-congestionmanagement-xml)


if(BUILD_SAMPLES)
  add_library(iidm-ext-congestionmanagement-xml-testing EXCLUDE_FROM_ALL ${IIDM_EXT_CONGESTIONMANAGEMENT_XML_SOURCES})

  target_compile_definitions(iidm-ext-congestionmanagement-xml-testing PRIVATE IIDM_TESTING)

  target_include_directories(iidm-ext-congestionmanagement-xml-testing
    PUBLIC
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  )

  target_link_libraries(iidm-ext-congestionmanagement-xml-testing
    iidm-ext-congestionmanagement
    iidm-xml-testing
  )

  set_target_properties(iidm-ext-congestionmanagement-xml-testing
    PROPERTIES
      VERSION ${IIDM_VERSION_STRING}
      SOVERSION ${IIDM_VERSION_MAJOR}
  )

  add_custom_command(TARGET iidm-ext-congestionmanagement-xml-testing PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E
      copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/share/xsd ${CMAKE_BINARY_DIR}/${IIDM_SHARE_PATH}/xsd
    COMMENT "copying xsd to test directory"
    VERBATIM
  )
endif()
