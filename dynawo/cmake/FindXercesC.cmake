# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# - Find Xerces-C
# This module tries to find the Xerces-C library and headers.
# Once done this will define
#
#   XERCESC_FOUND - system has Xerces-C headers and libraries
#   XERCESC_INCLUDE_DIRS - the include directories needed for Xerces-C
#   XERCESC_LIBRARIES - the libraries needed to use Xerces-C

IF(NOT XERCESC_HOME AND NOT $ENV{XERCESC_HOME} STREQUAL "")
    SET(XERCESC_HOME $ENV{XERCESC_HOME})
ENDIF()

IF(NOT XERCESC_HOME AND NOT $ENV{XERCESC_ROOT} STREQUAL "")
    SET(XERCESC_HOME $ENV{XERCESC_ROOT})
ENDIF()

FIND_PATH(XERCESC_INCLUDE_DIR NAME xercesc/util/XercesVersion.hpp HINTS ${XERCESC_HOME}/include)
FIND_LIBRARY(XERCESC_LIBRARY NAME xerces-c libxerces-c HINTS ${XERCESC_HOME}/lib)

MARK_AS_ADVANCED(XERCESC_INCLUDE_DIR XERCESC_LIBRARY)

# Handle the QUIETLY and REQUIRED arguments and set XERCESC_FOUND
# to TRUE if all listed variables are TRUE.
# (Use ${CMAKE_ROOT}/Modules instead of ${CMAKE_CURRENT_LIST_DIR} because CMake
#  itself includes this FindXercesC when built with an older CMake that does
#  not provide it.  The older CMake also does not have CMAKE_CURRENT_LIST_DIR.)
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(XercesC DEFAULT_MSG XERCESC_LIBRARY XERCESC_INCLUDE_DIR)

IF(XERCESC_FOUND)
    SET(XERCESC_INCLUDE_DIRS ${XERCESC_INCLUDE_DIR})
    SET(XERCESC_LIBRARIES    ${XERCESC_LIBRARY})
ENDIF()
