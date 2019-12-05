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
CMAKE_MINIMUM_REQUIRED(VERSION 3.9.6 FATAL_ERROR)

if(POLICY CMP0074)
  cmake_policy(SET CMP0074 NEW)
endif()

if(${CMAKE_VERSION} VERSION_GREATER "3.15.0")
  if(POLICY CMP0091)
    cmake_policy(SET CMP0091 NEW)
  endif()
endif()

# Add custom cmake modules to the path
SET(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel (CMake defaults)")
SET(LIBRARY_TYPE SHARED CACHE STRING "Choose either STATIC or SHARED.")
SET(BOOST_USE_STATIC OFF CACHE BOOL "Choose either ON or OFF.")
SET(MSVC_STATIC_RUNTIME_LIBRARY OFF CACHE BOOL "Choose either ON or OFF.")

# Project Dynawo
PROJECT(dynawo)
SET(DYNAWO_VERSION_MAJOR 1)
SET(DYNAWO_VERSION_MINOR 0)
SET(DYNAWO_VERSION_PATCH 1)
SET(DYNAWO_VERSION_STRING ${DYNAWO_VERSION_MAJOR}.${DYNAWO_VERSION_MINOR}.${DYNAWO_VERSION_PATCH})

SET(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)    # export all symbols from dll on Windows
SET(CMAKE_ENABLE_EXPORTS ON)                # export all symbols from exe on Windows
SET(CMAKE_POSITION_INDEPENDENT_CODE ON)     # set -fPIC on Linux

if(DEFINED DYNAWO_THIRD_PARTY_DIR)
  GET_FILENAME_COMPONENT(DYNAWO_THIRD_PARTY_DIR ${DYNAWO_THIRD_PARTY_DIR} ABSOLUTE)
  set(ADEPT_HOME ${DYNAWO_THIRD_PARTY_DIR}/adept CACHE PATH "Path where an Adept installation already exists")
  set(SUITESPARSE_HOME ${DYNAWO_THIRD_PARTY_DIR}/suitesparse CACHE PATH "Path where an SuiteSparse installation already exists")
  set(SUNDIALS_HOME ${DYNAWO_THIRD_PARTY_DIR}/sundials CACHE PATH "Path where an Sundials installation already exists")
  set(LIBZIP_HOME ${DYNAWO_THIRD_PARTY_DIR}/libzip CACHE PATH "Path where an libzip installation already exists")
  set(LIBXML_HOME ${DYNAWO_THIRD_PARTY_DIR}/libxml CACHE PATH "Path where an libxml installation already exists")
  set(LIBIIDM_HOME ${DYNAWO_THIRD_PARTY_DIR}/libiidm CACHE PATH "Path where an libiidm installation already exists")
  set(BOOST_ROOT ${DYNAWO_THIRD_PARTY_DIR}/boost CACHE PATH "Path where a Boost installation already exists")
  set(GTEST_ROOT ${DYNAWO_THIRD_PARTY_DIR}/googletest CACHE PATH "Path where a GoogleTest installation already exists")
  set(GMOCK_HOME ${DYNAWO_THIRD_PARTY_DIR}/googletest CACHE PATH "Path where a GoogleTest installation already exists")
  set(LIBARCHIVE_HOME ${DYNAWO_THIRD_PARTY_DIR}/libarchive CACHE PATH "Path where a LibArchive installation already exists")
  set(ZLIB_ROOT ${DYNAWO_THIRD_PARTY_DIR}/zlib CACHE PATH "Path where a ZLib installation already exists")
  set(XERCESC_HOME ${DYNAWO_THIRD_PARTY_DIR}/xerces-c CACHE PATH "Path where a Xerces-c installation already exists")
endif()

GET_FILENAME_COMPONENT(DYNAWO_HOME ${DYNAWO_HOME} ABSOLUTE)

# Set directories name
SET(BINDIR_NAME bin)
SET(SHAREDIR_NAME share)
SET(SBINDIR_NAME sbin)
SET(DDBDIR_NAME ddb)
SET(INCLUDEDIR_NAME include)
SET(LIBDIR_NAME lib)
SET(DOCDIR_NAME doxygen)

# Set some install directories variables
GET_FILENAME_COMPONENT(installdir ${CMAKE_INSTALL_PREFIX} ABSOLUTE)
GET_FILENAME_COMPONENT(libdir ${CMAKE_INSTALL_PREFIX}/${LIBDIR_NAME} ABSOLUTE)
GET_FILENAME_COMPONENT(includedir ${CMAKE_INSTALL_PREFIX}/${INCLUDEDIR_NAME} ABSOLUTE)
GET_FILENAME_COMPONENT(docdir ${CMAKE_INSTALL_PREFIX}/${DOCDIR_NAME} ABSOLUTE)
GET_FILENAME_COMPONENT(bindir ${CMAKE_INSTALL_PREFIX}/${BINDIR_NAME} ABSOLUTE)
GET_FILENAME_COMPONENT(sharedir ${CMAKE_INSTALL_PREFIX}/${SHAREDIR_NAME} ABSOLUTE)
GET_FILENAME_COMPONENT(sbindir ${CMAKE_INSTALL_PREFIX}/${SBINDIR_NAME} ABSOLUTE)
GET_FILENAME_COMPONENT(ddbdir ${CMAKE_INSTALL_PREFIX}/${DDBDIR_NAME} ABSOLUTE)

# Use of OMC
GET_FILENAME_COMPONENT(INSTALL_OPENMODELICA ${INSTALL_OPENMODELICA} ABSOLUTE)
SET(OMC_INCLUDE_DIR ${INSTALL_OPENMODELICA}/include/omc/c)
SET(OPENMODELICA_VERSION "1_13_2" CACHE STRING "Version of OpenModelica")

# If C++11 is enabled, check flags availability
SET(CXX11_ENABLED ON CACHE BOOL "")

IF(MSVC)
  ADD_DEFINITIONS(-D_CRT_SECURE_NO_WARNINGS -D_SCL_SECURE_NO_WARNINGS -D_WIN32_WINNT=0x0601)
  ADD_DEFINITIONS(-DLANG_CXX11)

  SET(CMAKE_PREFIX_PATH ${DYNAWO_THIRD_PARTY_DIR}/dlfcnwin32)

  FIND_PACKAGE(dlfcn-win32 REQUIRED)
  SET(CMAKE_DL_LIBS dlfcn-win32::dl)
  if(LIBRARY_TYPE STREQUAL "STATIC")
    if(MSVC_STATIC_RUNTIME_LIBRARY)
      set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    endif()
  endif()

ELSEIF(CXX11_ENABLED)
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

SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${DYNAWO_DEBUG_COMPILER_OPTION}")

SET(CMAKE_DYN_DICTIONARY_PATHS "$ENV{DYN_DICTIONARY_PATHS}")

# Add specific options for gcc 4.8
IF('${CMAKE_CXX_COMPILER_ID}' STREQUAL 'GNU')
  # See all warnings in Debug mode
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall -Wextra -Werror -fdiagnostics-show-option -Wno-unused-local-typedefs")
  # -Wswitch-enum : Warn whenever a switch statement has an index of enumerated type and lacks a case for one or more of the named codes of that enumeration
  SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wswitch-enum -Wunused")
ELSEIF('${CMAKE_CXX_COMPILER_ID}' STREQUAL 'Clang' OR '${CMAKE_CXX_COMPILER_ID}' STREQUAL 'AppleClang')
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

# Python Interpreter
FIND_PACKAGE(PythonInterp REQUIRED)
IF (DEFINED DYNAWO_PYTHON_COMMAND AND NOT DYNAWO_PYTHON_COMMAND STREQUAL "")
  SET(PYTHON_EXECUTABLE ${DYNAWO_PYTHON_COMMAND})
  SEPARATE_ARGUMENTS(PYTHON_EXECUTABLE)
ENDIF()
MESSAGE(STATUS "Python command used: ${PYTHON_EXECUTABLE}")

# Boost
IF(BOOST_ROOT_DEFAULT STREQUAL "true")
  SET(Boost_NO_SYSTEM_PATHS FALSE)
ELSE()
  SET(Boost_NO_SYSTEM_PATHS TRUE)
ENDIF()

IF(BOOST_USE_STATIC)
  SET(Boost_USE_STATIC_LIBS TRUE)
ELSE()
  ADD_DEFINITIONS(-DBOOST_ALL_DYN_LINK)
ENDIF()
# Tell BOOST to disable auto linking
ADD_DEFINITIONS(-DBOOST_ALL_NO_LIB)

IF(CMAKE_BUILD_TYPE STREQUAL "Tests" OR CMAKE_BUILD_TYPE STREQUAL "TestCoverage")
  FIND_PACKAGE(Boost 1.64 REQUIRED
          COMPONENTS
          filesystem
          program_options
          serialization
          system
          log
          log_setup
          iostreams
          )
ELSE()
  FIND_PACKAGE(Boost 1.64 REQUIRED
          COMPONENTS
          filesystem
          program_options
          serialization
          system
          log
          log_setup
          )
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

  if(NOT TARGET GTest::gtest AND TARGET GTest::GTest)
    add_library(GTest::gtest UNKNOWN IMPORTED)
    if(EXISTS "${GTEST_LIBRARY}")
      set_target_properties(GTest::gtest PROPERTIES
              IMPORTED_LOCATION "${GTEST_LIBRARY}")
    endif()
  endif()
  if(NOT TARGET GTest::gtest_main AND TARGET GTest::Main)
    add_library(GTest::gtest_main UNKNOWN IMPORTED)
    if(EXISTS "${GTEST_MAIN_LIBRARY}")
      set_target_properties(GTest::gtest_main PROPERTIES
              IMPORTED_LOCATION "${GTEST_MAIN_LIBRARY}")
    endif()
  endif()
  FIND_PACKAGE(GMock REQUIRED)

  ADD_LIBRARY(dynawo_Test INTERFACE)
  TARGET_LINK_LIBRARIES(dynawo_Test INTERFACE
          GTest::gmock_main
          GTest::gtest_main
          Boost::iostreams)
ENDIF()

# For compatibility with old makefiles
ADD_DEFINITIONS(-D_DYNAWO_)

# For ADEPT
SET(USE_ADEPT ON CACHE BOOL "")
IF(USE_ADEPT)
  FIND_PACKAGE(Adept REQUIRED)
ENDIF(USE_ADEPT)

# Transitive dependencies
FIND_PACKAGE(XercesC 3.2.2 REQUIRED)

if(MSVC)
  set(CMAKE_FIND_LIBRARY_SUFFIXES_bak "${CMAKE_FIND_LIBRARY_SUFFIXES}")
  if(LIBRARY_TYPE STREQUAL "STATIC")
    set(CMAKE_FIND_LIBRARY_SUFFIXES "_static${CMAKE_FIND_LIBRARY_SUFFIXES_bak}")
  endif()
endif()
FIND_PACKAGE(LibArchive 2.8.0 REQUIRED)

if(MSVC)
  if(LIBRARY_TYPE STREQUAL "STATIC")
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
      set(CMAKE_FIND_LIBRARY_SUFFIXES "staticd${CMAKE_FIND_LIBRARY_SUFFIXES_bak}")
    else()
      set(CMAKE_FIND_LIBRARY_SUFFIXES "static${CMAKE_FIND_LIBRARY_SUFFIXES_bak}")
    endif()
  endif()
endif()

FIND_PACKAGE(ZLIB 1.2.3 REQUIRED)
if(MSVC)
  SET(CMAKE_FIND_LIBRARY_SUFFIXES "${CMAKE_FIND_LIBRARY_SUFFIXES_bak}")
endif()

# SUITESPARSE
FIND_PACKAGE(SuiteSparse REQUIRED)

# NICSLU
FIND_PACKAGE(NICSLU)

IF(${NICSLU_FOUND})
  ADD_DEFINITIONS(-DWITH_NICSLU)
ENDIF()

# Sundials
FIND_PACKAGE(Sundials REQUIRED)

#libZIP
FIND_PACKAGE(libZIP 1.3.0 REQUIRED)

IF(LIBRARY_TYPE STREQUAL "STATIC")
  SET(LibXML_USE_STATIC_LIBS TRUE)
ENDIF()

# libXML
FIND_PACKAGE(libXML 0.2.4 REQUIRED PATHS ${LIBXML_HOME})

# libIIDM
FIND_PACKAGE(libIIDM 0.2.8 REQUIRED PATHS ${LIBIIDM_HOME}
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

#
# Target used to ensure that ddbdir directory is created
#
ADD_CUSTOM_TARGET(CREATE_DDBDIR
  COMMAND ${CMAKE_COMMAND} -E make_directory ${ddbdir}
  )

IF(MSVC)
  SET(runtime_PATH "PATH=${ADEPT_HOME}/bin;${Boost_LIBRARY_DIR_DEBUG};${Boost_LIBRARY_DIR_RELEASE};${dlfcn-win32_INCLUDE_DIRS}/../bin;${INSTALL_OPENMODELICA}/bin;${SUITESPARSE_HOME}/bin;${SUNDIALS_HOME}/lib;${XercesC_INCLUDE_DIRS}/../bin;${LibIIDM_BIN_DIR};${LibXML_BIN_DIR};${libdir};$ENV{PATH}")
  if(CMAKE_BUILD_TYPE STREQUAL "Tests" OR CMAKE_BUILD_TYPE STREQUAL "TestCoverage")
    SET(runtime_tests_PATH "PATH=${GTEST_ROOT}/bin;${ADEPT_HOME}/bin;${Boost_LIBRARY_DIR_DEBUG};${Boost_LIBRARY_DIR_RELEASE};${dlfcn-win32_INCLUDE_DIRS}/../bin;${INSTALL_OPENMODELICA}/bin;${SUITESPARSE_HOME}/bin;${SUNDIALS_HOME}/lib;${XercesC_INCLUDE_DIRS}/../bin;${LibIIDM_BIN_DIR};${LibXML_BIN_DIR};${libdir};$ENV{PATH}")
  endif()
ELSEIF(APPLE)
  SET(CMAKE_MACOSX_RPATH True)

  # use, i.e. don't skip the full RPATH for the build tree
  SET(CMAKE_SKIP_BUILD_RPATH False)

  # when building, don't use the install RPATH already
  # (but later on when installing)
  SET(CMAKE_BUILD_WITH_INSTALL_RPATH False)

  SET(CMAKE_INSTALL_RPATH "${INSTALL_PREFIX}/lib")

  # add the automatically determined parts of the RPATH
  # which point to directories outside the build tree to the install RPATH
  SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH True)

ELSE() # Linux
  SET(runtime_LD_LIBRARY_PATH "LD_LIBRARY_PATH=${ADEPT_HOME}/lib:${Boost_LIBRARY_DIR_DEBUG}:${Boost_LIBRARY_DIR_RELEASE}:${SUITESPARSE_HOME}/lib:${SUNDIALS_HOME}/lib64:${XercesC_INCLUDE_DIRS}/../lib:${LibIIDM_LIB_DIR}:${LibXML_LIB_DIR}:${libdir}:$ENV{LD_LIBRARY_PATH}")
  SET(runtime_PATH "PATH=${INSTALL_OPENMODELICA}/bin:$ENV{PATH}")
ENDIF()

INCLUDE(../cpplint/cpplint.cmake)
INCLUDE(3rdParty/jquery/jquery.cmake)

ADD_SUBDIRECTORY(sources)
ADD_SUBDIRECTORY(sources/Common)
ADD_SUBDIRECTORY(sources/API)
ADD_SUBDIRECTORY(sources/Solvers)
ADD_SUBDIRECTORY(sources/Modeler)
ADD_SUBDIRECTORY(sources/Simulation)
ADD_SUBDIRECTORY(sources/Launcher)
ADD_SUBDIRECTORY(sources/ModelicaCompiler)
ADD_SUBDIRECTORY(sources/Models)
ADD_SUBDIRECTORY(doxygen)

install(EXPORT dynawo-targets
  NAMESPACE Dynawo::
  FILE dynawo-config.cmake
  DESTINATION ${SHAREDIR_NAME}
  )

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/dynawo-config-version.cmake
  VERSION ${DYNAWO_VERSION_STRING}
  COMPATIBILITY AnyNewerVersion
)

install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/dynawo-config-version.cmake
  DESTINATION ${SHAREDIR_NAME}
)

INSTALL(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindAdept.cmake DESTINATION ${SHAREDIR_NAME}/cmake)
INSTALL(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindLibArchive.cmake DESTINATION ${SHAREDIR_NAME}/cmake)
INSTALL(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindXercesC.cmake DESTINATION ${SHAREDIR_NAME}/cmake)
INSTALL(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindSuiteSparse.cmake DESTINATION ${SHAREDIR_NAME}/cmake)
INSTALL(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindNICSLU.cmake DESTINATION ${SHAREDIR_NAME}/cmake)
INSTALL(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindSundials.cmake DESTINATION ${SHAREDIR_NAME}/cmake)
INSTALL(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindlibZIP.cmake DESTINATION ${SHAREDIR_NAME}/cmake)

if(MSVC)
  if(CMAKE_BUILD_TYPE STREQUAL "Tests" OR CMAKE_BUILD_TYPE STREQUAL "TestCoverage")
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel (CMake defaults)" FORCE)
  endif()
endif()
