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
 * @file API/CSTR/test/TestExporter.cpp
 * @brief Unit tests for API_CSTR exporter
 *
 */

#include "gtest_dynawo.h"

#include "CSTRConstraintsCollectionFactory.h"
#include "CSTRConstraintsCollection.h"
#include "CSTRConstraintFactory.h"
#include "CSTRXmlExporter.h"
#include "CSTRJsonExporter.h"

namespace constraints {

TEST(APICSTRTest, ConstraintsCollectionExporter) {
  std::shared_ptr<ConstraintsCollection> constraintsCollection1 = ConstraintsCollectionFactory::newInstance("Constraints");

  constraintsCollection1->addConstraint("model", "USupUmax", 80, CONSTRAINT_BEGIN, "Bus");
  constraintsCollection1->addConstraint("model", "OverloadUp", 80, CONSTRAINT_BEGIN, "Line");
  constraintsCollection1->addConstraint("model", "PATL", 80, CONSTRAINT_BEGIN, "Line");

  int side = 1;
  double acceptableDuration = 60;
  constraintsCollection1->addConstraint("modelDetail", "desc UInfUmin", 90, CONSTRAINT_BEGIN, "Bus",
    ConstraintData(ConstraintData::UInfUmin, 132.0, 130.0));
  constraintsCollection1->addConstraint("modelDetail", "desc OverloadUp", 90, CONSTRAINT_BEGIN, "Line",
    ConstraintData(ConstraintData::OverloadUp, 1000, 1001, side, acceptableDuration));
  constraintsCollection1->addConstraint("modelDetail", "desc PATL", 90, CONSTRAINT_BEGIN, "Line",
    ConstraintData(ConstraintData::PATL, 1100, 1111, side));

  XmlExporter xmlExporter;
  {
    std::stringstream ss;
    xmlExporter.exportToStream(constraintsCollection1, ss);
    ASSERT_EQ(ss.str(), "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" standalone=\"no\"?>\n"
        "<constraints xmlns=\"http://www.rte-france.com/dynawo\">\n  "
        "<constraint modelName=\"modelDetail\" description=\"desc OverloadUp\" time=\"90.000000\" type=\"Line\" "
        "kind=\"OverloadUp\" limit=\"1000\" value=\"1001\" side=\"1\" acceptableDuration=\"60\"/>\n  "
        "<constraint modelName=\"modelDetail\" description=\"desc PATL\" time=\"90.000000\" type=\"Line\" "
        "kind=\"PATL\" limit=\"1100\" value=\"1111\" side=\"1\"/>\n  "
        "<constraint modelName=\"modelDetail\" description=\"desc UInfUmin\" time=\"90.000000\" type=\"Bus\" "
        "kind=\"UInfUmin\" limit=\"132\" value=\"130\"/>\n  "
        "<constraint modelName=\"model\" description=\"OverloadUp\" time=\"80.000000\" type=\"Line\"/>\n  "
        "<constraint modelName=\"model\" description=\"PATL\" time=\"80.000000\" type=\"Line\"/>\n  "
        "<constraint modelName=\"model\" description=\"USupUmax\" time=\"80.000000\" type=\"Bus\"/>\n"
        "</constraints>\n");
  }

  JsonExporter jsonExporter;
  {
    std::stringstream ss;
    jsonExporter.exportToStream(constraintsCollection1, ss);
    ASSERT_EQ(ss.str(), "{\"constraints\":["
      "{\"modelName\":\"modelDetail\",\"description\":\"desc OverloadUp\",\"time\":\"90.000000\",\"type\":\"Line\","
      "\"kind\":\"OverloadUp\",\"limit\":\"1000\",\"value\":\"1001\",\"side\":\"1\",\"acceptableDuration\":\"60\"},"
      "{\"modelName\":\"modelDetail\",\"description\":\"desc PATL\",\"time\":\"90.000000\",\"type\":\"Line\","
      "\"kind\":\"PATL\",\"limit\":\"1100\",\"value\":\"1111\",\"side\":\"1\"},"
      "{\"modelName\":\"modelDetail\",\"description\":\"desc UInfUmin\",\"time\":\"90.000000\",\"type\":\"Bus\","
      "\"kind\":\"UInfUmin\",\"limit\":\"132\",\"value\":\"130\"},"
      "{\"modelName\":\"model\",\"description\":\"OverloadUp\",\"time\":\"80.000000\",\"type\":\"Line\"},"
      "{\"modelName\":\"model\",\"description\":\"PATL\",\"time\":\"80.000000\",\"type\":\"Line\"},"
      "{\"modelName\":\"model\",\"description\":\"USupUmax\",\"time\":\"80.000000\",\"type\":\"Bus\"}]}\n");
  }
}
}  // namespace constraints
