# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# - Find SUITESPARSE
# Find the native SUITESPARSE includes and library
#
#  SUITESPARSE_INCLUDE_DIR - where to find klu.h, etc.
#  SUITESPARSE_LIBRARIES   - List of libraries when using SuiteSparse.
#  SUITESPARSE_FOUND       - True if SuiteSparse found.

IF(NOT SUITESPARSE_HOME AND NOT $ENV{SUITESPARSE_HOME} STREQUAL "")
    SET(SUITESPARSE_HOME $ENV{SUITESPARSE_HOME})
ENDIF()

IF(NOT SUITESPARSE_HOME AND NOT $ENV{SUITESPARSE_ROOT} STREQUAL "")
    SET(SUITESPARSE_HOME $ENV{SUITESPARSE_ROOT})
ENDIF()

IF(NOT SUITESPARSE_HOME AND NOT $ENV{SUITESPARSE_INSTALL_DIR} STREQUAL "")
    SET(SUITESPARSE_HOME $ENV{SUITESPARSE_INSTALL_DIR})
ENDIF()

FIND_PATH(KLU_INCLUDE_DIR NAME klu.h HINTS ${SUITESPARSE_HOME}/include)
FIND_LIBRARY(KLU_LIBRARY NAME klu libklu HINTS ${SUITESPARSE_HOME}/lib)

MARK_AS_ADVANCED(KLU_INCLUDE_DIR KLU_LIBRARY)

FIND_LIBRARY( AMD_LIBRARY NAME amd libamd HINTS ${SUITESPARSE_HOME}/lib)
MARK_AS_ADVANCED(AMD_LIBRARY)

FIND_LIBRARY( COLAMD_LIBRARY NAME colamd libcolamd HINTS ${SUITESPARSE_HOME}/lib)
MARK_AS_ADVANCED(COLAMD_LIBRARY)

FIND_LIBRARY( BTF_LIBRARY NAME btf libbtf HINTS ${SUITESPARSE_HOME}/lib)
MARK_AS_ADVANCED(BTF_LIBRARY)

# Handle the QUIETLY and REQUIRED arguments and set SUITESPARSE_FOUND
# to TRUE if all listed variables are TRUE.
# (Use ${CMAKE_ROOT}/Modules instead of ${CMAKE_CURRENT_LIST_DIR} because CMake
#  itself includes this FindSuiteSparse when built with an older CMake that does
#  not provide it.  The older CMake also does not have CMAKE_CURRENT_LIST_DIR.)
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(SUITESPARSE DEFAULT_MSG KLU_INCLUDE_DIR KLU_LIBRARY AMD_LIBRARY COLAMD_LIBRARY BTF_LIBRARY)

IF(SUITESPARSE_FOUND)
    SET(SUITESPARSE_INCLUDE_DIRS ${KLU_INCLUDE_DIR})
    SET(SUITESPARSE_LIBRARIES    ${KLU_LIBRARY} ${AMD_LIBRARY} ${COLAMD_LIBRARY} ${BTF_LIBRARY})
ENDIF()
