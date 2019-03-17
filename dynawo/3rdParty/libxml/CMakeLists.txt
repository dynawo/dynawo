# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libxml, a library to handle XML files parsing.

cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)

# temporary only effectively supports g++ in versions starting 4.8.2.

SET(LIBXML_VERSION_MAJOR 0)
SET(LIBXML_VERSION_MINOR 2)
SET(LIBXML_VERSION_PATCH 4)

# Project options
option(LibXML_SAX_BUILD_FORMATTER "Set to OFF to disable XML SAX formatter build" ON)
option(LibXML_SAX_BUILD_PARSER "Set to OFF to disable XML SAX parser build" ON)

option(LibXML_BUILD_TESTS "Set to OFF to disable testings" ON)
option(LibXML_SAX_BUILD_SAMPLES "Set to OFF to disable XML SAX samples build" ON)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(LibXML_SAX_BUILD_SHARED TRUE CACHE BOOL "Build LibXML_SAX as shared library.")
set(LibXML_SAX_BUILD_STATIC TRUE CACHE BOOL "Build LibXML_SAX as static library.")

if(NOT LibXML_SAX_BUILD_SHARED AND NOT LibXML_SAX_BUILD_STATIC)
  message(FATAL_ERROR "At least one of LibXML_SAX_BUILD_SHARED and LibXML_SAX_BUILD_STATIC must be true")
endif()

set(CXX11_ENABLED OFF CACHE BOOL "activates the C++11 compilation")

set(CMAKE_BUILD_TYPE "RelWithDebInfo" CACHE STRING "Choose the type of build: Debug Release RelWithDebInfo MinSizeRel")

set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(LIBXML_VERSION "${LIBXML_VERSION_MAJOR}.${LIBXML_VERSION_MINOR}.${LIBXML_VERSION_PATCH}")

if(WIN32)
  set(LibXML_INSTALL_CMAKE cmake)
else()
  set(LibXML_INSTALL_CMAKE share/cmake/LibXML-${LIBXML_VERSION})
endif()

set(LibXML_INSTALL_LIBRARIES lib)
set(LibXML_INSTALL_BINARIES bin)
set(LibXML_INSTALL_INCLUDE include)

if (CXX11_ENABLED)
  # Test if a C++11 flag is supported
  include(CheckCXXCompilerFlag)
  check_cxx_compiler_flag("-std=c++14" COMPILER_SUPPORTS_CXX14)
  if(COMPILER_SUPPORTS_CXX14)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")
  else()
    check_cxx_compiler_flag("-std=c++11" COMPILER_SUPPORTS_CXX11)
    if(COMPILER_SUPPORTS_CXX11)
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
    else()
      check_cxx_compiler_flag("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
      if(COMPILER_SUPPORTS_CXX0X)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
      else()
        message(STATUS "The compiler ${CMAKE_CXX_COMPILER} has no C++11 support. Disabling C++11.")
      endif()
    endif()
  endif()
else()
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++98")
endif ()

# Add specific options for gcc
if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pedantic -Wall -Wextra")

  if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 4.8)
    message(STATUS "Use of GCC version greater than 4.8: activate specific options")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unused-local-typedefs")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnoexcept")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wconversion-null")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnarrowing")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wtrampolines")
  endif()

  if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.5 AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 4.4.0)
    # gcc 4.4.* as several problems with aliasing in Boost.Function and Boost.Optional (actually with align_as).
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-strict-aliasing")
  endif()

  # add many warnings
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wstrict-null-sentinel")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnon-virtual-dtor")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Woverloaded-virtual")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wcast-align")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wcast-qual")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wfloat-equal")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wlogical-op")

   # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wsign-conversion")

  # some where not added due to warning from boost.
    # '-Wsign-promo', #disabled since problems in boost
    # '-Wctor-dtor-privacy', #disabled since problems in boost
    # '-Wconversion', #disabled since problems in boost
  # quality
    # '-Wzero-as-null-pointer-constant', #disabled since problems in boost
    # '-Wold-style-cast', #disabled since problems in boost

  # also add a few extra check
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wvla -Wredundant-decls")
  # -Wpadded

endif()

set(CMAKE_MACOSX_RPATH True)

# use, i.e. don't skip the full RPATH for the build tree
set(CMAKE_SKIP_BUILD_RPATH  False)

# when building, don't use the install RPATH already
# (but later on when installing)
set(CMAKE_BUILD_WITH_INSTALL_RPATH False)

set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")

# add the automatically determined parts of the RPATH
# which point to directories outside the build tree to the install RPATH
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH True)

# CPack properties common to all packages
set(CPACK_PACKAGE_NAME "LibXML")
set(CPACK_PACKAGE_VENDOR "RTE")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "LibXML - simple xml library")
set(CPACK_PACKAGE_VERSION ${LIBXML_VERSION} )
set(CPACK_PACKAGE_VERSION_MAJOR ${LIBXML_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${LIBXML_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${LIBXML_VERSION_PATCH})

set(CPACK_PACKAGE_INSTALL_DIRECTORY "LibXML")

set(CPACK_DEBIAN_PACKAGE_MAINTAINER "contact@rte-france.com")

set(CPACK_DEBIAN_COMPONENT_INSTALL ON)
set(CPACK_RPM_COMPONENT_INSTALL ON)
set(CPACK_ARCHIVE_COMPONENT_INSTALL ON)

set(CPACK_COMPONENTS_ALL sax-common sax-parser sax-formatter)

set(CPACK_GENERATOR "RPM" CACHE STRING "Package formats to generate. See cpack --help for available generators.")

# Boost
find_package(Boost 1.59 REQUIRED)

set(LINK_SUFFIX_SHARED "")
set(LINK_SUFFIX_STATIC "-static")

# prepare a few custom targets
if (LibXML_BUILD_TESTS)
  add_custom_target(tests)

  # tests are compiled against SHARED libraries if possible, against STATIC otherwise.
  if (LibXML_SAX_BUILD_STATIC AND NOT LibXML_SAX_BUILD_SHARED)
    set(LINK_SUFFIX_TEST ${LINK_SUFFIX_STATIC})
  else ()
    set(LINK_SUFFIX_TEST ${LINK_SUFFIX_SHARED})
  endif ()
endif ()

# include sub directories

if (LibXML_SAX_BUILD_PARSER OR LibXML_SAX_BUILD_FORMATTER)
  add_subdirectory(sax/common)
endif ()

if (LibXML_SAX_BUILD_FORMATTER)
  add_subdirectory(sax/formatter)
endif ()

if (LibXML_SAX_BUILD_PARSER)
  add_subdirectory(sax/parser)
endif ()

if (LibXML_SAX_BUILD_SAMPLES)
  add_subdirectory(samples)
endif ()

# install files allowing find_package.

include(CMakePackageConfigHelpers)

configure_package_config_file(libxml-config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/libxml-config.cmake
  INSTALL_DESTINATION ${LibXML_INSTALL_CMAKE}
  PATH_VARS
    LibXML_INSTALL_INCLUDE
    LibXML_INSTALL_LIBRARIES
    LibXML_INSTALL_BINARIES
  NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/libxml-config-version.cmake
  VERSION ${LIBXML_VERSION}
  COMPATIBILITY SameMajorVersion
)

install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/libxml-config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/libxml-config-version.cmake
  DESTINATION ${LibXML_INSTALL_CMAKE}
  COMPONENT core
)

set(CPACK_COMPONENT_CORE_REQUIRED ON)

# This must always be last for a package
include(CPack)
