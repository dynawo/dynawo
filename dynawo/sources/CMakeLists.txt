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
   -DOUTPUT_DIR=${CMAKE_CURRENT_SOURCE_DIR}
   -DGIT_SOURCE_DIR=${DYNAWO_HOME}
   -P ${CMAKE_MODULE_PATH}/getgitheadrevision.cmake)


set(DYNAWO_INCLUDE_HEADERS
  config.h
  gitversion.h
)

install(FILES ${DYNAWO_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS)
  add_subdirectory(Modeler/DataInterface/test)
  if (CXX11_ENABLED)
    add_subdirectory(Modeler/DataInterface/PowSyblIIDM/test)
  else()
    add_subdirectory(Modeler/DataInterface/IIDM/test)
  endif()
endif()
