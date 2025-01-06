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
  std::shared_ptr<DynamicModelsCollection> collection;
  std::vector<std::string> files;
  files.push_back("res/templateExpansion.xml");
  files.push_back("res/blackBoxModel.xml");
  ASSERT_NO_THROW(collection = importer.importFromDydFiles(files));
}

TEST(APIDYDTest, ImporterWrongFiles) {
  XmlImporter importer;
  std::vector<std::string> files;
  files.push_back("res/BadTemplateExpansion.xml");
  files.push_back("res/blackBoxModel.xml");

  ASSERT_THROW_DYNAWO(importer.importFromDydFiles(files), DYN::Error::API, DYN::KeyError_t::XmlFileParsingError);
  std::vector<std::string> files2;
  files2.push_back("res/dummyFile.xml");
  ASSERT_THROW_DYNAWO(importer.importFromDydFiles(files2), DYN::Error::API, DYN::KeyError_t::FileSystemItemDoesNotExist);
}

TEST(APIDYDTest, ImporterWrongStream) {
  XmlImporter importer;

  XmlHandler dydHandler;
  xml::sax::parser::ParserFactory parser_factory;
  xml::sax::parser::ParserPtr parser = parser_factory.createParser();
  std::istringstream badInputStream("hello");
  std::istream badStream(badInputStream.rdbuf());
  ASSERT_THROW_DYNAWO(importer.importFromStream(badStream, dydHandler, parser, true), DYN::Error::API, DYN::KeyError_t::XmlParsingError);
}

TEST(APIDYDTest, ImporterStream) {
  XmlImporter importer;

  XmlHandler dydHandler;
  xml::sax::parser::ParserFactory parser_factory;
  xml::sax::parser::ParserPtr parser = parser_factory.createParser();
  bool xsdValidation = false;
  if (getEnvVar("DYNAWO_USE_XSD_VALIDATION") == "true") {
    std::string dydXsdPath = getMandatoryEnvVar("DYNAWO_XSD_DIR") + std::string("dyd.xsd");
    parser->addXmlSchema(dydXsdPath);
    xsdValidation = true;
  }
  std::istringstream goodInputStream(
    "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" standalone=\"no\"?>"
    "<dyn:dynamicModelsArchitecture xmlns:dyn=\"http://www.rte-france.com/dynawo\">"
    "<dyn:blackBoxModel id=\"BlackBoxModel\" staticId=\"bbmId\" lib=\"model\" parFile=\"parFile.par\" parId=\"1\">"
    "<dyn:staticRef var=\"M2S_P_value\" staticVar=\"p\"/>"
    "</dyn:blackBoxModel>"
    "<dyn:connect id1=\"BlackBoxModel\" var1=\"variable\" id2=\"externalModel\" var2=\"externalModel_variable\"/>"
    "</dyn:dynamicModelsArchitecture>");
  std::istream goodStream(goodInputStream.rdbuf());
  ASSERT_NO_THROW(importer.importFromStream(goodStream, dydHandler, parser, xsdValidation));
}

TEST(APIDYDTest, ImportMacroConnect) {
  XmlImporter importer;
  std::shared_ptr<DynamicModelsCollection> collection;
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
  std::shared_ptr<DynamicModelsCollection> collection;
  std::vector<std::string> files;
  files.push_back("res/macroStaticRef.xml");
  ASSERT_NO_THROW(collection = importer.importFromDydFiles(files));

  // export
  XmlExporter exporter;
  exporter.exportToFile(collection, "macroStaticRefExport.xml");

  ASSERT_EQ(compareFiles("macroStaticRefExport.xml", "res/macroStaticRef.xml"), true);
}

}  // namespace dynamicdata
