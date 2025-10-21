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

set(RTENGINE_SOURCES
      DYNClock.cpp
      DYNInputDispatcherAsync.cpp
      DYNOutputDispatcher.cpp
      )

set(RTENGINE_INCLUDE_HEADERS
      DYNClock.h
      DYNInputDispatcherAsync.h
      DYNOutputDispatcher.h
      )

add_library(dynawo_RTEngine SHARED ${RTENGINE_SOURCES})

target_link_libraries(dynawo_RTEngine
  PUBLIC
    dynawo_RTCommon
  PRIVATE
    dynawo_Common
    dynawo_ModelerCommon
    dynawo_SimulationCommon
    dynawo_RTIO
    dynawo_API_CRV
    dynawo_API_TL
    dynawo_API_CSTR
)

target_include_directories(dynawo_RTEngine
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )

set_target_properties(dynawo_RTEngine PROPERTIES VERSION ${SIM_VERSION_STRING}
                                                 SOVERSION ${SIM_VERSION_MAJOR})

install(TARGETS dynawo_RTEngine EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${RTENGINE_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
