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
#         libModelManager       #
#################################
set(MODEL_MANAGER_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(MODEL_MANAGER_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(MODEL_MANAGER_SOURCES
    DYNModelManager.cpp
    DYNModelManagerCommon.cpp
    DYNModelManagerOwnFunctions.cpp
    )

set(MODEL_MANAGER_INCLUDE_HEADERS
    DYNModelManager.h
    DYNModelManagerCommon.h
    DYNModelManagerOwnTypes.h
    DYNModelModelica.h
    DYNModelManagerOwnFunctions.h
    )

add_library(dynawo_ModelManager ${LIBRARY_TYPE} ${MODEL_MANAGER_SOURCES})

target_include_directories(dynawo_ModelManager PRIVATE ${OMC_INCLUDE_DIR} ${SUNDIALS_INCLUDE_DIR})
target_include_directories(dynawo_ModelManager
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
)

target_link_libraries(dynawo_ModelManager
  PUBLIC
    dynawo_ModelerCommon
    dynawo_SolverKINSOL
    Modelica_externalC
)

set_target_properties(dynawo_ModelManager PROPERTIES VERSION ${MODEL_MANAGER_VERSION_STRING}
                                                   SOVERSION ${MODEL_MANAGER_VERSION_MAJOR})

if(USE_ADEPT)
  target_link_libraries(dynawo_ModelManager PUBLIC Adept::Adept)
endif(USE_ADEPT)

install(TARGETS dynawo_ModelManager EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${MODEL_MANAGER_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

add_subdirectory(ModelicaExternalC)
