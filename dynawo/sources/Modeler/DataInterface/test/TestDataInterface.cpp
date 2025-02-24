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
#include "PARParametersSetFactory.h"

#include "DYNDataInterfaceIIDM.h"

#include <powsybl/iidm/LineAdder.hpp>
#include <powsybl/iidm/LoadAdder.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/TwoWindingsTransformerAdder.hpp>
#include <powsybl/iidm/GeneratorAdder.hpp>
#include <powsybl/iidm/ShuntCompensatorAdder.hpp>
#include <powsybl/iidm/StaticVarCompensatorAdder.hpp>
#include <powsybl/iidm/DanglingLineAdder.hpp>
#include <powsybl/iidm/ThreeWindingsTransformerAdder.hpp>
#include <powsybl/iidm/LccConverterStationAdder.hpp>
#include <powsybl/iidm/HvdcLineAdder.hpp>
#include <powsybl/iidm/VscConverterStationAdder.hpp>
#include <powsybl/iidm/TopologyKind.hpp>

using boost::shared_ptr;

namespace DYN {

static shared_ptr<SubModel>
initializeModel(shared_ptr<DataInterface> data) {
  shared_ptr<SubModel> modelNetwork = SubModelFactory::createSubModelFromLib("../../../../M/CPP/ModelNetwork/DYNModelNetwork" +
                                                                             std::string(sharedLibraryExtension()));
  modelNetwork->initFromData(data);
  data->setModelNetwork(modelNetwork);
  modelNetwork->name("NETWORK");
  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
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
  parametersSet->createParameter("deactivateRootFunctions", false);
  parametersSet->createParameter("generator_isVoltageDependant", false);
  parametersSet->createParameter("generator_alpha", 1.5);
  parametersSet->createParameter("generator_beta", 2.5);
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

static shared_ptr<powsybl::iidm::Network>

initIIDMNetwork() {
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

  vl2.newGenerator()
    .setId("VL2_GENERATOR")
    .setBus("VL2_BUS1")
    .setMinP(0.)
    .setMaxP(1.)
    .setTargetP(1.)
    .setVoltageRegulatorOn(true)
    .setTargetV(1.)
    .setTargetQ(0.)
    .add();

  vl2.newShuntCompensator()
    .setId("VL2_SHUNT1")
    .setName("SHUNT1_NAME")
    .setBus("VL2_BUS1")
    .newLinearModel()
    .setBPerSection(12.0)
    .setMaximumSectionCount(3UL)
    .add()
    .setSectionCount(2UL)
    .add();

  vl2.newStaticVarCompensator()
    .setId("VL2_SVC1")
    .setName("SVC1_NAME")
    .setBus("VL2_BUS1")
    .setBmin(-0.01)
    .setBmax(0.02)
    .setVoltageSetpoint(380.0)
    .setReactivePowerSetpoint(90.0)
    .setRegulationMode(powsybl::iidm::StaticVarCompensator::RegulationMode::OFF)
    .add();

  vl2.newDanglingLine()
    .setId("DANGLING_LINE1")
    .setBus("VL2_BUS1")
    .setName("DANGLING_LINE1_NAME")
    .setB(1.0)
    .setG(2.0)
    .setP0(3.0)
    .setQ0(4.0)
    .setR(5.0)
    .setX(6.0)
    .setUcteXnodeCode("ucteXnodeCodeTest")
    .add();

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

  vl1.newLccConverterStation()
    .setId("LCC1")
    .setName("LCC1_NAME")
    .setBus("VL1_BUS1")
    .setConnectableBus("VL1_BUS1")
    .setLossFactor(2.0)
    .setPowerFactor(-.2)
    .add();

  vl1.newLccConverterStation()
    .setId("LCC2")
    .setName("LCC2_NAME")
    .setBus("VL1_BUS1")
    .setConnectableBus("VL1_BUS1")
    .setLossFactor(2.0)
    .setPowerFactor(-.2)
    .add();

  network->newHvdcLine()
    .setId("HVDC1")
    .setName("HVDC1_NAME")
    .setActivePowerSetpoint(111.1)
    .setConvertersMode(powsybl::iidm::HvdcLine::ConvertersMode::SIDE_1_RECTIFIER_SIDE_2_INVERTER)
    .setConverterStationId1("LCC1")
    .setConverterStationId2("LCC2")
    .setMaxP(12.0)
    .setNominalV(13.0)
    .setR(14.0)
    .add();

  return network;
}

TEST(DataInterfaceTest, testLostEquipments) {
  auto network = initIIDMNetwork();

  shared_ptr<DataInterfaceIIDM> data(new DataInterfaceIIDM(network));
  data->initFromIIDM();
  exportStateVariables(data);

  std::shared_ptr<SwitchInterface> sw = data->getNetwork()->getVoltageLevels()[0]->getSwitches()[0];
  std::shared_ptr<LoadInterface> load = data->getNetwork()->getVoltageLevels()[0]->getLoads()[0];
  std::shared_ptr<LineInterface> line = data->getNetwork()->getLines()[0];
  std::shared_ptr<TwoWTransformerInterface> tfo = data->getNetwork()->getTwoWTransformers()[0];

  const int SWITCH_STATE = sw->getComponentVarIndex("state");
  const int LOAD_STATE = load->getComponentVarIndex("state");
  const int LINE_STATE = line->getComponentVarIndex("state");
  const int TRANSF_STATE = tfo->getComponentVarIndex("state");

  ///
  // BUS_BREAKER cases
  ///

  // all from CLOSED to CLOSED
  std::shared_ptr<std::vector<std::shared_ptr<ComponentInterface> > > connectedComponents = data->findConnectedComponents();
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
  ASSERT_TRUE(itLostEquipment == lostEquipments->cend());

  // line from CLOSED_1 to OPEN
  connectedComponents = data->findConnectedComponents();
  line->setValue(LINE_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  lostEquipments = data->findLostEquipments(connectedComponents);
  itLostEquipment = lostEquipments->cbegin();
  ASSERT_TRUE(itLostEquipment != lostEquipments->cend());
  ASSERT_EQ((*itLostEquipment)->getId(), line->getID());
  ASSERT_EQ((*itLostEquipment)->getType(), line->getTypeAsString());
  ASSERT_TRUE(++itLostEquipment == lostEquipments->cend());


  line->setValue(LINE_STATE, CLOSED);
  data->exportStateVariablesNoReadFromModel();

  // transf from CLOSED to CLOSED_2
  connectedComponents = data->findConnectedComponents();
  tfo->setValue(TRANSF_STATE, CLOSED_2);
  data->exportStateVariablesNoReadFromModel();
  lostEquipments = data->findLostEquipments(connectedComponents);
  itLostEquipment = lostEquipments->cbegin();
  ASSERT_TRUE(itLostEquipment == lostEquipments->cend());

  // transf from CLOSED_2 to OPEN
  connectedComponents = data->findConnectedComponents();
  tfo->setValue(TRANSF_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  lostEquipments = data->findLostEquipments(connectedComponents);
  itLostEquipment = lostEquipments->cbegin();
  ASSERT_TRUE(itLostEquipment != lostEquipments->cend());
  ASSERT_EQ((*itLostEquipment)->getId(), tfo->getID());
  ASSERT_EQ((*itLostEquipment)->getType(), tfo->getTypeAsString());
  ASSERT_TRUE(++itLostEquipment == lostEquipments->cend());

  tfo->setValue(TRANSF_STATE, CLOSED);
  data->exportStateVariablesNoReadFromModel();

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

  line->setValue(LINE_STATE, CLOSED_1);
  tfo->setValue(TRANSF_STATE, CLOSED_2);
  data->exportStateVariablesNoReadFromModel();

  // line, transf and switch from CLOSED_* to OPEN
  connectedComponents = data->findConnectedComponents();
  line->setValue(LINE_STATE, OPEN);
  tfo->setValue(TRANSF_STATE, OPEN);
  sw->setValue(SWITCH_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  lostEquipments = data->findLostEquipments(connectedComponents);
  std::map<std::string, std::string> mapIdToType;
  for (itLostEquipment = lostEquipments->cbegin(); itLostEquipment != lostEquipments->cend(); ++itLostEquipment) {
    mapIdToType[(*itLostEquipment)->getId()] = (*itLostEquipment)->getType();
  }
  ASSERT_EQ(mapIdToType.size(), 2);
  ASSERT_EQ(mapIdToType[line->getID()], line->getTypeAsString());
  ASSERT_EQ(mapIdToType[tfo->getID()], tfo->getTypeAsString());

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
  mapIdToType.clear();
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

  std::shared_ptr<SwitchInterface> swNB = data->getNetwork()->getVoltageLevels()[2]->getSwitches()[0];
  std::shared_ptr<LoadInterface> loadNB = data->getNetwork()->getVoltageLevels()[2]->getLoads()[0];
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

TEST(DataInterfaceTest, testInstatiateNetwork) {
  auto network = initIIDMNetwork();

  shared_ptr<DataInterfaceIIDM> data(new DataInterfaceIIDM(network));
  data->initFromIIDM();

  ASSERT_TRUE(data->instantiateNetwork());
  data->hasDynamicModel("VL1_BUS1");
  ASSERT_TRUE(data->instantiateNetwork());
  data->hasDynamicModel("VL1_BUS2");
  ASSERT_TRUE(data->instantiateNetwork());
  data->hasDynamicModel("VL2_BUS1");
  ASSERT_TRUE(data->instantiateNetwork());
  data->hasDynamicModel("calculatedBus_VL3_0");
  ASSERT_TRUE(data->instantiateNetwork());
  data->hasDynamicModel("calculatedBus_VL3_1");
  ASSERT_TRUE(data->instantiateNetwork());
  data->hasDynamicModel("VL1_SW12");
  ASSERT_TRUE(data->instantiateNetwork());
  data->hasDynamicModel("VL3_SW01");
  ASSERT_TRUE(data->instantiateNetwork());
  data->hasDynamicModel("VL1_LOAD1");
  ASSERT_TRUE(data->instantiateNetwork());
  data->hasDynamicModel("VL3_LOAD");
  ASSERT_TRUE(data->instantiateNetwork());
  data->hasDynamicModel("VL2_GENERATOR");
  ASSERT_TRUE(data->instantiateNetwork());
  data->hasDynamicModel("VL2_SHUNT1");
  ASSERT_TRUE(data->instantiateNetwork());
  data->hasDynamicModel("VL2_SVC1");
  ASSERT_TRUE(data->instantiateNetwork());
  data->hasDynamicModel("DANGLING_LINE1");
  ASSERT_TRUE(data->instantiateNetwork());
  data->hasDynamicModel("LINE_VL1_VL2");
  ASSERT_TRUE(data->instantiateNetwork());
  data->hasDynamicModel("2WT_VL1_VL2");
  ASSERT_TRUE(data->instantiateNetwork());
  data->hasDynamicModel("HVDC1");
  ASSERT_FALSE(data->instantiateNetwork());
}

}  // namespace DYN
