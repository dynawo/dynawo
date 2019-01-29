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
}

}  // namespace constraints
