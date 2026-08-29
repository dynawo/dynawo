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

#include "DYNBatteryInterfaceIIDM.h"

#include "DYNBusInterfaceIIDM.h"
#include "DYNCommon.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "make_unique.hpp"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Battery.hpp>
#include <powsybl/iidm/BatteryAdder.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/extensions/iidm/ActivePowerControl.hpp>
#include <powsybl/iidm/extensions/iidm/ActivePowerControlAdder.hpp>
#include <powsybl/iidm/extensions/iidm/CoordinatedReactiveControl.hpp>
#include <powsybl/iidm/extensions/iidm/CoordinatedReactiveControlAdder.hpp>
#include <powsybl/iidm/ExtensionProviders.hpp>

#include "gtest_dynawo.h"

namespace DYN {

using powsybl::iidm::Bus;
using powsybl::iidm::Battery;
using powsybl::iidm::Network;
using powsybl::iidm::Substation;
using powsybl::iidm::TopologyKind;
using powsybl::iidm::VoltageLevel;

TEST(DataInterfaceTest, Battery_1) {
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

  Battery& bat = vl1.newBattery()
                      .setId("BAT1")
                      .setName("BAT1_NAME")
                      .setBus(bus1.getId())
                      .setConnectableBus(bus1.getId())
                      .setMaxP(50.0)
                      .setMinP(3.0)
                      .setP0(5.0)
                      .setQ0(5.0)
                      .add();

  BatteryInterfaceIIDM batItf(bat);
  const std::shared_ptr<VoltageLevelInterface> vlItf = std::make_shared<VoltageLevelInterfaceIIDM>(vl1);
  batItf.setVoltageLevelInterface(vlItf);
  ASSERT_EQ(batItf.getID(), "BAT1");

  ASSERT_EQ(batItf.getComponentVarIndex(std::string("p")), BatteryInterfaceIIDM::VAR_P);
  ASSERT_EQ(batItf.getComponentVarIndex(std::string("q")), BatteryInterfaceIIDM::VAR_Q);
  ASSERT_EQ(batItf.getComponentVarIndex(std::string("state")), BatteryInterfaceIIDM::VAR_STATE);
  ASSERT_EQ(batItf.getComponentVarIndex(std::string("invalid")), -1);

  batItf.importStaticParameters();

  ASSERT_EQ(batItf.getBusInterface().get(), nullptr);
  std::unique_ptr<BusInterface> busItf = DYN::make_unique<BusInterfaceIIDM>(bus1);
  batItf.setBusInterface(std::move(busItf));
  ASSERT_EQ(batItf.getBusInterface().get()->getID(), "VL1_BUS1");

  batItf.importStaticParameters();

  const std::shared_ptr<VoltageLevelInterface> voltageLevelItf = std::make_shared<VoltageLevelInterfaceIIDM>(vl1);
  batItf.setVoltageLevelInterface(voltageLevelItf);

  ASSERT_TRUE(batItf.getInitialConnected());

  ASSERT_EQ(batItf.getP(), 0.0);
  bat.getTerminal().setP(10.0);
  ASSERT_EQ(batItf.getP(), 10.0);

  ASSERT_EQ(batItf.getQ(), 0.0);
  bat.getTerminal().setQ(11.0);
  ASSERT_EQ(batItf.getQ(), 11.0);

  ASSERT_EQ(batItf.getPMin(), 3.0);
  ASSERT_EQ(batItf.getPMax(), 50.0);

  ASSERT_EQ(batItf.getTargetP(), 0.0);
  ASSERT_EQ(batItf.getTargetQ(), 0.0);
  ASSERT_EQ(batItf.getTargetV(), 0.0);
  ASSERT_EQ(batItf.getEnergySource(), GeneratorInterface::SOURCE_OTHER);

  ASSERT_FALSE(batItf.isVoltageRegulationOn());

  ASSERT_EQ(batItf.getReactiveCurvesPoints().size(), 0);

  ASSERT_TRUE(batItf.getCountry().empty());
  batItf.setCountry("FR");
  ASSERT_EQ(batItf.getCountry(), "FR");
  batItf.setCountry("");
  ASSERT_TRUE(batItf.getCountry().empty());

  ASSERT_EQ(batItf.getQMin(), -std::numeric_limits<double>::max());
  ASSERT_EQ(batItf.getQMax(), std::numeric_limits<double>::max());
  ASSERT_EQ(batItf.getQNom(), std::numeric_limits<double>::max());
  bat.newMinMaxReactiveLimits().setMinQ(1.0).setMaxQ(2.0).add();
  ASSERT_EQ(batItf.getQMin(), 1.0);
  ASSERT_EQ(batItf.getQMax(), 2.0);
  ASSERT_EQ(batItf.getQNom(), 2.0);
  bat.newReactiveCapabilityCurve()
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
  ASSERT_EQ(batItf.getQMin(), 15.0);
  ASSERT_EQ(batItf.getQMax(), 25.0);
  ASSERT_EQ(batItf.getQNom(), 25.0);
  bat.newReactiveCapabilityCurve()
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
  ASSERT_EQ(batItf.getQMin(), 10.0);
  ASSERT_EQ(batItf.getQMax(), 20.0);
  ASSERT_EQ(batItf.getQNom(), 25.0);
  bat.newReactiveCapabilityCurve()
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
  ASSERT_EQ(batItf.getQMin(), 12.5);
  ASSERT_EQ(batItf.getQMax(), 22.5);
  ASSERT_EQ(batItf.getQNom(), 25.0);
  ASSERT_EQ(batItf.getReactiveCurvesPoints().size(), 2);
  bat.newReactiveCapabilityCurve()
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
  ASSERT_EQ(batItf.getQNom(), 30.0);

  // TODO(TBA) batItf.exportStateVariablesUnitComponent();
  bat.getTerminal().disconnect();
  // TODO(TBA) batItf.exportStateVariablesUnitComponent();
  ASSERT_FALSE(batItf.hasActivePowerControl());
  ASSERT_FALSE(batItf.isParticipating());
  ASSERT_DOUBLE_EQUALS_DYNAWO(batItf.getActivePowerControlDroop(), 0.);
  ASSERT_FALSE(batItf.hasCoordinatedReactiveControl());
  ASSERT_DOUBLE_EQUALS_DYNAWO(batItf.getCoordinatedReactiveControlPercentage(), 0.);

  bat.newExtension<powsybl::iidm::extensions::iidm::ActivePowerControlAdder>().withDroop(4.0).withParticipate(true).add();
  BatteryInterfaceIIDM batItfWithExtensions(bat);
  ASSERT_TRUE(batItfWithExtensions.hasActivePowerControl());
  ASSERT_TRUE(batItfWithExtensions.isParticipating());
  ASSERT_DOUBLE_EQUALS_DYNAWO(batItfWithExtensions.getActivePowerControlDroop(), 4.);
  ASSERT_FALSE(batItfWithExtensions.hasCoordinatedReactiveControl());
  ASSERT_DOUBLE_EQUALS_DYNAWO(batItfWithExtensions.getCoordinatedReactiveControlPercentage(), 0.);
}  // TEST(DataInterfaceTest, Battery_1)

}  // namespace DYN
