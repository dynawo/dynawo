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
cmake_minimum_required(VERSION 3.9.6 FATAL_ERROR)

if(POLICY CMP0074)
  cmake_policy(SET CMP0074 NEW)
endif()

if(${CMAKE_VERSION} VERSION_GREATER "3.15.0")
  if(POLICY CMP0091)
    cmake_policy(SET CMP0091 NEW)
  endif()
endif()

option(BUILD_TESTS "Choose to build the unit tests")
option(BUILD_TESTS_COVERAGE "Choose to build tests coverage")

# Add custom cmake modules to the path
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel (CMake defaults)")
set(LIBRARY_TYPE SHARED CACHE STRING "Choose either STATIC or SHARED.")
set(BOOST_USE_STATIC OFF CACHE BOOL "Choose either ON or OFF.")
set(MSVC_STATIC_RUNTIME_LIBRARY OFF CACHE BOOL "Choose either ON or OFF.")
set(FORCE_CXX11_ABI OFF CACHE BOOL "Choose either ON or OFF.")

# Project Dynawo
project(dynawo)
set(DYNAWO_VERSION_MAJOR 1)
set(DYNAWO_VERSION_MINOR 3)
set(DYNAWO_VERSION_PATCH 0)
set(DYNAWO_VERSION_STRING ${DYNAWO_VERSION_MAJOR}.${DYNAWO_VERSION_MINOR}.${DYNAWO_VERSION_PATCH})

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)    # export all symbols from dll on Windows
set(CMAKE_ENABLE_EXPORTS ON)                # export all symbols from exe on Windows
set(CMAKE_POSITION_INDEPENDENT_CODE ON)     # set -fPIC on Linux

if(DEFINED DYNAWO_THIRD_PARTY_DIR)
  get_filename_component(DYNAWO_THIRD_PARTY_DIR ${DYNAWO_THIRD_PARTY_DIR} ABSOLUTE)
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
  set(NICSLU_HOME ${DYNAWO_THIRD_PARTY_DIR}/nicslu CACHE PATH "Path where a Nicslu installation already exists")
  set(LIBXML2_HOME ${DYNAWO_THIRD_PARTY_DIR}/libxml2 CACHE PATH "Path where libxml2 installation already exists")
endif()

get_filename_component(DYNAWO_HOME ${DYNAWO_HOME} ABSOLUTE)

# Set directories name
set(BINDIR_NAME bin)
set(SHAREDIR_NAME share)
set(SBINDIR_NAME sbin)
set(DDBDIR_NAME ddb)
set(INCLUDEDIR_NAME include)
set(LIBDIR_NAME lib)
set(DOCDIR_NAME doxygen)

# Set some install directories variables
get_filename_component(installdir ${CMAKE_INSTALL_PREFIX} ABSOLUTE)
get_filename_component(libdir ${CMAKE_INSTALL_PREFIX}/${LIBDIR_NAME} ABSOLUTE)
get_filename_component(includedir ${CMAKE_INSTALL_PREFIX}/${INCLUDEDIR_NAME} ABSOLUTE)
get_filename_component(docdir ${CMAKE_INSTALL_PREFIX}/${DOCDIR_NAME} ABSOLUTE)
get_filename_component(bindir ${CMAKE_INSTALL_PREFIX}/${BINDIR_NAME} ABSOLUTE)
get_filename_component(sharedir ${CMAKE_INSTALL_PREFIX}/${SHAREDIR_NAME} ABSOLUTE)
get_filename_component(sbindir ${CMAKE_INSTALL_PREFIX}/${SBINDIR_NAME} ABSOLUTE)
get_filename_component(ddbdir ${CMAKE_INSTALL_PREFIX}/${DDBDIR_NAME} ABSOLUTE)

# Use of OMC
get_filename_component(INSTALL_OPENMODELICA ${INSTALL_OPENMODELICA} ABSOLUTE)
set(OMC_INCLUDE_DIR ${INSTALL_OPENMODELICA}/include/omc/c)
set(OPENMODELICA_VERSION "1_13_2" CACHE STRING "Version of OpenModelica")

# If C++11 is enabled, check flags availability
set(CXX11_ENABLED ON CACHE BOOL "")

list(APPEND CMAKE_PREFIX_PATH "${LIBXML2_HOME}")

if(MSVC)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS -D_SCL_SECURE_NO_WARNINGS -D_WIN32_WINNT=0x0601)
  add_definitions(-DLANG_CXX11)

  list(APPEND CMAKE_PREFIX_PATH "${DYNAWO_THIRD_PARTY_DIR}/dlfcnwin32")

  find_package(dlfcn-win32 REQUIRED)
  set(CMAKE_DL_LIBS dlfcn-win32::dl)
  if(LIBRARY_TYPE STREQUAL "STATIC")
    if(MSVC_STATIC_RUNTIME_LIBRARY)
      set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    endif()
  endif()

elseif(CXX11_ENABLED)
  # Test if a C++11 flag is supported
  include(CheckCXXCompilerFlag)
  check_cxx_compiler_flag("-std=c++11" COMPILER_SUPPORTS_CXX11)
  check_cxx_compiler_flag("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
  if(COMPILER_SUPPORTS_CXX11)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -DLANG_CXX11")
    if(FORCE_CXX11_ABI)
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_GLIBCXX_USE_CXX11_ABI=1")
    endif()
  elseif(COMPILER_SUPPORTS_CXX0X)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x -DLANG_CXX0X")
  else()
    message(STATUS "The compiler ${CMAKE_CXX_COMPILER} has no C++11 support. Disabling C++11.")
  endif()
else()
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++98")
endif()

set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${DYNAWO_DEBUG_COMPILER_OPTION}")

set(CMAKE_DYN_DICTIONARY_PATHS "$ENV{DYN_DICTIONARY_PATHS}")

# Add specific options for gcc 4.8
if('${CMAKE_CXX_COMPILER_ID}' STREQUAL 'GNU')
  # See all warnings in Debug mode
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall -Wextra -Werror -fdiagnostics-show-option -Wno-unused-local-typedefs")
  # -Wswitch-enum : Warn whenever a switch statement has an index of enumerated type and lacks a case for one or more of the named codes of that enumeration
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wswitch-enum -Wunused")
elseif('${CMAKE_CXX_COMPILER_ID}' STREQUAL 'Clang' OR '${CMAKE_CXX_COMPILER_ID}')
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Weverything")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-conditional-uninitialized")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-conversion")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-covered-switch-default")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-documentation")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-documentation-unknown-command")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-double-promotion")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-exit-time-destructors")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-extra-semi")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-float-conversion")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-float-equal")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-global-constructors")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-gnu-zero-variadic-macro-arguments")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-mismatched-tags")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-missing-noreturn")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-missing-prototypes")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-missing-variable-declarations")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-old-style-cast")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-padded")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-reserved-id-macro")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-return-type")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-shadow")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-shorten-64-to-32")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-sign-conversion")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-sometimes-uninitialized")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-undef")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-undefined-func-template")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-unreachable-code-break")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-unreachable-code-loop-increment")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-unreachable-code-return")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-unused-exception-parameter")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-unused-macros")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-unused-private-field")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-weak-vtables")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-used-but-marked-unused")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-overloaded-virtual")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-zero-as-null-pointer-constant")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Werror")
  if(CXX11_ENABLED)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-c++98-compat")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-c++98-compat-local-type-template-args")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-c++98-compat-pedantic")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-deprecated")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-return-std-move-in-c++11")
  else()
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-pedantic")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-variadic-macros")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-c++11-extensions")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-c++11-long-long")
  endif()
endif()

# Python Interpreter
find_package(PythonInterp REQUIRED)
if (DEFINED DYNAWO_PYTHON_COMMAND AND NOT DYNAWO_PYTHON_COMMAND STREQUAL "")
  set(PYTHON_EXECUTABLE ${DYNAWO_PYTHON_COMMAND})
  separate_arguments(PYTHON_EXECUTABLE)
endif()
message(STATUS "Python command used: ${PYTHON_EXECUTABLE}")

# Boost
if(BOOST_ROOT_DEFAULT STREQUAL "true")
  set(Boost_NO_SYSTEM_PATHS FALSE)
else()
  set(Boost_NO_SYSTEM_PATHS TRUE)
endif()

if(BOOST_USE_STATIC)
  set(Boost_USE_STATIC_LIBS TRUE)
  if(MSVC_STATIC_RUNTIME_LIBRARY)
    set(Boost_USE_STATIC_RUNTIME True)
  else()
    set(Boost_USE_STATIC_RUNTIME False)
  endif()
else()
  set(BUILD_SHARED_LIBS ON)
  set(Boost_USE_STATIC_RUNTIME False)
  add_definitions(-DBOOST_ALL_DYN_LINK)
endif()
# Tell BOOST to disable auto linking
add_definitions(-DBOOST_ALL_NO_LIB)

if(CXX11_ENABLED)
  set(Boost_RequiredVersion  "1.70")
else()
  set(Boost_RequiredVersion  "1.64")
endif()

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  find_package(Boost "${Boost_RequiredVersion}" REQUIRED
          COMPONENTS
          filesystem
          program_options
          serialization
          system
          log
          log_setup
          iostreams
          )
else()
  find_package(Boost "${Boost_RequiredVersion}" REQUIRED
    COMPONENTS filesystem program_options serialization system log log_setup
  )
endif()

if(BUILD_TESTS_COVERAGE)
  include(TestCoverage)
endif()

if(BUILD_TESTS)
  include(UnitTest)
endif()

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  find_package(GTest REQUIRED)

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
  find_package(GMock REQUIRED)

  add_library(dynawo_Test INTERFACE)
  target_link_libraries(dynawo_Test INTERFACE
    dynawo_Common
    dynawo_Test_utils
    GTest::gmock_main
    GTest::gtest_main
    Boost::iostreams
    Boost::filesystem)
endif()

# For compatibility with old makefiles
add_definitions(-D_DYNAWO_)

# For ADEPT
set(USE_ADEPT ON CACHE BOOL "")
if(USE_ADEPT)
  find_package(Adept REQUIRED)
endif(USE_ADEPT)

# Transitive dependencies
find_package(XercesC 3.2.2 REQUIRED)

if(MSVC)
  set(CMAKE_FIND_LIBRARY_SUFFIXES_bak "${CMAKE_FIND_LIBRARY_SUFFIXES}")
  if(LIBRARY_TYPE STREQUAL "STATIC")
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
      set(CMAKE_FIND_LIBRARY_SUFFIXES "staticd${CMAKE_FIND_LIBRARY_SUFFIXES_bak}")
    else()
      set(CMAKE_FIND_LIBRARY_SUFFIXES "static${CMAKE_FIND_LIBRARY_SUFFIXES_bak}")
    endif()
  endif()
endif()
find_package(ZLIB 1.2.3 REQUIRED)
set_property(TARGET ZLIB::ZLIB APPEND PROPERTY IMPORTED_LOCATION "${ZLIB_LIBRARY}")

if(MSVC)
  if(LIBRARY_TYPE STREQUAL "STATIC")
    set(CMAKE_FIND_LIBRARY_SUFFIXES "_static${CMAKE_FIND_LIBRARY_SUFFIXES_bak}")
  endif()
endif()
find_package(LibArchive 2.8.0 REQUIRED)
if(MSVC)
  set(CMAKE_FIND_LIBRARY_SUFFIXES "${CMAKE_FIND_LIBRARY_SUFFIXES_bak}")
endif()

# SUITESPARSE
find_package(SuiteSparse REQUIRED)

# NICSLU
find_package(NICSLU)

if(${NICSLU_FOUND})
  add_definitions(-DWITH_NICSLU)
endif()

# Sundials
find_package(Sundials REQUIRED)

#libZIP
find_package(libZIP 1.3.0 REQUIRED)

if(LIBRARY_TYPE STREQUAL "STATIC")
  set(LibXML_USE_STATIC_LIBS TRUE)
endif()

# libXML
find_package(libXML 0.2.4 REQUIRED PATHS ${LIBXML_HOME})

# libIIDM

if(CXX11_ENABLED)
  find_package(LibXml2 "2.9" REQUIRED)
  find_package(LibIIDM "1.4.0" REQUIRED PATHS ${LIBIIDM_HOME})
else()
  find_package(libIIDM "0.2.8" REQUIRED PATHS ${LIBIIDM_HOME}
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
endif()

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/sources/config.h.in ${CMAKE_CURRENT_SOURCE_DIR}/sources/config.h @ONLY)

#
# Target used to ensure that ddbdir directory is created
#
add_custom_target(CREATE_DDBDIR
  COMMAND ${CMAKE_COMMAND} -E make_directory ${ddbdir}
)

if(MSVC)
  set(runtime_PATH "PATH=${ADEPT_HOME}/bin;${Boost_INCLUDE_DIR}/../lib;${dlfcn-win32_INCLUDE_DIRS}/../bin;${INSTALL_OPENMODELICA}/bin;${SUITESPARSE_HOME}/bin;${SUNDIALS_HOME}/lib;${XercesC_INCLUDE_DIRS}/../bin;${LibIIDM_BIN_DIR};${LibXML_BIN_DIR};${LIBXML2_HOME}/bin;${libdir};$ENV{PATH}")
  if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
    set(runtime_tests_PATH "PATH=${GTEST_ROOT}/bin;${ADEPT_HOME}/bin;${Boost_INCLUDE_DIR}/../lib;${dlfcn-win32_INCLUDE_DIRS}/../bin;${INSTALL_OPENMODELICA}/bin;${SUITESPARSE_HOME}/bin;${SUNDIALS_HOME}/lib;${XercesC_INCLUDE_DIRS}/../bin;${LibIIDM_BIN_DIR};${LibXML_BIN_DIR};${libdir};$ENV{PATH}")
  endif()
else() # Linux
  set(runtime_LD_LIBRARY_PATH "LD_LIBRARY_PATH=${ADEPT_HOME}/lib:${SUITESPARSE_HOME}/lib:${SUNDIALS_HOME}/lib64:${SUNDIALS_HOME}/lib:${XercesC_INCLUDE_DIRS}/../lib:${LibIIDM_LIB_DIR}:${LibXML_LIB_DIR}:${libdir}:${Boost_INCLUDE_DIR}/../lib:${LIBXML2_HOME}/lib:$ENV{LD_LIBRARY_PATH}")
  set(runtime_PATH "PATH=${INSTALL_OPENMODELICA}/bin:$ENV{PATH}")
  if(CMAKE_BUILD_TYPE STREQUAL "Tests" OR CMAKE_BUILD_TYPE STREQUAL "TestCoverage")
    set(runtime_tests_PATH "LD_LIBRARY_PATH=${GTEST_ROOT}/lib:${ADEPT_HOME}/lib:${SUITESPARSE_HOME}/lib:${SUNDIALS_HOME}/lib64:${SUNDIALS_HOME}/lib:${XercesC_INCLUDE_DIRS}/../lib:${LibIIDM_LIB_DIR}:${LibXML_LIB_DIR}:${libdir}:${Boost_INCLUDE_DIR}/../lib:${LIBXML2_HOME}/lib:$ENV{LD_LIBRARY_PATH}")
  endif()
endif()

include(../cpplint/cpplint.cmake)
include(3rdParty/jquery/jquery.cmake)

add_subdirectory(sources)
add_subdirectory(sources/Common)
add_subdirectory(sources/API)
add_subdirectory(sources/Solvers)
add_subdirectory(sources/Modeler)
add_subdirectory(sources/Simulation)
add_subdirectory(sources/Launcher)
add_subdirectory(sources/ModelicaCompiler)
add_subdirectory(sources/Models)
add_subdirectory(doxygen)
if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(sources/Test)
endif()

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

install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindAdept.cmake DESTINATION ${SHAREDIR_NAME}/cmake)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindLibArchive.cmake DESTINATION ${SHAREDIR_NAME}/cmake)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindXercesC.cmake DESTINATION ${SHAREDIR_NAME}/cmake)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindSuiteSparse.cmake DESTINATION ${SHAREDIR_NAME}/cmake)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindNICSLU.cmake DESTINATION ${SHAREDIR_NAME}/cmake)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindSundials.cmake DESTINATION ${SHAREDIR_NAME}/cmake)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindlibZIP.cmake DESTINATION ${SHAREDIR_NAME}/cmake)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/CPUCount.cmake DESTINATION ${SHAREDIR_NAME}/cmake)

if(MSVC)
  if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel (CMake defaults)" FORCE)
  endif()
endif()
