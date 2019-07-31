# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# Minimum required (for ExternalProject_Add)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8 FATAL_ERROR)

# Add custom cmake modules to the path
SET(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Project Dynawo
PROJECT(dynawo)
SET(DYNAWO_VERSION_MAJOR 1)
SET(DYNAWO_VERSION_MINOR 0)
SET(DYNAWO_VERSION_PATCH 1)
SET(DYNAWO_VERSION_STRING ${DYNAWO_VERSION_MAJOR}.${DYNAWO_VERSION_MINOR}.${DYNAWO_VERSION_PATCH})

SET(LIBRARY_TYPE SHARED CACHE STRING "Choose either STATIC or SHARED.")
SET(BOOST_USE_STATIC OFF CACHE BOOL "Choose either ON or OFF.")
SET(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Set directories name
SET(BINDIR_NAME bin)
SET(SHAREDIR_NAME share)
SET(SBINDIR_NAME sbin)
SET(DDBDIR_NAME ddb)
SET(INCLUDEDIR_NAME include)
SET(LIBDIR_NAME lib)
SET(DOCDIR_NAME doxygen)

# Set some install directories variables
SET(INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
SET(libdir ${INSTALL_PREFIX}/${LIBDIR_NAME})
SET(includedir ${INSTALL_PREFIX}/${INCLUDEDIR_NAME})
SET(docdir ${INSTALL_PREFIX}/${DOCDIR_NAME})
SET(bindir ${INSTALL_PREFIX}/${BINDIR_NAME})
SET(sharedir ${INSTALL_PREFIX}/${SHAREDIR_NAME})
SET(sbindir ${INSTALL_PREFIX}/${SBINDIR_NAME})
SET(ddbdir ${INSTALL_PREFIX}/${DDBDIR_NAME})

# Use of OMC
SET(OMC_INCLUDE_DIR ${INSTALL_OPENMODELICA}/include/omc/c)
# OMC VERSION
ADD_DEFINITIONS(-D_OMC_${OPENMODELICA_VERSION})

# If C++11 is enabled, check flags availability
SET(CXX11_ENABLED ${CXX11_ENABLED} CACHE BOOL "")
IF(CXX11_ENABLED)
  # Test if a C++11 flag is supported
  INCLUDE(CheckCXXCompilerFlag)
  CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
  CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
  IF(COMPILER_SUPPORTS_CXX11)
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -DLANG_CXX11")
  ELSEIF(COMPILER_SUPPORTS_CXX0X)
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x -DLANG_CXX0X")
  ELSE()
    MESSAGE(STATUS "The compiler ${CMAKE_CXX_COMPILER} has no C++11 support. Disabling C++11.")
  ENDIF()
ELSE()
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++98")
ENDIF()

SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${DYNAWO_DEBUG_COMPILER_OPTION} -D_DEBUG_")

SET(CMAKE_DYN_DICTIONARY_PATHS "$ENV{DYN_DICTIONARY_PATHS}")

# Add specific options for gcc 4.8
IF("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
  # See all warnings in Debug mode
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall -Wextra -Werror -fdiagnostics-show-option -Wno-unused-local-typedefs")
  # -Wswitch-enum : Warn whenever a switch statement has an index of enumerated type and lacks a case for one or more of the named codes of that enumeration
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wswitch-enum -Wunused")
ELSEIF("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Weverything")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-conditional-uninitialized")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-conversion")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-covered-switch-default")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-documentation")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-documentation-unknown-command")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-double-promotion")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-exit-time-destructors")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-extra-semi")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-float-conversion")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-float-equal")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-global-constructors")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-gnu-zero-variadic-macro-arguments")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-mismatched-tags")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-missing-noreturn")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-missing-prototypes")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-missing-variable-declarations")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-non-virtual-dtor")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-old-style-cast")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-padded")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-reserved-id-macro")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-return-type")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-shadow")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-shorten-64-to-32")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-sign-conversion")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-sometimes-uninitialized")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-undef")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-undefined-func-template")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-unreachable-code-break")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-unreachable-code-loop-increment")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-unreachable-code-return")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-unused-exception-parameter")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-unused-macros")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-unused-private-field")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-weak-vtables")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-used-but-marked-unused")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-overloaded-virtual")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-zero-as-null-pointer-constant")
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Werror")
  IF(CXX11_ENABLED)
    SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-c++98-compat")
    SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-c++98-compat-local-type-template-args")
    SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-c++98-compat-pedantic")
    SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-deprecated")
  ELSE()
    SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-pedantic")
    SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-variadic-macros")
    SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-c++11-extensions")
    SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-c++11-long-long")
  ENDIF()
ENDIF()

SET(BUILD_TESTS ${BUILD_TESTS} CACHE BOOL "Build tests.")
IF(CMAKE_BUILD_TYPE STREQUAL "TestCoverage")
  INCLUDE(TestCoverage)
ENDIF()

IF(CMAKE_BUILD_TYPE STREQUAL "Tests")
  INCLUDE(UnitTest)
ENDIF()

IF(CMAKE_BUILD_TYPE STREQUAL "Tests" OR CMAKE_BUILD_TYPE STREQUAL "TestCoverage")
  SET(BUILD_TESTS true)
  FIND_PACKAGE(GTest REQUIRED)
  FIND_PACKAGE(GMock REQUIRED)
  SET(UNITTEST_INCLUDE_DIRS ${GMOCK_INCLUDE_DIRS} ${GTEST_INCLUDE_DIRS})
  SET(UNITTEST_LIBRARIES ${GMOCK_BOTH_LIBRARIES} ${GTEST_BOTH_LIBRARIES})
ENDIF()

# For compatibility with old makefiles
ADD_DEFINITIONS(-D_DYNAWO_)

IF(BOOST_USE_STATIC)
  SET(Boost_USE_STATIC_LIBS TRUE)
ELSE()
  ADD_DEFINITIONS(-DBOOST_ALL_DYN_LINK)
ENDIF()

# For ADEPT
SET(USE_ADEPT ${USE_ADEPT} CACHE BOOL "")
IF(USE_ADEPT)
  ADD_DEFINITIONS(-D_ADEPT_)
  FIND_PACKAGE(Adept REQUIRED)
ENDIF(USE_ADEPT)

find_package(ZLIB REQUIRED)

# LibArchive
FIND_PACKAGE(LibArchive 2.8.0 REQUIRED)

# Boost
IF(BOOST_ROOT_DEFAULT STREQUAL "true")
  SET(Boost_NO_SYSTEM_PATHS FALSE)
ELSE()
  SET(Boost_NO_SYSTEM_PATHS TRUE)
ENDIF()

IF(CMAKE_BUILD_TYPE STREQUAL "Tests" OR  CMAKE_BUILD_TYPE STREQUAL "TestCoverage")
  FIND_PACKAGE(Boost 1.59 REQUIRED
    COMPONENTS
    filesystem
    program_options
    serialization
    system
    log
    iostreams
    )
ELSE()
  FIND_PACKAGE(Boost 1.59 REQUIRED
    COMPONENTS
    filesystem
    program_options
    serialization
    system
    log
    )
ENDIF()

# SUITESPARSE
FIND_PACKAGE(SuiteSparse REQUIRED)

# NICSLU
FIND_PACKAGE(NICSLU)

IF(${NICSLU_FOUND})
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DWITH_NICSLU")
ENDIF()

# Sundials
FIND_PACKAGE(Sundials REQUIRED)

#libZIP
FIND_PACKAGE(libZIP 1.3.0 REQUIRED)

IF(LIBRARY_TYPE STREQUAL "STATIC")
  SET(LibXML_USE_STATIC_LIBS TRUE)
ENDIF()

# libXML
FIND_PACKAGE(libXML 0.2.4 REQUIRED)

# libIIDM
FIND_PACKAGE(libIIDM 0.2.8 REQUIRED
  COMPONENTS
    core
    xml
    ext-activeseason
    ext-activeseason-xml
    ext-busbarsectionposition
    ext-busbarsectionposition-xml
    ext-connectableposition
    ext-connectableposition-xml
    ext-currentlimitsperseason
    ext-currentlimitsperseason-xml
    ext-generatoractivepowercontrol
    ext-generatoractivepowercontrol-xml
    ext-hvdcangledroopactivepowercontrol
    ext-hvdcangledroopactivepowercontrol-xml
    ext-hvdcoperatoractivepowerrange
    ext-hvdcoperatoractivepowerrange-xml
    ext-generatorentsoecategory
    ext-generatorentsoecategory-xml
    ext-generatorstartup
    ext-generatorstartup-xml
    ext-loaddetail
    ext-loaddetail-xml
    ext-standbyautomaton
    ext-standbyautomaton-xml
)

CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/sources/config.h.in ${CMAKE_CURRENT_SOURCE_DIR}/sources/config.h @ONLY)

if (APPLE)
  set(CMAKE_MACOSX_RPATH True)

  # use, i.e. don't skip the full RPATH for the build tree
  set(CMAKE_SKIP_BUILD_RPATH  False)

  # when building, don't use the install RPATH already
  # (but later on when installing)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH False)

  set(CMAKE_INSTALL_RPATH "${INSTALL_PREFIX}/lib")

  # add the automatically determined parts of the RPATH
  # which point to directories outside the build tree to the install RPATH
  set(CMAKE_INSTALL_RPATH_USE_LINK_PATH True)
endif()

INCLUDE(../cpplint/cpplint.cmake)

ADD_SUBDIRECTORY(sources)
ADD_SUBDIRECTORY(sources/Common)
ADD_SUBDIRECTORY(sources/Solvers)
ADD_SUBDIRECTORY(sources/Modeler)
ADD_SUBDIRECTORY(sources/Simulation)
ADD_SUBDIRECTORY(sources/Launcher)
ADD_SUBDIRECTORY(sources/ModelicaCompiler)
ADD_SUBDIRECTORY(sources/Models)
ADD_SUBDIRECTORY(sources/API)
ADD_SUBDIRECTORY(doxygen)
