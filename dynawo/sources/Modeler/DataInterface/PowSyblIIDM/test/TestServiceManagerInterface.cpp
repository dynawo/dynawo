//
// Copyright (c) 2020, RTE (http://www.rte-france.com)
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

#include "DYNBatteryInterfaceIIDM.h"
#include "DYNBusInterfaceIIDM.h"
#include "DYNCalculatedBusInterfaceIIDM.h"
#include "DYNDanglingLineInterfaceIIDM.h"
#include "DYNDataInterfaceIIDM.h"
#include "DYNGeneratorInterfaceIIDM.h"
#include "DYNLccConverterInterfaceIIDM.h"
#include "DYNLineInterfaceIIDM.h"
#include "DYNLoadInterfaceIIDM.h"
#include "DYNNetworkInterfaceIIDM.h"
#include "DYNServiceManagerInterfaceIIDM.h"
#include "DYNShuntCompensatorInterfaceIIDM.h"
#include "DYNSwitchInterfaceIIDM.h"
#include "DYNStaticVarCompensatorInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNVscConverterInterfaceIIDM.h"
#include "DYNTwoWTransformerInterface.h"
#include "make_unique.hpp"
#include "gtest_dynawo.h"

#include <powsybl/iidm/Battery.hpp>
#include <powsybl/iidm/BatteryAdder.hpp>
#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/BusbarSection.hpp>
#include <powsybl/iidm/BusbarSectionAdder.hpp>
#include <powsybl/iidm/Connectable.hpp>
#include <powsybl/iidm/DanglingLine.hpp>
#include <powsybl/iidm/DanglingLineAdder.hpp>
#include <powsybl/iidm/GeneratorAdder.hpp>
#include <powsybl/iidm/LccConverterStation.hpp>
#include <powsybl/iidm/LccConverterStationAdder.hpp>
#include <powsybl/iidm/Line.hpp>
#include <powsybl/iidm/LineAdder.hpp>
#include <powsybl/iidm/Load.hpp>
#include <powsybl/iidm/LoadAdder.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/ShuntCompensator.hpp>
#include <powsybl/iidm/ShuntCompensatorAdder.hpp>
#include <powsybl/iidm/StaticVarCompensator.hpp>
#include <powsybl/iidm/StaticVarCompensatorAdder.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/Switch.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>
#include <powsybl/iidm/VoltageLevelAdder.hpp>
#include <powsybl/iidm/VscConverterStation.hpp>
#include <powsybl/iidm/VscConverterStationAdder.hpp>
#include <powsybl/iidm/TwoWindingsTransformer.hpp>
#include <powsybl/iidm/TwoWindingsTransformerAdder.hpp>

using powsybl::iidm::Bus;
using powsybl::iidm::DanglingLine;
using powsybl::iidm::LccConverterStation;
using powsybl::iidm::Load;
using powsybl::iidm::LoadType;
using powsybl::iidm::Network;
using powsybl::iidm::ShuntCompensator;
using powsybl::iidm::Substation;
using powsybl::iidm::Switch;
using powsybl::iidm::TopologyKind;
using powsybl::iidm::VoltageLevel;
using powsybl::iidm::VscConverterStation;

namespace DYN {

TEST(DataInterfaceTest, ServiceManager) {
  DataInterfaceIIDM interface(boost::make_shared<Network>("test", "test"));
  auto& network = interface.getNetworkIIDM();

  Substation& s = network.newSubstation().setId("S").add();

  VoltageLevel& vlIIDM1 = s.newVoltageLevel()
                              .setId("VL1")
                              .setNominalV(400.)
                              .setTopologyKind(TopologyKind::BUS_BREAKER)
                              .setHighVoltageLimit(420.)
                              .setLowVoltageLimit(380.)
                              .add();

  VoltageLevel& vlIIDM2 = s.newVoltageLevel()
                              .setId("VL2")
                              .setNominalV(400.)
                              .setTopologyKind(TopologyKind::NODE_BREAKER)
                              .setHighVoltageLimit(420.)
                              .setLowVoltageLimit(380.)
                              .add();

  powsybl::iidm::Bus& b1 = vlIIDM1.getBusBreakerView().newBus().setId("BUS1").add();
  powsybl::iidm::Bus& b2 = vlIIDM1.getBusBreakerView().newBus().setId("BUS2").add();
  powsybl::iidm::Bus& b3 = vlIIDM1.getBusBreakerView().newBus().setId("BUS3").add();
  powsybl::iidm::Bus& b4 = vlIIDM1.getBusBreakerView().newBus().setId("BUS4").add();
  powsybl::iidm::Switch& aSwitch = vlIIDM1.getBusBreakerView().newSwitch().setId("Sw").setName("SwName").setFictitious(false)
      .setBus1("BUS1")
      .setBus2("BUS2")
      .add();
  powsybl::iidm::Switch& aSwitch2 = vlIIDM1.getBusBreakerView().newSwitch().setId("Sw2").setName("SwName2").setFictitious(false)
      .setBus1("BUS1")
      .setBus2("BUS3")
      .add();

  vlIIDM2.getNodeBreakerView().newBusbarSection().setId("BUS51").setNode(1).add();
  vlIIDM2.getNodeBreakerView().newBusbarSection().setId("BUS52").setNode(2).add();
  vlIIDM2.getNodeBreakerView().newBusbarSection().setId("BUS53").setNode(3).add();
  vlIIDM2.getNodeBreakerView().newBusbarSection().setId("BUS54").setNode(4).add();
  vlIIDM2.getNodeBreakerView().newInternalConnection()
      .setNode1(1)
      .setNode2(6)
      .add();
  vlIIDM2.getNodeBreakerView().newInternalConnection()
      .setNode1(2)
      .setNode2(7)
      .add();
  vlIIDM2.getNodeBreakerView().newInternalConnection()
      .setNode1(3)
      .setNode2(8)
      .add();
  vlIIDM2.getNodeBreakerView().newInternalConnection()
      .setNode1(1)
      .setNode2(9)
      .add();
  vlIIDM2.getNodeBreakerView().newBreaker().setId("Sw5152").setName("SwName5152").setFictitious(false)
      .setRetained(true)
      .setNode1(6)
      .setNode2(7)
      .add();
  vlIIDM2.getNodeBreakerView().newBreaker().setId("Sw5153").setName("SwName5153").setFictitious(false)
      .setRetained(true)
      .setNode1(9)
      .setNode2(8)
      .add();

  VoltageLevelInterfaceIIDM vl(vlIIDM1);
  VoltageLevelInterfaceIIDM vl2(vlIIDM2);
  std::shared_ptr<BusInterface> bus1 = std::make_shared<BusInterfaceIIDM>(b1);
  std::shared_ptr<BusInterface> bus2 = std::make_shared<BusInterfaceIIDM>(b2);
  std::shared_ptr<BusInterface> bus3 = std::make_shared<BusInterfaceIIDM>(b3);
  std::unique_ptr<BusInterface> bus4 = DYN::make_unique<BusInterfaceIIDM>(b4);
  const std::unique_ptr<SwitchInterface> switch1(DYN::make_unique<SwitchInterfaceIIDM>(aSwitch));
  const std::unique_ptr<SwitchInterface> switch2(DYN::make_unique<SwitchInterfaceIIDM>(aSwitch2));
  switch1->setBusInterface1(bus1);
  switch1->setBusInterface2(bus2);
  switch2->setBusInterface1(bus1);
  switch2->setBusInterface2(bus3);
  vl.addBus(bus1);
  vl.addBus(bus2);
  vl.addBus(bus3);
  vl.addBus(std::move(bus4));

  interface.initFromIIDM();

  auto serviceManager = interface.getServiceManager();

  ASSERT_THROW_DYNAWO(serviceManager->getBusesConnectedBySwitch("BUS0", vl.getID()), Error::MODELER, KeyError_t::UnknownBus);

  ASSERT_THROW_DYNAWO(serviceManager->getBusesConnectedBySwitch("BUS4", "notVL"), Error::MODELER, KeyError_t::UnknownVoltageLevel);

  ASSERT_THROW_DYNAWO(serviceManager->getBusesConnectedBySwitch("BUS0", vl2.getID()), Error::MODELER, KeyError_t::UnknownBus);

  ASSERT_THROW_DYNAWO(serviceManager->isBusConnected("BUS0", vl.getID()), Error::MODELER, KeyError_t::UnknownBus);

  ASSERT_THROW_DYNAWO(serviceManager->isBusConnected("BUS4", "notVL"), Error::MODELER, KeyError_t::UnknownVoltageLevel);

  ASSERT_THROW_DYNAWO(serviceManager->isBusConnected("BUS0", vl2.getID()), Error::MODELER, KeyError_t::UnknownBus);

  auto connected = serviceManager->getBusesConnectedBySwitch("BUS4", vl.getID());
  ASSERT_EQ(0, connected.size());

  connected = serviceManager->getBusesConnectedBySwitch("BUS1", vl.getID());
  ASSERT_EQ(2, connected.size());
  ASSERT_EQ(connected[0], "BUS2");
  ASSERT_EQ(connected[1], "BUS3");
  ASSERT_TRUE(serviceManager->isBusConnected("BUS1", vl.getID()));

  connected = serviceManager->getBusesConnectedBySwitch("BUS2", vl.getID());
  ASSERT_EQ(2, connected.size());
  ASSERT_EQ(connected[0], "BUS1");
  ASSERT_EQ(connected[1], "BUS3");
  ASSERT_TRUE(serviceManager->isBusConnected("BUS2", vl.getID()));

  switch1->open();

  connected = serviceManager->getBusesConnectedBySwitch("BUS1", vl.getID());
  ASSERT_EQ(1, connected.size());
  ASSERT_EQ(connected[0], "BUS3");
  ASSERT_TRUE(serviceManager->isBusConnected("BUS1", vl.getID()));

  connected = serviceManager->getBusesConnectedBySwitch("BUS2", vl.getID());
  ASSERT_EQ(0, connected.size());
  ASSERT_TRUE(serviceManager->isBusConnected("BUS2", vl.getID()));

  connected = serviceManager->getBusesConnectedBySwitch("BUS3", vl.getID());
  ASSERT_EQ(1, connected.size());
  ASSERT_EQ(connected[0], "BUS1");
  ASSERT_TRUE(serviceManager->isBusConnected("BUS3", vl.getID()));

  // Node/breaker voltage level with internal connections

  std::shared_ptr<BusInterface> bus54 = interface.getNetwork()->getVoltageLevels()[1]->getBuses()[3];
  ASSERT_EQ("BUS54", bus54->getBusBarSectionIdentifiers()[0]);
  connected = serviceManager->getBusesConnectedBySwitch(bus54->getID(), vl2.getID());
  ASSERT_EQ(0, connected.size());
  ASSERT_FALSE(serviceManager->isBusConnected(bus54->getID(), vl2.getID()));

  std::shared_ptr<BusInterface> bus51 = interface.getNetwork()->getVoltageLevels()[1]->getBuses()[0];
  std::shared_ptr<BusInterface> bus52 = interface.getNetwork()->getVoltageLevels()[1]->getBuses()[1];
  std::shared_ptr<BusInterface> bus53 = interface.getNetwork()->getVoltageLevels()[1]->getBuses()[2];
  ASSERT_EQ("BUS51", bus51->getBusBarSectionIdentifiers()[0]);
  ASSERT_EQ("BUS52", bus52->getBusBarSectionIdentifiers()[0]);
  ASSERT_EQ("BUS53", bus53->getBusBarSectionIdentifiers()[0]);
  connected = serviceManager->getBusesConnectedBySwitch(bus51->getID(), vl2.getID());
  ASSERT_EQ(2, connected.size());
  ASSERT_EQ(bus52->getID(), connected[0]);
  ASSERT_EQ(bus53->getID(), connected[1]);
  ASSERT_TRUE(serviceManager->isBusConnected(bus51->getID(), vl2.getID()));

  connected = serviceManager->getBusesConnectedBySwitch(bus52->getID(), vl2.getID());
  ASSERT_EQ(2, connected.size());
  ASSERT_EQ(bus51->getID(), connected[0]);
  ASSERT_EQ(bus53->getID(), connected[1]);
  ASSERT_TRUE(serviceManager->isBusConnected(bus52->getID(), vl2.getID()));

  std::shared_ptr<SwitchInterface> switch5152 = interface.getNetwork()->getVoltageLevels()[1]->getSwitches()[0];
  switch5152->open();

  connected = serviceManager->getBusesConnectedBySwitch(bus51->getID(), vl2.getID());
  ASSERT_EQ(1, connected.size());
  ASSERT_EQ(bus53->getID(), connected[0]);
  ASSERT_TRUE(serviceManager->isBusConnected(bus53->getID(), vl2.getID()));

  connected = serviceManager->getBusesConnectedBySwitch(bus52->getID(), vl2.getID());
  ASSERT_EQ(0, connected.size());
  ASSERT_FALSE(serviceManager->isBusConnected(bus52->getID(), vl2.getID()));

  connected = serviceManager->getBusesConnectedBySwitch(bus53->getID(), vl2.getID());
  ASSERT_EQ(1, connected.size());
  ASSERT_EQ(bus51->getID(), connected[0]);
  ASSERT_TRUE(serviceManager->isBusConnected(bus51->getID(), vl2.getID()));
}

TEST(DataInterfaceTest, ServiceManagerRegulatedBus) {
  DataInterfaceIIDM interface(boost::make_shared<Network>("test", "test"));
  auto& network = interface.getNetworkIIDM();

  Substation& s = network.newSubstation().setId("S").add();

  VoltageLevel& vlIIDM1 = s.newVoltageLevel()
                              .setId("VL1")
                              .setNominalV(400.)
                              .setTopologyKind(TopologyKind::BUS_BREAKER)
                              .setHighVoltageLimit(420.)
                              .setLowVoltageLimit(380.)
                              .add();
  VoltageLevel& vlIIDM2 = s.newVoltageLevel()
                              .setId("VL2")
                              .setNominalV(400.)
                              .setTopologyKind(TopologyKind::BUS_BREAKER)
                              .setHighVoltageLimit(420.)
                              .setLowVoltageLimit(380.)
                              .add();

  auto swAdder = vlIIDM1.getBusBreakerView().newSwitch().setId("Sw").setName("SwName").setFictitious(false);
  swAdder.setBus1("BUS1");
  swAdder.setBus2("BUS2");
  powsybl::iidm::Bus& b1 = vlIIDM1.getBusBreakerView().newBus().setId("BUS1").add();
  powsybl::iidm::Bus& b2 = vlIIDM1.getBusBreakerView().newBus().setId("BUS2").add();
  powsybl::iidm::Bus& b3 = vlIIDM1.getBusBreakerView().newBus().setId("BUS3").add();
  powsybl::iidm::Bus& b4 = vlIIDM1.getBusBreakerView().newBus().setId("BUS4").add();
  powsybl::iidm::Bus& b5 = vlIIDM2.getBusBreakerView().newBus().setId("BUS5").add();

  powsybl::iidm::Line& line_ = network.newLine()
                                    .setId("LINE")
                                    .setVoltageLevel1(vlIIDM1.getId())
                                    .setBus1(b1.getId())
                                    .setConnectableBus1(b1.getId())
                                    .setVoltageLevel2(vlIIDM2.getId())
                                    .setBus2(b5.getId())
                                    .setConnectableBus2(b5.getId())
                                    .setR(3.0)
                                    .setX(33.33)
                                    .setG1(1.0)
                                    .setB1(0.2)
                                    .setG2(2.0)
                                    .setB2(0.4)
                                    .add();

  powsybl::iidm::TwoWindingsTransformer& TwoWTransf_ = s.newTwoWindingsTransformer()
                                          .setId("MyTransformer2Winding")
                                          .setVoltageLevel1(vlIIDM1.getId())
                                          .setBus1(b1.getId())
                                          .setConnectableBus1(b1.getId())
                                          .setVoltageLevel2(vlIIDM2.getId())
                                          .setBus2(b5.getId())
                                          .setConnectableBus2(b5.getId())
                                          .setR(3.0)
                                          .setX(33.0)
                                          .setG(1.0)
                                          .setB(0.2)
                                          .setRatedU1(400)
                                          .setRatedU2(400)
                                          .setRatedS(3.0)
                                          .add();

  powsybl::iidm::DanglingLine& dl = vlIIDM2.newDanglingLine()
         .setId("MyDanglingLine")
         .setBus(b5.getId())
         .setConnectableBus(b5.getId())
         .setName("MyDanglingLine_NAME")
         .setB(3.0)
         .setG(3.0)
         .setP0(105.0)
         .setQ0(90.0)
         .setR(3.0)
         .setX(3.0)
         .setUcteXnodeCode("ucteXnodeCodeTest")
         .add();

  powsybl::iidm::LccConverterStation& lcc = vlIIDM1.newLccConverterStation()
        .setId("MyLccConverter")
        .setName("MyLccConverter_NAME")
        .setBus(b1.getId())
        .setConnectableBus(b1.getId())
        .setLossFactor(3.0)
        .setPowerFactor(1.)
        .add();

  powsybl::iidm::VscConverterStation& vsc = vlIIDM1.newVscConverterStation()
        .setId("MyVscConverter")
        .setName("MyVscConverter_NAME")
        .setBus(b1.getId())
        .setConnectableBus(b1.getId())
        .setLossFactor(3.0)
        .setVoltageRegulatorOn(true)
        .setVoltageSetpoint(1.2)
        .setReactivePowerSetpoint(-1.5)
        .add();

  powsybl::iidm::Switch& aSwitch = swAdder.add();
  powsybl::iidm::Generator& gen = vlIIDM1.newGenerator()
                      .setId("GEN1")
                      .setName("GEN1_NAME")
                      .setConnectableBus(b1.getId())
                      .setMaxP(50.0)
                      .setMinP(3.0)
                      .setTargetP(45.0)
                      .setReactivePowerSetpoint(10.0)
                      .setTargetV(400.0)
                      .setVoltageRegulatorOn(true)
                      .add();

  powsybl::iidm::Generator& gen2 = vlIIDM1.newGenerator()
                      .setId("GEN2")
                      .setName("GEN2_NAME")
                      .setConnectableBus(b1.getId())
                      .setMaxP(50.0)
                      .setMinP(3.0)
                      .setTargetP(45.0)
                      .setReactivePowerSetpoint(10.0)
                      .setTargetV(400.0)
                      .setVoltageRegulatorOn(true)
                      .setRegulatingTerminal(stdcxx::Reference<powsybl::iidm::Terminal>(line_.getTerminal1()))
                      .add();

  powsybl::iidm::Generator& gen3 = vlIIDM1.newGenerator()
                      .setId("GEN3")
                      .setName("GEN3_NAME")
                      .setConnectableBus(b1.getId())
                      .setMaxP(50.0)
                      .setMinP(3.0)
                      .setTargetP(45.0)
                      .setReactivePowerSetpoint(10.0)
                      .setTargetV(400.0)
                      .setVoltageRegulatorOn(true)
                      .setRegulatingTerminal(stdcxx::Reference<powsybl::iidm::Terminal>(TwoWTransf_.getTerminal1()))
                      .add();

  powsybl::iidm::Generator& gen4 = vlIIDM1.newGenerator()
                      .setId("GEN4")
                      .setName("GEN4_NAME")
                      .setConnectableBus(b1.getId())
                      .setMaxP(50.0)
                      .setMinP(3.0)
                      .setTargetP(45.0)
                      .setReactivePowerSetpoint(10.0)
                      .setTargetV(400.0)
                      .setVoltageRegulatorOn(true)
                      .setRegulatingTerminal(stdcxx::Reference<powsybl::iidm::Terminal>(TwoWTransf_.getTerminal2()))
                      .add();

  powsybl::iidm::Generator& gen5 = vlIIDM1.newGenerator()
                      .setId("GEN5")
                      .setName("GEN5_NAME")
                      .setConnectableBus(b1.getId())
                      .setMaxP(50.0)
                      .setMinP(3.0)
                      .setTargetP(45.0)
                      .setReactivePowerSetpoint(10.0)
                      .setTargetV(400.0)
                      .setVoltageRegulatorOn(true)
                      .setRegulatingTerminal(stdcxx::Reference<powsybl::iidm::Terminal>(dl.getTerminal()))
                      .add();

  powsybl::iidm::Generator& gen6 = vlIIDM1.newGenerator()
                      .setId("GEN6")
                      .setName("GEN6_NAME")
                      .setConnectableBus(b1.getId())
                      .setMaxP(50.0)
                      .setMinP(3.0)
                      .setTargetP(45.0)
                      .setReactivePowerSetpoint(10.0)
                      .setTargetV(400.0)
                      .setVoltageRegulatorOn(true)
                      .setRegulatingTerminal(stdcxx::Reference<powsybl::iidm::Terminal>(lcc.getTerminal()))
                      .add();

  powsybl::iidm::Generator& gen7 = vlIIDM1.newGenerator()
                      .setId("GEN7")
                      .setName("GEN7_NAME")
                      .setConnectableBus(b1.getId())
                      .setMaxP(50.0)
                      .setMinP(3.0)
                      .setTargetP(45.0)
                      .setReactivePowerSetpoint(10.0)
                      .setTargetV(400.0)
                      .setVoltageRegulatorOn(true)
                      .setRegulatingTerminal(stdcxx::Reference<powsybl::iidm::Terminal>(vsc.getTerminal()))
                      .add();

  powsybl::iidm::ShuntCompensator& shunt = vlIIDM1.newShuntCompensator()
                                .setId("SHUNT")
                                .setName("SHUNT_NAME")
                                .setBus(b3.getId())
                                .setConnectableBus(b3.getId())
                                .newLinearModel()
                                .setBPerSection(12.0)
                                .setMaximumSectionCount(3UL)
                                .add()
                                .setSectionCount(2UL)
                                .add();

  powsybl::iidm::ShuntCompensator& shunt2 = vlIIDM1.newShuntCompensator()
                                .setId("SHUNT2")
                                .setName("SHUNT2_NAME")
                                .setBus(b1.getId())
                                .setConnectableBus(b1.getId())
                                .newLinearModel()
                                .setBPerSection(12.0)
                                .setMaximumSectionCount(3UL)
                                .add()
                                .setSectionCount(2UL)
                                .setRegulatingTerminal(stdcxx::Reference<powsybl::iidm::Terminal>(line_.getTerminal2()))
                                .add();
  powsybl::iidm::StaticVarCompensator& svc = vlIIDM1.newStaticVarCompensator()
                              .setId("SVC1")
                              .setName("SVC1_NAME")
                              .setBus(b1.getId())
                              .setConnectableBus(b1.getId())
                              .setBmin(-0.01)
                              .setBmax(0.02)
                              .setVoltageSetpoint(380.0)
                              .setReactivePowerSetpoint(90.0)
                              .setRegulationMode(powsybl::iidm::StaticVarCompensator::RegulationMode::VOLTAGE)
                              .add();
  powsybl::iidm::Load& load = vlIIDM1.newLoad()
                              .setId("LOAD")
                              .setBus(b1.getId())
                              .setConnectableBus(b1.getId())
                              .setName("LOAD1_NAME")
                              .setLoadType(LoadType::UNDEFINED)
                              .setP0(5000.0)
                              .setQ0(4000.0)
                              .add();
  powsybl::iidm::StaticVarCompensator& svc2 = vlIIDM1.newStaticVarCompensator()
                              .setId("SVC2")
                              .setName("SVC2_NAME")
                              .setBus(b1.getId())
                              .setConnectableBus(b1.getId())
                              .setBmin(-0.01)
                              .setBmax(0.02)
                              .setVoltageSetpoint(380.0)
                              .setReactivePowerSetpoint(90.0)
                              .setRegulationMode(powsybl::iidm::StaticVarCompensator::RegulationMode::VOLTAGE)
                              .setRegulatingTerminal(stdcxx::Reference<powsybl::iidm::Terminal>(load.getTerminal()))
                              .add();

  powsybl::iidm::Battery& battery = vlIIDM1.newBattery()
                      .setId("BAT1")
                      .setName("BAT1_NAME")
                      .setBus(b1.getId())
                      .setConnectableBus(b1.getId())
                      .setMaxP(50.0)
                      .setMinP(3.0)
                      .setP0(5.0)
                      .setQ0(5.0)
                      .add();

  VoltageLevelInterfaceIIDM vl(vlIIDM1);
  VoltageLevelInterfaceIIDM vl2(vlIIDM2);
  GeneratorInterfaceIIDM genItf(gen);
  GeneratorInterfaceIIDM genItf2(gen2);
  GeneratorInterfaceIIDM genItf3(gen3);
  GeneratorInterfaceIIDM genItf4(gen4);
  GeneratorInterfaceIIDM genItf5(gen5);
  GeneratorInterfaceIIDM genItf6(gen6);
  GeneratorInterfaceIIDM genItf7(gen7);
  LineInterfaceIIDM lineItf(line_);
  ShuntCompensatorInterfaceIIDM shuntItf(shunt);
  ShuntCompensatorInterfaceIIDM shuntItf2(shunt2);
  StaticVarCompensatorInterfaceIIDM svcItf(svc);
  StaticVarCompensatorInterfaceIIDM svcItf2(svc2);
  LoadInterfaceIIDM loadItf(load);
  VscConverterInterfaceIIDM vscItf(vsc);
  BatteryInterfaceIIDM batItf(battery);

  std::shared_ptr<BusInterface> bus1 = std::make_shared<BusInterfaceIIDM>(b1);
  std::shared_ptr<BusInterface> bus2 = std::make_shared<BusInterfaceIIDM>(b2);
  std::shared_ptr<BusInterface> bus3 = std::make_shared<BusInterfaceIIDM>(b3);
  std::unique_ptr<BusInterface> bus4 = DYN::make_unique<BusInterfaceIIDM>(b4);
  std::shared_ptr<BusInterface> bus5 = std::make_shared<BusInterfaceIIDM>(b5);
  const std::unique_ptr<SwitchInterface> switch1(DYN::make_unique<SwitchInterfaceIIDM>(aSwitch));

  switch1->setBusInterface1(bus1);
  switch1->setBusInterface2(bus2);


  vl.addBus(bus1);
  vl.addBus(bus2);
  vl.addBus(bus3);
  vl.addBus(std::move(bus4));

  vl2.addBus(bus5);

  genItf.setBusInterface(bus1);
  genItf2.setBusInterface(bus1);
  genItf3.setBusInterface(bus1);
  genItf4.setBusInterface(bus1);
  genItf5.setBusInterface(bus1);
  genItf6.setBusInterface(bus1);
  genItf7.setBusInterface(bus1);
  lineItf.setBusInterface1(bus1);
  lineItf.setBusInterface2(bus5);
  shuntItf.setBusInterface(bus1);
  svcItf.setBusInterface(bus1);
  svcItf2.setBusInterface(bus2);
  loadItf.setBusInterface(bus1);
  vscItf.setBusInterface(bus1);
  batItf.setBusInterface(bus1);

  interface.initFromIIDM();

  auto serviceManager = interface.getServiceManager();

  ASSERT_EQ(serviceManager->getRegulatedBus(genItf.getID())->getID(), bus1->getID());
  ASSERT_EQ(serviceManager->getRegulatedBus(genItf2.getID())->getID(), bus1->getID());
  ASSERT_EQ(serviceManager->getRegulatedBus(genItf3.getID())->getID(), bus1->getID());
  ASSERT_EQ(serviceManager->getRegulatedBus(genItf4.getID())->getID(), bus5->getID());
  ASSERT_EQ(serviceManager->getRegulatedBus(genItf5.getID())->getID(), bus5->getID());
  ASSERT_EQ(serviceManager->getRegulatedBus(genItf6.getID())->getID(), bus1->getID());
  ASSERT_EQ(serviceManager->getRegulatedBus(genItf7.getID())->getID(), bus1->getID());
  ASSERT_EQ(serviceManager->getRegulatedBus(shuntItf2.getID())->getID(), bus5->getID());
  ASSERT_EQ(serviceManager->getRegulatedBus(shuntItf.getID())->getID(), bus3->getID());
  ASSERT_EQ(serviceManager->getRegulatedBus(svcItf.getID())->getID(), bus1->getID());
  ASSERT_EQ(serviceManager->getRegulatedBus(svcItf2.getID())->getID(), bus1->getID());
  ASSERT_EQ(serviceManager->getRegulatedBus(vscItf.getID())->getID(), bus1->getID());
  ASSERT_FALSE(serviceManager->getRegulatedBus(lineItf.getID()));
  ASSERT_FALSE(serviceManager->getRegulatedBus(batItf.getID()));
}

}  // namespace DYN
