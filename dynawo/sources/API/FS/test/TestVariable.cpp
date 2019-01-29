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
 * @file API/FS/test/TestVariable.cpp
 * @brief Unit tests for API_FS
 *
 */

#include "gtest_dynawo.h"

#include "FSVariableFactory.h"
#include "FSVariable.h"

namespace finalState {

//-----------------------------------------------------
// TEST check Variable set and get functions
//-----------------------------------------------------

TEST(APIFSTest, Variable) {
  boost::shared_ptr<Variable> variable = VariableFactory::newVariable("id");

  ASSERT_EQ(variable->getId(), "id");
  ASSERT_EQ(variable->getValue(), 0);
  ASSERT_EQ(variable->getAvailable(), false);

  variable->setId("newId");
  variable->setValue(2);

  ASSERT_EQ(variable->getId(), "newId");
  ASSERT_EQ(variable->getValue(), 2);
  ASSERT_EQ(variable->getAvailable(), true);
}

}  // namespace finalState
