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
#include "DYNCalculatedBusInterfaceIIDM.h"

#include "gtest_dynawo.h"
#include "DYNCommon.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/BusbarSection.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>
#include <powsybl/iidm/TopologyKind.hpp>
#include <powsybl/iidm/Switch.hpp>


using powsybl::iidm::Network;
using powsybl::iidm::Substation;
using powsybl::iidm::VoltageLevel;
using powsybl::iidm::Bus;
using powsybl::iidm::BusbarSection;
using powsybl::iidm::TopologyKind;
using powsybl::iidm::Switch;

namespace DYN {

TEST(DataInterfaceTest, testBusInterface) {
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

  Bus& iidmBus = vl1.getBusBreakerView().newBus()
      .setId("Bus1")
      .add();

  iidmBus.setV(410.);
  iidmBus.setAngle(3.14);
  BusInterfaceIIDM bus(iidmBus);

  ASSERT_EQ(bus.getID(), "Bus1");
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getVMax(), 420.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getVMin(), 380.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getV0(), 410.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getVNom(), 400.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getAngle0(), 3.14);
  ASSERT_FALSE(bus.hasConnection());
  bus.hasConnection(true);
  ASSERT_TRUE(bus.hasConnection());
  ASSERT_EQ(bus.getComponentVarIndex("v"), BusInterfaceIIDM::VAR_V);
  ASSERT_EQ(bus.getComponentVarIndex("angle"), BusInterfaceIIDM::VAR_ANGLE);
  ASSERT_EQ(bus.getComponentVarIndex("foo"), -1);
  ASSERT_EQ(bus.getBusIndex(), 0);
  ASSERT_TRUE(bus.getBusBarSectionIdentifiers().empty());
  ASSERT_FALSE(bus.isFictitious());
  ASSERT_EQ(bus.getCountry(), "");
  bus.setCountry("AF");
  ASSERT_EQ(bus.getCountry(), "AF");
}

TEST(DataInterfaceTest, testBusInterfaceCornerCases) {
  Network network("test", "test");

  Substation& s = network.newSubstation()
      .setId("S")
      .add();

  VoltageLevel& vl1 = s.newVoltageLevel()
      .setId("VL1")
      .setNominalV(400.)
      .setTopologyKind(TopologyKind::BUS_BREAKER)
      .add();

  Bus& iidmBus = vl1.getBusBreakerView().newBus()
      .setId("Bus1")
      .add();

  BusInterfaceIIDM bus(iidmBus);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getV0(), 400.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getAngle0(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getVMax(), 480.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getVMin(), 320.);
}

TEST(DataInterfaceTest, testCalculatedBusInterface) {
  Network network("test", "test");
  Substation& s = network.newSubstation()
      .setId("S5")
      .add();
  VoltageLevel& vl = s.newVoltageLevel()
      .setId("MyVoltageLevel")
      .setTopologyKind(TopologyKind::NODE_BREAKER)
      .setNominalV(400.0)
      .setLowVoltageLimit(380.0)
      .setHighVoltageLimit(420.0)
      .add();
  BusbarSection& bbs = vl.getNodeBreakerView().newBusbarSection()
      .setId("BBS")
      .setName("BBS_NAME")
      .setNode(3)
      .add();
  vl.getNodeBreakerView().newBusbarSection()
      .setId("BBS2")
      .setName("BBS2_NAME")
      .setNode(4)
      .add();
  vl.getNodeBreakerView().newBreaker()
      .setId("BK1")
      .setNode1(0)
      .setNode2(5)
      .setRetained(true)
      .setOpen(true)
      .add();
  vl.getNodeBreakerView().newDisconnector()
      .setId("DC11")
      .setNode1(5)
      .setNode2(3)
      .setRetained(false)
      .setOpen(true)
      .add();
  vl.getNodeBreakerView().newDisconnector()
      .setId("DC12")
      .setNode1(5)
      .setNode2(4)
      .setRetained(false)
      .setOpen(true)
      .add();
  vl.getNodeBreakerView().newBreaker()
      .setId("BK2")
      .setNode1(1)
      .setNode2(6)
      .setRetained(true)
      .setOpen(false)
      .add();
  vl.getNodeBreakerView().newDisconnector()
      .setId("DC21")
      .setNode1(6)
      .setNode2(3)
      .setRetained(false)
      .setOpen(true)
      .add();
  vl.getNodeBreakerView().newDisconnector()
      .setId("DC22")
      .setNode1(6)
      .setNode2(4)
      .setRetained(false)
      .setOpen(false)
      .add();
  vl.getNodeBreakerView().newBreaker()
      .setId("BK3")
      .setNode1(2)
      .setNode2(7)
      .setRetained(true)
      .setOpen(true)
      .add();
  vl.getNodeBreakerView().newDisconnector()
      .setId("DC31")
      .setNode1(7)
      .setNode2(3)
      .setRetained(false)
      .setOpen(true)
      .add();

  Bus& calculatedIIDMBus = vl.getBusBreakerView().getBus("MyVoltageLevel_0").get();
  calculatedIIDMBus.setV(410.);
  calculatedIIDMBus.setAngle(3.14);
  CalculatedBusInterfaceIIDM bus(vl, "MyTest", 1);
  ASSERT_EQ(bus.getID(), "MyTest");
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getVMax(), 420.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getVMin(), 380.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getV0(), 400.);
  bus.setU0(410.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getV0(), 410.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getVNom(), 400.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getAngle0(), 0.);
  bus.setAngle0(3.14);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getAngle0(), 3.14);
  ASSERT_FALSE(bus.hasConnection());
  bus.hasConnection(true);
  ASSERT_TRUE(bus.hasConnection());
  ASSERT_EQ(bus.getComponentVarIndex("v"), BusInterfaceIIDM::VAR_V);
  ASSERT_EQ(bus.getComponentVarIndex("angle"), BusInterfaceIIDM::VAR_ANGLE);
  ASSERT_EQ(bus.getComponentVarIndex("foo"), -1);
  ASSERT_EQ(bus.getBusIndex(), 1);
  ASSERT_EQ(bus.getBusBarSectionIdentifiers().size(), 0);
  bus.addBusBarSection(bbs.getId());
  ASSERT_EQ(bus.getBusBarSectionIdentifiers().size(), 1);
  ASSERT_EQ(bus.getBusBarSectionIdentifiers()[0], "BBS");
  ASSERT_FALSE(bus.isFictitious());

  ASSERT_EQ(bus.getNodes().size(), 0);
  bus.addNode(8);
  ASSERT_EQ(bus.getNodes().size(), 1);
  ASSERT_TRUE(bus.hasNode(8));
  ASSERT_FALSE(bus.hasNode(2));
}

}  // namespace DYN
