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
                      "-Wl,--whole-archive"
                      dynawo_Util
                      "-Wl,--no-whole-archive"
                      ${Boost_PROGRAM_OPTIONS_LIBRARY}
                      pthread
                      ${Boost_THREAD_LIBRARY}
                      "-rdynamic"
                      )

INSTALL(TARGETS dumpModel DESTINATION ${sbindir})

#################################
#        generate-preassembled        #
#################################
# Generate Dyd Library from dyd file
SET(DYD_LIB_GENERATION_SOURCES
    DYNGeneratePreassembled.cpp
    )

INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIR}
                    ${LIBXML_INCLUDE_DIR}
                   )

INCLUDE_DIRECTORIES(../../Common
                    ../Common
                    )

ADD_EXECUTABLE(generate-preassembled ${DYD_LIB_GENERATION_SOURCES})

TARGET_LINK_LIBRARIES(generate-preassembled
                      XMLSAXFormatter${LibXML_LINK_SUFFIX}
                      dynawo_Common
                      dynawo_ModelerCommon
                      dynawo_API_EXTVAR
                      "-Wl,--whole-archive"
                      dynawo_Util
                      "-Wl,--no-whole-archive"
                      ${Boost_PROGRAM_OPTIONS_LIBRARY}
                      pthread
                      ${Boost_THREAD_LIBRARY}
                      ${Boost_FILESYSTEM_LIBRARY}
                      ${Boost_LOG_LIBRARY}
                      ${Boost_SYSTEM_LIBRARY}
                      "-rdynamic"
                     )
SET_TARGET_PROPERTIES(generate-preassembled PROPERTIES VERSION ${DYNAWO_VERSION_STRING})

INSTALL(TARGETS generate-preassembled DESTINATION ${sbindir})
