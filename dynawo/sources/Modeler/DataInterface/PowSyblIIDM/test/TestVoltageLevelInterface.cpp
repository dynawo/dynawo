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

#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNBusInterfaceIIDM.h"
#include "DYNSwitchInterfaceIIDM.h"
#include "DYNLoadInterfaceIIDM.h"
#include "DYNGeneratorInterfaceIIDM.h"
#include "DYNLccConverterInterfaceIIDM.h"
#include "DYNVscConverterInterfaceIIDM.h"
#include "DYNDanglingLineInterfaceIIDM.h"
#include "DYNShuntCompensatorInterfaceIIDM.h"

#include "gtest_dynawo.h"

#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>
#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Switch.hpp>
#include <powsybl/iidm/DanglingLine.hpp>
#include <powsybl/iidm/DanglingLineAdder.hpp>
#include <powsybl/iidm/Load.hpp>
#include <powsybl/iidm/LoadAdder.hpp>
#include <powsybl/iidm/LccConverterStation.hpp>
#include <powsybl/iidm/LccConverterStationAdder.hpp>
#include <powsybl/iidm/VscConverterStation.hpp>
#include <powsybl/iidm/VscConverterStationAdder.hpp>
#include <powsybl/iidm/ShuntCompensator.hpp>
#include <powsybl/iidm/ShuntCompensatorAdder.hpp>
#include <powsybl/iidm/GeneratorAdder.hpp>

using powsybl::iidm::Network;
using powsybl::iidm::Substation;
using powsybl::iidm::TopologyKind;
using powsybl::iidm::VoltageLevel;
using powsybl::iidm::Bus;
using powsybl::iidm::Switch;
using powsybl::iidm::Load;
using powsybl::iidm::LoadType;
using powsybl::iidm::LccConverterStation;
using powsybl::iidm::VscConverterStation;
using powsybl::iidm::DanglingLine;
using powsybl::iidm::ShuntCompensator;


namespace DYN {

TEST(DataInterfaceTest, VoltageLevel) {
  Network network("test", "test");

  Substation& s = network.newSubstation()
                      .setId("S")
                      .add();

  VoltageLevel& vlIIDM1 = s.newVoltageLevel()
                          .setId("VL1")
                          .setNominalV(400.)
                          .setTopologyKind(TopologyKind::BUS_BREAKER)
                          .setHighVoltageLimit(420.)
                          .setLowVoltageLimit(380.)
                          .add();

  Bus& iidmBus = vlIIDM1.getBusBreakerView().newBus()
      .setId("Bus1")
      .add();

  auto swAdder = vlIIDM1.getBusBreakerView().newSwitch().setId("Sw").setName("SwName").setFictitious(false);

  powsybl::iidm::Bus& b1 = vlIIDM1.getBusBreakerView().newBus().setId("BUS1").add();
  powsybl::iidm::Bus& b2 = vlIIDM1.getBusBreakerView().newBus().setId("BUS2").add();
  swAdder.setBus1("BUS1");
  swAdder.setBus2("BUS2");

  powsybl::iidm::Switch& aSwitch = swAdder.add();

  powsybl::iidm::Bus& b4 = vlIIDM1.getBusBreakerView().newBus().setId("BUS4").add();
  VscConverterStation& vscIIDM1 = vlIIDM1.newVscConverterStation()
      .setId("VSC1")
      .setName("VSC1_NAME")
      .setBus(b4.getId())
      .setConnectableBus(b4.getId())
      .setLossFactor(3.0)
      .setVoltageRegulatorOn(true)
      .setVoltageSetpoint(4.0)
      .setReactivePowerSetpoint(5.0)
      .add();

  powsybl::iidm::Bus& b5 = vlIIDM1.getBusBreakerView().newBus().setId("BUS5").add();
  LccConverterStation& lccIIDM1 = vlIIDM1.newLccConverterStation()
      .setId("LCC1")
      .setName("VSC1_NAME")
      .setBus(b5.getId())
      .setConnectableBus(b5.getId())
      .setLossFactor(2.0)
      .setPowerFactor(-.2)
      .add();

  Load& loadIIDM1 = vlIIDM1.newLoad()
      .setId("LOAD1")
      .setBus("Bus1")
      .setConnectableBus("Bus1")
      .setName("LOAD1_NAME")
      .setLoadType(LoadType::UNDEFINED)
      .setP0(50.0)
      .setQ0(40.0)
      .add();

  powsybl::iidm::Bus& b6 = vlIIDM1.getBusBreakerView().newBus().setId("BUS6").add();
  DanglingLine& dl = vlIIDM1.newDanglingLine()
       .setId("DANGLING_LINE1")
       .setBus("BUS6")
       .setConnectableBus("BUS6")
       .setName("DANGLING_LINE1_NAME")
       .setB(1.0)
       .setG(2.0)
       .setP0(3.0)
       .setQ0(4.0)
       .setR(5.0)
       .setX(6.0)
       .setUcteXnodeCode("ucteXnodeCodeTest")
       .add();

  powsybl::iidm::Bus& b7 = vlIIDM1.getBusBreakerView().newBus().setId("BUS7").add();
  ShuntCompensator& shuntIIDM = vlIIDM1.newShuntCompensator()
      .setId("SHUNT1")
      .setName("SHUNT1_NAME")
      .setBus(b7.getId())
      .setConnectableBus(b7.getId())
      .newLinearModel()
      .setBPerSection(12.0)
      .setMaximumSectionCount(3UL)
      .add()
      .setSectionCount(2UL)
      .add();

  powsybl::iidm::Bus& b8 = vlIIDM1.getBusBreakerView().newBus().setId("BUS8").add();
  powsybl::iidm::Generator& genIIDM = vlIIDM1.newGenerator()
      .setId("GEN1")
      .setName("GEN1_NAME")
      .setBus(b8.getId())
      .setConnectableBus(b8.getId())
      .setEnergySource(powsybl::iidm::EnergySource::WIND)
      .setMaxP(50.0)
      .setMinP(3.0)
      .setRatedS(4.0)
      .setTargetP(45.0)
      .setTargetQ(5.0)
      .setTargetV(24.0)
      .setVoltageRegulatorOn(true)
      .add();

  VoltageLevel& vlIIDM2 = s.newVoltageLevel()
                          .setId("VL2")
                          .setNominalV(63.)
                          .setTopologyKind(TopologyKind::NODE_BREAKER)
                          .setHighVoltageLimit(420.)
                          .setLowVoltageLimit(380.)
                          .add();

  vlIIDM2.getNodeBreakerView().newBusbarSection()
        .setId("BBS1")
        .setName("BBS1_NAME")
        .setNode(3)
        .add();

  vlIIDM2.getNodeBreakerView().newDisconnector()
        .setId("SW5")
        .setName("SW5_NAME")
        .setRetained(false)
        .setOpen(false)
        .setNode1(8)
        .setNode2(3)
        .add();
  vlIIDM2.getNodeBreakerView().newDisconnector()
        .setId("SW9")
        .setName("SW9_NAME")
        .setRetained(false)
        .setOpen(false)
        .setNode1(10)
        .setNode2(3)
        .add();
  vlIIDM2.getNodeBreakerView().newDisconnector()
        .setId("SW14")
        .setName("SW14_NAME")
        .setRetained(false)
        .setOpen(false)
        .setNode1(4)
        .setNode2(3)
        .add();
  vlIIDM2.getNodeBreakerView().newBreaker()
        .setId("SW16")
        .setName("SW16_NAME")
        .setRetained(true)
        .setOpen(false)
        .setNode1(15)
        .setNode2(16)
        .add();
  vlIIDM2.getNodeBreakerView().newDisconnector()
        .setId("SW17")
        .setName("SW17_NAME")
        .setRetained(false)
        .setOpen(false)
        .setNode1(16)
        .setNode2(3)
        .add();
  vlIIDM2.newLoad()
      .setId("LOAD")
      .setFictitious(true)
      .setNode(15)
      .setP0(8.62757682800293)
      .setQ0(300.0)
      .add();

  VoltageLevelInterfaceIIDM vl(vlIIDM1);
  VoltageLevelInterfaceIIDM vl2(vlIIDM2);
  std::shared_ptr<BusInterface> bus1 = std::make_shared<BusInterfaceIIDM>(b1);
  std::shared_ptr<BusInterface> bus2 = std::make_shared<BusInterfaceIIDM>(b2);
  std::shared_ptr<BusInterface> bus3 = std::make_shared<BusInterfaceIIDM>(iidmBus);
  std::shared_ptr<BusInterface> bus4 = std::make_shared<BusInterfaceIIDM>(b4);
  std::shared_ptr<BusInterface> bus5 = std::make_shared<BusInterfaceIIDM>(b5);
  std::shared_ptr<BusInterface> bus6 = std::make_shared<BusInterfaceIIDM>(b6);
  std::shared_ptr<BusInterface> bus7 = std::make_shared<BusInterfaceIIDM>(b7);
  std::shared_ptr<BusInterface> bus8 = std::make_shared<BusInterfaceIIDM>(b8);
  std::shared_ptr<SwitchInterface> switch1 = std::make_shared<SwitchInterfaceIIDM>(aSwitch);
  std::shared_ptr<LoadInterface> load1 = std::make_shared<LoadInterfaceIIDM>(loadIIDM1);
  switch1->setBusInterface1(bus2);
  switch1->setBusInterface2(bus3);
  load1->setBusInterface(bus1);
  std::shared_ptr<VscConverterInterface> vsc1 = std::make_shared<VscConverterInterfaceIIDM>(vscIIDM1);
  vsc1->setBusInterface(bus4);
  std::shared_ptr<LccConverterInterfaceIIDM> lcc1 = std::make_shared<LccConverterInterfaceIIDM>(lccIIDM1);
  lcc1->setBusInterface(bus5);
  std::shared_ptr<DanglingLineInterface> danglingLine = std::make_shared<DanglingLineInterfaceIIDM>(dl);
  danglingLine->setBusInterface(bus6);
  std::shared_ptr<ShuntCompensatorInterface> shunt = std::make_shared<ShuntCompensatorInterfaceIIDM>(shuntIIDM);
  shunt->setBusInterface(bus7);
  std::shared_ptr<GeneratorInterface> gen = std::make_shared<GeneratorInterfaceIIDM>(genIIDM);
  gen->setBusInterface(bus8);

  ASSERT_EQ(vl.getID(), "VL1");
  ASSERT_EQ(vl.getVNom(), 400.);
  ASSERT_EQ(vl.getVoltageLevelTopologyKind(), VoltageLevelInterface::BUS_BREAKER);
  ASSERT_EQ(vl2.getVoltageLevelTopologyKind(), VoltageLevelInterface::NODE_BREAKER);
  ASSERT_TRUE(vl2.isNodeConnected(15));

  ASSERT_EQ(vl.getBuses().size(), 0);
  vl.addBus(bus1);
  ASSERT_EQ(vl.getBuses().size(), 1);

  ASSERT_EQ(vl.getSwitches().size(), 0);
  vl.addSwitch(switch1);
  ASSERT_EQ(vl.getSwitches().size(), 1);

  ASSERT_EQ(vl.getLoads().size(), 0);
  vl.addLoad(load1);
  ASSERT_EQ(vl.getLoads().size(), 1);

  ASSERT_EQ(vl.getVscConverters().size(), 0);
  vl.addVscConverter(vsc1);
  ASSERT_EQ(vl.getVscConverters().size(), 1);

  ASSERT_EQ(vl.getLccConverters().size(), 0);
  vl.addLccConverter(lcc1);
  ASSERT_EQ(vl.getLccConverters().size(), 1);

  ASSERT_EQ(vl.getDanglingLines().size(), 0);
  vl.addDanglingLine(danglingLine);
  ASSERT_EQ(vl.getDanglingLines().size(), 1);

  ASSERT_EQ(vl.getShuntCompensators().size(), 0);
  vl.addShuntCompensator(shunt);
  ASSERT_EQ(vl.getShuntCompensators().size(), 1);

  ASSERT_EQ(vl.getGenerators().size(), 0);
  vl.addGenerator(gen);
  ASSERT_EQ(vl.getGenerators().size(), 1);

  ASSERT_FALSE(bus1->hasConnection());
  ASSERT_FALSE(bus2->hasConnection());
  ASSERT_FALSE(bus3->hasConnection());
  ASSERT_FALSE(bus4->hasConnection());
  ASSERT_FALSE(bus5->hasConnection());
  ASSERT_FALSE(bus6->hasConnection());
  ASSERT_FALSE(bus7->hasConnection());
  ASSERT_FALSE(bus8->hasConnection());
  vl.mapConnections();
  ASSERT_FALSE(bus1->hasConnection());
  ASSERT_FALSE(bus2->hasConnection());
  ASSERT_FALSE(bus3->hasConnection());
  ASSERT_FALSE(bus4->hasConnection());
  ASSERT_FALSE(bus5->hasConnection());
  ASSERT_FALSE(bus6->hasConnection());
  ASSERT_FALSE(bus7->hasConnection());
  ASSERT_FALSE(bus8->hasConnection());
  switch1->hasDynamicModel(true);
  vl.mapConnections();
  ASSERT_FALSE(bus1->hasConnection());
  ASSERT_TRUE(bus2->hasConnection());
  ASSERT_TRUE(bus3->hasConnection());
  ASSERT_FALSE(bus4->hasConnection());
  ASSERT_FALSE(bus5->hasConnection());
  ASSERT_FALSE(bus6->hasConnection());
  ASSERT_FALSE(bus7->hasConnection());
  ASSERT_FALSE(bus8->hasConnection());
  load1->hasDynamicModel(true);
  vl.mapConnections();
  ASSERT_TRUE(bus1->hasConnection());
  ASSERT_TRUE(bus2->hasConnection());
  ASSERT_TRUE(bus3->hasConnection());
  ASSERT_FALSE(bus4->hasConnection());
  ASSERT_FALSE(bus5->hasConnection());
  ASSERT_FALSE(bus6->hasConnection());
  ASSERT_FALSE(bus7->hasConnection());
  ASSERT_FALSE(bus8->hasConnection());
  vsc1->hasDynamicModel(true);
  vl.mapConnections();
  ASSERT_TRUE(bus1->hasConnection());
  ASSERT_TRUE(bus2->hasConnection());
  ASSERT_TRUE(bus3->hasConnection());
  ASSERT_TRUE(bus4->hasConnection());
  ASSERT_FALSE(bus5->hasConnection());
  ASSERT_FALSE(bus6->hasConnection());
  ASSERT_FALSE(bus7->hasConnection());
  ASSERT_FALSE(bus8->hasConnection());
  lcc1->hasDynamicModel(true);
  vl.mapConnections();
  ASSERT_TRUE(bus1->hasConnection());
  ASSERT_TRUE(bus2->hasConnection());
  ASSERT_TRUE(bus3->hasConnection());
  ASSERT_TRUE(bus4->hasConnection());
  ASSERT_TRUE(bus5->hasConnection());
  ASSERT_FALSE(bus6->hasConnection());
  ASSERT_FALSE(bus7->hasConnection());
  ASSERT_FALSE(bus8->hasConnection());
  danglingLine->hasDynamicModel(true);
  vl.mapConnections();
  ASSERT_TRUE(bus1->hasConnection());
  ASSERT_TRUE(bus2->hasConnection());
  ASSERT_TRUE(bus3->hasConnection());
  ASSERT_TRUE(bus4->hasConnection());
  ASSERT_TRUE(bus5->hasConnection());
  ASSERT_TRUE(bus6->hasConnection());
  ASSERT_FALSE(bus7->hasConnection());
  ASSERT_FALSE(bus8->hasConnection());
  shunt->hasDynamicModel(true);
  vl.mapConnections();
  ASSERT_TRUE(bus1->hasConnection());
  ASSERT_TRUE(bus2->hasConnection());
  ASSERT_TRUE(bus3->hasConnection());
  ASSERT_TRUE(bus4->hasConnection());
  ASSERT_TRUE(bus5->hasConnection());
  ASSERT_TRUE(bus6->hasConnection());
  ASSERT_TRUE(bus7->hasConnection());
  ASSERT_FALSE(bus8->hasConnection());
  gen->hasDynamicModel(true);
  vl.mapConnections();
  ASSERT_TRUE(bus1->hasConnection());
  ASSERT_TRUE(bus2->hasConnection());
  ASSERT_TRUE(bus3->hasConnection());
  ASSERT_TRUE(bus4->hasConnection());
  ASSERT_TRUE(bus5->hasConnection());
  ASSERT_TRUE(bus6->hasConnection());
  ASSERT_TRUE(bus7->hasConnection());
  ASSERT_TRUE(bus8->hasConnection());
}  // TEST(DataInterfaceTest, VoltageLevel)
}  // namespace DYN
