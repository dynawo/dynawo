# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

SET(SOLVER_KINSOL_VERSION_STRING ${DYNAWO_VERSION_STRING})
SET(SOLVER_KINSOL_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

SET(SOLVER_KINSOL_SOURCES
    DYNSolverKIN.cpp
    )

SET(SOLVER_KINSOL_INCLUDE_HEADERS
    DYNSolverKIN.h
    )

INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIR}
                    ${KLU_INCLUDE_DIR}
                    ${SUNDIALS_INCLUDE_DIR}
                    )

INCLUDE_DIRECTORIES(../../Common
                    ../../Solvers/Common
                    ../../Modeler/Common
                    )

ADD_LIBRARY(dynawo_SolverKINSOL ${LIBRARY_TYPE} ${SOLVER_KINSOL_SOURCES})

TARGET_LINK_LIBRARIES(dynawo_SolverKINSOL
                      dynawo_Common
                      ${SUNDIALS_KINSOL_LIBRARY}
                      ${SUNDIALS_NVECSERIAL_LIBRARY}
                      ${SUNDIALS_SUNLINSOLKLU_LIBRARY}
                      ${SUITESPARSE_LIBRARIES}
                      )

IF(${NICSLU_FOUND})
  TARGET_LINK_LIBRARIES(dynawo_SolverKINSOL ${NICSLU_LIBRARIES})
ENDIF()

SET_TARGET_PROPERTIES(dynawo_SolverKINSOL PROPERTIES VERSION ${SOLVER_KINSOL_VERSION_STRING}
                                              SOVERSION ${SOLVER_KINSOL_VERSION_MAJOR})

INSTALL(TARGETS dynawo_SolverKINSOL DESTINATION ${libdir})
INSTALL(FILES ${SOLVER_KINSOL_INCLUDE_HEADERS} DESTINATION ${includedir})
