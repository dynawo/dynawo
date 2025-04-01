//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file API/CRV/test/Test.cpp
 * @brief Unit tests for API_CRV
 *
 */

#include "gtest_dynawo.h"

#include "CRVCurve.h"
#include "CRVCurveFactory.h"
#include "CRVPoint.h"
#include "CRVCurvesCollectionFactory.h"
#include "CRVCurvesCollection.h"
#include "CRVXmlExporter.h"
#include "CRVCsvExporter.h"

namespace curves {

TEST(APICRVTest, test1) {
  // Create new curve collection
  boost::shared_ptr<CurvesCollection> curves = CurvesCollectionFactory::newInstance("Curves");

  boost::shared_ptr<Curve> curve1 = CurveFactory::newCurve();
  curve1->setModelName("model1");
  curve1->setVariable("variable1");
  boost::shared_ptr<Curve> curve2 = CurveFactory::newCurve();
  curve2->setModelName("model2");
  curve2->setVariable("variable2");

  // add curves to curve collection
  curves->add(curve1);
  curves->add(curve2);

  // associate curves to variable and buffer variable
  std::vector<double> variables;
  variables.assign(2, 0);

  int i = 0;
  for (CurvesCollection::iterator itCurve = curves->begin();
          itCurve != curves->end();
          ++itCurve) {
    (*itCurve)->setFoundVariableName("model_variable");
    (*itCurve)->setBuffer(&variables[i]);
    if (i == 0)
      (*itCurve)->setNegated(true);  // curve point value = -1*variables value
    else
      (*itCurve)->setNegated(false);
    ++i;
  }

  // simulate curve and curve update
  for (i = 0; i < 10; ++i) {
    variables[0] = i;
    variables[1] = i*i;
    int currentTime = i * 10;

    curves->updateCurves(currentTime);
  }

  // export the curves in xml format
  boost::shared_ptr<XmlExporter> xmlExporter = boost::shared_ptr<XmlExporter>(new XmlExporter());
  ASSERT_NO_THROW(xmlExporter->exportToFile(curves, "testXmlCurvesExport.crv"));

  // export the curves in xml format
  boost::shared_ptr<CsvExporter> csvExporter = boost::shared_ptr<CsvExporter>(new CsvExporter());
  ASSERT_NO_THROW(csvExporter->exportToFile(curves, "testCsvCurvesExport.csv"));

  // throw
  ASSERT_THROW_DYNAWO(csvExporter->exportToFile(curves, ""), DYN::Error::API, DYN::KeyError_t::FileGenerationFailed);
  ASSERT_THROW_DYNAWO(xmlExporter->exportToFile(curves, ""), DYN::Error::API, DYN::KeyError_t::FileGenerationFailed);
}

}  // namespace curves
