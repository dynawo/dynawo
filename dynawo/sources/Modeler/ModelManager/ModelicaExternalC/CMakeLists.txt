# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

SET(MODELICA_SOURCES
    ModelicaFFT.cpp
    ModelicaRandom.cpp
    ModelicaInternal.cpp
    ModelicaStandardTables.cpp
    ModelicaIO.cpp
    ModelicaStrings.cpp
    ModelicaMatIO.cpp
    ModelicaUtilities.cpp
    )

SET(MODELICA_INCLUDE_HEADERS
   gconstructor.h
   ModelicaFFT.h
   ModelicaRandom.h
   ModelicaInternal.h
   ModelicaStandardTables.h
   ModelicaIO.h
   ModelicaStrings.h
   ModelicaMatIO.h
   uthash.h
   ModelicaUtilities.h
   )

SET_SOURCE_FILES_PROPERTIES(
  ${MODELICA_SOURCES}
  PROPERTIES
  COMPILE_FLAGS "-w"
)

ADD_LIBRARY(Modelica_externalC ${LIBRARY_TYPE} ${MODELICA_SOURCES})

INSTALL(TARGETS Modelica_externalC DESTINATION ${libdir})
INSTALL(FILES ${MODELICA_INCLUDE_HEADERS} DESTINATION ${includedir})
