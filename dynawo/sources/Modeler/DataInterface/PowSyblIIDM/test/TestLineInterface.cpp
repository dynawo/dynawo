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

#include "DYNLineInterfaceIIDM.h"

#include "DYNBusInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNCurrentLimitInterfaceIIDM.h"

#include "make_unique.hpp"
#include "gtest_dynawo.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Line.hpp>
#include <powsybl/iidm/LineAdder.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/Substation.hpp>

#include <limits.h>

namespace powsybl {
namespace iidm {

static Network
createLineNetwork() {
  Network network("test", "test");
  Substation& substation = network.newSubstation()
                                     .setId("S1")
                                     .setName("S1_NAME")
                                     .setCountry(Country::FR)
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

  Bus& vl1Bus1 = vl1.getBusBreakerView().newBus().setId("VL1_BUS1").add();

  VoltageLevel& vl2 = substation.newVoltageLevel()
                                     .setId("VL2")
                                     .setName("VL2_NAME")
                                     .setTopologyKind(TopologyKind::BUS_BREAKER)
                                     .setNominalV(225.0)
                                     .setLowVoltageLimit(200.0)
                                     .setHighVoltageLimit(260.0)
                                     .add();

  vl2.getBusBreakerView().newBus().setId("VL2_BUS1").add();

  Substation& substation2 = network.newSubstation()
                                     .setId("S2")
                                     .setName("S2_NAME")
                                     .setCountry(Country::FR)
                                     .setTso("TSO")
                                     .add();

  VoltageLevel& vl3 = substation2.newVoltageLevel()
                                     .setId("VL3")
                                     .setName("VL3_NAME")
                                     .setTopologyKind(TopologyKind::BUS_BREAKER)
                                     .setNominalV(360.0)
                                     .setLowVoltageLimit(340.0)
                                     .setHighVoltageLimit(420.0)
                                     .add();

  Bus& vl3Bus1 = vl3.getBusBreakerView().newBus().setId("VL3_BUS1").add();

  VoltageLevel& vl4 = substation2.newVoltageLevel()
                                     .setId("VL4")
                                     .setName("VL4_NAME")
                                     .setTopologyKind(TopologyKind::BUS_BREAKER)
                                     .setNominalV(225.0)
                                     .setLowVoltageLimit(200.0)
                                     .setHighVoltageLimit(260.0)
                                     .add();

  vl4.getBusBreakerView().newBus().setId("VL4_BUS1").add();

  network.newLine().setId("VL1_VL3")
                    .setVoltageLevel1(vl1.getId())
                    .setBus1(vl1Bus1.getId())
                    .setConnectableBus1(vl1Bus1.getId())
                    .setVoltageLevel2(vl3.getId())
                    .setBus2(vl3Bus1.getId())
                    .setConnectableBus2(vl3Bus1.getId())
                    .setR(3.0)
                    .setX(33.33)
                    .setG1(1.0)
                    .setB1(0.2)
                    .setG2(2.0)
                    .setB2(0.4)
                    .add();
  return network;
}  // createLineNetwork
}  // namespace iidm
}  // namespace powsybl

namespace DYN {

using powsybl::iidm::createLineNetwork;

TEST(DataInterfaceTest, Line_1) {
  powsybl::iidm::Network network = createLineNetwork();
  powsybl::iidm::VoltageLevel& vl1 = network.getVoltageLevel("VL1");
  powsybl::iidm::VoltageLevel& vl3 = network.getVoltageLevel("VL3");
  powsybl::iidm::Bus& vl1Bus1 = vl1.getBusBreakerView().getBus("VL1_BUS1");
  powsybl::iidm::Bus& vl3Bus1 = vl3.getBusBreakerView().getBus("VL3_BUS1");
  powsybl::iidm::Line& MyLine = network.getLine("VL1_VL3");

  LineInterfaceIIDM li(MyLine);
  ASSERT_EQ(li.getID(), "VL1_VL3");
  ASSERT_EQ(li.getVNom1(), 380.0);
  ASSERT_EQ(li.getVNom2(), 360.0);
  ASSERT_EQ(li.getR(), 3.0);
  ASSERT_EQ(li.getX(), 33.33);
  ASSERT_EQ(li.getG1(), 1.0);
  ASSERT_EQ(li.getG2(), 2.0);
  ASSERT_EQ(li.getB1(), 0.2);
  ASSERT_EQ(li.getB2(), 0.4);

  ASSERT_EQ(li.getBusInterface1().get(), nullptr);
  ASSERT_EQ(li.getBusInterface2().get(), nullptr);
  std::unique_ptr<BusInterface> x_b1 = DYN::make_unique<BusInterfaceIIDM>(vl1Bus1);
  std::unique_ptr<BusInterface> x_b3 = DYN::make_unique<BusInterfaceIIDM>(vl3Bus1);
  const std::shared_ptr<VoltageLevelInterface> vl1Itf = std::make_shared<VoltageLevelInterfaceIIDM>(vl1);
  const std::shared_ptr<VoltageLevelInterface> vl3Itf = std::make_shared<VoltageLevelInterfaceIIDM>(vl3);
  li.setBusInterface1(std::move(x_b1));
  li.setBusInterface2(std::move(x_b3));
  li.setVoltageLevelInterface1(vl1Itf);
  li.setVoltageLevelInterface2(vl3Itf);
  ASSERT_EQ(li.getBusInterface1().get()->getID(), "VL1_BUS1");
  ASSERT_EQ(li.getBusInterface2().get()->getID(), "VL3_BUS1");

  ASSERT_TRUE(li.getInitialConnected1());
  ASSERT_TRUE(li.getInitialConnected2());

  ASSERT_TRUE(li.isConnected());
  ASSERT_TRUE(li.isPartiallyConnected());
  MyLine.getTerminal1().disconnect();
  ASSERT_FALSE(li.isConnected());
  ASSERT_TRUE(li.isPartiallyConnected());
  MyLine.getTerminal2().disconnect();
  ASSERT_FALSE(li.isConnected());
  ASSERT_FALSE(li.isPartiallyConnected());
  ASSERT_DOUBLE_EQ(li.getVNom1(), 380.0);
  ASSERT_DOUBLE_EQ(li.getVNom2(), 360.0);
  ASSERT_TRUE(li.getInitialConnected1());
  ASSERT_TRUE(li.getInitialConnected2());

  MyLine.getTerminal1().connect();
  ASSERT_FALSE(li.isConnected());
  ASSERT_TRUE(li.isPartiallyConnected());
  MyLine.getTerminal2().connect();
  ASSERT_TRUE(li.isConnected());
  ASSERT_TRUE(li.isPartiallyConnected());
  ASSERT_DOUBLE_EQ(li.getVNom1(), 380.0);
  ASSERT_DOUBLE_EQ(li.getVNom2(), 360.0);

  ASSERT_EQ(li.getComponentVarIndex(std::string("p1")), LineInterfaceIIDM::VAR_P1);
  ASSERT_EQ(li.getComponentVarIndex(std::string("P1")), -1);
  ASSERT_EQ(li.getComponentVarIndex(std::string("p2")), LineInterfaceIIDM::VAR_P2);
  ASSERT_EQ(li.getComponentVarIndex(std::string("q1")), LineInterfaceIIDM::VAR_Q1);
  ASSERT_EQ(li.getComponentVarIndex(std::string("q2")), LineInterfaceIIDM::VAR_Q2);
  ASSERT_EQ(li.getComponentVarIndex(std::string("state")), LineInterfaceIIDM::VAR_STATE);

  ASSERT_DOUBLE_EQ(li.getP1(), 0.0);
  ASSERT_DOUBLE_EQ(li.getQ1(), 0.0);
  ASSERT_DOUBLE_EQ(li.getP2(), 0.0);
  ASSERT_DOUBLE_EQ(li.getQ2(), 0.0);

  MyLine.getTerminal1().setP(999.999);
  MyLine.getTerminal1().setQ(666);
  MyLine.getTerminal2().setP(999.999999999999999/2);
  MyLine.getTerminal2().setQ(666.0/3.0);
  ASSERT_DOUBLE_EQ(li.getP1(), 999.999);
  ASSERT_DOUBLE_EQ(li.getQ1(), 666.0);
  ASSERT_DOUBLE_EQ(li.getP2(), 500.0);
  ASSERT_DOUBLE_EQ(li.getQ2(), 222.0);

  ASSERT_FALSE(li.hasInitialConditions());

  ASSERT_EQ(li.getCurrentLimitInterfaces1().size(), 0);
  ASSERT_EQ(li.getCurrentLimitInterfaces2().size(), 0);
  std::unique_ptr<CurrentLimitInterface> curLimItf1 = DYN::make_unique<CurrentLimitInterfaceIIDM>(1, 1, false);
  li.addCurrentLimitInterface1(std::move(curLimItf1));
  std::unique_ptr<CurrentLimitInterface> curLimItf2 = DYN::make_unique<CurrentLimitInterfaceIIDM>(2, 2, false);
  li.addCurrentLimitInterface2(std::move(curLimItf2));
  ASSERT_EQ(li.getCurrentLimitInterfaces1().size(), 1);
  ASSERT_EQ(li.getCurrentLimitInterfaces2().size(), 1);
  std::string season = "UNDEFINED";
  ASSERT_EQ(li.getActiveSeason(), season);
  ASSERT_FALSE(li.getCurrentLimitPermanent(season, CURRENT_LIMIT_SIDE_1));
  ASSERT_FALSE(li.getCurrentLimitNbTemporary(season, CURRENT_LIMIT_SIDE_1));
  ASSERT_FALSE(li.getCurrentLimitTemporaryName(season, CURRENT_LIMIT_SIDE_1, 0));
  ASSERT_FALSE(li.getCurrentLimitTemporaryAcceptableDuration(season, CURRENT_LIMIT_SIDE_1, 0));
  ASSERT_FALSE(li.getCurrentLimitTemporaryValue(season, CURRENT_LIMIT_SIDE_1, 0));
  ASSERT_FALSE(li.getCurrentLimitTemporaryFictitious(season, CURRENT_LIMIT_SIDE_1, 0));


  powsybl::iidm::Line& MySecondLine = network.newLine()
                                       .setId("VL1_VL3_Bad")
                                       .setVoltageLevel1(vl1.getId())
                                       .setBus1(vl1Bus1.getId())
                                       .setConnectableBus1(vl1Bus1.getId())
                                       .setVoltageLevel2(vl3.getId())
                                       .setBus2(vl3Bus1.getId())
                                       .setConnectableBus2(vl3Bus1.getId())
                                       .setR(0.0)
                                       .setX(0.0)
                                       .setG1(1.0)
                                       .setB1(0.2)
                                       .setG2(2.0)
                                       .setB2(0.4)
                                       .add();

  MySecondLine.getTerminal1().disconnect();
  MySecondLine.getTerminal2().disconnect();

  LineInterfaceIIDM li2(MySecondLine);
  li2.setVoltageLevelInterface1(vl1Itf);
  li2.setVoltageLevelInterface2(vl3Itf);
  ASSERT_FALSE(li2.getInitialConnected1());
  ASSERT_FALSE(li2.getInitialConnected2());
  ASSERT_EQ(li2.getR(), 0.0);
  ASSERT_EQ(li2.getX(), 0.01);
  ASSERT_DOUBLE_EQ(li2.getP1(), 0.0);
  ASSERT_DOUBLE_EQ(li2.getP2(), 0.0);
  ASSERT_DOUBLE_EQ(li2.getQ1(), 0.0);
  ASSERT_DOUBLE_EQ(li2.getQ2(), 0.0);

  MySecondLine.getTerminal1().setP(std::numeric_limits<double>::infinity());
  MySecondLine.getTerminal2().setP(-4444);
  MySecondLine.getTerminal1().setQ(444.4);
  MySecondLine.getTerminal2().setQ(444.4);
  ASSERT_DOUBLE_EQ(li2.getP1(), 0.0);
  ASSERT_DOUBLE_EQ(li2.getP2(), 0.0);
  ASSERT_DOUBLE_EQ(li2.getQ1(), 0.0);
  ASSERT_DOUBLE_EQ(li2.getQ2(), 0.0);

  MySecondLine.getTerminal1().setP(std::numeric_limits<double>::infinity());
  MySecondLine.getTerminal2().setP(-4444);
  MySecondLine.getTerminal1().setQ(444.4);
  MySecondLine.getTerminal2().setQ(std::nan("not  a number"));
  ASSERT_DOUBLE_EQ(li2.getP1(), 0.0);
  ASSERT_DOUBLE_EQ(li2.getP2(), 0.0);
  ASSERT_DOUBLE_EQ(li2.getQ1(), 0.0);
  ASSERT_DOUBLE_EQ(li2.getQ2(), 0.0);
}  // TEST(DataInterfaceTest, Line_1)

TEST(DataInterfaceTest, Line_2) {
  powsybl::iidm::Network network = createLineNetwork();
  powsybl::iidm::Line& MyLine = network.getLine("VL1_VL3");

  MyLine.getTerminal1().setP(0.0);
  MyLine.getTerminal2().setP(0.0);
  MyLine.getTerminal1().setQ(0.0);
  MyLine.getTerminal2().setQ(0.0);

  LineInterfaceIIDM li(MyLine);

  ASSERT_TRUE(li.hasInitialConditions());
}  // TEST(DataInterfaceTest, Line_2)
}  // namespace DYN
