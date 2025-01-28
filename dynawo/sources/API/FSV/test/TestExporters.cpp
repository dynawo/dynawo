//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file API/FSV/test/TestExporters.cpp
 * @brief Unit tests for API_FSV exporters
 *
 */

#include "FSVFinalStateValue.h"
#include "FSVFinalStateValueFactory.h"
#include "FSVFinalStateValuesCollection.h"
#include "FSVFinalStateValuesCollectionFactory.h"
#include "FSVXmlExporter.h"
#include "FSVCsvExporter.h"
#include "FSVTxtExporter.h"
#include "gtest_dynawo.h"

namespace finalStateValues {

//-----------------------------------------------------
// TEST build FinalStateValuesCollection
//-----------------------------------------------------

TEST(APIFSVTest, FinalStateValuesCollectionXmlExporter) {
  boost::shared_ptr<FinalStateValuesCollection> finalStateValuesCollection1 = FinalStateValuesCollectionFactory::newInstance("FinalStateValues");

  std::unique_ptr<FinalStateValue> finalStateValue1 = FinalStateValueFactory::newFinalStateValue();

  finalStateValue1->setModelName("model1");
  finalStateValue1->setVariable("variable1");
  finalStateValue1->setValue(5.0);
  finalStateValuesCollection1->add(std::move(finalStateValue1));

  std::unique_ptr<FinalStateValue> finalStateValue2 = FinalStateValueFactory::newFinalStateValue();

  finalStateValue2->setVariable("variable2");
  finalStateValue2->setValue(7.0);
  finalStateValuesCollection1->add(std::move(finalStateValue2));

  XmlExporter exporter;
  std::stringstream ss;
  exporter.exportToStream(finalStateValuesCollection1, ss);
  ASSERT_EQ(ss.str(),
            "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" "
            "standalone=\"no\"?>\n<finalStateValuesOutput "
            "xmlns=\"http://www.rte-france.com/dynawo\">\n  <finalStateValue model=\"model1\" "
            "variable=\"variable1\" value=\"5.000000\"/>\n  "
            "<finalStateValue model=\"\" variable=\"variable2\" value=\"7.000000\"/>\n"
            "</finalStateValuesOutput>\n");
}

TEST(APIFSVTest, FinalStateValuesCollectionCsvExporter) {
  boost::shared_ptr<FinalStateValuesCollection> finalStateValuesCollection1 = FinalStateValuesCollectionFactory::newInstance("FinalStateValues");

  std::unique_ptr<FinalStateValue> finalStateValue1 = FinalStateValueFactory::newFinalStateValue();

  finalStateValue1->setModelName("model1");
  finalStateValue1->setVariable("variable1");
  finalStateValue1->setValue(5.0);
  finalStateValuesCollection1->add(std::move(finalStateValue1));

  std::unique_ptr<FinalStateValue> finalStateValue2 = FinalStateValueFactory::newFinalStateValue();

  finalStateValue2->setVariable("variable2");
  finalStateValue2->setValue(7.0);
  finalStateValuesCollection1->add(std::move(finalStateValue2));

  CsvExporter exporter;
  std::stringstream ss;
  exporter.exportToStream(finalStateValuesCollection1, ss);
  ASSERT_EQ(ss.str(), "model;variable;value;\nmodel1;variable1;5.000000;\n;variable2;7.000000;\n");
}

TEST(APIFSVTest, FinalStateValuesCollectionTxtExporter) {
  boost::shared_ptr<FinalStateValuesCollection> finalStateValuesCollection1 = FinalStateValuesCollectionFactory::newInstance("FinalStateValues");

  std::unique_ptr<FinalStateValue> finalStateValue1 = FinalStateValueFactory::newFinalStateValue();

  finalStateValue1->setModelName("model1");
  finalStateValue1->setVariable("variable1");
  finalStateValue1->setValue(5.0);
  finalStateValuesCollection1->add(std::move(finalStateValue1));

  std::unique_ptr<FinalStateValue> finalStateValue2 = FinalStateValueFactory::newFinalStateValue();

  finalStateValue2->setVariable("variable2");
  finalStateValue2->setValue(7.0);
  finalStateValuesCollection1->add(std::move(finalStateValue2));

  TxtExporter exporter;
  std::stringstream ss;
  exporter.exportToStream(finalStateValuesCollection1, ss);
  ASSERT_EQ(ss.str(), "model | variable | value\nmodel1 | variable1 | 5.000000\n | variable2 | 7.000000\n");
}

}  // namespace finalStateValues
