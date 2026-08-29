//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

#include "DYNRatioTapChangerInterfaceIIDM.h"

#include "DYNStepInterfaceIIDM.h"

#include "DYNCommon.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Load.hpp>
#include <powsybl/iidm/LoadAdder.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/RatioTapChanger.hpp>
#include <powsybl/iidm/RatioTapChangerAdder.hpp>
#include <powsybl/iidm/RatioTapChangerStep.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/Terminal.hpp>
#include <powsybl/iidm/ThreeWindingsTransformer.hpp>
#include <powsybl/iidm/ThreeWindingsTransformerAdder.hpp>
#include <powsybl/iidm/TwoWindingsTransformer.hpp>
#include <powsybl/iidm/TwoWindingsTransformerAdder.hpp>

#include "gtest_dynawo.h"

namespace powsybl {

namespace iidm {

static Network
createTwoWindingsTransformerNetwork() {
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

  Load& l1 = vl1.newLoad()
                 .setId("LOAD1")
                 .setName("LOAD1_NAME")
                 .setBus(vl1Bus1.getId())
                 .setConnectableBus(vl1Bus1.getId())
                 .setLoadType(LoadType::UNDEFINED)
                 .setP0(50.0)
                 .setQ0(40.0)
                 .add();

  VoltageLevel& vl2 = substation.newVoltageLevel()
                          .setId("VL2")
                          .setName("VL2_NAME")
                          .setTopologyKind(TopologyKind::BUS_BREAKER)
                          .setNominalV(225.0)
                          .setLowVoltageLimit(200.0)
                          .setHighVoltageLimit(260.0)
                          .add();

  Bus& vl2Bus1 = vl2.getBusBreakerView().newBus().setId("VL2_BUS1").add();

  vl2.newLoad()
      .setId("LOAD2")
      .setName("LOAD2_NAME")
      .setBus(vl2Bus1.getId())
      .setConnectableBus(vl2Bus1.getId())
      .setLoadType(LoadType::UNDEFINED)
      .setP0(60.0)
      .setQ0(70.0)
      .add();

  substation.newTwoWindingsTransformer()
      .setId("2WT_VL1_VL2")
      .setVoltageLevel1(vl1.getId())
      .setBus1(vl1Bus1.getId())
      .setConnectableBus1(vl1Bus1.getId())
      .setVoltageLevel2(vl2.getId())
      .setBus2(vl2Bus1.getId())
      .setConnectableBus2(vl2Bus1.getId())
      .setR(3.0)
      .setX(33.0)
      .setG(1.0)
      .setB(0.2)
      .setRatedU1(2.0)
      .setRatedU2(0.4)
      .add()
      .newRatioTapChanger()
      .setTapPosition(2L)     // tag_UUHU
      .setLowTapPosition(1L)  // tag_YYHY
      .beginStep()            // step "lowPosition"
      .setB(10.0)
      .setG(11.0)
      .setR(12.0)
      .setRho(13.0)
      .setX(14.0)
      .endStep()
      .beginStep()  // step "currentPosition"
      .setB(15.0)
      .setG(16.0)
      .setR(17.0)
      .setRho(18.0)
      .setX(19.0)
      .endStep()  // Position 3L tag_HHHG
      .beginStep()
      .setB(20.0)
      .setG(21.0)
      .setR(22.0)
      .setRho(23.0)
      .setX(24.0)
      .endStep()  // No position 4L, neither 0L or -1L
      .setLoadTapChangingCapabilities(true)
      .setRegulating(true)
      .setRegulationTerminal(stdcxx::ref<Terminal>(l1.getTerminal()))
      .setTargetV(25.0)
      .setTargetDeadband(0.1)
      .add();

  return network;
}  // createTwoWindingsTransformerNetwork()
}  // namespace iidm
}  // namespace powsybl

namespace DYN {
using powsybl::iidm::createTwoWindingsTransformerNetwork;

TEST(DataInterfaceTest, RatioTapChanger_2WT) {
  const powsybl::iidm::Network& network = createTwoWindingsTransformerNetwork();
  const powsybl::iidm::TwoWindingsTransformer& twoWT = network.getTwoWindingsTransformer("2WT_VL1_VL2");
  powsybl::iidm::RatioTapChanger rtcCopy(twoWT.getRatioTapChanger());
  const std::string Parent(twoWT.getId());

  DYN::RatioTapChangerInterfaceIIDM Ifce(rtcCopy, "ONE");
  ASSERT_EQ(Ifce.getNbTap(), 3);
  ASSERT_EQ(Ifce.getSteps().size(), 3);
  ASSERT_EQ(Ifce.getLowPosition(), 1L);      // because tag_YYHY
  ASSERT_EQ(Ifce.getCurrentPosition(), 2L);  // because tag_UUHU

  Ifce.setCurrentPosition(3L);  // because tag_HHHG
  ASSERT_EQ(Ifce.getCurrentPosition(), 3L);

  ASSERT_THROW(Ifce.setCurrentPosition(4L), std::exception);
  ASSERT_THROW(Ifce.setCurrentPosition(-1L), std::exception);
  ASSERT_THROW(Ifce.setCurrentPosition(0L), std::exception);

  ASSERT_EQ(Ifce.getCurrentPosition(), 3L);

  ASSERT_EQ(Ifce.getNbTap(), 3);
  ASSERT_EQ(Ifce.getSteps().size(), 3);
  ASSERT_EQ(Ifce.getNbTap(), rtcCopy.getStepCount());
  ASSERT_EQ(Ifce.getLowPosition(), 1L);

  Ifce.setCurrentPosition(1L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentRho(), 13.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentR(), 12.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentX(), 14.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentG(), 11.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentB(), 10.0L);
  Ifce.setCurrentPosition(2L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentRho(), 18.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentR(), 17.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentX(), 19.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentG(), 16.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentB(), 15.0L);
  Ifce.setCurrentPosition(3L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentRho(), 23.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentR(), 22.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentX(), 24.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentG(), 21.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentB(), 20.0L);

  ASSERT_TRUE(Ifce.hasLoadTapChangingCapabilities());
  ASSERT_DOUBLE_EQ(Ifce.getTargetV(), 25.0);

  rtcCopy.setRegulating(false);
  rtcCopy.setTargetV(stdcxx::nan());
  ASSERT_FALSE(Ifce.getRegulating());
  ASSERT_DOUBLE_EQ(Ifce.getTargetV(), 99999.0L);
  ASSERT_EQ(Ifce.getTerminalRefId(), "");
  ASSERT_EQ(Ifce.getTerminalRefSide(), "ONE");
  ASSERT_DOUBLE_EQUALS_DYNAWO(Ifce.getTargetDeadBand(), 0.);

  rtcCopy.setTargetV(666.666);
  rtcCopy.setRegulating(true);
  ASSERT_TRUE(Ifce.getRegulating());
  ASSERT_DOUBLE_EQ(Ifce.getTargetV(), 666.666L);

  rtcCopy.setRegulating(true);
  ASSERT_THROW(rtcCopy.setTargetV(stdcxx::nan()), std::exception);
  ASSERT_DOUBLE_EQUALS_DYNAWO(Ifce.getTargetDeadBand(), 0.1);

  ASSERT_EQ(Ifce.getTerminalRefId(), "LOAD1");
  ASSERT_EQ(Ifce.getTerminalRefSide(), "ONE");
}

TEST(DataInterfaceTest, RatioTapChanger_bad) {
  const powsybl::iidm::Network& network = createTwoWindingsTransformerNetwork();
  powsybl::iidm::RatioTapChanger rTapChanger = network.getTwoWindingsTransformer("2WT_VL1_VL2").getRatioTapChanger();
  const std::string Parent("test_RTC_Parent");

  rTapChanger.setRegulating(false);
  rTapChanger.setTargetV(stdcxx::nan());
  DYN::RatioTapChangerInterfaceIIDM Ifce(rTapChanger, Parent);
  ASSERT_EQ(Ifce.getTerminalRefId(), "");
  ASSERT_DOUBLE_EQ(Ifce.getTargetV(), 99999.0L);
  ASSERT_THROW(rTapChanger.setRegulating(true), std::exception);  // no way to regulate a bad powsybl tap changer in powsybl-2
}  // TEST(DataInterfaceTest, RatioTapChanger_bad)
}  // namespace DYN

namespace powsybl {
namespace iidm {

static Network
createThreeWindingsTransformerNetwork() {
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

  vl1.newLoad()
      .setId("LOAD1")
      .setName("LOAD1_NAME")
      .setBus(vl1Bus1.getId())
      .setConnectableBus(vl1Bus1.getId())
      .setLoadType(LoadType::UNDEFINED)
      .setP0(50.0)
      .setQ0(40.0)
      .add();

  VoltageLevel& vl2 = substation.newVoltageLevel()
                          .setId("VL2")
                          .setName("VL2_NAME")
                          .setTopologyKind(TopologyKind::BUS_BREAKER)
                          .setNominalV(225.0)
                          .setLowVoltageLimit(200.0)
                          .setHighVoltageLimit(260.0)
                          .add();

  Bus& vl2Bus1 = vl2.getBusBreakerView().newBus().setId("VL2_BUS1").add();

  vl2.newLoad()
      .setId("LOAD2")
      .setName("LOAD2_NAME")
      .setBus(vl2Bus1.getId())
      .setConnectableBus(vl2Bus1.getId())
      .setLoadType(LoadType::UNDEFINED)
      .setP0(60.0)
      .setQ0(70.0)
      .add();

  VoltageLevel& vl3 = substation.newVoltageLevel()
                          .setId("VL3")
                          .setName("VL3_NAME")
                          .setTopologyKind(TopologyKind::BUS_BREAKER)
                          .setNominalV(380.0)
                          .setLowVoltageLimit(340.0)
                          .setHighVoltageLimit(420.0)
                          .add();

  Bus& vl3Bus1 = vl3.getBusBreakerView().newBus().setId("VL3_BUS1").add();

  Substation& substation2 = network.newSubstation()
                                .setId("S2")
                                .setName("S2_NAME")
                                .setCountry(Country::FR)
                                .setTso("TSO")
                                .add();

  VoltageLevel& vl4 = substation2.newVoltageLevel()
                          .setId("VL4")
                          .setName("VL4_NAME")
                          .setTopologyKind(TopologyKind::BUS_BREAKER)
                          .setNominalV(225.0)
                          .setLowVoltageLimit(200.0)
                          .setHighVoltageLimit(260.0)
                          .add();

  vl4.getBusBreakerView().newBus().setId("VL4_BUS1").add();

  substation.newThreeWindingsTransformer()
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

  return network;
}  // createThreeWindingsTransformerNetwork()

static void
addRatioTapChangerLeg2(ThreeWindingsTransformer& transformer, Terminal& terminal) {
  transformer.getLeg2()
      .newRatioTapChanger()
      .setTapPosition(2L)
      .setLowTapPosition(1L)
      .beginStep()
      .setB(10.0)
      .setG(11.0)
      .setR(12.0)
      .setRho(13.0)
      .setX(14.0)
      .endStep()
      .beginStep()
      .setB(15.0)
      .setG(16.0)
      .setR(17.0)
      .setRho(18.0)
      .setX(19.0)
      .endStep()
      .beginStep()
      .setB(20.0)
      .setG(21.0)
      .setR(22.0)
      .setRho(23.0)
      .setX(24.0)
      .endStep()
      .setLoadTapChangingCapabilities(true)
      .setRegulating(true)
      .setRegulationTerminal(stdcxx::ref<Terminal>(terminal))
      .setTargetV(25.0)
      .setTargetDeadband(1.0)
      .add();
}

static void
addRatioTapChangerLeg3(ThreeWindingsTransformer& transformer, Terminal& terminal) {
  transformer.getLeg3()
      .newRatioTapChanger()
      .setTapPosition(-2L)
      .setLowTapPosition(-3L)
      .beginStep()
      .setB(-10.0)
      .setG(-11.0)
      .setR(-12.0)
      .setRho(-13.0)
      .setX(-14.0)
      .endStep()
      .beginStep()
      .setB(-15.0)
      .setG(-16.0)
      .setR(-17.0)
      .setRho(-18.0)
      .setX(-19.0)
      .endStep()
      .beginStep()
      .setB(-20.0)
      .setG(-21.0)
      .setR(-22.0)
      .setRho(-23.0)
      .setX(-24.0)
      .endStep()
      .beginStep()
      .setB(-200.0)
      .setG(-210.0)
      .setR(-220.0)
      .setRho(-230.0)
      .setX(-240.0)
      .endStep()
      .setLoadTapChangingCapabilities(true)
      .setRegulating(false)
      .setRegulationTerminal(stdcxx::ref<Terminal>(terminal))
      .setTargetV(26.0)
      .setTargetDeadband(2.0)
      .add();
}
}  // namespace iidm
}  // namespace powsybl

namespace DYN {
using powsybl::iidm::createThreeWindingsTransformerNetwork;

TEST(DataInterfaceTest, RatioTapChanger_3WT) {
  powsybl::iidm::Network network = createThreeWindingsTransformerNetwork();
  powsybl::iidm::ThreeWindingsTransformer& transformer = network.getThreeWindingsTransformer("3WT_VL1_VL2_VL3");
  powsybl::iidm::Terminal& terminal = network.getLoad("LOAD1").getTerminal();
  powsybl::iidm::Terminal& terminal2 = network.getLoad("LOAD2").getTerminal();
  addRatioTapChangerLeg2(transformer, terminal);
  addRatioTapChangerLeg3(transformer, terminal2);

  powsybl::iidm::RatioTapChanger& rTapChanger = transformer.getLeg3().getRatioTapChanger();
  const std::string Parent("test_RTC_Parent");
  DYN::RatioTapChangerInterfaceIIDM Ifce(rTapChanger, Parent);

  ASSERT_EQ(Ifce.getNbTap(), 4);
  ASSERT_EQ(Ifce.getLowPosition(), -3L);
  ASSERT_EQ(Ifce.getCurrentPosition(), -2L);
  ASSERT_EQ(Ifce.getNbTap(), rTapChanger.getStepCount());

  Ifce.setCurrentPosition(Ifce.getLowPosition());
  ASSERT_DOUBLE_EQ(Ifce.getCurrentRho(), -13.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentR(), -12.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentX(), -14.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentG(), -11.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentB(), -10.0L);
  Ifce.setCurrentPosition(Ifce.getLowPosition() + Ifce.getNbTap() - 1L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentRho(), -230.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentR(), -220.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentX(), -240.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentG(), -210.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentB(), -200.0L);

  ASSERT_EQ(Ifce.getLowPosition(), -3L);
  ASSERT_EQ(Ifce.getSteps().size(), 4);
}  // TEST(DataInterfaceTest, RatioTapChanger_3WT)
}  // namespace DYN
