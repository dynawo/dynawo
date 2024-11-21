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

#include "DYNFictVoltageLevelInterfaceIIDM.h"
#include "DYNVoltageLevelInterface.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNBusInterfaceIIDM.h"
#include "DYNSwitchInterfaceIIDM.h"
#include "DYNLoadInterfaceIIDM.h"
#include "DYNGeneratorInterfaceIIDM.h"
#include "DYNLccConverterInterfaceIIDM.h"
#include "DYNVscConverterInterfaceIIDM.h"
#include "DYNDanglingLineInterfaceIIDM.h"
#include "DYNShuntCompensatorInterfaceIIDM.h"
#include "DYNStaticVarCompensatorInterfaceIIDM.h"

#include "make_unique.hpp"
#include "gtest_dynawo.h"
#include "DYNCommon.h"

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
#include <powsybl/iidm/StaticVarCompensator.hpp>
#include <powsybl/iidm/StaticVarCompensatorAdder.hpp>

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

TEST(DataInterfaceTest, testFictVoltageLevelInterface) {
  std::string Id = "fictBus_Id";
  double VNom = 400.;
  std::string country = "FRANCE";
  const std::unique_ptr<VoltageLevelInterface> FictVl = DYN::make_unique<FictVoltageLevelInterfaceIIDM>(Id, VNom, country);
  ASSERT_EQ(FictVl->getID(), Id);
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictVl->getVNom(), VNom);
  ASSERT_EQ(FictVl->getVoltageLevelTopologyKind(), VoltageLevelInterface::BUS_BREAKER);
  FictVl->connectNode(0);
  FictVl->disconnectNode(0);
  FictVl->isNodeConnected(0);
  ASSERT_EQ(FictVl->getBuses().size(), 0);
  ASSERT_FALSE(FictVl->isNodeBreakerTopology());


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

  powsybl::iidm::Bus& b9 = vlIIDM1.getBusBreakerView().newBus().setId("BUS9").add();
  powsybl::iidm::StaticVarCompensator& svcIIDM = vlIIDM1.newStaticVarCompensator().setId("SVC1").setBmin(0).setBmax(0)
    .setRegulationMode(powsybl::iidm::StaticVarCompensator::RegulationMode::OFF)
    .setConnectableBus(b9.getId()).add();
  std::unique_ptr<StaticVarCompensatorInterface> svc = DYN::make_unique<StaticVarCompensatorInterfaceIIDM>(svcIIDM);

  VoltageLevel& vlIIDM2 = s.newVoltageLevel()
                          .setId("VL2")
                          .setNominalV(63.)
                          .setTopologyKind(TopologyKind::NODE_BREAKER)
                          .setHighVoltageLimit(420.)
                          .setLowVoltageLimit(380.)
                          .add();
  VoltageLevelInterfaceIIDM vl(vlIIDM1);
  VoltageLevelInterfaceIIDM vl2(vlIIDM2);
  std::shared_ptr<BusInterface> bus1 = std::make_shared<BusInterfaceIIDM>(b1);
  std::unique_ptr<BusInterface> bus2 = DYN::make_unique<BusInterfaceIIDM>(b2);
  std::unique_ptr<BusInterface> bus3 = DYN::make_unique<BusInterfaceIIDM>(iidmBus);
  std::unique_ptr<BusInterface> bus4 = DYN::make_unique<BusInterfaceIIDM>(b4);
  std::unique_ptr<BusInterface> bus5 = DYN::make_unique<BusInterfaceIIDM>(b5);
  std::unique_ptr<BusInterface> bus6 = DYN::make_unique<BusInterfaceIIDM>(b6);
  std::unique_ptr<BusInterface> bus7 = DYN::make_unique<BusInterfaceIIDM>(b7);
  std::unique_ptr<BusInterface> bus8 = DYN::make_unique<BusInterfaceIIDM>(b8);
  std::shared_ptr<SwitchInterface> switch1 = std::make_shared<SwitchInterfaceIIDM>(aSwitch);
  std::unique_ptr<LoadInterface> load1 = DYN::make_unique<LoadInterfaceIIDM>(loadIIDM1);
  switch1->setBusInterface1(std::move(bus2));
  switch1->setBusInterface2(std::move(bus3));
  load1->setBusInterface(bus1);
  std::unique_ptr<VscConverterInterface> vsc1 = DYN::make_unique<VscConverterInterfaceIIDM>(vscIIDM1);
  vsc1->setBusInterface(std::move(bus4));
  std::unique_ptr<LccConverterInterfaceIIDM> lcc1 = DYN::make_unique<LccConverterInterfaceIIDM>(lccIIDM1);
  lcc1->setBusInterface(std::move(bus5));
  std::unique_ptr<DanglingLineInterface> danglingLine = DYN::make_unique<DanglingLineInterfaceIIDM>(dl);
  danglingLine->setBusInterface(std::move(bus6));
  std::unique_ptr<ShuntCompensatorInterface> shunt = DYN::make_unique<ShuntCompensatorInterfaceIIDM>(shuntIIDM);
  shunt->setBusInterface(std::move(bus7));
  std::unique_ptr<GeneratorInterface> gen = DYN::make_unique<GeneratorInterfaceIIDM>(genIIDM);
  gen->setBusInterface(std::move(bus8));

  FictVl->addSwitch(switch1);
  FictVl->addBus(bus1);
  FictVl->addGenerator(std::move(gen));
  FictVl->addLoad(std::move(load1));
  FictVl->addShuntCompensator(std::move(shunt));
  FictVl->addDanglingLine(std::move(danglingLine));
  FictVl->addVscConverter(std::move(vsc1));
  FictVl->addLccConverter(std::move(lcc1));
  FictVl->addStaticVarCompensator(std::move(svc));
}  // TEST(DataInterfaceTest, testFictVoltageLevelInterface)
}  // namespace DYN
