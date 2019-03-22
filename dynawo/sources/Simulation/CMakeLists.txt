# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

SET(SIM_VERSION_STRING ${DYNAWO_VERSION_STRING})
SET(SIM_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

SET(SIM_SOURCES
    DYNSimulation.cpp
    DYNSimulationLauncher.cpp
    )

SET(SIM_INCLUDE_HEADERS
    DYNSimulation.h
    DYNSimulationLauncher.h
    )

INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIR}
                    ${SUNDIALS_INCLUDE_DIR}
                    ${KLU_INCLUDE_DIR}
                    ${libZIP_INCLUDE_DIR}
                    ${LibXML_INCLUDE_DIR}
                    ${LibIIDM_CORE_INCLUDE_DIR}
                    ${LibIIDM_EXT_ACTIVESEASON_INCLUDE_DIR}
                    ${LibIIDM_EXT_CURRENTLIMITSPERSEASON_INCLUDE_DIR}
                    ${LibIIDM_EXT_STANDBYAUTOMATON_INCLUDE_DIR}
                    ${LibIIDM_EXT_GENERATORACTIVEPOWERCONTROL_INCLUDE_DIR}
                    ${LibIIDM_EXT_BUSBARSECTIONPOSITION_INCLUDE_DIR}
                    ${LibIIDM_EXT_CONNECTABLEPOSITION_INCLUDE_DIR}
                    ${LibIIDM_EXT_HVDCANGLEDROOPACTIVEPOWERCONTROL_INCLUDE_DIR}
                    ${LibIIDM_EXT_HVDCOPERATORACTIVEPOWERRANGE_INCLUDE_DIR}
                    ${LibIIDM_EXT_GENERATORENTSOECATEGORY_INCLUDE_DIR}
                    ${LibIIDM_EXT_GENERATORSTARTUP_INCLUDE_DIR}
                    ${LibIIDM_EXT_LOADDETAIL_INCLUDE_DIR}
                    )

INCLUDE_DIRECTORIES(../API/CRV
                    ../API/TL
                    ../API/FS
                    ../API/CSTR
                    ../API/JOB
                    ../API/PAR
                    ../Common
                    ../Modeler/Common
                    ../Modeler/DataInterface
                    ../Solvers/Common
                    ../
                    )

ADD_LIBRARY(dynawo_Simulation ${LIBRARY_TYPE} ${SIM_SOURCES})

TARGET_LINK_LIBRARIES(dynawo_Simulation
                      dynawo_SimulationCommon
                      dynawo_API_TL
                      dynawo_API_CRV
                      dynawo_API_FS
                      dynawo_API_CSTR
                      dynawo_API_PAR
                      dynawo_API_JOB
                      dynawo_SolverCommon
                      dynawo_Common
                      dynawo_ModelerCommon
                      dynawo_DataInterface
                      ${libZIP_LIBRARY}
                      ${Boost_SERIALIZATION_LIBRARY}
                      XMLSAXFormatter${LibXML_LINK_SUFFIX}
                      XMLSAXParser${LibXML_LINK_SUFFIX}
                      iidm-xml
                      iidm-ext-activeseason-xml
                      iidm-ext-currentlimitsperseason-xml
                      iidm-ext-standbyautomaton-xml
                      iidm-ext-generatoractivepowercontrol-xml
                      iidm-ext-busbarsectionposition-xml
                      iidm-ext-connectableposition-xml
                      iidm-ext-hvdcangledroopactivepowercontrol-xml
                      iidm-ext-hvdcoperatoractivepowerrange-xml
                      iidm-ext-generatorentsoecategory-xml
                      iidm-ext-generatorstartup-xml
                      iidm-ext-loaddetail-xml
                      )
SET_TARGET_PROPERTIES(dynawo_Simulation PROPERTIES VERSION ${SIM_VERSION_STRING}
                                     SOVERSION ${SIM_VERSION_MAJOR})

INSTALL(TARGETS dynawo_Simulation DESTINATION ${libdir})
INSTALL(FILES ${SIM_INCLUDE_HEADERS} DESTINATION ${includedir})


SET(SIMCOMMON_VERSION_STRING ${DYNAWO_VERSION_STRING})
SET(SIMCOMMON_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

SET(SIMCOMMON_SOURCES
    DYNSignalHandler.cpp
    DYNSimulationContext.cpp
    )

SET(SIMCOMMON_INCLUDE_HEADERS
    DYNSignalHandler.h
    DYNSimulationContext.h
    )

ADD_LIBRARY(dynawo_SimulationCommon ${LIBRARY_TYPE} ${SIMCOMMON_SOURCES})

#TARGET_LINK_LIBRARIES(dynawo_SimulationCommon)

SET_TARGET_PROPERTIES(dynawo_SimulationCommon PROPERTIES VERSION ${SIMCOMMON_VERSION_STRING}
                                     SOVERSION ${SIMCOMMON_VERSION_MAJOR})

INSTALL(TARGETS dynawo_SimulationCommon DESTINATION ${libdir})
INSTALL(FILES ${SIMCOMMON_INCLUDE_HEADERS} DESTINATION ${includedir})
