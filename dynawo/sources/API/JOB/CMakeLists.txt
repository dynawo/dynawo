# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
# 
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# API version
SET(API_JOB_VERSION_STRING ${DYNAWO_VERSION_STRING})
SET(API_JOB_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

SET(API_JOB_SHARED
  xsd/jobs.xsd
  )

INSTALL(FILES ${API_JOB_SHARED} DESTINATION ${sharedir}/xsd/)

SET(API_JOB_SOURCES
    JOBXmlHandler.cpp
    JOBXmlImporter.cpp
    JOBAppenderEntryImpl.cpp
    JOBConstraintsEntryImpl.cpp
    JOBCurvesEntryImpl.cpp
    JOBDynModelsEntryImpl.cpp
    JOBFinalStateEntryImpl.cpp
    JOBInitValuesEntryImpl.cpp
    JOBInitialStateEntryImpl.cpp
    JOBIterators.cpp
    JOBIteratorsImpl.cpp
    JOBJobEntryImpl.cpp
    JOBJobsCollectionFactory.cpp
    JOBJobsCollectionImpl.cpp
    JOBLogsEntryImpl.cpp
    JOBModelerEntryImpl.cpp
    JOBNetworkEntryImpl.cpp
    JOBOutputsEntryImpl.cpp
    JOBSimulationEntryImpl.cpp
    JOBSolverEntryImpl.cpp
    JOBTimelineEntryImpl.cpp
    JOBModelsDirEntryImpl.cpp
    )

SET(API_JOB_INCLUDE_HEADERS
    JOBXmlHandler.h
    JOBXmlImporter.h
    JOBExport.h
    JOBAppenderEntry.h
    JOBConstraintsEntry.h
    JOBCurvesEntry.h
    JOBDynModelsEntry.h
    JOBFinalStateEntry.h
    JOBInitValuesEntry.h
    JOBInitialStateEntry.h
    JOBIterators.h
    JOBImporter.h
    JOBJobEntry.h
    JOBJobsCollectionFactory.h
    JOBJobsCollection.h
    JOBJobsCollectionImpl.h
    JOBLogsEntry.h
    JOBModelerEntry.h
    JOBNetworkEntry.h
    JOBOutputsEntry.h
    JOBSimulationEntry.h
    JOBSolverEntry.h
    JOBTimelineEntry.h
    JOBModelsDirEntry.h
    )

INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIR}
                    ${LIBXML_INCLUDE_DIR}
                   )

INCLUDE_DIRECTORIES(../../Common
                   )

ADD_LIBRARY(dynawo_API_JOB SHARED ${API_JOB_SOURCES})


TARGET_LINK_LIBRARIES(dynawo_API_JOB
  XMLSAXFormatter
  XMLSAXParser
  dynawo_Common
  )
SET_TARGET_PROPERTIES(dynawo_API_JOB PROPERTIES VERSION ${API_JOB_VERSION_STRING}
                                           SOVERSION ${API_JOB_VERSION_MAJOR})

INSTALL(TARGETS dynawo_API_JOB DESTINATION ${libdir})
INSTALL(FILES ${API_JOB_INCLUDE_HEADERS} DESTINATION ${includedir})

