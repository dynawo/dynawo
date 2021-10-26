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

#include "DYNBusInterfaceIIDM.h"
#include "DYNSwitchInterfaceIIDM.h"
#include "DYNDataInterfaceIIDM.h"

#include "gtest_dynawo.h"

#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/Switch.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>

using powsybl::iidm::Network;
using powsybl::iidm::Substation;
using powsybl::iidm::TopologyKind;
using powsybl::iidm::VoltageLevel;

namespace DYN {

TEST(DataInterfaceTest, Switch) {
  Network network("test", "test");

  Substation& s = network.newSubstation()
                      .setId("S")
                      .add();

  VoltageLevel& vl1 = s.newVoltageLevel()
                          .setId("VL1")
                          .setNominalV(400.)
                          .setTopologyKind(TopologyKind::BUS_BREAKER)
                          .setHighVoltageLimit(420.)
                          .setLowVoltageLimit(380.)
                          .add();

  auto swAdder = vl1.getBusBreakerView().newSwitch().setId("Sw").setName("SwName").setFictitious(false);

  powsybl::iidm::Bus& b1 = vl1.getBusBreakerView().newBus().setId("BUS1").add();
  powsybl::iidm::Bus& b2 = vl1.getBusBreakerView().newBus().setId("BUS2").add();
  swAdder.setBus1("BUS1");
  swAdder.setBus2("BUS2");

  powsybl::iidm::Switch& aSwitch = swAdder.add();
  SwitchInterfaceIIDM sw(aSwitch);
  ASSERT_EQ(sw.getID(), "Sw");
  ASSERT_FALSE(sw.isOpen());
  ASSERT_TRUE(sw.isConnected());
  ASSERT_TRUE(sw.isPartiallyConnected());

  const boost::shared_ptr<BusInterface> x_b1(new BusInterfaceIIDM(b1));
  const boost::shared_ptr<BusInterface> x_b2(new BusInterfaceIIDM(b2));
  sw.setBusInterface1(x_b1);
  sw.setBusInterface2(x_b2);
  ASSERT_EQ(sw.getBusInterface1()->getID(), "BUS1");
  ASSERT_EQ(sw.getBusInterface2()->getID(), "BUS2");

  sw.close();
  ASSERT_FALSE(sw.isOpen());
  ASSERT_TRUE(sw.isConnected());
  ASSERT_TRUE(sw.isPartiallyConnected());
  sw.open();
  ASSERT_TRUE(sw.isOpen());
  ASSERT_FALSE(sw.isConnected());
  ASSERT_FALSE(sw.isPartiallyConnected());
  sw.close();
  ASSERT_FALSE(sw.isOpen());
  ASSERT_TRUE(sw.isConnected());
  ASSERT_TRUE(sw.isPartiallyConnected());

  ASSERT_EQ(sw.getComponentVarIndex("state"), 0);
  ASSERT_EQ(sw.getComponentVarIndex("others"), -1);
}  // TEST(DataInterfaceTest, Switch)

TEST(DataInterfaceTest, SwitchWithSameExtremities) {
  auto network = boost::make_shared<Network>("test", "test");
  Substation& s = network->newSubstation()
                      .setId("S")
                      .add();

  VoltageLevel& vl1 = s.newVoltageLevel()
                          .setId("VL1")
                          .setNominalV(400.)
                          .setTopologyKind(TopologyKind::BUS_BREAKER)
                          .setHighVoltageLimit(420.)
                          .setLowVoltageLimit(380.)
                          .add();

  auto swAdder = vl1.getBusBreakerView().newSwitch().setId("SwSameBus").setName("SwNameSameBus").setFictitious(false);
  auto swAdder2 = vl1.getBusBreakerView().newSwitch().setId("Sw").setName("SwName").setFictitious(false);

  vl1.getBusBreakerView().newBus().setId("BUS1").add();
  vl1.getBusBreakerView().newBus().setId("BUS2").add();
  swAdder.setBus1("BUS1");
  swAdder.setBus2("BUS1");
  swAdder.add();
  swAdder2.setBus1("BUS1");
  swAdder2.setBus2("BUS2");
  swAdder2.add();
  boost::shared_ptr<DataInterfaceIIDM> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  ASSERT_THROW_DYNAWO(data->findComponent("SwSameBus"), Error::MODELER, KeyError_t::UnknownStaticComponent);
}
}  // namespace DYN
