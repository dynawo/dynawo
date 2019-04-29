# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

#CompileModelicaModel
SET(COMPILER_MODELICA_OMC_SOURCES
    DYNCompileModelicaModel.cpp
    )

INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIR}
                   )

INCLUDE_DIRECTORIES(../Common
                   )

ADD_EXECUTABLE(compileModelicaModel ${COMPILER_MODELICA_OMC_SOURCES})

TARGET_LINK_LIBRARIES(compileModelicaModel
                      dynawo_ModelerCommon
                      dynawo_Common
                      dynawo_SolverCommon
                      dynawo_SolverSubModel
                      "-Wl,--whole-archive"
                      dynawo_Util
                      "-Wl,--no-whole-archive"
                      ${Boost_PROGRAM_OPTIONS_LIBRARY}
                      dl
                      pthread
                      ${Boost_THREAD_LIBRARY}
                      "-rdynamic"
                      )

INSTALL(TARGETS compileModelicaModel DESTINATION ${sbindir})

#compileCppModelicaModelInDynamicLib
CONFIGURE_FILE(compileCppModelicaModelInDynamicLib.in ${CMAKE_CURRENT_BINARY_DIR}/compileCppModelicaModelInDynamicLib @ONLY)

INSTALL(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/compileCppModelicaModelInDynamicLib DESTINATION ${sbindir})

#cleanCompileModelicaModel
INSTALL(PROGRAMS cleanCompileModelicaModel DESTINATION ${sbindir})

#Add post processing scripts
ADD_SUBDIRECTORY(Scripts_OMC_${OPENMODELICA_VERSION})
