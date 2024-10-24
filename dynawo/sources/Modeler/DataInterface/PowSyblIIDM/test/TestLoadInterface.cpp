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

#include "DYNLoadInterfaceIIDM.h"

#include "DYNBusInterfaceIIDM.h"
#include "DYNInjectorInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Load.hpp>
#include <powsybl/iidm/LoadAdder.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/Substation.hpp>

#include "gtest_dynawo.h"

namespace powsybl {
namespace iidm {

static Network
CreateLoadNetwork() {
  Network network("test", "test");

  Substation& substation = network.newSubstation()
                               .setId("S1")
                               .setName("S1_NAME")
                               .setCountry(powsybl::iidm::Country::FR)
                               .setTso("TSO")
                               .add();

  VoltageLevel& vl1 = substation.newVoltageLevel()
                          .setId("VL1")
                          .setName("VL1_NAME")
                          .setTopologyKind(TopologyKind::BUS_BREAKER)
                          .setNominalV(382.0)
                          .setLowVoltageLimit(340.0)
                          .setHighVoltageLimit(420.0)
                          .add();

  vl1.getBusBreakerView().newBus().setId("VL1_BUS1").add();

  return network;
}  // CreateLoadNetwork
}  // namespace iidm
}  // namespace powsybl

namespace DYN {
using powsybl::iidm::CreateLoadNetwork;

TEST(DataInterfaceTest, Load_1) {
  powsybl::iidm::Network network = CreateLoadNetwork();
  powsybl::iidm::VoltageLevel& vl1 = network.getVoltageLevel("VL1");
  powsybl::iidm::Bus& bus1 = vl1.getBusBreakerView().getBus("VL1_BUS1");
  vl1.newLoad()
      .setId("LOAD1")
      .setBus("VL1_BUS1")
      .setConnectableBus("VL1_BUS1")
      .setName("LOAD1_NAME")
      .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
      .setFictitious(true)
      .setP0(50.0)
      .setQ0(40.0)
      .add();
  powsybl::iidm::Load& load = network.getLoad("LOAD1");

  LoadInterfaceIIDM loadIfce(load);
  const std::shared_ptr<VoltageLevelInterface> voltageLevelIfce = std::make_shared<DYN::VoltageLevelInterfaceIIDM>(vl1);
  loadIfce.setVoltageLevelInterface(voltageLevelIfce);

  ASSERT_EQ(loadIfce.getComponentVarIndex(std::string("p")), LoadInterfaceIIDM::VAR_P);
  ASSERT_EQ(loadIfce.getComponentVarIndex(std::string("P1")), -1);
  ASSERT_EQ(loadIfce.getComponentVarIndex(std::string("q")), LoadInterfaceIIDM::VAR_Q);
  ASSERT_EQ(loadIfce.getComponentVarIndex(std::string("state")), LoadInterfaceIIDM::VAR_STATE);

  ASSERT_EQ(loadIfce.getID(), load.getId());
  ASSERT_DOUBLE_EQ(loadIfce.getPUnderVoltage(), 0.0);

  ASSERT_TRUE(loadIfce.getInitialConnected());
  ASSERT_TRUE(loadIfce.isConnected());
  ASSERT_TRUE(loadIfce.isPartiallyConnected());
  load.getTerminal().disconnect();
  ASSERT_FALSE(loadIfce.isPartiallyConnected());
  ASSERT_FALSE(loadIfce.isConnected());
  ASSERT_TRUE(loadIfce.getInitialConnected());

  ASSERT_EQ(loadIfce.getBusInterface().get(), nullptr);
  std::unique_ptr<BusInterface> busIfce(new BusInterfaceIIDM(bus1));
  loadIfce.setBusInterface(std::move(busIfce));
  ASSERT_EQ(loadIfce.getBusInterface().get()->getID(), "VL1_BUS1");

  ASSERT_FALSE(load.getTerminal().isConnected());
  ASSERT_FALSE(loadIfce.hasPInjector());
  ASSERT_FALSE(loadIfce.hasQInjector());

  ASSERT_DOUBLE_EQ(loadIfce.getP0(), 50.0);
  ASSERT_DOUBLE_EQ(loadIfce.getP(), 0.0);
  load.getTerminal().setP(1000.0);
  ASSERT_TRUE(loadIfce.hasPInjector());
  ASSERT_DOUBLE_EQ(loadIfce.getP(), 1000.0);

  ASSERT_DOUBLE_EQ(loadIfce.getQ0(), 40.0);
  ASSERT_DOUBLE_EQ(loadIfce.getQ(), 0.0);
  load.getTerminal().setQ(499.0);
  ASSERT_TRUE(loadIfce.hasQInjector());
  ASSERT_DOUBLE_EQ(loadIfce.getQ(), 499.0);

  ASSERT_FALSE(loadIfce.hasInitialConditions());

  ASSERT_TRUE(loadIfce.isFictitious());

  loadIfce.importStaticParameters();
  loadIfce.setBusInterface(nullptr);
  loadIfce.importStaticParameters();
  ASSERT_EQ(loadIfce.getCountry(), "");
  loadIfce.setCountry("AF");
  ASSERT_EQ(loadIfce.getCountry(), "AF");

  ASSERT_DOUBLE_EQ(loadIfce.getVNomInjector(), 382.0);
  ASSERT_EQ(loadIfce.getVoltageLevelInterfaceInjector(), voltageLevelIfce);

  load.setFictitious(false);
  LoadInterfaceIIDM loadIfceNotFictitious(load);
  loadIfceNotFictitious.setVoltageLevelInterface(voltageLevelIfce);
  ASSERT_FALSE(loadIfceNotFictitious.isFictitious());
}  // TEST(DataInterfaceTest, Load_1)

TEST(DataInterfaceTest, Load_2) {  // tests assuming getInitialConnected == false
  powsybl::iidm::Network network = CreateLoadNetwork();
  powsybl::iidm::VoltageLevel& vl1 = network.getVoltageLevel("VL1");
  vl1.newLoad()
      .setId("LOAD")
      .setBus("VL1_BUS1")
      .setConnectableBus("VL1_BUS1")
      .setName("LOAD1_NAME")
      .setLoadType(powsybl::iidm::LoadType::FICTITIOUS)
      .setFictitious(false)
      .setP0(5000.0)
      .setQ0(4000.0)
      .add();
  powsybl::iidm::Load& load = network.getLoad("LOAD");

  LoadInterfaceIIDM loadIfce(load);
  const std::shared_ptr<VoltageLevelInterface> voltageLevelIfce = std::make_shared<DYN::VoltageLevelInterfaceIIDM>(vl1);
  loadIfce.setVoltageLevelInterface(voltageLevelIfce);
  ASSERT_EQ(loadIfce.getID(), "LOAD");

  load.getTerminal().disconnect();
  ASSERT_FALSE(loadIfce.getInitialConnected());

  ASSERT_FALSE(loadIfce.hasPInjector());
  ASSERT_FALSE(loadIfce.hasQInjector());
  ASSERT_DOUBLE_EQ(loadIfce.getP(), 0.0);
  ASSERT_DOUBLE_EQ(loadIfce.getQ(), 0.0);
  ASSERT_TRUE(loadIfce.isFictitious());
  ASSERT_FALSE(loadIfce.hasInitialConditions());
}  // TEST(DataInterfaceTest, Load_2)

TEST(DataInterfaceTest, Load_3) {
  powsybl::iidm::Network network = CreateLoadNetwork();
  powsybl::iidm::VoltageLevel& vl1 = network.getVoltageLevel("VL1");
  vl1.newLoad()
      .setId("LOAD1")
      .setBus("VL1_BUS1")
      .setConnectableBus("VL1_BUS1")
      .setName("LOAD1_NAME")
      .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
      .setFictitious(true)
      .setP0(50.0)
      .setQ0(40.0)
      .add();
  powsybl::iidm::Load& load = network.getLoad("LOAD1");

  load.getTerminal().setP(0.);
  load.getTerminal().setQ(0.);
  LoadInterfaceIIDM loadIfce(load);

  ASSERT_TRUE(loadIfce.hasInitialConditions());
}  // TEST(DataInterfaceTest, Load_3)
}  // namespace DYN
