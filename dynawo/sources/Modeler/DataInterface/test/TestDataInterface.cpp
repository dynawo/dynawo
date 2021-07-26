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
#include "DYNModelMulti.h"
#include "DYNNetworkInterface.h"
#include "DYNSubModel.h"
#include "DYNSubModelFactory.h"
#include "DYNSwitchInterface.h"
#include "DYNVoltageLevelInterface.h"
#include "LEQLostEquipmentsCollectionFactory.h"
#include "PARParametersSet.h"

#ifdef USE_POWSYBL
#include "PowSyblIIDM/DYNDataInterfaceIIDM.h"

#include <powsybl/iidm/GeneratorAdder.hpp>
#include <powsybl/iidm/LoadAdder.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/TopologyKind.hpp>

#else
#include "IIDM/DYNDataInterfaceIIDM.h"
#include "IIDM/DYNGeneratorInterfaceIIDM.h"
#include "IIDM/DYNLoadInterfaceIIDM.h"
#include "IIDM/DYNSwitchInterfaceIIDM.h"

#include <IIDM/builders/BusBuilder.h>
#include <IIDM/builders/GeneratorBuilder.h>
#include <IIDM/builders/LoadBuilder.h>
#include <IIDM/builders/NetworkBuilder.h>
#include <IIDM/builders/SubstationBuilder.h>
#include <IIDM/builders/SwitchBuilder.h>
#include <IIDM/builders/VoltageLevelBuilder.h>
#endif

using boost::shared_ptr;

namespace DYN {

shared_ptr<SubModel>
initializeModel(shared_ptr<DataInterface> data) {
  shared_ptr<SubModel> modelNetwork = SubModelFactory::createSubModelFromLib("../../../Models/CPP/ModelNetwork/DYNModelNetwork" +
                                                                             std::string(sharedLibraryExtension()));
  modelNetwork->initFromData(data);
  data->setModelNetwork(modelNetwork);
  modelNetwork->name("NETWORK");
  shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
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

void
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
  auto network = boost::make_shared<powsybl::iidm::Network>("MyNetwork", "MyNetwork");

  auto& substation = network->newSubstation()
    .setId("MySubStation")
    .add();

  auto& vl = substation.newVoltageLevel()
    .setId("MyVoltageLevel")
    .setNominalV(5.)
    .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
    .add();

  vl.getBusBreakerView().newBus().setId("MyBus1").add();
  vl.getBusBreakerView().newBus().setId("MyBus2").add();

  vl.getBusBreakerView().newSwitch()
    .setId("MySwitch")
    .setBus1("MyBus1")
    .setBus2("MyBus2")
    .add();

  vl.newLoad()
    .setId("MyLoad")
    .setBus("MyBus1")
    .setP0(50.0)
    .setQ0(40.0)
    .add();

  vl.newGenerator()
    .setId("MyGenerator")
    .setBus("MyBus2")
    .setMaxP(50.0)
    .setMinP(3.0)
    .setTargetP(45.0)
    .setTargetQ(5.0)
    .setVoltageRegulatorOn(false)
    .add();
#else
  IIDM::connection_status_t cs = {true /*connected*/};
  IIDM::Port p1("MyBus1", cs), p2("MyBus2", cs);
  IIDM::Connection c1("MyVoltageLevel", p1, IIDM::side_1), c2("MyVoltageLevel", p2, IIDM::side_2);

  IIDM::builders::NetworkBuilder nb;
  boost::shared_ptr<IIDM::Network> network = boost::make_shared<IIDM::Network>(nb.build("MyNetwork"));

  IIDM::builders::SubstationBuilder ssb;
  IIDM::Substation ss = ssb.build("MySubStation");

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::bus_breaker);
  vlb.nominalV(5.);
  IIDM::VoltageLevel vl = vlb.build("MyVoltageLevel");

  IIDM::builders::BusBuilder bb;
  vl.add(bb.build("MyBus1"));
  vl.add(bb.build("MyBus2"));

  IIDM::builders::SwitchBuilder sb;
  vl.add(sb.build("MySwitch"), "MyBus1", "MyBus2");

  IIDM::builders::LoadBuilder lb;
  lb.p0(50.);
  lb.q0(40.);
  vl.add(lb.build("MyLoad"), c1);

  IIDM::builders::GeneratorBuilder gb;
  IIDM::MinMaxReactiveLimits limits(1., 20.);
  gb.minMaxReactiveLimits(limits);
  gb.targetP(-105.);
  gb.pmin(3.);
  gb.pmax(50.);
  gb.energySource(IIDM::Generator::source_nuclear);
  IIDM::Generator g = gb.build("MyGenerator");
  g.p(-105.);
  g.q(-90.);
  g.targetQ(-90.);
  g.targetV(150.);
  g.connectTo("MyVoltageLevel", p2);
  vl.add(g);

  ss.add(vl);
  network->add(ss);
#endif

  shared_ptr<DataInterfaceIIDM> data(new DataInterfaceIIDM(network));
  data->initFromIIDM();
  exportStateVariables(data);

  boost::shared_ptr<SwitchInterface> sw = data->getNetwork()->getVoltageLevels()[0]->getSwitches()[0];
  boost::shared_ptr<LoadInterface> load = data->getNetwork()->getVoltageLevels()[0]->getLoads()[0];
  boost::shared_ptr<GeneratorInterface> gen = data->getNetwork()->getVoltageLevels()[0]->getGenerators()[0];

  // all CLOSED to CLOSED
  data->backupConnectionState();
  shared_ptr<lostEquipments::LostEquipmentsCollection> lostEquipments = lostEquipments::LostEquipmentsCollectionFactory::newInstance();
  data->findLostEquipments(lostEquipments);
  lostEquipments::LostEquipmentsCollection::LostEquipmentsCollectionConstIterator itLostEquipment = lostEquipments->cbegin();
  ASSERT_EQ(lostEquipments->cbegin(), lostEquipments->cend());

  // switch CLOSED to OPEN
  sw->setValue(SwitchInterfaceIIDM::VAR_STATE, OPEN);
  data->findLostEquipments(lostEquipments);
  itLostEquipment = lostEquipments->cbegin();
  ASSERT_NE(itLostEquipment, lostEquipments->cend());
  ASSERT_EQ((*itLostEquipment)->getId(), sw->getID());
  ASSERT_EQ((*itLostEquipment)->getType(), sw->getTypeAsString());
  ASSERT_EQ(++itLostEquipment, lostEquipments->cend());

  // load CLOSED to OPEN
  data->backupConnectionState();
  load->setValue(LoadInterfaceIIDM::VAR_STATE, OPEN);
  lostEquipments = lostEquipments::LostEquipmentsCollectionFactory::newInstance();
  data->findLostEquipments(lostEquipments);
  itLostEquipment = lostEquipments->cbegin();
  ASSERT_NE(itLostEquipment, lostEquipments->cend());
  ASSERT_EQ((*itLostEquipment)->getId(), load->getID());
  ASSERT_EQ((*itLostEquipment)->getType(), load->getTypeAsString());
  ASSERT_EQ(++itLostEquipment, lostEquipments->cend());

  // generator CLOSED to OPEN
  data->backupConnectionState();
  gen->setValue(GeneratorInterfaceIIDM::VAR_STATE, OPEN);
  lostEquipments = lostEquipments::LostEquipmentsCollectionFactory::newInstance();
  data->findLostEquipments(lostEquipments);
  itLostEquipment = lostEquipments->cbegin();
  ASSERT_NE(itLostEquipment, lostEquipments->cend());
  ASSERT_EQ((*itLostEquipment)->getId(), gen->getID());
  ASSERT_EQ((*itLostEquipment)->getType(), gen->getTypeAsString());
  ASSERT_EQ(++itLostEquipment, lostEquipments->cend());

  // all OPEN to OPEN
  data->backupConnectionState();
  lostEquipments = lostEquipments::LostEquipmentsCollectionFactory::newInstance();
  data->findLostEquipments(lostEquipments);
  ASSERT_EQ(lostEquipments->cbegin(), lostEquipments->cend());

  // all OPEN to CLOSED
  sw->setValue(SwitchInterfaceIIDM::VAR_STATE, CLOSED);
  load->setValue(LoadInterfaceIIDM::VAR_STATE, CLOSED);
  gen->setValue(GeneratorInterfaceIIDM::VAR_STATE, CLOSED);
  data->findLostEquipments(lostEquipments);
  ASSERT_EQ(lostEquipments->cbegin(), lostEquipments->cend());

  // switch CLOSED to CLOSED_1
  data->backupConnectionState();
  sw->setValue(SwitchInterfaceIIDM::VAR_STATE, CLOSED_1);
  data->findLostEquipments(lostEquipments);
  itLostEquipment = lostEquipments->cbegin();
  ASSERT_NE(itLostEquipment, lostEquipments->cend());
  ASSERT_EQ((*itLostEquipment)->getId(), sw->getID());
  ASSERT_EQ((*itLostEquipment)->getType(), sw->getTypeAsString());
  ASSERT_EQ(++itLostEquipment, lostEquipments->cend());

  // load CLOSED to CLOSED_2
  data->backupConnectionState();
  load->setValue(LoadInterfaceIIDM::VAR_STATE, CLOSED_2);
  lostEquipments = lostEquipments::LostEquipmentsCollectionFactory::newInstance();
  data->findLostEquipments(lostEquipments);
  itLostEquipment = lostEquipments->cbegin();
  ASSERT_NE(itLostEquipment, lostEquipments->cend());
  ASSERT_EQ((*itLostEquipment)->getId(), load->getID());
  ASSERT_EQ((*itLostEquipment)->getType(), load->getTypeAsString());
  ASSERT_EQ(++itLostEquipment, lostEquipments->cend());

  // generator CLOSED to CLOSED_3
  data->backupConnectionState();
  gen->setValue(GeneratorInterfaceIIDM::VAR_STATE, CLOSED_3);
  lostEquipments = lostEquipments::LostEquipmentsCollectionFactory::newInstance();
  data->findLostEquipments(lostEquipments);
  itLostEquipment = lostEquipments->cbegin();
  ASSERT_NE(itLostEquipment, lostEquipments->cend());
  ASSERT_EQ((*itLostEquipment)->getId(), gen->getID());
  ASSERT_EQ((*itLostEquipment)->getType(), gen->getTypeAsString());
  ASSERT_EQ(++itLostEquipment, lostEquipments->cend());

  // all CLOSED_* to OPEN
  data->backupConnectionState();
  sw->setValue(SwitchInterfaceIIDM::VAR_STATE, OPEN);
  load->setValue(LoadInterfaceIIDM::VAR_STATE, OPEN);
  gen->setValue(GeneratorInterfaceIIDM::VAR_STATE, OPEN);
  lostEquipments = lostEquipments::LostEquipmentsCollectionFactory::newInstance();
  data->findLostEquipments(lostEquipments);
  ASSERT_EQ(lostEquipments->cbegin(), lostEquipments->cend());

  // all CLOSED to OPEN
  sw->setValue(SwitchInterfaceIIDM::VAR_STATE, CLOSED);
  load->setValue(LoadInterfaceIIDM::VAR_STATE, CLOSED);
  gen->setValue(GeneratorInterfaceIIDM::VAR_STATE, CLOSED);
  data->backupConnectionState();
  sw->setValue(SwitchInterfaceIIDM::VAR_STATE, OPEN);
  load->setValue(LoadInterfaceIIDM::VAR_STATE, OPEN);
  gen->setValue(GeneratorInterfaceIIDM::VAR_STATE, OPEN);
  lostEquipments = lostEquipments::LostEquipmentsCollectionFactory::newInstance();
  data->findLostEquipments(lostEquipments);
  std::map<std::string, std::string> mapIdToType;
  for (itLostEquipment = lostEquipments->cbegin(); itLostEquipment != lostEquipments->cend(); ++itLostEquipment) {
    mapIdToType[(*itLostEquipment)->getId()] = (*itLostEquipment)->getType();
  }
  ASSERT_EQ(mapIdToType.size(), 3);
  ASSERT_EQ(mapIdToType[sw->getID()], sw->getTypeAsString());
  ASSERT_EQ(mapIdToType[load->getID()], load->getTypeAsString());
  ASSERT_EQ(mapIdToType[gen->getID()], gen->getTypeAsString());
}

}  // namespace DYN
