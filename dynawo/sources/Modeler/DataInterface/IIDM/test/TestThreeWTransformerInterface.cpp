//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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

#include "DYNThreeWTransformerInterfaceIIDM.h"

#include <boost/make_shared.hpp>

#include <IIDM/Network.h>
#include <IIDM/builders/BusBuilder.h>
#include <IIDM/builders/NetworkBuilder.h>
#include <IIDM/builders/SubstationBuilder.h>
#include <IIDM/builders/Transformer3WindingsBuilder.h>
#include <IIDM/builders/VoltageLevelBuilder.h>
#include <IIDM/components/Bus.h>
#include <IIDM/components/Substation.h>
#include <IIDM/components/Transformer3Windings.h>
#include <IIDM/components/VoltageLevel.h>

#include "gtest_dynawo.h"

#include "DYNBusInterfaceIIDM.h"
#include "DYNCurrentLimitInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"

namespace DYN {

using IIDM::Bus;
using IIDM::Network;
using IIDM::Substation;
using IIDM::Transformer3Windings;
using IIDM::VoltageLevel;

TEST(DataInterfaceTest, ThreeWTransformer_1) {
  IIDM::builders::NetworkBuilder nb;
  boost::shared_ptr<Network> network = boost::make_shared<Network>(nb.build("test"));

  IIDM::builders::SubstationBuilder ssb;
  Substation substation = ssb.build("S1");
  network->add(substation);

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::bus_breaker);
  vlb.nominalV(400.0);
  VoltageLevel vl1 = vlb.build("VL1");
  vlb.nominalV(200.0);
  VoltageLevel vl2 = vlb.build("VL2");
  vlb.nominalV(100.0);
  VoltageLevel vl3 = vlb.build("VL3");

  IIDM::builders::BusBuilder bb;
  bb.v(401.1);
  bb.angle(0.01);
  Bus vl1Bus1 = bb.build("VL1_BUS1");
  vl1.add(vl1Bus1);
  bb.v(202.2);
  bb.angle(0.02);
  Bus vl2Bus1 = bb.build("VL2_BUS1");
  vl2.add(vl2Bus1);
  bb.v(103.3);
  bb.angle(0.03);
  Bus vl3Bus1 = bb.build("VL3_BUS1");
  vl3.add(vl3Bus1);
  substation.add(vl1);
  substation.add(vl2);
  substation.add(vl3);

  IIDM::connection_status_t cs = {true /*connected*/};
  IIDM::Port p1("VL1_BUS1", cs), p2("VL2_BUS1", cs), p3("VL3_BUS1", cs);
  IIDM::Connection c1("VL1", p1, IIDM::side_1), c2("VL2", p2, IIDM::side_2), c3("VL3", p3, IIDM::side_3);
  IIDM::builders::Transformer3WindingsBuilder tfob;
  tfob.r1(1.1);
  tfob.x1(1.2);
  tfob.g1(1.3);
  tfob.b1(1.4);
  tfob.ratedU1(400.0);
  tfob.r2(2.1);
  tfob.x2(2.2);
  tfob.ratedU2(200.0);
  tfob.r3(3.1);
  tfob.x3(3.2);
  tfob.ratedU3(100.0);
  Transformer3Windings transformer0 = tfob.build("3WT_VL1_VL2_VL3");
  substation.add(transformer0, c1, c2, c3);
  // The transformer that has been connected is a copy of the transformer0 that has been added to the substation
  Transformer3Windings& transformer = *substation.find_threeWindingsTransformer("3WT_VL1_VL2_VL3");

  ThreeWTransformerInterfaceIIDM tfoInterface(transformer);
  ASSERT_EQ(tfoInterface.getID(), "3WT_VL1_VL2_VL3");

  ASSERT_EQ(tfoInterface.getComponentVarIndex(std::string("invalid")), -1);

  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces1().size(), 0);
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces2().size(), 0);
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces3().size(), 0);
  const boost::shared_ptr<CurrentLimitInterface> curLimItf1(new CurrentLimitInterfaceIIDM(1, 1));
  tfoInterface.addCurrentLimitInterface1(curLimItf1);
  const boost::shared_ptr<CurrentLimitInterface> curLimItf2(new CurrentLimitInterfaceIIDM(2, 2));
  tfoInterface.addCurrentLimitInterface2(curLimItf2);
  const boost::shared_ptr<CurrentLimitInterface> curLimItf3(new CurrentLimitInterfaceIIDM(3, 3));
  tfoInterface.addCurrentLimitInterface3(curLimItf3);
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces1().size(), 1);
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces2().size(), 1);
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces3().size(), 1);

  ASSERT_FALSE(tfoInterface.getBusInterface1().get());
  const boost::shared_ptr<BusInterface> busItf1(new BusInterfaceIIDM(vl1Bus1));
  tfoInterface.setBusInterface1(busItf1);
  ASSERT_EQ(tfoInterface.getBusInterface1().get()->getID(), "VL1_BUS1");

  ASSERT_FALSE(tfoInterface.getBusInterface2().get());
  const boost::shared_ptr<BusInterface> busItf2(new BusInterfaceIIDM(vl2Bus1));
  tfoInterface.setBusInterface2(busItf2);
  ASSERT_EQ(tfoInterface.getBusInterface2().get()->getID(), "VL2_BUS1");

  ASSERT_FALSE(tfoInterface.getBusInterface3().get());
  const boost::shared_ptr<BusInterface> busItf3(new BusInterfaceIIDM(vl3Bus1));
  tfoInterface.setBusInterface3(busItf3);
  ASSERT_EQ(tfoInterface.getBusInterface3().get()->getID(), "VL3_BUS1");

  const boost::shared_ptr<VoltageLevelInterface> voltageLevelItf1(new VoltageLevelInterfaceIIDM(vl1));
  tfoInterface.setVoltageLevelInterface1(voltageLevelItf1);
  const boost::shared_ptr<VoltageLevelInterface> voltageLevelItf2(new VoltageLevelInterfaceIIDM(vl2));
  tfoInterface.setVoltageLevelInterface2(voltageLevelItf2);
  const boost::shared_ptr<VoltageLevelInterface> voltageLevelItf3(new VoltageLevelInterfaceIIDM(vl3));
  tfoInterface.setVoltageLevelInterface3(voltageLevelItf3);

  ASSERT_TRUE(tfoInterface.isConnected());
  ASSERT_TRUE(tfoInterface.isPartiallyConnected());

  ASSERT_TRUE(tfoInterface.getInitialConnected1());
  transformer.disconnect(IIDM::side_1);
  ASSERT_TRUE(tfoInterface.getInitialConnected1());
  ASSERT_FALSE(tfoInterface.isConnected());
  ASSERT_TRUE(tfoInterface.isPartiallyConnected());

  ASSERT_TRUE(tfoInterface.getInitialConnected2());
  transformer.disconnect(IIDM::side_2);
  ASSERT_TRUE(tfoInterface.getInitialConnected2());
  ASSERT_FALSE(tfoInterface.isConnected());
  ASSERT_TRUE(tfoInterface.isPartiallyConnected());

  ASSERT_TRUE(tfoInterface.getInitialConnected3());
  transformer.disconnect(IIDM::side_3);
  ASSERT_TRUE(tfoInterface.getInitialConnected3());
  ASSERT_FALSE(tfoInterface.isConnected());
  ASSERT_FALSE(tfoInterface.isPartiallyConnected());
}  // TEST(DataInterfaceTest, ThreeWTransformer_1)
}  // namespace DYN
