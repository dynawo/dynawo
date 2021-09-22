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
 * @file API/FS/test/TestXMLImporter.cpp
 * @brief Unit tests for API_FS
 *
 */

#include "gtest_dynawo.h"

#include "FSXmlImporter.h"
#include "FSXmlExporter.h"
#include "FSFinalStateCollection.h"

INIT_XML_DYNAWO;

namespace finalState {

//-----------------------------------------------------
// TEST import missing file
//-----------------------------------------------------

TEST(APIFSTest, XmlImporterMissingFile) {
  XmlImporter importer;
  boost::shared_ptr<FinalStateCollection> collection;
  ASSERT_THROW_DYNAWO(collection = importer.importFromFile("res/dummyFile.xml"), DYN::Error::API, DYN::KeyError_t::FileSystemItemDoesNotExist);
}

//-----------------------------------------------------
// TEST import existing file non consistent with xsd scheme
//-----------------------------------------------------

TEST(APIFSTest, XmlImporterWrongFile) {
  XmlImporter importer;
  boost::shared_ptr<FinalStateCollection> collection;
  ASSERT_THROW_DYNAWO(collection = importer.importFromFile("res/wrongFile.xml"), DYN::Error::API, DYN::KeyError_t::XmlFileParsingError);
}

//-----------------------------------------------------
// TEST import existing file in line with xsd scheme
//-----------------------------------------------------

TEST(APIFSTest, XmlFileImporter) {
  XmlImporter importer;
  boost::shared_ptr<FinalStateCollection> collection;
  collection = importer.importFromFile("res/okFile.xml");
  ASSERT_NO_THROW(collection = importer.importFromFile("res/okFile.xml"));
}

TEST(APIFSTest, testXmlWrongStream) {
  XmlImporter importer;
  std::istringstream badInputStream("hello");
  std::istream badStream(badInputStream.rdbuf());
  ASSERT_THROW_DYNAWO(importer.importFromStream(badStream), DYN::Error::API, DYN::KeyError_t::XmlParsingError);
}

TEST(APIFSTest, testXmlStreamImporter) {
  XmlImporter importer;
  std::istringstream goodInputStream(
    "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" standalone=\"no\"?>"
    "<dyn:finalStateInput xmlns:dyn=\"http://www.rte-france.com/dynawo\">"
    "<dyn:model id=\"model1\">"
    "<dyn:variable name=\"varModel1\"/>"
    "<dyn:model id=\"subModel1\">"
    "<dyn:variable name=\"varSubModel1\"/>"
    "</dyn:model>"
    "</dyn:model>"
    "<dyn:model id=\"model2\">"
    "<dyn:variable name=\"varModel2\"/>"
    "</dyn:model>"
    "<dyn:variable name=\"varGlobal1\"/>"
    "<dyn:variable name=\"varGlobal2\"/>"
    "</dyn:finalStateInput>");
  std::istream goodStream(goodInputStream.rdbuf());
  ASSERT_NO_THROW(importer.importFromStream(goodStream));
}

}  // namespace finalState
