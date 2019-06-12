# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

##############################
#     libSolverSubModel      #
##############################
SET(SOLVER_SUBMODEL_VERSION_STRING ${DYNAWO_VERSION_STRING})
SET(SOLVER_SUBMODEL_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

SET(SOLVER_SUBMODEL_SOURCES
    DYNSolverSubModel.cpp
    )

INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIR}
                    ${KLU_INCLUDE_DIR}
                    ${SUNDIALS_INCLUDE_DIR}
                    )

INCLUDE_DIRECTORIES(../Common
                    ../../Modeler/Common
                    ../../Common
                    )

ADD_LIBRARY(dynawo_SolverSubModel ${LIBRARY_TYPE} ${SOLVER_SUBMODEL_SOURCES})

TARGET_LINK_LIBRARIES(dynawo_SolverSubModel
                      ${SUNDIALS_NVECSERIAL_LIBRARY}
                      ${SUNDIALS_KINSOL_LIBRARY}
                      ${SUNDIALS_SUNLINSOLKLU_LIBRARY}
                      ${SUNDIALS_SUNMATRIXSPARSE_LIBRARY}
                      ${SUITESPARSE_LIBRARIES}
                      dynawo_SolverCommon
                      dynawo_ModelerCommon
                      )

IF(${NICSLU_FOUND})
  TARGET_LINK_LIBRARIES(dynawo_SolverSubModel ${NICSLU_LIBRARIES})
ENDIF()

SET_TARGET_PROPERTIES(dynawo_SolverSubModel PROPERTIES VERSION ${SOLVER_SUBMODEL_VERSION_STRING}
                                              SOVERSION ${SOLVER_SUBMODEL_VERSION_MAJOR})

INSTALL(TARGETS dynawo_SolverSubModel DESTINATION ${libdir})
