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


#include <IIDM/Network.h>
#include <IIDM/components/Substation.h>
#include <IIDM/components/VoltageLevel.h>
#include <IIDM/components/BusBarSection.h>
#include <IIDM/builders/NetworkBuilder.h>
#include <IIDM/builders/VoltageLevelBuilder.h>
#include <IIDM/builders/BusBarSectionBuilder.h>
#include <IIDM/builders/SubstationBuilder.h>
#include "DYNDataInterfaceIIDM.h"
#include "DYNNetworkInterface.h"
#include "DYNVoltageLevelInterface.h"
#include "DYNBusBarSectionInterfaceIIDM.h"

#include "gtest_dynawo.h"

#include <boost/make_shared.hpp>

using boost::shared_ptr;

namespace DYN {

TEST(DataInterfaceTest, testBusBarSectionInterface) {
  IIDM::builders::NetworkBuilder nb;
  boost::shared_ptr<IIDM::Network> network = boost::make_shared<IIDM::Network>(nb.build("MyNetwork"));
  IIDM::Port p1(0), p2(0);

  IIDM::builders::SubstationBuilder ssb;
  IIDM::Substation ss = ssb.build("MySubStation");

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::node_breaker);
  vlb.nominalV(190.);
  vlb.node_count(1);
  IIDM::VoltageLevel vl = vlb.build("MyVoltageLevel");
  vl.lowVoltageLimit(120.);
  vl.highVoltageLimit(150.);

  IIDM::builders::BusBarSectionBuilder bbsb;
  bbsb.node(0);
  IIDM::BusBarSection bbs = bbsb.build("MyBusBarSection");
  bbs.v(110.);
  bbs.angle(1.5);
  vl.add(bbs);

  ss.add(vl);

  network->add(ss);

  shared_ptr<DataInterface> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  const std::vector< boost::shared_ptr<VoltageLevelInterface> >& vls =  ptr->getNetwork()->getVoltageLevels();
  ASSERT_EQ(vls.size(), 1);
  boost::shared_ptr<VoltageLevelInterface> vlModel = vls[0];
  const std::vector< boost::shared_ptr<BusInterface> >& buses = vlModel->getBuses();
  ASSERT_EQ(buses.size(), 1);
  boost::shared_ptr<BusInterface> bus = buses[0];
  std::vector<std::string> bbsIdentifiers = bus->getBusBarSectionIdentifiers();
  ASSERT_EQ(bbsIdentifiers.size(), 1);
  ASSERT_EQ(bbsIdentifiers[0], "MyBusBarSection");


  BusBarSectionInterfaceIIDM bbsIIDM(bbs);
  ASSERT_EQ(bbsIIDM.id(), "MyBusBarSection");
  bbsIIDM.setAngle(3);
  ASSERT_EQ(bbs.angle(), 3);
  bbsIIDM.setV(240);
  ASSERT_EQ(bbs.v(), 240);
}

}  // namespace DYN
