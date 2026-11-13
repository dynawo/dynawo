# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# Modelica_externalC embeds the static external C library of the Modelica Standard Library (built in 3rdParty/modelicaexternalc)
# and implements the functions declared in ModelicaUtilities.h (DYNModelicaUtilities.cpp)
set(MODELICA_SOURCES
    DYNModelicaUtilities.cpp
    )

set(MODELICA_INCLUDE_HEADERS
    ${MODELICAEXTERNALC_INCLUDE_DIR}/ModelicaFFT.h
    ${MODELICAEXTERNALC_INCLUDE_DIR}/ModelicaInternal.h
    ${MODELICAEXTERNALC_INCLUDE_DIR}/ModelicaRandom.h
    ${MODELICAEXTERNALC_INCLUDE_DIR}/ModelicaStrings.h
    ${MODELICAEXTERNALC_INCLUDE_DIR}/ModelicaIO.h
    ${MODELICAEXTERNALC_INCLUDE_DIR}/ModelicaMatIO.h
    ${MODELICAEXTERNALC_INCLUDE_DIR}/ModelicaStandardTables.h
    )

add_library(Modelica_externalC SHARED ${MODELICA_SOURCES})

target_include_directories(Modelica_externalC
  PUBLIC
    $<BUILD_INTERFACE:${MODELICAEXTERNALC_INCLUDE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    )

target_include_directories(Modelica_externalC SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
    )

# The whole static library is embedded so that all its functions are available to the Modelica models
if(MSVC)
  set_property(TARGET Modelica_externalC APPEND_STRING PROPERTY LINK_FLAGS " /WHOLEARCHIVE:${MODELICAEXTERNALC_LIBRARY}")
  target_link_libraries(Modelica_externalC PRIVATE ${MODELICAEXTERNALC_LIBRARY})
else()
  target_link_libraries(Modelica_externalC PRIVATE -Wl,--whole-archive ${MODELICAEXTERNALC_LIBRARY} -Wl,--no-whole-archive)
endif()

target_link_libraries(Modelica_externalC
  PRIVATE
    dynawo_Common
    Boost::system
  )

install(TARGETS Modelica_externalC EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${MODELICA_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
