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
           .setNominalVoltage(380.0)
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
           .setNominalVoltage(225.0)
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
           .setNominalVoltage(380.0)
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
  const boost::shared_ptr<CurrentLimitInterface> curLimItf1(new CurrentLimitInterfaceIIDM(1, 1));
  tfoInterface.addCurrentLimitInterface1(curLimItf1);
  const boost::shared_ptr<CurrentLimitInterface> curLimItf2(new CurrentLimitInterfaceIIDM(2, 2));
  tfoInterface.addCurrentLimitInterface2(curLimItf2);
  const boost::shared_ptr<CurrentLimitInterface> curLimItf3(new CurrentLimitInterfaceIIDM(3, 3));
  tfoInterface.addCurrentLimitInterface3(curLimItf3);
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces1().size(), 1);
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces2().size(), 1);
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces3().size(), 1);

  ASSERT_EQ(tfoInterface.getBusInterface1().get(), nullptr);
  vl1Bus1.setV(10.0).setAngle(0.01);
  const boost::shared_ptr<BusInterface> busItf1(new BusInterfaceIIDM(vl1Bus1));
  tfoInterface.setBusInterface1(busItf1);
  ASSERT_EQ(tfoInterface.getBusInterface1().get()->getID(), "VL1_BUS1");

  ASSERT_EQ(tfoInterface.getBusInterface2().get(), nullptr);
  vl2Bus1.setV(11.0).setAngle(0.02);
  const boost::shared_ptr<BusInterface> busItf2(new BusInterfaceIIDM(vl2Bus1));
  tfoInterface.setBusInterface2(busItf2);
  ASSERT_EQ(tfoInterface.getBusInterface2().get()->getID(), "VL2_BUS1");

  ASSERT_EQ(tfoInterface.getBusInterface3().get(), nullptr);
  vl3Bus1.setV(12.0).setAngle(0.03);
  const boost::shared_ptr<BusInterface> busItf3(new BusInterfaceIIDM(vl3Bus1));
  tfoInterface.setBusInterface3(busItf3);
  ASSERT_EQ(tfoInterface.getBusInterface3().get()->getID(), "VL3_BUS1");

  const boost::shared_ptr<VoltageLevelInterface> voltageLevelItf1(new VoltageLevelInterfaceIIDM(vl1));
  tfoInterface.setVoltageLevelInterface1(voltageLevelItf1);
  const boost::shared_ptr<VoltageLevelInterface> voltageLevelItf2(new VoltageLevelInterfaceIIDM(vl2));
  tfoInterface.setVoltageLevelInterface2(voltageLevelItf2);
  const boost::shared_ptr<VoltageLevelInterface> voltageLevelItf3(new VoltageLevelInterfaceIIDM(vl3));
  tfoInterface.setVoltageLevelInterface3(voltageLevelItf3);

  ASSERT_TRUE(tfoInterface.getInitialConnected1());
  transformer.getLeg1().getTerminal().disconnect();
  ASSERT_TRUE(tfoInterface.getInitialConnected1());

  ASSERT_TRUE(tfoInterface.getInitialConnected2());
  transformer.getLeg2().getTerminal().disconnect();
  ASSERT_TRUE(tfoInterface.getInitialConnected2());

  ASSERT_TRUE(tfoInterface.getInitialConnected3());
  transformer.getLeg3().getTerminal().disconnect();
  ASSERT_TRUE(tfoInterface.getInitialConnected3());
}  // TEST(DataInterfaceTest, ThreeWTransformer_1)
}  // namespace DYN
