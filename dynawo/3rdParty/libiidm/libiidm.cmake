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

include(${CMAKE_CURRENT_SOURCE_DIR}/../cmake/CPUCount.cmake)
if(NOT DEFINED CPU_COUNT)
  message(FATAL_ERROR "CPUCount.cmake: file not found.")
endif()

set(package_name       "libiidm")
set(package_config_dir "LibIIDM")
set(package_install_dir  "${CMAKE_INSTALL_PREFIX}/${package_name}")
string(TOUPPER "${package_name}" package_uppername)
set(package_RequiredVersion 1.5.1)
#set(package_RequiredVersionName "1.5.1")

set(CMAKE_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}/${package_name}/${package_config_dir}")

find_package(${package_name} ${package_RequiredVersion} EXACT QUIET CONFIG)

if(${package_name}_FOUND)
  add_custom_target("${package_name}" DEPENDS libxml2 boost)
  message(STATUS "Found ${package_name} ${PACKAGE_VERSION}")

else()
  set(package_md5    96ae3317400c3f515d21afb279df7e6b)
  if(DEFINED ENV{DYNAWO_LIBIIDM_DOWNLOAD_URL})
    set(package_prefix_url $ENV{DYNAWO_LIBIIDM_DOWNLOAD_URL})
  else()
    set(package_prefix_url https://github.com/powsybl/powsybl-iidm4cpp/archive/refs/tags)
  endif()
  set(package_url  "${package_prefix_url}/v${package_RequiredVersion}.tar.gz")

  include(ExternalProject)
  ExternalProject_Add(
                      "${package_name}"

    DEPENDS           libxml2 boost
    INSTALL_DIR       "${package_install_dir}"

    URL               ${package_url}
    URL_MD5           ${package_md5}

    DOWNLOAD_DIR      "${CMAKE_CURRENT_SOURCE_DIR}/${package_name}"
    TMP_DIR           "${TMP_DIR}"
    STAMP_DIR         "${DOWNLOAD_DIR}/${package_name}-stamp"
    BINARY_DIR        "${DOWNLOAD_DIR}/${package_name}-build"
    SOURCE_DIR        "${DOWNLOAD_DIR}/${package_name}"

    CMAKE_CACHE_ARGS  -DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}
                      -DCMAKE_CXX_FLAGS_INIT:STRING=$<$<CONFIG:Debug>:-O0>

    CMAKE_ARGS        "-DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>"
                      "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}"
                      "-DBOOST_ROOT:PATH=${BOOST_ROOT}"
                      "$<$<BOOL:${MSVC}>:-DBOOST_LIBRARYDIR=${BOOST_ROOT}/bin>"
                      "-DCMAKE_PREFIX_PATH=${LIBXML2_HOME}"
                      "$<$<BOOL:${FORCE_CXX11_ABI}>:-DCMAKE_CXX_FLAGS='-D_GLIBCXX_USE_CXX11_ABI=1'>"
                      "$<$<BOOL:${MSVC}>:-DINSTALL_LIB_DIR:STRING=bin>"
                      "-DBUILD_SHARED_LIBS=ON"
                      "-DBUILD_TESTS=OFF"
                      "-DBUILD_TOOLS=OFF"
  )

  unset(package_git_repo)

endif(${package_name}_FOUND)

unset(package_RequiredVersion)
unset(package_upper_name)
unset(package_install_dir)
unset(package_config_dir)
unset(package_name)
