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
 * @file API/CRT/test/TestCriteria.cpp
 * @brief Unit tests for API_CRT
 *
 */

#include "gtest_dynawo.h"

#include "DYNCommon.h"
#include "CRTCriteriaParamsFactory.h"
#include "CRTCriteriaParams.h"
#include "CRTCriteriaFactory.h"
#include "CRTCriteria.h"
#include "CRTCriteriaCollectionFactory.h"
#include "CRTCriteriaCollection.h"

using DYN::doubleEquals;
namespace criteria {

//-----------------------------------------------------
// TEST build CriteriaParams
//-----------------------------------------------------

TEST(APICRTTest, CriteriaParams) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
//
  // test default constructor attributes
  ASSERT_EQ(criteriap->getScope(), CriteriaParams::UNDEFINED_SCOPE);
  ASSERT_EQ(criteriap->getType(), CriteriaParams::UNDEFINED_TYPE);
  ASSERT_EQ(criteriap->getId(), "");
  ASSERT_DOUBLE_EQUALS_DYNAWO(criteriap->getUMaxPu(), std::numeric_limits<double>::max());
  ASSERT_DOUBLE_EQUALS_DYNAWO(criteriap->getUMinPu(), -std::numeric_limits<double>::max());
  ASSERT_DOUBLE_EQUALS_DYNAWO(criteriap->getUNomMax(), std::numeric_limits<double>::max());
  ASSERT_DOUBLE_EQUALS_DYNAWO(criteriap->getUNomMin(), -std::numeric_limits<double>::max());
  ASSERT_DOUBLE_EQUALS_DYNAWO(criteriap->getPMax(), std::numeric_limits<double>::max());
  ASSERT_DOUBLE_EQUALS_DYNAWO(criteriap->getPMin(), -std::numeric_limits<double>::max());
  ASSERT_FALSE(criteriap->hasPMax());
  ASSERT_FALSE(criteriap->hasPMin());
  ASSERT_FALSE(criteriap->hasUMaxPu());
  ASSERT_FALSE(criteriap->hasUMinPu());

  // set attributes
  criteriap->setScope(CriteriaParams::FINAL);
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setUMaxPu(0.8);
  criteriap->setUMinPu(0.2);
  criteriap->setUNomMax(220);
  criteriap->setUNomMin(180);
  criteriap->setPMax(200);
  criteriap->setPMin(0);
  criteriap->setId("MyId");

  // test setted attributes
  ASSERT_EQ(criteriap->getScope(), CriteriaParams::FINAL);
  ASSERT_EQ(criteriap->getType(), CriteriaParams::SUM);
  ASSERT_EQ(criteriap->getId(), "MyId");
  ASSERT_DOUBLE_EQUALS_DYNAWO(criteriap->getUMaxPu(), 0.8);
  ASSERT_DOUBLE_EQUALS_DYNAWO(criteriap->getUMinPu(), 0.2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(criteriap->getUNomMax(), 220);
  ASSERT_DOUBLE_EQUALS_DYNAWO(criteriap->getUNomMin(), 180);
  ASSERT_DOUBLE_EQUALS_DYNAWO(criteriap->getPMax(), 200);
  ASSERT_DOUBLE_EQUALS_DYNAWO(criteriap->getPMin(), 0);
  ASSERT_TRUE(criteriap->hasPMax());
  ASSERT_TRUE(criteriap->hasPMin());
  ASSERT_TRUE(criteriap->hasUMaxPu());
  ASSERT_TRUE(criteriap->hasUMinPu());
}

TEST(APICRTTest, Criteria) {
  boost::shared_ptr<Criteria> criteria = CriteriaFactory::newCriteria();

  // test default constructor attributes
  assert(criteria->begin() == criteria->end());
  assert(!criteria->getParams());

  // set attributes
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setScope(CriteriaParams::FINAL);
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setId("MyId");
  criteriap->setUMaxPu(0.8);
  criteriap->setUMinPu(0.2);
  criteriap->setPMax(200);
  criteriap->setPMin(0);
  criteria->setParams(criteriap);
  criteria->addComponentId("MyCompId1");
  criteria->addComponentId("MyCompId2");

  // test setted attributes
  ASSERT_EQ(criteria->getParams(), criteriap);
  size_t idx = 0;
  for (Criteria::component_id_const_iterator it = criteria->begin(), itEnd = criteria->end();
      it != itEnd; ++it, ++idx) {
    if (idx == 0)
      ASSERT_EQ(*it, "MyCompId1");
    else if (idx == 1)
      ASSERT_EQ(*it, "MyCompId2");
    else
      assert(false);
  }
  Criteria::component_id_const_iterator itCt = criteria->begin();
  ASSERT_EQ(*(++itCt), "MyCompId2");
  ASSERT_EQ(*(--itCt), "MyCompId1");
  ASSERT_EQ(*(itCt++), "MyCompId1");
  ASSERT_EQ(*(itCt--), "MyCompId2");
  ASSERT_EQ(*itCt, "MyCompId1");
  ASSERT_EQ(itCt->size(), 9);
  Criteria::component_id_const_iterator itCt2 = criteria->end();
  itCt2 = itCt;
  ASSERT_EQ(itCt == itCt2, true);
}

TEST(APICRTTest, CriteriaCollection) {
  boost::shared_ptr<CriteriaCollection> criteriaCol = CriteriaCollectionFactory::newInstance();

  // test default constructor attributes
  assert(criteriaCol->begin(CriteriaCollection::BUS) == criteriaCol->end(CriteriaCollection::BUS));
  assert(criteriaCol->begin(CriteriaCollection::LOAD) == criteriaCol->end(CriteriaCollection::LOAD));
  assert(criteriaCol->begin(CriteriaCollection::GENERATOR) == criteriaCol->end(CriteriaCollection::GENERATOR));

  // set attributes
  boost::shared_ptr<Criteria> criteriaBus = CriteriaFactory::newCriteria();
  criteriaBus->addComponentId("MyCompBusId1");
  criteriaBus->addComponentId("MyCompBusId2");
  criteriaCol->add(CriteriaCollection::BUS, criteriaBus);
  boost::shared_ptr<Criteria> criteriaLoad = CriteriaFactory::newCriteria();
  criteriaLoad->addComponentId("MyCompLoadId1");
  criteriaLoad->addComponentId("MyCompLoadId2");
  boost::shared_ptr<Criteria> criteriaLoad2 = CriteriaFactory::newCriteria();
  criteriaLoad->addComponentId("MyCompLoadId3");
  criteriaCol->add(CriteriaCollection::LOAD, criteriaLoad);
  criteriaCol->add(CriteriaCollection::LOAD, criteriaLoad2);
  boost::shared_ptr<Criteria> criteriaGen = CriteriaFactory::newCriteria();
  criteriaLoad->addComponentId("MyCompGenId1");
  criteriaLoad->addComponentId("MyCompGenId2");
  criteriaLoad->addComponentId("MyCompGenId3");
  criteriaCol->add(CriteriaCollection::GENERATOR, criteriaGen);

  // test setted attributes
  size_t idx = 0;
  for (CriteriaCollection::CriteriaCollectionConstIterator it = criteriaCol->begin(CriteriaCollection::BUS),
      itEnd = criteriaCol->end(CriteriaCollection::BUS);
      it != itEnd; ++it, ++idx) {
    boost::shared_ptr<Criteria> criteria = *it;
    if (idx == 0)
      ASSERT_EQ(*it, criteriaBus);
    else
      assert(false);
  }

  idx = 0;
  for (CriteriaCollection::CriteriaCollectionConstIterator it = criteriaCol->begin(CriteriaCollection::LOAD),
      itEnd = criteriaCol->end(CriteriaCollection::LOAD);
      it != itEnd; ++it, ++idx) {
    boost::shared_ptr<Criteria> criteria = *it;
    if (idx == 0)
      ASSERT_EQ(*it, criteriaLoad);
    else if (idx == 1)
      ASSERT_EQ(*it, criteriaLoad2);
    else
      assert(false);
  }
  CriteriaCollection::CriteriaCollectionConstIterator itCt = criteriaCol->begin(CriteriaCollection::LOAD);
  ASSERT_EQ(*(++itCt), criteriaLoad2);
  ASSERT_EQ(*(--itCt), criteriaLoad);
  ASSERT_EQ(*(itCt++), criteriaLoad);
  ASSERT_EQ(*(itCt--), criteriaLoad2);
  ASSERT_EQ(*itCt, criteriaLoad);
  CriteriaCollection::CriteriaCollectionConstIterator itCt2  = criteriaCol->end(CriteriaCollection::LOAD);
  itCt2 = itCt;
  ASSERT_EQ(itCt == itCt2, true);

  idx = 0;
  for (CriteriaCollection::CriteriaCollectionConstIterator it = criteriaCol->begin(CriteriaCollection::GENERATOR),
      itEnd = criteriaCol->end(CriteriaCollection::GENERATOR);
      it != itEnd; ++it, ++idx) {
    boost::shared_ptr<Criteria> criteria = *it;
    if (idx == 0)
      ASSERT_EQ(*it, criteriaGen);
    else
      assert(false);
  }
}

}  // namespace criteria
