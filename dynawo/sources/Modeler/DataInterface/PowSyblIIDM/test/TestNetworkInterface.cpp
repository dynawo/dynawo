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

#include "DYNNetworkInterfaceIIDM.h"
#include "DYNLineInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNTwoWTransformerInterfaceIIDM.h"
#include "DYNThreeWTransformerInterfaceIIDM.h"
#include "DYNHvdcLineInterfaceIIDM.h"
#include "DYNLccConverterInterfaceIIDM.h"
#include "DYNVscConverterInterfaceIIDM.h"

#include "gtest_dynawo.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Line.hpp>
#include <powsybl/iidm/LineAdder.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/TwoWindingsTransformerAdder.hpp>
#include <powsybl/iidm/ThreeWindingsTransformerAdder.hpp>
#include <powsybl/iidm/VscConverterStation.hpp>
#include <powsybl/iidm/VscConverterStationAdder.hpp>
#include <powsybl/iidm/HvdcLine.hpp>
#include <powsybl/iidm/HvdcLineAdder.hpp>
#include <powsybl/iidm/LccConverterStation.hpp>
#include <powsybl/iidm/LccConverterStationAdder.hpp>

using boost::shared_ptr;

namespace DYN {

TEST(DataInterfaceTest, Network) {
  powsybl::iidm::Network networkIIDM("test", "test");
  powsybl::iidm::Substation& substation = networkIIDM.newSubstation()
                                     .setId("S1")
                                     .setName("S1_NAME")
                                     .setCountry(powsybl::iidm::Country::FR)
                                     .setTso("TSO")
                                     .add();

  powsybl::iidm::VoltageLevel& vl1 = substation.newVoltageLevel()
                                     .setId("VL1")
                                     .setName("VL1_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalV(380.0)
                                     .setLowVoltageLimit(340.0)
                                     .setHighVoltageLimit(420.0)
                                     .add();

  powsybl::iidm::Bus& vl1Bus1 = vl1.getBusBreakerView().newBus().setId("VL1_BUS1").add();

  powsybl::iidm::VoltageLevel& vl2 = substation.newVoltageLevel()
                                     .setId("VL2")
                                     .setName("VL2_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalV(225.0)
                                     .setLowVoltageLimit(200.0)
                                     .setHighVoltageLimit(260.0)
                                     .add();

  vl2.getBusBreakerView().newBus().setId("VL2_BUS1").add();

  powsybl::iidm::Substation& substation2 = networkIIDM.newSubstation()
                                     .setId("S2")
                                     .setName("S2_NAME")
                                     .setCountry(powsybl::iidm::Country::FR)
                                     .setTso("TSO")
                                     .add();

  powsybl::iidm::VoltageLevel& vl3 = substation.newVoltageLevel()
                                     .setId("VL3")
                                     .setName("VL3_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalV(360.0)
                                     .setLowVoltageLimit(340.0)
                                     .setHighVoltageLimit(420.0)
                                     .add();

  powsybl::iidm::Bus& vl3Bus1 = vl3.getBusBreakerView().newBus().setId("VL3_BUS1").add();

  powsybl::iidm::VoltageLevel& vl4 = substation2.newVoltageLevel()
                                     .setId("VL4")
                                     .setName("VL4_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalV(225.0)
                                     .setLowVoltageLimit(200.0)
                                     .setHighVoltageLimit(260.0)
                                     .add();

  vl4.getBusBreakerView().newBus().setId("VL4_BUS1").add();

  powsybl::iidm::Line& MyLine = networkIIDM.newLine()
                                    .setId("VL1_VL3")
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

  powsybl::iidm::TwoWindingsTransformer& transformer = substation.newTwoWindingsTransformer()
      .setId("2WT_VL1_VL2")
      .setVoltageLevel1(vl1.getId())
      .setBus1(vl1Bus1.getId())
      .setConnectableBus1(vl1Bus1.getId())
      .setVoltageLevel2(vl2.getId())
      .setBus2("VL2_BUS1")
      .setConnectableBus2("VL2_BUS1")
      .setR(3.0)
      .setX(33.0)
      .setG(1.0)
      .setB(0.2)
      .setRatedU1(2.0)
      .setRatedU2(0.4)
      .setRatedS(3.0)
      .add();

  powsybl::iidm::ThreeWindingsTransformer& transformer3 = substation.newThreeWindingsTransformer()
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
      .setBus("VL2_BUS1")
      .setConnectableBus("VL2_BUS1")
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

  powsybl::iidm::HvdcLine& hvdcIIDM = networkIIDM.newHvdcLine()
      .setId("HVDC1")
      .setName("HVDC1_NAME")
      .setActivePowerSetpoint(111.1)
      .setConvertersMode(powsybl::iidm::HvdcLine::ConvertersMode::SIDE_1_RECTIFIER_SIDE_2_INVERTER)
      .setConverterStationId1("LCC1")
      .setConverterStationId2("VSC2")
      .setMaxP(12.0)
      .setNominalV(13.0)
      .setR(14.0)
      .add();

  powsybl::iidm::extensions::SlackTerminal::attach(vl1Bus1);

  NetworkInterfaceIIDM network(networkIIDM);
  shared_ptr<LineInterface> li(new LineInterfaceIIDM(MyLine));
  shared_ptr<VoltageLevelInterface> vl(new VoltageLevelInterfaceIIDM(vl1));
  shared_ptr<TwoWTransformerInterface> twoWT(new TwoWTransformerInterfaceIIDM(transformer));
  shared_ptr<ThreeWTransformerInterface> threeWT(new ThreeWTransformerInterfaceIIDM(transformer3));
  powsybl::iidm::LccConverterStation& lcc = networkIIDM.getLccConverterStation("LCC1");
  powsybl::iidm::VscConverterStation& vsc = networkIIDM.getVscConverterStation("VSC2");

  const boost::shared_ptr<LccConverterInterface> LccIfce(new LccConverterInterfaceIIDM(lcc));
  const boost::shared_ptr<VscConverterInterface> VscIfce(new VscConverterInterfaceIIDM(vsc));
  shared_ptr<HvdcLineInterface> hvdc(new HvdcLineInterfaceIIDM(hvdcIIDM, LccIfce, VscIfce));

  ASSERT_EQ(network.getLines().size(), 0);
  network.addLine(li);
  ASSERT_EQ(network.getLines().size(), 1);

  ASSERT_EQ(network.getVoltageLevels().size(), 0);
  network.addVoltageLevel(vl);
  ASSERT_EQ(network.getVoltageLevels().size(), 1);

  ASSERT_EQ(network.getTwoWTransformers().size(), 0);
  network.addTwoWTransformer(twoWT);
  ASSERT_EQ(network.getTwoWTransformers().size(), 1);

  ASSERT_EQ(network.getThreeWTransformers().size(), 0);
  network.addThreeWTransformer(threeWT);
  ASSERT_EQ(network.getThreeWTransformers().size(), 1);

  ASSERT_EQ(network.getHvdcLines().size(), 0);
  network.addHvdcLine(hvdc);
  ASSERT_EQ(network.getHvdcLines().size(), 1);

  auto slackBus = network.getSlackNodeBusId();
  ASSERT_TRUE(slackBus);
  ASSERT_EQ(slackBus.value(), "VL1_BUS1");
}
}  // namespace DYN
