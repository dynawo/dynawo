# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

#
# Custom target for describing solvers
#
add_custom_target(solvers
    DEPENDS SOLVERS_FILES_INSTALL
    COMMENT "Describing solvers for Dynawo"
    )

#
# Target used to install solvers files in ddbdir
# (.so and .desc.xml)
#
add_custom_target(SOLVERS_FILES_INSTALL
    COMMENT "Installing solvers"
    )

#
# Macro called to generate a solver's description
# file into ddbdir. Automatically adds the dependencies
# to the main targets.
#
macro(DESC_SOLVER SOLVER_NAME)
    # Generates .desc.xml file for the solver
    if(MSVC)
        add_custom_command(
          OUTPUT ${SOLVER_NAME}.desc.xml
          DEPENDS ${SOLVER_NAME} dumpSolver
          WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
          COMMAND
            ${CMAKE_COMMAND} -E env
            "${runtime_PATH}"
            "${runtime_LD_LIBRARY_PATH}"
            $<TARGET_FILE:dumpSolver> -m $<TARGET_FILE:${SOLVER_NAME}> -o ${SOLVER_NAME}.desc.xml
          COMMENT "Generating ${SOLVER_NAME} description file"
        )
    else()
        add_custom_command(
          OUTPUT ${SOLVER_NAME}.desc.xml
          DEPENDS ${SOLVER_NAME} dumpSolver
          WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
          COMMAND
            test -d ${CMAKE_INSTALL_PREFIX}/${DDBDIR_NAME} || (echo "Target install was not completed, you need to launch it before compiling solvers. For example with dynawo build-dynawo-core." && exit 1)
          COMMAND
            ${CMAKE_COMMAND} -E env
            "${runtime_PATH}"
            "${runtime_LD_LIBRARY_PATH}"
            $<TARGET_FILE:dumpSolver> -m $<TARGET_FILE:${SOLVER_NAME}> -o ${SOLVER_NAME}.desc.xml
          COMMENT "Generating ${SOLVER_NAME} description file"
        )
    endif()

    # Install built library and generated .desc.xml file into ddbdir
    add_custom_target(${SOLVER_NAME}.desc
        DEPENDS
            ${SOLVER_NAME}
            ${SOLVER_NAME}.desc.xml
        COMMAND
            ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${SOLVER_NAME}> ${ddbdir}/
        COMMAND
            ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/${SOLVER_NAME}.desc.xml ${ddbdir}/
        )

    add_dependencies(SOLVERS_FILES_INSTALL ${SOLVER_NAME}.desc)
endmacro(DESC_SOLVER)

add_subdirectory(Common)
add_subdirectory(AlgebraicSolvers)
add_subdirectory(FixedTimeStep)
add_subdirectory(VariableTimeStep)
add_subdirectory(util)
