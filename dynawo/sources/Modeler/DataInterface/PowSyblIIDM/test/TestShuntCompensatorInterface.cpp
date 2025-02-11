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

#include "DYNShuntCompensatorInterfaceIIDM.h"

#include "DYNBusInterfaceIIDM.h"
#include "DYNInjectorInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"

#include "DYNCommon.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/ShuntCompensator.hpp>
#include <powsybl/iidm/ShuntCompensatorAdder.hpp>
#include <powsybl/iidm/Substation.hpp>

#include "make_unique.hpp"
#include "gtest_dynawo.h"

namespace powsybl {
namespace iidm {

static Network
CreateShuntCompensatorNetwork() {
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

  Bus& bus1 = vl1.getBusBreakerView().newBus().setId("VL1_BUS1").add();
  bus1.setV(382.).setAngle(90);

  vl1.newShuntCompensator()
      .setId("SHUNT1")
      .setName("SHUNT1_NAME")
      .setBus(bus1.getId())
      .setConnectableBus(bus1.getId())
      .newLinearModel()
      .setBPerSection(12.0)
      .setMaximumSectionCount(3UL)
      .add()
      .setSectionCount(2UL)
      .add();

  return network;
}  // CreateShuntCompensatorNetwork
}  // namespace iidm
}  // namespace powsybl

namespace DYN {
using powsybl::iidm::CreateShuntCompensatorNetwork;

TEST(DataInterfaceTest, ShuntCompensator_1) {
  powsybl::iidm::Network network = CreateShuntCompensatorNetwork();
  powsybl::iidm::VoltageLevel& vl1 = network.getVoltageLevel("VL1");
  powsybl::iidm::Bus& bus1 = vl1.getBusBreakerView().getBus("VL1_BUS1");
  powsybl::iidm::ShuntCompensator& shuntCompensator = network.getShuntCompensator("SHUNT1");

  ShuntCompensatorInterfaceIIDM shuntCompensatorIfce(shuntCompensator);
  const std::shared_ptr<VoltageLevelInterface> voltageLevelIfce = std::make_shared<VoltageLevelInterfaceIIDM>(vl1);
  shuntCompensatorIfce.setVoltageLevelInterface(voltageLevelIfce);

  ASSERT_EQ(shuntCompensatorIfce.getComponentVarIndex(std::string("currentSection")), ShuntCompensatorInterfaceIIDM::VAR_CURRENTSECTION);
  ASSERT_EQ(shuntCompensatorIfce.getComponentVarIndex(std::string("wrongIndex")), -1);
  ASSERT_EQ(shuntCompensatorIfce.getComponentVarIndex(std::string("q")), ShuntCompensatorInterfaceIIDM::VAR_Q);
  ASSERT_EQ(shuntCompensatorIfce.getComponentVarIndex(std::string("state")), ShuntCompensatorInterfaceIIDM::VAR_STATE);

  ASSERT_EQ(shuntCompensatorIfce.getID(), shuntCompensator.getId());

  ASSERT_TRUE(shuntCompensatorIfce.getInitialConnected());
  ASSERT_TRUE(shuntCompensatorIfce.isConnected());
  ASSERT_TRUE(shuntCompensatorIfce.isPartiallyConnected());
  shuntCompensator.getTerminal().disconnect();
  ASSERT_FALSE(shuntCompensatorIfce.isPartiallyConnected());
  ASSERT_FALSE(shuntCompensatorIfce.isConnected());
  ASSERT_TRUE(shuntCompensatorIfce.getInitialConnected());

  ASSERT_EQ(shuntCompensatorIfce.getBusInterface().get(), nullptr);
  std::unique_ptr<BusInterface> busIfce = DYN::make_unique<BusInterfaceIIDM>(bus1);
  shuntCompensatorIfce.setBusInterface(std::move(busIfce));
  ASSERT_EQ(shuntCompensatorIfce.getBusInterface().get()->getID(), "VL1_BUS1");

  ASSERT_DOUBLE_EQ(shuntCompensatorIfce.getCurrentSection(), 2UL);
  ASSERT_DOUBLE_EQ(shuntCompensatorIfce.getMaximumSection(), 3UL);
  shuntCompensator.getTerminal().setQ(4.0);
  ASSERT_DOUBLE_EQ(shuntCompensatorIfce.getQ(), 4.0);
  ASSERT_DOUBLE_EQ(shuntCompensatorIfce.getVNom(), 380);
  ASSERT_TRUE(shuntCompensatorIfce.isLinear());
  ASSERT_DOUBLE_EQ(shuntCompensatorIfce.getB(0), 0.);
  ASSERT_DOUBLE_EQ(shuntCompensatorIfce.getB(1), 12.);
  ASSERT_DOUBLE_EQ(shuntCompensatorIfce.getB(2), 24.);
  ASSERT_DOUBLE_EQ(shuntCompensatorIfce.getB(3), 36.);
  shuntCompensatorIfce.importStaticParameters();
  ASSERT_DOUBLE_EQUALS_DYNAWO(shuntCompensatorIfce.getStaticParameterValue<double>("v_pu"), 382.0/380.0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(shuntCompensatorIfce.getStaticParameterValue<double>("angle_pu"), M_PI/2.0);
  shuntCompensator.setTargetV(380.).setTargetDeadband(1.);
  shuntCompensator.setVoltageRegulatorOn(false);
  ASSERT_EQ(shuntCompensatorIfce.isVoltageRegulationOn(), false);
  shuntCompensator.setVoltageRegulatorOn(true);
  ASSERT_DOUBLE_EQUALS_DYNAWO(shuntCompensatorIfce.getTargetV(), 380.);
  ASSERT_EQ(shuntCompensatorIfce.isVoltageRegulationOn(), true);
  shuntCompensatorIfce.setBusInterface(nullptr);
  shuntCompensatorIfce.importStaticParameters();
  ASSERT_DOUBLE_EQUALS_DYNAWO(shuntCompensatorIfce.getStaticParameterValue<double>("v_pu"), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(shuntCompensatorIfce.getStaticParameterValue<double>("angle_pu"), 0.);

  ASSERT_FALSE(shuntCompensatorIfce.hasInitialConditions());

  vl1.newShuntCompensator()
      .setId("SHUNT2")
      .setName("SHUNT2_NAME")
      .setBus(bus1.getId())
      .setConnectableBus(bus1.getId())
      .newNonLinearModel()
      .beginSection()
      .setB(11.)
      .endSection()
      .beginSection()
      .setB(24.0)
      .endSection()
      .add()
      .setSectionCount(2)
      .add();
  powsybl::iidm::ShuntCompensator& shuntCompensator_2 = network.getShuntCompensator("SHUNT2");
  ShuntCompensatorInterfaceIIDM shuntCompensatorIfce_2(shuntCompensator_2);
  const std::shared_ptr<VoltageLevelInterface> voltageLevelIfce_2 = std::make_shared<VoltageLevelInterfaceIIDM>(vl1);
  shuntCompensatorIfce_2.setVoltageLevelInterface(voltageLevelIfce_2);
  ASSERT_FALSE(shuntCompensatorIfce_2.isLinear());
  ASSERT_DOUBLE_EQ(shuntCompensatorIfce_2.getB(0), 0.);
  ASSERT_DOUBLE_EQ(shuntCompensatorIfce_2.getB(1), 11.);
  ASSERT_DOUBLE_EQ(shuntCompensatorIfce_2.getB(2), 24.);
}  // TEST(DataInterfaceTest, ShuntCompensator_1)

TEST(DataInterfaceTest, ShuntCompensator_2) {
  powsybl::iidm::Network network = CreateShuntCompensatorNetwork();
  powsybl::iidm::ShuntCompensator& shuntCompensator = network.getShuntCompensator("SHUNT1");

  shuntCompensator.getTerminal().setQ(0.0);

  ShuntCompensatorInterfaceIIDM shuntCompensatorIfce(shuntCompensator);

  ASSERT_TRUE(shuntCompensatorIfce.hasInitialConditions());
}  // TEST(DataInterfaceTest, ShuntCompensator_2)
}  // namespace DYN
