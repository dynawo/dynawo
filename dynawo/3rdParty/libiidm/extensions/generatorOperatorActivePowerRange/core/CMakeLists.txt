# Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

project(libiidm_ext_generatoroperatoractivepowerrange CXX)

set(CPACK_COMPONENTS_ALL ${CPACK_COMPONENTS_ALL} "iidm-ext-generatoroperatoractivepowerrange" PARENT_SCOPE)

set(CPACK_COMPONENT_IIDM-EXT-GENERATOROPERATORACTIVEPOWERRANGE_DISPLAY_NAME "GeneratorOperatorActivePowerRange")
set(CPACK_COMPONENT_IIDM-EXT-GENERATOROPERATORACTIVEPOWERRANGE_DESCRIPTION "GeneratorOperatorActivePowerRange extension library.")

set(CPACK_COMPONENT_IIDM-EXT-GENERATOROPERATORACTIVEPOWERRANGE_GROUP iidm-extensions)
set(CPACK_COMPONENT_IIDM-EXT-GENERATOROPERATORACTIVEPOWERRANGE_DEPENDS iidm-core)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/extensions/generatorOperatorActivePowerRange/version.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/extensions/generatorOperatorActivePowerRange/version.h
)


add_library(iidm-ext-generatoroperatoractivepowerrange
  src/GeneratorOperatorActivePowerRange.cpp
  src/GeneratorOperatorActivePowerRangeBuilder.cpp
)

target_include_directories(iidm-ext-generatoroperatoractivepowerrange
  PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/${LibIIDM_INSTALL_INCLUDE}>
)

target_link_libraries(iidm-ext-generatoroperatoractivepowerrange
  iidm
)

set_target_properties(iidm-ext-generatoroperatoractivepowerrange
  PROPERTIES
    VERSION ${IIDM_VERSION_STRING}
    SOVERSION ${IIDM_VERSION_MAJOR}
)

install(TARGETS iidm-ext-generatoroperatoractivepowerrange EXPORT iidm-ext-generatoroperatoractivepowerrange-config
  PUBLIC_HEADER DESTINATION ${LibIIDM_INSTALL_INCLUDE}
  ARCHIVE DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
  LIBRARY DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
  RUNTIME DESTINATION ${LibIIDM_INSTALL_BINARIES}
  RESOURCE DESTINATION ${IIDM_SHARE_PATH}
  OPTIONAL
  COMPONENT iidm-ext-generatoroperatoractivepowerrange
)

install(DIRECTORY include/IIDM
  DESTINATION ${LibIIDM_INSTALL_INCLUDE}
  OPTIONAL
  COMPONENT iidm-ext-generatoroperatoractivepowerrange
  FILES_MATCHING PATTERN "*.h"
)

install(EXPORT iidm-ext-generatoroperatoractivepowerrange-config
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  FILE libiidm-ext-generatoroperatoractivepowerrange-targets.cmake
  OPTIONAL
  COMPONENT iidm-ext-generatoroperatoractivepowerrange
)

include(CMakePackageConfigHelpers)
configure_package_config_file(libiidm-ext-generatoroperatoractivepowerrange-config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/libiidm-ext-generatoroperatoractivepowerrange-config.cmake
  INSTALL_DESTINATION ${LibIIDM_INSTALL_CMAKE}
  PATH_VARS
    LibIIDM_INSTALL_INCLUDE
    LibIIDM_INSTALL_LIBRARIES
    LibIIDM_INSTALL_BINARIES
  NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/libiidm-ext-generatoroperatoractivepowerrange-config.cmake
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  COMPONENT iidm-ext-generatoroperatoractivepowerrange
)

# create a target to install this extension (and dependencies).
add_custom_target(install-generatoroperatoractivepowerrange
  DEPENDS iidm-ext-generatoroperatoractivepowerrange
  COMMAND
    "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=iidm-ext-generatoroperatoractivepowerrange
    -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
)

# Make extensions target depends on this extension
add_dependencies(extensions iidm-ext-generatoroperatoractivepowerrange)
add_dependencies(install-extensions install-generatoroperatoractivepowerrange)
