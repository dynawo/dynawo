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

ADD_EXECUTABLE(compileModelicaModel ${COMPILER_MODELICA_OMC_SOURCES})

TARGET_LINK_LIBRARIES(compileModelicaModel
    dynawo_Common
    ${CMAKE_DL_LIBS}
    )

IF(APPLE)
    # Additional step to make shared library work on macOS; see https://gist.github.com/robertmaynard/5750737
    SET_TARGET_PROPERTIES(compileModelicaModel PROPERTIES INSTALL_RPATH "@loader_path/../lib")
ENDIF()

INSTALL(TARGETS compileModelicaModel EXPORT dynawo-targets DESTINATION ${SBINDIR_NAME})

CONFIGURE_FILE(compileCppModelicaModelInDynamicLib.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/compileCppModelicaModelInDynamicLib.cmake @ONLY)
CONFIGURE_FILE(PreloadCache.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/PreloadCache.cmake @ONLY)
INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/compileCppModelicaModelInDynamicLib.cmake ${CMAKE_CURRENT_BINARY_DIR}/PreloadCache.cmake DESTINATION ${SBINDIR_NAME})

#Add post processing scripts
ADD_SUBDIRECTORY(Scripts_OMC_${OPENMODELICA_VERSION})
