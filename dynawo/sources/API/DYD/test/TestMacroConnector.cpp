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
 * @file API/DYD/test/TestMacroConnector.cpp
 * @brief Unit tests for API_DYD
 *
 */

#include "gtest_dynawo.h"

#include "DYDMacroConnectorFactory.h"
#include "DYDMacroConnector.h"

namespace dynamicdata {

//-----------------------------------------------------
// TEST build MacroConnector
//-----------------------------------------------------

TEST(APIDYDTest, MacroConnector) {
  const std::unique_ptr<MacroConnector> macroConnector = MacroConnectorFactory::newMacroConnector("macroConnector");
  macroConnector->addConnect("var1", "var2");
  macroConnector->addConnect("var4", "var3");

  macroConnector->addInitConnect("var1_0", "var2_0");
  macroConnector->addInitConnect("var4_0", "var3_0");

  ASSERT_EQ(macroConnector->getId(), "macroConnector");

  const std::map<std::string, std::unique_ptr<MacroConnection> >& connect = macroConnector->getConnectors();
  ASSERT_EQ(connect.size(), 2);
  std::map<std::string, std::unique_ptr<MacroConnection> >::const_iterator iter = connect.begin();
  int index = 0;
  for (; iter != connect.end(); ++iter) {
    if (index == 0)
      ASSERT_EQ(iter->first, "var1_var2");
    else
      ASSERT_EQ(iter->first, "var3_var4");
    ++index;
  }

  const std::map<std::string, std::unique_ptr<MacroConnection> >& initConnect = macroConnector->getInitConnectors();
  ASSERT_EQ(initConnect.size(), 2);
  std::map<std::string, std::unique_ptr<MacroConnection> >::const_iterator iter2 = initConnect.begin();
  int index2 = 0;
  for (; iter2 != initConnect.end(); ++iter2) {
    if (index2 == 0)
      ASSERT_EQ(iter2->first, "var1_0_var2_0");
    else
      ASSERT_EQ(iter2->first, "var3_0_var4_0");
    ++index2;
  }
}


}  // namespace dynamicdata
