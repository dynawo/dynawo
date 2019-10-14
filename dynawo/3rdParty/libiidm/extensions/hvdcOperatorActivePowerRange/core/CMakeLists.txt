# Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libiidm, a library to model IIDM networks and allows importing and exporting them to files.

project(libiidm_ext_hvdcoperatoractivepowerrange CXX)

set(CPACK_COMPONENTS_ALL ${CPACK_COMPONENTS_ALL} "iidm-ext-hvdcoperatoractivepowerrange" PARENT_SCOPE)

set(CPACK_COMPONENT_IIDM-EXT-HVDCOPERATORACTIVEPOWERRANGE_DISPLAY_NAME "HvdcOperatorActivePowerRange")
set(CPACK_COMPONENT_IIDM-EXT-HVDCOPERATORACTIVEPOWERRANGE_DESCRIPTION "HvdcOperatorActivePowerRange extension library.")

set(CPACK_COMPONENT_IIDM-EXT-HVDCOPERATORACTIVEPOWERRANGE_GROUP iidm-extensions)
set(CPACK_COMPONENT_IIDM-EXT-HVDCOPERATORACTIVEPOWERRANGE_DEPENDS iidm-core)

configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/extensions/hvdcOperatorActivePowerRange/version.h.in
        ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/extensions/hvdcOperatorActivePowerRange/version.h
)


add_library(iidm-ext-hvdcoperatoractivepowerrange
        src/HvdcOperatorActivePowerRange.cpp
        src/HvdcOperatorActivePowerRangeBuilder.cpp
        )

target_include_directories(iidm-ext-hvdcoperatoractivepowerrange
        PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        )

target_link_libraries(iidm-ext-hvdcoperatoractivepowerrange
        iidm
        )

set_target_properties(iidm-ext-hvdcoperatoractivepowerrange
        PROPERTIES
        VERSION ${IIDM_VERSION_STRING}
        SOVERSION ${IIDM_VERSION_MAJOR}
        WINDOWS_EXPORT_ALL_SYMBOLS TRUE
        )

install(TARGETS iidm-ext-hvdcoperatoractivepowerrange EXPORT iidm-ext-hvdcoperatoractivepowerrange-config
        PUBLIC_HEADER DESTINATION ${LibIIDM_INSTALL_INCLUDE}
        ARCHIVE DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
        LIBRARY DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
        RUNTIME DESTINATION ${LibIIDM_INSTALL_BINARIES}
        RESOURCE DESTINATION ${IIDM_SHARE_PATH}
        OPTIONAL
        COMPONENT iidm-ext-hvdcoperatoractivepowerrange
        )

install(DIRECTORY include/IIDM
        DESTINATION ${LibIIDM_INSTALL_INCLUDE}
        OPTIONAL
        COMPONENT iidm-ext-hvdcoperatoractivepowerrange
        FILES_MATCHING PATTERN "*.h"
        )

install(EXPORT iidm-ext-hvdcoperatoractivepowerrange-config
        DESTINATION ${LibIIDM_INSTALL_CMAKE}
        FILE libiidm-ext-hvdcoperatoractivepowerrange-targets.cmake
        OPTIONAL
        COMPONENT iidm-ext-hvdcoperatoractivepowerrange
        )

include(CMakePackageConfigHelpers)
configure_package_config_file(libiidm-ext-hvdcoperatoractivepowerrange-config.cmake.in
        ${CMAKE_CURRENT_BINARY_DIR}/libiidm-ext-hvdcoperatoractivepowerrange-config.cmake
        INSTALL_DESTINATION ${LibIIDM_INSTALL_CMAKE}
        PATH_VARS
        LibIIDM_INSTALL_INCLUDE
        LibIIDM_INSTALL_LIBRARIES
        LibIIDM_INSTALL_BINARIES
        NO_CHECK_REQUIRED_COMPONENTS_MACRO
        )

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/libiidm-ext-hvdcoperatoractivepowerrange-config.cmake
        DESTINATION ${LibIIDM_INSTALL_CMAKE}
        COMPONENT iidm-ext-hvdcoperatoractivepowerrange
        )

# create a target to install this extension (and dependencies).
add_custom_target(install-hvdcoperatoractivepowerrange
        DEPENDS iidm-ext-hvdcoperatoractivepowerrange
        COMMAND
        "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=iidm-ext-hvdcoperatoractivepowerrange
        -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
        )

# Make extensions target depends on this extension
add_dependencies(extensions iidm-ext-hvdcoperatoractivepowerrange)
add_dependencies(install-extensions install-hvdcoperatoractivepowerrange)
