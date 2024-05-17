//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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

#include "DYNCommonConstants.h"
#include "DYNFictBusInterfaceIIDM.h"

#include "gtest_dynawo.h"
#include "DYNCommon.h"


namespace DYN {

TEST(DataInterfaceTest, testFictBusInterface) {
  std::string Id = "fictBus_Id";
  double VNom = 400.;
  std::string country = "FRANCE";
  boost::shared_ptr<BusInterface> fictBus(new FictBusInterfaceIIDM(Id, VNom, country));
  ASSERT_DOUBLE_EQUALS_DYNAWO(fictBus->getV0(), VNom);
  ASSERT_DOUBLE_EQUALS_DYNAWO(fictBus->getVMin(), VNom * uMinPu);
  ASSERT_DOUBLE_EQUALS_DYNAWO(fictBus->getVMax(), VNom * uMaxPu);
  ASSERT_DOUBLE_EQUALS_DYNAWO(fictBus->getAngle0(), defaultAngle0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(fictBus->getVNom(), VNom);
  fictBus->getStateVarV();
  fictBus->getStateVarAngle();
  ASSERT_EQ(fictBus->getID(), Id);
  ASSERT_FALSE(fictBus->hasConnection());
  fictBus->hasConnection(true);
  ASSERT_TRUE(fictBus->hasConnection());
  ASSERT_TRUE(fictBus->getBusBarSectionIdentifiers().empty());
  ASSERT_EQ(fictBus->getComponentVarIndex("v"), FictBusInterfaceIIDM::VAR_V);
  ASSERT_EQ(fictBus->getComponentVarIndex("angle"), FictBusInterfaceIIDM::VAR_ANGLE);
  ASSERT_TRUE(fictBus->isFictitious());
  ASSERT_TRUE(fictBus->hasInitialConditions());
}

}  // namespace DYN
