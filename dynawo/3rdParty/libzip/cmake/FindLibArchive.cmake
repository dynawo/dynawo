# Copyright (c) 2013-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libzip, a library to handle zip archives.

# - Find libarchive library and headers
# The module defines the following variables:
#
#  LibArchive_FOUND        - true if libarchive was found
#  LibArchive_INCLUDE_DIRS - include search path
#  LibArchive_LIBRARIES    - libraries to link
#  LibArchive_VERSION      - libarchive 3-component version number

IF (NOT LIBARCHIVE_HOME AND NOT $ENV{LIBARCHIVE_HOME} STREQUAL "")
    SET(LIBARCHIVE_HOME $ENV{LIBARCHIVE_HOME})
ENDIF ()

IF (NOT LIBARCHIVE_HOME AND NOT $ENV{LIBARCHIVE_ROOT} STREQUAL "")
    SET(LIBARCHIVE_HOME $ENV{LIBARCHIVE_ROOT})
ENDIF ()

FIND_PATH(LibArchive_INCLUDE_DIR NAME archive.h archive_entry.h HINTS ${LIBARCHIVE_HOME}/include)
FIND_LIBRARY(LibArchive_LIBRARY NAME archive libarchive HINTS ${LIBARCHIVE_HOME}/lib)

MARK_AS_ADVANCED(LibArchive_INCLUDE_DIR LibArchive_LIBRARY)

# Extract the version number from the header.
IF (LibArchive_INCLUDE_DIR AND EXISTS "${LibArchive_INCLUDE_DIR}/archive.h")
    # The version string appears in one of two known formats in the header:
    #  #define ARCHIVE_LIBRARY_VERSION "libarchive 2.4.12"
    #  #define ARCHIVE_VERSION_STRING "libarchive 2.8.4"
    # Match either format.
    SET(_LibArchive_VERSION_REGEX "^#define[ \t]+ARCHIVE[_A-Z]+VERSION[_A-Z]*[ \t]+\"libarchive +([0-9]+)\\.([0-9]+)\\.([0-9]+)[^\"]*\".*$")
    FILE(STRINGS "${LibArchive_INCLUDE_DIR}/archive.h" _LibArchive_VERSION_STRING LIMIT_COUNT 1 REGEX "${_LibArchive_VERSION_REGEX}")
    IF (_LibArchive_VERSION_STRING)
        STRING(REGEX REPLACE "${_LibArchive_VERSION_REGEX}" "\\1.\\2.\\3" LibArchive_VERSION "${_LibArchive_VERSION_STRING}")
    ENDIF ()
    UNSET(_LibArchive_VERSION_REGEX)
    UNSET(_LibArchive_VERSION_STRING)
ENDIF ()

# Handle the QUIETLY and REQUIRED arguments and set LIBARCHIVE_FOUND
# to TRUE if all listed variables are TRUE.
# (Use ${CMAKE_ROOT}/Modules instead of ${CMAKE_CURRENT_LIST_DIR} because CMake
#  itself includes this FindLibArchive when built with an older CMake that does
#  not provide it.  The older CMake also does not have CMAKE_CURRENT_LIST_DIR.)
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(LibArchive DEFAULT_MSG LibArchive_LIBRARY LibArchive_INCLUDE_DIR)
SET(LibArchive_FOUND ${LIBARCHIVE_FOUND})
UNSET(LIBARCHIVE_FOUND)

IF (LibArchive_FOUND)
    SET(LibArchive_INCLUDE_DIRS ${LibArchive_INCLUDE_DIR})
    SET(LibArchive_LIBRARIES ${LibArchive_LIBRARY})
ENDIF ()
