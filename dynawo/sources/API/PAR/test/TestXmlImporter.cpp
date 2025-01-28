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

#include "PARXmlImporter.h"
#include "PARParametersSetCollection.h"


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

}  // namespace parameters
