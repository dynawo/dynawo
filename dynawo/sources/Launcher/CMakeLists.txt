# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# Dynawo
SET(DYNAWO_SOURCES
    main.cpp
    )

INSTALL(FILES ${DYNAWO_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

ADD_EXECUTABLE(dynawo ${DYNAWO_SOURCES})

TARGET_LINK_LIBRARIES(dynawo
    dynawo_Simulation
    )

IF(APPLE)
  # Additional step to make shared library work on macOS; see https://gist.github.com/robertmaynard/5750737
  SET_TARGET_PROPERTIES(dynawo PROPERTIES INSTALL_RPATH "@loader_path/../lib")
ENDIF()

SET_TARGET_PROPERTIES(dynawo PROPERTIES VERSION ${DYNAWO_VERSION_STRING})

INSTALL(TARGETS dynawo DESTINATION ${BINDIR_NAME})

IF(NOT MSVC)
  # Launcher
  CONFIGURE_FILE(launcher.in launcher @ONLY)

  INSTALL(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/launcher DESTINATION ${BINDIR_NAME})

  # execution script for distribution
  SET(EXEC_DYNAWO
      execDynawo.sh
      )

  INSTALL(PROGRAMS ${EXEC_DYNAWO} DESTINATION ${BINDIR_NAME})
ELSE()
  # Launcher
  CONFIGURE_FILE(dynawo.cmd.in dynawo.cmd @ONLY)
  INSTALL(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/dynawo.cmd DESTINATION /)
ENDIF()
