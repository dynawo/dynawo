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
#        dumpModel              #
#################################
set(DUMP_MODEL_SOURCES
    DYNDumpModel.cpp
    )

add_executable(dumpModel ${DUMP_MODEL_SOURCES})

target_include_directories(dumpModel SYSTEM
  PRIVATE
  $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dumpModel
  PRIVATE
    dynawo_Common
    dynawo_ModelerCommon
    XMLSAXFormatter${LibXML_LINK_SUFFIX}
    XMLSAXParser${LibXML_LINK_SUFFIX}
    LibXml2::LibXml2
    ${CMAKE_DL_LIBS}
    Boost::system
    Boost::program_options
    )

install(TARGETS dumpModel EXPORT dynawo-targets DESTINATION ${SBINDIR_NAME})

#################################
#     generate-preassembled     #
#################################
# Generate Dyd Library from dyd file
set(DYD_LIB_GENERATION_SOURCES
    DYNGeneratePreassembled.cpp
    )

add_executable(generate-preassembled ${DYD_LIB_GENERATION_SOURCES})

target_include_directories(generate-preassembled SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(generate-preassembled
  PRIVATE
    dynawo_Common
    dynawo_ModelerCommon
    ${CMAKE_DL_LIBS}
    XMLSAXParser${LibXML_LINK_SUFFIX}
    LibXml2::LibXml2
    Boost::filesystem
    Boost::program_options
    )

set_target_properties(generate-preassembled PROPERTIES VERSION ${DYNAWO_VERSION_STRING})

add_dependencies(generate-preassembled compileModelicaModel)

install(TARGETS generate-preassembled EXPORT dynawo-targets DESTINATION ${SBINDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
