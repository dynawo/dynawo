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

#include "DYNTwoWTransformerInterfaceIIDM.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Load.hpp>
#include <powsybl/iidm/LoadAdder.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/PhaseTapChangerAdder.hpp>
#include <powsybl/iidm/RatioTapChangerAdder.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/TwoWindingsTransformerAdder.hpp>

#include "gtest_dynawo.h"

#include "DYNBusInterfaceIIDM.h"
#include "DYNCurrentLimitInterfaceIIDM.h"
#include "DYNPhaseTapChangerInterfaceIIDM.h"
#include "DYNRatioTapChangerInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"

namespace DYN {

using powsybl::iidm::Bus;
using powsybl::iidm::Load;
using powsybl::iidm::LoadType;
using powsybl::iidm::Network;
using powsybl::iidm::PhaseTapChanger;
using powsybl::iidm::Substation;
using powsybl::iidm::Terminal;
using powsybl::iidm::TopologyKind;
using powsybl::iidm::TwoWindingsTransformer;
using powsybl::iidm::VoltageLevel;

TEST(DataInterfaceTest, TwoWTransformer_1) {
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

  Load& load1 = vl1.newLoad()
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

  Bus& vl2Bus1 = vl2.getBusBreakerView().newBus()
      .setId("VL2_BUS1")
      .add();

  Load& load2 = vl2.newLoad()
      .setId("LOAD2")
      .setName("LOAD2_NAME")
      .setBus(vl2Bus1.getId())
      .setConnectableBus(vl2Bus1.getId())
      .setLoadType(LoadType::UNDEFINED)
      .setP0(60.0)
      .setQ0(70.0)
      .add();

  TwoWindingsTransformer& transformer = substation.newTwoWindingsTransformer()
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
      .setRatedS(3.0)
      .add();

  TwoWTransformerInterfaceIIDM tfoInterface(transformer);
  ASSERT_EQ(tfoInterface.getID(), "2WT_VL1_VL2");

  ASSERT_EQ(tfoInterface.getComponentVarIndex(std::string("p1")), TwoWTransformerInterfaceIIDM::VAR_P1);
  ASSERT_EQ(tfoInterface.getComponentVarIndex(std::string("p2")), TwoWTransformerInterfaceIIDM::VAR_P2);
  ASSERT_EQ(tfoInterface.getComponentVarIndex(std::string("q1")), TwoWTransformerInterfaceIIDM::VAR_Q1);
  ASSERT_EQ(tfoInterface.getComponentVarIndex(std::string("q2")), TwoWTransformerInterfaceIIDM::VAR_Q2);
  ASSERT_EQ(tfoInterface.getComponentVarIndex(std::string("state")), TwoWTransformerInterfaceIIDM::VAR_STATE);
  ASSERT_EQ(tfoInterface.getComponentVarIndex(std::string("tapIndex")), TwoWTransformerInterfaceIIDM::VAR_TAPINDEX);
  ASSERT_EQ(tfoInterface.getComponentVarIndex(std::string("invalid")), -1);

  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces1().size(), 0);
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces2().size(), 0);
  const boost::shared_ptr<CurrentLimitInterface> curLimItf1(new CurrentLimitInterfaceIIDM(1, 1));
  tfoInterface.addCurrentLimitInterface1(curLimItf1);
  const boost::shared_ptr<CurrentLimitInterface> curLimItf2(new CurrentLimitInterfaceIIDM(2, 2));
  tfoInterface.addCurrentLimitInterface2(curLimItf2);
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces1().size(), 1);
  ASSERT_EQ(tfoInterface.getCurrentLimitInterfaces2().size(), 1);

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

  const boost::shared_ptr<VoltageLevelInterface> voltageLevelItf1(new VoltageLevelInterfaceIIDM(vl1));
  tfoInterface.setVoltageLevelInterface1(voltageLevelItf1);
  const boost::shared_ptr<VoltageLevelInterface> voltageLevelItf2(new VoltageLevelInterfaceIIDM(vl2));
  tfoInterface.setVoltageLevelInterface2(voltageLevelItf2);

  ASSERT_TRUE(tfoInterface.getInitialConnected1());
  ASSERT_EQ(tfoInterface.getVNom1(), 380.0);
  ASSERT_TRUE(tfoInterface.isConnected());
  ASSERT_TRUE(tfoInterface.isPartiallyConnected());
  transformer.getTerminal1().disconnect();
  ASSERT_FALSE(tfoInterface.isConnected());
  ASSERT_TRUE(tfoInterface.isPartiallyConnected());
  ASSERT_TRUE(tfoInterface.getInitialConnected1());
  ASSERT_EQ(tfoInterface.getVNom1(), 380.0);

  ASSERT_TRUE(tfoInterface.getInitialConnected2());
  ASSERT_EQ(tfoInterface.getVNom2(), 225.0);
  transformer.getTerminal2().disconnect();
  ASSERT_FALSE(tfoInterface.isConnected());
  ASSERT_FALSE(tfoInterface.isPartiallyConnected());
  ASSERT_TRUE(tfoInterface.getInitialConnected2());
  ASSERT_EQ(tfoInterface.getVNom2(), 225.0);

  ASSERT_EQ(tfoInterface.getRatedU1(), 2.0);
  ASSERT_EQ(tfoInterface.getRatedU2(), 0.4);

  ASSERT_FALSE(tfoInterface.getRatioTapChanger());
  transformer.newRatioTapChanger()
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
    .setRegulationTerminal(stdcxx::ref<Terminal>(load1.getTerminal()))
    .setTargetV(25.0)
    .setTargetDeadband(1.0)
    .add();
  const boost::shared_ptr<RatioTapChangerInterface> ratioTapChangerItf( \
      new RatioTapChangerInterfaceIIDM(transformer.getRatioTapChanger(), tfoInterface.getID()));
  tfoInterface.setRatioTapChanger(ratioTapChangerItf);
  ASSERT_TRUE(tfoInterface.getRatioTapChanger());

  // TODO(TBA) tfoInterface.importStaticParameters();

  ASSERT_FALSE(tfoInterface.getPhaseTapChanger());
  transformer.newPhaseTapChanger()
    .setTapPosition(-2L)
    .setLowTapPosition(-3L)
    .beginStep()
    .setAlpha(99.0)
    .setB(100.0)
    .setG(101.0)
    .setR(102.0)
    .setRho(103.0)
    .setX(104.0)
    .endStep()
    .beginStep()
    .setAlpha(104.5)
    .setB(105.0)
    .setG(106.0)
    .setR(107.0)
    .setRho(108.0)
    .setX(109.0)
    .endStep()
    .beginStep()
    .setAlpha(200.5)
    .setB(200.0)
    .setG(201.0)
    .setR(202.0)
    .setRho(203.0)
    .setX(204.0)
    .endStep()
    .beginStep()
    .setAlpha(205.5)
    .setB(205.0)
    .setG(206.0)
    .setR(207.0)
    .setRho(208.0)
    .setX(209.0)
    .endStep()
    .setRegulationMode(PhaseTapChanger::RegulationMode::ACTIVE_POWER_CONTROL)
    .setRegulating(false)
    .setRegulationTerminal(stdcxx::ref<Terminal>(load2.getTerminal()))
    .setRegulationValue(250.0)
    .setTargetDeadband(2.0)
    .add();
  const boost::shared_ptr<PhaseTapChangerInterface> phaseTapChangerItf(new PhaseTapChangerInterfaceIIDM(transformer.getPhaseTapChanger()));
  tfoInterface.setPhaseTapChanger(phaseTapChangerItf);
  ASSERT_TRUE(tfoInterface.getPhaseTapChanger());

  ASSERT_EQ(tfoInterface.getR(), 3.0);
  ASSERT_EQ(tfoInterface.getX(), 33.0);
  ASSERT_EQ(tfoInterface.getG(), 1.0);
  ASSERT_EQ(tfoInterface.getB(), 0.2);

  ASSERT_EQ(tfoInterface.getP1(), 0.0);
  transformer.getTerminal1().setP(5.0);
  ASSERT_EQ(tfoInterface.getP1(), 5.0);

  ASSERT_EQ(tfoInterface.getQ1(), 0.0);
  transformer.getTerminal1().setQ(6.0);
  ASSERT_EQ(tfoInterface.getQ1(), 6.0);

  ASSERT_EQ(tfoInterface.getP2(), 0.0);
  transformer.getTerminal2().setP(7.0);
  ASSERT_EQ(tfoInterface.getP2(), 7.0);

  ASSERT_EQ(tfoInterface.getQ2(), 0.0);
  transformer.getTerminal2().setQ(8.0);
  ASSERT_EQ(tfoInterface.getQ2(), 8.0);

  // TODO(TBA) tfoInterface.importStaticParameters();
  // TODO(TBA) tfoInterface.exportStateVariablesUnitComponent();
}  // TEST(DataInterfaceTest, TwoWTransformer_1)

TEST(DataInterfaceTest, TwoWTransformer_NoInitialConnections) {
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

  TwoWindingsTransformer& transformer = substation.newTwoWindingsTransformer()
      .setId("2WT_VL1_VL2")
      .setVoltageLevel1(vl1.getId())
      .setConnectableBus1(vl1Bus1.getId())
      .setVoltageLevel2(vl2.getId())
      .setConnectableBus2(vl2Bus1.getId())
      .setR(3.0)
      .setX(33.0)
      .setG(1.0)
      .setB(0.2)
      .setRatedU1(2.0)
      .setRatedU2(0.4)
      .setRatedS(3.0)
      .add();

  TwoWTransformerInterfaceIIDM tfoInterface(transformer);
  const boost::shared_ptr<VoltageLevelInterface> vl1Itf(new VoltageLevelInterfaceIIDM(vl1));
  const boost::shared_ptr<VoltageLevelInterface> vl2Itf(new VoltageLevelInterfaceIIDM(vl2));
  tfoInterface.setVoltageLevelInterface1(vl1Itf);
  tfoInterface.setVoltageLevelInterface2(vl2Itf);

  ASSERT_FALSE(tfoInterface.getInitialConnected1());
  ASSERT_FALSE(tfoInterface.isConnected());
  ASSERT_FALSE(tfoInterface.isPartiallyConnected());
  transformer.getTerminal1().connect();
  ASSERT_FALSE(tfoInterface.isConnected());
  ASSERT_TRUE(tfoInterface.isPartiallyConnected());
  ASSERT_FALSE(tfoInterface.getInitialConnected1());

  ASSERT_FALSE(tfoInterface.getInitialConnected2());
  transformer.getTerminal2().connect();
  ASSERT_TRUE(tfoInterface.isConnected());
  ASSERT_TRUE(tfoInterface.isPartiallyConnected());
  ASSERT_FALSE(tfoInterface.getInitialConnected2());

  ASSERT_EQ(tfoInterface.getP1(), 0.0);
  transformer.getTerminal1().setP(5.0);
  ASSERT_EQ(tfoInterface.getP1(), 0.0);

  ASSERT_EQ(tfoInterface.getQ1(), 0.0);
  transformer.getTerminal1().setQ(6.0);
  ASSERT_EQ(tfoInterface.getQ1(), 0.0);

  ASSERT_EQ(tfoInterface.getP2(), 0.0);
  transformer.getTerminal2().setP(7.0);
  ASSERT_EQ(tfoInterface.getP2(), 0.0);

  ASSERT_EQ(tfoInterface.getQ2(), 0.0);
  transformer.getTerminal2().setQ(8.0);
  ASSERT_EQ(tfoInterface.getQ2(), 0.0);

  ASSERT_EQ(tfoInterface.getActiveSeason(), "UNDEFINED");
}  // TEST(DataInterfaceTest, TwoWTransformer_NoInitialConnections)
}  // namespace DYN
