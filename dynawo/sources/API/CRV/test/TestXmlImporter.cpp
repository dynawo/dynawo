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
 * @file API/CRV/test/TestXmlImporter.cpp
 * @brief Unit tests for API_CRV
 *
 */

#include "gtest_dynawo.h"

#include "CRVXmlImporter.h"

INIT_XML_DYNAWO;

namespace curves {

//-----------------------------------------------------
// TEST XmlImporter
//-----------------------------------------------------

TEST(APICRVTest, testXmlImporterMissingFile) {
  XmlImporter importer;
  boost::shared_ptr<CurvesCollection> curves;
  ASSERT_THROW_DYNAWO(curves = importer.importFromFile("res/dummmyFile.crv"), DYN::Error::API, DYN::KeyError_t::FileSystemItemDoesNotExist);
}

TEST(APICRVTest, testXmlWrongFile) {
  XmlImporter importer;
  boost::shared_ptr<CurvesCollection> curves;
  ASSERT_THROW_DYNAWO(curves = importer.importFromFile("res/wrongFile.crv"), DYN::Error::API, DYN::KeyError_t::XmlFileParsingError);
}

TEST(APICRVTest, testXmlWrongStream) {
  XmlImporter importer;
  boost::shared_ptr<CurvesCollection> curves;
  std::istringstream badInputStream("hello");
  std::istream badStream(badInputStream.rdbuf());
  ASSERT_THROW_DYNAWO(curves = importer.importFromStream(badStream), DYN::Error::API, DYN::KeyError_t::XmlParsingError);
}

TEST(APICRVTest, testXmlFileImporter) {
  XmlImporter importer;
  boost::shared_ptr<CurvesCollection> curves;
  ASSERT_NO_THROW(curves = importer.importFromFile("res/curves.crv"));
}

TEST(APICRVTest, testXmlStreamImporter) {
  boost::shared_ptr<XmlImporter> importer = boost::shared_ptr<XmlImporter>(new XmlImporter());
  boost::shared_ptr<CurvesCollection> curves;
  std::istringstream goodInputStream(
    "<?xml version='1.0' encoding='UTF-8'?>"
    "<curvesInput xmlns=\"http://www.rte-france.com/dynawo\">"
    "<curve model=\"CHAN5Y742_EC\" variable=\"P\"/>"
    "</curvesInput>");
  std::istream goodStream(goodInputStream.rdbuf());
  ASSERT_NO_THROW(curves = importer->importFromStream(goodStream));
}

}  // namespace curves
