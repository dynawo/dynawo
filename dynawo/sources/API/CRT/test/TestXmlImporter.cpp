//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file API/CRT/test/TestXmlImporter.cpp
 * @brief Unit tests for API_CRT
 *
 */

#include "gtest_dynawo.h"

#include "CRTXmlImporter.h"
#include "CRTCriteriaCollection.h"
#include "CRTCriteria.h"
#include "CRTCriteriaParams.h"
#include "DYNCommon.h"

using DYN::doubleEquals;

INIT_XML_DYNAWO;

namespace criteria {

//-----------------------------------------------------
// TEST XmlImporter
//-----------------------------------------------------

TEST(APICRTTest, testXmlImporterMissingFile) {
  XmlImporter importer;
  std::shared_ptr<CriteriaCollection> criteria;
  ASSERT_THROW_DYNAWO(criteria = importer.importFromFile("res/dummmyFile.crt"), DYN::Error::API, DYN::KeyError_t::FileSystemItemDoesNotExist);
}

TEST(APICRTTest, testXmlWrongFile) {
  XmlImporter importer;
  std::shared_ptr<CriteriaCollection> criteria;
  ASSERT_THROW_DYNAWO(criteria = importer.importFromFile("res/wrongFile.crt"), DYN::Error::API, DYN::KeyError_t::XmlFileParsingError);
}

TEST(APICRTTest, testXmlWrongStream) {
  XmlImporter importer;
  std::shared_ptr<CriteriaCollection> criteria;
  std::istringstream badInputStream("hello");
  std::istream badStream(badInputStream.rdbuf());
  ASSERT_THROW_DYNAWO(criteria = importer.importFromStream(badStream), DYN::Error::API, DYN::KeyError_t::XmlParsingError);
}

TEST(APICRTTest, testXmlFileImporter) {
  XmlImporter importer;
  std::shared_ptr<CriteriaCollection> criteriaCollection;
  ASSERT_NO_THROW(criteriaCollection = importer.importFromFile("res/criteria.crt"));

  size_t idx = 0;
  for (CriteriaCollection::CriteriaCollectionConstIterator it = criteriaCollection->begin(CriteriaCollection::BUS),
      itEnd = criteriaCollection->end(CriteriaCollection::BUS);
      it != itEnd; ++it, ++idx) {
    std::shared_ptr<Criteria> criteria = *it;
    if (idx == 0) {
      size_t idx2 = 0;
      for (Criteria::component_id_const_iterator it2 = criteria->begin(), it2End = criteria->end();
          it2 != it2End; ++it2, ++idx2) {
        if (idx2 == 0) {
          ASSERT_EQ(it2->getId(), "MyId");
          ASSERT_EQ(it2->getVoltageLevelId(), "MyVoltageLevelId");
        } else if (idx2 == 1) {
          ASSERT_EQ(it2->getId(), "MyId2");
          ASSERT_EQ(it2->getVoltageLevelId(), "");
        } else {
          assert(false);
        }
      }
      ASSERT_TRUE(criteria->hasCountryFilter());
      ASSERT_TRUE(criteria->containsCountry("BE"));
      ASSERT_EQ(criteria->getParams()->getScope(), CriteriaParams::DYNAMIC);
      ASSERT_EQ(criteria->getParams()->getType(), CriteriaParams::LOCAL_VALUE);
      ASSERT_EQ(criteria->getParams()->getId(), "busCritId");
      ASSERT_TRUE(criteria->getParams()->hasVoltageLevels());
      ASSERT_EQ(criteria->getParams()->getVoltageLevels().size(), 1);
      const CriteriaParamsVoltageLevel& vl = criteria->getParams()->getVoltageLevels()[0];
      ASSERT_DOUBLE_EQUALS_DYNAWO(vl.getUMaxPu(), 0.8);
      ASSERT_DOUBLE_EQUALS_DYNAWO(vl.getUNomMin(), 225);
      ASSERT_FALSE(vl.hasUMinPu());
      ASSERT_FALSE(vl.hasUNomMax());
      ASSERT_FALSE(criteria->getParams()->hasPMax());
      ASSERT_FALSE(criteria->getParams()->hasPMin());
    } else {
      assert(false);
    }
  }

  idx = 0;
  for (CriteriaCollection::CriteriaCollectionConstIterator it = criteriaCollection->begin(CriteriaCollection::LOAD),
      itEnd = criteriaCollection->end(CriteriaCollection::LOAD);
      it != itEnd; ++it, ++idx) {
    std::shared_ptr<Criteria> criteria = *it;
    if (idx == 0) {
      assert(criteria->begin() == criteria->end());
      ASSERT_EQ(criteria->getParams()->getScope(), CriteriaParams::FINAL);
      ASSERT_EQ(criteria->getParams()->getType(), CriteriaParams::SUM);
      ASSERT_EQ(criteria->getParams()->getId(), "loadCritId");
      ASSERT_DOUBLE_EQUALS_DYNAWO(criteria->getParams()->getPMax(), 200);
      ASSERT_FALSE(criteria->getParams()->hasVoltageLevels());
      ASSERT_FALSE(criteria->getParams()->hasPMin());
      ASSERT_EQ(criteria->begin() == criteria->end(), true);
      ASSERT_FALSE(criteria->hasCountryFilter());
    } else if (idx == 1) {
      assert(criteria->begin() == criteria->end());
      ASSERT_EQ(criteria->getParams()->getScope(), CriteriaParams::FINAL);
      ASSERT_EQ(criteria->getParams()->getType(), CriteriaParams::SUM);
      ASSERT_EQ(criteria->getParams()->getId(), "loadCritIdWithCountry");
      ASSERT_DOUBLE_EQUALS_DYNAWO(criteria->getParams()->getPMax(), 300);
      ASSERT_FALSE(criteria->getParams()->hasVoltageLevels());
      ASSERT_FALSE(criteria->getParams()->hasPMin());
      ASSERT_EQ(criteria->begin() == criteria->end(), true);
      ASSERT_TRUE(criteria->hasCountryFilter());
      ASSERT_TRUE(criteria->containsCountry("EN"));
      ASSERT_TRUE(criteria->containsCountry("IT"));
    } else if (idx == 2) {
      size_t idx2 = 0;
      for (Criteria::component_id_const_iterator it2 = criteria->begin(), it2End = criteria->end();
          it2 != it2End; ++it2, ++idx2) {
        if (idx2 == 0)
          ASSERT_EQ(it2->getId(), "MyLoad");
        else if (idx2 == 1)
          ASSERT_EQ(it2->getId(), "MyLoad2");
        else
          assert(false);
      }
      ASSERT_EQ(criteria->getParams()->getScope(), CriteriaParams::FINAL);
      ASSERT_EQ(criteria->getParams()->getType(), CriteriaParams::SUM);
      ASSERT_EQ(criteria->getParams()->getId(), "loadCritId2");
      ASSERT_DOUBLE_EQUALS_DYNAWO(criteria->getParams()->getPMax(), 1500);
      ASSERT_TRUE(criteria->getParams()->hasVoltageLevels());
      ASSERT_EQ(criteria->getParams()->getVoltageLevels().size(), 2);
      const CriteriaParamsVoltageLevel& vl1 = criteria->getParams()->getVoltageLevels()[0];
      const CriteriaParamsVoltageLevel& vl2 = criteria->getParams()->getVoltageLevels()[1];
      ASSERT_DOUBLE_EQUALS_DYNAWO(vl1.getUMinPu(), 0.2);
      ASSERT_FALSE(vl1.hasUMaxPu());
      ASSERT_FALSE(vl1.hasUNomMin());
      ASSERT_FALSE(vl1.hasUNomMax());
      ASSERT_DOUBLE_EQUALS_DYNAWO(vl2.getUMaxPu(), 0.6);
      ASSERT_DOUBLE_EQUALS_DYNAWO(vl2.getUNomMin(), 225);
      ASSERT_FALSE(vl2.hasUMinPu());
      ASSERT_FALSE(vl2.hasUNomMax());
      ASSERT_FALSE(criteria->getParams()->hasPMin());
      ASSERT_FALSE(criteria->hasCountryFilter());
    } else if (idx == 3) {
      assert(criteria->begin() == criteria->end());
      ASSERT_EQ(criteria->getParams()->getScope(), CriteriaParams::FINAL);
      ASSERT_EQ(criteria->getParams()->getType(), CriteriaParams::SUM);
      ASSERT_EQ(criteria->getParams()->getId(), "loadCritId3");
      ASSERT_DOUBLE_EQUALS_DYNAWO(criteria->getParams()->getPMax(), 1500);
      ASSERT_TRUE(criteria->getParams()->hasVoltageLevels());
      ASSERT_EQ(criteria->getParams()->getVoltageLevels().size(), 1);
      const CriteriaParamsVoltageLevel& vl = criteria->getParams()->getVoltageLevels()[0];
      ASSERT_DOUBLE_EQUALS_DYNAWO(vl.getUMaxPu(), 0.4);
      ASSERT_DOUBLE_EQUALS_DYNAWO(vl.getUNomMin(), 40);
      ASSERT_DOUBLE_EQUALS_DYNAWO(vl.getUMinPu(), 0.2);
      ASSERT_DOUBLE_EQUALS_DYNAWO(vl.getUNomMax(), 100);
      ASSERT_FALSE(criteria->getParams()->hasPMin());
      ASSERT_FALSE(criteria->hasCountryFilter());
    } else {
      assert(false);
    }
  }
}

TEST(APICRTTest, testXmlStreamImporter) {
  std::shared_ptr<XmlImporter> importer = std::make_shared<XmlImporter>();
  std::shared_ptr<CriteriaCollection> criteria;
  std::istringstream goodInputStream(
    "<?xml version='1.0' encoding='UTF-8'?>"
    "<criteria xmlns=\"http://www.rte-france.com/dynawo\">"
    "<busCriteria>"
    "<parameters id =\"MyId\" scope=\"DYNAMIC\" type=\"LOCAL_VALUE\" uMaxPu=\"0.8\"/>"
    "</busCriteria>"
    "</criteria>");
  std::istream goodStream(goodInputStream.rdbuf());
  ASSERT_NO_THROW(criteria = importer->importFromStream(goodStream));
}

}  // namespace criteria
