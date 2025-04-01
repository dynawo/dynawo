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
 * @file API/CSTR/test/TestConstraintsCollection.cpp
 * @brief Unit tests for API_CSTR
 *
 */

#include "gtest_dynawo.h"

#include "CSTRConstraintsCollectionFactory.h"
#include "CSTRConstraintsCollection.h"
#include "CSTRConstraint.h"


namespace constraints {

//-----------------------------------------------------
// TEST for ConstraintsCollection
//-----------------------------------------------------

TEST(APICSTRTest, ConstraintsCollection) {
  boost::shared_ptr<ConstraintsCollection> collection1 = ConstraintsCollectionFactory::newInstance("collection1");

  boost::shared_ptr<ConstraintsCollection> collection2;
  boost::shared_ptr<ConstraintsCollection> collection3;

  ConstraintsCollection& refCollection1(*collection1);

  ASSERT_NO_THROW(collection2 = ConstraintsCollectionFactory::copyInstance(collection1));
  ASSERT_NO_THROW(collection3 = ConstraintsCollectionFactory::copyInstance(refCollection1));
}

TEST(APICSTRTest, ConstraintsCollectionIterator) {
  boost::shared_ptr<ConstraintsCollection> collection1 = ConstraintsCollectionFactory::newInstance("collection1");

  collection1->addConstraint("model", "constraint1", 1.2, CONSTRAINT_BEGIN);
  collection1->addConstraint("model2", "constraint1", 3.4, CONSTRAINT_BEGIN);

  int nbPoints = 0;
  for (ConstraintsCollection::const_iterator itPt = collection1->cbegin();
            itPt != collection1->cend();
            ++itPt) {
    if (nbPoints == 0) {
      ASSERT_EQ((*itPt)->getTime(), 1.2);
    } else if (nbPoints == 1) {
      ASSERT_EQ((*itPt)->getTime(), 3.4);
    }
    ++nbPoints;
  }
  ASSERT_EQ(nbPoints, 2);
  ConstraintsCollection::const_iterator itPtc(collection1->cbegin());
  ASSERT_EQ((++itPtc)->get()->getTime(), 3.4);
  ASSERT_EQ((--itPtc)->get()->getTime(), 1.2);
  ASSERT_EQ((itPtc++)->get()->getTime(), 1.2);
  ASSERT_EQ((itPtc--)->get()->getTime(), 3.4);
}

}  // namespace constraints
