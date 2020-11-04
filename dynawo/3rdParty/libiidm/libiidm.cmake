# Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

cmake_minimum_required(VERSION 3.12)

include($ENV{DYNAWO_HOME}/dynawo/cmake/CPUCount.cmake)
if(NOT DEFINED CPU_COUNT)
  message(FATAL_ERROR "CPUCount.cmake: file not found.")
endif()

set(package_name       "libiidm")
set(package_config_dir "LibIIDM")
set(package_install_dir  "${CMAKE_INSTALL_PREFIX}/${package_name}")
string(TOUPPER "${package_name}" package_uppername)
set(package_RequiredVersion 1.2.0)

set(CMAKE_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}/${package_name}/${package_config_dir}")

find_package(${package_name} ${package_RequiredVersion} EXACT QUIET CONFIG)

if(${package_name}_FOUND)
  add_custom_target("${package_name}" DEPENDS libxml2 boost)
  message(STATUS "Found ${package_name} ${PACKAGE_VERSION}")

else()
  set(package_git_repo   "https://github.com/powsybl/powsybl-iidm4cpp")

  include(${CMAKE_ROOT}/Modules/ExternalProject.cmake)
  ExternalProject_Add(
                      "${package_name}"

    DEPENDS           libxml2 boost
    INSTALL_DIR       "${package_install_dir}"

    GIT_REPOSITORY    "${package_git_repo}"
    GIT_TAG           "v${package_RequiredVersion}"
    GIT_PROGRESS      1

    UPDATE_COMMAND    ""

    DOWNLOAD_DIR      "${DOWNLOAD_DIR}/${package_name}"
    TMP_DIR           "${TMP_DIR}"
    STAMP_DIR         "${DOWNLOAD_DIR}/${package_name}-stamp"
    BINARY_DIR        "${DOWNLOAD_DIR}/${package_name}"
    SOURCE_DIR        "${DOWNLOAD_DIR}/${package_name}-build"

    CMAKE_CACHE_ARGS  "-DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}"
                      "-DCXX11_ENABLED:BOOL=${CXX11_ENABLED}"

    CMAKE_ARGS        "-DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>"
                      "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}"
                      "-DBOOST_ROOT:PATH=${BOOST_ROOT}"
                      "-DCMAKE_PREFIX_PATH=${LIBXML2_HOME}"
                      "-DMSVC_STATIC_RUNTIME_LIBRARY=${MSVC_STATIC_RUNTIME_LIBRARY}"

    BUILD_COMMAND     make -j ${CPU_COUNT} all
  )

  unset(package_git_repo)

endif(${package_name}_FOUND)

unset(package_RequiredVersion)
unset(package_upper_name)
unset(package_install_dir)
unset(package_config_dir)
unset(package_name)
