# Copyright (c) 2013-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libzip, a library to handle zip archives.

# - Find libZIP library and headers
#  The module defines the following variables:
#
# libZIP_FOUND        - True if libZIP exists and the version is older than the one requested
# libZIP_VERSION      - Version of the libZIP found x.y.z
# libZIP_LIBRARY      - library to link
# libZIP_INCLUDE_DIR  - include search path

IF (NOT LIBZIP_HOME AND NOT $ENV{LIBZIP_HOME} STREQUAL "")
    SET(LIBZIP_HOME $ENV{LIBZIP_HOME})
ENDIF ()

IF (NOT LIBZIP_HOME AND NOT $ENV{LIBZIP_ROOT} STREQUAL "")
    SET(LIBZIP_HOME $ENV{LIBZIP_ROOT})
ENDIF ()

IF (NOT LIBZIP_HOME AND NOT $ENV{LIBZIP_INSTALL_DIR} STREQUAL "")
    SET(LIBZIP_HOME $ENV{LIBZIP_INSTALL_DIR})
ENDIF ()

FIND_PATH(libZIP_INCLUDE_DIR NAME "libzip/ZipVersion.h" HINTS ${LIBZIP_HOME}/include)
FIND_LIBRARY(libZIP_LIBRARY NAME zip libzip HINTS ${LIBZIP_HOME}/lib)

MARK_AS_ADVANCED(libZIP_INCLUDE_DIR libZIP_LIBRARY)

# Extract the version number from the header.
SET(libZIP_VERSION "")
IF (libZIP_INCLUDE_DIR AND EXISTS "${libZIP_INCLUDE_DIR}/libzip/ZipVersion.h")
    # The version string appears in the following in the header:
    # #define  LIBZIP_VERSION 100300
    SET(_LIBZIP_VERSION_REGEX "^#define[ \t]+LIBZIP_VERSION+[ \t]+([0-9]+)")
    FILE(STRINGS "${libZIP_INCLUDE_DIR}/libzip/ZipVersion.h" _LIBZIP_VERSION_STRING LIMIT_COUNT 1 REGEX "${_LIBZIP_VERSION_REGEX}")
    IF (_LIBZIP_VERSION_STRING)
        MATH(EXPR LIBZIP_MAJOR_VERSION "${_LIBZIP_VERSION_STRING} / 100000")
        MATH(EXPR LIBZIP_MINOR_VERSION "${_LIBZIP_VERSION_STRING} / 100 % 1000")
        MATH(EXPR LIBZIP_SUBMINOR_VERSION "${_LIBZIP_VERSION_STRING} % 100")
        SET(libZIP_VERSION "${LIBZIP_MAJOR_VERSION}.${LIBZIP_MINOR_VERSION}.${LIBZIP_SUBMINOR_VERSION}")
    ENDIF ()
ENDIF ()

MESSAGE("-- libZIP version : ${libZIP_VERSION}")
IF (libZIP_FIND_VERSION)
    IF ("${libZIP_VERSION}" VERSION_LESS "${libZIP_FIND_VERSION}")
        MESSAGE("\n\tDetected version of libZIP is too old. Requested version was ${libZIP_FIND_VERSION}.\n")
        SET(libZIP_FOUND FALSE)
    ENDIF ()
ELSE ()
    # Handle the QUIETLY and REQUIRED arguments and set libZIP_FOUND
    # to TRUE if all listed variables are TRUE.
    # (Use ${CMAKE_ROOT}/Modules instead of ${CMAKE_CURRENT_LIST_DIR} because CMake
    #  itself includes this FindlibZIP when built with an older CMake that does
    #  not provide it.  The older CMake also does not have CMAKE_CURRENT_LIST_DIR.)
    INCLUDE(FindPackageHandleStandardArgs)
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(libZIP
        REQUIRED_VARS libZIP_LIBRARY libZIP_INCLUDE_DIR
        VERSION_VAR libZIP_VERSION)
ENDIF ()
