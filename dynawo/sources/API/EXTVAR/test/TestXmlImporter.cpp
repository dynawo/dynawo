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
 * @file API/EXTVAR/test/TestXmlImporter.cpp
 * @brief Unit tests for API_EXTVAR
 *
 */

#include "gtest_dynawo.h"

#include "EXTVARXmlImporter.h"

namespace externalVariables {

//-----------------------------------------------------
// TEST import an external variable file with bad variable type
//-----------------------------------------------------

TEST(APIEXTVARTest, ExternalVariableImportBadType) {
  // import
  const std::string fileName = "res/ExternalVariablesBadType.extvar";
  XmlImporter importer;
  ASSERT_THROW_DYNAWO(importer.importFromFile(fileName), DYN::Error::API, DYN::KeyError_t::XmlFileParsingError);
}

//-----------------------------------------------------
// TEST import an external variable file with duplicate variable id
//-----------------------------------------------------

TEST(APIEXTVARTest, ExternalVariableImportDuplicateId) {
  // import
  const std::string fileName = "res/ExternalVariablesDuplicateId.extvar";
  XmlImporter importer;
  ASSERT_THROW_DYNAWO(importer.importFromFile(fileName), DYN::Error::API, DYN::KeyError_t::XmlFileParsingError);
}

//-----------------------------------------------------
// TEST import non existing file
//-----------------------------------------------------

TEST(APIEXTVARTest, nonExistingFile) {
  XmlImporter importer;
  ASSERT_THROW_DYNAWO(importer.importFromFile("res/dummyFile.extvar"), DYN::Error::API, DYN::KeyError_t::FileSystemItemDoesNotExist);
}

TEST(APICRVTest, testXmlWrongStream) {
  XmlImporter importer;
  std::istringstream badInputStream("hello");
  std::istream badStream(badInputStream.rdbuf());
  ASSERT_THROW_DYNAWO(importer.importFromStream(badStream), DYN::Error::API, DYN::KeyError_t::XmlParsingError);
}

TEST(APICRVTest, testXmlFileImporter) {
  XmlImporter importer;
  ASSERT_NO_THROW(importer.importFromFile("res/ExternalVariablesTest.extvar"));
}

TEST(APICRVTest, testXmlStreamImporter) {
  XmlImporter importer;
  std::istringstream goodInputStream(
    "<?xml version='1.0' encoding='UTF-8'?>"
    "<external_variables xmlns=\"http://www.rte-france.com/dynawo\" xmlns:xi=\"http://www.w3.org/2001/XInclude\">"
    "<variable type=\"continuous\" id=\"sortie.V.re\"/>"
    "<variable type=\"continuous\" id=\"sortie.V.im\"/>"
    "<variable type=\"continuous\" id=\"omegaRef.value\"/>"
    "</external_variables>");
  std::istream goodStream(goodInputStream.rdbuf());
  ASSERT_NO_THROW(importer.importFromStream(goodStream));
}

}  // namespace externalVariables
