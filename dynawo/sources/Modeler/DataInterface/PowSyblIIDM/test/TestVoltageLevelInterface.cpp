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

#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNBusInterfaceIIDM.h"
#include "DYNSwitchInterfaceIIDM.h"
#include "DYNLoadInterfaceIIDM.h"
#include "DYNVscConverterInterfaceIIDM.h"

#include "gtest_dynawo.h"

#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>
#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Switch.hpp>
#include <powsybl/iidm/Load.hpp>
#include <powsybl/iidm/LoadAdder.hpp>
#include <powsybl/iidm/VscConverterStation.hpp>
#include <powsybl/iidm/VscConverterStationAdder.hpp>

using powsybl::iidm::Network;
using powsybl::iidm::Substation;
using powsybl::iidm::TopologyKind;
using powsybl::iidm::VoltageLevel;
using powsybl::iidm::Bus;
using powsybl::iidm::Switch;
using powsybl::iidm::Load;
using powsybl::iidm::LoadType;
using powsybl::iidm::VscConverterStation;
using boost::shared_ptr;

namespace DYN {

TEST(DataInterfaceTest, VoltageLevel) {
  Network network("test", "test");

  Substation& s = network.newSubstation()
                      .setId("S")
                      .add();

  VoltageLevel& vlIIDM1 = s.newVoltageLevel()
                          .setId("VL1")
                          .setNominalVoltage(400.)
                          .setTopologyKind(TopologyKind::BUS_BREAKER)
                          .setHighVoltageLimit(420.)
                          .setLowVoltageLimit(380.)
                          .add();

  Bus& iidmBus = vlIIDM1.getBusBreakerView().newBus()
      .setId("Bus1")
      .add();

  auto swAdder = vlIIDM1.getBusBreakerView().newSwitch().setId("Sw").setName("SwName").setFictitious(false);

  powsybl::iidm::Bus& b1 = vlIIDM1.getBusBreakerView().newBus().setId("BUS1").add();
  powsybl::iidm::Bus& b2 = vlIIDM1.getBusBreakerView().newBus().setId("BUS2").add();
  swAdder.setBus1("BUS1");
  swAdder.setBus2("BUS2");

  powsybl::iidm::Switch& aSwitch = swAdder.add();

  powsybl::iidm::Bus& b4 = vlIIDM1.getBusBreakerView().newBus().setId("BUS4").add();
  VscConverterStation& vscIIDM1 = vlIIDM1.newVscConverterStation()
      .setId("VSC1")
      .setName("VSC1_NAME")
      .setBus(b4.getId())
      .setConnectableBus(b4.getId())
      .setLossFactor(3.0)
      .setVoltageRegulatorOn(true)
      .setVoltageSetpoint(4.0)
      .setReactivePowerSetpoint(5.0)
      .add();

  Load& loadIIDM1 = vlIIDM1.newLoad()
      .setId("LOAD1")
      .setBus("Bus1")
      .setConnectableBus("Bus1")
      .setName("LOAD1_NAME")
      .setLoadType(LoadType::UNDEFINED)
      .setP0(50.0)
      .setQ0(40.0)
      .add();

  VoltageLevel& vlIIDM2 = s.newVoltageLevel()
                          .setId("VL2")
                          .setNominalVoltage(63.)
                          .setTopologyKind(TopologyKind::NODE_BREAKER)
                          .setHighVoltageLimit(420.)
                          .setLowVoltageLimit(380.)
                          .add();
  VoltageLevelInterfaceIIDM vl(vlIIDM1);
  VoltageLevelInterfaceIIDM vl2(vlIIDM2);
  shared_ptr<BusInterface> bus1(new BusInterfaceIIDM(b1));
  shared_ptr<BusInterface> bus2(new BusInterfaceIIDM(b2));
  shared_ptr<BusInterface> bus3(new BusInterfaceIIDM(iidmBus));
  shared_ptr<BusInterface> bus4(new BusInterfaceIIDM(b4));
  shared_ptr<SwitchInterface> switch1(new SwitchInterfaceIIDM(aSwitch));
  shared_ptr<LoadInterface> load1(new LoadInterfaceIIDM(loadIIDM1));
  switch1->setBusInterface1(bus2);
  switch1->setBusInterface2(bus3);
  load1->setBusInterface(bus1);
  shared_ptr<VscConverterInterface> vsc1(new VscConverterInterfaceIIDM(vscIIDM1));
  vsc1->setBusInterface(bus4);

  ASSERT_EQ(vl.getID(), "VL1");
  ASSERT_EQ(vl.getVNom(), 400.);
  ASSERT_EQ(vl.getVoltageLevelTopologyKind(), VoltageLevelInterface::BUS_BREAKER);
  ASSERT_EQ(vl2.getVoltageLevelTopologyKind(), VoltageLevelInterface::NODE_BREAKER);
  ASSERT_NO_THROW(vl.connectNode(0));
  ASSERT_NO_THROW(vl.disconnectNode(0));
  ASSERT_NO_THROW(vl.isNodeConnected(0));

  ASSERT_EQ(vl.getBuses().size(), 0);
  vl.addBus(bus1);
  ASSERT_EQ(vl.getBuses().size(), 1);

  ASSERT_EQ(vl.getSwitches().size(), 0);
  vl.addSwitch(switch1);
  ASSERT_EQ(vl.getSwitches().size(), 1);

  ASSERT_EQ(vl.getLoads().size(), 0);
  vl.addLoad(load1);
  ASSERT_EQ(vl.getLoads().size(), 1);

  ASSERT_EQ(vl.getVscConverters().size(), 0);
  vl.addVscConverter(vsc1);
  ASSERT_EQ(vl.getVscConverters().size(), 1);

  ASSERT_FALSE(bus1->hasConnection());
  ASSERT_FALSE(bus2->hasConnection());
  ASSERT_FALSE(bus3->hasConnection());
  ASSERT_FALSE(bus4->hasConnection());
  vl.mapConnections();
  ASSERT_FALSE(bus1->hasConnection());
  ASSERT_FALSE(bus2->hasConnection());
  ASSERT_FALSE(bus3->hasConnection());
  ASSERT_FALSE(bus4->hasConnection());
  switch1->hasDynamicModel(true);
  vl.mapConnections();
  ASSERT_FALSE(bus1->hasConnection());
  ASSERT_TRUE(bus2->hasConnection());
  ASSERT_TRUE(bus3->hasConnection());
  ASSERT_FALSE(bus4->hasConnection());
  load1->hasDynamicModel(true);
  vl.mapConnections();
  ASSERT_TRUE(bus1->hasConnection());
  ASSERT_TRUE(bus2->hasConnection());
  ASSERT_TRUE(bus3->hasConnection());
  ASSERT_FALSE(bus4->hasConnection());
  vsc1->hasDynamicModel(true);
  vl.mapConnections();
  ASSERT_TRUE(bus1->hasConnection());
  ASSERT_TRUE(bus2->hasConnection());
  ASSERT_TRUE(bus3->hasConnection());
  ASSERT_TRUE(bus4->hasConnection());
}  // TEST(DataInterfaceTest, VoltageLevel)
}  // namespace DYN
