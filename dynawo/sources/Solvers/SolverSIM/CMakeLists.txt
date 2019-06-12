# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

SET(SOLVER_SIM_VERSION_STRING ${DYNAWO_VERSION_STRING})
SET(SOLVER_SIM_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

SET(SOLVER_SIM_SOURCES
    DYNSolverEulerKIN.cpp
    DYNSolverSIM.cpp
    )

SET(SOLVER_SIM_INCLUDE_HEADERS
    DYNSolverSIM.h
    )

INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIR}
                    ${KLU_INCLUDE_DIR}
                    ${SUNDIALS_INCLUDE_DIR}
                    )

INCLUDE_DIRECTORIES(../../API/PAR
                    ../../API/TL
                    ../../Common
                    ../../Modeler/Common
                    ../Common
                    ../SolverKINSOL
                    )

ADD_LIBRARY(dynawo_SolverSIM SHARED ${SOLVER_SIM_SOURCES})

TARGET_LINK_LIBRARIES(dynawo_SolverSIM
                      dynawo_API_PAR
                      dynawo_API_TL
                      dynawo_Common
                      dynawo_SolverCommon
                      dynawo_SolverKINSOL
                      ${SUNDIALS_KINSOL_LIBRARY}
                      ${SUNDIALS_SUNLINSOLNICSLU_LIBRARY}
                      ${SUNDIALS_NVECSERIAL_LIBRARY}
                      ${SUITESPARSE_LIBRARIES}
                      ${Boost_ATOMIC_LIBRARY}
                      ${Boost_DATE_TIME_LIBRARY}
                      ${Boost_REGEX_LIBRARY}
                      ${Boost_CHRONO_LIBRARY}
                      )

IF(${NICSLU_FOUND})
  INCLUDE_DIRECTORIES(SYSTEM ${NICSLU_INCLUDE_DIR})
  TARGET_LINK_LIBRARIES(dynawo_SolverSIM ${NICSLU_LIBRARIES})
ENDIF()

if (APPLE)
  IF(LIBRARY_TYPE STREQUAL "STATIC")
    TARGET_LINK_LIBRARIES(dynawo_SolverSIM "-flat_namespace -undefined warning")
  ENDIF()
endif()

SET_TARGET_PROPERTIES(dynawo_SolverSIM PROPERTIES VERSION ${SOLVER_SIM_VERSION_STRING}
                                           SOVERSION ${SOLVER_SIM_VERSION_MAJOR})

INSTALL(TARGETS dynawo_SolverSIM DESTINATION ${libdir})
INSTALL(FILES ${SOLVER_SIM_INCLUDE_HEADERS} DESTINATION ${includedir})

DESC_SOLVER(dynawo_SolverSIM)
