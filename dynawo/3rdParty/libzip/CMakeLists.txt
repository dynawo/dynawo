# Copyright (c) 2013-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libzip, a library to handle zip archives.

cmake_minimum_required(VERSION 2.6 FATAL_ERROR)

project(zip)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(LIBZIP_BUILD_TESTS TRUE CACHE BOOL "Build LibZIP tests.")
set(LIBZIP_BUILD_SAMPLES TRUE CACHE BOOL "Build LibZIP samples.")

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

find_package(Boost 1.39 REQUIRED)
if (LIBZIP_BUILD_TESTS)
    find_package(GTest)
endif ()

if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "RelWithDebInfo" CACHE STRING "Choose the type of build: Debug Release RelWithDebInfo MinSizeRel" FORCE)
endif ()

if(NOT MSVC)
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Werror")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
endif()

set(BIN_INSTALL_DIR "bin" CACHE PATH "The directory the executables are installed in.")
set(INCLUDE_INSTALL_DIR "include" CACHE PATH "The directory the headers are installed in.")
set(LIB_INSTALL_DIR "lib" CACHE STRING "The directory the libraries are installed in.")

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
include_directories(${Boost_INCLUDE_DIRS})
if (LIBZIP_BUILD_TESTS)
  include_directories(${GTEST_INCLUDE_DIRS})
endif ()

add_subdirectory(src)
if (LIBZIP_BUILD_SAMPLES)
  add_subdirectory(samples)
endif ()
if (LIBZIP_BUILD_TESTS)
  add_subdirectory(test)
endif ()
