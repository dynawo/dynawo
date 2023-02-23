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
 * @file API/DYD/test/Test.cpp
 * @brief Unit tests for API_DYD
 *
 */
#include "gtest_dynawo.h"

#include "DYDXmlImporter.h"
#include "DYDXmlExporter.h"
#include "DYDXmlHandler.h"

#include "DYDMacroStaticReferenceFactory.h"
#include "DYDMacroStaticReference.h"
#include "DYDStaticRef.h"
#include "DYNExecUtils.h"
#include "DYNMacrosMessage.h"

#include "TestUtil.h"

INIT_XML_DYNAWO;

namespace dynamicdata {

//------------------------------------------------------
// TEST for read multiples files, wrong files
//------------------------------------------------------

TEST(APIDYDTest, ImporterTwoFilesAndExportWrongFile) {
  XmlImporter importer;
  boost::shared_ptr<DynamicModelsCollection> collection;
  std::vector<std::string> files;
  files.push_back("res/templateExpansion.xml");
  files.push_back("res/blackBoxModel.xml");
  ASSERT_NO_THROW(collection = importer.importFromDydFiles(files));
}

TEST(APIDYDTest, ImporterWrongFiles) {
  XmlImporter importer;
  boost::shared_ptr<DynamicModelsCollection> collection;
  std::vector<std::string> files;
  files.push_back("res/BadTemplateExpansion.xml");
  files.push_back("res/blackBoxModel.xml");

  ASSERT_THROW_DYNAWO(importer.importFromDydFiles(files), DYN::Error::API, DYN::KeyError_t::XmlFileParsingError);
  std::vector<std::string> files2;
  files2.push_back("res/dummyFile.xml");
  ASSERT_THROW_DYNAWO(importer.importFromDydFiles(files2), DYN::Error::API, DYN::KeyError_t::FileSystemItemDoesNotExist);
}

TEST(APIDYDTest, ImportMacroConnect) {
  XmlImporter importer;
  boost::shared_ptr<DynamicModelsCollection> collection;
  std::vector<std::string> files;
  files.push_back("res/macroConnectExample.xml");
  ASSERT_NO_THROW(collection = importer.importFromDydFiles(files));

  // export
  XmlExporter exporter;
  exporter.exportToFile(collection, "macroConnectExampleExport.xml");

  ASSERT_EQ(compareFiles("macroConnectExampleExport.xml", "res/macroConnectExample.xml"), true);
}

TEST(APIDYDTest, ImportMacroStaticRef) {
  XmlImporter importer;
  boost::shared_ptr<DynamicModelsCollection> collection;
  std::vector<std::string> files;
  files.push_back("res/macroStaticRef.xml");
  ASSERT_NO_THROW(collection = importer.importFromDydFiles(files));

  // export
  XmlExporter exporter;
  exporter.exportToFile(collection, "macroStaticRefExport.xml");

  ASSERT_EQ(compareFiles("macroStaticRefExport.xml", "res/macroStaticRef.xml"), true);
}

}  // namespace dynamicdata
