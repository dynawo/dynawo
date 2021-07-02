//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
//

/**
 * @file Modeler/DataInterface/IIDM/test/TestDataInterfaceIIDM.cpp
 * @brief Unit tests for data interface IIDM
 *
 */

#include "DYNDataInterfaceIIDM.h"
#include "DYNHvdcLineInterfaceIIDM.h"
#include "DYNLineInterfaceIIDM.h"
#include "DYNLoadInterfaceIIDM.h"
#include "DYNNetworkInterfaceIIDM.h"
#include "DYNThreeWTransformerInterfaceIIDM.h"
#include "DYNTwoWTransformerInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "gtest_dynawo.h"

#include <IIDM/Network.h>
#include <IIDM/builders/BusBarSectionBuilder.h>
#include <IIDM/builders/BusBuilder.h>
#include <IIDM/builders/DanglingLineBuilder.h>
#include <IIDM/builders/GeneratorBuilder.h>
#include <IIDM/builders/HvdcLineBuilder.h>
#include <IIDM/builders/LccConverterStationBuilder.h>
#include <IIDM/builders/LineBuilder.h>
#include <IIDM/builders/LoadBuilder.h>
#include <IIDM/builders/NetworkBuilder.h>
#include <IIDM/builders/ShuntCompensatorBuilder.h>
#include <IIDM/builders/StaticVarCompensatorBuilder.h>
#include <IIDM/builders/SubstationBuilder.h>
#include <IIDM/builders/SwitchBuilder.h>
#include <IIDM/builders/Transformer2WindingsBuilder.h>
#include <IIDM/builders/Transformer3WindingsBuilder.h>
#include <IIDM/builders/VoltageLevelBuilder.h>
#include <IIDM/builders/VscConverterStationBuilder.h>
#include <IIDM/components/Bus.h>
#include <IIDM/components/BusBarSection.h>
#include <IIDM/components/Connection.h>
#include <IIDM/components/ConnectionPoint.h>
#include <IIDM/components/DanglingLine.h>
#include <IIDM/components/Generator.h>
#include <IIDM/components/HvdcLine.h>
#include <IIDM/components/LccConverterStation.h>
#include <IIDM/components/Line.h>
#include <IIDM/components/Load.h>
#include <IIDM/components/ShuntCompensator.h>
#include <IIDM/components/StaticVarCompensator.h>
#include <IIDM/components/Substation.h>
#include <IIDM/components/Switch.h>
#include <IIDM/components/TapChanger.h>
#include <IIDM/components/VoltageLevel.h>
#include <IIDM/components/VscConverterStation.h>
#include <IIDM/extensions/standbyAutomaton/StandbyAutomaton.h>
#include <IIDM/extensions/standbyAutomaton/StandbyAutomatonBuilder.h>
#include <boost/make_shared.hpp>
#include <boost/shared_ptr.hpp>

namespace DYN {

static boost::shared_ptr<IIDM::Network>
createNodeBreakerNetworkIIDM() {
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

  return network;
}

boost::shared_ptr<DataInterfaceIIDM>
createDataItfFromNetwork(const boost::shared_ptr<IIDM::Network>& network) {
  boost::shared_ptr<DataInterfaceIIDM> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  return data;
}

TEST(DataInterfaceIIDMTest, testClone) {
  boost::shared_ptr<IIDM::Network> network = createNodeBreakerNetworkIIDM();

  boost::shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(network);
  boost::shared_ptr<DataInterfaceIIDM> data2 = boost::dynamic_pointer_cast<DataInterfaceIIDM>(data->clone());

  ASSERT_TRUE(data);
  ASSERT_NE(data, data2);

  ASSERT_EQ(data->getNetworkIIDM().id(), data2->getNetworkIIDM().id());

  boost::shared_ptr<NetworkInterfaceIIDM> network_interface = boost::dynamic_pointer_cast<NetworkInterfaceIIDM>(data->getNetwork());
  boost::shared_ptr<NetworkInterfaceIIDM> network_interface2 = boost::dynamic_pointer_cast<NetworkInterfaceIIDM>(data2->getNetwork());
  ASSERT_NE(network_interface, network_interface2);
  ASSERT_EQ(network_interface->getVoltageLevels().size(), network_interface2->getVoltageLevels().size());
  for (unsigned int i = 0; i < network_interface->getVoltageLevels().size(); i++) {
    ASSERT_NE(network_interface->getVoltageLevels().at(i), network_interface2->getVoltageLevels().at(i));
    ASSERT_EQ(boost::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(network_interface->getVoltageLevels().at(i))->getID(),
              boost::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(network_interface2->getVoltageLevels().at(i))->getID());
    ASSERT_EQ(boost::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(network_interface->getVoltageLevels().at(i))->getVNom(),
              boost::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(network_interface2->getVoltageLevels().at(i))->getVNom());
    ASSERT_EQ(boost::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(network_interface->getVoltageLevels().at(i))->getVoltageLevelTopologyKind(),
              boost::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(network_interface2->getVoltageLevels().at(i))->getVoltageLevelTopologyKind());

    const std::vector<boost::shared_ptr<LoadInterface> >& loads = network_interface->getVoltageLevels().at(i)->getLoads();
    const std::vector<boost::shared_ptr<LoadInterface> >& loads2 = network_interface2->getVoltageLevels().at(i)->getLoads();
    ASSERT_EQ(loads.size(), loads2.size());
    for (unsigned int j = 0; j < loads.size(); j++) {
      ASSERT_EQ(boost::dynamic_pointer_cast<LoadInterfaceIIDM>(loads[j])->getInitialConnected(),
                boost::dynamic_pointer_cast<LoadInterfaceIIDM>(loads2[j])->getInitialConnected());
      ASSERT_EQ(boost::dynamic_pointer_cast<LoadInterfaceIIDM>(loads[j])->getP(), boost::dynamic_pointer_cast<LoadInterfaceIIDM>(loads2[j])->getP());
      ASSERT_EQ(boost::dynamic_pointer_cast<LoadInterfaceIIDM>(loads[j])->getP0(), boost::dynamic_pointer_cast<LoadInterfaceIIDM>(loads2[j])->getP0());
      ASSERT_EQ(boost::dynamic_pointer_cast<LoadInterfaceIIDM>(loads[j])->getQ(), boost::dynamic_pointer_cast<LoadInterfaceIIDM>(loads2[j])->getQ());
      ASSERT_EQ(boost::dynamic_pointer_cast<LoadInterfaceIIDM>(loads[j])->getQ0(), boost::dynamic_pointer_cast<LoadInterfaceIIDM>(loads2[j])->getQ0());
      ASSERT_EQ(boost::dynamic_pointer_cast<LoadInterfaceIIDM>(loads[j])->getID(), boost::dynamic_pointer_cast<LoadInterfaceIIDM>(loads2[j])->getID());
      ASSERT_EQ(boost::dynamic_pointer_cast<LoadInterfaceIIDM>(loads[j])->getPUnderVoltage(),
                boost::dynamic_pointer_cast<LoadInterfaceIIDM>(loads2[j])->getPUnderVoltage());
      ASSERT_EQ(boost::dynamic_pointer_cast<LoadInterfaceIIDM>(loads[j])->getCountry(),
                boost::dynamic_pointer_cast<LoadInterfaceIIDM>(loads2[j])->getCountry());
    }
    const std::vector<boost::shared_ptr<DYN::BusInterface> >& buses = network_interface->getVoltageLevels().at(i)->getBuses();
    const std::vector<boost::shared_ptr<DYN::BusInterface> >& buses2 = network_interface2->getVoltageLevels().at(i)->getBuses();
    ASSERT_EQ(buses.size(), buses2.size());
    for (unsigned int j = 0; j < buses.size(); j++) {
      const std::vector<std::string>& names = buses[j]->getBusBarSectionNames();
      const std::vector<std::string>& names2 = buses2[j]->getBusBarSectionNames();
      ASSERT_EQ(names.size(), names2.size());
      for (unsigned k = 0; k < names.size(); k++) {
        ASSERT_EQ(names[k], names2[k]);
      }
    }
    const std::vector<boost::shared_ptr<DYN::SwitchInterface> >& switches = network_interface->getVoltageLevels().at(i)->getSwitches();
    const std::vector<boost::shared_ptr<DYN::SwitchInterface> >& switches2 = network_interface2->getVoltageLevels().at(i)->getSwitches();
    ASSERT_EQ(switches.size(), switches2.size());
    for (unsigned int j = 0; j < switches.size(); j++) {
      ASSERT_EQ(switches[j]->getID(), switches2[j]->getID());
    }
  }
  ASSERT_EQ(network_interface->getTwoWTransformers().size(), network_interface2->getTwoWTransformers().size());
  ASSERT_EQ(network_interface->getThreeWTransformers().size(), network_interface2->getThreeWTransformers().size());
}

}  // namespace DYN
