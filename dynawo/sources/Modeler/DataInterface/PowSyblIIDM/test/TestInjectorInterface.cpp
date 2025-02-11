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

/**
 * @file  TestInjectorInterface.cpp
 *
 * @brief Test of the Injector interface base class for IIDM
 *
 * InjectorInterface is a base class for other objects: LoadInterface, BusCalculated...
 * This test file instanciates only unitary tests
 */

#include "DYNInjectorInterfaceIIDM.h"

#include "DYNBusInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Load.hpp>
#include <powsybl/iidm/LoadAdder.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/Substation.hpp>

#include "make_unique.hpp"
#include "gtest_dynawo.h"

TEST(DataInterfaceTest, Injector_1) {
  using powsybl::iidm::Bus;
  using powsybl::iidm::Load;
  using powsybl::iidm::LoadType;
  using powsybl::iidm::Network;
  using powsybl::iidm::Substation;
  using powsybl::iidm::TopologyKind;
  using powsybl::iidm::VoltageLevel;

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

  Bus& bus = vl1.getBusBreakerView().newBus().setId("VL1_BUS1").add();

  vl1.newLoad()
      .setId("LOAD1")
      .setBus("VL1_BUS1")
      .setConnectableBus("VL1_BUS1")
      .setLoadType(LoadType::UNDEFINED)
      .setP0(55.0)
      .setQ0(44.0)
      .add();

  Load& load = network.getLoad("LOAD1");
  const powsybl::iidm::Injection& Inj = load;

  DYN::InjectorInterfaceIIDM Ifce(Inj, "Name for TRACE");
  const std::shared_ptr<DYN::VoltageLevelInterface> voltageLevelIfce = std::make_shared<DYN::VoltageLevelInterfaceIIDM>(vl1);
  Ifce.setVoltageLevelInterfaceInjector(voltageLevelIfce);
  ASSERT_EQ("Name for TRACE", Ifce.getIDInjector());

  ASSERT_EQ(Ifce.getBusInterfaceInjector().get(), nullptr);
  std::unique_ptr<DYN::BusInterface> busIfce = DYN::make_unique<DYN::BusInterfaceIIDM>(bus);
  Ifce.setBusInterfaceInjector(std::move(busIfce));
  ASSERT_EQ(Ifce.getBusInterfaceInjector().get()->getID(), "VL1_BUS1");

  ASSERT_TRUE(Ifce.getInitialConnectedInjector());
  ASSERT_TRUE(Ifce.isConnectedInjector());
  load.getTerminal().disconnect();
  ASSERT_FALSE(Ifce.isConnectedInjector());
  ASSERT_TRUE(Ifce.getInitialConnectedInjector());

  ASSERT_FALSE(Ifce.hasPInjector());
  ASSERT_FALSE(Ifce.hasQInjector());

  ASSERT_DOUBLE_EQ(Ifce.getPInjector(), 0.0);
  load.getTerminal().setP(1000.0);
  ASSERT_TRUE(Ifce.hasPInjector());
  ASSERT_DOUBLE_EQ(Ifce.getPInjector(), 1000.0);

  ASSERT_DOUBLE_EQ(Ifce.getQInjector(), 0.0);
  load.getTerminal().setQ(499.0);
  ASSERT_TRUE(Ifce.hasQInjector());
  ASSERT_DOUBLE_EQ(Ifce.getQInjector(), 499.0);

  DYN::InjectorInterfaceIIDM IfceNC(Inj, "Injector initially not connected");
  IfceNC.setVoltageLevelInterfaceInjector(voltageLevelIfce);
  ASSERT_FALSE(IfceNC.getInitialConnectedInjector());
  ASSERT_DOUBLE_EQ(IfceNC.getPInjector(), 0.0);
  ASSERT_DOUBLE_EQ(IfceNC.getQInjector(), 0.0);
  ASSERT_DOUBLE_EQ(Ifce.getVNomInjector(), 380);
  ASSERT_EQ(Ifce.getVoltageLevelInterfaceInjector(), voltageLevelIfce);
}  // TEST(DataInterfaceTest, Injector_1)


TEST(DataInterfaceTest, Injector_2) {
  using powsybl::iidm::Load;
  using powsybl::iidm::LoadType;
  using powsybl::iidm::Network;
  using powsybl::iidm::Substation;
  using powsybl::iidm::TopologyKind;
  using powsybl::iidm::VoltageLevel;

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

  vl1.getBusBreakerView().newBus().setId("VL1_BUS1").add();

  vl1.newLoad()
      .setId("LOAD2")
      .setBus("VL1_BUS1")
      .setConnectableBus("VL1_BUS1")
      .setLoadType(LoadType::UNDEFINED)
      .setP0(55.0)
      .setQ0(44.0)
      .add();

  Load& load = network.getLoad("LOAD2");
  load.getTerminal().disconnect();
  const powsybl::iidm::Injection& Inj = load;

  DYN::InjectorInterfaceIIDM IfceNC(Inj, "Injector initially not connected");
  const std::shared_ptr<DYN::VoltageLevelInterface> voltageLevelIfce = std::make_shared<DYN::VoltageLevelInterfaceIIDM>(vl1);
  IfceNC.setVoltageLevelInterfaceInjector(voltageLevelIfce);
  ASSERT_FALSE(IfceNC.getInitialConnectedInjector());
  ASSERT_DOUBLE_EQ(IfceNC.getPInjector(), 0.0);
  ASSERT_DOUBLE_EQ(IfceNC.getQInjector(), 0.0);
}  // TEST(DataInterfaceTest, Injector_2)
