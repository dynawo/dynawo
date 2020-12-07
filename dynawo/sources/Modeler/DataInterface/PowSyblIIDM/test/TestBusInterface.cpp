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

#include "gtest_dynawo.h"
#include "DYNCommon.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>
#include <powsybl/iidm/TopologyKind.hpp>


using powsybl::iidm::Network;
using powsybl::iidm::Substation;
using powsybl::iidm::VoltageLevel;
using powsybl::iidm::Bus;
using powsybl::iidm::TopologyKind;

namespace DYN {

TEST(DataInterfaceTest, testBusInterface) {
  Network network("test", "test");

  Substation& s = network.newSubstation()
      .setId("S")
      .add();

  VoltageLevel& vl1 = s.newVoltageLevel()
      .setId("VL1")
      .setNominalVoltage(400.)
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
  ASSERT_TRUE(bus.getBusBarSectionNames().empty());
}

TEST(DataInterfaceTest, testBusInterfaceCornerCases) {
  Network network("test", "test");

  Substation& s = network.newSubstation()
      .setId("S")
      .add();

  VoltageLevel& vl1 = s.newVoltageLevel()
      .setId("VL1")
      .setNominalVoltage(400.)
      .setTopologyKind(TopologyKind::BUS_BREAKER)
      .add();

  Bus& iidmBus = vl1.getBusBreakerView().newBus()
      .setId("Bus1")
      .add();

  BusInterfaceIIDM bus(iidmBus);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getV0(), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getAngle0(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getVMax(), 480.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus.getVMin(), 320.);
}

}  // namespace DYN
