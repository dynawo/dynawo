# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

SET(COMMON_CPP_MODELS_SOURCES
    DYNModelCPPImpl.cpp
    )

SET(COMMON_CPP_MODELS_HEADERS
    DYNModelCPP.h
    DYNModelCPPImpl.h
    )

ADD_LIBRARY(dynawo_CPPModelsCommon ${LIBRARY_TYPE} ${COMMON_CPP_MODELS_SOURCES})

TARGET_INCLUDE_DIRECTORIES(dynawo_CPPModelsCommon
    INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    )

TARGET_LINK_LIBRARIES(dynawo_CPPModelsCommon dynawo_ModelerCommon)

INSTALL(TARGETS dynawo_CPPModelsCommon EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
INSTALL(FILES ${COMMON_CPP_MODELS_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
