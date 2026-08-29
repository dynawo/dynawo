//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file API/FSV/test/TestXmlImporter.cpp
 * @brief Unit tests for API_FSV
 *
 */

#include "FSVFinalStateValuesCollectionFactory.h"
#include "FSVXmlImporter.h"
#include "gtest_dynawo.h"

INIT_XML_DYNAWO;

namespace finalStateValues {

//-----------------------------------------------------
// TEST XmlImporter
//-----------------------------------------------------

TEST(APIFSVTest, testXmlImporterMissingFile) {
  XmlImporter importer;
  std::shared_ptr<FinalStateValuesCollection> finalStateValues;
  ASSERT_THROW_DYNAWO(finalStateValues = importer.importFromFile("res/dummmyFile.fsv"), DYN::Error::API, DYN::KeyError_t::FileSystemItemDoesNotExist);
}

TEST(APIFSVTest, testXmlWrongFile) {
  XmlImporter importer;
  std::shared_ptr<FinalStateValuesCollection> finalStateValues;
  ASSERT_THROW_DYNAWO(finalStateValues = importer.importFromFile("res/wrongFile.fsv"), DYN::Error::API, DYN::KeyError_t::XmlFileParsingError);
}

TEST(APIFSVTest, testXmlWrongStream) {
  XmlImporter importer;
  std::shared_ptr<FinalStateValuesCollection> finalStateValues;
  std::istringstream badInputStream("hello");
  std::istream badStream(badInputStream.rdbuf());
  ASSERT_THROW_DYNAWO(finalStateValues = importer.importFromStream(badStream), DYN::Error::API, DYN::KeyError_t::XmlParsingError);
}

TEST(APIFSVTest, testXmlFileImporter) {
  XmlImporter importer;
  std::shared_ptr<FinalStateValuesCollection> finalStateValues;
  ASSERT_NO_THROW(finalStateValues = importer.importFromFile("res/finalStateValues.fsv"));
}

TEST(APIFSVTest, testXmlStreamImporter) {
  std::unique_ptr<XmlImporter> importer = std::unique_ptr<XmlImporter>(new XmlImporter());
  std::shared_ptr<FinalStateValuesCollection> finalStateValues;
  std::istringstream goodInputStream(
      "<?xml version='1.0' encoding='UTF-8'?>"
      "<finalStateValuesInput xmlns=\"http://www.rte-france.com/dynawo\">"
      "<finalStateValue model=\"CHAN5Y742_EC\" variable=\"P\"/>"
      "</finalStateValuesInput>");
  std::istream goodStream(goodInputStream.rdbuf());
  ASSERT_NO_THROW(finalStateValues = importer->importFromStream(goodStream));
}

}  // namespace finalStateValues
