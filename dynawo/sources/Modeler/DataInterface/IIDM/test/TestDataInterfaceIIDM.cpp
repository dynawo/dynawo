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
  ASSERT_EQ(network_interface->getLines().size(), network_interface2->getLines().size());
  for (unsigned int i = 0; i < network_interface->getLines().size(); i++) {
    ASSERT_NE(network_interface->getLines().at(i), network_interface2->getLines().at(i));
    ASSERT_EQ(boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface->getLines().at(i))->getVNom1(),
              boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface2->getLines().at(i))->getVNom1());
    ASSERT_EQ(boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface->getLines().at(i))->getVNom2(),
              boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface2->getLines().at(i))->getVNom2());
    ASSERT_EQ(boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface->getLines().at(i))->getR(),
              boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface2->getLines().at(i))->getR());
    ASSERT_EQ(boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface->getLines().at(i))->getX(),
              boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface2->getLines().at(i))->getX());
    ASSERT_EQ(boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface->getLines().at(i))->getB1(),
              boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface2->getLines().at(i))->getB1());
    ASSERT_EQ(boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface->getLines().at(i))->getB2(),
              boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface2->getLines().at(i))->getB2());
    ASSERT_EQ(boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface->getLines().at(i))->getG1(),
              boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface2->getLines().at(i))->getG1());
    ASSERT_EQ(boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface->getLines().at(i))->getG2(),
              boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface2->getLines().at(i))->getG2());
    ASSERT_EQ(boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface->getLines().at(i))->getP1(),
              boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface2->getLines().at(i))->getP1());
    ASSERT_EQ(boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface->getLines().at(i))->getQ1(),
              boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface2->getLines().at(i))->getQ1());
    ASSERT_EQ(boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface->getLines().at(i))->getP2(),
              boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface2->getLines().at(i))->getP2());
    ASSERT_EQ(boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface->getLines().at(i))->getQ2(),
              boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface2->getLines().at(i))->getQ2());
    ASSERT_EQ(boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface->getLines().at(i))->getInitialConnected1(),
              boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface2->getLines().at(i))->getInitialConnected1());
    ASSERT_EQ(boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface->getLines().at(i))->getInitialConnected2(),
              boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface2->getLines().at(i))->getInitialConnected2());
    ASSERT_EQ(boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface->getLines().at(i))->getID(),
              boost::dynamic_pointer_cast<LineInterfaceIIDM>(network_interface2->getLines().at(i))->getID());
  }

  ASSERT_EQ(network_interface->getHvdcLines().size(), network_interface2->getHvdcLines().size());
  for (unsigned int i = 0; i < network_interface->getHvdcLines().size(); i++) {
    ASSERT_NE(network_interface->getHvdcLines().at(i), network_interface2->getHvdcLines().at(i));
    ASSERT_EQ(boost::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(network_interface->getHvdcLines().at(i))->getID(),
              boost::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(network_interface2->getHvdcLines().at(i))->getID());
    ASSERT_EQ(boost::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(network_interface->getHvdcLines().at(i))->getResistanceDC(),
              boost::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(network_interface2->getHvdcLines().at(i))->getResistanceDC());
    ASSERT_EQ(boost::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(network_interface->getHvdcLines().at(i))->getVNom(),
              boost::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(network_interface2->getHvdcLines().at(i))->getVNom());
    ASSERT_EQ(boost::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(network_interface->getHvdcLines().at(i))->getActivePowerSetpoint(),
              boost::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(network_interface2->getHvdcLines().at(i))->getActivePowerSetpoint());
    ASSERT_EQ(boost::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(network_interface->getHvdcLines().at(i))->getPmax(),
              boost::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(network_interface2->getHvdcLines().at(i))->getPmax());
    ASSERT_EQ(boost::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(network_interface->getHvdcLines().at(i))->getConverterMode(),
              boost::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(network_interface2->getHvdcLines().at(i))->getConverterMode());
    ASSERT_EQ(boost::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(network_interface->getHvdcLines().at(i))->getIdConverter1(),
              boost::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(network_interface2->getHvdcLines().at(i))->getIdConverter1());
    ASSERT_EQ(boost::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(network_interface->getHvdcLines().at(i))->getIdConverter2(),
              boost::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(network_interface2->getHvdcLines().at(i))->getIdConverter2());
  }

  ASSERT_EQ(network_interface->getVoltageLevels().size(), network_interface2->getVoltageLevels().size());
  for (unsigned int i = 0; i < network_interface->getVoltageLevels().size(); i++) {
    ASSERT_NE(network_interface->getVoltageLevels().at(i), network_interface2->getVoltageLevels().at(i));
    ASSERT_EQ(boost::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(network_interface->getVoltageLevels().at(i))->getID(),
              boost::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(network_interface2->getVoltageLevels().at(i))->getID());
    ASSERT_EQ(boost::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(network_interface->getVoltageLevels().at(i))->getVNom(),
              boost::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(network_interface2->getVoltageLevels().at(i))->getVNom());
    ASSERT_EQ(boost::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(network_interface->getVoltageLevels().at(i))->getVoltageLevelTopologyKind(),
              boost::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(network_interface2->getVoltageLevels().at(i))->getVoltageLevelTopologyKind());
  }

  ASSERT_EQ(network_interface->getTwoWTransformers().size(), network_interface2->getTwoWTransformers().size());
  for (unsigned int i = 0; i < network_interface->getTwoWTransformers().size(); i++) {
    ASSERT_NE(network_interface->getTwoWTransformers().at(i), network_interface2->getTwoWTransformers().at(i));
    ASSERT_EQ(boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface->getTwoWTransformers().at(i))->getID(),
              boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface2->getTwoWTransformers().at(i))->getID());
    ASSERT_EQ(boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface->getTwoWTransformers().at(i))->getInitialConnected1(),
              boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface2->getTwoWTransformers().at(i))->getInitialConnected1());
    ASSERT_EQ(boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface->getTwoWTransformers().at(i))->getInitialConnected2(),
              boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface2->getTwoWTransformers().at(i))->getInitialConnected2());
    ASSERT_EQ(boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface->getTwoWTransformers().at(i))->getVNom1(),
              boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface2->getTwoWTransformers().at(i))->getVNom1());
    ASSERT_EQ(boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface->getTwoWTransformers().at(i))->getVNom2(),
              boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface2->getTwoWTransformers().at(i))->getVNom2());
    ASSERT_EQ(boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface->getTwoWTransformers().at(i))->getRatedU1(),
              boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface2->getTwoWTransformers().at(i))->getRatedU1());
    ASSERT_EQ(boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface->getTwoWTransformers().at(i))->getRatedU2(),
              boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface2->getTwoWTransformers().at(i))->getRatedU2());
    ASSERT_EQ(boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface->getTwoWTransformers().at(i))->getR(),
              boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface2->getTwoWTransformers().at(i))->getR());
    ASSERT_EQ(boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface->getTwoWTransformers().at(i))->getX(),
              boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface2->getTwoWTransformers().at(i))->getX());
    ASSERT_EQ(boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface->getTwoWTransformers().at(i))->getG(),
              boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface2->getTwoWTransformers().at(i))->getG());
    ASSERT_EQ(boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface->getTwoWTransformers().at(i))->getB(),
              boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface2->getTwoWTransformers().at(i))->getB());
    ASSERT_EQ(boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface->getTwoWTransformers().at(i))->getP1(),
              boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface2->getTwoWTransformers().at(i))->getP1());
    ASSERT_EQ(boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface->getTwoWTransformers().at(i))->getQ1(),
              boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface2->getTwoWTransformers().at(i))->getQ1());
    ASSERT_EQ(boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface->getTwoWTransformers().at(i))->getP2(),
              boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface2->getTwoWTransformers().at(i))->getP2());
    ASSERT_EQ(boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface->getTwoWTransformers().at(i))->getQ2(),
              boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(network_interface2->getTwoWTransformers().at(i))->getQ2());
  }

  ASSERT_EQ(network_interface->getThreeWTransformers().size(), network_interface2->getThreeWTransformers().size());
  for (unsigned int i = 0; i < network_interface->getThreeWTransformers().size(); i++) {
    ASSERT_NE(network_interface->getThreeWTransformers().at(i), network_interface2->getThreeWTransformers().at(i));
    ASSERT_EQ(boost::dynamic_pointer_cast<ThreeWTransformerInterfaceIIDM>(network_interface->getThreeWTransformers().at(i))->getID(),
              boost::dynamic_pointer_cast<ThreeWTransformerInterfaceIIDM>(network_interface2->getThreeWTransformers().at(i))->getID());
    ASSERT_EQ(boost::dynamic_pointer_cast<ThreeWTransformerInterfaceIIDM>(network_interface->getThreeWTransformers().at(i))->getInitialConnected1(),
              boost::dynamic_pointer_cast<ThreeWTransformerInterfaceIIDM>(network_interface2->getThreeWTransformers().at(i))->getInitialConnected1());
    ASSERT_EQ(boost::dynamic_pointer_cast<ThreeWTransformerInterfaceIIDM>(network_interface->getThreeWTransformers().at(i))->getInitialConnected2(),
              boost::dynamic_pointer_cast<ThreeWTransformerInterfaceIIDM>(network_interface2->getThreeWTransformers().at(i))->getInitialConnected2());
  }
}

}  // namespace DYN
