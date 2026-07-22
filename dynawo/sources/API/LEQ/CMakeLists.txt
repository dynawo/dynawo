# Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite
# of simulation tools for power systems.

# API Version
set(API_LEQ_VERSION_STRING ${DYNAWO_VERSION_STRING})
set(API_LEQ_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

set(API_LEQ_SHARED
  xsd/lostEquipments.xsd
  )

install(FILES ${API_LEQ_SHARED} DESTINATION ${SHAREDIR_NAME}/xsd/)

set(API_LEQ_SOURCES
  LEQLostEquipment.cpp
  LEQLostEquipmentFactory.cpp
  LEQLostEquipmentsCollection.cpp
  LEQLostEquipmentsCollectionFactory.cpp
  LEQXmlExporter.cpp
  )

set(API_LEQ_INCLUDE_HEADERS
  LEQLostEquipment.h
  LEQLostEquipmentFactory.h
  LEQLostEquipmentsCollection.h
  LEQLostEquipmentsCollectionFactory.h
  LEQExporter.h
  LEQXmlExporter.h
  )

add_library(dynawo_API_LEQ SHARED ${API_LEQ_SOURCES})

target_include_directories(dynawo_API_LEQ
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )
target_include_directories(dynawo_API_LEQ SYSTEM
  PRIVATE
    $<TARGET_PROPERTY:Boost::boost,INTERFACE_INCLUDE_DIRECTORIES>
  )

target_link_libraries(dynawo_API_LEQ
  PUBLIC
    XMLSAXFormatter${LibXML_LINK_SUFFIX}
  PRIVATE
    dynawo_Common
    )

set_target_properties(dynawo_API_LEQ PROPERTIES VERSION ${API_LEQ_VERSION_STRING}
                                               SOVERSION ${API_LEQ_VERSION_MAJOR})

install(TARGETS dynawo_API_LEQ EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
install(FILES ${API_LEQ_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})

if(BUILD_TESTS OR BUILD_TESTS_COVERAGE)
  add_subdirectory(test)
endif()
