# Copyright (c) 2026, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

cmake_minimum_required(VERSION 3.12)

set(NLOHMANN_HOME ${CMAKE_INSTALL_PREFIX}/nlohmann CACHE PATH "Path to nlohmann installation" FORCE)

find_package(nlohmann_json 3.11.3 QUIET CONFIG PATHS "${NLOHMANN_HOME}")

if(nlohmann_json_FOUND)
  add_custom_target(nlohmann)
  message(STATUS "Found nlohmann ${nlohmann_json_VERSION}")
else()
  if(DEFINED ENV{DYNAWO_NLOHMANN_DOWNLOAD_URL})
    set(nlohmann_url $ENV{DYNAWO_NLOHMANN_DOWNLOAD_URL}/v3.11.3.tar.gz)
  else()
    set(nlohmann_url https://github.com/nlohmann/json/archive/refs/tags/v3.11.3.tar.gz)
  endif()

  include(ExternalProject)
  ExternalProject_Add(nlohmann
    INSTALL_DIR       "${NLOHMANN_HOME}"
    URL               ${nlohmann_url}
    URL_MD5           d603041cbc6051edbaa02ebb82cf0aa9
    DOWNLOAD_DIR      "${CMAKE_CURRENT_SOURCE_DIR}/nlohmann"
    TMP_DIR           "${TMP_DIR}"
    STAMP_DIR         "${DOWNLOAD_DIR}/nlohmann-stamp"
    BINARY_DIR        "${DOWNLOAD_DIR}/nlohmann-build"
    SOURCE_DIR        "${DOWNLOAD_DIR}/nlohmann"
    CMAKE_ARGS        "-DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>"
                      "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}"
                      "-DJSON_BuildTests:BOOL=OFF"
                      "-DJSON_Install:BOOL=ON"
  )
endif()
