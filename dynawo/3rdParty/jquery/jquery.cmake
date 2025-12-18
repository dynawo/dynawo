# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

if(NOT EXISTS "${DYNAWO_HOME}/util/curvesToHtml/resources/jquery.js")
  include(ExternalProject)

  set(jquery_version 1.3.2)
  set(jquery_md5 d26ffb8c2a558e74030a72dae7b40885)
  if(DEFINED ENV{DYNAWO_JQUERY_DOWNLOAD_URL})
    set(jquery_prefix_url $ENV{DYNAWO_JQUERY_DOWNLOAD_URL})
  else()
    set(jquery_prefix_url https://github.com/jquery/jquery/archive)
  endif()

  ExternalProject_Add(jquery_download
    INSTALL_DIR         ${DYNAWO_HOME}/util/curvesToHtml/resources
    DOWNLOAD_DIR        ${DYNAWO_HOME}/util/curvesToHtml/resources
    TMP_DIR             ${CMAKE_CURRENT_BINARY_DIR}/jquery-tmp
    STAMP_DIR           ${CMAKE_CURRENT_BINARY_DIR}/jquery-stamp
    SOURCE_DIR          ${CMAKE_CURRENT_BINARY_DIR}/jquery
    BINARY_DIR          ${CMAKE_CURRENT_BINARY_DIR}/jquery-build
    URL                 ${jquery_prefix_url}/${jquery_version}.tar.gz
    URL_MD5             ${jquery_md5}
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ""
    INSTALL_COMMAND     ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/jquery.js <INSTALL_DIR>/jquery.js
    )
else()
  add_custom_target(jquery_download ALL)
endif()

if(NOT EXISTS "${DYNAWO_HOME}/util/curvesToHtml/resources/jquery.flot.crosshair.js" OR
NOT EXISTS "${DYNAWO_HOME}/util/curvesToHtml/resources/jquery.flot.js" OR
NOT EXISTS "${DYNAWO_HOME}/util/curvesToHtml/resources/jquery.flot.navigate.js" OR
NOT EXISTS "${DYNAWO_HOME}/util/curvesToHtml/resources/jquery.flot.selection.js" OR
NOT EXISTS "${DYNAWO_HOME}/util/curvesToHtml/resources/arrow-down.gif" OR
NOT EXISTS "${DYNAWO_HOME}/util/curvesToHtml/resources/arrow-left.gif" OR
NOT EXISTS "${DYNAWO_HOME}/util/curvesToHtml/resources/arrow-right.gif" OR
NOT EXISTS "${DYNAWO_HOME}/util/curvesToHtml/resources/arrow-up.gif")
  include(ExternalProject)

  set(flot_version 0.6.0)
  set(flot_md5 edc4027c4778401f03db35608ca4d46d)
  if(DEFINED ENV{DYNAWO_FLOT_DOWNLOAD_URL})
    set(flot_prefix_url $ENV{DYNAWO_FLOT_DOWNLOAD_URL})
  else()
    set(flot_prefix_url https://github.com/flot/flot/archive)
  endif()

  ExternalProject_Add(flot_download
    INSTALL_DIR         ${DYNAWO_HOME}/util/curvesToHtml/resources
    DOWNLOAD_DIR        ${DYNAWO_HOME}/util/curvesToHtml/resources
    TMP_DIR             ${CMAKE_CURRENT_BINARY_DIR}/flot-tmp
    STAMP_DIR           ${CMAKE_CURRENT_BINARY_DIR}/flot-stamp
    SOURCE_DIR          ${CMAKE_CURRENT_BINARY_DIR}/flot
    BINARY_DIR          ${CMAKE_CURRENT_BINARY_DIR}/flot-build
    URL                 ${flot_prefix_url}/v${flot_version}.tar.gz
    URL_MD5             ${flot_md5}
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ""
    INSTALL_COMMAND     ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/jquery.flot.crosshair.js <INSTALL_DIR>/jquery.flot.crosshair.js
    COMMAND             ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/jquery.flot.js <INSTALL_DIR>/jquery.flot.js
    COMMAND             ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/jquery.flot.navigate.js <INSTALL_DIR>/jquery.flot.navigate.js
    COMMAND             ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/jquery.flot.selection.js <INSTALL_DIR>/jquery.flot.selection.js
    COMMAND             ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/examples/arrow-down.gif <INSTALL_DIR>/arrow-down.gif
    COMMAND             ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/examples/arrow-left.gif <INSTALL_DIR>/arrow-left.gif
    COMMAND             ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/examples/arrow-right.gif <INSTALL_DIR>/arrow-right.gif
    COMMAND             ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/examples/arrow-up.gif <INSTALL_DIR>/arrow-up.gif
    )
else()
  add_custom_target(flot_download ALL)
endif()
