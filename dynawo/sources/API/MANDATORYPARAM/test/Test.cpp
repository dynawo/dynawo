//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file API/MANDATORYPARAM/test/Test.cpp
 * @brief Unit tests for API_MANDATORYPARAM
 */

#include "gtest_dynawo.h"

#include "MANDATORYPARAMParameter.h"
#include "MANDATORYPARAMCollection.h"
#include "MANDATORYPARAMXmlImporter.h"
#include "MANDATORYPARAMXmlExporter.h"

INIT_XML_DYNAWO;

namespace mandatoryParameters {

//-----------------------------------------------------
// TEST Parameter getters
//-----------------------------------------------------

TEST(APIMandatoryParamTest, ParameterGetters) {
  Parameter param("RPu", "DOUBLE");
  ASSERT_EQ(param.getName(), "RPu");
  ASSERT_EQ(param.getType(), "DOUBLE");
}

//-----------------------------------------------------
// TEST Collection addParameter and getParameters
//-----------------------------------------------------

TEST(APIMandatoryParamTest, CollectionAddAndGet) {
  Collection collection;

  ASSERT_TRUE(collection.getParameters().empty());

  collection.addParameter("RPu", "DOUBLE");
  collection.addParameter("NbSwitches", "INT");
  collection.addParameter("IsConnected", "BOOL");
  collection.addParameter("Label", "STRING");

  ASSERT_EQ(collection.getParameters().size(), 4u);
  ASSERT_EQ(collection.getParameters()[0].getName(), "RPu");
  ASSERT_EQ(collection.getParameters()[0].getType(), "DOUBLE");
  ASSERT_EQ(collection.getParameters()[1].getName(), "NbSwitches");
  ASSERT_EQ(collection.getParameters()[1].getType(), "INT");
  ASSERT_EQ(collection.getParameters()[2].getName(), "IsConnected");
  ASSERT_EQ(collection.getParameters()[2].getType(), "BOOL");
  ASSERT_EQ(collection.getParameters()[3].getName(), "Label");
  ASSERT_EQ(collection.getParameters()[3].getType(), "STRING");
}

//-----------------------------------------------------
// TEST export then import round-trip
//-----------------------------------------------------

TEST(APIMandatoryParamTest, ExportImport) {
  Collection collection;
  collection.addParameter("RPu", "DOUBLE");
  collection.addParameter("NbSwitches", "INT");
  collection.addParameter("IsConnected", "BOOL");
  collection.addParameter("Label", "STRING");

  const std::string fileName = "MandatoryParamRoundTrip.mandatoryParam";
  XmlExporter exporter;
  ASSERT_NO_THROW(exporter.exportToFile(collection, fileName));

  XmlImporter importer;
  std::shared_ptr<Collection> imported;
  ASSERT_NO_THROW(imported = importer.importFromFile(fileName));

  ASSERT_EQ(imported->getParameters().size(), collection.getParameters().size());
  for (std::size_t i = 0; i < collection.getParameters().size(); ++i) {
    ASSERT_EQ(imported->getParameters()[i].getName(), collection.getParameters()[i].getName());
    ASSERT_EQ(imported->getParameters()[i].getType(), collection.getParameters()[i].getType());
  }
}

}  // namespace mandatoryParameters
