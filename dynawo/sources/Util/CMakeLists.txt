# Copyright (c) 2021, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

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
  )

# custom target to generate files associated to dictionnaries
add_custom_target(create_keys_files ALL DEPENDS ${DYNAWO_DICTIONARIES})

add_custom_command(TARGET create_keys_files
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/Dictionaries/validateDictionaries.py --inputDir=${CMAKE_CURRENT_SOURCE_DIR}/Dictionaries,${CMAKE_DYN_DICTIONARY_PATHS} --outputDir=${CMAKE_CURRENT_SOURCE_DIR} --modelicaPackage=Dynawo.NonElectrical.Logs --modelicaDir=${CMAKE_CURRENT_SOURCE_DIR}/../Models/Modelica/Dynawo/NonElectrical/Logs/
  COMMENT "Generate key files for dictionnaries"
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

add_library(dynawo_Interface INTERFACE)

target_compile_definitions(dynawo_Interface
  INTERFACE
  _OMC_${OPENMODELICA_VERSION}
  $<$<BOOL:${USE_ADEPT}>:_ADEPT_>
  $<$<CONFIG:Debug>:_DEBUG_>)

target_link_libraries(dynawo_Interface
  INTERFACE
  $<$<CXX_COMPILER_ID:GNU>:rt>
  $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:pthread>
  )

set(UTIL_SOURCES
  DYNError.cpp
  DYNTerminate.cpp
  DYNMessageTimeline.cpp
  DYNMessage.cpp
  DYNExecUtils.cpp
  DYNFileSystemUtils.cpp
  DYNCommon.cpp
  ${CPP_KEYS}
  DYNTimer.cpp
  DYNTraceEndline.cpp
  DYNTraceStream.cpp
  DYNTraceAppender.cpp
  DYNIoDico.cpp
  )

set(UTIL_INCLUDE_HEADERS
  DYNMacrosMessage.h
  DYNError.h
  DYNMessageTimeline.h
  DYNMessageTimeline.hpp
  DYNTerminate.h
  DYNMessage.h
  DYNMessage.hpp
  DYNExecUtils.h
  DYNFileSystemUtils.h
  DYNCommon.h
  ${INCLUDE_KEYS}
  DYNErrorQueue.h
  DYNIoDico.h
  DYNTimer.h
  DYNVisibility.h
  DYNTrace.h
  DYNTraceStream.h
  DYNTraceAppender.h
  gtest_dynawo.h
  )

set(SINGLETON_SOURCES
  DYNTrace.cpp
  DYNTraceExternal.cpp
  DYNIoDicos.cpp
  DYNIoDicosExternal.cpp
  DYNErrorQueue.cpp
  DYNErrorQueueExternal.cpp
  DYNTimers.cpp
  DYNTimersExternal.cpp
  )

if(LIBRARY_TYPE STREQUAL "STATIC")
  add_library(dynawo_Singletons ${LIBRARY_TYPE} ${SINGLETON_SOURCES})

  add_dependencies(dynawo_Singletons create_keys_files)

  target_include_directories(dynawo_Singletons
    INTERFACE
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
      $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    )
  target_include_directories(dynawo_Singletons SYSTEM
    PRIVATE
      $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
    )

  target_link_libraries(dynawo_Singletons
    PUBLIC
      dynawo_Interface
    PRIVATE
      Boost::filesystem
      Boost::log
    )

  set_target_properties(dynawo_Singletons PROPERTIES VERSION ${UTIL_VERSION_STRING}
    SOVERSION ${UTIL_VERSION_MAJOR})
else()
  list(APPEND UTIL_SOURCES
    ${SINGLETON_SOURCES}
    )
endif()

add_library(dynawo_Util ${LIBRARY_TYPE} ${UTIL_SOURCES})

add_dependencies(dynawo_Util create_keys_files)

target_include_directories(dynawo_Util
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )
target_include_directories(dynawo_Util SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_Util
  PUBLIC
    dynawo_Interface
  PRIVATE
    Boost::filesystem
    Boost::log
  )

if(LIBRARY_TYPE STREQUAL "STATIC")
  target_link_libraries(dynawo_Util PRIVATE dynawo_Singletons)
endif()

set_target_properties(dynawo_Util PROPERTIES VERSION ${UTIL_VERSION_STRING}
  SOVERSION ${UTIL_VERSION_MAJOR})

# PYTHON scripts for models
set(PYTHON_SCRIPTS_COMMON
  Dictionaries/validateDictionaries.py
  )

install(TARGETS dynawo_Interface dynawo_Util EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
if(LIBRARY_TYPE STREQUAL "STATIC")
  install(TARGETS dynawo_Singletons EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
endif()
install(FILES ${TRACE_HEADERS} ${UTIL_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
install(FILES ${DYNAWO_DICTIONARIES} ${DYNAWO_DICTIONARIES_MAPPING} DESTINATION ${SHAREDIR_NAME})
install(PROGRAMS ${PYTHON_SCRIPTS_COMMON} DESTINATION ${SBINDIR_NAME})
