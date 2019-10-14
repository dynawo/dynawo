# Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libiidm, a library to model IIDM networks and allows importing and exporting them to files.

project(libiidm_ext_standbyautomaton CXX)

set(CPACK_COMPONENTS_ALL ${CPACK_COMPONENTS_ALL} "iidm-ext-standbyautomaton" PARENT_SCOPE)

set(CPACK_COMPONENT_IIDM-EXT-STANDBYAUTOMATON_DISPLAY_NAME "StandbyAutomaton")
set(CPACK_COMPONENT_IIDM-EXT-STANDBYAUTOMATON_DESCRIPTION "StandbyAutomaton extension library.")

set(CPACK_COMPONENT_IIDM-EXT-STANDBYAUTOMATON_GROUP iidm-extensions)
set(CPACK_COMPONENT_IIDM-EXT-STANDBYAUTOMATON_DEPENDS iidm-core)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/extensions/standbyAutomaton/version.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/extensions/standbyAutomaton/version.h
)


add_library(iidm-ext-standbyautomaton
  src/StandbyAutomaton.cpp
  src/StandbyAutomatonBuilder.cpp
)

target_include_directories(iidm-ext-standbyautomaton
  PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
)

target_link_libraries(iidm-ext-standbyautomaton
  iidm
)

set_target_properties(iidm-ext-standbyautomaton
  PROPERTIES
    VERSION ${IIDM_VERSION_STRING}
    SOVERSION ${IIDM_VERSION_MAJOR}
    WINDOWS_EXPORT_ALL_SYMBOLS TRUE
)

install(TARGETS iidm-ext-standbyautomaton EXPORT iidm-ext-standbyautomaton-config
  PUBLIC_HEADER DESTINATION ${LibIIDM_INSTALL_INCLUDE}
  ARCHIVE DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
  LIBRARY DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
  RUNTIME DESTINATION ${LibIIDM_INSTALL_BINARIES}
  RESOURCE DESTINATION ${IIDM_SHARE_PATH}
  OPTIONAL
  COMPONENT iidm-ext-standbyautomaton
)

install(DIRECTORY include/IIDM DESTINATION
  DESTINATION ${LibIIDM_INSTALL_INCLUDE}
  OPTIONAL
  COMPONENT iidm-ext-standbyautomaton
  FILES_MATCHING PATTERN "*.h"
)

install(EXPORT iidm-ext-standbyautomaton-config
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  FILE libiidm-ext-standbyautomaton-targets.cmake
  OPTIONAL
  COMPONENT iidm-ext-standbyautomaton
)

include(CMakePackageConfigHelpers)
configure_package_config_file(libiidm-ext-standbyautomaton-config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/libiidm-ext-standbyautomaton-config.cmake
  INSTALL_DESTINATION ${LibIIDM_INSTALL_CMAKE}
  PATH_VARS
    LibIIDM_INSTALL_INCLUDE
    LibIIDM_INSTALL_LIBRARIES
    LibIIDM_INSTALL_BINARIES
  NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/libiidm-ext-standbyautomaton-config.cmake
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  COMPONENT iidm-ext-standbyautomaton
)

# create a target to install this extension (and dependencies).
add_custom_target(install-standbyautomaton
  DEPENDS iidm-ext-standbyautomaton
  COMMAND
    "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=iidm-ext-standbyautomaton
    -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
)

# Make extensions target depends on this extension
add_dependencies(extensions iidm-ext-standbyautomaton)
add_dependencies(install-extensions install-standbyautomaton)
