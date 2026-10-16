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

if(NOT SUNDIALS_HOME AND NOT $ENV{SUNDIALS_HOME} STREQUAL "")
  set(SUNDIALS_HOME $ENV{SUNDIALS_HOME})
endif()

if(NOT SUNDIALS_HOME AND NOT $ENV{SUNDIALS_ROOT} STREQUAL "")
  set(SUNDIALS_HOME $ENV{SUNDIALS_ROOT})
endif()

if(NOT SUNDIALS_HOME AND NOT $ENV{SUNDIALS_INSTALL_DIR} STREQUAL "")
  set(SUNDIALS_HOME $ENV{SUNDIALS_INSTALL_DIR})
endif()

set(SUNDIALS_LIBRARY_LOCATIONS ${SUNDIALS_HOME}/lib)
if(MSVC)
  list(APPEND SUNDIALS_LIBRARY_LOCATIONS ${SUNDIALS_HOME}/bin)
endif()

find_path(SUNDIALS_INCLUDE_DIR NAME sundials/sundials_config.h HINTS ${SUNDIALS_HOME}/include)
mark_as_advanced(SUNDIALS_INCLUDE_DIR)

# Searching for sundials ida
find_library(SUNDIALS_IDA_LIBRARY NAME sundials_ida libsundials_ida HINTS ${SUNDIALS_LIBRARY_LOCATIONS})
mark_as_advanced(SUNDIALS_IDA_LIBRARY)

# Searching for sundials kinsol
find_library(SUNDIALS_KINSOL_LIBRARY NAME sundials_kinsol libsundials_kinsol HINTS ${SUNDIALS_LIBRARY_LOCATIONS})
mark_as_advanced(SUNDIALS_KINSOL_LIBRARY)

# Searching for sundials nvecserial
find_library(SUNDIALS_NVECSERIAL_LIBRARY NAME sundials_nvecserial libsundials_nvecserial HINTS ${SUNDIALS_LIBRARY_LOCATIONS})
mark_as_advanced(SUNDIALS_NVECSERIAL_LIBRARY)

# Searching for sundials sunlinsolklu
find_library(SUNDIALS_SUNLINSOLKLU_LIBRARY NAME sundials_sunlinsolklu libsundials_sunlinsolklu HINTS ${SUNDIALS_LIBRARY_LOCATIONS})
mark_as_advanced(SUNDIALS_SUNLINSOLKLU_LIBRARY)

if (SUNDIALS_INCLUDE_DIR AND SUNDIALS_IDA_LIBRARY)
  set(SundialsTest_DIR ${PROJECT_BINARY_DIR}/SundialsTest_DIR)
  file(MAKE_DIRECTORY ${SundialsTest_DIR})
  set(CXX_STDFLAG "-std=c++11")

  file(WRITE ${SundialsTest_DIR}/testSundials.cpp
    "\#include <ida/ida.h>\n"
    "\#include <sundials/sundials_context.h>\n"
    "int main() {\n"
    "  SUNContext ctx;\n"
    "  int retval = SUNContext_Create(NULL, &ctx);\n"
    "  void* IDAMem = IDACreate(ctx);\n"
    "  int flag = IDASetMinStep(IDAMem, 0.1);\n"
    "  flag = IDASetURound(IDAMem, 0.1);\n"
    "  long int newtoncuriter;\n"
    "  flag = IDAGetNewtonCurIter(IDAMem, &newtoncuriter);\n"
    "  static_cast<void>(flag);\n"
    "  IDAFree(&IDAMem);\n"
    "  SUNContext_Free(&ctx);\n"
    "  return 0;\n"
    "}\n")

  try_compile(TEST_SUNDIALS ${SundialsTest_DIR} SOURCES ${SundialsTest_DIR}/testSundials.cpp
    LINK_LIBRARIES ${SUNDIALS_IDA_LIBRARY}
    CMAKE_FLAGS "-DINCLUDE_DIRECTORIES=${SUNDIALS_INCLUDE_DIR}"
      "-DCOMPILE_DEFINITIONS=${CXX_STDFLAG}"
    OUTPUT_VARIABLE TEST_SUNDIALS_OUTPUT)

  if(NOT TEST_SUNDIALS)
    message(WARNING "Sundials doesn't compile: ${TEST_SUNDIALS_OUTPUT}")
    unset(SUNDIALS_IDA_LIBRARY CACHE)
    unset(SUNDIALS_KINSOL_LIBRARY CACHE)
    unset(SUNDIALS_NVECSERIAL_LIBRARY CACHE)
    unset(SUNDIALS_INCLUDE_DIR CACHE)
    unset(SUNDIALS_SUNLINSOLKLU_LIBRARY CACHE)
    set(Sundials_FOUND OFF)
  endif()
endif()

# Handle the QUIETLY and REQUIRED arguments and set SUNDIALS_FOUND
# to TRUE if all listed variables are TRUE.
# (Use ${CMAKE_ROOT}/Modules instead of ${CMAKE_CURRENT_LIST_DIR} because CMake
#  itself includes this FindSundials when built with an older CMake that does
#  not provide it.  The older CMake also does not have CMAKE_CURRENT_LIST_DIR.)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Sundials "Found Sundials suite" SUNDIALS_IDA_LIBRARY SUNDIALS_KINSOL_LIBRARY SUNDIALS_NVECSERIAL_LIBRARY SUNDIALS_SUNLINSOLKLU_LIBRARY SUNDIALS_INCLUDE_DIR)

if(Sundials_FOUND)
  set(Sundials_INCLUDE_DIRS "${SUNDIALS_INCLUDE_DIR}")

  if(NOT TARGET Sundials::Sundials_IDA)
    add_library(Sundials::Sundials_IDA UNKNOWN IMPORTED)
    if(Sundials_INCLUDE_DIRS)
      set_target_properties(Sundials::Sundials_IDA PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${Sundials_INCLUDE_DIRS}")
    endif()
    if(EXISTS "${SUNDIALS_IDA_LIBRARY}")
      set_target_properties(Sundials::Sundials_IDA PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "C"
        IMPORTED_LOCATION "${SUNDIALS_IDA_LIBRARY}")
    endif()
  endif()

  if(NOT TARGET Sundials::Sundials_KINSOL)
    add_library(Sundials::Sundials_KINSOL UNKNOWN IMPORTED)
    if(Sundials_INCLUDE_DIRS)
      set_target_properties(Sundials::Sundials_KINSOL PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${Sundials_INCLUDE_DIRS}")
    endif()
    if(EXISTS "${SUNDIALS_KINSOL_LIBRARY}")
      set_target_properties(Sundials::Sundials_KINSOL PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "C"
        IMPORTED_LOCATION "${SUNDIALS_KINSOL_LIBRARY}")
    endif()
  endif()

  if(NOT TARGET Sundials::Sundials_NVECSERIAL)
    add_library(Sundials::Sundials_NVECSERIAL UNKNOWN IMPORTED)
    if(Sundials_INCLUDE_DIRS)
      set_target_properties(Sundials::Sundials_NVECSERIAL PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${Sundials_INCLUDE_DIRS}")
    endif()
    if(EXISTS "${SUNDIALS_NVECSERIAL_LIBRARY}")
      set_target_properties(Sundials::Sundials_NVECSERIAL PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "C"
        IMPORTED_LOCATION "${SUNDIALS_NVECSERIAL_LIBRARY}")
    endif()
  endif()

  if(NOT TARGET Sundials::Sundials_SUNMATRIXSPARSE)
    add_library(Sundials::Sundials_SUNMATRIXSPARSE UNKNOWN IMPORTED)
    if(Sundials_INCLUDE_DIRS)
      set_target_properties(Sundials::Sundials_SUNMATRIXSPARSE PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${Sundials_INCLUDE_DIRS}")
    endif()
    if(EXISTS "${SUNDIALS_SUNMATRIXSPARSE_LIBRARY}")
      set_target_properties(Sundials::Sundials_SUNMATRIXSPARSE PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "C"
        IMPORTED_LOCATION "${SUNDIALS_SUNMATRIXSPARSE_LIBRARY}")
    endif()
  endif()

  if(NOT TARGET Sundials::Sundials_SUNLINSOLKLU)
    add_library(Sundials::Sundials_SUNLINSOLKLU UNKNOWN IMPORTED)
    if(Sundials_INCLUDE_DIRS)
      set_target_properties(Sundials::Sundials_SUNLINSOLKLU PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${Sundials_INCLUDE_DIRS}")
    endif()
    if(EXISTS "${SUNDIALS_SUNLINSOLKLU_LIBRARY}")
      set_target_properties(Sundials::Sundials_SUNLINSOLKLU PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "C"
        IMPORTED_LOCATION "${SUNDIALS_SUNLINSOLKLU_LIBRARY}")
    endif()
    set_property(TARGET Sundials::Sundials_SUNLINSOLKLU APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
      $<TARGET_PROPERTY:SuiteSparse::SuiteSparse_KLU,INTERFACE_INCLUDE_DIRECTORIES>
      $<TARGET_PROPERTY:SuiteSparse::SuiteSparse_AMD,INTERFACE_INCLUDE_DIRECTORIES>
      $<TARGET_PROPERTY:SuiteSparse::SuiteSparse_COLAMD,INTERFACE_INCLUDE_DIRECTORIES>
      $<TARGET_PROPERTY:SuiteSparse::SuiteSparse_BTF,INTERFACE_INCLUDE_DIRECTORIES>
      $<TARGET_PROPERTY:SuiteSparse::SuiteSparse_Config,INTERFACE_INCLUDE_DIRECTORIES>
      )
    set_property(TARGET Sundials::Sundials_SUNLINSOLKLU APPEND PROPERTY INTERFACE_LINK_LIBRARIES
      $<TARGET_PROPERTY:SuiteSparse::SuiteSparse_KLU,IMPORTED_LOCATION>
      $<TARGET_PROPERTY:SuiteSparse::SuiteSparse_AMD,IMPORTED_LOCATION>
      $<TARGET_PROPERTY:SuiteSparse::SuiteSparse_COLAMD,IMPORTED_LOCATION>
      $<TARGET_PROPERTY:SuiteSparse::SuiteSparse_BTF,IMPORTED_LOCATION>
      $<TARGET_PROPERTY:SuiteSparse::SuiteSparse_Config,IMPORTED_LOCATION>
      $<TARGET_PROPERTY:Sundials::Sundials_SUNMATRIXSPARSE,IMPORTED_LOCATION>
      )
  endif()
endif()
