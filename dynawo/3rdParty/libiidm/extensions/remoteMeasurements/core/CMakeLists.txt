# Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
# 
# This file is part of Libiidm, a library to model IIDM networks and allows importing and exporting them to files.

project(libiidm_ext_remotemeasurements CXX)

set(CPACK_COMPONENTS_ALL ${CPACK_COMPONENTS_ALL} "iidm-ext-remotemeasurements" PARENT_SCOPE)

set(CPACK_COMPONENT_IIDM-EXT-REMOTEMEASUREMENTS_DISPLAY_NAME "RemoteMeasurements")
set(CPACK_COMPONENT_IIDM-EXT-REMOTEMEASUREMENTS_DESCRIPTION "RemoteMeasurements extension library.")

set(CPACK_COMPONENT_IIDM-EXT-REMOTEMEASUREMENTS_GROUP iidm-extensions)
set(CPACK_COMPONENT_IIDM-EXT-REMOTEMEASUREMENTS_DEPENDS iidm-core)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/extensions/remoteMeasurements/version.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/extensions/remoteMeasurements/version.h
)


add_library(iidm-ext-remotemeasurements
  src/RemoteMeasurements.cpp
  src/RemoteMeasurementsBuilder.cpp
)

target_include_directories(iidm-ext-remotemeasurements
  PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/${LibIIDM_INSTALL_INCLUDE}>
)

target_link_libraries(iidm-ext-remotemeasurements
  iidm
)

set_target_properties(iidm-ext-remotemeasurements
  PROPERTIES
    VERSION ${IIDM_VERSION_STRING}
    SOVERSION ${IIDM_VERSION_MAJOR}
)

install(TARGETS iidm-ext-remotemeasurements EXPORT iidm-ext-remotemeasurements-config
  PUBLIC_HEADER DESTINATION ${LibIIDM_INSTALL_INCLUDE}
  ARCHIVE DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
  LIBRARY DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
  RUNTIME DESTINATION ${LibIIDM_INSTALL_BINARIES}
  RESOURCE DESTINATION ${IIDM_SHARE_PATH}
  OPTIONAL
  COMPONENT iidm-ext-remotemeasurements
)

install(DIRECTORY include/IIDM
  DESTINATION ${LibIIDM_INSTALL_INCLUDE}
  OPTIONAL
  COMPONENT iidm-ext-remotemeasurements
  FILES_MATCHING PATTERN "*.h"
)

install(EXPORT iidm-ext-remotemeasurements-config
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  FILE libiidm-ext-remotemeasurements-targets.cmake
  OPTIONAL
  COMPONENT iidm-ext-remotemeasurements
)

include(CMakePackageConfigHelpers)
configure_package_config_file(libiidm-ext-remotemeasurements-config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/libiidm-ext-remotemeasurements-config.cmake
  INSTALL_DESTINATION ${LibIIDM_INSTALL_CMAKE}
  PATH_VARS
    LibIIDM_INSTALL_INCLUDE
    LibIIDM_INSTALL_LIBRARIES
    LibIIDM_INSTALL_BINARIES
  NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/libiidm-ext-remotemeasurements-config.cmake
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  COMPONENT iidm-ext-remotemeasurements
)

# create a target to install this extension (and dependencies).
add_custom_target(install-remotemeasurements
  DEPENDS iidm-ext-remotemeasurements
  COMMAND 
    "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=iidm-ext-remotemeasurements
    -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
)

# Make extensions target depends on this extension
add_dependencies(extensions iidm-ext-remotemeasurements)
add_dependencies(install-extensions install-remotemeasurements)
