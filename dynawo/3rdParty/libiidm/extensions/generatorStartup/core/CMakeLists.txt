# Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libiidm, a library to model IIDM networks and allows importing and exporting them to files.

project(libiidm_ext_generatorstartup CXX)

set(CPACK_COMPONENTS_ALL ${CPACK_COMPONENTS_ALL} "iidm-ext-generatorstartup" PARENT_SCOPE)

set(CPACK_COMPONENT_IIDM-EXT-GENERATORSTARTUP_DISPLAY_NAME "GeneratorStartup")
set(CPACK_COMPONENT_IIDM-EXT-GENERATORSTARTUP_DESCRIPTION "GeneratorStartup extension library.")

set(CPACK_COMPONENT_IIDM-EXT-GENERATORSTARTUP_GROUP iidm-extensions)
set(CPACK_COMPONENT_IIDM-EXT-GENERATORSTARTUP_DEPENDS iidm-core)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/extensions/generatorStartup/version.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/extensions/generatorStartup/version.h
)


add_library(iidm-ext-generatorstartup
  src/GeneratorStartup.cpp
  src/GeneratorStartupBuilder.cpp
)

target_include_directories(iidm-ext-generatorstartup
  PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/${LibIIDM_INSTALL_INCLUDE}>
)

target_link_libraries(iidm-ext-generatorstartup
  iidm
)

set_target_properties(iidm-ext-generatorstartup
  PROPERTIES
    VERSION ${IIDM_VERSION_STRING}
    SOVERSION ${IIDM_VERSION_MAJOR}
)

install(TARGETS iidm-ext-generatorstartup EXPORT iidm-ext-generatorstartup-config
  PUBLIC_HEADER DESTINATION ${LibIIDM_INSTALL_INCLUDE}
  ARCHIVE DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
  LIBRARY DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
  RUNTIME DESTINATION ${LibIIDM_INSTALL_BINARIES}
  RESOURCE DESTINATION ${IIDM_SHARE_PATH}
  OPTIONAL
  COMPONENT iidm-ext-generatorstartup
)

install(DIRECTORY include/IIDM
  DESTINATION ${LibIIDM_INSTALL_INCLUDE}
  OPTIONAL
  COMPONENT iidm-ext-generatorstartup
  FILES_MATCHING PATTERN "*.h"
)

install(EXPORT iidm-ext-generatorstartup-config
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  FILE libiidm-ext-generatorstartup-targets.cmake
  OPTIONAL
  COMPONENT iidm-ext-generatorstartup
)

include(CMakePackageConfigHelpers)
configure_package_config_file(libiidm-ext-generatorstartup-config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/libiidm-ext-generatorstartup-config.cmake
  INSTALL_DESTINATION ${LibIIDM_INSTALL_CMAKE}
  PATH_VARS
    LibIIDM_INSTALL_INCLUDE
    LibIIDM_INSTALL_LIBRARIES
    LibIIDM_INSTALL_BINARIES
  NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/libiidm-ext-generatorstartup-config.cmake
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  COMPONENT iidm-ext-generatorstartup
)

# create a target to install this extension (and dependencies).
add_custom_target(install-generatorstartup
  DEPENDS iidm-ext-generatorstartup
  COMMAND
    "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=iidm-ext-generatorstartup
    -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
)

# Make extensions target depends on this extension
add_dependencies(extensions iidm-ext-generatorstartup)
add_dependencies(install-extensions install-generatorstartup)
