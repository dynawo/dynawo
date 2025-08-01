# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

#CompileModelicaModel
set(COMPILER_MODELICA_OMC_SOURCES
    DYNCompileModelicaModel.cpp
    )

add_executable(compileModelicaModel ${COMPILER_MODELICA_OMC_SOURCES})

target_include_directories(compileModelicaModel SYSTEM
  PRIVATE
  $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(compileModelicaModel
  PRIVATE
    dynawo_Common
    ${CMAKE_DL_LIBS}
    Boost::log
    Boost::program_options
    XMLSAXParser${LibXML_LINK_SUFFIX}
    LibXml2::LibXml2
  )

install(TARGETS compileModelicaModel EXPORT dynawo-targets DESTINATION ${SBINDIR_NAME})

configure_file(compileCppModelicaModelInDynamicLib.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/compileCppModelicaModelInDynamicLib.cmake @ONLY)
configure_file(PreloadCache.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/PreloadCache.cmake @ONLY)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/compileCppModelicaModelInDynamicLib.cmake ${CMAKE_CURRENT_BINARY_DIR}/PreloadCache.cmake DESTINATION ${SBINDIR_NAME})
install(FILES computeJacobian.py DESTINATION ${SBINDIR_NAME})
install(FILES extractEvalFAdept.py DESTINATION ${SBINDIR_NAME})
install(PROGRAMS generateEvalJ.sh DESTINATION ${SBINDIR_NAME})
install(FILES remove_comments.pl DESTINATION ${SBINDIR_NAME})
install(FILES methodsEvalFAdept.cpp DESTINATION ${SBINDIR_NAME})

#Add post processing scripts
add_subdirectory(Scripts_OMC_${OPENMODELICA_VERSION})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
