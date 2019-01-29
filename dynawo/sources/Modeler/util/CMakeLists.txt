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
                    ${LIBXML_INCLUDE_DIR}
                    )

INCLUDE_DIRECTORIES(../Common
                    ../../Common
                    )

ADD_EXECUTABLE(dumpModel ${DUMP_MODEL_SOURCES})

TARGET_LINK_LIBRARIES(dumpModel
                      XMLSAXFormatter
                      dynawo_Common
                      dynawo_ModelerCommon
                      dynawo_ModelManager
                      ${Boost_PROGRAM_OPTIONS_LIBRARY}
                      )

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
                      XMLSAXFormatter
                      XMLSAXParser
                      dynawo_Common
                      dynawo_ModelerCommon
                      dynawo_API_EXTVAR
                      ${Boost_PROGRAM_OPTIONS_LIBRARY}
                     )
SET_TARGET_PROPERTIES(dydLibGenerator PROPERTIES VERSION ${DYNAWO_VERSION_STRING})

INSTALL(TARGETS dydLibGenerator DESTINATION ${sbindir})
