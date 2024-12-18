# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

set(COMMON_CPP_MODELS_SOURCES
    DYNModelCPP.cpp
    )

set(COMMON_CPP_MODELS_HEADERS
    DYNModelCPP.h
    DYNModelCPP.hpp
    )

add_library(dynawo_CPPModelsCommon SHARED ${COMMON_CPP_MODELS_SOURCES})

target_include_directories(dynawo_CPPModelsCommon
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )
target_include_directories(dynawo_CPPModelsCommon SYSTEM
  PRIVATE
  $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_compile_definitions(dynawo_CPPModelsCommon
  INTERFACE $<$<BOOL:${MSVC}>:_USE_MATH_DEFINES>
  )

target_link_libraries(dynawo_CPPModelsCommon
  PRIVATE
    dynawo_Common
    Boost::serialization
  PUBLIC
    dynawo_ModelerCommon
    Boost::system
  )

install(TARGETS dynawo_CPPModelsCommon EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${COMMON_CPP_MODELS_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
