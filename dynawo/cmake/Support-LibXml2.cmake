# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

cmake_minimum_required( VERSION 3.12)

if ( NOT CMAKE_SCRIPT_MODE_FILE )
    project( "Libxml2 support for Dynawo")
endif ()

include( $ENV{DYNAWO_HOME}/dynawo/cmake/cpu_count.cmake)
if ( NOT DEFINED CPU_COUNT )
    message( FATAL_ERROR "cpu_count.cmake: file not found.")
endif ()

set( paquet_name        "libxml2")
set( paquet_finder      "LibXml2")
set( paquet_install_dir "${CMAKE_INSTALL_PREFIX}/libxml2")

string( TOLOWER ${paquet_name} paquet_lowername)
string( TOUPPER ${paquet_name} paquet_uppername)

unset( CMAKE_MODULE_PATH)
list( APPEND CMAKE_MODULE_PATH "$ENV{DYNAWO_HOME}/dynawo/cmake")
if ( IS_DIRECTORY "$ENV{DYNAWO_HOME}/dynawo/3rdParty/${paquet_name}")
    list( APPEND CMAKE_MODULE_PATH "$ENV{DYNAWO_HOME}/dynawo/3rdParty/${paquet_name}")
endif ()

set(RequiredVersion 2.9)

set( CMAKE_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}/libxml2")
find_package( ${paquet_finder} ${RequiredVersion} QUIET)
if ( ${paquet_finder}_FOUND )

    add_custom_target( ${paquet_name})
    set( ${paquet_uppername}_HOME ${paquet_install_dir})
    message( STATUS "found LibXML2 lib and includes : ${LIBXML2_VERSION_STRING} in ${LIBXML2_HOME}")

else ()
    include( ExternalProject)
    ExternalProject_Add(
                            ${paquet_name}
        INSTALL_DIR         ${paquet_install_dir}

        GIT_REPOSITORY      https://gitlab.gnome.org/GNOME/libxml2.git
        GIT_TAG             master
        GIT_PROGRESS        1

        UPDATE_COMMAND      ""

        TMP_DIR             ${CMAKE_CURRENT_BINARY_DIR}/tmp_dir
        SOURCE_DIR          ${CMAKE_CURRENT_BINARY_DIR}/source_dir
        DOWNLOAD_DIR        ${CMAKE_CURRENT_BINARY_DIR}/download_dir
        STAMP_DIR           ${CMAKE_CURRENT_BINARY_DIR}/stamp_dir
        BINARY_DIR          ${CMAKE_CURRENT_BINARY_DIR}/binary_dir

        CONFIGURE_COMMAND   <SOURCE_DIR>/autogen.sh
                            "--without-python"
                            "--prefix=<INSTALL_DIR>"
                            "CC=${CMAKE_C_COMPILER}"
                            "CXX=${CMAKE_CXX_COMPILER}"
                            "CFLAGS=${CMAKE_C_FLAGS}"
                            "CXXFLAGS=${CMAKE_CXX_FLAGS}"

        BUILD_COMMAND       make -j ${CPU_COUNT} all

        INSTALL_COMMAND     make install
    )

    set_target_properties(
        ${paquet_name}
        PROPERTIES  INTERFACE_INCLUDE_DIRECTORIES
        "${CMAKE_INSTALL_PREFIX}/include/libxml2"
    )

    ExternalProject_Get_Property( ${paquet_name} install_dir)
    set( ${paquet_uppername}_HOME ${install_dir})

endif ()
