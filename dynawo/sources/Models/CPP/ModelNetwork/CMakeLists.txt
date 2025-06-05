# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

#################################
#         ModelNetwork          #
#################################
set(MODEL_NAME
  DYNModelNetwork
  )

set(MODEL_SOURCES
  DYNDerivative.cpp
  DYNNetworkComponent.cpp
  DYNModelBus.cpp
  DYNModelGenerator.cpp
  DYNModelSwitch.cpp
  DYNModelSwitchFactory.cpp
  DYNModelLine.cpp
  DYNModelLoad.cpp
  DYNModelShuntCompensator.cpp
  DYNModelStaticVarCompensator.cpp
  DYNModelTapChanger.cpp
  DYNModelThreeWindingsTransformer.cpp
  DYNModelTwoWindingsTransformer.cpp
  DYNModelDanglingLine.cpp
  DYNModelNetwork.cpp
  DYNModelCurrentLimits.cpp
  DYNModelRatioTapChanger.cpp
  DYNModelPhaseTapChanger.cpp
  DYNModelHvdcLink.cpp
  DYNModelVoltageLevel.cpp
  )

compile_cpp_model(${MODEL_NAME} "${MODEL_SOURCES}")

target_include_directories(${MODEL_NAME}
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
  PUBLIC
    $<TARGET_PROPERTY:dynawo_CPPModelsCommon,INTERFACE_INCLUDE_DIRECTORIES>
  )
target_include_directories(${MODEL_NAME} SYSTEM
  PRIVATE
  $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(${MODEL_NAME}
  PRIVATE
    dynawo_DataInterface
    dynawo_API_PAR
  PUBLIC
    dynawo_SolverKINSubModel
  )

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
