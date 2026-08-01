//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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
 * @file API/PAR/test/TestXmlExporter.cpp
 * @brief Unit tests for API_PAR
 */

#include "gtest_dynawo.h"

#include "PARXmlImporter.h"
#include "PARXmlExporter.h"
#include "PARParametersSetCollection.h"
#include "TestUtil.h"

#include <memory>


namespace parameters {

//-----------------------------------------------------
// TEST export file and compare with expected file
//-----------------------------------------------------

TEST(APIPARTest, XmlExporter) {
  XmlImporter importer;
  std::shared_ptr<ParametersSetCollection> collection;
  ASSERT_NO_THROW(collection = importer.importFromFile("res/fileToImport.par"));

  // Export the collection in xml format
  XmlExporter exporter;
  ASSERT_NO_THROW(exporter.exportToFile(collection, "exportedFile.par"));
  ASSERT_NO_THROW(exporter.exportToFile(collection, "exportedFile.par", "ISO-8859-1"));
  ASSERT_EQ(compareFiles("exportedFile.par", "res/exportedFile.par"), true);
}

}  // namespace parameters
