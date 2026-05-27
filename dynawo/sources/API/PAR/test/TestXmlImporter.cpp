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
 * @file API/PAR/test/TestXmlImporter.cpp
 * @brief Unit tests for API_PAR
 */

#include "gtest_dynawo.h"

#include <boost/filesystem.hpp>

#include "PARXmlImporter.h"
#include "PARParametersSetCollection.h"
#include "PARParametersSet.h"


INIT_XML_DYNAWO;

namespace parameters {

//-----------------------------------------------------
// TEST import missing file
//-----------------------------------------------------

TEST(APIPARTest, XmlImporterMissingFile) {
  XmlImporter importer;
  std::shared_ptr<ParametersSetCollection> collection;
  ASSERT_THROW_DYNAWO(collection = importer.importFromFile("res/dummyFile.par"), DYN::Error::API, DYN::KeyError_t::FileSystemItemDoesNotExist);
}

//-----------------------------------------------------
// TEST import existing file non consistent with xsd scheme
//-----------------------------------------------------

TEST(APIPARTest, XmlImporterWrongFile) {
  XmlImporter importer;
  std::shared_ptr<ParametersSetCollection> collection;
  ASSERT_THROW_DYNAWO(collection = importer.importFromFile("res/wrongFile.par"), DYN::Error::API, DYN::KeyError_t::XmlFileParsingError);
}

//-----------------------------------------------------
// TEST import existing file in line with xsd scheme
//-----------------------------------------------------

TEST(APIPARTest, XmlImporter) {
  XmlImporter importer;
  std::shared_ptr<ParametersSetCollection> collection;
  ASSERT_NO_THROW(collection = importer.importFromFile("res/fileToImport.par"));
}

TEST(APIPARTest, testXmlWrongStream) {
  XmlImporter importer;
  std::istringstream badInputStream("hello");
  std::istream badStream(badInputStream.rdbuf());
  ASSERT_THROW_DYNAWO(importer.importFromStream(badStream), DYN::Error::API, DYN::KeyError_t::XmlParsingError);
}

TEST(APIPARTest, testXmlStreamImporter) {
  XmlImporter importer;
  std::istringstream goodInputStream(
    "<?xml version='1.0' encoding='UTF-8'?>"
    "<parametersSet xmlns=\"http://www.rte-france.com/dynawo\">"
    "<set id=\"1\">"
    "<parTable type=\"DOUBLE\" name=\"A\">"
    "<par row=\"1\" column=\"1\" value=\"0.1\"/>"
    "<par row=\"1\" column=\"2\" value=\"0.5\"/>"
    "<par row=\"2\" column=\"1\" value=\"1.0\"/>"
    "<par row=\"2\" column=\"2\" value=\"0\"/>"
    "</parTable>"
    "<parTable type=\"INT\" name=\"B\">"
    "<par row=\"1\" column=\"1\" value=\"1\"/>"
    "<par row=\"1\" column=\"2\" value=\"2\"/>"
    "</parTable>"
    "<parTable type=\"BOOL\" name=\"C\">"
    "<par row=\"1\" column=\"1\" value=\"true\"/>"
    "<par row=\"1\" column=\"2\" value=\"false\"/>"
    "</parTable>"
    "<parTable type=\"STRING\" name=\"D\">"
    "<par row=\"1\" column=\"1\" value=\"term1\"/>"
    "<par row=\"1\" column=\"2\" value=\"term2\"/>"
    "</parTable>"
    "<par type=\"DOUBLE\" name=\"tb\" value=\"30.\"/>"
    "<par type=\"INT\" name=\"int\" value=\"1\"/>"
    "<par type=\"BOOL\" name=\"boolean\" value=\"true\"/>"
    "<par type=\"STRING\" name=\"string\" value=\"mode\"/>"
    "<reference type=\"DOUBLE\" name=\"M2S_P0\" origData=\"IIDM\" origName=\"active\" componentId=\"compId\"/>"
    "<reference type=\"DOUBLE\" name=\"M2S_U0\" origData=\"IIDM\" origName=\"v_pu\"/>"
    "</set>"
    "</parametersSet>");
  std::istream goodStream(goodInputStream.rdbuf());
  ASSERT_NO_THROW(importer.importFromStream(goodStream));
}

TEST(APIPARTest, XmlImporterMacroSubstitutionFromFile) {
  setenv("DYNAWO_INSTALL_DIR", "/dynawo/install", 1);

  XmlImporter importer;
  std::shared_ptr<ParametersSetCollection> collection;
  ASSERT_NO_THROW(collection = importer.importFromFile("res/fileWithMacros.par"));

  auto set = collection->getParametersSet("1");
  ASSERT_TRUE(set != nullptr);

  std::string expectedParPath = boost::filesystem::absolute("res/fileWithMacros.par").parent_path().string();

  // @DYNAWO_INSTALL_DIR@ substituted
  ASSERT_EQ(set->getParameter("installPath")->getString(), "/dynawo/install/lib");
  // @PAR_PATH@ substituted with the directory of the par file
  ASSERT_EQ(set->getParameter("parPath")->getString(), expectedParPath + "/data.csv");
  // both macros substituted in the same value
  ASSERT_EQ(set->getParameter("combined")->getString(), "/dynawo/install/share/" + expectedParPath + "/file.txt");

  // parTable STRING values also substituted (table parameter names get a trailing underscore)
  ASSERT_EQ(set->getParameter("paths_1_1_")->getString(), "/dynawo/install/bin");
  ASSERT_EQ(set->getParameter("paths_1_2_")->getString(), expectedParPath + "/tables");

  unsetenv("DYNAWO_INSTALL_DIR");
}

TEST(APIPARTest, XmlImporterMacroSubstitutionFromStream) {
  setenv("DYNAWO_INSTALL_DIR", "/dynawo/install", 1);

  XmlImporter importer;
  std::istringstream goodInputStream(
    "<?xml version='1.0' encoding='UTF-8'?>"
    "<parametersSet xmlns=\"http://www.rte-france.com/dynawo\">"
    "<set id=\"1\">"
    "<par type=\"STRING\" name=\"installPath\" value=\"@DYNAWO_INSTALL_DIR@/lib\"/>"
    "<par type=\"STRING\" name=\"parPath\" value=\"@PAR_PATH@/data.csv\"/>"
    "</set>"
    "</parametersSet>");
  std::istream goodStream(goodInputStream.rdbuf());
  std::shared_ptr<ParametersSetCollection> collection;
  ASSERT_NO_THROW(collection = importer.importFromStream(goodStream));

  auto set = collection->getParametersSet("1");
  // @DYNAWO_INSTALL_DIR@ substituted even from stream
  ASSERT_EQ(set->getParameter("installPath")->getString(), "/dynawo/install/lib");
  // @PAR_PATH@ NOT substituted from stream (no file path available)
  ASSERT_EQ(set->getParameter("parPath")->getString(), "@PAR_PATH@/data.csv");

  unsetenv("DYNAWO_INSTALL_DIR");
}

}  // namespace parameters
