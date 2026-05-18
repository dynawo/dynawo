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
 * @file API/MANDATORYPARAM/test/TestXmlImporter.cpp
 * @brief Unit tests for XmlImporter
 */

#include "gtest_dynawo.h"

#include "MANDATORYPARAMXmlImporter.h"

namespace mandatoryParameters {

//-----------------------------------------------------
// TEST import a valid .mandatoryParam file
//-----------------------------------------------------

TEST(APIMandatoryParamTest, ImportValidFile) {
  XmlImporter importer;
  std::shared_ptr<Collection> collection;
  ASSERT_NO_THROW(collection = importer.importFromFile("res/MandatoryParamTest.mandatoryParam"));
  ASSERT_EQ(collection->getParameters().size(), 4u);
}

//-----------------------------------------------------
// TEST import a file with a bad parameter type (XSD validation)
//-----------------------------------------------------

TEST(APIMandatoryParamTest, ImportBadType) {
  XmlImporter importer;
  ASSERT_THROW_DYNAWO(importer.importFromFile("res/MandatoryParamBadType.mandatoryParam"),
                      DYN::Error::API, DYN::KeyError_t::XmlFileParsingError);
}

//-----------------------------------------------------
// TEST import a file with a missing required attribute
//-----------------------------------------------------

TEST(APIMandatoryParamTest, ImportMissingAttribute) {
  XmlImporter importer;
  ASSERT_THROW_DYNAWO(importer.importFromFile("res/MandatoryParamMissingName.mandatoryParam"),
                      DYN::Error::API, DYN::KeyError_t::XmlFileParsingError);
}

//-----------------------------------------------------
// TEST import a non-existing file
//-----------------------------------------------------

TEST(APIMandatoryParamTest, ImportNonExistingFile) {
  XmlImporter importer;
  ASSERT_THROW_DYNAWO(importer.importFromFile("res/dummyFile.mandatoryParam"),
                      DYN::Error::API, DYN::KeyError_t::FileSystemItemDoesNotExist);
}

//-----------------------------------------------------
// TEST importFromStream with malformed XML
//-----------------------------------------------------

TEST(APIMandatoryParamTest, ImportBadStream) {
  XmlImporter importer;
  std::istringstream badInputStream("not xml");
  std::istream badStream(badInputStream.rdbuf());
  ASSERT_THROW_DYNAWO(importer.importFromStream(badStream),
                      DYN::Error::API, DYN::KeyError_t::XmlParsingError);
}

//-----------------------------------------------------
// TEST importFromStream with valid XML
//-----------------------------------------------------

TEST(APIMandatoryParamTest, ImportGoodStream) {
  XmlImporter importer;
  std::istringstream goodInputStream(
    "<?xml version='1.0' encoding='UTF-8'?>"
    "<mandatoryParameters>"
    "<mandatoryParameter name=\"RPu\" type=\"DOUBLE\"/>"
    "<mandatoryParameter name=\"XPu\" type=\"DOUBLE\"/>"
    "</mandatoryParameters>");
  std::istream goodStream(goodInputStream.rdbuf());
  std::shared_ptr<Collection> collection;
  ASSERT_NO_THROW(collection = importer.importFromStream(goodStream));
  ASSERT_EQ(collection->getParameters().size(), 2u);
}

}  // namespace mandatoryParameters
