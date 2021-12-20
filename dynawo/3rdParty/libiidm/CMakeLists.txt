# Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libiidm, a library to model IIDM networks and allows importing and exporting them to files.

cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)

project(libiidm)

# This project has a core component: libiidm.so
# It also provide some extensions, like libiidm-xml.so

# temporary only effectively supports g++ in versions starting 4.8.2.

set(IIDM_VERSION_MAJOR 0)
set(IIDM_VERSION_MINOR 2)
set(IIDM_VERSION_PATCH 8)

# Project options
option(BUILD_XML "enables the XML support." OFF)
# option(BUILD_JSON "enables the JSON support." OFF)

option(BUILD_SAMPLES "enables the building of the samples (only those related to built components)." OFF)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "RelWithDebInfo" CACHE STRING "build type, one of (Release, Debug, RelWithDebInfo)" FORCE)
else()
  set(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING "build type, one of (Release, Debug, RelWithDebInfo)")
endif()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(BOOST_ROOT ${BOOST_ROOT} CACHE STRING "Boost library install directory")

set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} CACHE STRING "pathes where cmake searches for package-config.cmake files")

set(BUILD_SHARED_LIBS ON) # Required in order dependencies to be retrieved properly

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(IIDM_VERSION ${IIDM_VERSION_MAJOR}.${IIDM_VERSION_MINOR}.${IIDM_VERSION_PATCH})
set(IIDM_SOVERSION ${IIDM_VERSION_MAJOR}.${IIDM_VERSION_MINOR})
set(IIDM_VERSION_STRING ${IIDM_VERSION})

set(IIDM_SHARE_PATH "share/iidm")

if(WIN32)
  set(LibIIDM_INSTALL_CMAKE cmake)
else()
  set(LibIIDM_INSTALL_CMAKE share/cmake/LibIIDM-${IIDM_VERSION})
endif()

set(LibIIDM_INSTALL_LIBRARIES lib)
set(LibIIDM_INSTALL_BINARIES bin)
set(LibIIDM_INSTALL_INCLUDE include)

add_definitions(-DBOOST_NO_LONG_LONG)

if(NOT MSVC)
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
endif()

# Add specific options for gcc
if('${CMAKE_CXX_COMPILER_ID}' STREQUAL 'GNU')
  if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 4.8)
    message(STATUS "Use of GCC version greater than 4.8: activate specific options")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unused-local-typedefs")
    # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnoexcept")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wconversion-null")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnarrowing")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wtrampolines")
  endif()

  # add many warnings
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -pedantic")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wstrict-null-sentinel")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnon-virtual-dtor")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Woverloaded-virtual")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wcast-align")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wcast-qual")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wfloat-equal")

  if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 4.5)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wlogical-op")
  endif()

  # some where not added due to warning from boost.
    # '-Wsign-promo', #disabled since problems in boost
    # '-Wctor-dtor-privacy', #disabled since problems in boost
    # '-Wconversion', #disabled since problems in boost
    # '-Wsign-conversion', #disabled since problems in boost.unordered
  # quality
    # '-Wzero-as-null-pointer-constant', #disabled since problems in boost
    # '-Wold-style-cast', #disabled since problems in boost

  # also add a few extra check
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wvla -Wredundant-decls")
  # -Wpadded

endif()

# CPack properties common to all packages
set(CPACK_PACKAGE_NAME "iidm")
set(CPACK_PACKAGE_VENDOR "RTE")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "LibIIDM - Library to model and share IIDM networks.")
set(CPACK_PACKAGE_VERSION ${IIDM_CORE_VERSION} )
set(CPACK_PACKAGE_VERSION_MAJOR ${IIDM_CORE_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${IIDM_CORE_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${IIDM_CORE_VERSION_PATCH})

set(CPACK_PACKAGE_INSTALL_DIRECTORY "LibIIDM")

set(CPACK_DEBIAN_PACKAGE_MAINTAINER "contact@rte-france.com")

set(CPACK_DEBIAN_COMPONENT_INSTALL ON)
set(CPACK_RPM_COMPONENT_INSTALL ON)
set(CPACK_ARCHIVE_COMPONENT_INSTALL ON)

set(CPACK_COMPONENTS_ALL iidm-core)

set(CPACK_COMPONENT_GROUP_EXTENSIONS_DESCRIPTION "All the extension libraries.")
set(CPACK_COMPONENT_GROUP_EXTENSIONS_EXPANDED ON)

# Boost is required for core and all extensions.
find_package(Boost 1.59 REQUIRED)

set(LibIIDM_LibXML_REQUIRED_VERSION 0.2.4)

add_subdirectory(core)

# note from documentation:  "Add a target with no output so it will always be built."
add_custom_target(extensions)
add_custom_target(install-extensions)

if( BUILD_XML )
  find_package(XercesC REQUIRED)
  find_package(libXML ${LibIIDM_LibXML_REQUIRED_VERSION} REQUIRED)
  add_subdirectory(xml)
endif()

add_subdirectory(extensions/activeSeason)
add_subdirectory(extensions/activePowerControl)
add_subdirectory(extensions/busbarSectionPosition)
add_subdirectory(extensions/congestionManagement)
add_subdirectory(extensions/connectablePosition)
add_subdirectory(extensions/currentLimitsPerSeason)
add_subdirectory(extensions/generatorActivePowerControl)
add_subdirectory(extensions/generatorEntsoeCategory)
add_subdirectory(extensions/generatorOperatorActivePowerRange)
add_subdirectory(extensions/generatorShortCircuits)
add_subdirectory(extensions/generatorStartup)
add_subdirectory(extensions/hvdcAngleDroopActivePowerControl)
add_subdirectory(extensions/hvdcOperatorActivePowerRange)
add_subdirectory(extensions/loadDetail)
add_subdirectory(extensions/remoteMeasurements)
add_subdirectory(extensions/standbyAutomaton)
add_subdirectory(extensions/stateOfCharge)
add_subdirectory(extensions/voltageLevelShortCircuits)
add_subdirectory(extensions/voltageRegulation)

# install files allowing find_package.

include(CMakePackageConfigHelpers)
configure_package_config_file(libiidm-config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/libiidm-config.cmake
  INSTALL_DESTINATION ${LibIIDM_INSTALL_CMAKE}
  PATH_VARS
    LibIIDM_INSTALL_INCLUDE
    LibIIDM_INSTALL_LIBRARIES
    LibIIDM_INSTALL_BINARIES
  NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/libiidm-config-version.cmake
  VERSION ${IIDM_VERSION}
  COMPATIBILITY SameMajorVersion
)

install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/libiidm-config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/libiidm-config-version.cmake
  DESTINATION ${LibIIDM_INSTALL_CMAKE}
  COMPONENT core
)

# This must always be last for a package
include(CPack)
