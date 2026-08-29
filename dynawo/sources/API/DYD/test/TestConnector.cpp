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
 * @file API/DYD/test/TestConnector.cpp
 * @brief Unit tests for API_DYD
 *
 */

#include "gtest_dynawo.h"

#include "DYDConnectorFactory.h"
#include "DYDConnector.h"

namespace dynamicdata {

//-----------------------------------------------------
// TEST build connector
//-----------------------------------------------------
TEST(APIDYDTest, Connector) {
  boost::shared_ptr<Connector> connector;
  connector = boost::shared_ptr<Connector>(ConnectorFactory::newConnector("model1", "var1", "model2", "var2"));

  ASSERT_EQ(connector->getFirstModelId(), "model1");
  ASSERT_EQ(connector->getSecondModelId(), "model2");
  ASSERT_EQ(connector->getFirstVariableId(), "var1");
  ASSERT_EQ(connector->getSecondVariableId(), "var2");
}


}  // namespace dynamicdata
