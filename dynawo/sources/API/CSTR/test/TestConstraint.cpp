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
 * @file API/CSTR/test/TestConstraint.cpp
 * @brief Unit tests for API_CSTR
 *
 */

#include "gtest_dynawo.h"

#include "CSTRConstraintFactory.h"
#include "CSTRConstraint.h"

namespace constraints {

//-----------------------------------------------------
// TEST for Constraints
//-----------------------------------------------------

TEST(APICSTRTest, Constraint) {
  boost::shared_ptr<Constraint> constraint = ConstraintFactory::newConstraint();

  constraint->setModelName("model");
  constraint->setType(CONSTRAINT_BEGIN);
  constraint->setTime(1.2);
  constraint->setDescription("constraint");

  ASSERT_EQ(constraint->getModelName(), "model");
  ASSERT_EQ(constraint->getType(), CONSTRAINT_BEGIN);
  ASSERT_EQ(constraint->getTime(), 1.2);
  ASSERT_EQ(constraint->getDescription(), "constraint");
  ASSERT_FALSE(constraint->getData());
}

TEST(APICSTRTest, ConstraintData) {
  ConstraintData a = ConstraintData(ConstraintData::UInfUmin, 120.0, 20.0);

  ASSERT_EQ(a.kind, ConstraintData::UInfUmin);
  ASSERT_EQ(a.limit, 120.0);
  ASSERT_EQ(a.value, 20.0);
  ASSERT_FALSE(a.side);
  ASSERT_FALSE(a.acceptableDuration);

  ConstraintData b = ConstraintData(ConstraintData::PATL, 0.0, 0.0, 1, 0.5);
  ASSERT_EQ(b.kind, ConstraintData::PATL);
  ASSERT_EQ(b.limit, 0.0);
  ASSERT_EQ(b.value, 0.0);
  ASSERT_EQ(*b.side, 1);
  ASSERT_EQ(*b.acceptableDuration, 0.5);
}

TEST(APICSTRTest, ConstraintWithData) {
  boost::shared_ptr<Constraint> constraint = ConstraintFactory::newConstraint();

  constraint->setModelName("model2");
  constraint->setType(CONSTRAINT_END);
  constraint->setTime(0.3);
  constraint->setDescription("constraint");
  constraint->setData(ConstraintData(ConstraintData::PATL, 0.1, 0.2, 2, 0.0));

  ASSERT_EQ(constraint->getModelName(), "model2");
  ASSERT_EQ(constraint->getType(), CONSTRAINT_END);
  ASSERT_EQ(constraint->getTime(), 0.3);
  ASSERT_EQ(constraint->getDescription(), "constraint");
  ASSERT_EQ(constraint->getData().value().kind, ConstraintData::PATL);
  ASSERT_EQ(constraint->getData().value().limit, 0.1);
  ASSERT_EQ(constraint->getData().value().value, 0.2);
  ASSERT_EQ(*constraint->getData().value().side, 2);
  ASSERT_EQ(*constraint->getData().value().acceptableDuration, 0.0);
}

}  // namespace constraints
