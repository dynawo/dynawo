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

if(NOT NICSLU_HOME AND NOT $ENV{NICSLU_HOME} STREQUAL "")
  set(NICSLU_HOME $ENV{NICSLU_HOME})
endif()

if(NOT NICSLU_HOME AND NOT $ENV{NICSLU_ROOT} STREQUAL "")
  set(NICSLU_HOME $ENV{NICSLU_ROOT})
endif()

if(NOT NICSLU_HOME AND NOT $ENV{NICSLU_INSTALL_DIR} STREQUAL "")
  set(NICSLU_HOME $ENV{NICSLU_INSTALL_DIR})
endif()

find_path(NICSLU_INCLUDE_DIR NAME nicslu.h HINTS ${NICSLU_HOME}/include)
find_library(NICSLU_LIBRARY NAME nicslu libnicslu HINTS ${NICSLU_HOME}/lib)
find_library(NICSLU_UTIL NAME nicslu_util HINTS ${NICSLU_HOME}/lib)

mark_as_advanced(NICSLU_INCLUDE_DIR NICSLU_LIBRARY)

# Handle the QUIETLY and REQUIRED arguments and set NICSLU_FOUND
# to TRUE if all listed variables are TRUE.
# (Use ${CMAKE_ROOT}/Modules instead of ${CMAKE_CURRENT_LIST_DIR} because CMake
#  itself includes this FindNICSLU when built with an older CMake that does
#  not provide it.  The older CMake also does not have CMAKE_CURRENT_LIST_DIR.)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(NICSLU DEFAULT_MSG NICSLU_INCLUDE_DIR NICSLU_LIBRARY NICSLU_UTIL)

if(NICSLU_FOUND)
  set(NICSLU_INCLUDE_DIRS ${NICSLU_INCLUDE_DIR})
  set(NICSLU_LIBRARIES ${NICSLU_LIBRARY} ${NICSLU_UTIL})

  if(NOT TARGET NICSLU::NICSLU)
    add_library(NICSLU::NICSLU UNKNOWN IMPORTED)
    if(NICSLU_INCLUDE_DIRS)
      set_target_properties(NICSLU::NICSLU PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${NICSLU_INCLUDE_DIRS}")
    endif()
    if(EXISTS "${NICSLU_LIBRARY}")
      set_target_properties(NICSLU::NICSLU PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "C"
        IMPORTED_LOCATION "${NICSLU_LIBRARY}")
    endif()
  endif()

  if(NOT TARGET NICSLU::NICSLU_Util)
    add_library(NICSLU::NICSLU_Util UNKNOWN IMPORTED)
    if(NICSLU_INCLUDE_DIRS)
      set_target_properties(NICSLU::NICSLU_Util PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${NICSLU_INCLUDE_DIRS}")
    endif()
    if(EXISTS "${NICSLU_UTIL}")
      set_target_properties(NICSLU::NICSLU_Util PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "C"
        IMPORTED_LOCATION "${NICSLU_UTIL}")
    endif()
  endif()
endif()
