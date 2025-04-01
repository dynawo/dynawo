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

#include "DYNLccConverterInterfaceIIDM.h"

#include "DYNBusInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"

#include <powsybl/iidm/HvdcLine.hpp>
#include <powsybl/iidm/HvdcLineAdder.hpp>
#include <powsybl/iidm/LccConverterStation.hpp>
#include <powsybl/iidm/LccConverterStationAdder.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/Terminal.hpp>

#include "gtest_dynawo.h"

namespace powsybl {
namespace iidm {

static Network
createHvdcLccConverterStationNetwork() {
  Network network("test", "test");
  Substation& substation = network.newSubstation().setId("S1").setName("S1_NAME").setCountry(Country::FR).setTso("TSO").add();

  VoltageLevel& vl1 = substation.newVoltageLevel()
                          .setId("VL1")
                          .setName("VL1_NAME")
                          .setTopologyKind(TopologyKind::BUS_BREAKER)
                          .setNominalV(380.0)
                          .setLowVoltageLimit(340.0)
                          .setHighVoltageLimit(420.0)
                          .add();

  Bus& vl1Bus1 = vl1.getBusBreakerView().newBus().setId("VL1_BUS1").add();

  vl1.newLccConverterStation()
      .setId("LCC1")
      .setName("LCC1_NAME")
      .setBus(vl1Bus1.getId())
      .setConnectableBus(vl1Bus1.getId())
      .setLossFactor(2.0)
      .setPowerFactor(-.2)
      .add();

  vl1.newLccConverterStation()
      .setId("LCC2")
      .setName("LCC2_NAME")
      .setBus(vl1Bus1.getId())
      .setConnectableBus(vl1Bus1.getId())
      .setLossFactor(3.0)
      .setPowerFactor(-.3)
      .add();

  network.newHvdcLine()
      .setId("HVDC1")
      .setName("HVDC1_NAME")
      .setActivePowerSetpoint(111.1)
      .setConvertersMode(HvdcLine::ConvertersMode::SIDE_1_RECTIFIER_SIDE_2_INVERTER)
      .setConverterStationId1("LCC1")
      .setConverterStationId2("LCC2")
      .setMaxP(12.0)
      .setNominalV(13.0)
      .setR(14.0)
      .add();

  return network;
}  // createHvdcConverterStationNetwork()
}  // namespace iidm
}  // namespace powsybl

namespace DYN {

using powsybl::iidm::createHvdcLccConverterStationNetwork;

TEST(DataInterfaceTest, LccConverter) {
  powsybl::iidm::Network network = createHvdcLccConverterStationNetwork();
  powsybl::iidm::VoltageLevel& vl1 = network.getVoltageLevel("VL1");
  powsybl::iidm::LccConverterStation& lcc = network.getLccConverterStation("LCC1");

  DYN::LccConverterInterfaceIIDM Ifce(lcc);
  const boost::shared_ptr<DYN::VoltageLevelInterface> voltageLevelIfce(new DYN::VoltageLevelInterfaceIIDM(vl1));
  Ifce.setVoltageLevelInterfaceInjector(voltageLevelIfce);
  ASSERT_EQ(Ifce.getID(), "LCC1");
  ASSERT_EQ(Ifce.getComponentVarIndex("nothing"), -1);
  ASSERT_DOUBLE_EQ(Ifce.getLossFactor(), 2.0);
  ASSERT_DOUBLE_EQ(Ifce.getPowerFactor(), -0.2L);

  ASSERT_TRUE(Ifce.getInitialConnected());
  Ifce.exportStateVariablesUnitComponent();
  Ifce.importStaticParameters();

  powsybl::iidm::Bus& b1 = vl1.getBusBreakerView().newBus().setId("BUS1").add();
  b1.setV(410.0).setAngle(3.14);
  const boost::shared_ptr<BusInterface> x_b1(new BusInterfaceIIDM(b1));

  ASSERT_EQ(Ifce.getBusInterface(), nullptr);
  Ifce.setBusInterface(x_b1);
  ASSERT_EQ(Ifce.getBusInterface(), x_b1);
  ASSERT_EQ(Ifce.getBusInterface()->getID(), "BUS1");
  Ifce.setBusInterface(nullptr);
  ASSERT_EQ(Ifce.getBusInterface(), nullptr);
  Ifce.setBusInterface(x_b1);

  ASSERT_FALSE(Ifce.hasP());
  ASSERT_FALSE(Ifce.hasQ());

  ASSERT_DOUBLE_EQ(Ifce.getP(), 0.0);
  lcc.getTerminal().setP(1000.0);
  ASSERT_TRUE(Ifce.hasP());
  ASSERT_DOUBLE_EQ(Ifce.getP(), 1000.0);

  ASSERT_DOUBLE_EQ(Ifce.getQ(), 0.0);
  lcc.getTerminal().setQ(499.0);
  ASSERT_TRUE(Ifce.hasQ());
  ASSERT_DOUBLE_EQ(Ifce.getQ(), 499.0);

  ASSERT_FALSE(Ifce.hasInitialConditions());

  ASSERT_EQ(Ifce.getLccIIDM().getHvdcLine().get().getId(), "HVDC1");
  Ifce.importStaticParameters();

  ASSERT_EQ(Ifce.getLccIIDM().getId(), lcc.getId());

  ASSERT_DOUBLE_EQ(Ifce.getVNom(), 380);
  ASSERT_EQ(Ifce.getVoltageLevelInterfaceInjector(), voltageLevelIfce);

  ASSERT_TRUE(Ifce.isConnected());
  ASSERT_TRUE(Ifce.isPartiallyConnected());
  lcc.getTerminal().disconnect();
  ASSERT_FALSE(Ifce.isPartiallyConnected());
  ASSERT_FALSE(Ifce.isConnected());
  ASSERT_TRUE(Ifce.getInitialConnected());
}  // TEST(DataInterfaceTest, LccConverter)

TEST(DataInterfaceTest, LccConverter_2) {
  powsybl::iidm::Network network = createHvdcLccConverterStationNetwork();
  powsybl::iidm::LccConverterStation& lcc = network.getLccConverterStation("LCC1");

  lcc.getTerminal().setP(0.0);
  lcc.getTerminal().setQ(0.0);

  DYN::LccConverterInterfaceIIDM Ifce(lcc);

  ASSERT_TRUE(Ifce.hasInitialConditions());
}  // TEST(DataInterfaceTest, LccConverter_2)
}  // namespace DYN
