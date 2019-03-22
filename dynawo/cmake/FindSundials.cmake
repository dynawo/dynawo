# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# - Find SUNDIALS
# Find the native SUNDIALS includes and library
#
#  SUNDIALS_INCLUDE_DIR - where to find sundials/sundials_config.h, etc.
#  SUNDIALS_LIBRARIES   - List of libraries when using Sundials.
#  SUNDIALS_FOUND       - True if Sundials found.

IF(NOT SUNDIALS_HOME AND NOT $ENV{SUNDIALS_HOME} STREQUAL "")
    SET(SUNDIALS_HOME $ENV{SUNDIALS_HOME})
ENDIF()

IF(NOT SUNDIALS_HOME AND NOT $ENV{SUNDIALS_ROOT} STREQUAL "")
    SET(SUNDIALS_HOME $ENV{SUNDIALS_ROOT})
ENDIF()

IF(NOT SUNDIALS_HOME AND NOT $ENV{SUNDIALS_INSTALL_DIR} STREQUAL "")
    SET(SUNDIALS_HOME $ENV{SUNDIALS_INSTALL_DIR})
ENDIF()

FIND_PATH(SUNDIALS_INCLUDE_DIR NAME sundials/sundials_config.h HINTS ${SUNDIALS_HOME}/include)
MARK_AS_ADVANCED(SUNDIALS_INCLUDE_DIR)

# Searching for sundials ida
FIND_LIBRARY(SUNDIALS_IDA_LIBRARY NAME sundials_ida libsundials_ida HINTS ${SUNDIALS_HOME}/lib)
MARK_AS_ADVANCED(SUNDIALS_IDA_LIBRARY)

# Searching for sundials kinsol
FIND_LIBRARY(SUNDIALS_KINSOL_LIBRARY NAME sundials_kinsol libsundials_kinsol HINTS ${SUNDIALS_HOME}/lib)
MARK_AS_ADVANCED(SUNDIALS_KINSOL_LIBRARY)

# Searching for sundials nvecserial
FIND_LIBRARY(SUNDIALS_NVECSERIAL_LIBRARY NAME sundials_nvecserial libsundials_nvecserial HINTS ${SUNDIALS_HOME}/lib)
MARK_AS_ADVANCED(SUNDIALS_NVECSERIAL_LIBRARY)

# Searching for sundials sunlinsolklu
FIND_LIBRARY(SUNDIALS_SUNLINSOLKLU_LIBRARY NAME sundials_sunlinsolklu libsundials_sunlinsolklu HINTS ${SUNDIALS_HOME}/lib)
MARK_AS_ADVANCED(SUNDIALS_SUNLINSOLKLU_LIBRARY)

# Searching for sundials sunmatrixsparse
FIND_LIBRARY(SUNDIALS_SUNMATRIXSPARSE_LIBRARY NAME sundials_sunmatrixsparse libsundials_sunmatrixsparse HINTS ${SUNDIALS_HOME}/lib)
MARK_AS_ADVANCED(SUNDIALS_SUNMATRIXSPARSE_LIBRARY)

IF(NICSLU_FOUND)
  # Searching for sundials sunlinsolnicslu
  FIND_LIBRARY(SUNDIALS_SUNLINSOLNICSLU_LIBRARY NAME sundials_sunlinsolnicslu libsundials_sunlinsolnicslu HINTS ${SUNDIALS_HOME}/lib)
  MARK_AS_ADVANCED(SUNDIALS_SUNLINSOLNICSLU_LIBRARY)
ENDIF()

# Handle the QUIETLY and REQUIRED arguments and set SUNDIALS_FOUND
# to TRUE if all listed variables are TRUE.
# (Use ${CMAKE_ROOT}/Modules instead of ${CMAKE_CURRENT_LIST_DIR} because CMake
#  itself includes this FindSundials when built with an older CMake that does
#  not provide it.  The older CMake also does not have CMAKE_CURRENT_LIST_DIR.)
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Sundials "Found Sundials suite" SUNDIALS_IDA_LIBRARY SUNDIALS_KINSOL_LIBRARY SUNDIALS_NVECSERIAL_LIBRARY SUNDIALS_INCLUDE_DIR)
