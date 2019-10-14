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
SET(API_CRV_VERSION_STRING ${DYNAWO_VERSION_STRING})
SET(API_CRV_VERSION_MAJOR ${DYNAWO_VERSION_MAJOR})

SET(API_CRV_SHARED
  xsd/curvesInput.xsd
  xsd/curvesOutput.xsd
  )

INSTALL(FILES ${API_CRV_SHARED} DESTINATION ${SHAREDIR_NAME}/xsd/)

SET(API_CRV_SOURCES
  CRVCurve.cpp
  CRVCurveImpl.cpp
  CRVCurveFactory.cpp
  CRVPointImpl.cpp
  CRVPointFactory.cpp
  CRVCurvesCollection.cpp
  CRVCurvesCollectionImpl.cpp
  CRVCurvesCollectionFactory.cpp
  CRVXmlHandler.cpp
  CRVXmlImporter.cpp
  CRVXmlExporter.cpp
  CRVCsvExporter.cpp
  )

SET(API_CRV_INCLUDE_HEADERS
  CRVCurve.h
  CRVCurveFactory.h
  CRVPoint.h
  CRVPointFactory.h
  CRVCurvesCollection.h
  CRVCurvesCollectionFactory.h
  CRVImporter.h
  CRVXmlImporter.h
  CRVExporter.h
  CRVXmlExporter.h
  CRVCsvExporter.h
  )

ADD_LIBRARY(dynawo_API_CRV ${LIBRARY_TYPE} ${API_CRV_SOURCES})

TARGET_INCLUDE_DIRECTORIES(dynawo_API_CRV
  INTERFACE
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
      $<INSTALL_INTERFACE:${INCLUDEDIR_NAME}>
  )

TARGET_LINK_LIBRARIES(dynawo_API_CRV
  XMLSAXFormatter${LibXML_LINK_SUFFIX}
  XMLSAXParser${LibXML_LINK_SUFFIX}
  dynawo_Common
  )

SET_TARGET_PROPERTIES(dynawo_API_CRV PROPERTIES VERSION ${API_CRV_VERSION_STRING}
                                              SOVERSION ${API_CRV_VERSION_MAJOR})

INSTALL(TARGETS dynawo_API_CRV EXPORT dynawo-targets DESTINATION ${LIBDIR_NAME})
INSTALL(FILES ${API_CRV_INCLUDE_HEADERS} DESTINATION ${INCLUDEDIR_NAME})
