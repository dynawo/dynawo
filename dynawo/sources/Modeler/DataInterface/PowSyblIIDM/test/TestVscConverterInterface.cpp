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

#include "DYNVscConverterInterfaceIIDM.h"

#include "DYNBusInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"

#include <powsybl/iidm/HvdcLine.hpp>
#include <powsybl/iidm/HvdcLineAdder.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/Terminal.hpp>
#include <powsybl/iidm/VscConverterStation.hpp>
#include <powsybl/iidm/VscConverterStationAdder.hpp>

#include "gtest_dynawo.h"

namespace powsybl {
namespace iidm {

static Network
createHvdcConverterStationNetwork() {
  Network network("test", "test");
  Substation& substation = network.newSubstation().setId("S1").setName("S1_NAME").setCountry(Country::FR).setTso("TSO").add();

  VoltageLevel& vl1 = substation.newVoltageLevel()
                          .setId("VL1")
                          .setName("VL1_NAME")
                          .setTopologyKind(TopologyKind::BUS_BREAKER)
                          .setNominalV(388.0)
                          .setLowVoltageLimit(340.0)
                          .setHighVoltageLimit(420.0)
                          .add();

  Bus& vl1Bus1 = vl1.getBusBreakerView().newBus().setId("VL1_BUS1").add();

  vl1.newVscConverterStation()
      .setId("VSC1")
      .setName("VSC1_NAME")
      .setBus(vl1Bus1.getId())
      .setConnectableBus(vl1Bus1.getId())
      .setLossFactor(3.0)
      .setVoltageRegulatorOn(true)
      .setVoltageSetpoint(4.0)
      .setReactivePowerSetpoint(5.0)
      .add();

  vl1.newVscConverterStation()
      .setId("VSC2")
      .setName("VSC2_NAME")
      .setBus(vl1Bus1.getId())
      .setConnectableBus(vl1Bus1.getId())
      .setLossFactor(3.0)
      .setVoltageRegulatorOn(false)
      .setVoltageSetpoint(-4.0)
      .setReactivePowerSetpoint(-5.0)
      .add();

  network.newHvdcLine()
      .setId("HVDC1")
      .setName("HVDC1_NAME")
      .setActivePowerSetpoint(111.1)
      .setConvertersMode(HvdcLine::ConvertersMode::SIDE_1_RECTIFIER_SIDE_2_INVERTER)
      .setConverterStationId1("VSC1")
      .setConverterStationId2("VSC2")
      .setMaxP(12.0)
      .setNominalV(13.0)
      .setR(14.0)
      .add();

  return network;
}  // createHvdcConverterStationNetwork()
}  // namespace iidm
}  // namespace powsybl

namespace DYN {

using powsybl::iidm::createHvdcConverterStationNetwork;

TEST(DataInterfaceTest, VscConverter_1) {
  powsybl::iidm::Network network = createHvdcConverterStationNetwork();
  powsybl::iidm::VoltageLevel& vl1 = network.getVoltageLevel("VL1");
  powsybl::iidm::VscConverterStation& vsc = network.getVscConverterStation("VSC1");

  VscConverterInterfaceIIDM Ifce(vsc);
  const boost::shared_ptr<VoltageLevelInterface> voltageLevelIfce(new VoltageLevelInterfaceIIDM(vl1));
  Ifce.setVoltageLevelInterface(voltageLevelIfce);
  ASSERT_EQ(Ifce.getID(), "VSC1");
  ASSERT_EQ(Ifce.getComponentVarIndex("nothing"), -1);
  ASSERT_DOUBLE_EQ(Ifce.getLossFactor(), 3.0);
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
  vsc.getTerminal().setP(1000.0);
  ASSERT_TRUE(Ifce.hasP());
  ASSERT_DOUBLE_EQ(Ifce.getP(), 1000.0);

  ASSERT_DOUBLE_EQ(Ifce.getQ(), 0.0);
  vsc.getTerminal().setQ(499.0);
  ASSERT_TRUE(Ifce.hasQ());
  ASSERT_DOUBLE_EQ(Ifce.getQ(), 499.0);

  ASSERT_FALSE(Ifce.hasInitialConditions());

  ASSERT_TRUE(Ifce.getVoltageRegulatorOn());
  ASSERT_DOUBLE_EQ(Ifce.getVoltageSetpoint(), 4.0);
  ASSERT_DOUBLE_EQ(Ifce.getReactivePowerSetpoint(), 5.0);
  powsybl::iidm::VscConverterStation& vsc2 = network.getVscConverterStation("VSC2");
  VscConverterInterfaceIIDM Ifce2(vsc2);
  ASSERT_FALSE(Ifce2.getVoltageRegulatorOn());
  ASSERT_DOUBLE_EQ(Ifce2.getVoltageSetpoint(), -4.0);
  ASSERT_DOUBLE_EQ(Ifce2.getReactivePowerSetpoint(), -5.0);

  ASSERT_EQ(Ifce.getVscIIDM().getHvdcLine().get().getId(), "HVDC1");
  Ifce.importStaticParameters();

  ASSERT_EQ(Ifce.getVscIIDM().getId(), vsc.getId());
  ASSERT_DOUBLE_EQ(Ifce.getVNom(), 388);
  ASSERT_EQ(Ifce.getVoltageLevelInterfaceInjector(), voltageLevelIfce);

  vsc.newReactiveCapabilityCurve()
     .beginPoint()
       .setP(-2000)
       .setMinQ(10)
       .setMaxQ(10)
     .endPoint()
     .beginPoint()
       .setP(0)
       .setMinQ(10)
       .setMaxQ(20)
     .endPoint()
     .beginPoint()
       .setP(2000)
       .setMinQ(10)
       .setMaxQ(10)
     .endPoint()
     .add();
  ASSERT_DOUBLE_EQ(Ifce.getQMax(), 15.0);

  ASSERT_TRUE(Ifce.isConnected());
  ASSERT_TRUE(Ifce.isPartiallyConnected());
  vsc.getTerminal().disconnect();
  ASSERT_FALSE(Ifce.isConnected());
  ASSERT_FALSE(Ifce.isPartiallyConnected());
  ASSERT_TRUE(Ifce.getInitialConnected());
  ASSERT_DOUBLE_EQ(Ifce.getQMin(), 10.0);
  const auto& points = Ifce.getReactiveCurvesPoints();
  ASSERT_EQ(points.size(), 3);
  ASSERT_EQ(points.at(0).p, -2000);
  ASSERT_EQ(points.at(0).qmax, 10);
  ASSERT_EQ(points.at(0).qmin, 10);
  ASSERT_EQ(points.at(1).p, 0.);
  ASSERT_EQ(points.at(1).qmax, 20);
  ASSERT_EQ(points.at(1).qmin, 10);
  ASSERT_EQ(points.at(2).p, 2000);
  ASSERT_EQ(points.at(2).qmax, 10);
  ASSERT_EQ(points.at(2).qmin, 10);
}  // TEST(DataInterfaceTest, VscConverter_1)

TEST(DataInterfaceTest, VscConverter_2) {
  powsybl::iidm::Network network = createHvdcConverterStationNetwork();
  powsybl::iidm::VscConverterStation& vsc = network.getVscConverterStation("VSC1");

  vsc.getTerminal().setP(0.0);
  vsc.getTerminal().setQ(0.0);

  VscConverterInterfaceIIDM Ifce(vsc);

  ASSERT_TRUE(Ifce.hasInitialConditions());
}  // TEST(DataInterfaceTest, VscConverter_2)
}  // namespace DYN
