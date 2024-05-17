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

#include "DYNStaticVarCompensatorInterfaceIIDM.h"

#include "DYNBusInterfaceIIDM.h"
#include "DYNInjectorInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/StaticVarCompensatorAdder.hpp>
#include <powsybl/iidm/StaticVarCompensator.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/extensions/iidm/VoltagePerReactivePowerControl.hpp>
#include <powsybl/iidm/extensions/iidm/VoltagePerReactivePowerControlAdder.hpp>

#include "gtest_dynawo.h"

namespace powsybl {
namespace iidm {

static Network
CreateStaticVarCompensatorNetwork() {
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
                          .setNominalV(382.0)
                          .setLowVoltageLimit(340.0)
                          .setHighVoltageLimit(420.0)
                          .add();

  Bus& bus1 = vl1.getBusBreakerView().newBus().setId("VL1_BUS1").add();
  bus1.setV(410.);
  bus1.setAngle(3.14);

  vl1.newStaticVarCompensator()
    .setId("SVC1")
    .setName("SVC1_NAME")
    .setBus(bus1.getId())
    .setConnectableBus(bus1.getId())
    .setBmin(-0.01)
    .setBmax(0.02)
    .setVoltageSetpoint(380.0)
    .setReactivePowerSetpoint(90.0)
    .setRegulationMode(StaticVarCompensator::RegulationMode::OFF)
    .add();

  return network;
}  // CreateStaticVarCompensatorNetwork
}  // namespace iidm
}  // namespace powsybl

namespace DYN {

using powsybl::iidm::CreateStaticVarCompensatorNetwork;

TEST(DataInterfaceTest, SVarC_1) {
  powsybl::iidm::Network network = CreateStaticVarCompensatorNetwork();
  powsybl::iidm::VoltageLevel& vl1 = network.getVoltageLevel("VL1");
  powsybl::iidm::Bus& bus1 = vl1.getBusBreakerView().getBus("VL1_BUS1");
  powsybl::iidm::StaticVarCompensator& svc = network.getStaticVarCompensator("SVC1");

  StaticVarCompensatorInterfaceIIDM svcInterface(svc);
  const boost::shared_ptr<VoltageLevelInterface> voltageLevelIfce(new VoltageLevelInterfaceIIDM(vl1));
  svcInterface.setVoltageLevelInterface(voltageLevelIfce);

  ASSERT_EQ(svcInterface.getComponentVarIndex(std::string("p")), StaticVarCompensatorInterfaceIIDM::VAR_P);
  ASSERT_EQ(svcInterface.getComponentVarIndex(std::string("P1")), -1);
  ASSERT_EQ(svcInterface.getComponentVarIndex(std::string("q")), StaticVarCompensatorInterfaceIIDM::VAR_Q);
  ASSERT_EQ(svcInterface.getComponentVarIndex(std::string("state")), StaticVarCompensatorInterfaceIIDM::VAR_STATE);
  ASSERT_EQ(svcInterface.getComponentVarIndex(std::string("regulatingMode")), -1);

  ASSERT_EQ(svcInterface.getID(), svc.getId());

  ASSERT_TRUE(svcInterface.getInitialConnected());
  ASSERT_TRUE(svcInterface.isConnected());
  ASSERT_TRUE(svcInterface.isPartiallyConnected());
  svc.getTerminal().disconnect();
  ASSERT_FALSE(svcInterface.isPartiallyConnected());
  ASSERT_FALSE(svcInterface.isConnected());
  ASSERT_TRUE(svcInterface.getInitialConnected());

  ASSERT_EQ(svcInterface.getBusInterface().get(), nullptr);
  svcInterface.importStaticParameters();
  const boost::shared_ptr<BusInterface> busIfce(new BusInterfaceIIDM(bus1));
  svcInterface.setBusInterface(busIfce);
  ASSERT_EQ(svcInterface.getBusInterface().get()->getID(), "VL1_BUS1");
  ASSERT_DOUBLE_EQ(svcInterface.getVNom(), 382.0);
  ASSERT_EQ(svcInterface.getVoltageLevelInterfaceInjector(), voltageLevelIfce);

  ASSERT_FALSE(svc.getTerminal().isConnected());

  ASSERT_DOUBLE_EQ(svcInterface.getBMin(), -0.01);
  ASSERT_DOUBLE_EQ(svcInterface.getBMax(), 0.02);

  ASSERT_FALSE(svcInterface.hasStandbyAutomaton());
  ASSERT_FALSE(svcInterface.isStandBy());
  ASSERT_FALSE(svcInterface.hasVoltagePerReactivePowerControl());
  ASSERT_DOUBLE_EQ(svcInterface.getSlope(), 0.);
  ASSERT_DOUBLE_EQ(svcInterface.getB0(), 0.);
  ASSERT_DOUBLE_EQ(svcInterface.getUMinActivation(), 0.);
  ASSERT_DOUBLE_EQ(svcInterface.getUMaxActivation(), 0.);
  ASSERT_DOUBLE_EQ(svcInterface.getUSetPointMin(), 0.);
  ASSERT_DOUBLE_EQ(svcInterface.getUSetPointMax(), 0.);

  ASSERT_DOUBLE_EQ(svcInterface.getVSetPoint(), 380.0);
  ASSERT_DOUBLE_EQ(svcInterface.getReactivePowerSetPoint(), 90.0);

  ASSERT_DOUBLE_EQ(svcInterface.getQ(), 0.0);
  svc.getTerminal().setQ(499.0);
  ASSERT_TRUE(svcInterface.hasQInjector());
  ASSERT_DOUBLE_EQ(svcInterface.getQ(), 499.0);

  ASSERT_DOUBLE_EQ(svcInterface.getPInjector(), 0.0);
  svc.getTerminal().setP(1.0);
  ASSERT_TRUE(svcInterface.hasPInjector());
  ASSERT_DOUBLE_EQ(svcInterface.getPInjector(), 1.0);

  ASSERT_FALSE(svcInterface.hasInitialConditions());

  ASSERT_EQ(svcInterface.getRegulationMode(), StaticVarCompensatorInterface::OFF);
  svc.setRegulationMode(powsybl::iidm::StaticVarCompensator::RegulationMode::VOLTAGE);
  ASSERT_EQ(svcInterface.getRegulationMode(), StaticVarCompensatorInterface::RUNNING_V);
  svc.setRegulationMode(powsybl::iidm::StaticVarCompensator::RegulationMode::REACTIVE_POWER);
  ASSERT_EQ(svcInterface.getRegulationMode(), StaticVarCompensatorInterface::RUNNING_Q);
}  // TEST(DataInterfaceTest, SVarC_1)

TEST(DataInterfaceTest, SVarC_2) {  // tests assuming getInitialConnected == false
  powsybl::iidm::Network network = CreateStaticVarCompensatorNetwork();
  powsybl::iidm::VoltageLevel& vl1 = network.getVoltageLevel("VL1");
  powsybl::iidm::StaticVarCompensator& svc = network.getStaticVarCompensator("SVC1");

  svc.newExtension<powsybl::iidm::extensions::iidm::VoltagePerReactivePowerControlAdder>().withSlope(0.1).add();
  StaticVarCompensatorInterfaceIIDM svcInterface(svc);
  const boost::shared_ptr<VoltageLevelInterface> voltageLevelIfce(new VoltageLevelInterfaceIIDM(vl1));
  svcInterface.setVoltageLevelInterface(voltageLevelIfce);
  ASSERT_EQ(svcInterface.getID(), "SVC1");

  svc.getTerminal().disconnect();
  ASSERT_FALSE(svcInterface.getInitialConnected());

  ASSERT_FALSE(svcInterface.hasPInjector());
  ASSERT_FALSE(svcInterface.hasQInjector());
  ASSERT_DOUBLE_EQ(svcInterface.getPInjector(), 0.0);
  ASSERT_DOUBLE_EQ(svcInterface.getQ(), 0.0);
  ASSERT_TRUE(svcInterface.hasVoltagePerReactivePowerControl());
  ASSERT_DOUBLE_EQ(svcInterface.getSlope(), 0.1);
  ASSERT_FALSE(svcInterface.hasInitialConditions());
}  // TEST(DataInterfaceTest, SVarC_2)

TEST(DataInterfaceTest, SVarC_3) {
  powsybl::iidm::Network network = CreateStaticVarCompensatorNetwork();
  powsybl::iidm::StaticVarCompensator& svc = network.getStaticVarCompensator("SVC1");

  svc.getTerminal().setP(0.0);
  svc.getTerminal().setQ(0.0);

  StaticVarCompensatorInterfaceIIDM svcInterface(svc);

  ASSERT_TRUE(svcInterface.hasInitialConditions());
}  // TEST(DataInterfaceTest, SVarC_3)
}  // namespace DYN
