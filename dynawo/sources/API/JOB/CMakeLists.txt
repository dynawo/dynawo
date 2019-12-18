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
set(API_JOB_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(API_JOB_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(API_JOB_SHARED
    xsd/jobs.xsd
    )

install(FILES ${API_JOB_SHARED} DESTINATION ${SHAREDIR_NAME}/xsd/)

set(API_JOB_SOURCES
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

set(API_JOB_INCLUDE_HEADERS
    JOBXmlHandler.h
    JOBXmlImporter.h
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

add_library(dynawo_API_JOB ${LIBRARY_TYPE} ${API_JOB_SOURCES})

target_include_directories(dynawo_API_JOB
    INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
    )

target_link_libraries(dynawo_API_JOB
    XMLSAXParser${LibXML_LINK_SUFFIX}
    dynawo_Common
    )

set_target_properties(dynawo_API_JOB PROPERTIES VERSION ${API_JOB_VERSION_STRING}
                                              SOVERSION ${API_JOB_VERSION_MAJOR})

install(TARGETS dynawo_API_JOB EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${API_JOB_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
