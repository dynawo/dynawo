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
 * @file Modeler/DataInterface/IIDM/test/TestCriteria.cpp
 * @brief Unit tests for Criteria classes
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

#include <boost/make_shared.hpp>

using boost::shared_ptr;
using criteria::CriteriaFactory;
using criteria::CriteriaParams;
using criteria::CriteriaParamsFactory;
using criteria::CriteriaCollection;
using criteria::CriteriaCollectionFactory;

namespace DYN {

static shared_ptr<DataInterface>
createNodeBreakerNetworkCriteria() {
  IIDM::builders::NetworkBuilder nb;
  boost::shared_ptr<IIDM::Network> network = boost::make_shared<IIDM::Network>(nb.build("MyNetwork"));

  IIDM::builders::SubstationBuilder ssb;
  IIDM::Substation ss = ssb.build("MySubStation");

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::node_breaker);
  vlb.nominalV(225.);
  vlb.node_count(2);
  IIDM::VoltageLevel vl = vlb.build("MyVoltageLevel");

  IIDM::builders::BusBarSectionBuilder bbsb;
  bbsb.node(0);
  IIDM::BusBarSection bbs = bbsb.build("MyBusBarSection");
  bbs.v(190.);
  bbs.angle(1.5);
  vl.add(bbs);

  IIDM::Port p1(0);
  IIDM::Connection c1("MyVoltageLevel", p1, IIDM::side_1);
  IIDM::builders::LoadBuilder lb;
  IIDM::Load load = lb.build("MyLoad");
  vl.add(load, c1);

  ss.add(vl);

  network->add(ss);

  shared_ptr<DataInterface> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  return data;
}

static shared_ptr<DataInterface>
createBusBreakerNetwork(double busV, double busVNom, bool addCountry = true) {
  IIDM::builders::NetworkBuilder nb;
  boost::shared_ptr<IIDM::Network> network = boost::make_shared<IIDM::Network>(nb.build("MyNetwork"));

  IIDM::builders::SubstationBuilder ssb;
  if (addCountry)
    ssb.country("FR");
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
  network->add(ss);

  shared_ptr<DataInterface> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  return data;
}

static shared_ptr<DataInterface>
createBusBreakerNetworkWithLoads(double busV, double busVNom, double pow1, double pow2, bool addCountry = true) {
  IIDM::builders::NetworkBuilder nb;
  boost::shared_ptr<IIDM::Network> network = boost::make_shared<IIDM::Network>(nb.build("MyNetwork"));
  IIDM::connection_status_t cs = {true /*connected*/};
  IIDM::Port p1("MyBus", cs), p2("MyBus", cs);
  IIDM::Connection c1("MyVoltageLevel", p1, IIDM::side_1), c2("MyVoltageLevel", p2, IIDM::side_1);
  IIDM::Port p3("MyBus2", cs), p4("MyBus2", cs);
  IIDM::Connection c3("MyVoltageLevel2", p3, IIDM::side_1), c4("MyVoltageLevel2", p4, IIDM::side_1);
  IIDM::Port p5("MyBus", cs), p6("MyBus2", cs);
  IIDM::Connection c5("MyVoltageLevel", p5, IIDM::side_1), c6("MyVoltageLevel2", p6, IIDM::side_2);

  IIDM::builders::SubstationBuilder ssb;
  if (addCountry)
    ssb.country("FR");
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

  IIDM::builders::BusBuilder bb2;
  bb2.v(400);
  bb2.angle(1.5);
  IIDM::Bus bus2 = bb2.build("MyBus2");

  IIDM::builders::VoltageLevelBuilder vlb2;
  vlb2.mode(IIDM::VoltageLevel::bus_breaker);
  vlb2.nominalV(500);
  IIDM::VoltageLevel vl2 = vlb2.build("MyVoltageLevel2");
  vl2.add(bus2);
  IIDM::builders::LoadBuilder lb2;
  lb2.p0(pow1);
  lb2.p(pow1);
  lb2.q0(90.);
  lb2.q(90.);
  IIDM::Load load3 = lb2.build("MyLoad3");
  lb2.p0(pow2);
  lb2.p(pow2);
  lb2.q0(90.);
  lb2.q(90.);
  IIDM::Load load4 = lb2.build("MyLoad4");
  vl2.add(load3, c3);
  vl2.add(load4, c4);
  ss.add(vl2);

  IIDM::builders::Transformer2WindingsBuilder t2Wb;
  t2Wb.r(1.1);
  t2Wb.x(1.2);
  t2Wb.g(1.3);
  t2Wb.b(1.4);
  t2Wb.ratedU1(busV);
  t2Wb.ratedU2(400);
  IIDM::Transformer2Windings t2W = t2Wb.build("MyTransformer2Winding");
  ss.add(t2W, c5, c6);
  network->add(ss);

  shared_ptr<DataInterface> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  return data;
}

static shared_ptr<DataInterface>
createBusBreakerNetworkWithGenerators(double busV, double busVNom, double pow1, double pow2, bool addCountry = true) {
  IIDM::builders::NetworkBuilder nb;
  boost::shared_ptr<IIDM::Network> network = boost::make_shared<IIDM::Network>(nb.build("MyNetwork"));
  IIDM::connection_status_t cs = {true /*connected*/};
  IIDM::Port p1("MyBus", cs), p2("MyBus", cs);
  IIDM::Connection c1("MyVoltageLevel", p1, IIDM::side_1), c2("MyVoltageLevel", p2, IIDM::side_1);
  IIDM::Port p3("MyBus2", cs), p4("MyBus2", cs);
  IIDM::Connection c3("MyVoltageLevel2", p3, IIDM::side_1), c4("MyVoltageLevel2", p4, IIDM::side_1);
  IIDM::Port p5("MyBus", cs), p6("MyBus2", cs);
  IIDM::Connection c5("MyVoltageLevel", p5, IIDM::side_1), c6("MyVoltageLevel2", p6, IIDM::side_2);

  IIDM::builders::SubstationBuilder ssb;
  if (addCountry)
    ssb.country("FR");
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

  IIDM::builders::BusBuilder bb2;
  bb2.v(400);
  bb2.angle(1.5);
  IIDM::Bus bus2 = bb2.build("MyBus2");

  IIDM::builders::VoltageLevelBuilder vlb2;
  vlb2.mode(IIDM::VoltageLevel::bus_breaker);
  vlb2.nominalV(500);
  IIDM::VoltageLevel vl2 = vlb2.build("MyVoltageLevel2");
  vl2.add(bus2);
  genb.p(pow1);
  genb.q(90.);
  IIDM::Generator gen3 = genb.build("MyGen3");
  genb.p(pow2);
  genb.q(90.);
  IIDM::Generator gen4 = genb.build("MyGen4");
  vl2.add(gen3, c3);
  vl2.add(gen4, c4);
  ss.add(vl2);

  IIDM::builders::Transformer2WindingsBuilder t2Wb;
  t2Wb.r(1.1);
  t2Wb.x(1.2);
  t2Wb.g(1.3);
  t2Wb.b(1.4);
  t2Wb.ratedU1(busV);
  t2Wb.ratedU2(400);
  IIDM::Transformer2Windings t2W = t2Wb.build("MyTransformer2Winding");
  ss.add(t2W, c5, c6);
  network->add(ss);

  shared_ptr<DataInterface> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  return data;
}

static shared_ptr<SubModel>
initModel(shared_ptr<DataInterface> data) {
  shared_ptr<SubModel> modelNetwork = SubModelFactory::createSubModelFromLib("../../../../../M/CPP/ModelNetwork/DYNModelNetwork" +
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
  modelNetwork->setPARParameters(parametersSet);

  return modelNetwork;
}

static void
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
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(100);
  criteriap->setPMin(0);
  ASSERT_FALSE(BusCriteria::criteriaEligibleForBus(criteriap));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(100);
  criteriap->setPMin(0);
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
  ASSERT_TRUE(criteria.checkCriteria(0, false));
  ASSERT_TRUE(criteria.getFailingCriteria().empty());

  data = createBusBreakerNetwork(190, 225);
  exportStates(data);
  bus = data->getNetwork()->getVoltageLevels()[0]->getBuses()[0];
  // v>0.8*vNom
  BusCriteria criteria2(criteriap);
  criteria2.addBus(bus);
  ASSERT_FALSE(criteria2.checkCriteria(0, false));
  ASSERT_EQ(criteria2.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria2.getFailingCriteria()[0].second, "BusAboveVoltage MyBus 190 0.844444 180 0.8 MyCriteria");

  boost::shared_ptr<CriteriaParams> criteriap2 = CriteriaParamsFactory::newCriteriaParams();
  criteriap2->setType(CriteriaParams::LOCAL_VALUE);
  vl.reset();
  vl.setUMinPu(0.2);
  criteriap2->addVoltageLevel(vl);
  criteriap2->setScope(CriteriaParams::FINAL);
  BusCriteria criteria3(criteriap2);
  data = createBusBreakerNetwork(190, 225);
  exportStates(data);
  bus = data->getNetwork()->getVoltageLevels()[0]->getBuses()[0];
  // v>=0.2*vNom
  criteria3.addBus(bus);
  ASSERT_TRUE(criteria3.checkCriteria(0, true));
  ASSERT_TRUE(criteria3.getFailingCriteria().empty());

  data = createBusBreakerNetwork(43, 225);
  exportStates(data);
  bus = data->getNetwork()->getVoltageLevels()[0]->getBuses()[0];
  // v<0.2*vNom
  BusCriteria criteria4(criteriap2);
  criteria4.addBus(bus);
  ASSERT_FALSE(criteria4.checkCriteria(0, true));
  ASSERT_EQ(criteria4.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria4.getFailingCriteria()[0].second, "BusUnderVoltage MyBus 43 0.191111 45 0.2 ");
  ASSERT_TRUE(criteria4.checkCriteria(0, false));
  ASSERT_TRUE(criteria4.getFailingCriteria().empty());
}

TEST(DataInterfaceIIDMTest, testBusCriteriaDataIIDM) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  criteriap->addVoltageLevel(vl);
  boost::shared_ptr<criteria::Criteria> criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  boost::shared_ptr<CriteriaCollection> collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  shared_ptr<DataInterface> data = createBusBreakerNetwork(180, 225);
  exportStates(data);
  data->configureCriteria(collection);
  // not eligible
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createBusBreakerNetwork(190, 200);
  exportStates(data);
  data->configureCriteria(collection);
  // vNom < min
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createBusBreakerNetwork(190, 225);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_FALSE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addCountry("BE");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createBusBreakerNetwork(190, 225);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom but criteria filter is KO
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addCountry("FR");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createBusBreakerNetwork(190, 225);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom and criteria filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addCountry("FR");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createBusBreakerNetwork(190, 225, false);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom and criteria filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyDummyName");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createBusBreakerNetwork(190, 200);
  exportStates(data);
  data->configureCriteria(collection);
  // bus not found
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyBus");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createBusBreakerNetwork(190, 225);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_FALSE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::FINAL);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyBus");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createBusBreakerNetwork(190, 225);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(0, false));
  ASSERT_FALSE(data->checkCriteria(0, true));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyBus");
  criteria->addCountry("BE");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createBusBreakerNetwork(190, 225);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom but the bus is ignored due to country filter
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyBus");
  criteria->addCountry("FR");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createBusBreakerNetwork(190, 225);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom and the country filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyBus");
  criteria->addCountry("FR");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createBusBreakerNetwork(190, 225, false);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom and the country filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyBusBarSection", "DummyVoltageLevel");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createNodeBreakerNetworkCriteria();
  exportStates(data);
  data->configureCriteria(collection);
  // voltage level not found
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("DummyBBS", "MyVoltageLevel");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createNodeBreakerNetworkCriteria();
  exportStates(data);
  data->configureCriteria(collection);
  // bbs not found
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyBusBarSection", "MyVoltageLevel");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createNodeBreakerNetworkCriteria();
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_FALSE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::FINAL);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyBusBarSection", "MyVoltageLevel");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::BUS, criteria);
  data = createNodeBreakerNetworkCriteria();
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(0, false));
  ASSERT_FALSE(data->checkCriteria(0, true));
}

TEST(DataInterfaceIIDMTest, testLoadCriteriaLocalValue) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  ASSERT_FALSE(LoadCriteria::criteriaEligibleForLoad(criteriap));
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  vl.setUMinPu(0.2);
  criteriap->addVoltageLevel(vl);
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
  ASSERT_TRUE(criteria.checkCriteria(0, true));
  ASSERT_TRUE(criteria.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithLoads(43, 225, 250, 100);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // V < uMinPu*VNom
  LoadCriteria criteria2(criteriap);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria2.addLoad(loads[i]);
  ASSERT_FALSE(criteria2.empty());
  ASSERT_TRUE(criteria2.checkCriteria(0, true));
  ASSERT_TRUE(criteria2.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithLoads(180, 225, 100, 100);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // OK
  LoadCriteria criteria3(criteriap);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria3.addLoad(loads[i]);
  ASSERT_FALSE(criteria3.empty());
  ASSERT_TRUE(criteria3.checkCriteria(0, true));
  ASSERT_TRUE(criteria3.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithLoads(180, 225, 250, 100);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // P> PMax
  LoadCriteria criteria4(criteriap);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria4.addLoad(loads[i]);
  ASSERT_FALSE(criteria4.empty());
  ASSERT_FALSE(criteria4.checkCriteria(0, true));
  ASSERT_EQ(criteria4.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria4.getFailingCriteria()[0].second, "SourceAbovePower MyLoad 250 200 MyCriteria");

  data = createBusBreakerNetworkWithLoads(180, 225, 40, 100);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // P< PMin
  criteriap->setScope(CriteriaParams::FINAL);
  LoadCriteria criteria5(criteriap);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria5.addLoad(loads[i]);
  ASSERT_FALSE(criteria5.empty());
  ASSERT_TRUE(criteria5.checkCriteria(0, false));
  ASSERT_TRUE(criteria5.getFailingCriteria().empty());
  ASSERT_FALSE(criteria5.checkCriteria(0, true));
  ASSERT_EQ(criteria5.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria5.getFailingCriteria()[0].second, "SourceUnderPower MyLoad 40 50 MyCriteria");

  // Multiple voltage levels
  criteriap = CriteriaParamsFactory::newCriteriaParams();
  vl.reset();
  vl.setUNomMin(300);
  vl.setUNomMax(400);
  criteriap->addVoltageLevel(vl);
  criteria::CriteriaParamsVoltageLevel vl2;
  vl2.setUNomMin(225);
  vl2.setUNomMax(400);
  criteriap->addVoltageLevel(vl2);
  criteriap->setPMax(200);
  criteriap->setPMin(50);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setId("MyCriteria");
  data = createBusBreakerNetworkWithLoads(180, 225, 250, 100);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // P> PMax
  LoadCriteria criteria6(criteriap);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria6.addLoad(loads[i]);
  ASSERT_FALSE(criteria6.empty());
  ASSERT_FALSE(criteria6.checkCriteria(0, false));
  ASSERT_EQ(criteria6.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria6.getFailingCriteria()[0].second, "SourceAbovePower MyLoad 250 200 MyCriteria");
}

TEST(DataInterfaceIIDMTest, testLoadCriteriaSum) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  vl.setUMinPu(0.2);
  criteriap->addVoltageLevel(vl);
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
  ASSERT_TRUE(criteria.checkCriteria(0, true));
  ASSERT_TRUE(criteria.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithLoads(43, 225, 250, 100);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // V < uMinPu*VNom
  LoadCriteria criteria2(criteriap);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria2.addLoad(loads[i]);
  ASSERT_FALSE(criteria2.empty());
  ASSERT_TRUE(criteria2.checkCriteria(0, true));
  ASSERT_TRUE(criteria2.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithLoads(180, 225, 50, 50);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // OK
  LoadCriteria criteria3(criteriap);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria3.addLoad(loads[i]);
  ASSERT_FALSE(criteria3.empty());
  ASSERT_TRUE(criteria3.checkCriteria(0, true));
  ASSERT_TRUE(criteria3.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithLoads(180, 225, 250, 100);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // P> PMax
  LoadCriteria criteria4(criteriap);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria4.addLoad(loads[i]);
  ASSERT_FALSE(criteria4.empty());
  ASSERT_FALSE(criteria4.checkCriteria(0, true));
  ASSERT_EQ(criteria4.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria4.getFailingCriteria()[0].second, "SourcePowerAboveMax 350 200 MyCriteria");

  data = createBusBreakerNetworkWithLoads(180, 225, 10, 10);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // P< PMin
  criteriap->setScope(CriteriaParams::FINAL);
  LoadCriteria criteria5(criteriap);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria5.addLoad(loads[i]);
  ASSERT_FALSE(criteria5.empty());
  ASSERT_TRUE(criteria5.checkCriteria(0, false));
  ASSERT_TRUE(criteria5.getFailingCriteria().empty());
  ASSERT_FALSE(criteria5.checkCriteria(0, true));
  ASSERT_EQ(criteria5.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria5.getFailingCriteria()[0].second, "SourcePowerBelowMin 20 50 MyCriteria");

  // Multiple voltage levels
  criteriap = CriteriaParamsFactory::newCriteriaParams();
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(300);
  vl.setUMaxPu(0.8);
  vl.setUMinPu(0.2);
  criteriap->addVoltageLevel(vl);
  criteria::CriteriaParamsVoltageLevel vl2;
  vl2.setUNomMin(400);
  vl.setUNomMax(600);
  vl.setUMaxPu(0.8);
  vl.setUMinPu(0.2);
  criteriap->addVoltageLevel(vl2);
  criteriap->setPMax(200);
  criteriap->setPMin(50);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setId("MyCriteria");
  data = createBusBreakerNetworkWithLoads(180, 225, 250, 100);
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // P> PMax
  LoadCriteria criteria6(criteriap);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria6.addLoad(loads[i]);
  loads = data->getNetwork()->getVoltageLevels()[1]->getLoads();
  for (size_t i = 0; i < loads.size(); ++i)
    criteria6.addLoad(loads[i]);
  ASSERT_FALSE(criteria6.empty());
  ASSERT_FALSE(criteria6.checkCriteria(0, false));
  ASSERT_EQ(criteria6.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria6.getFailingCriteria()[0].second, "SourcePowerAboveMax 700 200 MyCriteria");
}

TEST(DataInterfaceIIDMTest, testLoadCriteriaDataIIDMLocalValue) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  boost::shared_ptr<criteria::Criteria> criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  boost::shared_ptr<CriteriaCollection> collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  shared_ptr<DataInterface> data = createBusBreakerNetworkWithLoads(180, 225, 100, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // not eligible
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(190, 200, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // vNom < min
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(190, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax
  ASSERT_FALSE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addCountry("BE");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax but country filter is KO
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addCountry("FR");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax and country filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addCountry("FR");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(180, 225, 200, 100, false);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax and country filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
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
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
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
  ASSERT_FALSE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
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
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::FINAL);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
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
  ASSERT_TRUE(data->checkCriteria(0, false));
  ASSERT_FALSE(data->checkCriteria(0, true));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyLoad");
  criteria->addCountry("BE");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax but country filter is KO
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyLoad");
  criteria->addCountry("FR");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax and country filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyLoad");
  criteria->addCountry("FR");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(180, 225, 200, 100, false);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax and country filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));
}

TEST(DataInterfaceIIDMTest, testLoadCriteriaDataIIDMSum) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  boost::shared_ptr<criteria::Criteria> criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  boost::shared_ptr<CriteriaCollection> collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  shared_ptr<DataInterface> data = createBusBreakerNetworkWithLoads(180, 225, 100, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // not eligible
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(190, 200, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // vNom < min
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(190, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
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
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(180, 225, 50, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // sum(P)<= PMax
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
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
  ASSERT_FALSE(data->checkCriteria(0, false));
  std::vector<std::pair<double, std::string> > failingCriteria;
  data->getFailingCriteria(failingCriteria);
  ASSERT_EQ(failingCriteria.size(), 1);
  ASSERT_EQ(failingCriteria[0].second, "SourcePowerAboveMax 300 150 MyCriteria");

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
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
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::FINAL);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::LOAD, criteria);
  data = createBusBreakerNetworkWithLoads(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(0, false));
  ASSERT_FALSE(data->checkCriteria(0, true));
}

TEST(DataInterfaceIIDMTest, testGeneratorCriteriaLocalValue) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  ASSERT_FALSE(GeneratorCriteria::criteriaEligibleForGenerator(criteriap));
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  vl.setUMinPu(0.2);
  criteriap->addVoltageLevel(vl);
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
  ASSERT_TRUE(criteria.checkCriteria(0, true));
  ASSERT_TRUE(criteria.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithGenerators(43, 225, 250, 100);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // V < uMinPu*VNom
  GeneratorCriteria criteria2(criteriap);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria2.addGenerator(generators[i]);
  ASSERT_FALSE(criteria2.empty());
  ASSERT_TRUE(criteria2.checkCriteria(0, true));
  ASSERT_TRUE(criteria2.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithGenerators(180, 225, 100, 100);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // OK
  GeneratorCriteria criteria3(criteriap);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria3.addGenerator(generators[i]);
  ASSERT_FALSE(criteria3.empty());
  ASSERT_TRUE(criteria3.checkCriteria(0, true));
  ASSERT_TRUE(criteria3.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithGenerators(180, 225, 250, 100);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // P> PMax
  GeneratorCriteria criteria4(criteriap);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria4.addGenerator(generators[i]);
  ASSERT_FALSE(criteria4.empty());
  ASSERT_FALSE(criteria4.checkCriteria(0, true));
  ASSERT_EQ(criteria4.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria4.getFailingCriteria()[0].second, "SourceAbovePower MyGen 250 200 MyCriteria");

  data = createBusBreakerNetworkWithGenerators(180, 225, 40, 100);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // P< PMin
  criteriap->setScope(CriteriaParams::FINAL);
  GeneratorCriteria criteria5(criteriap);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria5.addGenerator(generators[i]);
  ASSERT_FALSE(criteria5.empty());
  ASSERT_TRUE(criteria5.checkCriteria(0, false));
  ASSERT_TRUE(criteria5.getFailingCriteria().empty());
  ASSERT_FALSE(criteria5.checkCriteria(0, true));
  ASSERT_EQ(criteria5.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria5.getFailingCriteria()[0].second, "SourceUnderPower MyGen 40 50 MyCriteria");

  // Multiple voltage levels
  criteriap = CriteriaParamsFactory::newCriteriaParams();
  vl.reset();
  vl.setUNomMin(300);
  vl.setUNomMax(400);
  criteriap->addVoltageLevel(vl);
  criteria::CriteriaParamsVoltageLevel vl2;
  vl2.setUNomMin(225);
  vl2.setUNomMax(400);
  criteriap->addVoltageLevel(vl2);
  criteriap->setPMax(200);
  criteriap->setPMin(50);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setId("MyCriteria");

  data = createBusBreakerNetworkWithGenerators(180, 225, 250, 100);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // P> PMax
  GeneratorCriteria criteria6(criteriap);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria6.addGenerator(generators[i]);
  ASSERT_FALSE(criteria6.empty());
  ASSERT_FALSE(criteria6.checkCriteria(0, false));
  ASSERT_EQ(criteria6.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria6.getFailingCriteria()[0].second, "SourceAbovePower MyGen 250 200 MyCriteria");
}

TEST(DataInterfaceIIDMTest, testGeneratorCriteriaSum) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  vl.setUMinPu(0.2);
  criteriap->addVoltageLevel(vl);
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
  ASSERT_TRUE(criteria.checkCriteria(0, true));
  ASSERT_TRUE(criteria.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithGenerators(43, 225, 250, 100);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // V < uMinPu*VNom
  GeneratorCriteria criteria2(criteriap);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria2.addGenerator(generators[i]);
  ASSERT_FALSE(criteria2.empty());
  ASSERT_TRUE(criteria2.checkCriteria(0, true));
  ASSERT_TRUE(criteria2.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithGenerators(180, 225, 50, 50);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // OK
  GeneratorCriteria criteria3(criteriap);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria3.addGenerator(generators[i]);
  ASSERT_FALSE(criteria3.empty());
  ASSERT_TRUE(criteria3.checkCriteria(0, true));
  ASSERT_TRUE(criteria3.getFailingCriteria().empty());

  data = createBusBreakerNetworkWithGenerators(180, 225, 250, 100);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // P> PMax
  GeneratorCriteria criteria4(criteriap);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria4.addGenerator(generators[i]);
  ASSERT_FALSE(criteria4.empty());
  ASSERT_FALSE(criteria4.checkCriteria(0, true));
  ASSERT_EQ(criteria4.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria4.getFailingCriteria()[0].second, "SourcePowerAboveMax 350 200 MyCriteria");

  data = createBusBreakerNetworkWithGenerators(180, 225, 10, 10);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // P< PMin
  criteriap->setScope(CriteriaParams::FINAL);
  GeneratorCriteria criteria5(criteriap);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria5.addGenerator(generators[i]);
  ASSERT_FALSE(criteria5.empty());
  ASSERT_TRUE(criteria5.checkCriteria(0, false));
  ASSERT_TRUE(criteria5.getFailingCriteria().empty());
  ASSERT_FALSE(criteria5.checkCriteria(0, true));
  ASSERT_EQ(criteria5.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria5.getFailingCriteria()[0].second, "SourcePowerBelowMin 20 50 MyCriteria");

  // Multiple voltage levels
  criteriap = CriteriaParamsFactory::newCriteriaParams();
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(300);
  vl.setUMaxPu(0.8);
  vl.setUMinPu(0.2);
  criteriap->addVoltageLevel(vl);
  criteria::CriteriaParamsVoltageLevel vl2;
  vl2.setUNomMin(400);
  vl.setUNomMax(600);
  vl.setUMaxPu(0.8);
  vl.setUMinPu(0.2);
  criteriap->addVoltageLevel(vl2);
  criteriap->setPMax(200);
  criteriap->setPMin(50);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setId("MyCriteria");
  data = createBusBreakerNetworkWithGenerators(180, 225, 250, 100);
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // P> PMax
  GeneratorCriteria criteria6(criteriap);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria6.addGenerator(generators[i]);
  generators = data->getNetwork()->getVoltageLevels()[1]->getGenerators();
  for (size_t i = 0; i < generators.size(); ++i)
    criteria6.addGenerator(generators[i]);
  ASSERT_FALSE(criteria6.empty());
  ASSERT_FALSE(criteria6.checkCriteria(0, false));
  ASSERT_EQ(criteria6.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria6.getFailingCriteria()[0].second, "SourcePowerAboveMax 700 200 MyCriteria");
}

TEST(DataInterfaceIIDMTest, testGeneratorCriteriaDataIIDMLocalValue) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  boost::shared_ptr<criteria::Criteria> criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  boost::shared_ptr<CriteriaCollection> collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  shared_ptr<DataInterface> data = createBusBreakerNetworkWithGenerators(180, 225, 100, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // not eligible
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(190, 200, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // vNom < min
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(190, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax
  ASSERT_FALSE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addCountry("BE");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax but country filter is KO
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addCountry("FR");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax and country filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addCountry("FR");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 225, 200, 100, false);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax and country filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
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
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
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
  ASSERT_FALSE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
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
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::FINAL);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
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
  ASSERT_TRUE(data->checkCriteria(0, false));
  ASSERT_FALSE(data->checkCriteria(0, true));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyGen");
  criteria->addCountry("BE");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax but criteria filter is KO
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyGen");
  criteria->addCountry("FR");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax and criteria filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::LOCAL_VALUE);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  criteria->addComponentId("MyGen");
  criteria->addCountry("FR");
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 225, 200, 100, false);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax and criteria filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));
}

TEST(DataInterfaceIIDMTest, testGeneratorCriteriaDataIIDMSum) {
  boost::shared_ptr<CriteriaParams> criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  boost::shared_ptr<criteria::Criteria> criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  boost::shared_ptr<CriteriaCollection> collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  shared_ptr<DataInterface> data = createBusBreakerNetworkWithGenerators(180, 225, 100, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // not eligible
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(190, 200, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // vNom < min
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(190, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
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
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 225, 50, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // sum(P)<= PMax
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // P > PMax
  ASSERT_FALSE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
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
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap = CriteriaParamsFactory::newCriteriaParams();
  criteriap->setType(CriteriaParams::SUM);
  criteriap->setScope(CriteriaParams::FINAL);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap->addVoltageLevel(vl);
  criteriap->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap);
  collection = CriteriaCollectionFactory::newInstance();
  collection->add(CriteriaCollection::GENERATOR, criteria);
  data = createBusBreakerNetworkWithGenerators(180, 225, 200, 100);
  exportStates(data);
  data->configureCriteria(collection);
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(0, false));
  ASSERT_FALSE(data->checkCriteria(0, true));
}

}  // namespace DYN
