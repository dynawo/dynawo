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

#include "DYNGeneratorInterfaceIIDM.h"

#include "DYNBusInterfaceIIDM.h"
#include "DYNCommon.h"
#include "DYNVoltageLevelInterfaceIIDM.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Generator.hpp>
#include <powsybl/iidm/GeneratorAdder.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/extensions/iidm/ActivePowerControl.hpp>
#include <powsybl/iidm/extensions/iidm/ActivePowerControlAdder.hpp>
#include <powsybl/iidm/extensions/iidm/CoordinatedReactiveControl.hpp>
#include <powsybl/iidm/extensions/iidm/CoordinatedReactiveControlAdder.hpp>
#include <powsybl/iidm/ExtensionProviders.hpp>

#include "gtest_dynawo.h"

namespace powsybl {
namespace iidm {

static Network
createGeneratorNetwork() {
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
                                .setNominalV(382.0)
                                .setLowVoltageLimit(340.0)
                                .setHighVoltageLimit(420.0)
                                .add();

  vl1.getBusBreakerView().newBus().setId("VL1_BUS1").add();

  return network;
}
}  // namespace iidm
}  // namespace powsybl

namespace DYN {
using powsybl::iidm::createGeneratorNetwork;

TEST(DataInterfaceTest, Generator_1) {
  powsybl::iidm::Network network = createGeneratorNetwork();
  powsybl::iidm::VoltageLevel& vl1 = network.getVoltageLevel("VL1");
  powsybl::iidm::Bus& bus1 = vl1.getBusBreakerView().getBus("VL1_BUS1");
  powsybl::iidm::Generator& gen =    vl1.newGenerator()
     .setId("GEN1")
     .setName("GEN1_NAME")
     .setBus(bus1.getId())
     .setConnectableBus(bus1.getId())
     .setEnergySource(powsybl::iidm::EnergySource::WIND)
     .setMaxP(50.0)
     .setMinP(3.0)
     .setRatedS(4.0)
     .setTargetP(45.0)
     .setTargetQ(5.0)
     .setTargetV(24.0)
     .setVoltageRegulatorOn(true)
     .add();

  GeneratorInterfaceIIDM genItf(gen);
  const boost::shared_ptr<VoltageLevelInterface> vlItf(new VoltageLevelInterfaceIIDM(vl1));
  genItf.setVoltageLevelInterface(vlItf);
  ASSERT_EQ(genItf.getID(), "GEN1");

  ASSERT_FALSE(genItf.hasInitialConditions());

  ASSERT_EQ(genItf.getComponentVarIndex(std::string("p")), GeneratorInterfaceIIDM::VAR_P);
  ASSERT_EQ(genItf.getComponentVarIndex(std::string("q")), GeneratorInterfaceIIDM::VAR_Q);
  ASSERT_EQ(genItf.getComponentVarIndex(std::string("state")), GeneratorInterfaceIIDM::VAR_STATE);
  ASSERT_EQ(genItf.getComponentVarIndex(std::string("invalid")), -1);

  genItf.importStaticParameters();

  ASSERT_EQ(genItf.getBusInterface().get(), nullptr);
  const boost::shared_ptr<BusInterface> busItf(new BusInterfaceIIDM(bus1));
  genItf.setBusInterface(busItf);
  ASSERT_EQ(genItf.getBusInterface().get()->getID(), "VL1_BUS1");

  genItf.importStaticParameters();

  const boost::shared_ptr<VoltageLevelInterface> voltageLevelItf(new VoltageLevelInterfaceIIDM(vl1));
  genItf.setVoltageLevelInterface(voltageLevelItf);

  ASSERT_TRUE(genItf.getInitialConnected());

  ASSERT_EQ(genItf.getP(), 0.0);
  gen.getTerminal().setP(10.0);
  ASSERT_EQ(genItf.getP(), 10.0);

  ASSERT_EQ(genItf.getQ(), 0.0);
  gen.getTerminal().setQ(11.0);
  ASSERT_EQ(genItf.getQ(), 11.0);

  ASSERT_EQ(genItf.getPMin(), 3.0);
  ASSERT_EQ(genItf.getPMax(), 50.0);

  ASSERT_EQ(genItf.getTargetP(), -45.0);
  ASSERT_EQ(genItf.getTargetQ(), -5.0);
  ASSERT_EQ(genItf.getTargetV(), 24.0);
  ASSERT_EQ(genItf.getEnergySource(), GeneratorInterface::SOURCE_WIND);

  ASSERT_TRUE(genItf.isVoltageRegulationOn());

  ASSERT_EQ(genItf.getReactiveCurvesPoints().size(), 0);

  ASSERT_TRUE(genItf.getCountry().empty());
  genItf.setCountry("FR");
  ASSERT_EQ(genItf.getCountry(), "FR");
  genItf.setCountry("");
  ASSERT_TRUE(genItf.getCountry().empty());

  ASSERT_EQ(genItf.getQMin(), -std::numeric_limits<double>::max());
  ASSERT_EQ(genItf.getQMax(), std::numeric_limits<double>::max());
  ASSERT_EQ(genItf.getQNom(), std::numeric_limits<double>::max());
  gen.newMinMaxReactiveLimits().setMinQ(1.0).setMaxQ(2.0).add();
  ASSERT_EQ(genItf.getQMin(), 1.0);
  ASSERT_EQ(genItf.getQMax(), 2.0);
  ASSERT_EQ(genItf.getQNom(), 2.0);
  gen.newReactiveCapabilityCurve()
     .beginPoint()
       .setP(1)
       .setMinQ(15)
       .setMaxQ(25)
     .endPoint()
     .beginPoint()
       .setP(2)
       .setMinQ(10)
       .setMaxQ(20)
     .endPoint()
     .add();
  ASSERT_EQ(genItf.getQMin(), 15.0);
  ASSERT_EQ(genItf.getQMax(), 25.0);
  ASSERT_EQ(genItf.getQNom(), 25.0);
  gen.newReactiveCapabilityCurve()
     .beginPoint()
       .setP(-30)
       .setMinQ(15)
       .setMaxQ(25)
     .endPoint()
     .beginPoint()
       .setP(-20)
       .setMinQ(10)
       .setMaxQ(20)
     .endPoint()
     .add();
  ASSERT_EQ(genItf.getQMin(), 10.0);
  ASSERT_EQ(genItf.getQMax(), 20.0);
  ASSERT_EQ(genItf.getQNom(), 25.0);
  gen.newReactiveCapabilityCurve()
     .beginPoint()
       .setP(-20)
       .setMinQ(15)
       .setMaxQ(25)
     .endPoint()
     .beginPoint()
       .setP(0)
       .setMinQ(10)
       .setMaxQ(20)
     .endPoint()
     .add();
  ASSERT_EQ(genItf.getQMin(), 12.5);
  ASSERT_EQ(genItf.getQMax(), 22.5);
  ASSERT_EQ(genItf.getQNom(), 25.0);
  ASSERT_EQ(genItf.getReactiveCurvesPoints().size(), 2);
  gen.newReactiveCapabilityCurve()
     .beginPoint()
       .setP(-10)
       .setMinQ(-30)
       .setMaxQ(25)
     .endPoint()
     .beginPoint()
       .setP(0)
       .setMinQ(10)
       .setMaxQ(20)
     .endPoint()
     .add();
  ASSERT_EQ(genItf.getQNom(), 30.0);

  ASSERT_TRUE(genItf.isConnected());
  ASSERT_TRUE(genItf.isPartiallyConnected());
  // TODO(TBA) genItf.exportStateVariablesUnitComponent();
  gen.getTerminal().disconnect();
  // TODO(TBA) genItf.exportStateVariablesUnitComponent();
  ASSERT_FALSE(genItf.isPartiallyConnected());
  ASSERT_FALSE(genItf.isConnected());
  ASSERT_TRUE(genItf.getInitialConnected());
  ASSERT_FALSE(genItf.hasActivePowerControl());
  ASSERT_FALSE(genItf.isParticipating());
  ASSERT_DOUBLE_EQUALS_DYNAWO(genItf.getActivePowerControlDroop(), 0.);
  ASSERT_FALSE(genItf.hasCoordinatedReactiveControl());
  ASSERT_DOUBLE_EQUALS_DYNAWO(genItf.getCoordinatedReactiveControlPercentage(), 0.);

  gen.newExtension<powsybl::iidm::extensions::iidm::ActivePowerControlAdder>().withDroop(4.0).withParticipate(true).add();
  gen.newExtension<powsybl::iidm::extensions::iidm::CoordinatedReactiveControlAdder>().withQPercent(50).add();
  GeneratorInterfaceIIDM genItfWithExtensions(gen);
  ASSERT_TRUE(genItfWithExtensions.hasActivePowerControl());
  ASSERT_TRUE(genItfWithExtensions.isParticipating());
  ASSERT_DOUBLE_EQUALS_DYNAWO(genItfWithExtensions.getActivePowerControlDroop(), 4.);
  ASSERT_TRUE(genItfWithExtensions.hasCoordinatedReactiveControl());
  ASSERT_DOUBLE_EQUALS_DYNAWO(genItfWithExtensions.getCoordinatedReactiveControlPercentage(), 50.);
}  // TEST(DataInterfaceTest, Generator_1)

TEST(DataInterfaceTest, Generator_2) {
  powsybl::iidm::Network network = createGeneratorNetwork();
  powsybl::iidm::VoltageLevel& vl1 = network.getVoltageLevel("VL1");
  powsybl::iidm::Bus& bus1 = vl1.getBusBreakerView().getBus("VL1_BUS1");
  powsybl::iidm::Generator& gen = vl1.newGenerator()
                      .setId("GEN1")
                      .setName("GEN1_NAME")
                      .setConnectableBus(bus1.getId())
                      .setMaxP(50.0)
                      .setMinP(3.0)
                      .setTargetP(45.0)
                      .setReactivePowerSetpoint(10.0)
                      .setVoltageRegulatorOn(false)
                      .add();

  GeneratorInterfaceIIDM genItf(gen);
  const boost::shared_ptr<VoltageLevelInterface> vlItf(new VoltageLevelInterfaceIIDM(vl1));
  genItf.setVoltageLevelInterface(vlItf);
  ASSERT_EQ(genItf.getID(), "GEN1");
  ASSERT_EQ(genItf.getEnergySource(), GeneratorInterface::SOURCE_OTHER);

  ASSERT_FALSE(genItf.getInitialConnected());
  ASSERT_FALSE(genItf.isVoltageRegulationOn());

  ASSERT_EQ(genItf.getTargetV(), 0.0);
  gen.setTargetV(24.0).setVoltageRegulatorOn(true).setReactivePowerSetpoint(stdcxx::nan());
  ASSERT_EQ(genItf.getTargetQ(), 0.0);
  genItf.importStaticParameters();
}  // TEST(DataInterfaceTest, Generator_2)

TEST(DataInterfaceTest, Generator_3) {
  powsybl::iidm::Network network = createGeneratorNetwork();
  powsybl::iidm::VoltageLevel& vl1 = network.getVoltageLevel("VL1");
  powsybl::iidm::Bus& bus1 = vl1.getBusBreakerView().getBus("VL1_BUS1");
  powsybl::iidm::Generator& gen =  vl1.newGenerator()
     .setId("GEN1")
     .setName("GEN1_NAME")
     .setBus(bus1.getId())
     .setConnectableBus(bus1.getId())
     .setMaxP(50.0)
     .setMinP(3.0)
     .setTargetP(45.0)
     .setTargetQ(5.0)
     .setTargetV(24.0)
     .setVoltageRegulatorOn(true)
     .add();

  gen.getTerminal().setP(0.0);
  gen.getTerminal().setQ(0.0);

  GeneratorInterfaceIIDM genItf(gen);

  ASSERT_TRUE(genItf.hasInitialConditions());
}  // TEST(DataInterfaceTest, Generator_3)
}  // namespace DYN
