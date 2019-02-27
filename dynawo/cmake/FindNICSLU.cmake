# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# - Find NICSLU
# Find the native NICSLU includes and library
#
#  NICSLU_INCLUDE_DIR - where to find nicslu.h, etc.
#  NICSLU_LIBRARIES   - List of libraries when using NICSLU.
#  NICSLU_FOUND       - True if NICSLU found.

IF(NOT NICSLU_HOME AND NOT $ENV{NICSLU_HOME} STREQUAL "")
  SET(NICSLU_HOME $ENV{NICSLU_HOME})
ENDIF()

IF(NOT NICSLU_HOME AND NOT $ENV{NICSLU_ROOT} STREQUAL "")
  SET(NICSLU_HOME $ENV{NICSLU_ROOT})
ENDIF()

IF(NOT NICSLU_HOME AND NOT $ENV{NICSLU_INSTALL_DIR} STREQUAL "")
  SET(NICSLU_HOME $ENV{NICSLU_INSTALL_DIR})
ENDIF()

FIND_PATH(NICSLU_INCLUDE_DIR NAME nicslu.h HINTS ${NICSLU_HOME}/include)
FIND_LIBRARY(NICSLU_LIBRARY NAME nicslu libnicslu HINTS ${NICSLU_HOME}/lib)
FIND_LIBRARY(NICSLU_UTIL NAME nicslu_util HINTS ${NICSLU_HOME}/lib)

MARK_AS_ADVANCED(NICSLU_INCLUDE_DIR NICSLU_LIBRARY)

# Handle the QUIETLY and REQUIRED arguments and set NICSLU_FOUND
# to TRUE if all listed variables are TRUE.
# (Use ${CMAKE_ROOT}/Modules instead of ${CMAKE_CURRENT_LIST_DIR} because CMake
#  itself includes this FindNICSLU when built with an older CMake that does
#  not provide it.  The older CMake also does not have CMAKE_CURRENT_LIST_DIR.)
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(NICSLU DEFAULT_MSG NICSLU_INCLUDE_DIR NICSLU_LIBRARY NICSLU_UTIL)

IF(NICSLU_FOUND)
  SET(NICSLU_INCLUDE_DIRS ${NICSLU_INCLUDE_DIR})
  SET(NICSLU_LIBRARIES ${NICSLU_LIBRARY} ${NICSLU_UTIL})
ENDIF()
