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

#include "DYNNetworkInterfaceIIDM.h"
#include "DYNLineInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"

#include "gtest_dynawo.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Line.hpp>
#include <powsybl/iidm/LineAdder.hpp>
#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/Substation.hpp>

using boost::shared_ptr;

namespace DYN {

TEST(DataInterfaceTest, Network) {
  powsybl::iidm::Network networkIIDM("test", "test");
  powsybl::iidm::Substation& substation = networkIIDM.newSubstation()
                                     .setId("S1")
                                     .setName("S1_NAME")
                                     .setCountry(powsybl::iidm::Country::FR)
                                     .setTso("TSO")
                                     .add();

  powsybl::iidm::VoltageLevel& vl1 = substation.newVoltageLevel()
                                     .setId("VL1")
                                     .setName("VL1_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalVoltage(380.0)
                                     .setLowVoltageLimit(340.0)
                                     .setHighVoltageLimit(420.0)
                                     .add();

  powsybl::iidm::Bus& vl1Bus1 = vl1.getBusBreakerView().newBus().setId("VL1_BUS1").add();

  powsybl::iidm::VoltageLevel& vl2 = substation.newVoltageLevel()
                                     .setId("VL2")
                                     .setName("VL2_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalVoltage(225.0)
                                     .setLowVoltageLimit(200.0)
                                     .setHighVoltageLimit(260.0)
                                     .add();

  vl2.getBusBreakerView().newBus().setId("VL2_BUS1").add();

  powsybl::iidm::Substation& substation2 = networkIIDM.newSubstation()
                                     .setId("S2")
                                     .setName("S2_NAME")
                                     .setCountry(powsybl::iidm::Country::FR)
                                     .setTso("TSO")
                                     .add();

  powsybl::iidm::VoltageLevel& vl3 = substation2.newVoltageLevel()
                                     .setId("VL3")
                                     .setName("VL3_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalVoltage(360.0)
                                     .setLowVoltageLimit(340.0)
                                     .setHighVoltageLimit(420.0)
                                     .add();

  powsybl::iidm::Bus& vl3Bus1 = vl3.getBusBreakerView().newBus().setId("VL3_BUS1").add();

  powsybl::iidm::VoltageLevel& vl4 = substation2.newVoltageLevel()
                                     .setId("VL4")
                                     .setName("VL4_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalVoltage(225.0)
                                     .setLowVoltageLimit(200.0)
                                     .setHighVoltageLimit(260.0)
                                     .add();

  vl4.getBusBreakerView().newBus().setId("VL4_BUS1").add();

  powsybl::iidm::Line& MyLine = networkIIDM.newLine()
                                    .setId("VL1_VL3")
                                    .setVoltageLevel1(vl1.getId())
                                    .setBus1(vl1Bus1.getId())
                                    .setConnectableBus1(vl1Bus1.getId())
                                    .setVoltageLevel2(vl3.getId())
                                    .setBus2(vl3Bus1.getId())
                                    .setConnectableBus2(vl3Bus1.getId())
                                    .setR(3.0)
                                    .setX(33.33)
                                    .setG1(1.0)
                                    .setB1(0.2)
                                    .setG2(2.0)
                                    .setB2(0.4)
                                    .add();
  NetworkInterfaceIIDM network(networkIIDM);
  shared_ptr<LineInterface> li(new LineInterfaceIIDM(MyLine));
  shared_ptr<VoltageLevelInterface> vl(new VoltageLevelInterfaceIIDM(vl1));

  ASSERT_EQ(network.getLines().size(), 0);
  network.addLine(li);
  ASSERT_EQ(network.getLines().size(), 1);

  ASSERT_EQ(network.getVoltageLevels().size(), 0);
  network.addVoltageLevel(vl);
  ASSERT_EQ(network.getVoltageLevels().size(), 1);
}  // TEST(DataInterfaceTest, VoltageLevel)
}  // namespace DYN
