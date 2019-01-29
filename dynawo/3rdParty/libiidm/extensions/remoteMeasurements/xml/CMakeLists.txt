# Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
# 
# This file is part of Libiidm, a library to model IIDM networks and allows importing and exporting them to files.

project(libiidm_ext_remotemeasurements_xml CXX)

set(CPACK_COMPONENTS_ALL ${CPACK_COMPONENTS_ALL} "iidm-ext-remotemeasurements-xml" PARENT_SCOPE)

set(CPACK_COMPONENT_IIDM-EXT-REMOTEMEASUREMENTS-XML_DISPLAY_NAME "RemoteMeasurements XML")
set(CPACK_COMPONENT_IIDM-EXT-REMOTEMEASUREMENTS-XML_DESCRIPTION "XML support library for the RemoteMeasurements extension.")

set(CPACK_COMPONENT_IIDM-EXT-REMOTEMEASUREMENTS-XML_GROUP iidm-extensions)
set(CPACK_COMPONENT_IIDM-EXT-REMOTEMEASUREMENTS-XML_DEPENDS iidm-ext-remotemeasurements iidm-xml)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/extensions/remoteMeasurements/xml/version.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/extensions/remoteMeasurements/xml/version.h
)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/include/internals/config.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/include/internals/config.h
)


set(IIDM_EXT_REMOTEMEASUREMENTS_XML_SOURCES
  src/RemoteMeasurementsHandler.cpp
  src/RemoteMeasurementsFormatter.cpp
)

add_library(iidm-ext-remotemeasurements-xml ${IIDM_EXT_REMOTEMEASUREMENTS_XML_SOURCES})

target_include_directories(iidm-ext-remotemeasurements-xml
  PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/${LibIIDM_INSTALL_INCLUDE}>
)

target_link_libraries(iidm-ext-remotemeasurements-xml
  iidm-ext-remotemeasurements
  iidm-xml
)

set_target_properties(iidm-ext-remotemeasurements-xml
  PROPERTIES
    VERSION ${IIDM_VERSION_STRING}
    SOVERSION ${IIDM_VERSION_MAJOR}
)

install(TARGETS iidm-ext-remotemeasurements-xml EXPORT iidm-ext-remotemeasurements-xml-config
  PUBLIC_HEADER DESTINATION ${LibIIDM_INSTALL_INCLUDE}
  ARCHIVE DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
  LIBRARY DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
  RUNTIME DESTINATION ${LibIIDM_INSTALL_BINARIES}
  RESOURCE DESTINATION ${IIDM_SHARE_PATH}
  OPTIONAL
  COMPONENT iidm-ext-remotemeasurements-xml
)

install(DIRECTORY include/IIDM
  DESTINATION ${LibIIDM_INSTALL_INCLUDE}
  OPTIONAL
  COMPONENT iidm-ext-remotemeasurements-xml
  FILES_MATCHING PATTERN "*.h"
)

#install(DIRECTORY ...) append the last part of input paths to the destination path. Adding a "/" prevents this.
install(DIRECTORY share/
  DESTINATION ${IIDM_SHARE_PATH}
  OPTIONAL
  COMPONENT iidm-ext-remotemeasurements-xml
)

install(EXPORT iidm-ext-remotemeasurements-xml-config
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  FILE libiidm-ext-remotemeasurements-xml-targets.cmake
  OPTIONAL
  COMPONENT iidm-ext-remotemeasurements-xml
)

include(CMakePackageConfigHelpers)
configure_package_config_file(libiidm-ext-remotemeasurements-xml-config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/libiidm-ext-remotemeasurements-xml-config.cmake
  INSTALL_DESTINATION ${LibIIDM_INSTALL_CMAKE}
  PATH_VARS
    LibIIDM_INSTALL_INCLUDE
    LibIIDM_INSTALL_LIBRARIES
    LibIIDM_INSTALL_BINARIES
  NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/libiidm-ext-remotemeasurements-xml-config.cmake
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  OPTIONAL
  COMPONENT iidm-ext-remotemeasurements-xml
)

# create a target to install this extension (and dependencies).
add_custom_target(install-remotemeasurements-xml
  DEPENDS iidm-ext-remotemeasurements-xml
  COMMAND 
    "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=iidm-ext-remotemeasurements-xml
    -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
)

# Make extensions and install-extensions target depends on this extension
add_dependencies(extensions-xml iidm-ext-remotemeasurements-xml)
add_dependencies(install-extensions-xml install-remotemeasurements-xml)


if(BUILD_SAMPLES)
  add_library(iidm-ext-remotemeasurements-xml-testing EXCLUDE_FROM_ALL ${IIDM_EXT_REMOTEMEASUREMENTS_XML_SOURCES})

  target_compile_definitions(iidm-ext-remotemeasurements-xml-testing PRIVATE IIDM_TESTING)
  
  target_include_directories(iidm-ext-remotemeasurements-xml-testing
    PUBLIC
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  )

  target_link_libraries(iidm-ext-remotemeasurements-xml-testing
    iidm-ext-remotemeasurements
    iidm-xml-testing
  )

  set_target_properties(iidm-ext-remotemeasurements-xml-testing
    PROPERTIES
      VERSION ${IIDM_VERSION_STRING}
      SOVERSION ${IIDM_VERSION_MAJOR}
  )

  add_custom_command(TARGET iidm-ext-remotemeasurements-xml-testing PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E
      copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/share/xsd ${CMAKE_BINARY_DIR}/${IIDM_SHARE_PATH}/xsd
    COMMENT "copying xsd to test directory"
    VERBATIM
  )
endif()
