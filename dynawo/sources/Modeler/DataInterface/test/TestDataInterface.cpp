//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite
// of simulation tools for power systems.
//

/**
 * @file Modeler/DataInterface/test/TestDataInterface.cpp
 * @brief Unit tests for DataInterface/DYNDataInterface class
 *
 */

#include "gtest_dynawo.h"

#include "DYNCommon.h"
#include "DYNDataInterface.h"
#include "DYNLineInterface.h"
#include "DYNModelConstants.h"
#include "DYNModelMulti.h"
#include "DYNNetworkInterface.h"
#include "DYNSubModel.h"
#include "DYNSubModelFactory.h"
#include "DYNSwitchInterface.h"
#include "DYNTwoWTransformerInterface.h"
#include "DYNVoltageLevelInterface.h"
#include "LEQLostEquipmentsCollectionFactory.h"
#include "PARParametersSet.h"

#include "DYNDataInterfaceIIDM.h"

#ifdef USE_POWSYBL
#include <powsybl/iidm/LineAdder.hpp>
#include <powsybl/iidm/LoadAdder.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/TwoWindingsTransformerAdder.hpp>
#include <powsybl/iidm/TopologyKind.hpp>

#else
#include <IIDM/builders/BusBarSectionBuilder.h>
#include <IIDM/builders/BusBuilder.h>
#include <IIDM/builders/LineBuilder.h>
#include <IIDM/builders/LoadBuilder.h>
#include <IIDM/builders/NetworkBuilder.h>
#include <IIDM/builders/SubstationBuilder.h>
#include <IIDM/builders/SwitchBuilder.h>
#include <IIDM/builders/Transformer2WindingsBuilder.h>
#include <IIDM/builders/VoltageLevelBuilder.h>
#endif

using boost::shared_ptr;

namespace DYN {

static shared_ptr<SubModel>
initializeModel(shared_ptr<DataInterface> data) {
  shared_ptr<SubModel> modelNetwork = SubModelFactory::createSubModelFromLib("../../../../M/CPP/ModelNetwork/DYNModelNetwork" +
                                                                             std::string(sharedLibraryExtension()));
  modelNetwork->initFromData(data);
  data->setModelNetwork(modelNetwork);
  modelNetwork->name("NETWORK");
  shared_ptr<parameters::ParametersSet> parametersSet = shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
  parametersSet->createParameter("bus_uMax", 0.);
  parametersSet->createParameter("capacitor_no_reclosing_delay", 0.);
  parametersSet->createParameter("load_alpha", 0.);
  parametersSet->createParameter("load_beta", 0.);
  parametersSet->createParameter("load_isRestorative", false);
  parametersSet->createParameter("load_isControllable", false);
  parametersSet->createParameter("transformer_t1st_THT", 9.);
  parametersSet->createParameter("transformer_tNext_THT", 10.);
  parametersSet->createParameter("transformer_t1st_HT", 11.);
  parametersSet->createParameter("transformer_tNext_HT", 12.);
  parametersSet->createParameter("transformer_tolV", 13.);
  modelNetwork->setPARParameters(parametersSet);

  return modelNetwork;
}  // initializeModel(shared_ptr<DataInterface> data);

static void
exportStateVariables(shared_ptr<DataInterface> data) {
  shared_ptr<SubModel> modelNetwork = initializeModel(data);
  ModelMulti mm;
  mm.addSubModel(modelNetwork, "MyLib");
  mm.initBuffers();
  mm.init(0.0);
  data->getStateVariableReference();
  data->exportStateVariables();
  data->updateFromModel(false);
  data->importStaticParameters();
}

TEST(DataInterfaceTest, testLostEquipments) {
#ifdef USE_POWSYBL
  auto network = boost::make_shared<powsybl::iidm::Network>("test", "test");

  auto& substation = network->newSubstation()
    .setId("SUB")
    .add();

  auto& vl1 = substation.newVoltageLevel()
    .setId("VL1")
    .setNominalV(380.)
    .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
    .add();

  vl1.getBusBreakerView().newBus().setId("VL1_BUS1").add().setAngle(1.5).setV(150.);
  vl1.getBusBreakerView().newBus().setId("VL1_BUS2").add().setAngle(1.5).setV(150.);

  vl1.getBusBreakerView().newSwitch()
    .setId("VL1_SW12")
    .setBus1("VL1_BUS1")
    .setBus2("VL1_BUS2")
    .add();

  vl1.newLoad()
    .setId("VL1_LOAD1")
    .setBus("VL1_BUS1")
    .setP0(5000.)
    .setQ0(4000.)
    .add();

  auto& vl2 = substation.newVoltageLevel()
    .setId("VL2")
    .setNominalV(225.)
    .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
    .add();

  vl2.getBusBreakerView().newBus().setId("VL2_BUS1").add().setAngle(1.5).setV(150.);

  network->newLine()
    .setId("LINE_VL1_VL2")
    .setVoltageLevel1("VL1")
    .setBus1("VL1_BUS1")
    .setVoltageLevel2("VL2")
    .setBus2("VL2_BUS1")
    .setR(3.0)
    .setX(33.33)
    .setG1(1.0)
    .setB1(0.2)
    .setG2(2.0)
    .setB2(0.4)
    .add();

  substation.newTwoWindingsTransformer()
    .setId("2WT_VL1_VL2")
    .setVoltageLevel1(vl1.getId())
    .setBus1("VL1_BUS1")
    .setVoltageLevel2(vl2.getId())
    .setBus2("VL2_BUS1")
    .setR(3.0)
    .setX(33.0)
    .setG(1.0)
    .setB(0.2)
    .setRatedU1(2.0)
    .setRatedU2(0.4)
    .setRatedS(3.0)
    .add();

  auto& vl3 = substation.newVoltageLevel()
    .setId("VL3")
    .setNominalV(360.)
    .setTopologyKind(powsybl::iidm::TopologyKind::NODE_BREAKER)
    .add();

  vl3.getNodeBreakerView().newBusbarSection()
    .setId("VL3_BBS")
    .setNode(0)
    .add();

  vl3.getNodeBreakerView().newSwitch()
    .setId("VL3_SW01")
    .setKind(powsybl::iidm::SwitchKind::BREAKER)
    .setNode1(0)
    .setNode2(1)
    .setRetained(true)
    .add();

  vl3.newLoad()
    .setId("VL3_LOAD")
    .setNode(1)
    .setP0(5000.)
    .setQ0(4000.)
    .add();

#else
  IIDM::builders::NetworkBuilder nb;
  shared_ptr<IIDM::Network> network = boost::make_shared<IIDM::Network>(nb.build("test"));

  IIDM::builders::SubstationBuilder ssb;
  IIDM::Substation ss1 = ssb.build("SUB");

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::bus_breaker);
  IIDM::VoltageLevel vl1 = vlb.nominalV(380.).build("VL1");

  IIDM::builders::BusBuilder bb;
  bb.v(150).angle(1.5);
  vl1.add(bb.build("VL1_BUS1"));
  vl1.add(bb.build("VL1_BUS2"));

  IIDM::builders::SwitchBuilder sb;
  vl1.add(sb.opened(false).build("VL1_SW12"), "VL1_BUS1", "VL1_BUS2");

  IIDM::connection_status_t cs = {true /*connected*/};
  IIDM::Port p1("VL1_BUS1", cs);
  IIDM::Connection c1("VL1", p1, IIDM::side_1);

  IIDM::builders::LoadBuilder ldb;
  vl1.add(ldb.p0(5000.).q0(4000.).build("VL1_LOAD"), c1);

  ss1.add(vl1);

  IIDM::VoltageLevel vl2 = vlb.nominalV(225.).build("VL2");

  vl2.add(bb.build("VL2_BUS1"));

  ss1.add(vl2);

  IIDM::Port p2("VL2_BUS1", cs);
  IIDM::Connection c2("VL2", p2, IIDM::side_2);

  IIDM::builders::Transformer2WindingsBuilder t2Wb;
  ss1.add(t2Wb.build("2WT_VL1_VL2"), c1, c2);

  vlb.mode(IIDM::VoltageLevel::node_breaker);
  IIDM::VoltageLevel vl3 = vlb.nominalV(360.).node_count(2).build("VL3");

  IIDM::builders::BusBarSectionBuilder bbsb;
  vl3.add(bbsb.node(0).build("VL3_BBS"));

  vl3.add(sb.opened(false).retained(true).build("VL3_SW01"), 0, 1);

  IIDM::Port p3(1);
  IIDM::Connection c3("VL3", p3, IIDM::side_1);

  vl3.add(ldb.build("VL3_LOAD"), c3);

  ss1.add(vl3);

  network->add(ss1);

  IIDM::builders::LineBuilder lnb;
  network->add(lnb.build("LINE_VL1_VL2"), c1, c2);
#endif

  shared_ptr<DataInterfaceIIDM> data(new DataInterfaceIIDM(network));
  data->initFromIIDM();
  exportStateVariables(data);

  shared_ptr<SwitchInterface> sw = data->getNetwork()->getVoltageLevels()[0]->getSwitches()[0];
  shared_ptr<LoadInterface> load = data->getNetwork()->getVoltageLevels()[0]->getLoads()[0];
  shared_ptr<LineInterface> line = data->getNetwork()->getLines()[0];
  shared_ptr<TwoWTransformerInterface> tfo = data->getNetwork()->getTwoWTransformers()[0];

  const int SWITCH_STATE = sw->getComponentVarIndex("state");
  const int LOAD_STATE = load->getComponentVarIndex("state");
  const int LINE_STATE = line->getComponentVarIndex("state");
  const int TRANSF_STATE = tfo->getComponentVarIndex("state");

  ///
  // BUS_BREAKER cases
  ///

  // all from CLOSED to CLOSED
  shared_ptr<std::vector<shared_ptr<ComponentInterface> > > connectedComponents = data->findConnectedComponents();
  shared_ptr<lostEquipments::LostEquipmentsCollection> lostEquipments = data->findLostEquipments(connectedComponents);
  lostEquipments::LostEquipmentsCollection::LostEquipmentsCollectionConstIterator itLostEquipment = lostEquipments->cbegin();
  ASSERT_TRUE(itLostEquipment == lostEquipments->cend());

  // switch from CLOSED to OPEN
  sw->setValue(SWITCH_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  lostEquipments = data->findLostEquipments(connectedComponents);
  itLostEquipment = lostEquipments->cbegin();
  ASSERT_TRUE(itLostEquipment != lostEquipments->cend());
  ASSERT_EQ((*itLostEquipment)->getId(), sw->getID());
  ASSERT_EQ((*itLostEquipment)->getType(), sw->getTypeAsString());
  ASSERT_TRUE(++itLostEquipment == lostEquipments->cend());

  // load from CLOSED to OPEN
  connectedComponents = data->findConnectedComponents();
  load->setValue(LOAD_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  lostEquipments = data->findLostEquipments(connectedComponents);
  itLostEquipment = lostEquipments->cbegin();
  ASSERT_TRUE(itLostEquipment != lostEquipments->cend());
  ASSERT_EQ((*itLostEquipment)->getId(), load->getID());
  ASSERT_EQ((*itLostEquipment)->getType(), load->getTypeAsString());
  ASSERT_TRUE(++itLostEquipment == lostEquipments->cend());

  // line from CLOSED to OPEN
  connectedComponents = data->findConnectedComponents();
  line->setValue(LINE_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  lostEquipments = data->findLostEquipments(connectedComponents);
  itLostEquipment = lostEquipments->cbegin();
  ASSERT_TRUE(itLostEquipment != lostEquipments->cend());
  ASSERT_EQ((*itLostEquipment)->getId(), line->getID());
  ASSERT_EQ((*itLostEquipment)->getType(), line->getTypeAsString());
  ASSERT_TRUE(++itLostEquipment == lostEquipments->cend());

  // transf from CLOSED to OPEN
  connectedComponents = data->findConnectedComponents();
  tfo->setValue(TRANSF_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  lostEquipments = data->findLostEquipments(connectedComponents);
  itLostEquipment = lostEquipments->cbegin();
  ASSERT_TRUE(itLostEquipment != lostEquipments->cend());
  ASSERT_EQ((*itLostEquipment)->getId(), tfo->getID());
  ASSERT_EQ((*itLostEquipment)->getType(), tfo->getTypeAsString());
  ASSERT_TRUE(++itLostEquipment == lostEquipments->cend());

  // all from OPEN to OPEN
  connectedComponents = data->findConnectedComponents();
  lostEquipments = data->findLostEquipments(connectedComponents);
  ASSERT_TRUE(lostEquipments->cbegin() == lostEquipments->cend());

  // all from OPEN to CLOSED
  sw->setValue(SWITCH_STATE, CLOSED);
  load->setValue(LOAD_STATE, CLOSED);
  line->setValue(LINE_STATE, CLOSED);
  tfo->setValue(TRANSF_STATE, CLOSED);
  data->exportStateVariablesNoReadFromModel();
  lostEquipments = data->findLostEquipments(connectedComponents);
  ASSERT_TRUE(lostEquipments->cbegin() == lostEquipments->cend());

  // line from CLOSED to CLOSED_1
  connectedComponents = data->findConnectedComponents();
  line->setValue(LINE_STATE, CLOSED_1);
  data->exportStateVariablesNoReadFromModel();
  lostEquipments = data->findLostEquipments(connectedComponents);
  itLostEquipment = lostEquipments->cbegin();
  ASSERT_TRUE(itLostEquipment != lostEquipments->cend());
  ASSERT_EQ((*itLostEquipment)->getId(), line->getID());
  ASSERT_EQ((*itLostEquipment)->getType(), line->getTypeAsString());
  ASSERT_TRUE(++itLostEquipment == lostEquipments->cend());

  // transf from CLOSED to CLOSED_2
  connectedComponents = data->findConnectedComponents();
  tfo->setValue(TRANSF_STATE, CLOSED_2);
  data->exportStateVariablesNoReadFromModel();
  lostEquipments = data->findLostEquipments(connectedComponents);
  itLostEquipment = lostEquipments->cbegin();
  ASSERT_TRUE(itLostEquipment != lostEquipments->cend());
  ASSERT_EQ((*itLostEquipment)->getId(), tfo->getID());
  ASSERT_EQ((*itLostEquipment)->getType(), tfo->getTypeAsString());
  ASSERT_TRUE(++itLostEquipment == lostEquipments->cend());

  // switch from CLOSED to CLOSED_3 (no sense: it's for test only)
  connectedComponents = data->findConnectedComponents();
  sw->setValue(SWITCH_STATE, CLOSED_3);
  data->exportStateVariablesNoReadFromModel();
  lostEquipments = data->findLostEquipments(connectedComponents);
  itLostEquipment = lostEquipments->cbegin();
  ASSERT_TRUE(itLostEquipment != lostEquipments->cend());
  ASSERT_EQ((*itLostEquipment)->getId(), sw->getID());
  ASSERT_EQ((*itLostEquipment)->getType(), sw->getTypeAsString());
  ASSERT_TRUE(++itLostEquipment == lostEquipments->cend());

  // line, transf and switch from CLOSED_* to OPEN
  connectedComponents = data->findConnectedComponents();
  line->setValue(LINE_STATE, OPEN);
  tfo->setValue(TRANSF_STATE, OPEN);
  sw->setValue(SWITCH_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  lostEquipments = data->findLostEquipments(connectedComponents);
  ASSERT_TRUE(lostEquipments->cbegin() == lostEquipments->cend());

  // all from CLOSED to OPEN
  sw->setValue(SWITCH_STATE, CLOSED);
  load->setValue(LOAD_STATE, CLOSED);
  line->setValue(LINE_STATE, CLOSED);
  tfo->setValue(TRANSF_STATE, CLOSED);
  data->exportStateVariablesNoReadFromModel();
  connectedComponents = data->findConnectedComponents();
  sw->setValue(SWITCH_STATE, OPEN);
  load->setValue(LOAD_STATE, OPEN);
  line->setValue(LINE_STATE, OPEN);
  tfo->setValue(TRANSF_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  lostEquipments = data->findLostEquipments(connectedComponents);
  std::map<std::string, std::string> mapIdToType;
  for (itLostEquipment = lostEquipments->cbegin(); itLostEquipment != lostEquipments->cend(); ++itLostEquipment) {
    mapIdToType[(*itLostEquipment)->getId()] = (*itLostEquipment)->getType();
  }
  ASSERT_EQ(mapIdToType.size(), 4);
  ASSERT_EQ(mapIdToType[sw->getID()], sw->getTypeAsString());
  ASSERT_EQ(mapIdToType[load->getID()], load->getTypeAsString());
  ASSERT_EQ(mapIdToType[line->getID()], line->getTypeAsString());
  ASSERT_EQ(mapIdToType[tfo->getID()], tfo->getTypeAsString());

  ///
  // NODE_BREAKER case
  ///

  shared_ptr<SwitchInterface> swNB = data->getNetwork()->getVoltageLevels()[2]->getSwitches()[0];
  shared_ptr<LoadInterface> loadNB = data->getNetwork()->getVoltageLevels()[2]->getLoads()[0];
  connectedComponents = data->findConnectedComponents();
  swNB->setValue(SWITCH_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  lostEquipments = data->findLostEquipments(connectedComponents);
  mapIdToType.clear();
  for (itLostEquipment = lostEquipments->cbegin(); itLostEquipment != lostEquipments->cend(); ++itLostEquipment) {
    mapIdToType[(*itLostEquipment)->getId()] = (*itLostEquipment)->getType();
  }
  ASSERT_EQ(mapIdToType.size(), 2);
  ASSERT_EQ(mapIdToType[swNB->getID()], swNB->getTypeAsString());
  ASSERT_EQ(mapIdToType[loadNB->getID()], loadNB->getTypeAsString());
}

}  // namespace DYN
