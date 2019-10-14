# Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libiidm, a library to model IIDM networks and allows importing and exporting them to files.

project(libiidm_ext_activeseason CXX)

set(CPACK_COMPONENTS_ALL ${CPACK_COMPONENTS_ALL} "iidm-ext-activeseason" PARENT_SCOPE)

set(CPACK_COMPONENT_IIDM-EXT-ACTIVESEASON_DISPLAY_NAME "ActiveSeason")
set(CPACK_COMPONENT_IIDM-EXT-ACTIVESEASON_DESCRIPTION "ActiveSeason extension library.")

set(CPACK_COMPONENT_IIDM-EXT-ACTIVESEASON_GROUP iidm-extensions)
set(CPACK_COMPONENT_IIDM-EXT-ACTIVESEASON_DEPENDS iidm-core)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/extensions/activeSeason/version.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/extensions/activeSeason/version.h
)


add_library(iidm-ext-activeseason
  src/ActiveSeason.cpp
)

target_include_directories(iidm-ext-activeseason
  PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
)

target_link_libraries(iidm-ext-activeseason
  iidm
)

set_target_properties(iidm-ext-activeseason
  PROPERTIES
    VERSION ${IIDM_VERSION_STRING}
    SOVERSION ${IIDM_VERSION_MAJOR}
    WINDOWS_EXPORT_ALL_SYMBOLS TRUE
)

install(TARGETS iidm-ext-activeseason EXPORT iidm-ext-activeseason-config
  PUBLIC_HEADER DESTINATION ${LibIIDM_INSTALL_INCLUDE}
  ARCHIVE DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
  LIBRARY DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
  RUNTIME DESTINATION ${LibIIDM_INSTALL_BINARIES}
  RESOURCE DESTINATION ${IIDM_SHARE_PATH}
  OPTIONAL
  COMPONENT iidm-ext-activeseason
)

install(DIRECTORY include/IIDM
  DESTINATION ${LibIIDM_INSTALL_INCLUDE}
  OPTIONAL
  COMPONENT iidm-ext-activeseason
  FILES_MATCHING PATTERN "*.h"
)

install(EXPORT iidm-ext-activeseason-config
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  FILE libiidm-ext-activeseason-targets.cmake
  OPTIONAL
  COMPONENT iidm-ext-activeseason
)

include(CMakePackageConfigHelpers)
configure_package_config_file(libiidm-ext-activeseason-config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/libiidm-ext-activeseason-config.cmake
  INSTALL_DESTINATION ${LibIIDM_INSTALL_CMAKE}
  PATH_VARS
    LibIIDM_INSTALL_INCLUDE
    LibIIDM_INSTALL_LIBRARIES
    LibIIDM_INSTALL_BINARIES
  NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/libiidm-ext-activeseason-config.cmake
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  COMPONENT iidm-ext-activeseason
)

# create a target to install this extension (and dependencies).
add_custom_target(install-activeseason
  DEPENDS iidm-ext-activeseason
  COMMAND
    "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=iidm-ext-activeseason
    -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
)

# Make extensions target depends on this extension
add_dependencies(extensions iidm-ext-activeseason)
add_dependencies(install-extensions install-activeseason)
