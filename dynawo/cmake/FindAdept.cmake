# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

# - Find Adept
# Find the native Adept includes and library
#
#  ADEPT_INCLUDE_DIR - where to find adept.h
#  ADEPT_LIBRARY     - where is libadept.a.
#  ADEPT_FOUND         - True if adept found.

if(NOT ADEPT_HOME AND NOT $ENV{ADEPT_HOME} STREQUAL "")
  set(ADEPT_HOME $ENV{ADEPT_HOME})
endif()

if(NOT ADEPT_HOME AND NOT $ENV{ADEPT_ROOT} STREQUAL "")
  set(ADEPT_HOME $ENV{ADEPT_ROOT})
endif()

if(NOT ADEPT_HOME AND NOT $ENV{ADEPT_INSTALL_DIR} STREQUAL "")
  set(ADEPT_HOME $ENV{ADEPT_INSTALL_DIR})
endif()

find_path(ADEPT_INCLUDE_DIR NAME adept.h HINTS ${ADEPT_HOME}/include)
find_library(ADEPT_LIBRARY NAME adept libadept HINTS ${ADEPT_HOME}/lib)

mark_as_advanced(ADEPT_INCLUDE_DIR ADEPT_LIBRARY)

# Handle the QUIETLY and REQUIRED arguments and set ADEPT_FOUND
# to TRUE if all listed variables are TRUE.
# (Use ${CMAKE_ROOT}/Modules instead of ${CMAKE_CURRENT_LIST_DIR} because CMake
#  itself includes this FindAdept when built with an older CMake that does
#  not provide it.  The older CMake also does not have CMAKE_CURRENT_LIST_DIR.)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Adept DEFAULT_MSG ADEPT_LIBRARY ADEPT_INCLUDE_DIR)

if(Adept_FOUND)
  set(Adept_INCLUDE_DIRS "${ADEPT_INCLUDE_DIR}")

  if(NOT TARGET Adept::Adept)
    add_library(Adept::Adept UNKNOWN IMPORTED)
    if(Adept_INCLUDE_DIRS)
      set_target_properties(Adept::Adept PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${Adept_INCLUDE_DIRS}")
    endif()
    if(EXISTS "${ADEPT_LIBRARY}")
      set_target_properties(Adept::Adept PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
        IMPORTED_LOCATION "${ADEPT_LIBRARY}")
    endif()
  endif()
endif()
