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

#include "DYNDanglingLineInterfaceIIDM.h"

#include "DYNBusInterfaceIIDM.h"
#include "DYNCurrentLimitInterfaceIIDM.h"
#include "DYNInjectorInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "make_unique.hpp"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/DanglingLine.hpp>
#include <powsybl/iidm/DanglingLineAdder.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/Substation.hpp>

#include "gtest_dynawo.h"

namespace powsybl {
namespace iidm {

static Network
createDanglingLineNetwork() {
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
                          .setNominalV(380.0)
                          .setLowVoltageLimit(340.0)
                          .setHighVoltageLimit(420.0)
                          .add();

  vl1.getBusBreakerView().newBus().setId("VL1_BUS1").add();

  return network;
}
}  // namespace iidm
}  // namespace powsybl

namespace DYN {

using powsybl::iidm::createDanglingLineNetwork;

TEST(DataInterfaceTest, DanglingLine_1) {
  powsybl::iidm::Network network = createDanglingLineNetwork();
  powsybl::iidm::VoltageLevel& vl1 = network.getVoltageLevel("VL1");
  powsybl::iidm::Bus& bus1 = vl1.getBusBreakerView().getBus("VL1_BUS1");

  vl1.newDanglingLine()
       .setId("DANGLING_LINE1")
       .setBus("VL1_BUS1")
       .setConnectableBus("VL1_BUS1")
       .setName("DANGLING_LINE1_NAME")
       .setB(1.0)
       .setG(2.0)
       .setP0(3.0)
       .setQ0(4.0)
       .setR(5.0)
       .setX(6.0)
       .setUcteXnodeCode("ucteXnodeCodeTest")
       .add();

  powsybl::iidm::DanglingLine& danglingLine = network.getDanglingLine("DANGLING_LINE1");
  DanglingLineInterfaceIIDM danglingLineIfce(danglingLine);
  const std::shared_ptr<VoltageLevelInterface> vlItf = std::make_shared<VoltageLevelInterfaceIIDM>(vl1);
  danglingLineIfce.setVoltageLevelInterface(vlItf);

  ASSERT_EQ(danglingLineIfce.getComponentVarIndex(std::string("p")), DanglingLineInterfaceIIDM::VAR_P);
  ASSERT_EQ(danglingLineIfce.getComponentVarIndex(std::string("wrongIndex")), -1);
  ASSERT_EQ(danglingLineIfce.getComponentVarIndex(std::string("q")), DanglingLineInterfaceIIDM::VAR_Q);
  ASSERT_EQ(danglingLineIfce.getComponentVarIndex(std::string("state")), DanglingLineInterfaceIIDM::VAR_STATE);

  ASSERT_EQ(danglingLineIfce.getID(), danglingLine.getId());

  ASSERT_TRUE(danglingLineIfce.getInitialConnected());
  ASSERT_TRUE(danglingLineIfce.isConnected());
  ASSERT_TRUE(danglingLineIfce.isPartiallyConnected());
  danglingLine.getTerminal().disconnect();
  ASSERT_FALSE(danglingLineIfce.isPartiallyConnected());
  ASSERT_FALSE(danglingLineIfce.isConnected());
  ASSERT_TRUE(danglingLineIfce.getInitialConnected());

  ASSERT_EQ(danglingLineIfce.getBusInterface().get(), nullptr);
  std::unique_ptr<BusInterface> busIfce = DYN::make_unique<BusInterfaceIIDM>(bus1);
  danglingLineIfce.setBusInterface(std::move(busIfce));
  ASSERT_EQ(danglingLineIfce.getBusInterface().get()->getID(), "VL1_BUS1");

  ASSERT_FALSE(danglingLineIfce.hasInitialConditions());

  ASSERT_DOUBLE_EQ(danglingLineIfce.getP0(), 3.0);
  ASSERT_DOUBLE_EQ(danglingLineIfce.getP(), 0.0);
  danglingLine.getTerminal().setP(10.0);
  ASSERT_DOUBLE_EQ(danglingLineIfce.getP(), 10.0);

  ASSERT_DOUBLE_EQ(danglingLineIfce.getQ0(), 4.0);
  ASSERT_DOUBLE_EQ(danglingLineIfce.getQ(), 0.0);
  danglingLine.getTerminal().setQ(40.0);
  ASSERT_DOUBLE_EQ(danglingLineIfce.getQ(), 40.0);

  ASSERT_DOUBLE_EQ(danglingLineIfce.getB(), 1.0);
  ASSERT_DOUBLE_EQ(danglingLineIfce.getG(), 2.0);
  ASSERT_DOUBLE_EQ(danglingLineIfce.getR(), 5.0);
  ASSERT_DOUBLE_EQ(danglingLineIfce.getX(), 6.0);

  const std::shared_ptr<VoltageLevelInterface> voltageLevelIfce = std::make_shared<VoltageLevelInterfaceIIDM>(vl1);
  danglingLineIfce.setVoltageLevelInterface(voltageLevelIfce);
  ASSERT_DOUBLE_EQ(danglingLineIfce.getVNom(), 380);

  std::unique_ptr<CurrentLimitInterface> currentLimitIfce = DYN::make_unique<CurrentLimitInterfaceIIDM>(1.0, 99);
  danglingLineIfce.addCurrentLimitInterface(std::move(currentLimitIfce));
  ASSERT_EQ(danglingLineIfce.getCurrentLimitInterfaces().size(), 1);

  vl1.newDanglingLine()
       .setId("DANGLING_LINE2")
       .setBus("VL1_BUS1")
       .setConnectableBus("VL1_BUS1")
       .setName("DANGLING_LINE2_NAME")
       .setB(0.0)
       .setG(0.0)
       .setP0(3.0)
       .setQ0(4.0)
       .setR(0.0)
       .setX(0.0)
       .setUcteXnodeCode("ucteXnodeCodeTest")
       .add();
  powsybl::iidm::DanglingLine& danglingLine2 = network.getDanglingLine("DANGLING_LINE2");
  danglingLine2.getTerminal().setP(10.0);
  danglingLine2.getTerminal().setQ(40);
  DanglingLineInterfaceIIDM danglingLineIfce2(danglingLine2);
  danglingLineIfce2.setVoltageLevelInterface(vlItf);
  ASSERT_DOUBLE_EQ(danglingLineIfce2.getX(), 0.01);
}  // TEST(DataInterfaceTest, DanglingLine_1)

TEST(DataInterfaceTest, DanglingLine_2) {
  powsybl::iidm::Network network = createDanglingLineNetwork();
  powsybl::iidm::VoltageLevel& vl1 = network.getVoltageLevel("VL1");

  vl1.newDanglingLine()
       .setId("DANGLING_LINE1")
       .setBus("VL1_BUS1")
       .setConnectableBus("VL1_BUS1")
       .setName("DANGLING_LINE1_NAME")
       .setB(1.0)
       .setG(2.0)
       .setP0(3.0)
       .setQ0(4.0)
       .setR(5.0)
       .setX(6.0)
       .setUcteXnodeCode("ucteXnodeCodeTest")
       .add();

  powsybl::iidm::DanglingLine& danglingLine = network.getDanglingLine("DANGLING_LINE1");

  danglingLine.getTerminal().setP(0.0);
  danglingLine.getTerminal().setQ(0);

  DanglingLineInterfaceIIDM danglingLineIfce(danglingLine);

  ASSERT_TRUE(danglingLineIfce.hasInitialConditions());
}  // TEST(DataInterfaceTest, DanglingLine_2)
}  // namespace DYN
