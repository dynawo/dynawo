# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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

set(RTIO_SOURCES DYNInputChannel.cpp)

set(RTIO_INCLUDE_HEADERS
      DYNInputChannel.h
      DYNOutputChannel.h
      )

if (USE_ZMQPP)
      list(APPEND RTIO_SOURCES
            DYNZmqInputChannel.cpp
            DYNZmqOutputChannel.cpp
            )

      list(APPEND RTIO_INCLUDE_HEADERS
            DYNZmqInputChannel.h
            DYNZmqOutputChannel.h
            )
endif()

add_library(dynawo_RTIO SHARED ${RTIO_SOURCES})

target_link_libraries(dynawo_RTIO
  PRIVATE
    dynawo_ModelerCommon
    dynawo_SimulationCommon
    dynawo_Common
    dynawo_RTCommon
)

if (USE_ZMQPP)
      target_link_libraries(dynawo_RTIO PUBLIC ZMQPP::ZMQPP)
endif()

target_include_directories(dynawo_RTIO SYSTEM INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
)

set_target_properties(dynawo_RTIO PROPERTIES VERSION ${SIM_VERSION_STRING}
                                             SOVERSION ${SIM_VERSION_MAJOR})

install(TARGETS dynawo_RTIO EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${RTIO_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
