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
 * @file API/DYD/test/TestMacroConnect.cpp
 * @brief Unit tests for API_DYD
 *
 */

#include "gtest_dynawo.h"

#include "DYDMacroConnectFactory.h"
#include "DYDMacroConnect.h"

namespace dynamicdata {

//-----------------------------------------------------
// TEST build MacroConnect
//-----------------------------------------------------

TEST(APIDYDTest, MacroConnect) {
  boost::shared_ptr<MacroConnect> connect = MacroConnectFactory::newMacroConnect("macroConnector", "model1", "model2");
  connect->setIndex1("index1");
  connect->setIndex2("index2");
  connect->setName1("name1");
  connect->setName2("name2");

  ASSERT_EQ(connect->getConnector(), "macroConnector");
  ASSERT_EQ(connect->getFirstModelId(), "model1");
  ASSERT_EQ(connect->getSecondModelId(), "model2");
  ASSERT_EQ(connect->getIndex1(), "index1");
  ASSERT_EQ(connect->getIndex2(), "index2");
  ASSERT_EQ(connect->getName1(), "name1");
  ASSERT_EQ(connect->getName2(), "name2");
}


}  // namespace dynamicdata
