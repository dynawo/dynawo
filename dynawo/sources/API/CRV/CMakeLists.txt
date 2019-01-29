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

INSTALL(FILES ${API_CRV_SHARED} DESTINATION ${sharedir}/xsd/)

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
  CRVExport.h
  CRVExporter.h
  CRVXmlExporter.h
  CRVCsvExporter.h
  )

INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIR}
                    ${LIBXML_INCLUDE_DIR}
                    )

INCLUDE_DIRECTORIES(../../Common )

ADD_LIBRARY(dynawo_API_CRV SHARED ${API_CRV_SOURCES})

TARGET_LINK_LIBRARIES(dynawo_API_CRV
    XMLSAXFormatter
    XMLSAXParser
    dynawo_Common
    )
SET_TARGET_PROPERTIES(dynawo_API_CRV PROPERTIES VERSION ${API_CRV_VERSION_STRING}
                                              SOVERSION ${API_CRV_VERSION_MAJOR})

INSTALL(TARGETS dynawo_API_CRV DESTINATION ${libdir})
INSTALL(FILES ${API_CRV_INCLUDE_HEADERS} DESTINATION ${includedir})

