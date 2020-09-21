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
if(NOT DEFINED CPU_COUNT ) 
  message(FATAL_ERROR "Le décompte des CPUs a échoué")
endif()

set(paquet_name        "libiidm")
set(paquet_config_dir  "LibIIDM")  
set(paquet_install_dir "${CMAKE_INSTALL_PREFIX}/${paquet_name}")
string(TOUPPER "${paquet_name}" paquet_uppername)
set(paquet_RequiredVersion 1.2.0)

set(CMAKE_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}/${paquet_name}/${paquet_config_dir}")       

find_package(${paquet_name} ${paquet_RequiredVersion} EXACT QUIET CONFIG)
if(${paquet_name}_FOUND)

  add_custom_target("${paquet_name}" DEPENDS libxml2)
  message(STATUS "Found ${paquet_name} ${PACKAGE_VERSION}")

else()

  set(paquet_git_repo    "https://github.com/powsybl/powsybl-iidm4cpp")

  include(${CMAKE_ROOT}/Modules/ExternalProject.cmake)  
  ExternalProject_Add(

                      "${paquet_name}"                                  

    DEPENDS           libxml2
    INSTALL_DIR       "${paquet_install_dir}"

    GIT_REPOSITORY    "${paquet_git_repo}"
    GIT_TAG           "v${paquet_RequiredVersion}"
    GIT_PROGRESS      1

    UPDATE_COMMAND    ""

    DOWNLOAD_DIR      "${CMAKE_CURRENT_BINARY_DIR}/download_dir"          
    TMP_DIR           "${CMAKE_CURRENT_BINARY_DIR}/tmp_dir"
    STAMP_DIR         "${CMAKE_CURRENT_BINARY_DIR}/stamp_dir"
    BINARY_DIR        "${CMAKE_CURRENT_BINARY_DIR}/binary_dir"
    SOURCE_DIR        "${CMAKE_CURRENT_BINARY_DIR}/source_dir"

    CMAKE_CACHE_ARGS  "-DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}"
                      "-DCXX11_ENABLED:BOOL=${CXX11_ENABLED}"

    CMAKE_ARGS        "-DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>"
                      "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}"
                      "-DIIDM_BUILD_SHARED:BOOL=$<BOOL:${BUILD_SHARED_LIBS}>"
                      "-DBUILD_XML:BOOL=ON"
                      "-DBUILD_SAMPLES:BOOL=$<BOOL:${LIBIIDM_BUILD_SAMPLES}>"
                      "-DLIBXML2_LIBRARY=${LIBXML2_LIBRARY}"            --> Ajout DG
                      "-DLIBXML2_INCLUDE_DIR=${LIBXML2_INCLUDE_DIR}"    --> Ajout DG
                      "-DBOOST_ROOT:PATH=${BOOST_ROOT}"
                      "-DMSVC_STATIC_RUNTIME_LIBRARY=${MSVC_STATIC_RUNTIME_LIBRARY}"

    BUILD_COMMAND     make -j ${CPU_COUNT} all                      
  )

  unset(paquet_git_repo)

endif(${paquet_name}_FOUND)
unset(paquet_RequiredVersion)
unset(paquet_upper_name)
unset(paquet_install_dir)
unset(paquet_config_dir)
unset(paquet_name)
