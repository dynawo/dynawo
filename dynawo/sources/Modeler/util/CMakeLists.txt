# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

#################################
#        dumpModel              #
#################################
SET(DUMP_MODEL_SOURCES
    DYNDumpModel.cpp
    )

ADD_EXECUTABLE(dumpModel ${DUMP_MODEL_SOURCES})

TARGET_LINK_LIBRARIES(dumpModel
    dynawo_ModelerCommon
    )

IF(APPLE)
    # Additional step to make shared library work on macOS; see https://gist.github.com/robertmaynard/5750737
    SET_TARGET_PROPERTIES(dumpModel PROPERTIES INSTALL_RPATH "@loader_path/../lib")
ENDIF()

INSTALL(TARGETS dumpModel EXPORT dynawo-targets DESTINATION ${SBINDIR_NAME})

#################################
#     generate-preassembled     #
#################################
# Generate Dyd Library from dyd file
SET(DYD_LIB_GENERATION_SOURCES
    DYNGeneratePreassembled.cpp
    )

ADD_EXECUTABLE(generate-preassembled ${DYD_LIB_GENERATION_SOURCES})

TARGET_LINK_LIBRARIES(generate-preassembled
    dynawo_ModelerCommon
    )

IF(APPLE)
  # Additional step to make shared library work on macOS; see https://gist.github.com/robertmaynard/5750737
  SET_TARGET_PROPERTIES(generate-preassembled PROPERTIES INSTALL_RPATH "@loader_path/../lib")
ENDIF()

SET_TARGET_PROPERTIES(generate-preassembled PROPERTIES VERSION ${DYNAWO_VERSION_STRING})

INSTALL(TARGETS generate-preassembled EXPORT dynawo-targets DESTINATION ${SBINDIR_NAME})
