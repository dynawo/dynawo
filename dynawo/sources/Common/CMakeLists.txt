# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

set(COMMON_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(COMMON_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(UTIL_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(UTIL_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(DYNAWO_DICTIONARIES
  Dictionaries/DYNError_en_GB.dic
  Dictionaries/DYNTimeline_en_GB.dic
  Dictionaries/DYNConstraint_en_GB.dic
  Dictionaries/DYNLog_en_GB.dic
  )

set(DYNAWO_DICTIONARIES_MAPPING
  Dictionaries/dictionaries_mapping.dic
  Dictionaries/DYNTimeline_oppositeEvents.dic
  )

# custom target to generate files associated to dictionaries
add_custom_target(create_keys_files ALL DEPENDS ${DYNAWO_DICTIONARIES})

add_custom_command(TARGET create_keys_files
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/Dictionaries/validateDictionaries.py --inputDir=${CMAKE_CURRENT_SOURCE_DIR}/Dictionaries,${CMAKE_DYN_DICTIONARY_PATHS} --outputDir=${CMAKE_CURRENT_SOURCE_DIR} --modelicaPackage=Dynawo.NonElectrical.Logs --modelicaDir=${CMAKE_CURRENT_SOURCE_DIR}/../Models/Modelica/Dynawo/NonElectrical/Logs/
  COMMENT "Generate key files for dictionaries"
  )

# Find keys.cpp files (generated files)
set(CPP_KEYS
  DYNTimeline_keys.cpp
  DYNConstraint_keys.cpp
  DYNError_keys.cpp
  DYNLog_keys.cpp
  )

# Find keys.h files  (generated files)
set(INCLUDE_KEYS
  DYNTimeline_keys.h
  DYNConstraint_keys.h
  DYNError_keys.h
  DYNLog_keys.h
  )

set_source_files_properties(${CMAKE_CURRENT_SOURCE_DIR}/DYNTimeline_keys.cpp PROPERTIES GENERATED 1)
set_source_files_properties(${CMAKE_CURRENT_SOURCE_DIR}/DYNConstraint_keys.cpp PROPERTIES GENERATED 1)
set_source_files_properties(${CMAKE_CURRENT_SOURCE_DIR}/DYNError_keys.cpp PROPERTIES GENERATED 1)
set_source_files_properties(${CMAKE_CURRENT_SOURCE_DIR}/DYNLog_keys.cpp PROPERTIES GENERATED 1)

set(COMMON_SOURCES
  DYNBitMask.cpp
  DYNCommon.cpp
  DYNError.cpp
  DYNTerminate.cpp
  DYNExecUtils.cpp
  DYNEnumUtils.cpp
  DYNFileSystemUtils.cpp
  DYNMessage.cpp
  DYNMessageTimeline.cpp
  DYNGraph.cpp
  DYNParameter.cpp
  DYNSparseMatrix.cpp
  ${CPP_KEYS}
  DYNErrorQueue.cpp
  DYNIoDico.cpp
  DYNTimer.cpp
  DYNTrace.cpp
  DYNTraceStream.cpp
  )

set(COMMON_INCLUDE_HEADERS
  DYNBitMask.h
  DYNCommon.h
  DYNError.h
  DYNTerminate.h
  DYNExecUtils.h
  DYNEnumUtils.h
  DYNFileSystemUtils.h
  DYNGraph.h
  DYNMessage.h
  DYNMessage.hpp
  DYNMessageTimeline.h
  DYNMessageTimeline.hpp
  DYNNumericalUtils.h
  DYNMacrosMessage.h
  DYNParameter.h
  DYNSparseMatrix.h
  DYNParameter.hpp
  gtest_dynawo.h
  ${INCLUDE_KEYS}
  DYNErrorQueue.h
  DYNInitXml.h
  DYNIoDico.h
  DYNTimer.h
  DYNTrace.h
  DYNTraceStream.h
  DYNClone.hpp
  make_unique.hpp
  )

add_library(dynawo_Common SHARED ${COMMON_SOURCES})

add_dependencies(dynawo_Common create_keys_files)

target_include_directories(dynawo_Common
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/sources> # for config.h & gitversion.h
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )
target_include_directories(dynawo_Common SYSTEM
  PUBLIC
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_Common
  PUBLIC
    dynawo_Interface
  PRIVATE
    Boost::filesystem
    Boost::log
    ${CMAKE_DL_LIBS}
  )

set_target_properties(dynawo_Common PROPERTIES VERSION ${COMMON_VERSION_STRING}
                                             SOVERSION ${COMMON_VERSION_MAJOR})

# PYTHON scripts for models
set(PYTHON_SCRIPTS_COMMON
  Dictionaries/validateDictionaries.py
)

install(TARGETS dynawo_Common EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${COMMON_INCLUDE_HEADERS} ${UTIL_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
install(FILES ${DYNAWO_DICTIONARIES} ${DYNAWO_DICTIONARIES_MAPPING} DESTINATION ${SHAREDIR_NAME})
install(PROGRAMS ${PYTHON_SCRIPTS_COMMON} DESTINATION ${SBINDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
