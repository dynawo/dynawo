# Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libiidm, a library to model IIDM networks and allows importing and exporting them to files.

project(libiidm_ext_hvdcangledroopactivepowercontrol_xml CXX)

set(CPACK_COMPONENTS_ALL ${CPACK_COMPONENTS_ALL} "iidm-ext-hvdcangledroopactivepowercontrol-xml" PARENT_SCOPE)

set(CPACK_COMPONENT_IIDM-EXT-HVDCANGLEDROOPACTIVEPOWERCONTROL-XML_DISPLAY_NAME "HvdcAngleDroopActivePowerControl XML")
set(CPACK_COMPONENT_IIDM-EXT-HVDCANGLEDROOPACTIVEPOWERCONTROL-XML_DESCRIPTION "XML support library for the HvdcAngleDroopActivePowerControl extension.")

set(CPACK_COMPONENT_IIDM-EXT-HVDCANGLEDROOPACTIVEPOWERCONTROL-XML_GROUP iidm-extensions)
set(CPACK_COMPONENT_IIDM-EXT-HVDCANGLEDROOPACTIVEPOWERCONTROL-XML_DEPENDS iidm-ext-hvdcangledroopactivepowercontrol iidm-xml)

configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/extensions/hvdcAngleDroopActivePowerControl/xml/version.h.in
        ${CMAKE_CURRENT_SOURCE_DIR}/include/IIDM/extensions/hvdcAngleDroopActivePowerControl/xml/version.h
)

configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/include/internals/config.h.in
        ${CMAKE_CURRENT_SOURCE_DIR}/include/internals/config.h
)


set(IIDM_EXT_HVDCANGLEDROOPACTIVEPOWERCONTROL_XML_SOURCES
        src/HvdcAngleDroopActivePowerControlHandler.cpp
        src/HvdcAngleDroopActivePowerControlFormatter.cpp
        )

add_library(iidm-ext-hvdcangledroopactivepowercontrol-xml ${IIDM_EXT_HVDCANGLEDROOPACTIVEPOWERCONTROL_XML_SOURCES})

target_include_directories(iidm-ext-hvdcangledroopactivepowercontrol-xml
        PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        )

target_link_libraries(iidm-ext-hvdcangledroopactivepowercontrol-xml
        iidm-ext-hvdcangledroopactivepowercontrol
        iidm-xml
        )

set_target_properties(iidm-ext-hvdcangledroopactivepowercontrol-xml
        PROPERTIES
        VERSION ${IIDM_VERSION_STRING}
        SOVERSION ${IIDM_VERSION_MAJOR}
        WINDOWS_EXPORT_ALL_SYMBOLS TRUE
        )

install(TARGETS iidm-ext-hvdcangledroopactivepowercontrol-xml EXPORT iidm-ext-hvdcangledroopactivepowercontrol-xml-config
        PUBLIC_HEADER DESTINATION ${LibIIDM_INSTALL_INCLUDE}
        ARCHIVE DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
        LIBRARY DESTINATION ${LibIIDM_INSTALL_LIBRARIES}
        RUNTIME DESTINATION ${LibIIDM_INSTALL_BINARIES}
        RESOURCE DESTINATION ${IIDM_SHARE_PATH}
        OPTIONAL
        COMPONENT iidm-ext-hvdcangledroopactivepowercontrol-xml
        )

install(DIRECTORY include/IIDM
        DESTINATION ${LibIIDM_INSTALL_INCLUDE}
        OPTIONAL
        COMPONENT iidm-ext-hvdcangledroopactivepowercontrol-xml
        FILES_MATCHING PATTERN "*.h"
        )

#install(DIRECTORY ...) append the last part of input paths to the destination path. Adding a "/" prevents this.
install(DIRECTORY share/
        DESTINATION ${IIDM_SHARE_PATH}
        OPTIONAL
        COMPONENT iidm-ext-hvdcangledroopactivepowercontrol-xml
        )

install(EXPORT iidm-ext-hvdcangledroopactivepowercontrol-xml-config
        DESTINATION ${LibIIDM_INSTALL_CMAKE}
        FILE libiidm-ext-hvdcangledroopactivepowercontrol-xml-targets.cmake
        OPTIONAL
        COMPONENT iidm-ext-hvdcangledroopactivepowercontrol-xml
        )

include(CMakePackageConfigHelpers)
configure_package_config_file(libiidm-ext-hvdcangledroopactivepowercontrol-xml-config.cmake.in
        ${CMAKE_CURRENT_BINARY_DIR}/libiidm-ext-hvdcangledroopactivepowercontrol-xml-config.cmake
        INSTALL_DESTINATION ${LibIIDM_INSTALL_CMAKE}
        PATH_VARS
        LibIIDM_INSTALL_INCLUDE
        LibIIDM_INSTALL_LIBRARIES
        LibIIDM_INSTALL_BINARIES
        NO_CHECK_REQUIRED_COMPONENTS_MACRO
        )

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/libiidm-ext-hvdcangledroopactivepowercontrol-xml-config.cmake
        DESTINATION ${LibIIDM_INSTALL_CMAKE}
        OPTIONAL
        COMPONENT iidm-ext-hvdcangledroopactivepowercontrol-xml
        )

# create a target to install this extension (and dependencies).
add_custom_target(install-hvdcangledroopactivepowercontrol-xml
        DEPENDS iidm-ext-hvdcangledroopactivepowercontrol-xml
        COMMAND
        "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=iidm-ext-hvdcangledroopactivepowercontrol-xml
        -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
        )

# Make extensions and install-extensions target depends on this extension
add_dependencies(extensions-xml iidm-ext-hvdcangledroopactivepowercontrol-xml)
add_dependencies(install-extensions-xml install-hvdcangledroopactivepowercontrol-xml)


if(BUILD_SAMPLES)
    add_library(iidm-ext-hvdcangledroopactivepowercontrol-xml-testing EXCLUDE_FROM_ALL ${IIDM_EXT_HVDCANGLEDROOPACTIVEPOWERCONTROL_XML_SOURCES})

    target_compile_definitions(iidm-ext-hvdcangledroopactivepowercontrol-xml-testing PRIVATE IIDM_TESTING)

    target_include_directories(iidm-ext-hvdcangledroopactivepowercontrol-xml-testing
            PUBLIC
            $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
            )

    target_link_libraries(iidm-ext-hvdcangledroopactivepowercontrol-xml-testing
            iidm-ext-hvdcangledroopactivepowercontrol
            iidm-xml-testing
            )

    set_target_properties(iidm-ext-hvdcangledroopactivepowercontrol-xml-testing
            PROPERTIES
            VERSION ${IIDM_VERSION_STRING}
            SOVERSION ${IIDM_VERSION_MAJOR}
            WINDOWS_EXPORT_ALL_SYMBOLS TRUE
            )

    add_custom_command(TARGET iidm-ext-hvdcangledroopactivepowercontrol-xml-testing PRE_BUILD
            COMMAND ${CMAKE_COMMAND} -E
            copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/share/xsd ${CMAKE_BINARY_DIR}/${IIDM_SHARE_PATH}/xsd
            COMMENT "copying xsd to test directory"
            VERBATIM
            )
endif()
