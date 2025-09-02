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

option(BUILD_TESTS "Choose to build the unit tests")
option(BUILD_TESTS_COVERAGE "Choose to build tests coverage")

# IO interfaces for interactive dynawo
option(USE_ZMQPP "Link ZMQPP library" OFF)

# Add custom cmake modules to the path
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel (CMake defaults)")
set(FORCE_CXX11_ABI OFF CACHE BOOL "Choose either ON or OFF.")

# Project Dynawo
project(dynawo)
set(DYNAWO_VERSION_MAJOR 1)
set(DYNAWO_VERSION_MINOR 8)
set(DYNAWO_VERSION_PATCH 0)
set(DYNAWO_VERSION_STRING ${DYNAWO_VERSION_MAJOR}.${DYNAWO_VERSION_MINOR}.${DYNAWO_VERSION_PATCH})

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)    # export all symbols from dll on Windows
set(CMAKE_ENABLE_EXPORTS ON)                # export all symbols from exe on Windows
set(CMAKE_POSITION_INDEPENDENT_CODE ON)     # set -fPIC on Linux

get_filename_component(DYNAWO_HOME ${DYNAWO_HOME} ABSOLUTE)

# Set directories name
set(BINDIR_NAME bin)
set(SHAREDIR_NAME share)
set(SBINDIR_NAME sbin)
set(DDBDIR_NAME ddb)
set(INCLUDEDIR_NAME include)
if(MSVC)
  set(LIBDIR_NAME ${BINDIR_NAME})
else()
  set(LIBDIR_NAME lib)
endif()
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

if(MSVC)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS -D_SCL_SECURE_NO_WARNINGS -D_WIN32_WINNT=0x0601)
else()
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
  if(FORCE_CXX11_ABI)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_GLIBCXX_USE_CXX11_ABI=1")
  endif()
endif()

set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${DYNAWO_DEBUG_COMPILER_OPTION}")

set(CMAKE_DYN_DICTIONARY_PATHS "$ENV{DYN_DICTIONARY_PATHS}")

# Add specific options for gcc 4.8
if('${CMAKE_CXX_COMPILER_ID}' STREQUAL 'GNU')
  # See all warnings in Debug mode
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall -Wextra -Werror -fdiagnostics-show-option -Wno-unused-local-typedefs")
  # -Wswitch-enum : Warn whenever a switch statement has an index of enumerated type and lacks a case for one or more of the named codes of that enumeration
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wswitch-enum -Wunused")
elseif('${CMAKE_CXX_COMPILER_ID}' STREQUAL 'Clang')
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Weverything")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-covered-switch-default")
  # error: unknown command tag name [-Werror,-Wdocumentation-unknown-command]
  # => used command tag names (@copydoc and @n) are legal !
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-documentation-unknown-command")
  # error: declaration requires an exit-time destructor [-Werror,-Wexit-time-destructors]
  # => occurs with static objects, including singleton implementations
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-exit-time-destructors")
  # error: padding class 'DYN::Message' with 7 bytes to align 'key_' [-Werror,-Wpadded]
  # error: padding size of 'DYN::ParameterCommon' with 3 bytes to alignment boundary [-Werror,-Wpadded]
  # => it's better to let compiler generate correct padding
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-padded")
  # error: implicit conversion changes signedness: 'something signed' to 'something unsigned' [-Werror,-Wsign-conversion]
  # error: operand of ? changes signedness: 'something unsigned' to 'something signed' [-Werror,-Wsign-conversion]
  # => occurs many times in particular when a signed value is used as an index which must be an unsigned (size_t) !
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-sign-conversion")
  # error: 'arg2' was marked unused but was used [-Werror,-Wused-but-marked-unused]
  # => occurs in all API Xml handlers (using boost::phoenix::placeholders)
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-used-but-marked-unused")
  # error: zero as null pointer constant [-Werror,-Wzero-as-null-pointer-constant]
  # => caused by NULL macro use in many places (mandatory with c++98, should be replaced by nullptr with c++11)
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-zero-as-null-pointer-constant")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Werror")
  # -Wno-c++98-compat shall be kept to allow c++11 code !
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-c++98-compat")
  if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 14)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-return-std-move-in-c++11")
  endif()
  if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 14)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-deprecated-declarations")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wno-reserved-identifier")
  endif()
endif()

if(DEFINED DYNAWO_THIRD_PARTY_DIR)
  get_filename_component(DYNAWO_THIRD_PARTY_DIR ${DYNAWO_THIRD_PARTY_DIR} ABSOLUTE)
  set(ADEPT_HOME ${DYNAWO_THIRD_PARTY_DIR}/adept CACHE PATH "Path where an Adept installation already exists")
  set(SUITESPARSE_HOME ${DYNAWO_THIRD_PARTY_DIR}/suitesparse CACHE PATH "Path where an SuiteSparse installation already exists")
  set(SUNDIALS_HOME ${DYNAWO_THIRD_PARTY_DIR}/sundials CACHE PATH "Path where an Sundials installation already exists")
  set(LIBZIP_HOME ${DYNAWO_THIRD_PARTY_DIR}/libzip CACHE PATH "Path where an libzip installation already exists")
  set(LIBXML_HOME ${DYNAWO_THIRD_PARTY_DIR}/libxml CACHE PATH "Path where an libxml installation already exists")
  set(LIBIIDM_HOME ${DYNAWO_THIRD_PARTY_DIR}/libiidm CACHE PATH "Path where an libiidm installation already exists")
  set(BOOST_ROOT ${DYNAWO_THIRD_PARTY_DIR}/boost CACHE PATH "Path where a Boost installation already exists")
  if(MSVC)
    set(BOOST_LIBRARYDIR ${DYNAWO_THIRD_PARTY_DIR}/boost/bin CACHE PATH "Path where a Boost lib installation already exists")
  endif()
  set(GTEST_ROOT ${DYNAWO_THIRD_PARTY_DIR}/googletest CACHE PATH "Path where a GoogleTest installation already exists")
  set(GMOCK_HOME ${DYNAWO_THIRD_PARTY_DIR}/googletest CACHE PATH "Path where a GoogleTest installation already exists")
  set(LIBARCHIVE_HOME ${DYNAWO_THIRD_PARTY_DIR}/libarchive CACHE PATH "Path where a LibArchive installation already exists")
  set(ZLIB_ROOT ${DYNAWO_THIRD_PARTY_DIR}/zlib CACHE PATH "Path where a ZLib installation already exists")
  set(XERCESC_HOME ${DYNAWO_THIRD_PARTY_DIR}/xerces-c CACHE PATH "Path where a Xerces-c installation already exists")
  set(LIBXML2_HOME ${DYNAWO_THIRD_PARTY_DIR}/libxml2 CACHE PATH "Path where libxml2 installation already exists")
endif()

list(APPEND CMAKE_PREFIX_PATH "${LIBXML2_HOME}")

if (DEFINED ZMQPP_HOME)
  list(APPEND CMAKE_PREFIX_PATH "${ZMQPP_HOME}")
endif()

if (DEFINED WEBSOCKETPP_HOME)
  list(APPEND CMAKE_PREFIX_PATH "${WEBSOCKETPP_HOME}")
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

set(BUILD_SHARED_LIBS ON)
set(Boost_USE_STATIC_RUNTIME False)
add_definitions(-DBOOST_ALL_DYN_LINK)
# Tell BOOST to disable auto linking
add_definitions(-DBOOST_ALL_NO_LIB)

set(Boost_RequiredVersion  "1.70")

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
          thread
          regex
          chrono
          atomic
          date_time
          )
else()
  find_package(Boost "${Boost_RequiredVersion}" REQUIRED
    COMPONENTS filesystem program_options serialization system log log_setup thread regex chrono atomic date_time
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
    if(EXISTS "${GTEST_LIBRARY_DEBUG}")
      set_target_properties(GTest::gtest PROPERTIES
              IMPORTED_LOCATION "${GTEST_LIBRARY_DEBUG}")
    elseif(EXISTS "${GTEST_LIBRARY}")
      set_target_properties(GTest::gtest PROPERTIES
        IMPORTED_LOCATION "${GTEST_LIBRARY}")
    endif()
  endif()
  if(NOT TARGET GTest::gtest_main AND TARGET GTest::Main)
    add_library(GTest::gtest_main UNKNOWN IMPORTED)
    if(EXISTS "${GTEST_MAIN_LIBRARY_DEBUG}")
      set_target_properties(GTest::gtest_main PROPERTIES
              IMPORTED_LOCATION "${GTEST_MAIN_LIBRARY_DEBUG}")
    elseif(EXISTS "${GTEST_MAIN_LIBRARY}")
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
endif()
find_package(ZLIB 1.2.3 REQUIRED)
set_property(TARGET ZLIB::ZLIB APPEND PROPERTY IMPORTED_LOCATION "${ZLIB_LIBRARY}")

find_package(LibArchive 2.8.0 REQUIRED)
if(MSVC)
  set(CMAKE_FIND_LIBRARY_SUFFIXES "${CMAKE_FIND_LIBRARY_SUFFIXES_bak}")
endif()

# SUITESPARSE
find_package(SuiteSparse REQUIRED)

# Sundials
find_package(Sundials REQUIRED)

#libZIP
find_package(libZIP 1.3.0 REQUIRED)

# libXML
find_package(libXML 0.2.4 REQUIRED PATHS ${LIBXML_HOME})

# libIIDM

set(DYNAWO_USE_LIBXML2 "Y")
find_package(LibXml2 "2.9" REQUIRED)
find_package(LibIIDM "1.5.1" REQUIRED PATHS ${LIBIIDM_HOME})

# Interactive mode interfaces
if(USE_ZMQPP)
    find_package(ZMQPP QUIET)
    if(ZMQPP_FOUND)
        add_definitions(-DUSE_ZMQPP)
    else()
        message("USE_ZMQPP not found. Disabling support.")
        set(USE_ZMQPP OFF)
    endif()
endif()

# find_package(websocketpp REQUIRED)

if(MSVC)
  set(runtime_PATH "PATH=${ADEPT_HOME}/bin;${Boost_INCLUDE_DIR}/../bin;${INSTALL_OPENMODELICA}/bin;${SUITESPARSE_HOME}/bin;${SUNDIALS_HOME}/bin;${XercesC_INCLUDE_DIRS}/../bin;${LibIIDM_BIN_DIR};${LIBIIDM_HOME}/bin;${LibXML_BIN_DIR};${LIBXML2_HOME}/bin;${libdir};$ENV{PATH}")
  if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
    set(runtime_tests_PATH "PATH=${GTEST_ROOT}/bin;${ADEPT_HOME}/bin;${Boost_INCLUDE_DIR}/../bin;${INSTALL_OPENMODELICA}/bin;${SUITESPARSE_HOME}/bin;${SUNDIALS_HOME}/bin;${XercesC_INCLUDE_DIRS}/../bin;${LibIIDM_BIN_DIR};${LIBIIDM_HOME}/bin;${LibXML_BIN_DIR};${libdir};$ENV{PATH}")
  endif()
else() # Linux
  set(runtime_LD_LIBRARY_PATH "LD_LIBRARY_PATH=\"${ADEPT_HOME}/lib:${SUITESPARSE_HOME}/lib:${SUNDIALS_HOME}/lib64:${SUNDIALS_HOME}/lib:${XercesC_INCLUDE_DIRS}/../lib:${LibIIDM_LIB_DIR}:${LIBIIDM_HOME}/lib:${LibXML_LIB_DIR}:${libdir}:${Boost_INCLUDE_DIR}/../lib:${LIBXML2_HOME}/lib:$ENV{LD_LIBRARY_PATH}\"")
  set(runtime_PATH "PATH=\"${INSTALL_OPENMODELICA}/bin:$ENV{PATH}\"")
  if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
    set(runtime_tests_PATH "LD_LIBRARY_PATH=${GTEST_ROOT}/lib:${ADEPT_HOME}/lib:${SUITESPARSE_HOME}/lib:${SUNDIALS_HOME}/lib64:${SUNDIALS_HOME}/lib:${XercesC_INCLUDE_DIRS}/../lib:${LibIIDM_LIB_DIR}:${LIBIIDM_HOME}/lib:${LibXML_LIB_DIR}:${libdir}:${Boost_INCLUDE_DIR}/../lib:${LIBXML2_HOME}/lib:$ENV{LD_LIBRARY_PATH}")
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
add_subdirectory(sources/Models M)
add_subdirectory(sources/RT)
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
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindSundials.cmake DESTINATION ${SHAREDIR_NAME}/cmake)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindlibZIP.cmake DESTINATION ${SHAREDIR_NAME}/cmake)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindZMQPP.cmake DESTINATION ${SHAREDIR_NAME}/cmake)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/CPUCount.cmake DESTINATION ${SHAREDIR_NAME}/cmake)

if(MSVC)
  install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../util/curvesToHtml DESTINATION ${SBINDIR_NAME})
endif()

if(MSVC)
  if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel (CMake defaults)" FORCE)
  endif()
endif()
