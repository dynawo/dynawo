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

INSTALL(FILES ${DYNAWO_HEADERS} DESTINATION ${includedir})


INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIR}
                   )

INCLUDE_DIRECTORIES(../Common
                    ../
                    ../Simulation
                   )

ADD_EXECUTABLE(dynawo ${DYNAWO_SOURCES})

TARGET_LINK_LIBRARIES(dynawo
                      dynawo_Common
                      dynawo_API_PAR
                      dynawo_ModelerCommon
                      dynawo_DataInterface
                      dynawo_Simulation
                      dynawo_SolverCommon
                      dynawo_SolverKINSOL
                      dynawo_SolverSubModel
                      ${Boost_PROGRAM_OPTIONS_LIBRARY}
                      pthread
                      ${Boost_THREAD_LIBRARY}
                      ${LibArchive_LIBRARY}
                      ${ZLIB_LIBRARY}
                      "-rdynamic"
                    )

if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
  TARGET_LINK_LIBRARIES(dynawo "-lrt")
endif()

if (APPLE)
  TARGET_LINK_LIBRARIES(dynawo "-force_load" dynawo_Util)
  # Additional step to make shared library work on macOS; see https://gist.github.com/robertmaynard/5750737
  set_target_properties(dynawo PROPERTIES INSTALL_RPATH "@loader_path/../lib")
else()
  TARGET_LINK_LIBRARIES(dynawo "-Wl,--whole-archive" dynawo_Util "-Wl,--no-whole-archive")
endif()

SET_TARGET_PROPERTIES(dynawo PROPERTIES VERSION ${DYNAWO_VERSION_STRING})
INSTALL(TARGETS dynawo DESTINATION ${bindir})

# Launcher
CONFIGURE_FILE(launcher.in launcher @ONLY)

INSTALL(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/launcher DESTINATION ${bindir})

# execution script for distribution
SET(EXEC_DYNAWO
  execDynawo.sh)

INSTALL(PROGRAMS ${EXEC_DYNAWO} DESTINATION ${bindir})
