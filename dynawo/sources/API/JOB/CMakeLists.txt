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
    JOBAppenderEntry.cpp
    JOBAppenderEntryFactory.cpp
    JOBConstraintsEntry.cpp
    JOBCurvesEntry.cpp
    JOBDynModelsEntry.cpp
    JOBDynModelsEntryFactory.cpp
    JOBFinalStateEntry.cpp
    JOBFinalStateEntryFactory.cpp
    JOBFinalStateValuesEntry.cpp
    JOBFinalValuesEntry.cpp
    JOBInitValuesEntry.cpp
    JOBInitialStateEntry.cpp
    JOBInitialStateEntryFactory.cpp
    JOBJobEntry.cpp
    JOBJobsCollectionFactory.cpp
    JOBJobsCollection.cpp
    JOBLocalInitEntry.cpp
    JOBLogsEntry.cpp
    JOBLostEquipmentsEntry.cpp
    JOBModelerEntry.cpp
    JOBNetworkEntry.cpp
    JOBOutputsEntry.cpp
    JOBSimulationEntry.cpp
    JOBSolverEntry.cpp
    JOBTimelineEntry.cpp
    JOBTimetableEntry.cpp
    JOBModelsDirEntry.cpp
    JOBJobEntryFactory.cpp
    JOBLogsEntryFactory.cpp
    JOBModelerEntryFactory.cpp
    JOBNetworkEntryFactory.cpp
    JOBOutputsEntryFactory.cpp
    JOBSimulationEntryFactory.cpp
    JOBSolverEntryFactory.cpp
    JOBModelsDirEntryFactory.cpp
    JOBChannelsEntry.cpp
    JOBChannelEntry.cpp
    JOBClockEntry.cpp
    JOBOutputStreamsEntry.cpp
    JOBOutputStreamEntry.cpp
    )

set(API_JOB_INCLUDE_HEADERS
    JOBXmlHandler.h
    JOBXmlImporter.h
    JOBAppenderEntry.h
    JOBAppenderEntryFactory.h
    JOBConstraintsEntry.h
    JOBCurvesEntry.h
    JOBDynModelsEntry.h
    JOBDynModelsEntryFactory.h
    JOBFinalStateEntry.h
    JOBFinalStateEntryFactory.h
    JOBFinalStateValuesEntry.h
    JOBFinalValuesEntry.h
    JOBInitValuesEntry.h
    JOBInitialStateEntry.h
    JOBInitialStateEntryFactory.h
    JOBImporter.h
    JOBJobEntry.h
    JOBJobEntryFactory.h
    JOBJobsCollectionFactory.h
    JOBJobsCollection.h
    JOBJobsCollection.h
    JOBLocalInitEntry.h
    JOBLogsEntry.h
    JOBLostEquipmentsEntry.h
    JOBModelerEntry.h
    JOBNetworkEntry.h
    JOBOutputsEntry.h
    JOBSimulationEntry.h
    JOBSolverEntry.h
    JOBLogsEntryFactory.h
    JOBModelerEntryFactory.h
    JOBNetworkEntryFactory.h
    JOBOutputsEntryFactory.h
    JOBSimulationEntryFactory.h
    JOBSolverEntryFactory.h
    JOBModelsDirEntryFactory.h
    JOBTimelineEntry.h
    JOBTimetableEntry.h
    JOBModelsDirEntry.h
    )

add_library(dynawo_API_JOB SHARED ${API_JOB_SOURCES})

target_include_directories(dynawo_API_JOB
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )

target_include_directories(dynawo_API_JOB SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_API_JOB
  PUBLIC
    XMLSAXParser${LibXML_LINK_SUFFIX}
  PRIVATE
    dynawo_Common
    Boost::system
    )

set_target_properties(dynawo_API_JOB PROPERTIES VERSION ${API_JOB_VERSION_STRING}
                                              SOVERSION ${API_JOB_VERSION_MAJOR})

install(TARGETS dynawo_API_JOB EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${API_JOB_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
