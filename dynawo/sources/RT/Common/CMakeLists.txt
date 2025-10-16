# Copyright (c) 2025, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

set(SIM_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(SIM_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(RTCOMMON_INCLUDE_HEADERS
  DYNRTInputCommon.h
  DYNRTOutputCommon.h
)

add_library(dynawo_RTCommon INTERFACE)

target_include_directories(dynawo_RTCommon
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )

install(TARGETS dynawo_RTCommon EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${RTCOMMON_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
