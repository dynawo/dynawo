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
 * @file API/CRV/test/TestExporters.cpp
 * @brief Unit tests for API_CRV exporters
 *
 */

#include "gtest_dynawo.h"

#include "CRVCurvesCollectionFactory.h"
#include "CRVCurvesCollection.h"
#include "CRVCurveFactory.h"
#include "CRVCurve.h"
#include "CRVCsvExporter.h"
#include "CRVXmlExporter.h"

namespace curves {

//-----------------------------------------------------
// TEST build CurvesCollection
//-----------------------------------------------------

TEST(APICRVTest, CurvesCollectionCsvExporter) {
  boost::shared_ptr<CurvesCollection> curvesCollection1 = CurvesCollectionFactory::newInstance("Curves");

  boost::shared_ptr<Curve> curve1 = CurveFactory::newCurve();

  curve1->setVariable("variable1");
  curve1->setAvailable(true);
  curve1->setNegated(false);
  curve1->setAsParameterCurve(true);
  std::vector<double> variables;
  variables.assign(2, 1);
  curve1->setBuffer(&variables[0]);
  curvesCollection1->add(curve1);

  // update parameter curve (set the value of parameter curve to zero)
  ASSERT_NO_THROW(curve1->update(0));
  ASSERT_NO_THROW(curve1->update(1));
  ASSERT_NO_THROW(curve1->update(2));

  // test updateParameterCurveValue (set the value to a given value)
  ASSERT_NO_THROW(curve1->updateParameterCurveValue("variable1", 5));

  boost::shared_ptr<Curve> curve2 = CurveFactory::newCurve();

  curve2->setVariable("variable2");
  curve2->setAvailable(true);
  curve2->setNegated(true);
  curve2->setAsParameterCurve(false);
  std::vector<double> variables2;
  variables2.assign(3, 4);
  curve2->setBuffer(&variables2[0]);
  curvesCollection1->add(curve2);
  ASSERT_NO_THROW(curve2->update(0));
  ASSERT_NO_THROW(curve2->update(1));
  ASSERT_NO_THROW(curve2->update(2));
  ASSERT_NO_THROW(curve2->updateParameterCurveValue("variable1", 7));

  CsvExporter exporter;
  std::stringstream ss;
  exporter.exportToStream(curvesCollection1, ss);
  ASSERT_EQ(ss.str(), "time;_variable1;_variable2;\n0;5.000000;7.000000;\n1;5.000000;7.000000;\n2;5.000000;7.000000;\n");
}

TEST(APICRVTest, CurvesCollectionXmlExporter) {
  boost::shared_ptr<CurvesCollection> curvesCollection1 = CurvesCollectionFactory::newInstance("Curves");

  boost::shared_ptr<Curve> curve1 = CurveFactory::newCurve();

  curve1->setVariable("variable1");
  curve1->setAvailable(true);
  curve1->setNegated(false);
  curve1->setAsParameterCurve(true);
  std::vector<double> variables;
  variables.assign(2, 1);
  curve1->setBuffer(&variables[0]);
  curvesCollection1->add(curve1);

  // update parameter curve (set the value of parameter curve to zero)
  ASSERT_NO_THROW(curve1->update(0));
  ASSERT_NO_THROW(curve1->update(1));
  ASSERT_NO_THROW(curve1->update(2));

  // test updateParameterCurveValue (set the value to a given value)
  ASSERT_NO_THROW(curve1->updateParameterCurveValue("variable1", 5));

  boost::shared_ptr<Curve> curve2 = CurveFactory::newCurve();

  curve2->setVariable("variable2");
  curve2->setAvailable(true);
  curve2->setNegated(true);
  curve2->setAsParameterCurve(false);
  std::vector<double> variables2;
  variables2.assign(3, 4);
  curve2->setBuffer(&variables2[0]);
  curvesCollection1->add(curve2);
  ASSERT_NO_THROW(curve2->update(0));
  ASSERT_NO_THROW(curve2->update(1));
  ASSERT_NO_THROW(curve2->update(2));
  ASSERT_NO_THROW(curve2->updateParameterCurveValue("variable1", 7));

  XmlExporter exporter;
  std::stringstream ss;
  exporter.exportToStream(curvesCollection1, ss);
  ASSERT_EQ(ss.str(), "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" standalone=\"no\"?>\n<curvesOutput "
      "xmlns=\"http://www.rte-france.com/dynawo\">\n  <curve model=\"\" variable=\"variable1\">\n    "
      "<point time=\"0.000000\" value=\"5.000000\"/>\n    "
      "<point time=\"1.000000\" value=\"5.000000\"/>\n    "
      "<point time=\"2.000000\" value=\"5.000000\"/>\n  "
      "</curve>\n  <curve model=\"\" variable=\"variable2\">\n    "
      "<point time=\"0.000000\" value=\"7.000000\"/>\n    "
      "<point time=\"1.000000\" value=\"7.000000\"/>\n    "
      "<point time=\"2.000000\" value=\"7.000000\"/>\n  "
      "</curve>\n"
      "</curvesOutput>\n");
}

}  // namespace curves
