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
  DYNModelCPPImpl.cpp)

SET(COMMON_CPP_MODELS_HEADERS
  DYNModelCPP.h
  DYNModelCPPImpl.h
  )

INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIR})

INCLUDE_DIRECTORIES(../../../Modeler/Common/
                    ../../../Common
                   )

ADD_LIBRARY(dynawo_CPPModelsCommon SHARED ${COMMON_CPP_MODELS_SOURCES})

TARGET_LINK_LIBRARIES(dynawo_CPPModelsCommon ${Boost_SERIALIZATION_LIBRARY})

INSTALL(TARGETS dynawo_CPPModelsCommon DESTINATION ${libdir})
INSTALL(FILES ${COMMON_CPP_MODELS_HEADERS} DESTINATION ${includedir})

