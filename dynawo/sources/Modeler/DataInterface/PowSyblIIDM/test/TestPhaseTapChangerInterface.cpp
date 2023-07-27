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

#include "DYNPhaseTapChangerInterfaceIIDM.h"

#include "DYNStepInterfaceIIDM.h"
#include "DYNCommon.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Load.hpp>
#include <powsybl/iidm/LoadAdder.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/PhaseTapChanger.hpp>
#include <powsybl/iidm/PhaseTapChangerAdder.hpp>
#include <powsybl/iidm/PhaseTapChangerStep.hpp>
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
create_2WT_PhaseTapChanger_Network() {
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
      .newPhaseTapChanger()
      .setTapPosition(2L)     // tag_UUHU
      .setLowTapPosition(1L)  // tag_YYHY
      .beginStep()            // step "lowPosition"
      .setB(10.0)
      .setG(11.0)
      .setR(12.0)
      .setRho(13.0)
      .setX(14.0)
      .setAlpha(96.97)
      .endStep()
      .beginStep()  // step "currentPosition"
      .setB(15.0)
      .setG(16.0)
      .setR(17.0)
      .setRho(18.0)
      .setX(19.0)
      .setAlpha(97.98)
      .endStep()  // Position 3L tag_HHHG
      .beginStep()
      .setB(20.0)
      .setG(21.0)
      .setR(22.0)
      .setRho(23.0)
      .setX(24.0)
      .setAlpha(98.99)
      .endStep()  // No position 4L, neither 0L or -1L
      .setRegulating(false)
      .setRegulationTerminal(stdcxx::ref<Terminal>(l1.getTerminal()))
      .setTargetDeadband(0.1)
      .add();

  return network;
}  // create_2WT_PhaseTapChanger_Network()
}  // namespace iidm
}  // namespace powsybl

namespace DYN {
using powsybl::iidm::create_2WT_PhaseTapChanger_Network;

TEST(DataInterfaceTest, PhaseTapChanger_2WT) {
  const powsybl::iidm::Network& network = create_2WT_PhaseTapChanger_Network();
  const powsybl::iidm::TwoWindingsTransformer& twoWT = network.getTwoWindingsTransformer("2WT_VL1_VL2");
  powsybl::iidm::PhaseTapChanger ptcCopy(twoWT.getPhaseTapChanger());

  DYN::PhaseTapChangerInterfaceIIDM Ifce(ptcCopy);
  ASSERT_EQ(Ifce.getSteps().size(), 3);  // number of steps
  ASSERT_EQ(Ifce.getNbTap(), 3);         // getNbTap() is the number of steps!
  ASSERT_EQ(Ifce.getNbTap(), ptcCopy.getStepCount());
  ASSERT_EQ(Ifce.getLowPosition(), 1L);      // because tag_YYHY
  ASSERT_EQ(Ifce.getCurrentPosition(), 2L);  // because tag_UUHU

  Ifce.setCurrentPosition(3L);  // because tag_HHHG
  ASSERT_EQ(Ifce.getCurrentPosition(), 3L);

  ASSERT_THROW(Ifce.setCurrentPosition(4L), std::exception);
  ASSERT_THROW(Ifce.setCurrentPosition(-1L), std::exception);
  ASSERT_THROW(Ifce.setCurrentPosition(0L), std::exception);
  ASSERT_EQ(Ifce.getCurrentPosition(), 3L);

  Ifce.setCurrentPosition(1L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentAlpha(), 96.97);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentRho(), 13.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentR(), 12.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentX(), 14.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentG(), 11.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentB(), 10.0L);
  Ifce.setCurrentPosition(2L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentAlpha(), 97.98);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentRho(), 18.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentR(), 17.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentX(), 19.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentG(), 16.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentB(), 15.0L);
  Ifce.setCurrentPosition(3L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentAlpha(), 98.99);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentRho(), 23.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentR(), 22.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentX(), 24.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentG(), 21.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentB(), 20.0L);

  ptcCopy.setRegulationMode(powsybl::iidm::PhaseTapChanger::RegulationMode::FIXED_TAP);
  ASSERT_FALSE(Ifce.isCurrentLimiter());
  ASSERT_DOUBLE_EQ(Ifce.getRegulationValue(), 99999.0);

  ptcCopy.setRegulationValue(100000.0);
  ptcCopy.setRegulationMode(powsybl::iidm::PhaseTapChanger::RegulationMode::CURRENT_LIMITER);
  ASSERT_TRUE(Ifce.isCurrentLimiter());
  ASSERT_DOUBLE_EQ(Ifce.getRegulationValue(), 100000.0);

  ptcCopy.setRegulating(true);
  ASSERT_TRUE(Ifce.getRegulating());
  ASSERT_DOUBLE_EQUALS_DYNAWO(Ifce.getTargetDeadBand(), 0.1);
  ptcCopy.setRegulating(false);
  ASSERT_FALSE(Ifce.getRegulating());
  ASSERT_DOUBLE_EQUALS_DYNAWO(Ifce.getTargetDeadBand(), 0.);
}  // TEST(DataInterfaceTest, PhaseTapChanger_2WT)
}  // namespace DYN

namespace powsybl {
namespace iidm {

static Network
create_3WT_PhaseTapChanger_Network() {
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
}  // create_3WT_PhaseTapChanger_Network()

static void
addPhaseTapChangerLeg2(ThreeWindingsTransformer& transformer, Terminal& terminal) {
  transformer.getLeg2()
      .newPhaseTapChanger()
      .setTapPosition(2L)
      .setLowTapPosition(1L)
      .beginStep()
      .setAlpha(110.0)
      .setB(10.0)
      .setG(11.0)
      .setR(12.0)
      .setRho(13.0)
      .setX(14.0)
      .endStep()
      .beginStep()
      .setAlpha(111.0)
      .setB(15.0)
      .setG(16.0)
      .setR(17.0)
      .setRho(18.0)
      .setX(19.0)
      .endStep()
      .beginStep()
      .setAlpha(112.0)
      .setB(20.0)
      .setG(21.0)
      .setR(22.0)
      .setRho(23.0)
      .setX(24.0)
      .endStep()
      .setRegulating(false)
      .setRegulationTerminal(stdcxx::ref<Terminal>(terminal))
      .setTargetDeadband(1.0)
      .add();
}  // addRatioTapChangerLeg2()

static void
addPhaseTapChangerLeg3(ThreeWindingsTransformer& transformer, Terminal& terminal) {
  transformer.getLeg3()
      .newPhaseTapChanger()
      .setTapPosition(-2L)
      .setLowTapPosition(-3L)
      .beginStep()
      .setAlpha(-120.0)
      .setB(-10.0)
      .setG(-11.0)
      .setR(-12.0)
      .setRho(-13.0)
      .setX(-14.0)
      .endStep()
      .beginStep()
      .setAlpha(-121.0)
      .setB(-15.0)
      .setG(-16.0)
      .setR(-17.0)
      .setRho(-18.0)
      .setX(-19.0)
      .endStep()
      .beginStep()
      .setAlpha(-122.0)
      .setB(-20.0)
      .setG(-21.0)
      .setR(-22.0)
      .setRho(-23.0)
      .setX(-24.0)
      .endStep()
      .beginStep()
      .setAlpha(-123.0)
      .setB(-200.0)
      .setG(-210.0)
      .setR(-220.0)
      .setRho(-230.0)
      .setX(-240.0)
      .endStep()
      .setRegulating(false)
      .setRegulationTerminal(stdcxx::ref<Terminal>(terminal))
      .setTargetDeadband(2.0)
      .add();
}  // addRatioTapChangerLeg3()
}  // namespace iidm
}  // namespace powsybl

namespace DYN {
using powsybl::iidm::create_3WT_PhaseTapChanger_Network;

TEST(DataInterfaceTest, PhaseTapChanger_3WT) {
  powsybl::iidm::Network network = create_3WT_PhaseTapChanger_Network();
  powsybl::iidm::ThreeWindingsTransformer& transformer = network.getThreeWindingsTransformer("3WT_VL1_VL2_VL3");
  powsybl::iidm::Terminal& terminal = network.getLoad("LOAD1").getTerminal();
  powsybl::iidm::Terminal& terminal2 = network.getLoad("LOAD2").getTerminal();
  addPhaseTapChangerLeg2(transformer, terminal);
  addPhaseTapChangerLeg3(transformer, terminal2);

  powsybl::iidm::PhaseTapChanger& pTapChanger = transformer.getLeg3().getPhaseTapChanger();
  DYN::PhaseTapChangerInterfaceIIDM Ifce(pTapChanger);

  ASSERT_EQ(Ifce.getNbTap(), 4);
  ASSERT_EQ(Ifce.getNbTap(), pTapChanger.getStepCount());
  ASSERT_EQ(Ifce.getLowPosition(), -3L);
  ASSERT_EQ(Ifce.getCurrentPosition(), -2L);

  Ifce.setCurrentPosition(Ifce.getLowPosition());
  ASSERT_DOUBLE_EQ(Ifce.getCurrentRho(), -13.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentR(), -12.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentX(), -14.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentG(), -11.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentB(), -10.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentAlpha(), -120.0L);
  Ifce.setCurrentPosition(Ifce.getLowPosition() + Ifce.getNbTap() - 1L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentRho(), -230.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentR(), -220.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentX(), -240.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentG(), -210.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentB(), -200.0L);
  ASSERT_DOUBLE_EQ(Ifce.getCurrentAlpha(), -123.0L);

  ASSERT_EQ(Ifce.getLowPosition(), -3L);
  ASSERT_EQ(Ifce.getSteps().size(), 4);
}  // TEST(DataInterfaceTest, PhaseTapChanger_3WT)
}  // namespace DYN
