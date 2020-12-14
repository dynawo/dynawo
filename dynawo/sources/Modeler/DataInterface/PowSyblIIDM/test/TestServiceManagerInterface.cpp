//
// Copyright (c) 2020, RTE (http://www.rte-france.com)
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
#include "DYNDanglingLineInterfaceIIDM.h"
#include "DYNDataInterfaceIIDM.h"
#include "DYNGeneratorInterfaceIIDM.h"
#include "DYNLccConverterInterfaceIIDM.h"
#include "DYNLoadInterfaceIIDM.h"
#include "DYNServiceManagerInterfaceIIDM.h"
#include "DYNShuntCompensatorInterfaceIIDM.h"
#include "DYNSwitchInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNVscConverterInterfaceIIDM.h"
#include "gtest_dynawo.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/DanglingLine.hpp>
#include <powsybl/iidm/DanglingLineAdder.hpp>
#include <powsybl/iidm/GeneratorAdder.hpp>
#include <powsybl/iidm/LccConverterStation.hpp>
#include <powsybl/iidm/LccConverterStationAdder.hpp>
#include <powsybl/iidm/Load.hpp>
#include <powsybl/iidm/LoadAdder.hpp>
#include <powsybl/iidm/ShuntCompensator.hpp>
#include <powsybl/iidm/ShuntCompensatorAdder.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/Switch.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>
#include <powsybl/iidm/VscConverterStation.hpp>
#include <powsybl/iidm/VscConverterStationAdder.hpp>

using boost::shared_ptr;
using powsybl::iidm::Bus;
using powsybl::iidm::DanglingLine;
using powsybl::iidm::LccConverterStation;
using powsybl::iidm::Load;
using powsybl::iidm::LoadType;
using powsybl::iidm::Network;
using powsybl::iidm::ShuntCompensator;
using powsybl::iidm::Substation;
using powsybl::iidm::Switch;
using powsybl::iidm::TopologyKind;
using powsybl::iidm::VoltageLevel;
using powsybl::iidm::VscConverterStation;

namespace DYN {

TEST(DataInterfaceTest, ServiceManager) {
  DataInterfaceIIDM interface(Network("test", "test"));
  auto& network = interface.getNetworkIIDM();

  Substation& s = network.newSubstation().setId("S").add();

  VoltageLevel& vlIIDM1 = s.newVoltageLevel()
                              .setId("VL1")
                              .setNominalVoltage(400.)
                              .setTopologyKind(TopologyKind::BUS_BREAKER)
                              .setHighVoltageLimit(420.)
                              .setLowVoltageLimit(380.)
                              .add();

  auto swAdder = vlIIDM1.getBusBreakerView().newSwitch().setId("Sw").setName("SwName").setFictitious(false);
  swAdder.setBus1("BUS1");
  swAdder.setBus2("BUS2");

  powsybl::iidm::Bus& b1 = vlIIDM1.getBusBreakerView().newBus().setId("BUS1").add();
  powsybl::iidm::Bus& b2 = vlIIDM1.getBusBreakerView().newBus().setId("BUS2").add();
  powsybl::iidm::Bus& b3 = vlIIDM1.getBusBreakerView().newBus().setId("BUS3").add();
  powsybl::iidm::Bus& b4 = vlIIDM1.getBusBreakerView().newBus().setId("BUS4").add();

  auto swAdder2 = vlIIDM1.getBusBreakerView().newSwitch().setId("Sw2").setName("SwName2").setFictitious(false);
  swAdder2.setBus1("BUS1");
  swAdder2.setBus2("BUS3");

  powsybl::iidm::Switch& aSwitch = swAdder.add();
  powsybl::iidm::Switch& aSwitch2 = swAdder2.add();

  VoltageLevelInterfaceIIDM vl(vlIIDM1);

  shared_ptr<BusInterface> bus1(new BusInterfaceIIDM(b1));
  shared_ptr<BusInterface> bus2(new BusInterfaceIIDM(b2));
  shared_ptr<BusInterface> bus3(new BusInterfaceIIDM(b3));
  shared_ptr<BusInterface> bus4(new BusInterfaceIIDM(b4));
  shared_ptr<SwitchInterface> switch1(new SwitchInterfaceIIDM(aSwitch));
  shared_ptr<SwitchInterface> switch2(new SwitchInterfaceIIDM(aSwitch2));

  switch1->setBusInterface1(bus1);
  switch1->setBusInterface2(bus2);

  switch2->setBusInterface1(bus1);
  switch2->setBusInterface2(bus3);

  vl.addBus(bus1);
  vl.addBus(bus2);
  vl.addBus(bus3);
  vl.addBus(bus4);

  interface.initFromIIDM();

  auto serviceManager = interface.getServiceManager();

  ASSERT_THROW_DYNAWO(serviceManager->getBusesConnectedBySwitch("BUS0", vl.getID()), Error::MODELER, KeyError_t::UnknownBus);

  auto connected = serviceManager->getBusesConnectedBySwitch("BUS4", vl.getID());
  ASSERT_EQ(0, connected.size());

  connected = serviceManager->getBusesConnectedBySwitch("BUS1", vl.getID());
  ASSERT_EQ(2, connected.size());
  ASSERT_EQ(connected[0], "BUS2");
  ASSERT_EQ(connected[1], "BUS3");

  connected = serviceManager->getBusesConnectedBySwitch("BUS2", vl.getID());
  ASSERT_EQ(2, connected.size());
  ASSERT_EQ(connected[0], "BUS1");
  ASSERT_EQ(connected[1], "BUS3");

  switch1->open();

  connected = serviceManager->getBusesConnectedBySwitch("BUS1", vl.getID());
  ASSERT_EQ(1, connected.size());
  ASSERT_EQ(connected[0], "BUS3");

  connected = serviceManager->getBusesConnectedBySwitch("BUS2", vl.getID());
  ASSERT_EQ(0, connected.size());

  connected = serviceManager->getBusesConnectedBySwitch("BUS3", vl.getID());
  ASSERT_EQ(1, connected.size());
  ASSERT_EQ(connected[0], "BUS1");
}

}  // namespace DYN
