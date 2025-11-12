//
// Copyright (c) 2022, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

#include "DYNFictTwoWTransformerInterfaceIIDM.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Load.hpp>
#include <powsybl/iidm/LoadAdder.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/PhaseTapChangerAdder.hpp>
#include <powsybl/iidm/RatioTapChangerAdder.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/ThreeWindingsTransformerAdder.hpp>

#include "gtest_dynawo.h"

#include "DYNBusInterfaceIIDM.h"
#include "DYNCurrentLimitInterfaceIIDM.h"
#include "DYNPhaseTapChangerInterfaceIIDM.h"
#include "DYNRatioTapChangerInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNCommon.h"

namespace DYN {

using powsybl::iidm::Bus;
using powsybl::iidm::Load;
using powsybl::iidm::LoadType;
using powsybl::iidm::Network;
using powsybl::iidm::PhaseTapChanger;
using powsybl::iidm::Substation;
using powsybl::iidm::Terminal;
using powsybl::iidm::TopologyKind;
using powsybl::iidm::ThreeWindingsTransformer;
using powsybl::iidm::VoltageLevel;

TEST(DataInterfaceTest, FictTwoWTransformer_1) {
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

  Bus& vl1Bus1 = vl1.getBusBreakerView().newBus()
           .setId("VL1_BUS1")
           .add();

  VoltageLevel& vl2 = substation.newVoltageLevel()
           .setId("VL2")
           .setName("VL2_NAME")
           .setTopologyKind(TopologyKind::BUS_BREAKER)
           .setNominalV(225.0)
           .setLowVoltageLimit(200.0)
           .setHighVoltageLimit(260.0)
           .add();

  Bus& vl2Bus1 = vl2.getBusBreakerView().newBus()
           .setId("VL2_BUS1")
           .add();

  VoltageLevel& vl3 = substation.newVoltageLevel()
           .setId("VL3")
           .setName("VL3_NAME")
           .setTopologyKind(TopologyKind::BUS_BREAKER)
           .setNominalV(380.0)
           .setLowVoltageLimit(340.0)
           .setHighVoltageLimit(420.0)
           .add();

  Bus& vl3Bus1 = vl3.getBusBreakerView().newBus()
           .setId("VL3_BUS1")
           .add();

  ThreeWindingsTransformer& transformer = substation.newThreeWindingsTransformer()
           .setId("3WT_VL1_VL2_VL3")
           .setName("3WT_VL1_VL2_VL3_NAME")
           .newLeg1()
           .setR(1.3)
           .setX(1.4)
           .setG(1.6)
           .setB(1.7)
           .setRatedU(1.1)
           .setRatedS(2.2)
           .setVoltageLevel(vl1.getId())
           .setBus(vl1Bus1.getId())
           .setConnectableBus(vl1Bus1.getId())
           .add()
           .newLeg2()
           .setR(2.3)
           .setX(2.4)
           .setG(0.0)
           .setB(0.0)
           .setRatedU(2.1)
           .setVoltageLevel(vl2.getId())
           .setBus(vl2Bus1.getId())
           .setConnectableBus(vl2Bus1.getId())
           .add()
           .newLeg3()
           .setR(3.3)
           .setX(3.4)
           .setG(0.0)
           .setB(0.0)
           .setRatedU(3.1)
           .setVoltageLevel(vl3.getId())
           .setBus(vl3Bus1.getId())
           .setConnectableBus(vl3Bus1.getId())
           .add()
           .add();

  stdcxx::Reference<powsybl::iidm::ThreeWindingsTransformer::Leg> leg1 =
      stdcxx::Reference<powsybl::iidm::ThreeWindingsTransformer::Leg>(transformer.getLeg1());
  FictTwoWTransformerInterfaceIIDM tfoInterface("3WT_VL1_VL2_VL3_1",
      leg1, true, transformer.getRatedU0(), transformer.getRatedU0(), "UNDEFINED");
  ASSERT_EQ(tfoInterface.getID(), "3WT_VL1_VL2_VL3_1");

  ASSERT_EQ(tfoInterface.getComponentVarIndex(std::string("p1")), FictTwoWTransformerInterfaceIIDM::VAR_P1);
  ASSERT_EQ(tfoInterface.getComponentVarIndex(std::string("p2")), FictTwoWTransformerInterfaceIIDM::VAR_P2);
  ASSERT_EQ(tfoInterface.getComponentVarIndex(std::string("q1")), FictTwoWTransformerInterfaceIIDM::VAR_Q1);
  ASSERT_EQ(tfoInterface.getComponentVarIndex(std::string("q2")), FictTwoWTransformerInterfaceIIDM::VAR_Q2);
  ASSERT_EQ(tfoInterface.getComponentVarIndex(std::string("state")), FictTwoWTransformerInterfaceIIDM::VAR_STATE);
  ASSERT_EQ(tfoInterface.getComponentVarIndex(std::string("tapIndex")), FictTwoWTransformerInterfaceIIDM::VAR_TAPINDEX);
  ASSERT_EQ(tfoInterface.getComponentVarIndex(std::string("invalid")), -1);

  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces1().size(), 0);
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces2().size(), 0);
  std::unique_ptr<CurrentLimitInterface> curLimItf1(new CurrentLimitInterfaceIIDM(1, 1, false));
  tfoInterface.addCurrentLimitInterface1(std::move(curLimItf1));
  std::unique_ptr<CurrentLimitInterface> curLimItf2(new CurrentLimitInterfaceIIDM(2, 2, false));
  tfoInterface.addCurrentLimitInterface2(std::move(curLimItf2));
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces1().size(), 0);
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces2().size(), 1);

  ASSERT_EQ(tfoInterface.getBusInterface1().get(), nullptr);
  vl1Bus1.setV(10.0).setAngle(0.01);
  std::unique_ptr<BusInterface> busItf1(new BusInterfaceIIDM(vl1Bus1));
  tfoInterface.setBusInterface1(std::move(busItf1));
  ASSERT_EQ(tfoInterface.getBusInterface1().get()->getID(), "VL1_BUS1");

  ASSERT_EQ(tfoInterface.getBusInterface2().get(), nullptr);
  vl2Bus1.setV(11.0).setAngle(0.02);
  std::unique_ptr<BusInterface> busItf2(new BusInterfaceIIDM(vl2Bus1));
  tfoInterface.setBusInterface2(std::move(busItf2));
  ASSERT_EQ(tfoInterface.getBusInterface2().get()->getID(), "VL2_BUS1");

  std::unique_ptr<VoltageLevelInterface> voltageLevelItf1(new VoltageLevelInterfaceIIDM(vl1));
  tfoInterface.setVoltageLevelInterface1(std::move(voltageLevelItf1));
  std::unique_ptr<VoltageLevelInterface> voltageLevelItf2(new VoltageLevelInterfaceIIDM(vl2));
  tfoInterface.setVoltageLevelInterface2(std::move(voltageLevelItf2));

  ASSERT_TRUE(tfoInterface.getInitialConnected1());
  ASSERT_TRUE(tfoInterface.isConnected());
  ASSERT_TRUE(tfoInterface.isPartiallyConnected());
  transformer.getLeg1().getTerminal().disconnect();
  ASSERT_FALSE(tfoInterface.isConnected());
  ASSERT_FALSE(tfoInterface.isPartiallyConnected());
  ASSERT_TRUE(tfoInterface.getInitialConnected1());
  ASSERT_EQ(tfoInterface.getVNom1(), 1.1);
  ASSERT_EQ(tfoInterface.getVNom2(), 380.);

  ASSERT_EQ(tfoInterface.getRatedU1(), 1.1);
  ASSERT_EQ(tfoInterface.getRatedU2(), 1.1);

  ASSERT_DOUBLE_EQUALS_DYNAWO(tfoInterface.getR(), 155140.49586776856);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tfoInterface.getX(), 167074.38016528924);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tfoInterface.getG(), 190942.14876033054);
  ASSERT_DOUBLE_EQUALS_DYNAWO(tfoInterface.getB(), 202876.03305785122);

  ASSERT_EQ(tfoInterface.getP1(), 0.);
  ASSERT_EQ(tfoInterface.getQ1(), 0.);
  ASSERT_EQ(tfoInterface.getP2(), 0.);
  ASSERT_EQ(tfoInterface.getQ2(), 0.);

  ASSERT_TRUE(tfoInterface.hasInitialConditions());

  ASSERT_EQ(tfoInterface.getActiveSeason(), "UNDEFINED");
}

TEST(DataInterfaceTest, FictTwoWTransformer_NoInitialConnections) {
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

  Bus& vl1Bus1 = vl1.getBusBreakerView().newBus()
           .setId("VL1_BUS1")
           .add();

  VoltageLevel& vl2 = substation.newVoltageLevel()
           .setId("VL2")
           .setName("VL2_NAME")
           .setTopologyKind(TopologyKind::BUS_BREAKER)
           .setNominalV(225.0)
           .setLowVoltageLimit(200.0)
           .setHighVoltageLimit(260.0)
           .add();

  Bus& vl2Bus1 = vl2.getBusBreakerView().newBus()
           .setId("VL2_BUS1")
           .add();

  VoltageLevel& vl3 = substation.newVoltageLevel()
           .setId("VL3")
           .setName("VL3_NAME")
           .setTopologyKind(TopologyKind::BUS_BREAKER)
           .setNominalV(380.0)
           .setLowVoltageLimit(340.0)
           .setHighVoltageLimit(420.0)
           .add();

  Bus& vl3Bus1 = vl3.getBusBreakerView().newBus()
           .setId("VL3_BUS1")
           .add();

  ThreeWindingsTransformer& transformer = substation.newThreeWindingsTransformer()
           .setId("3WT_VL1_VL2_VL3")
           .setName("3WT_VL1_VL2_VL3_NAME")
           .newLeg1()
           .setR(1.3)
           .setX(1.4)
           .setG(1.6)
           .setB(1.7)
           .setRatedU(1.1)
           .setRatedS(2.2)
           .setVoltageLevel(vl1.getId())
           .setConnectableBus(vl1Bus1.getId())
           .add()
           .newLeg2()
           .setR(2.3)
           .setX(2.4)
           .setG(0.0)
           .setB(0.0)
           .setRatedU(2.1)
           .setVoltageLevel(vl2.getId())
           .setConnectableBus(vl2Bus1.getId())
           .add()
           .newLeg3()
           .setR(3.3)
           .setX(3.4)
           .setG(0.0)
           .setB(0.0)
           .setRatedU(3.1)
           .setVoltageLevel(vl3.getId())
           .setConnectableBus(vl3Bus1.getId())
           .add()
           .add();

  stdcxx::Reference<powsybl::iidm::ThreeWindingsTransformer::Leg> leg1 =
      stdcxx::Reference<powsybl::iidm::ThreeWindingsTransformer::Leg>(transformer.getLeg1());
  FictTwoWTransformerInterfaceIIDM tfoInterface("3WT_VL1_VL2_VL3_1",
      leg1, false, transformer.getRatedU0(), transformer.getRatedU0(), "UNDEFINED");
  ASSERT_EQ(tfoInterface.getID(), "3WT_VL1_VL2_VL3_1");
  std::unique_ptr<VoltageLevelInterface> vl1Itf(new VoltageLevelInterfaceIIDM(vl1));
  std::unique_ptr<VoltageLevelInterface> vl2Itf(new VoltageLevelInterfaceIIDM(vl2));
  tfoInterface.setVoltageLevelInterface1(std::move(vl1Itf));
  tfoInterface.setVoltageLevelInterface2(std::move(vl2Itf));

  ASSERT_FALSE(tfoInterface.getInitialConnected1());
  ASSERT_FALSE(tfoInterface.isConnected());
  ASSERT_FALSE(tfoInterface.isPartiallyConnected());
  transformer.getLeg1().getTerminal().connect();
  ASSERT_TRUE(tfoInterface.isConnected());
  ASSERT_TRUE(tfoInterface.isPartiallyConnected());
  ASSERT_FALSE(tfoInterface.getInitialConnected1());

  ASSERT_EQ(tfoInterface.getP1(), 0.0);
  ASSERT_EQ(tfoInterface.getQ1(), 0.0);
  ASSERT_EQ(tfoInterface.getP2(), 0.0);
  ASSERT_EQ(tfoInterface.getQ2(), 0.0);

  ASSERT_TRUE(tfoInterface.hasInitialConditions());

  ASSERT_EQ(tfoInterface.getActiveSeason(), "UNDEFINED");
}
}  // namespace DYN
