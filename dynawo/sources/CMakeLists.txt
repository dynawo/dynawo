# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

SET(DYNAWO_INCLUDE_HEADERS
    config.h
    )

INSTALL(FILES ${DYNAWO_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

#obtain git revision
# a custom target that is always built
ADD_CUSTOM_TARGET(revisiontag ALL)

# creates gitversion.h using cmake script
ADD_CUSTOM_COMMAND(TARGET revisiontag COMMAND ${CMAKE_COMMAND}
   -DOUTPUT_DIR=${CMAKE_CURRENT_SOURCE_DIR}
   -DGIT_SOURCE_DIR=${DYNAWO_HOME}
   -P ${CMAKE_MODULE_PATH}/getgitheadrevision.cmake)


IF(BUILD_TESTS)
  ADD_SUBDIRECTORY(API/CRV/test)
  ADD_SUBDIRECTORY(API/DYD/test)
  ADD_SUBDIRECTORY(API/EXTVAR/test)
  ADD_SUBDIRECTORY(API/PAR/test)
  ADD_SUBDIRECTORY(API/TL/test)
  ADD_SUBDIRECTORY(API/CSTR/test)
  ADD_SUBDIRECTORY(API/FS/test)
  ADD_SUBDIRECTORY(API/JOB/test)
  ADD_SUBDIRECTORY(Common/test)
  ADD_SUBDIRECTORY(Modeler/Common/test)
  ADD_SUBDIRECTORY(Modeler/DataInterface/test)
  ADD_SUBDIRECTORY(Models/CPP/ModelNetwork/test)
  ADD_SUBDIRECTORY(Solvers/Common/test)
  ADD_SUBDIRECTORY(Solvers/SolverIDA/test)
  ADD_SUBDIRECTORY(Solvers/SolverSIM/test)
  ADD_SUBDIRECTORY(ModelicaCompiler/test)
ENDIF()
