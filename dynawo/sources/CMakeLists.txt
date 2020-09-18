# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

#obtain git revision
# a custom target that is always built
add_custom_target(revisiontag ALL)

# creates gitversion.h using cmake script
add_custom_command(TARGET revisiontag COMMAND ${CMAKE_COMMAND}
   -DOUTPUT_DIR=${CMAKE_CURRENT_SOURCE_DIR}
   -DGIT_SOURCE_DIR=${DYNAWO_HOME}
   -P ${CMAKE_MODULE_PATH}/getgitheadrevision.cmake)


set(DYNAWO_INCLUDE_HEADERS
  config.h
  gitversion.h
)

install(FILES ${DYNAWO_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS)
  add_subdirectory(API/CRV/test)
  add_subdirectory(API/CRT/test)
  add_subdirectory(API/DYD/test)
  add_subdirectory(API/EXTVAR/test)
  add_subdirectory(API/PAR/test)
  add_subdirectory(API/TL/test)
  add_subdirectory(API/CSTR/test)
  add_subdirectory(API/FS/test)
  add_subdirectory(API/JOB/test)
  add_subdirectory(Common/test)
  add_subdirectory(ModelicaCompiler/test)
  add_subdirectory(Modeler/Common/test)
  add_subdirectory(Modeler/DataInterface/IIDM/test)
  add_subdirectory(Modeler/ModelManager/test)
  add_subdirectory(Modeler/util/test)
  add_subdirectory(Models/CPP/ModelFrequency/ModelSignalN/test)
  add_subdirectory(Models/CPP/ModelFrequency/ModelOmegaRef/test)
  add_subdirectory(Models/CPP/ModelVariationArea/test)
  add_subdirectory(Models/CPP/ModelNetwork/test)
  add_subdirectory(Models/test)
  add_subdirectory(Models/Modelica/PreassembledModels/test)
  add_subdirectory(Solvers/Common/test)
  add_subdirectory(Solvers/AlgebraicSolvers/test)
  add_subdirectory(Solvers/SolverIDA/test)
  add_subdirectory(Solvers/SolverSIM/test)
  add_subdirectory(Solvers/util/test)
endif()
