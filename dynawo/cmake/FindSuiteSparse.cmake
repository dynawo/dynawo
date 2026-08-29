# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

# - Find SUITESPARSE
# Find the native SUITESPARSE includes and library
#
#  SUITESPARSE_INCLUDE_DIR - where to find klu.h, etc.
#  SUITESPARSE_LIBRARIES   - List of libraries when using SuiteSparse.
#  SUITESPARSE_FOUND       - True if SuiteSparse found.

if(NOT SUITESPARSE_HOME AND NOT $ENV{SUITESPARSE_HOME} STREQUAL "")
  set(SUITESPARSE_HOME $ENV{SUITESPARSE_HOME})
endif()

if(NOT SUITESPARSE_HOME AND NOT $ENV{SUITESPARSE_ROOT} STREQUAL "")
  set(SUITESPARSE_HOME $ENV{SUITESPARSE_ROOT})
endif()

if(NOT SUITESPARSE_HOME AND NOT $ENV{SUITESPARSE_INSTALL_DIR} STREQUAL "")
  set(SUITESPARSE_HOME $ENV{SUITESPARSE_INSTALL_DIR})
endif()

find_path(KLU_INCLUDE_DIR NAME klu.h HINTS ${SUITESPARSE_HOME}/include)
find_library(KLU_LIBRARY NAME klu libklu HINTS ${SUITESPARSE_HOME}/lib)

mark_as_advanced(KLU_INCLUDE_DIR KLU_LIBRARY)

find_library(SUITESPARSE_CONFIG_LIBRARY NAME suitesparseconfig libsuitesparseconfig HINTS ${SUITESPARSE_HOME}/lib)
mark_as_advanced(SUITESPARSE_CONFIG_LIBRARY)

find_library(AMD_LIBRARY NAME amd libamd HINTS ${SUITESPARSE_HOME}/lib)
mark_as_advanced(AMD_LIBRARY)

find_library(COLAMD_LIBRARY NAME colamd libcolamd HINTS ${SUITESPARSE_HOME}/lib)
mark_as_advanced(COLAMD_LIBRARY)

find_library(BTF_LIBRARY NAME btf libbtf HINTS ${SUITESPARSE_HOME}/lib)
mark_as_advanced(BTF_LIBRARY)

# Handle the QUIETLY and REQUIRED arguments and set SUITESPARSE_FOUND
# to TRUE if all listed variables are TRUE.
# (Use ${CMAKE_ROOT}/Modules instead of ${CMAKE_CURRENT_LIST_DIR} because CMake
#  itself includes this FindSuiteSparse when built with an older CMake that does
#  not provide it.  The older CMake also does not have CMAKE_CURRENT_LIST_DIR.)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SuiteSparse DEFAULT_MSG KLU_INCLUDE_DIR KLU_LIBRARY AMD_LIBRARY COLAMD_LIBRARY BTF_LIBRARY)

if(SuiteSparse_FOUND)

  set(SUITESPARSE_INCLUDE_DIRS ${KLU_INCLUDE_DIR})
  if(NOT TARGET SuiteSparse::SuiteSparse_Config)
    add_library(SuiteSparse::SuiteSparse_Config UNKNOWN IMPORTED)
    if(SUITESPARSE_INCLUDE_DIRS)
      set_target_properties(SuiteSparse::SuiteSparse_Config PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${SUITESPARSE_INCLUDE_DIRS}")
    endif()
    if(EXISTS "${SUITESPARSE_CONFIG_LIBRARY}")
      set_target_properties(SuiteSparse::SuiteSparse_Config PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "C"
        IMPORTED_LOCATION "${SUITESPARSE_CONFIG_LIBRARY}")
    endif()
  endif()

  if(NOT TARGET SuiteSparse::SuiteSparse_KLU)
    add_library(SuiteSparse::SuiteSparse_KLU UNKNOWN IMPORTED)
    if(SUITESPARSE_INCLUDE_DIRS)
      set_target_properties(SuiteSparse::SuiteSparse_KLU PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${SUITESPARSE_INCLUDE_DIRS}")
    endif()
    if(EXISTS "${KLU_LIBRARY}")
      set_target_properties(SuiteSparse::SuiteSparse_KLU PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "C"
        IMPORTED_LOCATION "${KLU_LIBRARY}")
    endif()
  endif()

  if(NOT TARGET SuiteSparse::SuiteSparse_AMD)
    add_library(SuiteSparse::SuiteSparse_AMD UNKNOWN IMPORTED)
    if(SUITESPARSE_INCLUDE_DIRS)
      set_target_properties(SuiteSparse::SuiteSparse_AMD PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${SUITESPARSE_INCLUDE_DIRS}")
    endif()
    if(EXISTS "${AMD_LIBRARY}")
      set_target_properties(SuiteSparse::SuiteSparse_AMD PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "C"
        IMPORTED_LOCATION "${AMD_LIBRARY}")
    endif()
  endif()

  if(NOT TARGET SuiteSparse::SuiteSparse_COLAMD)
    add_library(SuiteSparse::SuiteSparse_COLAMD UNKNOWN IMPORTED)
    if(SUITESPARSE_INCLUDE_DIRS)
      set_target_properties(SuiteSparse::SuiteSparse_COLAMD PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${SUITESPARSE_INCLUDE_DIRS}")
    endif()
    if(EXISTS "${COLAMD_LIBRARY}")
      set_target_properties(SuiteSparse::SuiteSparse_COLAMD PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "C"
        IMPORTED_LOCATION "${COLAMD_LIBRARY}")
    endif()
  endif()

  if(NOT TARGET SuiteSparse::SuiteSparse_BTF)
    add_library(SuiteSparse::SuiteSparse_BTF UNKNOWN IMPORTED)
    if(SUITESPARSE_INCLUDE_DIRS)
      set_target_properties(SuiteSparse::SuiteSparse_BTF PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${SUITESPARSE_INCLUDE_DIRS}")
    endif()
    if(EXISTS "${BTF_LIBRARY}")
      set_target_properties(SuiteSparse::SuiteSparse_BTF PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "C"
        IMPORTED_LOCATION "${BTF_LIBRARY}")
    endif()
  endif()

endif()
