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
 * @file API/CRV/test/TestCurvesCollection.cpp
 * @brief Unit tests for API_CRV
 *
 */

#include "gtest_dynawo.h"

#include "CRVCurvesCollectionFactory.h"
#include "CRVCurvesCollection.h"
#include "CRVCurveFactory.h"
#include "CRVCurve.h"

namespace curves {

//-----------------------------------------------------
// TEST build CurvesCollection
//-----------------------------------------------------

TEST(APICRVTest, CurvesCollection) {
  boost::shared_ptr<CurvesCollection> curvesCollection1 = CurvesCollectionFactory::newInstance("Curves");

  boost::shared_ptr<CurvesCollection> curvesCollection2;
  boost::shared_ptr<CurvesCollection> curvesCollection3;

  CurvesCollection& refCurvesCollection1(*curvesCollection1);

  ASSERT_NO_THROW(curvesCollection2 = CurvesCollectionFactory::copyInstance(curvesCollection1));
  ASSERT_NO_THROW(curvesCollection3 = CurvesCollectionFactory::copyInstance(refCurvesCollection1));
}

TEST(APICRVTest, CurvesCollectionIterator) {
  boost::shared_ptr<CurvesCollection> curvesCollection1 = CurvesCollectionFactory::newInstance("Curves");

  boost::shared_ptr<Curve> curve1 = CurveFactory::newCurve();

  curve1->setVariable("variable1");
  curve1->setAvailable(true);
  curve1->setNegated(false);
  curve1->setAsParameterCurve(true);
  std::vector<double> variables;
  variables.assign(2, 1);
  curve1->setBuffer(&variables[0]);
  curvesCollection1->add(curve1);

  boost::shared_ptr<Curve> curve2 = CurveFactory::newCurve();

  curve2->setVariable("variable2");
  curve2->setAvailable(true);
  curve2->setNegated(true);
  curve2->setAsParameterCurve(false);
  std::vector<double> variables2;
  variables2.assign(3, 4);
  curve2->setBuffer(&variables2[0]);
  curvesCollection1->add(curve2);

  int nbPoints = 0;
  for (CurvesCollection::const_iterator itPt = curvesCollection1->cbegin();
            itPt != curvesCollection1->cend();
            ++itPt) {
    if (nbPoints == 0) {
      ASSERT_EQ((*itPt), curve1);
    } else if (nbPoints == 1) {
      ASSERT_EQ((*itPt), curve2);
    }
    ++nbPoints;
  }
  ASSERT_EQ(nbPoints, 2);
  CurvesCollection::const_iterator itPtc(curvesCollection1->cbegin());
  ASSERT_EQ((++itPtc)->get(), curve2.get());
  ASSERT_EQ((--itPtc)->get(), curve1.get());
  ASSERT_EQ((itPtc++)->get(), curve1.get());
  ASSERT_EQ((itPtc--)->get(), curve2.get());

  nbPoints = 0;
  for (CurvesCollection::iterator itPt = curvesCollection1->begin();
      itPt != curvesCollection1->end();
      ++itPt) {
    if (nbPoints == 0) {
      ASSERT_EQ((*itPt), curve1);
    } else if (nbPoints == 1) {
      ASSERT_EQ((*itPt), curve2);
    }
    ++nbPoints;
  }
  ASSERT_EQ(nbPoints, 2);
  CurvesCollection::iterator itPt(curvesCollection1->begin());
  ASSERT_EQ((++itPt)->get(), curve2.get());
  ASSERT_EQ((--itPt)->get(), curve1.get());
  ASSERT_EQ((itPt++)->get(), curve1.get());
  ASSERT_EQ((itPt--)->get(), curve2.get());
}

}  // namespace curves
