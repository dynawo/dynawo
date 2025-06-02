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

#include "make_unique.hpp"

namespace curves {

TEST(APICRVTest, test1) {
  // Create new curve collection
  std::shared_ptr<CurvesCollection> curves = CurvesCollectionFactory::newInstance("Curves");

  std::unique_ptr<Curve> curve1 = CurveFactory::newCurve();
  curve1->setModelName("model1");
  curve1->setVariable("variable1");
  std::unique_ptr<Curve> curve2 = CurveFactory::newCurve();
  curve2->setModelName("model2");
  curve2->setVariable("variable2");

  // add curves to curve collection
  curves->add(std::move(curve1));
  curves->add(std::move(curve2));

  // associate curves to variable and buffer variable
  std::vector<double> variables;
  variables.assign(2, 0);

  int i = 0;
  for (const auto& curve : curves->getCurves()) {
    curve->setFoundVariableName("model_variable");
    curve->setBuffer(&variables[i]);
    if (i == 0)
      curve->setNegated(true);  // curve point value = -1*variables value
    else
      curve->setNegated(false);
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
  std::unique_ptr<XmlExporter> xmlExporter = DYN::make_unique<XmlExporter>();
  ASSERT_NO_THROW(xmlExporter->exportToFile(curves, "testXmlCurvesExport.crv"));

  // export the curves in xml format
  std::unique_ptr<CsvExporter> csvExporter = DYN::make_unique<CsvExporter>();
  ASSERT_NO_THROW(csvExporter->exportToFile(curves, "testCsvCurvesExport.csv"));

  // throw
  ASSERT_THROW_DYNAWO(csvExporter->exportToFile(curves, ""), DYN::Error::API, DYN::KeyError_t::FileGenerationFailed);
  ASSERT_THROW_DYNAWO(xmlExporter->exportToFile(curves, ""), DYN::Error::API, DYN::KeyError_t::FileGenerationFailed);
}

}  // namespace curves
