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

#include "CRTXmlImporter.h"
#include "CRTCriteriaCollection.h"
#include "CRTCriteria.h"
#include "CRTCriteriaParams.h"
#include "DYNCommon.h"

using DYN::doubleEquals;

namespace criteria {

//-----------------------------------------------------
// TEST XmlImporter
//-----------------------------------------------------

TEST(APICRTTest, testXmlImporterMissingFile) {
  XmlImporter importer;
  boost::shared_ptr<CriteriaCollection> criteria;
  ASSERT_THROW_DYNAWO(criteria = importer.importFromFile("res/dummmyFile.crt"), DYN::Error::API, DYN::KeyError_t::FileSystemItemDoesNotExist);
}

TEST(APICRTTest, testXmlWrongFile) {
  XmlImporter importer;
  boost::shared_ptr<CriteriaCollection> criteria;
  ASSERT_THROW_DYNAWO(criteria = importer.importFromFile("res/wrongFile.crt"), DYN::Error::API, DYN::KeyError_t::XmlFileParsingError);
}

TEST(APICRTTest, testXmlWrongStream) {
  XmlImporter importer;
  boost::shared_ptr<CriteriaCollection> criteria;
  std::istringstream badInputStream("hello");
  std::istream badStream(badInputStream.rdbuf());
  ASSERT_THROW_DYNAWO(criteria = importer.importFromStream(badStream), DYN::Error::API, DYN::KeyError_t::XmlParsingError);
}

TEST(APICRTTest, testXmlFileImporter) {
  XmlImporter importer;
  boost::shared_ptr<CriteriaCollection> criteria;
  ASSERT_NO_THROW(criteria = importer.importFromFile("res/criteria.crt"));

  size_t idx = 0;
  for (CriteriaCollection::CriteriaCollectionConstIterator it = criteria->begin(CriteriaCollection::BUS),
      itEnd = criteria->end(CriteriaCollection::BUS);
      it != itEnd; ++it, ++idx) {
    boost::shared_ptr<Criteria> criteria = *it;
    if (idx == 0) {
      size_t idx2 = 0;
      for (Criteria::component_id_const_iterator it2 = criteria->begin(), it2End = criteria->end();
          it2 != it2End; ++it2, ++idx2) {
        if (idx2 == 0)
          ASSERT_EQ(*it2, "MyId");
        else if (idx2 == 1)
          ASSERT_EQ(*it2, "MyId2");
        else
          assert(false);
      }
      ASSERT_EQ(criteria->getParams()->getScope(), CriteriaParams::DYNAMIC);
      ASSERT_EQ(criteria->getParams()->getType(), CriteriaParams::LOCAL_VALUE);
      ASSERT_EQ(criteria->getParams()->getId(), "busCritId");
      ASSERT_DOUBLE_EQUALS_DYNAWO(criteria->getParams()->getUMaxPu(), 0.8);
      ASSERT_DOUBLE_EQUALS_DYNAWO(criteria->getParams()->getUMinNom(), 225);
      ASSERT_FALSE(criteria->getParams()->hasUMinPu());
      ASSERT_FALSE(criteria->getParams()->hasUMaxNom());
      ASSERT_FALSE(criteria->getParams()->hasPMax());
      ASSERT_FALSE(criteria->getParams()->hasPMin());
    } else {
      assert(false);
    }
  }

  idx = 0;
  for (CriteriaCollection::CriteriaCollectionConstIterator it = criteria->begin(CriteriaCollection::LOAD),
      itEnd = criteria->end(CriteriaCollection::LOAD);
      it != itEnd; ++it, ++idx) {
    boost::shared_ptr<Criteria> criteria = *it;
    if (idx == 0) {
      ASSERT_EQ(criteria->begin(), criteria->end());
      ASSERT_EQ(criteria->getParams()->getScope(), CriteriaParams::FINAL);
      ASSERT_EQ(criteria->getParams()->getType(), CriteriaParams::SUM);
      ASSERT_EQ(criteria->getParams()->getId(), "loadCritId");
      ASSERT_DOUBLE_EQUALS_DYNAWO(criteria->getParams()->getPMax(), 200);
      ASSERT_FALSE(criteria->getParams()->hasUMinPu());
      ASSERT_FALSE(criteria->getParams()->hasUMaxPu());
      ASSERT_FALSE(criteria->getParams()->hasUMinNom());
      ASSERT_FALSE(criteria->getParams()->hasUMaxNom());
      ASSERT_FALSE(criteria->getParams()->hasPMin());
    } else if (idx == 1) {
      size_t idx2 = 0;
      for (Criteria::component_id_const_iterator it2 = criteria->begin(), it2End = criteria->end();
          it2 != it2End; ++it2, ++idx2) {
        if (idx2 == 0)
          ASSERT_EQ(*it2, "MyLoad");
        else if (idx2 == 1)
          ASSERT_EQ(*it2, "MyLoad2");
        else
          assert(false);
      }
      ASSERT_EQ(criteria->getParams()->getScope(), CriteriaParams::FINAL);
      ASSERT_EQ(criteria->getParams()->getType(), CriteriaParams::SUM);
      ASSERT_EQ(criteria->getParams()->getId(), "loadCritId2");
      ASSERT_DOUBLE_EQUALS_DYNAWO(criteria->getParams()->getPMax(), 1500);
      ASSERT_DOUBLE_EQUALS_DYNAWO(criteria->getParams()->getUMinPu(), 0.2);
      ASSERT_FALSE(criteria->getParams()->hasUMaxPu());
      ASSERT_FALSE(criteria->getParams()->hasPMin());
      ASSERT_FALSE(criteria->getParams()->hasUMinNom());
      ASSERT_FALSE(criteria->getParams()->hasUMaxNom());
    } else {
      assert(false);
    }
  }
}

TEST(APICRTTest, testXmlStreamImporter) {
  boost::shared_ptr<XmlImporter> importer = boost::shared_ptr<XmlImporter>(new XmlImporter());
  boost::shared_ptr<CriteriaCollection> curves;
  std::istringstream goodInputStream(
    "<?xml version='1.0' encoding='UTF-8'?>"
    "<criteria xmlns=\"http://www.rte-france.com/dynawo\">"
    "<busCriteria>"
    "<parameters id =\"MyId\" scope=\"DYNAMIC\" type=\"LOCAL_VALUE\" uMaxPu=\"0.8\"/>"
    "</busCriteria>"
    "</criteria>");
  std::istream goodStream(goodInputStream.rdbuf());
  ASSERT_NO_THROW(curves = importer->importFromStream(goodStream));
}

}  // namespace criteria
