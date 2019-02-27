# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

##########################################
#          DYNModelVariationArea         #
##########################################
SET(MODEL_NAME
    DYNModelVariationArea
   )

SET(MODEL_SOURCES
    DYNModelVariationArea.cpp
    )

INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIR})

INCLUDE_DIRECTORIES(../../../API/PAR
                    ../../../Modeler/Common
                    ../../../Common
                    ../../../Solvers/Common
                    ../Common
                   )

SET(MODEL_LINKED_LIBRARIES
    dynawo_CPPModelsCommon
    dynawo_API_PAR
    dynawo_Common
    dynawo_SolverCommon
    dynawo_ModelerCommon
   )

COMPILE_CPP_MODEL(${MODEL_NAME}
                  ${MODEL_SOURCES}
                  "${MODEL_LINKED_LIBRARIES}"
                 )
