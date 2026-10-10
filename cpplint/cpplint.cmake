# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
set(CPPLINT_PATH ${DYNAWO_HOME}/cpplint/cpplint-wrapper.py)

if(NOT EXISTS "${DYNAWO_HOME}/cpplint/cpplint.py")
  include(ExternalProject)

  set(cpplint_version 1.4.4)
  set(cpplint_md5 77a0f3c2469a737e899443ef2d29f498)
  if(DEFINED ENV{DYNAWO_CPPLINT_DOWNLOAD_URL})
    set(cpplint_prefix_url $ENV{DYNAWO_CPPLINT_DOWNLOAD_URL})
  else()
    set(cpplint_prefix_url https://github.com/cpplint/cpplint/archive)
  endif()

  ExternalProject_Add(cpplint_download
    INSTALL_DIR         ${DYNAWO_HOME}/cpplint
    DOWNLOAD_DIR        ${DYNAWO_HOME}/cpplint
    TMP_DIR             ${CMAKE_CURRENT_BINARY_DIR}/cpplint-tmp
    STAMP_DIR           ${CMAKE_CURRENT_BINARY_DIR}/cpplint-stamp
    SOURCE_DIR          ${CMAKE_CURRENT_BINARY_DIR}/cpplint
    BINARY_DIR          ${CMAKE_CURRENT_BINARY_DIR}/cpplint-build
    URL                 ${cpplint_prefix_url}/${cpplint_version}.tar.gz
    URL_MD5             ${cpplint_md5}
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ""
    INSTALL_COMMAND     ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/cpplint.py <INSTALL_DIR>/cpplint.py
    )
else()
  add_custom_target(cpplint_download ALL)
endif()

if(MSVC)
  add_custom_target(cpplint ALL
    DEPENDS cpplint_download
    COMMAND ${PYTHON_EXECUTABLE} ${CPPLINT_PATH} --modified --filter=-build/header_guard ${DYNAWO_HOME})
else()
  add_custom_target(cpplint ALL
    DEPENDS cpplint_download
    COMMAND ${PYTHON_EXECUTABLE} ${CPPLINT_PATH} --modified ${DYNAWO_HOME})
endif()
