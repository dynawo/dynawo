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

set(packet_name        "libxml2")
set(packet_finder      "LibXml2")
set(packet_install_dir "${CMAKE_INSTALL_PREFIX}/${packet_name}")
set(packet_RequiredVersion 2.9)

string(TOUPPER "${packet_name}" packet_uppername)

unset(CMAKE_MODULE_PATH)
if(IS_DIRECTORY "$ENV{DYNAWO_HOME}/dynawo/3rdParty/${packet_name}")
  list(APPEND CMAKE_MODULE_PATH "$ENV{DYNAWO_HOME}/dynawo/3rdParty/${packet_name}")
endif()
list(APPEND CMAKE_MODULE_PATH "$ENV{DYNAWO_HOME}/dynawo/cmake")

set(CMAKE_PREFIX_PATH "${packet_install_dir}")
find_package("${packet_finder}" "${packet_RequiredVersion}" QUIET)
if(${packet_finder}_FOUND)

  message(STATUS "Found ${packet_name} ${${packet_uppername}_VERSION_STRING}"
                 " - lib: ${${packet_uppername}_LIBRARY} - include_dir: ${${packet_uppername}_INCLUDE_DIR}"
  )

else()

  set(packet_VersionToInstall 2.9.4)
  set(packet_md5   85235a3961e6f02b6af8774e33eaa1f2)

  if(DEFINED $ENV{DYNAWO_LIBXML2_DOWNLOAD_URL})
    set(packet_prefix_url $ENV{DYNAWO_LIBXML2_DOWNLOAD_URL})
  else()
    set(packet_prefix_url http://www.github.com/GNOME/libxml2/archive)
  endif()
  set(packet_url   "${packet_prefix_url}/v${packet_VersionToInstall}.tar.gz")

  include(${CMAKE_ROOT}/Modules/ExternalProject.cmake)
  ExternalProject_Add(
                        ${packet_name}
    INSTALL_DIR         ${packet_install_dir}

    DOWNLOAD_DIR        ${CMAKE_CURRENT_BINARY_DIR}/download_dir
    TMP_DIR             ${CMAKE_CURRENT_BINARY_DIR}/tmp_dir
    STAMP_DIR           ${CMAKE_CURRENT_BINARY_DIR}/stamp_dir
    SOURCE_DIR          ${CMAKE_CURRENT_BINARY_DIR}/source_dir

    URL                 ${packet_url}
    URL_MD5             ${packet_md5}

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
  )

  ExternalProject_Get_Property(${packet_name} install_dir)

  unset(packet_url)
  unset(packet_prefix_url)
  unset(packet_md5)
  unset(packet_VersionToInstall)

endif(${packet_finder}_FOUND)

unset(packet_uppername)
unset(packet_RequiredVersion)
unset(packet_install_dir)
unset(packet_finder)
unset(packet_name)
