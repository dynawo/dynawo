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
 * @file API/CRV/test/TestCurve.cpp
 * @brief Unit tests for API_CRV
 *
 */

#include "gtest_dynawo.h"

#include "CRVCurveFactory.h"
#include "CRVCurve.h"
#include "CRVPoint.h"

namespace curves {

//-----------------------------------------------------
// TEST build Curve
//-----------------------------------------------------

TEST(APICRVTest, Curve) {
  boost::shared_ptr<Curve> curve1 = CurveFactory::newCurve();

  // test default constructor attributes
  ASSERT_EQ(curve1->getModelName(), "");
  ASSERT_EQ(curve1->getVariable(), "");
  ASSERT_EQ(curve1->getFoundVariableName(), "");
  ASSERT_EQ(curve1->getAvailable(), false);
  ASSERT_EQ(curve1->isParameterCurve(), false);
  ASSERT_EQ(curve1->getCurveType(), Curve::UNDEFINED);

  // set attributes
  curve1->setModelName("model1");
  curve1->setVariable("variable1");
  curve1->setFoundVariableName("foundVariable1");
  curve1->setAvailable(true);
  curve1->setNegated(false);
  curve1->setAsParameterCurve(true);
  curve1->setCurveType(Curve::DISCRETE_VARIABLE);
  std::vector<double> variables;
  variables.assign(2, 1);
  curve1->setBuffer(&variables[0]);
  curve1->setFactor(2.0);

  // test setted attributes
  ASSERT_EQ(curve1->getModelName(), "model1");
  ASSERT_EQ(curve1->getVariable(), "variable1");
  ASSERT_EQ(curve1->getFoundVariableName(), "foundVariable1");
  ASSERT_EQ(curve1->getAvailable(), true);
  ASSERT_EQ(curve1->getNegated(), false);
  ASSERT_EQ(curve1->isParameterCurve(), true);
  ASSERT_EQ(curve1->getBuffer(), &variables[0]);
  ASSERT_EQ(curve1->getCurveType(), Curve::DISCRETE_VARIABLE);
  ASSERT_DOUBLE_EQ(curve1->getFactor(), 2.0);
}

TEST(APICRVTest, CurveUpdate) {
  std::shared_ptr<Curve> curve1 = CurveFactory::newCurve();

  curve1->setAvailable(true);
  curve1->setAsParameterCurve(true);
  curve1->setNegated(false);
  std::vector<double> variables;
  variables.assign(2, 1);
  curve1->setBuffer(&variables[0]);

  // test update method (enter update methode several times to test all conditions)
  ASSERT_NO_THROW(curve1->update(0));  // the curve is available and is a parameter curve
  curve1->setAsParameterCurve(false);
  ASSERT_NO_THROW(curve1->update(1));  // the curve is available and is not a parameter curve
  curve1->setNegated(true);
  ASSERT_NO_THROW(curve1->update(2));  // the curve is available and is not a parameter curve and the value has to be negated

  int nbPoints = 0;
  for (const auto& point : curve1->getPoints()) {
    if (nbPoints == 0) {
      ASSERT_EQ(point->getTime(), 0);  // uptade method called at time = 0
      ASSERT_EQ(point->getValue(), 0);  // the curve is a parameter curve so the value is set to zero (default value)
    } else if (nbPoints == 1) {
      ASSERT_EQ(point->getTime(), 1);  // uptade method called at time = 1
      ASSERT_EQ(point->getValue(), 1);  // negated is false so the value is 1 (value stored in the vector 'variables')
    } else {
      ASSERT_EQ(point->getTime(), 2);  // uptade method called at time = 2
      ASSERT_EQ(point->getValue(), -1);  // negated is true so the value is -1 (inverse of the value stored in the vector 'variables')
    }
    ++nbPoints;
  }
  ASSERT_EQ(nbPoints, 3);
}

TEST(APICRVTest, CurveUpdateParameterCurveValue) {
  boost::shared_ptr<Curve> curve1 = CurveFactory::newCurve();

  curve1->setVariable("variable1");
  curve1->setAvailable(true);
  curve1->setNegated(false);
  curve1->setAsParameterCurve(true);
  std::vector<double> variables;
  variables.assign(2, 1);
  curve1->setBuffer(&variables[0]);

  // update parameter curve (set the value of parameter curve to zero)
  ASSERT_NO_THROW(curve1->update(0));
  ASSERT_NO_THROW(curve1->update(1));
  ASSERT_NO_THROW(curve1->update(2));

  // test updateParameterCurveValue (set the value to a given value)
  ASSERT_NO_THROW(curve1->updateParameterCurveValue("variable1", 5));

  int nbPoints = 0;
  for (const auto& point : curve1->getPoints()) {
    if (nbPoints == 0) {
      ASSERT_EQ(point->getTime(), 0);  // uptade method called at time = 0
      ASSERT_EQ(point->getValue(), 5);  // the value has been set to 5 by the updateParameterCurveValue method
    } else if (nbPoints == 1) {
      ASSERT_EQ(point->getTime(), 1);  // uptade method called at time = 1
      ASSERT_EQ(point->getValue(), 5);  // the value has been set to 5 by the updateParameterCurveValue method
    } else {
      ASSERT_EQ(point->getTime(), 2);  // uptade method called at time = 2
      ASSERT_EQ(point->getValue(), 5);  // the value has been set to 5 by the updateParameterCurveValue method
    }
    ++nbPoints;
  }
  ASSERT_EQ(nbPoints, 3);

  boost::shared_ptr<Curve> curve2 = CurveFactory::newCurve();
  curve2->setVariable("variable1");
  curve2->setAvailable(true);
  curve2->setNegated(false);
  curve2->setAsParameterCurve(true);
  std::vector<double> variables2;
  variables2.assign(1, 2);
  curve1->setBuffer(&variables2[0]);

  boost::shared_ptr<Curve> curve3 = CurveFactory::newCurve();
  double val3 = 3;
  curve3->setVariable("variable3");
  curve3->setAvailable(true);
  curve3->setNegated(false);
  curve3->setFactor(10);
  curve3->setBuffer(&val3);
  curve3->update(2);
  ASSERT_TRUE(curve3->getPoints().at(0)->getTime() == 2.);
  ASSERT_TRUE(curve3->getPoints().at(0)->getValue() == 30.);
}

}  // namespace curves
