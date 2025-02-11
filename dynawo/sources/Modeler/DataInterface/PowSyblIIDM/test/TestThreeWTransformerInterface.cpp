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

#include "DYNThreeWTransformerInterfaceIIDM.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/ThreeWindingsTransformerAdder.hpp>

#include "make_unique.hpp"
#include "gtest_dynawo.h"

#include "DYNBusInterfaceIIDM.h"
#include "DYNCurrentLimitInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"

namespace DYN {

using powsybl::iidm::Bus;
using powsybl::iidm::Network;
using powsybl::iidm::Substation;
using powsybl::iidm::ThreeWindingsTransformer;
using powsybl::iidm::TopologyKind;
using powsybl::iidm::VoltageLevel;

TEST(DataInterfaceTest, ThreeWTransformer_1) {
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

  ThreeWTransformerInterfaceIIDM tfoInterface(transformer);
  ASSERT_EQ(tfoInterface.getID(), "3WT_VL1_VL2_VL3");

  ASSERT_EQ(tfoInterface.getComponentVarIndex(std::string("invalid")), -1);

  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces1().size(), 0);
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces2().size(), 0);
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces3().size(), 0);
  std::unique_ptr<CurrentLimitInterface> curLimItf1 = DYN::make_unique<CurrentLimitInterfaceIIDM>(1, 1);
  tfoInterface.addCurrentLimitInterface1(std::move(curLimItf1));
  std::unique_ptr<CurrentLimitInterface> curLimItf2 = DYN::make_unique<CurrentLimitInterfaceIIDM>(2, 2);
  tfoInterface.addCurrentLimitInterface2(std::move(curLimItf2));
  std::unique_ptr<CurrentLimitInterface> curLimItf3 = DYN::make_unique<CurrentLimitInterfaceIIDM>(3, 3);
  tfoInterface.addCurrentLimitInterface3(std::move(curLimItf3));
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces1().size(), 1);
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces2().size(), 1);
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces3().size(), 1);

  ASSERT_EQ(tfoInterface.getBusInterface1().get(), nullptr);
  vl1Bus1.setV(10.0).setAngle(0.01);
  std::unique_ptr<BusInterface> busItf1 = DYN::make_unique<BusInterfaceIIDM>(vl1Bus1);
  tfoInterface.setBusInterface1(std::move(busItf1));
  ASSERT_EQ(tfoInterface.getBusInterface1().get()->getID(), "VL1_BUS1");

  ASSERT_EQ(tfoInterface.getBusInterface2().get(), nullptr);
  vl2Bus1.setV(11.0).setAngle(0.02);
  std::unique_ptr<BusInterface> busItf2 = DYN::make_unique<BusInterfaceIIDM>(vl2Bus1);
  tfoInterface.setBusInterface2(std::move(busItf2));
  ASSERT_EQ(tfoInterface.getBusInterface2().get()->getID(), "VL2_BUS1");

  ASSERT_EQ(tfoInterface.getBusInterface3().get(), nullptr);
  vl3Bus1.setV(12.0).setAngle(0.03);
  std::unique_ptr<BusInterface> busItf3 = DYN::make_unique<BusInterfaceIIDM>(vl3Bus1);
  tfoInterface.setBusInterface3(std::move(busItf3));
  ASSERT_EQ(tfoInterface.getBusInterface3().get()->getID(), "VL3_BUS1");

  std::unique_ptr<VoltageLevelInterface> voltageLevelItf1 = DYN::make_unique<VoltageLevelInterfaceIIDM>(vl1);
  tfoInterface.setVoltageLevelInterface1(std::move(voltageLevelItf1));
  std::unique_ptr<VoltageLevelInterface> voltageLevelItf2 = DYN::make_unique<VoltageLevelInterfaceIIDM>(vl2);
  tfoInterface.setVoltageLevelInterface2(std::move(voltageLevelItf2));
  std::unique_ptr<VoltageLevelInterface> voltageLevelItf3 = DYN::make_unique<VoltageLevelInterfaceIIDM>(vl3);
  tfoInterface.setVoltageLevelInterface3(std::move(voltageLevelItf3));

  ASSERT_TRUE(tfoInterface.isConnected());
  ASSERT_TRUE(tfoInterface.isPartiallyConnected());

  ASSERT_TRUE(tfoInterface.getInitialConnected1());
  transformer.getLeg1().getTerminal().disconnect();
  ASSERT_TRUE(tfoInterface.getInitialConnected1());
  ASSERT_FALSE(tfoInterface.isConnected());
  ASSERT_TRUE(tfoInterface.isPartiallyConnected());

  ASSERT_TRUE(tfoInterface.getInitialConnected2());
  transformer.getLeg2().getTerminal().disconnect();
  ASSERT_TRUE(tfoInterface.getInitialConnected2());
  ASSERT_FALSE(tfoInterface.isConnected());
  ASSERT_TRUE(tfoInterface.isPartiallyConnected());

  ASSERT_TRUE(tfoInterface.getInitialConnected3());
  transformer.getLeg3().getTerminal().disconnect();
  ASSERT_TRUE(tfoInterface.getInitialConnected3());
  ASSERT_FALSE(tfoInterface.isConnected());
  ASSERT_FALSE(tfoInterface.isPartiallyConnected());

  ASSERT_EQ(tfoInterface.getActiveSeason(), "UNDEFINED");
}  // TEST(DataInterfaceTest, ThreeWTransformer_1)
}  // namespace DYN
