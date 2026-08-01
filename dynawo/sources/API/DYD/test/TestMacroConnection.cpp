//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file API/DYD/test/TestMacroConnection.cpp
 * @brief Unit tests for API_DYD
 *
 */

#include "gtest_dynawo.h"

#include "DYDMacroConnection.h"
#include "DYDMacroConnectionFactory.h"

namespace dynamicdata {

//-----------------------------------------------------
// TEST build MacroConnection
//-----------------------------------------------------

TEST(APIDYDTest, MacroConnection) {
  boost::shared_ptr<MacroConnection> connection;
  connection = boost::shared_ptr<MacroConnection>(MacroConnectionFactory::newMacroConnection("var1", "var2"));

  ASSERT_EQ(connection->getFirstVariableId(), "var1");
  ASSERT_EQ(connection->getSecondVariableId(), "var2");
}


}  // namespace dynamicdata
