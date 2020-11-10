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

set(package_name       "libxml2")
set(package_finder     "LibXml2")
set(package_install_dir  "${CMAKE_INSTALL_PREFIX}/${package_name}")
set(package_RequiredVersion 2.9)
string(TOUPPER "${package_name}" package_uppername)

unset(CMAKE_MODULE_PATH)
if(IS_DIRECTORY "$ENV{DYNAWO_HOME}/dynawo/3rdParty/${package_name}")
  list(APPEND CMAKE_MODULE_PATH "$ENV{DYNAWO_HOME}/dynawo/3rdParty/${package_name}")
endif()
list(APPEND CMAKE_MODULE_PATH "$ENV{DYNAWO_HOME}/dynawo/cmake")

list(APPEND CMAKE_PREFIX_PATH "${LIBXML2_HOME}")

set(CMAKE_PREFIX_PATH "${package_install_dir}")
find_package("${package_finder}" "${package_RequiredVersion}" QUIET)

if(${package_finder}_FOUND)
  message(STATUS "Found ${package_name} ${${package_uppername}_VERSION_STRING}"
                 " - lib: ${${package_uppername}_LIBRARY} - include_dir: ${${package_uppername}_INCLUDE_DIR}"
  )
  add_custom_target("${package_name}")
  set(LIBXML2_HOME ${CMAKE_INSTALL_PREFIX}/libxml2)

else()
  include($ENV{DYNAWO_HOME}/dynawo/cmake/CPUCount.cmake)
  if(NOT DEFINED CPU_COUNT)
    message(FATAL_ERROR "CPUCount.cmake: file not found.")
  endif()

  set(package_VersionToInstall 2.9.4)
  set(package_md5    85235a3961e6f02b6af8774e33eaa1f2)

  if(DEFINED $ENV{DYNAWO_LIBXML2_DOWNLOAD_URL})
    set(package_prefix_url $ENV{DYNAWO_LIBXML2_DOWNLOAD_URL})
  else()
    set(package_prefix_url http://www.github.com/GNOME/libxml2/archive)
  endif()
  set(package_url  "${package_prefix_url}/v${package_VersionToInstall}.tar.gz")

  include(ExternalProject)
  ExternalProject_Add(
                        "${package_name}"

    INSTALL_DIR         ${package_install_dir}

    DOWNLOAD_DIR        "${DOWNLOAD_DIR}/${package_name}"
    TMP_DIR             "${TMP_DIR}"
    STAMP_DIR           "${DOWNLOAD_DIR}/${package_name}-stamp"
    SOURCE_DIR          "${DOWNLOAD_DIR}/${package_name}-build"

    URL                 ${package_url}
    URL_MD5             ${package_md5}

    BUILD_IN_SOURCE     1

    CONFIGURE_COMMAND   "<SOURCE_DIR>/autogen.sh"
                        "CC=${CMAKE_C_COMPILER}"
                        "CFLAGS=${CMAKE_C_FLAGS}"
                        "CXX=${CMAKE_CXX_COMPILER}"
                        "CXXFLAGS=${CXX_STDFLAG} -fPIC $<IF:$<CONFIG:Release>,-O3,-O0>"
                        "--prefix=<INSTALL_DIR>"
                        "$<IF:$<BOOL:${BUILD_SHARED_LIBS}>,--disable-static,--enable-static>"
                        "$<IF:$<BOOL:${BUILD_SHARED_LIBS}>,--enable-shared,--disable-shared>"
                        "--without-python"

    BUILD_COMMAND   make -j ${CPU_COUNT} all
  )

  ExternalProject_Get_Property(libxml2 install_dir)
  set(LIBXML2_HOME ${install_dir})

  unset(package_url)
  unset(package_prefix_url)
  unset(package_md5)
  unset(package_VersionToInstall)

endif(${package_finder}_FOUND)

unset(package_uppername)
unset(package_RequiredVersion)
unset(package_install_dir)
unset(package_finder)
unset(package_name)
