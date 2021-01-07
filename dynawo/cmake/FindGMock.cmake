# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# - Find GMock
#
#  GMOCK_INCLUDE_DIR - where to find gmock.h
#  GMOCK_FOUND       - True if gmock found.
IF(NOT GMOCK_HOME AND NOT $ENV{GMOCK_HOME} STREQUAL "")
  SET(GMOCK_HOME $ENV{GMOCK_HOME})
ENDIF()

IF(NOT GMOCK_HOME AND NOT $ENV{GMOCK_ROOT} STREQUAL "")
  SET(GMOCK_HOME $ENV{GMOCK_ROOT})
ENDIF()

FIND_PATH(GMOCK_INCLUDE_DIR NAME gmock/gmock.h gtest/gtest.h HINTS $ENV{GMOCK_HOME}/include ${GMOCK_HOME}/include)
FIND_LIBRARY(GMOCK_LIBRARY NAME gmock libgmock gtest libgtest HINTS ENV{GMOCK_HOME} ${GMOCK_HOME} PATH_SUFFIXES lib lib${CMAKE_LIBRARY_ARCHITECTURE} )
FIND_LIBRARY(GMOCK_MAIN_LIBRARY NAME gmock_main liggmock_main gtest_main libgtest_main
             HINTS ENV{GMOCK_HOME} ${GMOCK_HOME} PATH_SUFFIXES lib lib${CMAKE_LIBRARY_ARCHITECTURE} )

MARK_AS_ADVANCED(GMOCK_INCLUDE_DIR GMOCK_LIBRARY GMOCK_MAIN_LIBRARY)

# Handle the QUIETLY and REQUIRED arguments and set GMOCK_FOUND
# to TRUE if all listed variables are TRUE.
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(GMock DEFAULT_MSG GMOCK_INCLUDE_DIR GMOCK_LIBRARY GMOCK_MAIN_LIBRARY)

if(GMOCK_FOUND)
  set(GMOCK_INCLUDE_DIRS ${GMOCK_INCLUDE_DIR})
  set(GMOCK_BOTH_LIBRARIES ${GMOCK_LIBRARY} ${GMOCK_MAIN_LIBRARY})

  if(NOT TARGET GTest::gmock)
    add_library(GTest::gmock UNKNOWN IMPORTED)
    set_property(TARGET GTest::gmock APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
    if(GMOCK_INCLUDE_DIRS)
      set_target_properties(GTest::gmock PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${GMOCK_INCLUDE_DIRS}")
    endif()
    if(EXISTS "${GMOCK_LIBRARY}")
      set_target_properties(GTest::gmock PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
        IMPORTED_LINK_INTERFACE_LIBRARIES "Threads::Threads;GTest::gtest"
        IMPORTED_LOCATION "${GMOCK_LIBRARY}")
    endif()
  endif()
  if(NOT TARGET GTest::gmock_main)
    add_library(GTest::gmock_main UNKNOWN IMPORTED)
    set_property(TARGET GTest::gmock_main APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
    if(GMOCK_INCLUDE_DIRS)
      set_target_properties(GTest::gmock_main PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${GMOCK_INCLUDE_DIRS}")
    endif()
    if(EXISTS "${GMOCK_MAIN_LIBRARY}")
      set_target_properties(GTest::gmock_main PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
        IMPORTED_LINK_INTERFACE_LIBRARIES "Threads::Threads;GTest::gmock"
        IMPORTED_LOCATION "${GMOCK_MAIN_LIBRARY}")
    endif()
  endif()
endif()
