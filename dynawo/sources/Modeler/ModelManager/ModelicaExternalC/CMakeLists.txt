# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

set(MODELICA_SOURCES
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

set(MODELICA_INCLUDE_HEADERS
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

#set_source_files_properties(${MODELICA_SOURCES} PROPERTIES LANGUAGE CXX)

add_library(Modelica_externalC SHARED ${MODELICA_SOURCES})

target_compile_options(Modelica_externalC PRIVATE -w)

target_compile_definitions(Modelica_externalC PRIVATE #[[TABLE_SHARE]] DUMMY_FUNCTION_USERTAB)

target_include_directories(Modelica_externalC
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    )

target_include_directories(Modelica_externalC SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
    )


target_link_libraries(Modelica_externalC
  PRIVATE
    dynawo_Common
    Boost::system
  )

install(TARGETS Modelica_externalC EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${MODELICA_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
