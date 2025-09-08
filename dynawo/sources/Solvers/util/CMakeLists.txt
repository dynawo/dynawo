# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

#################################
#        dumpSolver              #
#################################
set(DUMP_SOLVER_SOURCES
    DYNDumpSolver.cpp
    )

add_executable(dumpSolver ${DUMP_SOLVER_SOURCES})

target_include_directories(dumpSolver SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dumpSolver
  PRIVATE
    XMLSAXFormatter${LibXML_LINK_SUFFIX}
    XMLSAXParser${LibXML_LINK_SUFFIX}
    LibXml2::LibXml2
    dynawo_Common
    dynawo_SolverCommon
    dynawo_ModelerCommon
    Boost::system
    Boost::program_options
  )

install(TARGETS dumpSolver EXPORT dynawo-targets DESTINATION ${SBINDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
