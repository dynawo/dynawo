# Copyright (c) 2025, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.

######################################################
#     DYNModelSecondaryVoltageControlSimplified      #
######################################################
set(MODEL_NAME
  DYNModelSecondaryVoltageControlSimplified
  )

set(MODEL_SOURCES
DYNModelSecondaryVoltageControlSimplified.cpp
  )

compile_cpp_model(${MODEL_NAME} "${MODEL_SOURCES}")

target_include_directories(${MODEL_NAME}
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<TARGET_PROPERTY:dynawo_CPPModelsCommon,INTERFACE_INCLUDE_DIRECTORIES>
  )
target_include_directories(${MODEL_NAME} SYSTEM
  PRIVATE
  $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
