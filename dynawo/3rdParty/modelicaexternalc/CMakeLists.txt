# Copyright (c) 2026, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# Build of the external C sources of the Modelica Standard Library 3.2.3 (Modelica/Resources/C-Sources)
# This file is copied into the extracted sources during the patch step (see 3rdParty/CMakeLists.txt)
#
# The library is static: it is embedded into the Dynawo library Modelica_externalC,
# that implements the functions declared in ModelicaUtilities.h (ModelicaError, ModelicaFormatMessage...)

cmake_minimum_required(VERSION 3.9.6 FATAL_ERROR)

project(ModelicaExternalC C)

set(MODELICAEXTERNALC_SOURCES
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

set(MODELICAEXTERNALC_HEADERS
    ModelicaFFT.h
    ModelicaInternal.h
    ModelicaRandom.h
    ModelicaStrings.h
    ModelicaIO.h
    ModelicaMatIO.h
    ModelicaStandardTables.h
    ModelicaUtilities.h
    )

add_library(ModelicaExternalC STATIC ${MODELICAEXTERNALC_SOURCES})

set_target_properties(ModelicaExternalC PROPERTIES POSITION_INDEPENDENT_CODE ON)

target_compile_options(ModelicaExternalC PRIVATE -w)

target_compile_definitions(ModelicaExternalC PRIVATE DUMMY_FUNCTION_USERTAB)

if(MSVC)
  # The functions are exported by the Dynawo dll that embeds this static library
  target_compile_definitions(ModelicaExternalC PRIVATE "MODELICA_EXPORT=__declspec(dllexport)")
endif()

install(TARGETS ModelicaExternalC DESTINATION lib)
install(FILES ${MODELICAEXTERNALC_HEADERS} DESTINATION include)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/../../../LICENSE DESTINATION .)
