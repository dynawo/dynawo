# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

# - Find libZIP library and headers
#  The module defines the following variables:
#
# libZIP_FOUND        - True if libZIP exists and the version is older than the one requested
# libZIP_VERSION      - Version of the libZIP found x.y.z
# libZIP_LIBRARY      - library to link
# libZIP_INCLUDE_DIR  - include search path

if(NOT LIBZIP_HOME AND NOT $ENV{LIBZIP_HOME} STREQUAL "")
  set(LIBZIP_HOME $ENV{LIBZIP_HOME})
endif()

if(NOT LIBZIP_HOME AND NOT $ENV{LIBZIP_ROOT} STREQUAL "")
  set(LIBZIP_HOME $ENV{LIBZIP_ROOT})
endif()

if(NOT LIBZIP_HOME AND NOT $ENV{LIBZIP_INSTALL_DIR} STREQUAL "")
  set(LIBZIP_HOME $ENV{LIBZIP_INSTALL_DIR})
endif()

find_path(libZIP_INCLUDE_DIR NAME "libzip/ZipVersion.h" HINTS ${LIBZIP_HOME}/include)
find_library(libZIP_LIBRARY NAME zip libzip HINTS ${LIBZIP_HOME}/lib)

mark_as_advanced(libZIP_INCLUDE_DIR libZIP_LIBRARY)

# Extract the version number from the header.
set(libZIP_VERSION "")
if(libZIP_INCLUDE_DIR AND EXISTS "${libZIP_INCLUDE_DIR}/libzip/ZipVersion.h")
  # The version string appears in the following in the header:
  # #define  LIBZIP_VERSION 100300
  set(_LIBZIP_VERSION_REGEX "^#define[ \t]+LIBZIP_VERSION[ \t]+([0-9]+)")
  file(STRINGS "${libZIP_INCLUDE_DIR}/libzip/ZipVersion.h" _LIBZIP_VERSION_STRING LIMIT_COUNT 1 REGEX "${_LIBZIP_VERSION_REGEX}")
  string(REGEX REPLACE ${_LIBZIP_VERSION_REGEX} "\\1" _LIBZIP_VERSION_STRING "${_LIBZIP_VERSION_STRING}")
  if(_LIBZIP_VERSION_STRING)
    math(EXPR LIBZIP_MAJOR_VERSION "${_LIBZIP_VERSION_STRING} / 100000")
    math(EXPR LIBZIP_MINOR_VERSION "${_LIBZIP_VERSION_STRING} / 100 % 1000")
    math(EXPR LIBZIP_SUBMINOR_VERSION "${_LIBZIP_VERSION_STRING} % 100")
    set(libZIP_VERSION "${LIBZIP_MAJOR_VERSION}.${LIBZIP_MINOR_VERSION}.${LIBZIP_SUBMINOR_VERSION}")
  endif()
endif()

message("-- libZIP version : ${libZIP_VERSION}")
if(libZIP_FIND_VERSION)
  if("${libZIP_VERSION}" VERSION_LESS "${libZIP_FIND_VERSION}")
    message("\tDetected version of libZIP is too old. Requested version was ${libZIP_FIND_VERSION}.")
    set(libZIP_FOUND FALSE)
  else()
    set(libZIP_FOUND TRUE)
  endif()
else()
  # Handle the QUIETLY and REQUIRED arguments and set libZIP_FOUND
  # to TRUE if all listed variables are TRUE.
  # (Use ${CMAKE_ROOT}/Modules instead of ${CMAKE_CURRENT_LIST_DIR} because CMake
  #  itself includes this FindlibZIP when built with an older CMake that does
  #  not provide it.  The older CMake also does not have CMAKE_CURRENT_LIST_DIR.)
  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(libZIP
    REQUIRED_VARS libZIP_LIBRARY libZIP_INCLUDE_DIR
    VERSION_VAR libZIP_VERSION)
endif()

if(libZIP_FOUND)
  set(libZIP_INCLUDE_DIRS "${libZIP_INCLUDE_DIR}")

  if(NOT TARGET libZIP::libZIP)
    add_library(libZIP::libZIP UNKNOWN IMPORTED)
    if(libZIP_INCLUDE_DIRS)
      set_target_properties(libZIP::libZIP PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${libZIP_INCLUDE_DIRS}")
      set_property(TARGET libZIP::libZIP APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
        $<TARGET_PROPERTY:LibArchive::LibArchive,INTERFACE_INCLUDE_DIRECTORIES>
        )
    endif()
    if(EXISTS "${libZIP_LIBRARY}")
      set_target_properties(libZIP::libZIP PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
        IMPORTED_LOCATION "${libZIP_LIBRARY}")
    endif()
    set_property(TARGET libZIP::libZIP APPEND PROPERTY INTERFACE_LINK_LIBRARIES
      $<TARGET_PROPERTY:LibArchive::LibArchive,IMPORTED_LOCATION>
      $<TARGET_PROPERTY:ZLIB::ZLIB,IMPORTED_LOCATION>
      )
  endif()
endif()
