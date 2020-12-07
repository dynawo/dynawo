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

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Load.hpp>
#include <powsybl/iidm/LoadAdder.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/Substation.hpp>

#include "gtest_dynawo.h"

namespace DYN {

using powsybl::iidm::Bus;
using powsybl::iidm::Load;
using powsybl::iidm::LoadType;
using powsybl::iidm::Network;
using powsybl::iidm::Substation;
using powsybl::iidm::TopologyKind;
using powsybl::iidm::VoltageLevel;

TEST(DataInterfaceTest, Load_1) {
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
                          .setNominalVoltage(380.0)
                          .setLowVoltageLimit(340.0)
                          .setHighVoltageLimit(420.0)
                          .add();

  Bus& bus1 = vl1.getBusBreakerView().newBus().setId("VL1_BUS1").add();

  vl1.newLoad()
      .setId("LOAD1")
      .setBus("VL1_BUS1")
      .setConnectableBus("VL1_BUS1")
      .setName("LOAD1_NAME")
      .setLoadType(LoadType::UNDEFINED)
      .setP0(50.0)
      .setQ0(40.0)
      .add();

  Load& load = network.getLoad("LOAD1");
  LoadInterfaceIIDM loadIfce(load);

  ASSERT_EQ(loadIfce.getComponentVarIndex(std::string("p")), LoadInterfaceIIDM::VAR_P);
  ASSERT_EQ(loadIfce.getComponentVarIndex(std::string("P1")), -1);
  ASSERT_EQ(loadIfce.getComponentVarIndex(std::string("q")), LoadInterfaceIIDM::VAR_Q);
  ASSERT_EQ(loadIfce.getComponentVarIndex(std::string("state")), LoadInterfaceIIDM::VAR_STATE);

  ASSERT_EQ(loadIfce.getID(), load.getId());
  ASSERT_DOUBLE_EQ(loadIfce.getPUnderVoltage(), 0.0);

  ASSERT_TRUE(loadIfce.getInitialConnected());
  load.getTerminal().disconnect();
  ASSERT_TRUE(loadIfce.getInitialConnected());

  ASSERT_EQ(loadIfce.getBusInterface().get(), nullptr);
  const boost::shared_ptr<BusInterface> busIfce(new BusInterfaceIIDM(bus1));
  loadIfce.setBusInterface(busIfce);
  ASSERT_EQ(loadIfce.getBusInterface().get()->getID(), "VL1_BUS1");

  ASSERT_FALSE(load.getTerminal().isConnected());
  ASSERT_FALSE(loadIfce.hasP());
  ASSERT_FALSE(loadIfce.hasQ());

  ASSERT_DOUBLE_EQ(loadIfce.getP0(), 50.0);
  ASSERT_DOUBLE_EQ(loadIfce.getP(), 0.0);
  load.getTerminal().setP(1000.0);
  ASSERT_TRUE(loadIfce.hasP());
  ASSERT_DOUBLE_EQ(loadIfce.getP(), 1000.0);

  ASSERT_DOUBLE_EQ(loadIfce.getQ0(), 40.0);
  ASSERT_DOUBLE_EQ(loadIfce.getQ(), 0.0);
  load.getTerminal().setQ(499.0);
  ASSERT_TRUE(loadIfce.hasQ());
  ASSERT_DOUBLE_EQ(loadIfce.getQ(), 499.0);

  // Ci dessous, DG FAIRE
  loadIfce.importStaticParameters();
  loadIfce.setBusInterface(nullptr);
  loadIfce.importStaticParameters();
  //  loadIfce.exportStateVariablesUnitComponent();

  // Manque le test de setVoltageLevelInterface DG - FAIRE
  // loadIfce.getVoltageLevelInterface() ;
}  // TEST(DataInterfaceTest, Load_1)

TEST(DataInterfaceTest, Load_2) {  // tests assuming getInitialConnected == false
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
                          .setNominalVoltage(380.0)
                          .setLowVoltageLimit(340.0)
                          .setHighVoltageLimit(420.0)
                          .add();

  vl1.getBusBreakerView().newBus().setId("VL1_BUS1").add();

  vl1.newLoad()
      .setId("LOAD")
      .setBus("VL1_BUS1")
      .setConnectableBus("VL1_BUS1")
      .setName("LOAD1_NAME")
      .setLoadType(LoadType::UNDEFINED)
      .setP0(5000.0)
      .setQ0(4000.0)
      .add();

  Load& load = network.getLoad("LOAD");
  LoadInterfaceIIDM loadIfce(load);
  ASSERT_EQ(loadIfce.getID(), "LOAD");

  load.getTerminal().disconnect();
  ASSERT_FALSE(loadIfce.getInitialConnected());

  ASSERT_FALSE(loadIfce.hasP());
  ASSERT_FALSE(loadIfce.hasQ());
  ASSERT_DOUBLE_EQ(loadIfce.getP(), 0.0);
  ASSERT_DOUBLE_EQ(loadIfce.getQ(), 0.0);
}  // TEST(DataInterfaceTest, Load_2)
}  // namespace DYN
