# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

#obtain git revision
# a custom target that is always built
add_custom_target(revisiontag ALL)

# creates gitversion.h using cmake script
add_custom_command(TARGET revisiontag COMMAND ${CMAKE_COMMAND}
   -DOUTPUT_DIR=${CMAKE_CURRENT_BINARY_DIR}
   -DGIT_SOURCE_DIR=${DYNAWO_HOME}
   -P ${CMAKE_MODULE_PATH}/getgitheadrevision.cmake)

configure_file(config.h.in config.h @ONLY)

set(DYNAWO_INCLUDE_HEADERS
  ${CMAKE_CURRENT_BINARY_DIR}/config.h
  ${CMAKE_CURRENT_BINARY_DIR}/gitversion.h
)

install(FILES ${DYNAWO_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

add_library(dynawo_Interface INTERFACE)

target_compile_definitions(dynawo_Interface
  INTERFACE
    _OMC_${OPENMODELICA_VERSION}
    $<$<BOOL:${USE_ADEPT}>:_ADEPT_>
    $<$<OR:$<CONFIG:Debug>,$<STREQUAL:${RELEASE_WITH_DEBUG},YES>>:_DEBUG_>
)

target_link_libraries(dynawo_Interface
  INTERFACE
    $<$<CXX_COMPILER_ID:GNU>:rt>
    $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:pthread>
)

install(TARGETS dynawo_Interface EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
