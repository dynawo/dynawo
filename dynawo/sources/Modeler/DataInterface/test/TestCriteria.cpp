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
 * @file Modeler/DataInterface/test/TestIIDMModels.cpp
 * @brief Unit tests for DataInterface/*IIDM classes
 *
 */


#include <IIDM/Network.h>
#include <IIDM/components/Connection.h>
#include <IIDM/components/ConnectionPoint.h>
#include <IIDM/components/TapChanger.h>
#include <IIDM/components/Bus.h>
#include <IIDM/components/BusBarSection.h>
#include <IIDM/components/VoltageLevel.h>
#include <IIDM/components/ShuntCompensator.h>
#include <IIDM/components/Substation.h>
#include <IIDM/components/StaticVarCompensator.h>
#include <IIDM/components/DanglingLine.h>
#include <IIDM/components/HvdcLine.h>
#include <IIDM/components/Generator.h>
#include <IIDM/components/LccConverterStation.h>
#include <IIDM/components/HvdcLine.h>
#include <IIDM/components/Line.h>
#include <IIDM/components/Load.h>
#include <IIDM/components/Switch.h>
#include <IIDM/components/VscConverterStation.h>
#include <IIDM/builders/NetworkBuilder.h>
#include <IIDM/builders/Transformer2WindingsBuilder.h>
#include <IIDM/builders/Transformer3WindingsBuilder.h>
#include <IIDM/builders/VoltageLevelBuilder.h>
#include <IIDM/builders/ShuntCompensatorBuilder.h>
#include <IIDM/builders/SubstationBuilder.h>
#include <IIDM/builders/BusBuilder.h>
#include <IIDM/builders/BusBarSectionBuilder.h>
#include <IIDM/builders/StaticVarCompensatorBuilder.h>
#include <IIDM/builders/DanglingLineBuilder.h>
#include <IIDM/builders/HvdcLineBuilder.h>
#include <IIDM/builders/GeneratorBuilder.h>
#include <IIDM/builders/LccConverterStationBuilder.h>
#include <IIDM/builders/HvdcLineBuilder.h>
#include <IIDM/builders/LineBuilder.h>
#include <IIDM/builders/LoadBuilder.h>
#include <IIDM/builders/SwitchBuilder.h>
#include <IIDM/builders/VscConverterStationBuilder.h>
#include <IIDM/extensions/standbyAutomaton/StandbyAutomaton.h>
#include <IIDM/extensions/standbyAutomaton/StandbyAutomatonBuilder.h>

#include "gtest_dynawo.h"
#include "DYNDataInterfaceIIDM.h"
#include "DYNSubModelFactory.h"
#include "DYNSubModel.h"
#include "PARParametersSetFactory.h"
#include "DYNModelMulti.h"
#include "DYNNetworkInterface.h"
#include "DYNTwoWTransformerInterface.h"
#include "DYNModelConstants.h"
#include "DYNVoltageLevelInterface.h"
#include "DYNLoadInterface.h"
#include "DYNCriteria.h"
#include "CRTCriteria.h"
#include "CRTCriteriaFactory.h"
#include "CRTCriteriaParams.h"
#include "CRTCriteriaParamsFactory.h"
#include "CRTCriteriaCollection.h"
#include "CRTCriteriaCollectionFactory.h"

using boost::shared_ptr;
using criteria::CriteriaFactory;
using criteria::CriteriaParams;
using criteria::CriteriaParamsFactory;
using criteria::CriteriaCollection;
using criteria::CriteriaCollectionFactory;

namespace DYN {

shared_ptr<DataInterface>
createBusBreakerNetwork(double busV, double busVNom) {
  IIDM::builders::NetworkBuilder nb;
  IIDM::Network network = nb.build("MyNetwork");

  IIDM::builders::SubstationBuilder ssb;
  IIDM::Substation ss = ssb.build("MySubStation");

  IIDM::builders::BusBuilder bb;
  bb.v(busV);
  bb.angle(1.5);
  IIDM::Bus bus = bb.build("MyBus");

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::bus_breaker);
  vlb.nominalV(busVNom);
  IIDM::VoltageLevel vl = vlb.build("MyVoltageLevel");
  vl.add(bus);
  ss.add(vl);
  network.add(ss);

  shared_ptr<DataInterface> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  return data;
}

shared_ptr<DataInterface>
createBusBreakerNetworkWithLoads(double busV, double busVNom, double pow1, double pow2) {
  IIDM::builders::NetworkBuilder nb;
  IIDM::Network network = nb.build("MyNetwork");
  IIDM::connection_status_t cs = {true /*connected*/};
  IIDM::Port p1("MyBus", cs), p2("MyBus", cs);
  IIDM::Connection c1("MyVoltageLevel", p1, IIDM::side_1), c2("MyVoltageLevel", p2, IIDM::side_1);

  IIDM::builders::SubstationBuilder ssb;
  IIDM::Substation ss = ssb.build("MySubStation");

  IIDM::builders::BusBuilder bb;
  bb.v(busV);
  bb.angle(1.5);
  IIDM::Bus bus = bb.build("MyBus");

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::bus_breaker);
  vlb.nominalV(busVNom);
  IIDM::VoltageLevel vl = vlb.build("MyVoltageLevel");
  vl.add(bus);
  IIDM::builders::LoadBuilder lb;
  lb.p0(pow1);
  lb.p(pow1);
  lb.q0(90.);
  lb.q(90.);
  IIDM::Load load = lb.build("MyLoad");
  lb.p0(pow2);
  lb.p(pow2);
  lb.q0(90.);
  lb.q(90.);
  IIDM::Load load2 = lb.build("MyLoad2");
  vl.add(load, c1);
  vl.add(load2, c2);
  ss.add(vl);
  network.add(ss);

  shared_ptr<DataInterface> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  return data;
}

shared_ptr<DataInterface>
createBusBreakerNetworkWithGenerators(double busV, double busVNom, double pow1, double pow2) {
  IIDM::builders::NetworkBuilder nb;
  IIDM::Network network = nb.build("MyNetwork");
  IIDM::connection_status_t cs = {true /*connected*/};
  IIDM::Port p1("MyBus", cs), p2("MyBus", cs);
  IIDM::Connection c1("MyVoltageLevel", p1, IIDM::side_1), c2("MyVoltageLevel", p2, IIDM::side_1);

  IIDM::builders::SubstationBuilder ssb;
  IIDM::Substation ss = ssb.build("MySubStation");

  IIDM::builders::BusBuilder bb;
  bb.v(busV);
  bb.angle(1.5);
  IIDM::Bus bus = bb.build("MyBus");

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::bus_breaker);
  vlb.nominalV(busVNom);
  IIDM::VoltageLevel vl = vlb.build("MyVoltageLevel");
  vl.add(bus);
  IIDM::builders::GeneratorBuilder genb;
  genb.p(pow1);
  genb.q(90.);
  IIDM::MinMaxReactiveLimits limits(90., 180.);
  genb.minMaxReactiveLimits(limits);
  IIDM::Generator gen = genb.build("MyGen");
  genb.p(pow2);
  genb.q(90.);
  IIDM::Generator gen2 = genb.build("MyGen2");
  vl.add(gen, c1);
  vl.add(gen2, c2);
  ss.add(vl);
  network.add(ss);

  shared_ptr<DataInterface> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  return data;
}

shared_ptr<SubModel>
initModel(shared_ptr<DataInterface> data) {
  shared_ptr<SubModel> modelNetwork = SubModelFactory::createSubModelFromLib("../../../Models/CPP/ModelNetwork/DYNModelNetwork" +
                                                std::string(sharedLibraryExtension()));
  modelNetwork->initFromData(data);
  data->setModelNetwork(modelNetwork);
  modelNetwork->name("NETWORK");
  shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newInstance("Parameterset");
  parametersSet->createParameter("bus_uMax", 0.);
  parametersSet->createParameter("capacitor_no_reclosing_delay", 0.);
  parametersSet->createParameter("load_alpha", 0.);
  parametersSet->createParameter("load_beta", 0.);
  parametersSet->createParameter("load_isRestorative", false);
  parametersSet->createParameter("load_isControllable", false);
  modelNetwork->setPARParameters(parametersSet);

  return modelNetwork;
}

void
exportStates(shared_ptr<DataInterface> data) {
  shared_ptr<SubModel> modelNetwork = initModel(data);
  ModelMulti mm;
  mm.addSubModel(modelNetwork, "MyLib");
  mm.initBuffers();
  mm.init(0.0);
  data->getStateVariableReference();
  data->exportStateVariables();
  data->updateFromModel(false);
  data->importStaticParameters();
}

TEST(DataInterfaceIIDMTest, testBusCriteria) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  ASSERT_FALSE(BusCriteria::criteriaEligibleForBus(criteriap));
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  ASSERT_FALSE(BusCriteria::criteriaEligibleForBus(criteriap));
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setPMax(100);
  criteriap->setPMin(0);
  ASSERT_FALSE(BusCriteria::criteriaEligibleForBus(criteriap));
  criteriap->setUMaxPu(0.8);
  ASSERT_TRUE(BusCriteria::criteriaEligibleForBus(criteriap));
  criteriap->setId("MyCriteria");

  shared_ptr<DataInterface> data = createBusBreakerNetwork(180, 190);
  exportStates(data);
  boost::shared_ptr<BusInterface> bus = data->getNetwork()->getVoltageLevels()[0]->getBuses()[0];
  BusCriteria criteria(criteriap);
  // VNom lower than min
  criteria.addBus(bus);
  ASSERT_TRUE(criteria.empty());

  data = createBusBreakerNetwork(180, 401);
  exportStates(data);
  bus = data->getNetwork()->getVoltageLevels()[0]->getBuses()[0];
  // VNom higher than max
  criteria.addBus(bus);
  ASSERT_TRUE(criteria.empty());

  data = createBusBreakerNetwork(180, 225);
  exportStates(data);
  bus = data->getNetwork()->getVoltageLevels()[0]->getBuses()[0];
  // v<=0.8*vNom
  criteria.addBus(bus);
  ASSERT_FALSE(criteria.empty());
  ASSERT_TRUE(criteria.checkCriteria(false));
  ASSERT_TRUE(criteria.getFailingCriteria().empty());

  data = createBusBreakerNetwork(190, 225);
  exportStates(data);
  bus = data->getNetwork()->getVoltageLevels()[0]->getBuses()[0];
  // v>0.8*vNom
  BusCriteria criteria2(criteriap);
  criteria2.addBus(bus);
  ASSERT_FALSE(criteria2.checkCriteria(false));
  ASSERT_EQ(criteria2.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria2.getFailingCriteria()[0], "BusAboveVoltage MyBus 190 0.8 MyCriteria");

  boost::shared_ptr<CriteriaParams> criteriap2 = CriteriaParamsFactory::newCriteriaParams();
  criteriap2->setType(CriteriaParams::LOCAL_VALUE);
  criteriap2->setUMinPu(0.2);
  criteriap2->setScope(CriteriaParams::FINAL);
  BusCriteria criteria3(criteriap2);
  data = createBusBreakerNetwork(190, 225);
  exportStates(data);
  bus = data->getNetwork()->getVoltageLevels()[0]->getBuses()[0];
  // v>=0.2*vNom
  criteria3.addBus(bus);
  ASSERT_TRUE(criteria3.checkCriteria(true));
  ASSERT_TRUE(criteria3.getFailingCriteria().empty());

  data = createBusBreakerNetwork(43, 225);
  exportStates(data);
  bus = data->getNetwork()->getVoltageLevels()[0]->getBuses()[0];
  // v<0.2*vNom
  BusCriteria criteria4(criteriap2);
  criteria4.addBus(bus);
  ASSERT_FALSE(criteria4.checkCriteria(true));
  ASSERT_EQ(criteria4.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria4.getFailingCriteria()[0], "BusUnderVoltage MyBus 43 0.2 ");
  ASSERT_TRUE(criteria4.checkCriteria(false));
  ASSERT_TRUE(criteria4.getFailingCriteria().empty());
}

TEST(DataInterfaceIIDMTest, testBusCriteriaDataIIDM) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  boost::shared_ptr<criteria::Criteria> criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  boost::shared_ptr<CriteriaCollection> collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  shared_ptr<DataInterface> data = createBusBreakerNetwork(180, 225);
  exportStates(data);
  data->configureCriteria(collection);
  // not eligible
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createBusBreakerNetwork(190, 200);
  exportStates(data);
  data->configureCriteria(collection);
  // vNom < min
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createBusBreakerNetwork(190, 225);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_FALSE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyDummyName");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createBusBreakerNetwork(190, 200);
  exportStates(data);
  data->configureCriteria(collection);
  // bus not found
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyBus");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createBusBreakerNetwork(190, 225);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_FALSE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::FINAL);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyBus");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createBusBreakerNetwork(190, 225);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(false));
  ASSERT_FALSE(data->checkCriteria(true));
}

TEST(DataInterfaceIIDMTest, testLoadCriteriaLocalValue) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  ASSERT_FALSE(LoadCriteria::criteriaEligibleForLoad(criteriap));
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setUMinPu(0.2);
  ASSERT_FALSE(LoadCriteria::criteriaEligibleForLoad(criteriap));
  criteriap->setPMax(200);
  ASSERT_TRUE(LoadCriteria::criteriaEligibleForLoad(criteriap));
  criteriap->setPMin(50);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  ASSERT_TRUE(LoadCriteria::criteriaEligibleForLoad(criteriap));
  criteriap->setId("MyCriteria");

  shared_ptr<DataInterface> data = createBusBreakerNetworkWithLoads(180, 190, 100, 100);
  exportStates(data);
  std::vector< boost::shared_ptr<LoadInterface> > loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  LoadCriteria criteria(criteriap);
  // VNom lower than min
  for (size_t i = 0; i < loads.size(); ++i)
    criteria.addLoad(loads[i]);
  ASSERT_TRUE(criteria.empty());

  data = createBusBreakerNetworkWithLoads(180, 425, 100, 100);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // VNom higher than max
  for (size_t i = 0; i < loads.size(); ++i)
    criteria.addLoad(loads[i]);
  ASSERT_TRUE(criteria.empty());

  data = createBusBreakerNetworkWithLoads(190, 225, 250, 100);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // V > uMaxPu*VNom
  for (size_t i = 0; i < loads.size(); ++i)
    criteria.addLoad(loads[i]);
  ASSERT_FALSE(criteria.empty());
  ASSERT_TRUE(criteria.checkCriteria(true));
  ASSERT_TRUE(criteria.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithLoads(43, 225, 250, 100);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // V < uMinPu*VNom
  LoadCriteria criteria2(criteriap);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria2.addLoad(loads[i]);
  ASSERT_FALSE(criteria2.empty());
  ASSERT_TRUE(criteria2.checkCriteria(true));
  ASSERT_TRUE(criteria2.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithLoads(180, 225, 100, 100);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // OK
  LoadCriteria criteria3(criteriap);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria3.addLoad(loads[i]);
  ASSERT_FALSE(criteria3.empty());
  ASSERT_TRUE(criteria3.checkCriteria(true));
  ASSERT_TRUE(criteria3.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithLoads(180, 225, 250, 100);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // P> PMax
  LoadCriteria criteria4(criteriap);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria4.addLoad(loads[i]);
  ASSERT_FALSE(criteria4.empty());
  ASSERT_FALSE(criteria4.checkCriteria(true));
  ASSERT_EQ(criteria4.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria4.getFailingCriteria()[0], "SourceAbovePower MyLoad 250 200 MyCriteria");

  data = createBusBreakerNetworkWithLoads(180, 225, 40, 100);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // P< PMin
  criteriap->setScope(CriteriaParams::FINAL);
  LoadCriteria criteria5(criteriap);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria5.addLoad(loads[i]);
  ASSERT_FALSE(criteria5.empty());
  ASSERT_TRUE(criteria5.checkCriteria(false));
  ASSERT_TRUE(criteria5.getFailingCriteria().empty());
  ASSERT_FALSE(criteria5.checkCriteria(true));
  ASSERT_EQ(criteria5.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria5.getFailingCriteria()[0], "SourceUnderPower MyLoad 40 50 MyCriteria");
}

TEST(DataInterfaceIIDMTest, testLoadCriteriaSum) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setUMinPu(0.2);
  criteriap->setPMax(200);
  criteriap->setPMin(50);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setType(CriteriaParams::SUM);
  ASSERT_TRUE(LoadCriteria::criteriaEligibleForLoad(criteriap));
  criteriap->setId("MyCriteria");

  shared_ptr<DataInterface> data = createBusBreakerNetworkWithLoads(180, 190, 100, 100);
  exportStates(data);
  std::vector< boost::shared_ptr<LoadInterface> > loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  LoadCriteria criteria(criteriap);
  // VNom lower than min
  for (size_t i = 0; i < loads.size(); ++i)
    criteria.addLoad(loads[i]);
  ASSERT_TRUE(criteria.empty());

  data = createBusBreakerNetworkWithLoads(180, 425, 100, 100);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // VNom higher than max
  for (size_t i = 0; i < loads.size(); ++i)
    criteria.addLoad(loads[i]);
  ASSERT_TRUE(criteria.empty());

  data = createBusBreakerNetworkWithLoads(190, 225, 250, 100);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // V > uMaxPu*VNom
  for (size_t i = 0; i < loads.size(); ++i)
    criteria.addLoad(loads[i]);
  ASSERT_FALSE(criteria.empty());
  ASSERT_TRUE(criteria.checkCriteria(true));
  ASSERT_TRUE(criteria.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithLoads(43, 225, 250, 100);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // V < uMinPu*VNom
  LoadCriteria criteria2(criteriap);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria2.addLoad(loads[i]);
  ASSERT_FALSE(criteria2.empty());
  ASSERT_TRUE(criteria2.checkCriteria(true));
  ASSERT_TRUE(criteria2.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithLoads(180, 225, 50, 50);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // OK
  LoadCriteria criteria3(criteriap);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria3.addLoad(loads[i]);
  ASSERT_FALSE(criteria3.empty());
  ASSERT_TRUE(criteria3.checkCriteria(true));
  ASSERT_TRUE(criteria3.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithLoads(180, 225, 250, 100);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // P> PMax
  LoadCriteria criteria4(criteriap);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria4.addLoad(loads[i]);
  ASSERT_FALSE(criteria4.empty());
  ASSERT_FALSE(criteria4.checkCriteria(true));
  ASSERT_EQ(criteria4.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria4.getFailingCriteria()[0], "SourcePowerAboveMax 350 200 MyCriteria");

  data = createBusBreakerNetworkWithLoads(180, 225, 10, 10);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // P< PMin
  criteriap->setScope(CriteriaParams::FINAL);
  LoadCriteria criteria5(criteriap);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria5.addLoad(loads[i]);
  ASSERT_FALSE(criteria5.empty());
  ASSERT_TRUE(criteria5.checkCriteria(false));
  ASSERT_TRUE(criteria5.getFailingCriteria().empty());
  ASSERT_FALSE(criteria5.checkCriteria(true));
  ASSERT_EQ(criteria5.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria5.getFailingCriteria()[0], "SourcePowerBelowMin 20 50 MyCriteria");
}

TEST(DataInterfaceIIDMTest, testLoadCriteriaDataIIDMLocalValue) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  boost::shared_ptr<criteria::Criteria> criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  boost::shared_ptr<CriteriaCollection> collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  shared_ptr<DataInterface> data = createBusBreakerNetworkWithLoads(180, 225, 100, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // not eligible
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(190, 200, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // vNom < min
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(190, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyDummyName");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(180, 200, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // load not found
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyLoad");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax
  ASSERT_FALSE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyLoad2");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P < PMax
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::FINAL);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyLoad");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(false));
  ASSERT_FALSE(data->checkCriteria(true));
}

TEST(DataInterfaceIIDMTest, testLoadCriteriaDataIIDMSum) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  boost::shared_ptr<criteria::Criteria> criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  boost::shared_ptr<CriteriaCollection> collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  shared_ptr<DataInterface> data = createBusBreakerNetworkWithLoads(180, 225, 100, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // not eligible
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(190, 200, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // vNom < min
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(190, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyDummyName");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(180, 200, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // load not found
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(180, 225, 50, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // sum(P)<= PMax
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(150);
  criteriap->setId("MyCriteria");
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax
  ASSERT_FALSE(data->checkCriteria(false));
  std::vector<std::string> failingCriteria;
  data->getFailingCriteria(failingCriteria);
  ASSERT_EQ(failingCriteria.size(), 1);
  ASSERT_EQ(failingCriteria[0], "SourcePowerAboveMax 300 150 MyCriteria");

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyLoad2");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P < PMax
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::FINAL);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(false));
  ASSERT_FALSE(data->checkCriteria(true));
}

TEST(DataInterfaceIIDMTest, testGeneratorCriteriaLocalValue) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  ASSERT_FALSE(GeneratorCriteria::criteriaEligibleForGenerator(criteriap));
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setUMinPu(0.2);
  ASSERT_FALSE(GeneratorCriteria::criteriaEligibleForGenerator(criteriap));
  criteriap->setPMax(200);
  ASSERT_TRUE(GeneratorCriteria::criteriaEligibleForGenerator(criteriap));
  criteriap->setPMin(50);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  ASSERT_TRUE(GeneratorCriteria::criteriaEligibleForGenerator(criteriap));
  criteriap->setId("MyCriteria");

  shared_ptr<DataInterface> data = createBusBreakerNetworkWithGenerators(180, 190, 100, 100);
  exportStates(data);
  std::vector< boost::shared_ptr<GeneratorInterface> > generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  GeneratorCriteria criteria(criteriap);
  // VNom lower than min
  for (size_t i = 0; i < generators.size(); ++i)
    criteria.addGenerator(generators[i]);
  ASSERT_TRUE(criteria.empty());

  data = createBusBreakerNetworkWithGenerators(180, 425, 100, 100);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // VNom higher than max
  for (size_t i = 0; i < generators.size(); ++i)
    criteria.addGenerator(generators[i]);
  ASSERT_TRUE(criteria.empty());

  data = createBusBreakerNetworkWithGenerators(190, 225, 250, 100);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // V > uMaxPu*VNom
  for (size_t i = 0; i < generators.size(); ++i)
    criteria.addGenerator(generators[i]);
  ASSERT_FALSE(criteria.empty());
  ASSERT_TRUE(criteria.checkCriteria(true));
  ASSERT_TRUE(criteria.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithGenerators(43, 225, 250, 100);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // V < uMinPu*VNom
  GeneratorCriteria criteria2(criteriap);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria2.addGenerator(generators[i]);
  ASSERT_FALSE(criteria2.empty());
  ASSERT_TRUE(criteria2.checkCriteria(true));
  ASSERT_TRUE(criteria2.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithGenerators(180, 225, 100, 100);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // OK
  GeneratorCriteria criteria3(criteriap);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria3.addGenerator(generators[i]);
  ASSERT_FALSE(criteria3.empty());
  ASSERT_TRUE(criteria3.checkCriteria(true));
  ASSERT_TRUE(criteria3.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithGenerators(180, 225, 250, 100);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // P> PMax
  GeneratorCriteria criteria4(criteriap);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria4.addGenerator(generators[i]);
  ASSERT_FALSE(criteria4.empty());
  ASSERT_FALSE(criteria4.checkCriteria(true));
  ASSERT_EQ(criteria4.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria4.getFailingCriteria()[0], "SourceAbovePower MyGen 250 200 MyCriteria");

  data = createBusBreakerNetworkWithGenerators(180, 225, 40, 100);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // P< PMin
  criteriap->setScope(CriteriaParams::FINAL);
  GeneratorCriteria criteria5(criteriap);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria5.addGenerator(generators[i]);
  ASSERT_FALSE(criteria5.empty());
  ASSERT_TRUE(criteria5.checkCriteria(false));
  ASSERT_TRUE(criteria5.getFailingCriteria().empty());
  ASSERT_FALSE(criteria5.checkCriteria(true));
  ASSERT_EQ(criteria5.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria5.getFailingCriteria()[0], "SourceUnderPower MyGen 40 50 MyCriteria");
}

TEST(DataInterfaceIIDMTest, testGeneratorCriteriaSum) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setUMinPu(0.2);
  criteriap->setPMax(200);
  criteriap->setPMin(50);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setType(CriteriaParams::SUM);
  ASSERT_TRUE(GeneratorCriteria::criteriaEligibleForGenerator(criteriap));
  criteriap->setId("MyCriteria");

  shared_ptr<DataInterface> data = createBusBreakerNetworkWithGenerators(180, 190, 100, 100);
  exportStates(data);
  std::vector< boost::shared_ptr<GeneratorInterface> > generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  GeneratorCriteria criteria(criteriap);
  // VNom lower than min
  for (size_t i = 0; i < generators.size(); ++i)
    criteria.addGenerator(generators[i]);
  ASSERT_TRUE(criteria.empty());

  data = createBusBreakerNetworkWithGenerators(180, 425, 100, 100);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // VNom higher than max
  for (size_t i = 0; i < generators.size(); ++i)
    criteria.addGenerator(generators[i]);
  ASSERT_TRUE(criteria.empty());

  data = createBusBreakerNetworkWithGenerators(190, 225, 250, 100);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // V > uMaxPu*VNom
  for (size_t i = 0; i < generators.size(); ++i)
    criteria.addGenerator(generators[i]);
  ASSERT_FALSE(criteria.empty());
  ASSERT_TRUE(criteria.checkCriteria(true));
  ASSERT_TRUE(criteria.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithGenerators(43, 225, 250, 100);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // V < uMinPu*VNom
  GeneratorCriteria criteria2(criteriap);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria2.addGenerator(generators[i]);
  ASSERT_FALSE(criteria2.empty());
  ASSERT_TRUE(criteria2.checkCriteria(true));
  ASSERT_TRUE(criteria2.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithGenerators(180, 225, 50, 50);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // OK
  GeneratorCriteria criteria3(criteriap);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria3.addGenerator(generators[i]);
  ASSERT_FALSE(criteria3.empty());
  ASSERT_TRUE(criteria3.checkCriteria(true));
  ASSERT_TRUE(criteria3.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithGenerators(180, 225, 250, 100);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // P> PMax
  GeneratorCriteria criteria4(criteriap);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria4.addGenerator(generators[i]);
  ASSERT_FALSE(criteria4.empty());
  ASSERT_FALSE(criteria4.checkCriteria(true));
  ASSERT_EQ(criteria4.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria4.getFailingCriteria()[0], "SourcePowerAboveMax 350 200 MyCriteria");

  data = createBusBreakerNetworkWithGenerators(180, 225, 10, 10);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // P< PMin
  criteriap->setScope(CriteriaParams::FINAL);
  GeneratorCriteria criteria5(criteriap);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria5.addGenerator(generators[i]);
  ASSERT_FALSE(criteria5.empty());
  ASSERT_TRUE(criteria5.checkCriteria(false));
  ASSERT_TRUE(criteria5.getFailingCriteria().empty());
  ASSERT_FALSE(criteria5.checkCriteria(true));
  ASSERT_EQ(criteria5.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria5.getFailingCriteria()[0], "SourcePowerBelowMin 20 50 MyCriteria");
}

TEST(DataInterfaceIIDMTest, testGeneratorCriteriaDataIIDMLocalValue) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  boost::shared_ptr<criteria::Criteria> criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  boost::shared_ptr<CriteriaCollection> collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  shared_ptr<DataInterface> data = createBusBreakerNetworkWithGenerators(180, 225, 100, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // not eligible
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(190, 200, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // vNom < min
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(190, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyDummyName");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 200, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // generator not found
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyGen");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax
  ASSERT_FALSE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyGend2");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P < PMax
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::FINAL);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyGen");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(false));
  ASSERT_FALSE(data->checkCriteria(true));
}

TEST(DataInterfaceIIDMTest, testGeneratorCriteriaDataIIDMSum) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  boost::shared_ptr<criteria::Criteria> criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  boost::shared_ptr<CriteriaCollection> collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  shared_ptr<DataInterface> data = createBusBreakerNetworkWithGenerators(180, 225, 100, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // not eligible
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(190, 200, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // vNom < min
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(190, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyDummyName");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 200, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // generator not found
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 225, 50, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // sum(P)<= PMax
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax
  ASSERT_FALSE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyGen2");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P < PMax
  ASSERT_TRUE(data->checkCriteria(false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::FINAL);
  criteriap->setUNomMin(225);
  criteriap->setUNomMax(400);
  criteriap->setUMaxPu(0.8);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(false));
  ASSERT_FALSE(data->checkCriteria(true));
}

}  // namespace DYN
