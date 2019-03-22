# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

SET(SOLVER_COMMON_VERSION_STRING ${DYNAWO_VERSION_STRING})
SET(SOLVER_COMMON_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

SET(SOLVER_COMMON_SOURCES
    DYNSolverImpl.cpp
    DYNSolverFactory.cpp
    DYNSolverCommon.cpp
    DYNParameterSolver.cpp
    )

SET(SOLVER_COMMON_INCLUDE_HEADERS
    DYNSolver.h
    DYNSolverFactory.h
    DYNSolverCommon.h
    DYNParameterSolver.h
    DYNParameterSolver.hpp
    )

INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIR}
                    ${SUNDIALS_INCLUDE_DIR}
                    )

INCLUDE_DIRECTORIES(../../Common
                    ../../Modeler/Common/
                    ../../API/PAR/
                    ../../API/TL
                    )

ADD_LIBRARY(dynawo_SolverCommon ${LIBRARY_TYPE} ${SOLVER_COMMON_SOURCES})

TARGET_LINK_LIBRARIES(dynawo_SolverCommon
                      dynawo_Common
                      ${SUNDIALS_NVECSERIAL_LIBRARY}
                      dl
                      )

SET_TARGET_PROPERTIES(dynawo_SolverCommon PROPERTIES VERSION ${SOLVER_COMMON_VERSION_STRING}
                                              SOVERSION ${SOLVER_COMMON_VERSION_MAJOR})

INSTALL(TARGETS dynawo_SolverCommon DESTINATION ${libdir})
INSTALL(FILES ${SOLVER_COMMON_INCLUDE_HEADERS} DESTINATION ${includedir})

SET(SOLVER_SHARED
  solvers.par
  )

INSTALL(FILES ${SOLVER_SHARED} DESTINATION ${sharedir})
