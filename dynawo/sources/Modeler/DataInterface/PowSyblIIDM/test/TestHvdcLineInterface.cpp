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

#include "DYNHvdcLineInterfaceIIDM.h"

#include "DYNLccConverterInterfaceIIDM.h"
#include "DYNVscConverterInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/HvdcLine.hpp>
#include <powsybl/iidm/HvdcLineAdder.hpp>
#include <powsybl/iidm/LccConverterStation.hpp>
#include <powsybl/iidm/LccConverterStationAdder.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/Terminal.hpp>
#include <powsybl/iidm/VscConverterStation.hpp>
#include <powsybl/iidm/VscConverterStationAdder.hpp>

#include "gtest_dynawo.h"

namespace powsybl {
namespace iidm {

static Network
createHvdcLineNetwork() {
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

  vl1.newVscConverterStation()
      .setId("VSC2")
      .setName("VSC2_NAME")
      .setBus(vl1Bus1.getId())
      .setConnectableBus(vl1Bus1.getId())
      .setLossFactor(3.0)
      .setVoltageRegulatorOn(true)
      .setVoltageSetpoint(1.2)
      .setReactivePowerSetpoint(-1.5)
      .add();

  network.newHvdcLine()
      .setId("HVDC1")
      .setName("HVDC1_NAME")
      .setActivePowerSetpoint(111.1)
      .setConvertersMode(HvdcLine::ConvertersMode::SIDE_1_RECTIFIER_SIDE_2_INVERTER)
      .setConverterStationId1("LCC1")
      .setConverterStationId2("VSC2")
      .setMaxP(12.0)
      .setNominalV(13.0)
      .setR(14.0)
      .add();

  return network;
}  // createHvdcLineNetwork()
}  // namespace iidm
}  // namespace powsybl

namespace DYN {

using powsybl::iidm::createHvdcLineNetwork;

TEST(DataInterfaceTest, HvdcLine) {
  powsybl::iidm::Network network = createHvdcLineNetwork();
  powsybl::iidm::HvdcLine& hvdcLine = network.getHvdcLine("HVDC1");
  powsybl::iidm::LccConverterStation& lcc = network.getLccConverterStation("LCC1");
  powsybl::iidm::VscConverterStation& vsc = network.getVscConverterStation("VSC2");
  powsybl::iidm::VoltageLevel& vl1 = network.getVoltageLevel("VL1");

  const boost::shared_ptr<LccConverterInterface> LccIfce(new LccConverterInterfaceIIDM(lcc));
  const boost::shared_ptr<VscConverterInterface> VscIfce(new VscConverterInterfaceIIDM(vsc));

  DYN::HvdcLineInterfaceIIDM Ifce(hvdcLine, LccIfce, VscIfce);
  const boost::shared_ptr<VoltageLevelInterface> vlItf(new VoltageLevelInterfaceIIDM(vl1));
  LccIfce->setVoltageLevelInterface(vlItf);
  VscIfce->setVoltageLevelInterface(vlItf);
  ASSERT_EQ(Ifce.getID(), "HVDC1");

  ASSERT_EQ(Ifce.getIdConverter1(), "LCC1");
  ASSERT_EQ(Ifce.getConverter1().get()->getID(), "LCC1");
  ASSERT_EQ(Ifce.getIdConverter2(), "VSC2");
  ASSERT_EQ(Ifce.getConverter2().get()->getID(), "VSC2");

  ASSERT_DOUBLE_EQ(Ifce.getResistanceDC(), 14.0);
  ASSERT_DOUBLE_EQ(Ifce.getVNom(), 13.0);
  ASSERT_DOUBLE_EQ(Ifce.getPmax(), 12.0);
  ASSERT_DOUBLE_EQ(Ifce.getActivePowerSetpoint(), 111.1);

  ASSERT_EQ(Ifce.getComponentVarIndex(std::string("p1")), HvdcLineInterfaceIIDM::VAR_P1);
  ASSERT_EQ(Ifce.getComponentVarIndex(std::string("p2")), HvdcLineInterfaceIIDM::VAR_P2);
  ASSERT_EQ(Ifce.getComponentVarIndex(std::string("q1")), HvdcLineInterfaceIIDM::VAR_Q1);
  ASSERT_EQ(Ifce.getComponentVarIndex(std::string("q2")), HvdcLineInterfaceIIDM::VAR_Q2);
  ASSERT_EQ(Ifce.getComponentVarIndex(std::string("state1")), HvdcLineInterfaceIIDM::VAR_STATE1);
  ASSERT_EQ(Ifce.getComponentVarIndex(std::string("state2")), HvdcLineInterfaceIIDM::VAR_STATE2);
  ASSERT_EQ(Ifce.getComponentVarIndex(std::string("invalid")), -1);

  ASSERT_EQ(Ifce.getConverterMode(), HvdcLineInterface::RECTIFIER_INVERTER);
  hvdcLine.setConvertersMode(powsybl::iidm::HvdcLine::ConvertersMode::SIDE_1_INVERTER_SIDE_2_RECTIFIER);
  ASSERT_EQ(Ifce.getConverterMode(), HvdcLineInterface::INVERTER_RECTIFIER);
  hvdcLine.setConvertersMode(powsybl::iidm::HvdcLine::ConvertersMode::SIDE_1_RECTIFIER_SIDE_2_INVERTER);
  ASSERT_EQ(Ifce.getConverterMode(), HvdcLineInterface::RECTIFIER_INVERTER);

  ASSERT_FALSE(Ifce.getDroop());
  ASSERT_FALSE(Ifce.getP0());
  ASSERT_FALSE(Ifce.isActivePowerControlEnabled());
  ASSERT_FALSE(Ifce.getOprFromCS1toCS2());
  ASSERT_FALSE(Ifce.getOprFromCS2toCS1());

  ASSERT_TRUE(Ifce.isConnected());
  ASSERT_TRUE(Ifce.isPartiallyConnected());
  lcc.getTerminal().disconnect();
  ASSERT_FALSE(Ifce.isConnected());
  ASSERT_TRUE(Ifce.isPartiallyConnected());
  vsc.getTerminal().disconnect();
  ASSERT_FALSE(Ifce.isConnected());
  ASSERT_FALSE(Ifce.isPartiallyConnected());
  lcc.getTerminal().connect();
  ASSERT_FALSE(Ifce.isConnected());
  ASSERT_TRUE(Ifce.isPartiallyConnected());

  ASSERT_TRUE(Ifce.hasInitialConditions());
}  // TEST(DataInterfaceTest, HvdcLine)
}  // namespace DYN
