# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

SET(MODELICA_SOURCES
    DYNModelicaUtilities.cpp
    ModelicaFFT.c
    ModelicaInternal.c
    ModelicaRandom.c
    ModelicaStrings.c
    ModelicaIO.c
    ModelicaMatIO.c
    snprintf.c
    ModelicaStandardTables.c
    ModelicaStandardTablesUsertab.c
    )

SET(MODELICA_INCLUDE_HEADERS
    ModelicaFFT.h
    ModelicaInternal.h
    ModelicaRandom.h
    ModelicaStrings.h
    ModelicaIO.h
    ModelicaMatIO.h
    ModelicaStandardTables.h
    )

# these remaining five files are for internal used only :
#ModelicaUtilities.h
#gconstructor.h
#uthash.h
#win32_dirent.c
#win32_dirent.h

#SET_SOURCE_FILES_PROPERTIES(${MODELICA_SOURCES} PROPERTIES LANGUAGE CXX)

ADD_LIBRARY(Modelica_externalC ${LIBRARY_TYPE} ${MODELICA_SOURCES})

TARGET_COMPILE_OPTIONS(Modelica_externalC PRIVATE -w)

TARGET_COMPILE_DEFINITIONS(Modelica_externalC PRIVATE #[[TABLE_SHARE]] DUMMY_FUNCTION_USERTAB)

TARGET_INCLUDE_DIRECTORIES(Modelica_externalC
    INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    )

TARGET_LINK_LIBRARIES(Modelica_externalC
    dynawo_Common
    )

INSTALL(TARGETS Modelica_externalC EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
INSTALL(FILES ${MODELICA_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
