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

INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIR}
                    ${LibXML_INCLUDE_DIR}
                    )

INCLUDE_DIRECTORIES(../Common
                    ../../Common
                    )

ADD_EXECUTABLE(dumpModel ${DUMP_MODEL_SOURCES})

TARGET_LINK_LIBRARIES(dumpModel
                      XMLSAXFormatter${LibXML_LINK_SUFFIX}
                      dynawo_Common
                      dynawo_ModelerCommon
                      dynawo_ModelManager
                      dynawo_DataInterface
                      dynawo_SolverCommon
                      dynawo_SolverSubModel
                      "-force_load"
                      dynawo_Util
                      ${Boost_PROGRAM_OPTIONS_LIBRARY}
                      pthread
                      ${Boost_THREAD_LIBRARY}
                      "-rdynamic"
                      )

if (APPLE)
  # Additional step to make shared library work on macOS; see https://gist.github.com/robertmaynard/5750737
  set_target_properties(dumpModel PROPERTIES INSTALL_RPATH "@loader_path/../lib")
endif()

INSTALL(TARGETS dumpModel DESTINATION ${sbindir})

#################################
#        dydLibGenerator        #
#################################
# Generate Dyd Library from dyd file
SET(DYD_LIB_GENERATION_SOURCES
    DYNDydLibGenerator.cpp
    )

INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIR}
                    ${LIBXML_INCLUDE_DIR}
                   )

INCLUDE_DIRECTORIES(../../Common
                    ../Common
                    )

ADD_EXECUTABLE(dydLibGenerator ${DYD_LIB_GENERATION_SOURCES})

TARGET_LINK_LIBRARIES(dydLibGenerator
                      XMLSAXFormatter${LibXML_LINK_SUFFIX}
                      dynawo_Common
                      dynawo_ModelerCommon
                      dynawo_API_EXTVAR
                      "-force_load"
                      dynawo_Util
                      ${Boost_PROGRAM_OPTIONS_LIBRARY}
                      pthread
                      ${Boost_THREAD_LIBRARY}
                      ${Boost_FILESYSTEM_LIBRARY}
                      ${Boost_LOG_LIBRARY}
                      ${Boost_SYSTEM_LIBRARY}
                      "-rdynamic"
                      "-framework CoreFoundation -framework CoreServices"
                     )
SET_TARGET_PROPERTIES(dydLibGenerator PROPERTIES VERSION ${DYNAWO_VERSION_STRING})

if (APPLE)
  # Additional step to make shared library work on macOS; see https://gist.github.com/robertmaynard/5750737
  set_target_properties(dydLibGenerator PROPERTIES INSTALL_RPATH "@loader_path/../lib")
endif()

INSTALL(TARGETS dydLibGenerator DESTINATION ${sbindir})
