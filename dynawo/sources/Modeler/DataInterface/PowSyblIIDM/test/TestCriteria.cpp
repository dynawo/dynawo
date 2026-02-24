//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file Modeler/DataInterface/PowSyblIIDM/test/TestCriteria.cpp
 * @brief Unit tests for criteria classes
 *
 */

#include "gtest_dynawo.h"
#include "DYNIoDico.h"
#include "DYNExecUtils.h"
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
#include "PARParametersSetFactory.h"
#include "TLTimelineFactory.h"
#include <boost/algorithm/string.hpp>

#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/SubstationAdder.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>
#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Load.hpp>
#include <powsybl/iidm/LoadAdder.hpp>
#include <powsybl/iidm/Generator.hpp>
#include <powsybl/iidm/GeneratorAdder.hpp>
#include <powsybl/iidm/TwoWindingsTransformerAdder.hpp>

using boost::shared_ptr;
using criteria::CriteriaFactory;
using criteria::CriteriaParams;
using criteria::CriteriaParamsFactory;
using criteria::CriteriaCollection;
using criteria::CriteriaCollectionFactory;

namespace DYN {

static shared_ptr<DataInterface>
createDataItfFromNetworkCriteria(const boost::shared_ptr<powsybl::iidm::Network>& network) {
  shared_ptr<DataInterface> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  return data;
}

static boost::shared_ptr<powsybl::iidm::Network>
createNodeBreakerNetworkCriteria() {
  auto network = boost::make_shared<powsybl::iidm::Network>("MyNetwork", "MyNetwork");

  auto& substation = network->newSubstation()
    .setId("MySubStation")
    .setName("MySubStation_NAME")
    .setTso("TSO")
    .add();

  auto& vl = substation.newVoltageLevel()
    .setId("MyVoltageLevel")
    .setName("MyVoltageLevel_NAME")
    .setTopologyKind(powsybl::iidm::TopologyKind::NODE_BREAKER)
    .setNominalV(225.)
    .setLowVoltageLimit(120.)
    .setHighVoltageLimit(150.)
    .add();
  vl.getNodeBreakerView().newBusbarSection()
    .setId("MyBusBarSection")
    .setName("MyBusBarSection_NAME")
    .setNode(0)
    .add();
  vl.getNodeBreakerView().newBreaker()
    .setId("BK1")
    .setNode1(0)
    .setNode2(1)
    .setRetained(true)
    .setOpen(false)
    .add();
  vl.newLoad()
    .setId("MyLoad")
    .setName("MyLoad_NAME")
    .setNode(1)
    .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
    .setP0(105.0)
    .setQ0(90.0)
    .add();

  auto& calculatedIIDMBus0 = vl.getBusBreakerView().getBus("MyVoltageLevel_0").get();
  calculatedIIDMBus0.setV(190.);
  calculatedIIDMBus0.setAngle(1.5);

  return network;
}

static boost::shared_ptr<powsybl::iidm::Network>
createBusBreakerNetwork(double busV, double busVNom, bool addCountry = true) {
  auto network = boost::make_shared<powsybl::iidm::Network>("MyNetwork", "MyNetwork");

  auto substationAdder = network->newSubstation()
                                     .setId("MySubStation")
                                     .setName("MySubStation_NAME")
                                     .setTso("TSO");

  if (addCountry)
    substationAdder.setCountry(powsybl::iidm::Country::FR);
  powsybl::iidm::Substation& substation = substationAdder.add();

  powsybl::iidm::VoltageLevel& vl1 = substation.newVoltageLevel()
                                     .setId("MyVoltageLevel")
                                     .setName("MyVoltageLevel_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalV(busVNom)
                                     .add();

  powsybl::iidm::Bus& bus = vl1.getBusBreakerView().newBus().setId("MyBus").add();
  bus.setV(busV);
  bus.setAngle(1.5);
  return network;
}

static boost::shared_ptr<powsybl::iidm::Network>
createBusBreakerNetworkWithLoads(double busV, double busVNom, double pow1, double pow2, bool addCountry = true) {
  auto network = boost::make_shared<powsybl::iidm::Network>("MyNetwork", "MyNetwork");

  auto substationAdder = network->newSubstation()
                                     .setId("MySubStation")
                                     .setName("MySubStation_NAME")
                                     .setTso("TSO");

  if (addCountry)
    substationAdder.setCountry(powsybl::iidm::Country::FR);
  powsybl::iidm::Substation& substation = substationAdder.add();

  powsybl::iidm::VoltageLevel& vl1 = substation.newVoltageLevel()
                                     .setId("MyVoltageLevel")
                                     .setName("MyVoltageLevel_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalV(busVNom)
                                     .add();

  powsybl::iidm::Bus& bus = vl1.getBusBreakerView().newBus().setId("MyBus").add();
  bus.setV(busV);
  bus.setAngle(1.5);

  powsybl::iidm::Load& load = vl1.newLoad()
      .setId("MyLoad")
      .setBus("MyBus")
      .setConnectableBus("MyBus")
      .setName("MyLoad_NAME")
      .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
      .setP0(pow1)
      .setQ0(90.0)
      .add();
  load.getTerminal().setP(pow1);
  load.getTerminal().setQ(90.);

  powsybl::iidm::Load& load2 = vl1.newLoad()
      .setId("MyLoad2")
      .setBus("MyBus")
      .setConnectableBus("MyBus")
      .setName("MyLoad2_NAME")
      .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
      .setP0(pow2)
      .setQ0(90.0)
      .add();
  load2.getTerminal().setP(pow2);
  load2.getTerminal().setQ(90.);

  powsybl::iidm::VoltageLevel& vl2 = substation.newVoltageLevel()
                                     .setId("MyVoltageLevel2")
                                     .setName("MyVoltageLevel2_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalV(500)
                                     .add();

  powsybl::iidm::Bus& bus2 = vl2.getBusBreakerView().newBus().setId("MyBus2").add();
  bus2.setV(400);
  bus2.setAngle(1.5);

  powsybl::iidm::Load& load3 = vl2.newLoad()
      .setId("MyLoad3")
      .setBus("MyBus2")
      .setConnectableBus("MyBus2")
      .setName("MyLoad3_NAME")
      .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
      .setP0(pow1)
      .setQ0(90.0)
      .add();
  load3.getTerminal().setP(pow1);
  load3.getTerminal().setQ(90.);

  powsybl::iidm::Load& load4 = vl2.newLoad()
      .setId("MyLoad4")
      .setBus("MyBus2")
      .setConnectableBus("MyBus2")
      .setName("MyLoad4_NAME")
      .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
      .setP0(pow2)
      .setQ0(90.0)
      .add();
  load4.getTerminal().setP(pow2);
  load4.getTerminal().setQ(90.);

  substation.newTwoWindingsTransformer()
      .setId("MyTransformer2Winding")
      .setVoltageLevel1(vl1.getId())
      .setBus1(bus.getId())
      .setConnectableBus1(bus.getId())
      .setVoltageLevel2(vl2.getId())
      .setBus2(bus2.getId())
      .setConnectableBus2(bus2.getId())
      .setR(1.1)
      .setX(1.2)
      .setG(1.3)
      .setB(1.4)
      .setRatedU1(busV)
      .setRatedU2(400)
      .setRatedS(3.0)
      .add();
  return network;
}

static boost::shared_ptr<powsybl::iidm::Network>
createBusBreakerNetworkWithLoads2(double busV1, double busV2, double busVNom, double pow1, double pow2, bool addCountry = true) {
  auto network = boost::make_shared<powsybl::iidm::Network>("MyNetwork", "MyNetwork");

  auto substationAdder = network->newSubstation()
                                     .setId("MySubStation")
                                     .setName("MySubStation_NAME")
                                     .setTso("TSO");

  if (addCountry)
    substationAdder.setCountry(powsybl::iidm::Country::FR);
  powsybl::iidm::Substation& substation = substationAdder.add();

  powsybl::iidm::VoltageLevel& vl1 = substation.newVoltageLevel()
                                     .setId("MyVoltageLevel1")
                                     .setName("MyVoltageLevel1_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalV(busVNom)
                                     .add();

  powsybl::iidm::Bus& bus1 = vl1.getBusBreakerView().newBus().setId("MyBus1").add();
  bus1.setV(busV1);
  bus1.setAngle(1.5);

  powsybl::iidm::Load& load = vl1.newLoad()
      .setId("MyLoad1")
      .setBus("MyBus1")
      .setConnectableBus("MyBus1")
      .setName("MyLoad1_NAME")
      .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
      .setP0(pow1)
      .setQ0(90.0)
      .add();
  load.getTerminal().setP(pow1);
  load.getTerminal().setQ(90.);

  powsybl::iidm::Load& load2 = vl1.newLoad()
      .setId("MyLoad2")
      .setBus("MyBus1")
      .setConnectableBus("MyBus1")
      .setName("MyLoad2_NAME")
      .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
      .setP0(pow2)
      .setQ0(90.0)
      .add();
  load2.getTerminal().setP(pow2);
  load2.getTerminal().setQ(90.);

  powsybl::iidm::VoltageLevel& vl2 = substation.newVoltageLevel()
                                     .setId("MyVoltageLevel2")
                                     .setName("MyVoltageLevel2_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalV(busVNom)
                                     .add();

  powsybl::iidm::Bus& bus2 = vl2.getBusBreakerView().newBus().setId("MyBus2").add();
  bus2.setV(busV2);
  bus2.setAngle(1.5);

  powsybl::iidm::Load& load3 = vl2.newLoad()
      .setId("MyLoad3")
      .setBus("MyBus2")
      .setConnectableBus("MyBus2")
      .setName("MyLoad3_NAME")
      .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
      .setP0(pow1)
      .setQ0(90.0)
      .add();
  load3.getTerminal().setP(pow1);
  load3.getTerminal().setQ(90.);

  powsybl::iidm::Load& load4 = vl2.newLoad()
      .setId("MyLoad4")
      .setBus("MyBus2")
      .setConnectableBus("MyBus2")
      .setName("MyLoad4_NAME")
      .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
      .setP0(pow2)
      .setQ0(90.0)
      .add();
  load4.getTerminal().setP(pow2);
  load4.getTerminal().setQ(90.);

  substation.newTwoWindingsTransformer()
      .setId("MyTransformer2Winding")
      .setVoltageLevel1(vl1.getId())
      .setBus1(bus1.getId())
      .setConnectableBus1(bus1.getId())
      .setVoltageLevel2(vl2.getId())
      .setBus2(bus2.getId())
      .setConnectableBus2(bus2.getId())
      .setR(1.1)
      .setX(1.2)
      .setG(1.3)
      .setB(1.4)
      .setRatedU1(busV1)
      .setRatedU2(busV2)
      .setRatedS(3.0)
      .add();
  return network;
}

static boost::shared_ptr<powsybl::iidm::Network>
createBusBreakerNetworkWithGenerators(double busV, double busVNom, double pow1, double pow2, bool addCountry = true) {
  auto network = boost::make_shared<powsybl::iidm::Network>("MyNetwork", "MyNetwork");

  auto substationAdder = network->newSubstation()
                                     .setId("MySubStation")
                                     .setName("MySubStation_NAME")
                                     .setTso("TSO");

  if (addCountry)
    substationAdder.setCountry(powsybl::iidm::Country::FR);
  powsybl::iidm::Substation& substation = substationAdder.add();

  powsybl::iidm::VoltageLevel& vl1 = substation.newVoltageLevel()
                                     .setId("MyVoltageLevel")
                                     .setName("MyVoltageLevel_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalV(busVNom)
                                     .add();

  powsybl::iidm::Bus& bus = vl1.getBusBreakerView().newBus().setId("MyBus").add();
  bus.setV(busV);
  bus.setAngle(1.5);

  powsybl::iidm::Generator& gen = vl1.newGenerator()
      .setId("MyGen")
      .setBus("MyBus")
      .setConnectableBus("MyBus")
      .setName("MyGen_NAME")
      .setTargetP(-105.)
      .setMinP(90.)
      .setMaxP(180.)
      .setTargetQ(-90.0)
      .setTargetV(150.0)
      .setEnergySource(powsybl::iidm::EnergySource::NUCLEAR)
      .setVoltageRegulatorOn(true)
      .add();
  gen.getTerminal().setP(pow1);
  gen.getTerminal().setQ(90.);

  powsybl::iidm::Generator& gen2 = vl1.newGenerator()
      .setId("MyGen2")
      .setBus("MyBus")
      .setConnectableBus("MyBus")
      .setName("MyGen2_NAME")
      .setTargetP(-105.)
      .setMinP(90.)
      .setMaxP(180.)
      .setTargetQ(-90.0)
      .setTargetV(150.0)
      .setEnergySource(powsybl::iidm::EnergySource::NUCLEAR)
      .setVoltageRegulatorOn(true)
      .add();
  gen2.getTerminal().setP(pow2);
  gen2.getTerminal().setQ(90.);

  powsybl::iidm::VoltageLevel& vl2 = substation.newVoltageLevel()
                                     .setId("MyVoltageLevel2")
                                     .setName("MyVoltageLevel2_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalV(500)
                                     .add();

  powsybl::iidm::Bus& bus2 = vl2.getBusBreakerView().newBus().setId("MyBus2").add();
  bus2.setV(400);
  bus2.setAngle(1.5);

  powsybl::iidm::Generator& gen3 = vl2.newGenerator()
      .setId("MyGen3")
      .setBus("MyBus2")
      .setConnectableBus("MyBus2")
      .setName("MyGen3_NAME")
      .setTargetP(-105.)
      .setMinP(90.)
      .setMaxP(180.)
      .setTargetQ(-90.0)
      .setTargetV(150.0)
      .setEnergySource(powsybl::iidm::EnergySource::NUCLEAR)
      .setVoltageRegulatorOn(true)
      .add();
  gen3.getTerminal().setP(pow1);
  gen3.getTerminal().setQ(90.);

  powsybl::iidm::Generator& gen4 = vl2.newGenerator()
      .setId("MyGen4")
      .setBus("MyBus2")
      .setConnectableBus("MyBus2")
      .setName("MyGen4_NAME")
      .setTargetP(-105.)
      .setMinP(90.)
      .setMaxP(180.)
      .setTargetQ(-90.0)
      .setTargetV(150.0)
      .setEnergySource(powsybl::iidm::EnergySource::NUCLEAR)
      .setVoltageRegulatorOn(true)
      .add();
  gen4.getTerminal().setP(pow2);
  gen4.getTerminal().setQ(90.);

  substation.newTwoWindingsTransformer()
      .setId("MyTransformer2Winding")
      .setVoltageLevel1(vl1.getId())
      .setBus1(bus.getId())
      .setConnectableBus1(bus.getId())
      .setVoltageLevel2(vl2.getId())
      .setBus2(bus2.getId())
      .setConnectableBus2(bus2.getId())
      .setR(1.1)
      .setX(1.2)
      .setG(1.3)
      .setB(1.4)
      .setRatedU1(busV)
      .setRatedU2(400)
      .setRatedS(3.0)
      .add();
  return network;
}

static boost::shared_ptr<powsybl::iidm::Network>
createBusBreakerNetworkWithGenerators2(double busV1, double busV2, double busVNom, double pow1, double pow2, bool addCountry = true) {
  auto network = boost::make_shared<powsybl::iidm::Network>("MyNetwork", "MyNetwork");

  auto substationAdder = network->newSubstation()
                                     .setId("MySubStation")
                                     .setName("MySubStation_NAME")
                                     .setTso("TSO");

  if (addCountry)
    substationAdder.setCountry(powsybl::iidm::Country::FR);
  powsybl::iidm::Substation& substation = substationAdder.add();

  powsybl::iidm::VoltageLevel& vl1 = substation.newVoltageLevel()
                                     .setId("MyVoltageLevel1")
                                     .setName("MyVoltageLevel1_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalV(busVNom)
                                     .add();

  powsybl::iidm::Bus& bus1 = vl1.getBusBreakerView().newBus().setId("MyBus1").add();
  bus1.setV(busV1);
  bus1.setAngle(1.5);

  powsybl::iidm::Generator& generator1 = vl1.newGenerator()
      .setId("MyGenerator1")
      .setBus("MyBus1")
      .setConnectableBus("MyBus1")
      .setName("MyGenerator1_NAME")
      .setTargetP(-105.)
      .setMinP(90.)
      .setMaxP(180.)
      .setTargetQ(-90.0)
      .setTargetV(150.0)
      .setEnergySource(powsybl::iidm::EnergySource::NUCLEAR)
      .setVoltageRegulatorOn(true)
      .add();
  generator1.getTerminal().setP(pow1);
  generator1.getTerminal().setQ(90.);

  powsybl::iidm::Generator& generator2 = vl1.newGenerator()
      .setId("MyGen2")
      .setBus("MyBus1")
      .setConnectableBus("MyBus1")
      .setName("MyGen2_NAME")
      .setTargetP(-105.)
      .setMinP(90.)
      .setMaxP(180.)
      .setTargetQ(-90.0)
      .setTargetV(150.0)
      .setEnergySource(powsybl::iidm::EnergySource::NUCLEAR)
      .setVoltageRegulatorOn(true)
      .add();
  generator2.getTerminal().setP(pow2);
  generator2.getTerminal().setQ(90.);

  powsybl::iidm::VoltageLevel& vl2 = substation.newVoltageLevel()
                                     .setId("MyVoltageLevel2")
                                     .setName("MyVoltageLevel2_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalV(busVNom)
                                     .add();

  powsybl::iidm::Bus& bus2 = vl2.getBusBreakerView().newBus().setId("MyBus2").add();
  bus2.setV(busV2);
  bus2.setAngle(1.5);

  powsybl::iidm::Generator& generator3 = vl2.newGenerator()
      .setId("MyGen3")
      .setBus("MyBus2")
      .setConnectableBus("MyBus2")
      .setName("MyGen3_NAME")
      .setTargetP(-105.)
      .setMinP(90.)
      .setMaxP(180.)
      .setTargetQ(-90.0)
      .setTargetV(150.0)
      .setEnergySource(powsybl::iidm::EnergySource::NUCLEAR)
      .setVoltageRegulatorOn(true)
      .add();
  generator3.getTerminal().setP(pow1);
  generator3.getTerminal().setQ(90.);

  powsybl::iidm::Generator& generator4 = vl2.newGenerator()
      .setId("MyGen4")
      .setBus("MyBus2")
      .setConnectableBus("MyBus2")
      .setName("MyGen4_NAME")
      .setTargetP(-105.)
      .setMinP(90.)
      .setMaxP(180.)
      .setTargetQ(-90.0)
      .setTargetV(150.0)
      .setEnergySource(powsybl::iidm::EnergySource::NUCLEAR)
      .setVoltageRegulatorOn(true)
      .add();
  generator4.getTerminal().setP(pow2);
  generator4.getTerminal().setQ(90.);

  substation.newTwoWindingsTransformer()
      .setId("MyTransformer2Winding")
      .setVoltageLevel1(vl1.getId())
      .setBus1(bus1.getId())
      .setConnectableBus1(bus1.getId())
      .setVoltageLevel2(vl2.getId())
      .setBus2(bus2.getId())
      .setConnectableBus2(bus2.getId())
      .setR(1.1)
      .setX(1.2)
      .setG(1.3)
      .setB(1.4)
      .setRatedU1(busV1)
      .setRatedU2(busV2)
      .setRatedS(3.0)
      .add();
  return network;
}

static boost::shared_ptr<powsybl::iidm::Network>
createNetworkWithCustomisableNumberOfLoadsAndGenerators(double busV, double busVNom, const std::vector<double>& loadPowers) {
  auto network = boost::make_shared<powsybl::iidm::Network>("MyNetwork", "MyNetwork");

  auto substationAdder = network->newSubstation()
                                     .setId("MySubStation")
                                     .setName("MySubStation_NAME")
                                     .setTso("TSO");

  substationAdder.setCountry(powsybl::iidm::Country::FR);
  powsybl::iidm::Substation& substation = substationAdder.add();

  powsybl::iidm::VoltageLevel& vl1 = substation.newVoltageLevel()
                                     .setId("MyVoltageLevel")
                                     .setName("MyVoltageLevel_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalV(busVNom)
                                     .add();

  powsybl::iidm::Bus& bus = vl1.getBusBreakerView().newBus().setId("MyBus").add();
  bus.setV(busV);
  bus.setAngle(1.5);

  for (size_t loadPowerIdx = 0; loadPowerIdx < loadPowers.size(); ++loadPowerIdx) {
    std::string loadId = "MyLoad" + std::to_string(loadPowerIdx+1);
    std::string loadName = "MyLoad" + std::to_string(loadPowerIdx+1) + "_NAME";

    powsybl::iidm::Load& load = vl1.newLoad()
        .setId(loadId)
        .setBus("MyBus")
        .setConnectableBus("MyBus")
        .setName(loadName)
        .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
        .setP0(loadPowers[loadPowerIdx])
        .setQ0(90.0)
        .add();
    load.getTerminal().setP(loadPowers[loadPowerIdx]);
    load.getTerminal().setQ(90.);

    std::string generatorId = "MyGen" + std::to_string(loadPowerIdx+1);
    std::string generatorName = "MyGen" + std::to_string(loadPowerIdx+1) + "_NAME";

    powsybl::iidm::Generator& gen = vl1.newGenerator()
      .setId(generatorId)
      .setBus("MyBus")
      .setConnectableBus("MyBus")
      .setName(generatorName)
      .setTargetP(-105.)
      .setMinP(90.)
      .setMaxP(180.)
      .setTargetQ(-90.0)
      .setTargetV(150.0)
      .setEnergySource(powsybl::iidm::EnergySource::NUCLEAR)
      .setVoltageRegulatorOn(true)
      .add();
    gen.getTerminal().setP(loadPowers[loadPowerIdx]);
    gen.getTerminal().setQ(90.);
  }

  return network;
}

static boost::shared_ptr<powsybl::iidm::Network>
createBusBreakerNetworkWithOneFictitiousLoadAmongTwo(double busV, double busVNom, double pow1, double pow2, bool addCountry = true) {
  auto network = boost::make_shared<powsybl::iidm::Network>("MyNetwork", "MyNetwork");

  auto substationAdder = network->newSubstation()
                                     .setId("MySubStation")
                                     .setName("MySubStation_NAME")
                                     .setTso("TSO");

  if (addCountry)
    substationAdder.setCountry(powsybl::iidm::Country::FR);
  powsybl::iidm::Substation& substation = substationAdder.add();

  powsybl::iidm::VoltageLevel& vl1 = substation.newVoltageLevel()
                                     .setId("MyVoltageLevel")
                                     .setName("MyVoltageLevel_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalV(busVNom)
                                     .add();

  powsybl::iidm::Bus& bus = vl1.getBusBreakerView().newBus().setId("MyBus").add();
  bus.setV(busV);
  bus.setAngle(1.5);

  powsybl::iidm::Load& load = vl1.newLoad()
      .setId("MyLoad")
      .setBus("MyBus")
      .setConnectableBus("MyBus")
      .setName("MyLoad_NAME")
      .setLoadType(powsybl::iidm::LoadType::FICTITIOUS)
      .setP0(pow1)
      .setQ0(90.0)
      .add();
  load.getTerminal().setP(pow1);
  load.getTerminal().setQ(90.);

  powsybl::iidm::Load& load2 = vl1.newLoad()
      .setId("MyLoad2")
      .setBus("MyBus")
      .setConnectableBus("MyBus")
      .setName("MyLoad2_NAME")
      .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
      .setP0(pow2)
      .setQ0(90.0)
      .add();
  load2.getTerminal().setP(pow2);
  load2.getTerminal().setQ(90.);

  powsybl::iidm::VoltageLevel& vl2 = substation.newVoltageLevel()
                                     .setId("MyVoltageLevel2")
                                     .setName("MyVoltageLevel2_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalV(500)
                                     .add();

  powsybl::iidm::Bus& bus2 = vl2.getBusBreakerView().newBus().setId("MyBus2").add();
  bus2.setV(400);
  bus2.setAngle(1.5);

  powsybl::iidm::Load& load3 = vl2.newLoad()
      .setId("MyLoad3")
      .setBus("MyBus2")
      .setConnectableBus("MyBus2")
      .setName("MyLoad3_NAME")
      .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
      .setP0(pow1)
      .setQ0(90.0)
      .add();
  load3.getTerminal().setP(pow1);
  load3.getTerminal().setQ(90.);

  powsybl::iidm::Load& load4 = vl2.newLoad()
      .setId("MyLoad4")
      .setBus("MyBus2")
      .setConnectableBus("MyBus2")
      .setName("MyLoad4_NAME")
      .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
      .setP0(pow2)
      .setQ0(90.0)
      .add();
  load4.getTerminal().setP(pow2);
  load4.getTerminal().setQ(90.);

  substation.newTwoWindingsTransformer()
      .setId("MyTransformer2Winding")
      .setVoltageLevel1(vl1.getId())
      .setBus1(bus.getId())
      .setConnectableBus1(bus.getId())
      .setVoltageLevel2(vl2.getId())
      .setBus2(bus2.getId())
      .setConnectableBus2(bus2.getId())
      .setR(1.1)
      .setX(1.2)
      .setG(1.3)
      .setB(1.4)
      .setRatedU1(busV)
      .setRatedU2(400)
      .setRatedS(3.0)
      .add();
  return network;
}

static shared_ptr<SubModel>
initModel(shared_ptr<DataInterface> data) {
  shared_ptr<SubModel> modelNetwork = SubModelFactory::createSubModelFromLib("../../../../../M/CPP/ModelNetwork/DYNModelNetwork" +
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
  parametersSet->createParameter("generator_isVoltageDependent", false);
  parametersSet->createParameter("generator_alpha", 1.5);
  parametersSet->createParameter("generator_beta", 2.5);
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

static void
checkNoLoadIsTestedSeveralTimes(const std::vector<std::pair<double, std::string> >& loadFailingCriteria) {
  std::vector<std::string> checkedLoadList;
  for (std::pair<double, std::string> failingCriterion : loadFailingCriteria) {
    const std::string failingCriterionLog = failingCriterion.second;
    std::vector<std::string> splitFailingCriterionLog;
    boost::algorithm::split(splitFailingCriterionLog, failingCriterionLog, boost::is_any_of(" "));
    const std::string checkedLoadName = splitFailingCriterionLog[1];
    checkedLoadList.push_back(checkedLoadName);
  }
  size_t checkedLoadListSize = checkedLoadList.size();
  for (size_t i = 0; i < checkedLoadListSize; ++i) {
    for (size_t j = i + 1; j < checkedLoadListSize; ++j) {
      ASSERT_NE(checkedLoadList[i], checkedLoadList[j]);
    }
  }
}

TEST(DataInterfaceIIDMTest, Timeline) {
  std::array<criteria::CriteriaParams::CriteriaScope_t, 2> criteriaScopeArray = {CriteriaParams::DYNAMIC,
                                                                                CriteriaParams::FINAL};

  for (criteria::CriteriaParams::CriteriaScope_t criteriaScope : criteriaScopeArray) {
    std::shared_ptr<CriteriaParams> criteriaParams = CriteriaParamsFactory::newCriteriaParams();
    criteriaParams->setPMax(200);
    criteriaParams->setPMin(150);
    criteriaParams->setType(CriteriaParams::LOCAL_VALUE);
    criteriaParams->setScope(criteriaScope);
    criteria::CriteriaParamsVoltageLevel voltageLevel;
    voltageLevel.setUMinPu(0.99);
    voltageLevel.setUMaxPu(1.01);
    criteriaParams->addVoltageLevel(voltageLevel);

    BusCriteria busCriteria(criteriaParams);
    std::vector<boost::shared_ptr<DataInterface> > dataInterfaceArray;
    constexpr int nominalBusVoltage = 150;
    constexpr int numberOfNodes = 10;
    std::array<int, numberOfNodes> busVoltage = {200, 190, 180, 170, 160, 145, 135, 125, 115, 105};
    for (int busVIndex = 0; busVIndex < numberOfNodes; ++busVIndex) {
      boost::shared_ptr<DataInterface> data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(busVoltage[busVIndex], nominalBusVoltage));
      exportStates(data);
      dataInterfaceArray.push_back(data);
    }
    for (int busIndex = 0; busIndex < numberOfNodes; ++busIndex) {
      std::shared_ptr<BusInterface> bus = dataInterfaceArray[busIndex]->getNetwork()->getVoltageLevels()[0]->getBuses()[0];
      busCriteria.addBus(bus);
    }

    boost::shared_ptr<timeline::Timeline> timeline = timeline::TimelineFactory::newInstance("TestCriteria");
    switch (criteriaScope) {
      case CriteriaParams::DYNAMIC:
        busCriteria.checkCriteria(0, false, timeline);
        break;
      case CriteriaParams::FINAL:
        busCriteria.checkCriteria(0, true, timeline);
        break;
      case CriteriaParams::UNDEFINED_SCOPE:
        GTEST_FAIL();
    }
    constexpr int maxNumberOfEvents = 5;
    ASSERT_EQ(timeline->getSizeEvents(), maxNumberOfEvents);  // timeline can't contain more than 5 events for each FailingCriteria
    double busPreviousVoltageDistancePu = std::numeric_limits<double>::max();
    for (const auto& event : timeline->getEvents()) {
      const std::string timelineLog = event->getMessage();
      std::vector<std::string> splitTimelineLog;
      boost::algorithm::split(splitTimelineLog, timelineLog, boost::is_any_of(" "));
      const std::string busErrorLogName = splitTimelineLog[0];
      ASSERT_TRUE(busErrorLogName == "BusAboveVoltage" || busErrorLogName == "BusUnderVoltage");
      const double currentVoltagePu = std::stod(splitTimelineLog[3]);
      const double voltageBoundPu = std::stod(splitTimelineLog[5]);
      const double busCurrentVoltageDistancePu = std::abs(currentVoltagePu - voltageBoundPu);
      // the timeline should display logs with the biggest gap between the voltage and the nominal voltage first
      ASSERT_TRUE(busPreviousVoltageDistancePu >= busCurrentVoltageDistancePu);
      busPreviousVoltageDistancePu = busCurrentVoltageDistancePu;
    }

    double failCritPreviousVoltageDistancePu = std::numeric_limits<double>::max();
    std::vector<std::pair<double, std::string> > busFailingCriteria = busCriteria.getFailingCriteria();
    for (size_t busFailCritIdx = 0; busFailCritIdx < busFailingCriteria.size(); ++busFailCritIdx) {
      const std::string busFailCritLog = busFailingCriteria[busFailCritIdx].second;
      std::vector<std::string> splitBusFailCritLog;
      boost::algorithm::split(splitBusFailCritLog, busFailCritLog, boost::is_any_of(" "));
      const std::string busErrorLogName = splitBusFailCritLog[0];
      ASSERT_TRUE(busErrorLogName == "BusAboveVoltage" || busErrorLogName == "BusUnderVoltage");
      const double currentVoltagePu = std::stod(splitBusFailCritLog[3]);
      const double voltageBoundPu = std::stod(splitBusFailCritLog[5]);
      const double failCritCurrentVoltageDistancePu = std::abs(currentVoltagePu - voltageBoundPu);
      // the failingCriteria_ array should display logs with the biggest gap between the voltage and the nominal voltage first
      ASSERT_TRUE(failCritPreviousVoltageDistancePu >= failCritCurrentVoltageDistancePu);
      failCritPreviousVoltageDistancePu = failCritCurrentVoltageDistancePu;
    }

    std::vector<double> loadPowers = {250, 240, 230, 220, 210, 145, 135, 125, 115, 105};
    boost::shared_ptr<powsybl::iidm::Network> loadNetwork = createNetworkWithCustomisableNumberOfLoadsAndGenerators(400, 400, loadPowers);
    boost::shared_ptr<DataInterface> loadData = createDataItfFromNetworkCriteria(loadNetwork);
    exportStates(loadData);

    LoadCriteria loadCriteria(criteriaParams);
    std::vector<std::shared_ptr<LoadInterface> > loads = loadData->getNetwork()->getVoltageLevels()[0]->getLoads();
    for (size_t loadsIdx = 0; loadsIdx < loads.size(); ++loadsIdx) {
      loadCriteria.addLoad(loads[loadsIdx]);
    }

    switch (criteriaScope) {
      case CriteriaParams::DYNAMIC:
        loadCriteria.checkCriteria(0, false, timeline);
        break;
      case CriteriaParams::FINAL:
        loadCriteria.checkCriteria(0, true, timeline);
        break;
      case CriteriaParams::UNDEFINED_SCOPE:
        GTEST_FAIL();
    }
    double loadPreviousLoadPowerDistance = std::numeric_limits<double>::max();
    ASSERT_EQ(timeline->getSizeEvents(), maxNumberOfEvents * 2);  // timeline can't contain more than 5 events for each FailingCriteria
    int firstTimelineLoadEvent = 0;
    // increment the iterator to place it on the first load timeline event
    for (int i = 0; i < maxNumberOfEvents; ++i) {
      ++firstTimelineLoadEvent;
    }
    for (int i = firstTimelineLoadEvent; i < timeline->getSizeEvents(); ++i) {
      const std::string timelineLog = timeline->getEvents()[i]->getMessage();
      std::vector<std::string> splitTimelineLog;
      boost::algorithm::split(splitTimelineLog, timelineLog, boost::is_any_of(" "));
      const std::string loadErrorLogName = splitTimelineLog[0];
      ASSERT_TRUE(loadErrorLogName == "SourceAbovePower" || loadErrorLogName == "SourceUnderPower");
      const double loadPower = std::stod(splitTimelineLog[2]);
      const double loadPowerBound = std::stod(splitTimelineLog[3]);
      const double loadCurrentLoadPowerDistance = std::abs(loadPower - loadPowerBound);
      // the failingCriteria_ array should display logs with the biggest gap between the load power and the nominal load power first
      ASSERT_TRUE(loadPreviousLoadPowerDistance >= loadCurrentLoadPowerDistance);
      loadPreviousLoadPowerDistance = loadCurrentLoadPowerDistance;
    }

    double failCritPreviousLoadPowerDistance = std::numeric_limits<double>::max();
    std::vector<std::pair<double, std::string> > loadFailingCriteria = loadCriteria.getFailingCriteria();
    for (size_t loadFailCritIdx = 0; loadFailCritIdx < loadFailingCriteria.size(); ++loadFailCritIdx) {
      const std::string loadFailCritLog = loadFailingCriteria[loadFailCritIdx].second;
      std::vector<std::string> splitLoadFailCritLog;
      boost::algorithm::split(splitLoadFailCritLog, loadFailCritLog, boost::is_any_of(" "));
      const std::string loadErrorLogName = splitLoadFailCritLog[0];
      ASSERT_TRUE(loadErrorLogName == "SourceAbovePower" || loadErrorLogName == "SourceUnderPower");
      const double loadPower = std::stod(splitLoadFailCritLog[2]);
      const double loadPowerBound = std::stod(splitLoadFailCritLog[3]);
      const double failCritCurrentLoadPowerDistance = std::abs(loadPower - loadPowerBound);
      // the failingCriteria_ array should display logs with the biggest gap between the load power and the nominal load power first
      ASSERT_TRUE(failCritPreviousLoadPowerDistance >= failCritCurrentLoadPowerDistance);
      failCritPreviousLoadPowerDistance = failCritCurrentLoadPowerDistance;
    }

    GeneratorCriteria generatorCriteria(criteriaParams);
    std::vector<std::shared_ptr<GeneratorInterface> > generators = loadData->getNetwork()->getVoltageLevels()[0]->getGenerators();
    for (size_t generatorsIdx = 0; generatorsIdx < generators.size(); ++generatorsIdx) {
      generatorCriteria.addGenerator(generators[generatorsIdx]);
    }

    switch (criteriaScope) {
      case CriteriaParams::DYNAMIC:
        generatorCriteria.checkCriteria(0, false, timeline);
        break;
      case CriteriaParams::FINAL:
        generatorCriteria.checkCriteria(0, true, timeline);
        break;
      case CriteriaParams::UNDEFINED_SCOPE:
        GTEST_FAIL();
    }
    double generatorPreviousGeneratorPowerDistance = std::numeric_limits<double>::max();
    ASSERT_EQ(timeline->getSizeEvents(), maxNumberOfEvents * 3);  // timeline can't contain more than 5 events for each FailingCriteria
    int firstTimelineGeneratorEvent = 0;
    // increment the iterator to place it on the first generator timeline event
    for (int i = 0; i < maxNumberOfEvents * 2; ++i) {
      ++firstTimelineGeneratorEvent;
    }
    for (int i = firstTimelineGeneratorEvent; i < timeline->getSizeEvents(); ++i) {
      const std::string timelineLog = timeline->getEvents()[i]->getMessage();
      std::vector<std::string> splitTimelineLog;
      boost::algorithm::split(splitTimelineLog, timelineLog, boost::is_any_of(" "));
      const std::string generatorErrorLogName = splitTimelineLog[0];
      ASSERT_TRUE(generatorErrorLogName == "SourceAbovePower" || generatorErrorLogName == "SourceUnderPower");
      const double generatorPower = std::stod(splitTimelineLog[2]);
      const double generatorPowerBound = std::stod(splitTimelineLog[3]);
      double currentGeneratorPowerDistance = std::abs(generatorPower - generatorPowerBound);
      // the timeline should display logs with the biggest gap between the load power and the nominal load power first
      ASSERT_TRUE(generatorPreviousGeneratorPowerDistance >= currentGeneratorPowerDistance);
      generatorPreviousGeneratorPowerDistance = currentGeneratorPowerDistance;
    }

    double failCritPreviousGeneratorPowerDistance = std::numeric_limits<double>::max();
    std::vector<std::pair<double, std::string> > generatorFailingCriteria = generatorCriteria.getFailingCriteria();
    for (size_t generatorFailCritIdx = 0; generatorFailCritIdx < generatorFailingCriteria.size(); ++generatorFailCritIdx) {
      const std::string generatorFailCritLog = generatorFailingCriteria[generatorFailCritIdx].second;
      std::vector<std::string> splitGeneratorFailCritLog;
      boost::algorithm::split(splitGeneratorFailCritLog, generatorFailCritLog, boost::is_any_of(" "));
      const std::string generatorErrorLogName = splitGeneratorFailCritLog[0];
      ASSERT_TRUE(generatorErrorLogName == "SourceAbovePower" || generatorErrorLogName == "SourceUnderPower");
      const double generatorPower = std::stod(splitGeneratorFailCritLog[2]);
      const double generatorPowerBound = std::stod(splitGeneratorFailCritLog[3]);
      const double failCritCurrentGeneratorPowerDistance = std::abs(generatorPower - generatorPowerBound);
      // the failingCriteria_ array should display logs with the biggest gap between the load power and the nominal load power first
      ASSERT_TRUE(failCritPreviousGeneratorPowerDistance >= failCritCurrentGeneratorPowerDistance);
      failCritPreviousGeneratorPowerDistance = failCritCurrentGeneratorPowerDistance;
    }
  }

  for (criteria::CriteriaParams::CriteriaScope_t criteriaScope : criteriaScopeArray) {
    std::shared_ptr<CriteriaParams> criteriaParams = CriteriaParamsFactory::newCriteriaParams();
    criteriaParams->setPMax(825);
    criteriaParams->setPMin(120);
    criteriaParams->setType(CriteriaParams::SUM);
    criteriaParams->setScope(criteriaScope);
    criteria::CriteriaParamsVoltageLevel voltageLevel;
    voltageLevel.setUMinPu(0.99);
    voltageLevel.setUMaxPu(1.01);
    criteriaParams->addVoltageLevel(voltageLevel);

    enum class TestCriteriaBound {
      MAX = 0,
      MIN
    };

    std::map<TestCriteriaBound, std::vector<double> > loadPowersLists;
    const std::vector<double> maxLoadPowers = {211, 145, 0, 105, 250, 1e-6, 115};
    const std::vector<double> minLoadPowers = {50, 29, 0, 1e-5, 40};
    loadPowersLists.insert({TestCriteriaBound::MAX, maxLoadPowers});
    loadPowersLists.insert({TestCriteriaBound::MIN, minLoadPowers});

    for (const auto& loadPowers : loadPowersLists) {
      boost::shared_ptr<powsybl::iidm::Network> loadNetwork = createNetworkWithCustomisableNumberOfLoadsAndGenerators(400, 400, loadPowers.second);
      boost::shared_ptr<DataInterface> data = createDataItfFromNetworkCriteria(loadNetwork);
      exportStates(data);

      LoadCriteria loadCriteria(criteriaParams);
      std::vector<std::shared_ptr<LoadInterface> > loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
      for (const std::shared_ptr<LoadInterface>& load : loads) {
        loadCriteria.addLoad(load);
      }

      boost::shared_ptr<timeline::Timeline> loadTimeline = timeline::TimelineFactory::newInstance("TestLoadCriteria");
      switch (criteriaScope) {
        case CriteriaParams::DYNAMIC:
          loadCriteria.checkCriteria(0, false, loadTimeline);
          break;
        case CriteriaParams::FINAL:
          loadCriteria.checkCriteria(0, true, loadTimeline);
          break;
        case CriteriaParams::UNDEFINED_SCOPE:
          GTEST_FAIL();
      }

      switch (loadPowers.first) {
        case TestCriteriaBound::MAX: {
          ASSERT_EQ(loadTimeline->getSizeEvents(), 7);
          const auto& loadEvents = loadTimeline->getEvents();
          ASSERT_EQ(loadEvents[0]->getMessage(), "SourcePowerTakenIntoAccount load MyLoad5  250 400");
          ASSERT_EQ(loadEvents[1]->getMessage(), "SourcePowerTakenIntoAccount load MyLoad1  211 400");
          ASSERT_EQ(loadEvents[2]->getMessage(), "SourcePowerTakenIntoAccount load MyLoad2  145 400");
          ASSERT_EQ(loadEvents[3]->getMessage(), "SourcePowerTakenIntoAccount load MyLoad7  115 400");
          ASSERT_EQ(loadEvents[4]->getMessage(), "SourcePowerTakenIntoAccount load MyLoad4  105 400");
          ASSERT_EQ(loadEvents[5]->getMessage(), "SourcePowerTakenIntoAccount load MyLoad6  1e-06 400");
          ASSERT_EQ(loadEvents[6]->getMessage(), "SourcePowerAboveMax 826 825 ");
          break;
        }
        case TestCriteriaBound::MIN: {
          ASSERT_EQ(loadTimeline->getSizeEvents(), 5);
          const auto& loadEvents = loadTimeline->getEvents();
          ASSERT_EQ(loadEvents[0]->getMessage(), "SourcePowerTakenIntoAccount load MyLoad4  1e-05 400");
          ASSERT_EQ(loadEvents[1]->getMessage(), "SourcePowerTakenIntoAccount load MyLoad2  29 400");
          ASSERT_EQ(loadEvents[2]->getMessage(), "SourcePowerTakenIntoAccount load MyLoad5  40 400");
          ASSERT_EQ(loadEvents[3]->getMessage(), "SourcePowerTakenIntoAccount load MyLoad1  50 400");
          ASSERT_EQ(loadEvents[4]->getMessage(), "SourcePowerBelowMin 119 120 ");
          break;
        }
      }

      GeneratorCriteria generatorCriteria(criteriaParams);
      std::vector<std::shared_ptr<GeneratorInterface> > generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
      for (const std::shared_ptr<GeneratorInterface>& generator : generators) {
        generatorCriteria.addGenerator(generator);
      }

      boost::shared_ptr<timeline::Timeline> generatorTimeline = timeline::TimelineFactory::newInstance("TestGeneratorCriteria");
      switch (criteriaScope) {
        case CriteriaParams::DYNAMIC:
          generatorCriteria.checkCriteria(0, false, generatorTimeline);
          break;
        case CriteriaParams::FINAL:
          generatorCriteria.checkCriteria(0, true, generatorTimeline);
          break;
        case CriteriaParams::UNDEFINED_SCOPE:
          GTEST_FAIL();
      }

      switch (loadPowers.first) {
        case TestCriteriaBound::MAX: {
          ASSERT_EQ(generatorTimeline->getSizeEvents(), 7);
          const auto& generatorEvents = generatorTimeline->getEvents();
          ASSERT_EQ(generatorEvents[0]->getMessage(), "SourcePowerTakenIntoAccount generator MyGen5  250 400");
          ASSERT_EQ(generatorEvents[1]->getMessage(), "SourcePowerTakenIntoAccount generator MyGen1  211 400");
          ASSERT_EQ(generatorEvents[2]->getMessage(), "SourcePowerTakenIntoAccount generator MyGen2  145 400");
          ASSERT_EQ(generatorEvents[3]->getMessage(), "SourcePowerTakenIntoAccount generator MyGen7  115 400");
          ASSERT_EQ(generatorEvents[4]->getMessage(), "SourcePowerTakenIntoAccount generator MyGen4  105 400");
          ASSERT_EQ(generatorEvents[5]->getMessage(), "SourcePowerTakenIntoAccount generator MyGen6  1e-06 400");
          ASSERT_EQ(generatorEvents[6]->getMessage(), "SourcePowerAboveMax 826 825 ");
          break;
        }
        case TestCriteriaBound::MIN: {
          ASSERT_EQ(generatorTimeline->getSizeEvents(), 5);
          const auto& generatorEvents = generatorTimeline->getEvents();
          ASSERT_EQ(generatorEvents[0]->getMessage(), "SourcePowerTakenIntoAccount generator MyGen4  1e-05 400");
          ASSERT_EQ(generatorEvents[1]->getMessage(), "SourcePowerTakenIntoAccount generator MyGen2  29 400");
          ASSERT_EQ(generatorEvents[2]->getMessage(), "SourcePowerTakenIntoAccount generator MyGen5  40 400");
          ASSERT_EQ(generatorEvents[3]->getMessage(), "SourcePowerTakenIntoAccount generator MyGen1  50 400");
          ASSERT_EQ(generatorEvents[4]->getMessage(), "SourcePowerBelowMin 119 120 ");
          break;
        }
      }
    }
  }
}

TEST(DataInterfaceIIDMTest, testBusCriteria) {
  std::shared_ptr<CriteriaParams> criteriap1 = CriteriaParamsFactory::newCriteriaParams();
  criteriap1->setType(CriteriaParams::SUM);
  ASSERT_FALSE(BusCriteria::criteriaEligibleForBus(criteriap1));
  criteriap1->setType(CriteriaParams::LOCAL_VALUE);
  ASSERT_FALSE(BusCriteria::criteriaEligibleForBus(criteriap1));
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  criteriap1->addVoltageLevel(vl);
  criteriap1->setPMax(100);
  criteriap1->setPMin(0);
  ASSERT_FALSE(BusCriteria::criteriaEligibleForBus(criteriap1));

  criteriap1 = CriteriaParamsFactory::newCriteriaParams();
  criteriap1->setType(CriteriaParams::SUM);
  criteriap1->setType(CriteriaParams::LOCAL_VALUE);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap1->addVoltageLevel(vl);
  criteriap1->setPMax(100);
  criteriap1->setPMin(0);
  ASSERT_TRUE(BusCriteria::criteriaEligibleForBus(criteriap1));
  criteriap1->setId("MyCriteria");

  shared_ptr<DataInterface> data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(180, 190));
  exportStates(data);
  std::shared_ptr<BusInterface> bus = data->getNetwork()->getVoltageLevels()[0]->getBuses()[0];
  BusCriteria criteria(criteriap1);
  // VNom lower than min
  criteria.addBus(bus);
  ASSERT_TRUE(criteria.empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(180, 401));
  exportStates(data);
  bus = data->getNetwork()->getVoltageLevels()[0]->getBuses()[0];
  // VNom higher than max
  criteria.addBus(bus);
  ASSERT_TRUE(criteria.empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(180, 225));
  exportStates(data);
  bus = data->getNetwork()->getVoltageLevels()[0]->getBuses()[0];
  // v<=0.8*vNom
  criteria.addBus(bus);
  ASSERT_FALSE(criteria.empty());
  ASSERT_TRUE(criteria.checkCriteria(0, false));
  ASSERT_TRUE(criteria.getFailingCriteria().empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(190, 225));
  exportStates(data);
  bus = data->getNetwork()->getVoltageLevels()[0]->getBuses()[0];
  // v>0.8*vNom
  BusCriteria criteria2(criteriap1);
  criteria2.addBus(bus);
  ASSERT_FALSE(criteria2.checkCriteria(0, false));
  ASSERT_EQ(criteria2.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria2.getFailingCriteria()[0].second, "BusAboveVoltage MyBus 190 0.844444 180 0.8 MyCriteria");

  std::shared_ptr<CriteriaParams> criteriap2 = CriteriaParamsFactory::newCriteriaParams();
  criteriap2->setType(CriteriaParams::LOCAL_VALUE);
  vl.reset();
  vl.setUMinPu(0.2);
  criteriap2->addVoltageLevel(vl);
  criteriap2->setScope(CriteriaParams::FINAL);
  BusCriteria criteria3(criteriap2);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(190, 225));
  exportStates(data);
  bus = data->getNetwork()->getVoltageLevels()[0]->getBuses()[0];
  // v>=0.2*vNom
  criteria3.addBus(bus);
  ASSERT_TRUE(criteria3.checkCriteria(0, true));
  ASSERT_TRUE(criteria3.getFailingCriteria().empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(43, 225));
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
  std::unique_ptr<CriteriaParams> criteriap1 = CriteriaParamsFactory::newCriteriaParams();
  criteriap1->setType(CriteriaParams::LOCAL_VALUE);
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  criteriap1->addVoltageLevel(vl);
  std::shared_ptr<criteria::Criteria> criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap1));
  std::unique_ptr<CriteriaCollection> collection1 = CriteriaCollectionFactory::newInstance();
  collection1->add(CriteriaCollection::BUS, criteria);
  shared_ptr<DataInterface> data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(180, 225));
  exportStates(data);
  data->configureCriteria(std::move(collection1));
  // not eligible
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap2 = CriteriaParamsFactory::newCriteriaParams();
  criteriap2->setType(CriteriaParams::LOCAL_VALUE);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap2->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap2));
  std::unique_ptr<CriteriaCollection> collection2 = CriteriaCollectionFactory::newInstance();
  collection2->add(CriteriaCollection::BUS, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(190, 200));
  exportStates(data);
  data->configureCriteria(std::move(collection2));
  // vNom < min
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap3 = CriteriaParamsFactory::newCriteriaParams();
  criteriap3->setType(CriteriaParams::LOCAL_VALUE);
  criteriap3->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap3->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap3));
  std::unique_ptr<CriteriaCollection> collection3 = CriteriaCollectionFactory::newInstance();
  collection3->add(CriteriaCollection::BUS, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(190, 225));
  exportStates(data);
  data->configureCriteria(std::move(collection3));
  // v > 0.8*vNom
  ASSERT_FALSE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap4 = CriteriaParamsFactory::newCriteriaParams();
  criteriap4->setType(CriteriaParams::LOCAL_VALUE);
  criteriap4->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap4->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap4));
  criteria->addCountry("BE");
  std::unique_ptr<CriteriaCollection> collection4 = CriteriaCollectionFactory::newInstance();
  collection4->add(CriteriaCollection::BUS, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(190, 225));
  exportStates(data);
  data->configureCriteria(std::move(collection4));
  // v > 0.8*vNom but criteria filter is KO
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap5 = CriteriaParamsFactory::newCriteriaParams();
  criteriap5->setType(CriteriaParams::LOCAL_VALUE);
  criteriap5->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap5->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap5));
  criteria->addCountry("FRANCE");
  std::unique_ptr<CriteriaCollection> collection5 = CriteriaCollectionFactory::newInstance();
  collection5->add(CriteriaCollection::BUS, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(190, 225));
  exportStates(data);
  data->configureCriteria(std::move(collection5));
  // v > 0.8*vNom and criteria filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap6 = CriteriaParamsFactory::newCriteriaParams();
  criteriap6->setType(CriteriaParams::LOCAL_VALUE);
  criteriap6->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap6->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap6));
  criteria->addCountry("FRANCE");
  std::unique_ptr<CriteriaCollection> collection6 = CriteriaCollectionFactory::newInstance();
  collection6->add(CriteriaCollection::BUS, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(190, 225, false));
  exportStates(data);
  data->configureCriteria(std::move(collection6));
  // v > 0.8*vNom and criteria filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap7 = CriteriaParamsFactory::newCriteriaParams();
  criteriap7->setType(CriteriaParams::LOCAL_VALUE);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap7->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap7));
  criteria->addComponentId("MyDummyName");
  std::unique_ptr<CriteriaCollection> collection7 = CriteriaCollectionFactory::newInstance();
  collection7->add(CriteriaCollection::BUS, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(190, 200));
  exportStates(data);
  data->configureCriteria(std::move(collection7));
  // bus not found
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap8 = CriteriaParamsFactory::newCriteriaParams();
  criteriap8->setType(CriteriaParams::LOCAL_VALUE);
  criteriap8->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap8->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap8));
  criteria->addComponentId("MyBus");
  std::unique_ptr<CriteriaCollection> collection8 = CriteriaCollectionFactory::newInstance();
  collection8->add(CriteriaCollection::BUS, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(190, 225));
  exportStates(data);
  data->configureCriteria(std::move(collection8));
  // v > 0.8*vNom
  ASSERT_FALSE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap9 = CriteriaParamsFactory::newCriteriaParams();
  criteriap9->setType(CriteriaParams::LOCAL_VALUE);
  criteriap9->setScope(CriteriaParams::FINAL);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap9->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap9));
  criteria->addComponentId("MyBus");
  std::unique_ptr<CriteriaCollection> collection9 = CriteriaCollectionFactory::newInstance();
  collection9->add(CriteriaCollection::BUS, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(190, 225));
  exportStates(data);
  data->configureCriteria(std::move(collection9));
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(0, false));
  ASSERT_FALSE(data->checkCriteria(0, true));

  std::unique_ptr<CriteriaParams> criteriap10 = CriteriaParamsFactory::newCriteriaParams();
  criteriap10->setType(CriteriaParams::LOCAL_VALUE);
  criteriap10->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap10->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap10));
  criteria->addComponentId("MyBus");
  criteria->addCountry("BE");
  std::unique_ptr<CriteriaCollection> collection10 = CriteriaCollectionFactory::newInstance();
  collection10->add(CriteriaCollection::BUS, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(190, 225));
  exportStates(data);
  data->configureCriteria(std::move(collection10));
  // v > 0.8*vNom but the bus is ignored due to country filter
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap11 = CriteriaParamsFactory::newCriteriaParams();
  criteriap11->setType(CriteriaParams::LOCAL_VALUE);
  criteriap11->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap11->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap11));
  criteria->addComponentId("MyBus");
  criteria->addCountry("FRANCE");
  std::unique_ptr<CriteriaCollection> collection11 = CriteriaCollectionFactory::newInstance();
  collection11->add(CriteriaCollection::BUS, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(190, 225));
  exportStates(data);
  data->configureCriteria(std::move(collection11));
  // v > 0.8*vNom and the country filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap12 = CriteriaParamsFactory::newCriteriaParams();
  criteriap12->setType(CriteriaParams::LOCAL_VALUE);
  criteriap12->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap12->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap12));
  criteria->addComponentId("MyBus");
  criteria->addCountry("FRANCE");
  std::unique_ptr<CriteriaCollection> collection12 = CriteriaCollectionFactory::newInstance();
  collection12->add(CriteriaCollection::BUS, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetwork(190, 225, false));
  exportStates(data);
  data->configureCriteria(std::move(collection12));
  // v > 0.8*vNom and the country filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap13 = CriteriaParamsFactory::newCriteriaParams();
  criteriap13->setType(CriteriaParams::LOCAL_VALUE);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap13->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap13));
  criteria->addComponentId("MyBusBarSection", "DummyVoltageLevel");
  std::unique_ptr<CriteriaCollection> collection13 = CriteriaCollectionFactory::newInstance();
  collection13->add(CriteriaCollection::BUS, criteria);
  data = createDataItfFromNetworkCriteria(createNodeBreakerNetworkCriteria());
  exportStates(data);
  data->configureCriteria(std::move(collection13));
  // voltage level not found
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap14 = CriteriaParamsFactory::newCriteriaParams();
  criteriap14->setType(CriteriaParams::LOCAL_VALUE);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap14->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap14));
  criteria->addComponentId("DummyBBS", "MyVoltageLevel");
  std::unique_ptr<CriteriaCollection> collection14 = CriteriaCollectionFactory::newInstance();
  collection14->add(CriteriaCollection::BUS, criteria);
  data = createDataItfFromNetworkCriteria(createNodeBreakerNetworkCriteria());
  exportStates(data);
  data->configureCriteria(std::move(collection14));
  // bbs not found
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap15 = CriteriaParamsFactory::newCriteriaParams();
  criteriap15->setType(CriteriaParams::LOCAL_VALUE);
  criteriap15->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap15->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap15));
  criteria->addComponentId("MyBusBarSection", "MyVoltageLevel");
  std::unique_ptr<CriteriaCollection> collection15 = CriteriaCollectionFactory::newInstance();
  collection15->add(CriteriaCollection::BUS, criteria);
  data = createDataItfFromNetworkCriteria(createNodeBreakerNetworkCriteria());
  exportStates(data);
  data->configureCriteria(std::move(collection15));
  // v > 0.8*vNom
  ASSERT_FALSE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap16 = CriteriaParamsFactory::newCriteriaParams();
  criteriap16->setType(CriteriaParams::LOCAL_VALUE);
  criteriap16->setScope(CriteriaParams::FINAL);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap16->addVoltageLevel(vl);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap16));
  criteria->addComponentId("MyBusBarSection", "MyVoltageLevel");
  std::unique_ptr<CriteriaCollection> collection16 = CriteriaCollectionFactory::newInstance();
  collection16->add(CriteriaCollection::BUS, criteria);
  data = createDataItfFromNetworkCriteria(createNodeBreakerNetworkCriteria());
  exportStates(data);
  data->configureCriteria(std::move(collection16));
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(0, false));
  ASSERT_FALSE(data->checkCriteria(0, true));
}

TEST(DataInterfaceIIDMTest, testLoadCriteriaLocalValue) {
  std::shared_ptr<CriteriaParams> criteriap1 = CriteriaParamsFactory::newCriteriaParams();
  ASSERT_FALSE(LoadCriteria::criteriaEligibleForLoad(criteriap1));
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  vl.setUMinPu(0.2);
  criteriap1->addVoltageLevel(vl);
  ASSERT_FALSE(LoadCriteria::criteriaEligibleForLoad(criteriap1));
  criteriap1->setPMax(200);
  ASSERT_TRUE(LoadCriteria::criteriaEligibleForLoad(criteriap1));
  criteriap1->setPMin(50);
  criteriap1->setScope(CriteriaParams::DYNAMIC);
  criteriap1->setType(CriteriaParams::LOCAL_VALUE);
  ASSERT_TRUE(LoadCriteria::criteriaEligibleForLoad(criteriap1));
  criteriap1->setId("MyCriteria");

  shared_ptr<DataInterface> data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 190, 100, 100));
  exportStates(data);
  std::vector<std::shared_ptr<LoadInterface> > loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  LoadCriteria criteria(criteriap1);
  // VNom lower than min
  for (size_t i = 0; i < loads.size(); ++i)
    criteria.addLoad(loads[i]);
  ASSERT_TRUE(criteria.empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 425, 100, 100));
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // VNom higher than max
  for (size_t i = 0; i < loads.size(); ++i)
    criteria.addLoad(loads[i]);
  ASSERT_TRUE(criteria.empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(190, 225, 250, 100));
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // V > uMaxPu*VNom
  for (size_t i = 0; i < loads.size(); ++i)
    criteria.addLoad(loads[i]);
  ASSERT_FALSE(criteria.empty());
  ASSERT_TRUE(criteria.checkCriteria(0, true));
  ASSERT_TRUE(criteria.getFailingCriteria().empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(43, 225, 250, 100));
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // V < uMinPu*VNom
  LoadCriteria criteria2(criteriap1);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria2.addLoad(loads[i]);
  ASSERT_FALSE(criteria2.empty());
  ASSERT_TRUE(criteria2.checkCriteria(0, true));
  ASSERT_TRUE(criteria2.getFailingCriteria().empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 100, 100));
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // OK
  LoadCriteria criteria3(criteriap1);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria3.addLoad(loads[i]);
  ASSERT_FALSE(criteria3.empty());
  ASSERT_TRUE(criteria3.checkCriteria(0, true));
  ASSERT_TRUE(criteria3.getFailingCriteria().empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 250, 100));
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // P> PMax
  LoadCriteria criteria4(criteriap1);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria4.addLoad(loads[i]);
  ASSERT_FALSE(criteria4.empty());
  ASSERT_FALSE(criteria4.checkCriteria(0, true));
  ASSERT_EQ(criteria4.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria4.getFailingCriteria()[0].second, "SourceAbovePower MyLoad 250 200 MyCriteria");

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 40, 100));
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // P< PMin
  criteriap1->setScope(CriteriaParams::FINAL);
  LoadCriteria criteria5(criteriap1);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria5.addLoad(loads[i]);
  ASSERT_FALSE(criteria5.empty());
  ASSERT_TRUE(criteria5.checkCriteria(0, false));
  ASSERT_TRUE(criteria5.getFailingCriteria().empty());
  ASSERT_FALSE(criteria5.checkCriteria(0, true));
  ASSERT_EQ(criteria5.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria5.getFailingCriteria()[0].second, "SourceUnderPower MyLoad 40 50 MyCriteria");

  // Multiple voltage levels
  std::unique_ptr<CriteriaParams> criteriap2 = CriteriaParamsFactory::newCriteriaParams();
  vl.reset();
  vl.setUNomMin(300);
  vl.setUNomMax(400);
  criteriap2->addVoltageLevel(vl);
  criteria::CriteriaParamsVoltageLevel vl2;
  vl2.setUNomMin(225);
  vl2.setUNomMax(400);
  criteriap2->addVoltageLevel(vl2);
  criteriap2->setPMax(200);
  criteriap2->setPMin(50);
  criteriap2->setScope(CriteriaParams::DYNAMIC);
  criteriap2->setType(CriteriaParams::LOCAL_VALUE);
  criteriap2->setId("MyCriteria");
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 250, 100));
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // P> PMax
  LoadCriteria criteria6(std::move(criteriap2));
  for (size_t i = 0; i < loads.size(); ++i)
    criteria6.addLoad(loads[i]);
  ASSERT_FALSE(criteria6.empty());
  ASSERT_FALSE(criteria6.checkCriteria(0, false));
  ASSERT_GT(criteria6.getFailingCriteria().size(), 0);
  ASSERT_EQ(criteria6.getFailingCriteria()[0].second, "SourceAbovePower MyLoad 250 200 MyCriteria");
}

TEST(DataInterfaceIIDMTest, testLoadCriteriaSum) {
  std::shared_ptr<CriteriaParams> criteriap1 = CriteriaParamsFactory::newCriteriaParams();
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  vl.setUMinPu(0.2);
  criteriap1->addVoltageLevel(vl);
  criteriap1->setPMax(200);
  criteriap1->setPMin(50);
  criteriap1->setScope(CriteriaParams::DYNAMIC);
  criteriap1->setType(CriteriaParams::SUM);
  ASSERT_TRUE(LoadCriteria::criteriaEligibleForLoad(criteriap1));
  criteriap1->setId("MyCriteria");

  shared_ptr<DataInterface> data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 190, 100, 100));
  exportStates(data);
  std::vector<std::shared_ptr<LoadInterface> > loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  LoadCriteria criteria(criteriap1);
  // VNom lower than min
  for (size_t i = 0; i < loads.size(); ++i)
    criteria.addLoad(loads[i]);
  ASSERT_TRUE(criteria.empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 425, 100, 100));
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // VNom higher than max
  for (size_t i = 0; i < loads.size(); ++i)
    criteria.addLoad(loads[i]);
  ASSERT_TRUE(criteria.empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(190, 225, 250, 100));
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // V > uMaxPu*VNom
  for (size_t i = 0; i < loads.size(); ++i)
    criteria.addLoad(loads[i]);
  ASSERT_FALSE(criteria.empty());
  ASSERT_TRUE(criteria.checkCriteria(0, true));
  ASSERT_TRUE(criteria.getFailingCriteria().empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(43, 225, 250, 100));
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // V < uMinPu*VNom
  LoadCriteria criteria2(criteriap1);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria2.addLoad(loads[i]);
  ASSERT_FALSE(criteria2.empty());
  ASSERT_TRUE(criteria2.checkCriteria(0, true));
  ASSERT_TRUE(criteria2.getFailingCriteria().empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 50, 50));
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // OK
  LoadCriteria criteria3(criteriap1);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria3.addLoad(loads[i]);
  ASSERT_FALSE(criteria3.empty());
  ASSERT_TRUE(criteria3.checkCriteria(0, true));
  ASSERT_TRUE(criteria3.getFailingCriteria().empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 250, 100));
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // P> PMax
  LoadCriteria criteria4(criteriap1);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria4.addLoad(loads[i]);
  ASSERT_FALSE(criteria4.empty());
  ASSERT_FALSE(criteria4.checkCriteria(0, true));
  ASSERT_EQ(criteria4.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria4.getFailingCriteria()[0].second, "SourcePowerAboveMax 350 200 MyCriteria");

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 10, 10));
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // P< PMin
  criteriap1->setScope(CriteriaParams::FINAL);
  LoadCriteria criteria5(criteriap1);
  for (size_t i = 0; i < loads.size(); ++i)
    criteria5.addLoad(loads[i]);
  ASSERT_FALSE(criteria5.empty());
  ASSERT_TRUE(criteria5.checkCriteria(0, false));
  ASSERT_TRUE(criteria5.getFailingCriteria().empty());
  ASSERT_FALSE(criteria5.checkCriteria(0, true));
  ASSERT_EQ(criteria5.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria5.getFailingCriteria()[0].second, "SourcePowerBelowMin 20 50 MyCriteria");

  // Multiple voltage levels
  std::unique_ptr<CriteriaParams> criteriap2 = CriteriaParamsFactory::newCriteriaParams();
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(300);
  vl.setUMaxPu(0.8);
  vl.setUMinPu(0.2);
  criteriap2->addVoltageLevel(vl);
  criteria::CriteriaParamsVoltageLevel vl2;
  vl2.setUNomMin(400);
  vl.setUNomMax(600);
  vl.setUMaxPu(0.8);
  vl.setUMinPu(0.2);
  criteriap2->addVoltageLevel(vl2);
  criteriap2->setPMax(200);
  criteriap2->setPMin(50);
  criteriap2->setScope(CriteriaParams::DYNAMIC);
  criteriap2->setType(CriteriaParams::SUM);
  criteriap2->setId("MyCriteria");
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 250, 100));
  exportStates(data);
  loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  // P> PMax
  LoadCriteria criteria6(std::move(criteriap2));
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
  std::unique_ptr<CriteriaParams> criteriap1 = CriteriaParamsFactory::newCriteriaParams();
  criteriap1->setType(CriteriaParams::LOCAL_VALUE);
  criteriap1->setScope(CriteriaParams::DYNAMIC);
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap1->addVoltageLevel(vl);
  std::shared_ptr<criteria::Criteria> criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap1));
  std::shared_ptr<CriteriaCollection> collection1 = CriteriaCollectionFactory::newInstance();
  collection1->add(CriteriaCollection::LOAD, criteria);
  shared_ptr<DataInterface> data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 100, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection1));
  // not eligible
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap2 = CriteriaParamsFactory::newCriteriaParams();
  criteriap2->setType(CriteriaParams::LOCAL_VALUE);
  criteriap2->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap2->addVoltageLevel(vl);
  criteriap2->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap2));
  std::unique_ptr<CriteriaCollection> collection2 = CriteriaCollectionFactory::newInstance();
  collection2->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(190, 200, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection2));
  // vNom < min
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap3 = CriteriaParamsFactory::newCriteriaParams();
  criteriap3->setType(CriteriaParams::LOCAL_VALUE);
  criteriap3->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap3->addVoltageLevel(vl);
  criteriap3->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap3));
  std::unique_ptr<CriteriaCollection> collection3 = CriteriaCollectionFactory::newInstance();
  collection3->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(190, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection3));
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap4 = CriteriaParamsFactory::newCriteriaParams();
  criteriap4->setType(CriteriaParams::LOCAL_VALUE);
  criteriap4->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap4->addVoltageLevel(vl);
  criteriap4->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap4));
  std::unique_ptr<CriteriaCollection> collection4 = CriteriaCollectionFactory::newInstance();
  collection4->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection4));
  // P > PMax
  ASSERT_FALSE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap5 = CriteriaParamsFactory::newCriteriaParams();
  criteriap5->setType(CriteriaParams::LOCAL_VALUE);
  criteriap5->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap5->addVoltageLevel(vl);
  criteriap5->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap5));
  criteria->addCountry("BE");
  std::unique_ptr<CriteriaCollection> collection5 = CriteriaCollectionFactory::newInstance();
  collection5->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection5));
  // P > PMax but country filter is KO
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap6 = CriteriaParamsFactory::newCriteriaParams();
  criteriap6->setType(CriteriaParams::LOCAL_VALUE);
  criteriap6->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap6->addVoltageLevel(vl);
  criteriap6->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap6));
  criteria->addCountry("FRANCE");
  std::unique_ptr<CriteriaCollection> collection6 = CriteriaCollectionFactory::newInstance();
  collection6->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection6));
  // P > PMax and country filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap7 = CriteriaParamsFactory::newCriteriaParams();
  criteriap7->setType(CriteriaParams::LOCAL_VALUE);
  criteriap7->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap7->addVoltageLevel(vl);
  criteriap7->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap7));
  criteria->addCountry("FRANCE");
  std::unique_ptr<CriteriaCollection> collection7 = CriteriaCollectionFactory::newInstance();
  collection7->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 200, 100, false));
  exportStates(data);
  data->configureCriteria(std::move(collection7));
  // P > PMax and country filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap8 = CriteriaParamsFactory::newCriteriaParams();
  criteriap8->setType(CriteriaParams::LOCAL_VALUE);
  criteriap8->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap8->addVoltageLevel(vl);
  criteriap8->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap8));
  criteria->addComponentId("MyDummyName");
  std::unique_ptr<CriteriaCollection> collection8 = CriteriaCollectionFactory::newInstance();
  collection8->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 200, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection8));
  // load not found
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap9 = CriteriaParamsFactory::newCriteriaParams();
  criteriap9->setType(CriteriaParams::LOCAL_VALUE);
  criteriap9->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap9->addVoltageLevel(vl);
  criteriap9->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap9));
  criteria->addComponentId("MyLoad");
  std::unique_ptr<CriteriaCollection> collection9 = CriteriaCollectionFactory::newInstance();
  collection9->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection9));
  // P > PMax
  ASSERT_FALSE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap10 = CriteriaParamsFactory::newCriteriaParams();
  criteriap10->setType(CriteriaParams::LOCAL_VALUE);
  criteriap10->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap10->addVoltageLevel(vl);
  criteriap10->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap10));
  criteria->addComponentId("MyLoad2");
  std::unique_ptr<CriteriaCollection> collection10 = CriteriaCollectionFactory::newInstance();
  collection10->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection10));
  // P < PMax
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap11 = CriteriaParamsFactory::newCriteriaParams();
  criteriap11->setType(CriteriaParams::LOCAL_VALUE);
  criteriap11->setScope(CriteriaParams::FINAL);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap11->addVoltageLevel(vl);
  criteriap11->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap11));
  criteria->addComponentId("MyLoad");
  std::unique_ptr<CriteriaCollection> collection11 = CriteriaCollectionFactory::newInstance();
  collection11->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection11));
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(0, false));
  ASSERT_FALSE(data->checkCriteria(0, true));

  std::unique_ptr<CriteriaParams> criteriap12 = CriteriaParamsFactory::newCriteriaParams();
  criteriap12->setType(CriteriaParams::LOCAL_VALUE);
  criteriap12->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap12->addVoltageLevel(vl);
  criteriap12->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap12));
  criteria->addComponentId("MyLoad");
  criteria->addCountry("BE");
  std::unique_ptr<CriteriaCollection> collection12 = CriteriaCollectionFactory::newInstance();
  collection12->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection12));
  // P > PMax but country filter is KO
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap13 = CriteriaParamsFactory::newCriteriaParams();
  criteriap13->setType(CriteriaParams::LOCAL_VALUE);
  criteriap13->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap13->addVoltageLevel(vl);
  criteriap13->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap13));
  criteria->addComponentId("MyLoad");
  criteria->addCountry("FRANCE");
  std::unique_ptr<CriteriaCollection> collection13 = CriteriaCollectionFactory::newInstance();
  collection13->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection13));
  // P > PMax and country filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap14 = CriteriaParamsFactory::newCriteriaParams();
  criteriap14->setType(CriteriaParams::LOCAL_VALUE);
  criteriap14->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap14->addVoltageLevel(vl);
  criteriap14->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap14));
  criteria->addComponentId("MyLoad");
  criteria->addCountry("FRANCE");
  std::unique_ptr<CriteriaCollection> collection14 = CriteriaCollectionFactory::newInstance();
  collection14->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 200, 100, false));
  exportStates(data);
  data->configureCriteria(std::move(collection14));
  // P > PMax and country filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));
}

TEST(DataInterfaceIIDMTest, testLoadCriteriaDataIIDMSum) {
  std::unique_ptr<CriteriaParams> criteriap1 = CriteriaParamsFactory::newCriteriaParams();
  criteriap1->setType(CriteriaParams::SUM);
  criteriap1->setScope(CriteriaParams::DYNAMIC);
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap1->addVoltageLevel(vl);
  std::shared_ptr<criteria::Criteria> criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap1));
  std::unique_ptr<CriteriaCollection> collection1 = CriteriaCollectionFactory::newInstance();
  collection1->add(CriteriaCollection::LOAD, criteria);
  shared_ptr<DataInterface> data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 100, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection1));
  // not eligible
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap2 = CriteriaParamsFactory::newCriteriaParams();
  criteriap2->setType(CriteriaParams::SUM);
  criteriap2->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap2->addVoltageLevel(vl);
  criteriap2->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap2));
  std::unique_ptr<CriteriaCollection> collection2 = CriteriaCollectionFactory::newInstance();
  collection2->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(190, 200, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection2));
  // vNom < min
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap3 = CriteriaParamsFactory::newCriteriaParams();
  criteriap3->setType(CriteriaParams::SUM);
  criteriap3->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap3->addVoltageLevel(vl);
  criteriap3->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap3));
  std::unique_ptr<CriteriaCollection> collection3 = CriteriaCollectionFactory::newInstance();
  collection3->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(190, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection3));
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap4 = CriteriaParamsFactory::newCriteriaParams();
  criteriap4->setType(CriteriaParams::SUM);
  criteriap4->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap4->addVoltageLevel(vl);
  criteriap4->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap4));
  criteria->addComponentId("MyDummyName");
  std::unique_ptr<CriteriaCollection> collection4 = CriteriaCollectionFactory::newInstance();
  collection4->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 200, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection4));
  // load not found
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap5 = CriteriaParamsFactory::newCriteriaParams();
  criteriap5->setType(CriteriaParams::SUM);
  criteriap5->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap5->addVoltageLevel(vl);
  criteriap5->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap5));
  std::unique_ptr<CriteriaCollection> collection5 = CriteriaCollectionFactory::newInstance();
  collection5->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 50, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection5));
  // sum(P)<= PMax
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap6 = CriteriaParamsFactory::newCriteriaParams();
  criteriap6->setType(CriteriaParams::SUM);
  criteriap6->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap6->addVoltageLevel(vl);
  criteriap6->setPMax(150);
  criteriap6->setId("MyCriteria");
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap6));
  std::unique_ptr<CriteriaCollection> collection6 = CriteriaCollectionFactory::newInstance();
  collection6->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection6));
  // P > PMax
  ASSERT_FALSE(data->checkCriteria(0, false));
  std::vector<std::pair<double, std::string> > failingCriteria;
  data->getFailingCriteria(failingCriteria);
  ASSERT_EQ(failingCriteria.size(), 1);
  ASSERT_EQ(failingCriteria[0].second, "SourcePowerAboveMax 300 150 MyCriteria");

  std::unique_ptr<CriteriaParams> criteriap7 = CriteriaParamsFactory::newCriteriaParams();
  criteriap7->setType(CriteriaParams::SUM);
  criteriap7->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap7->addVoltageLevel(vl);
  criteriap7->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap7));
  criteria->addComponentId("MyLoad2");
  std::unique_ptr<CriteriaCollection> collection7 = CriteriaCollectionFactory::newInstance();
  collection7->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection7));
  // P < PMax
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap8 = CriteriaParamsFactory::newCriteriaParams();
  criteriap8->setType(CriteriaParams::SUM);
  criteriap8->setScope(CriteriaParams::FINAL);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap8->addVoltageLevel(vl);
  criteriap8->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap8));
  std::unique_ptr<CriteriaCollection> collection8 = CriteriaCollectionFactory::newInstance();
  collection8->add(CriteriaCollection::LOAD, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithLoads(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection8));
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(0, false));
  ASSERT_FALSE(data->checkCriteria(0, true));
}

TEST(DataInterfaceIIDMTest, testDontTestFictitiousLoadsInCriteria) {
  std::unique_ptr<CriteriaParams> criteriaParams = CriteriaParamsFactory::newCriteriaParams();
  criteriaParams->setType(CriteriaParams::LOCAL_VALUE);
  criteriaParams->setScope(CriteriaParams::DYNAMIC);
  criteriaParams->setPMax(90);
  shared_ptr<DataInterface> data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithOneFictitiousLoadAmongTwo(180, 190, 100, 100));
  exportStates(data);
  std::vector<std::shared_ptr<LoadInterface> > loads = data->getNetwork()->getVoltageLevels()[0]->getLoads();
  LoadCriteria criteria(std::move(criteriaParams));
  for (size_t i = 0; i < loads.size(); ++i)
    criteria.addLoad(loads[i]);
  criteria.checkCriteria(0, false);
  const std::vector<std::pair<double, std::string> > failingCriteria = criteria.getFailingCriteria();
  ASSERT_EQ(failingCriteria.size(), 1);
}

TEST(DataInterfaceIIDMTest, testGeneratorCriteriaLocalValue) {
  std::shared_ptr<CriteriaParams> criteriap1 = CriteriaParamsFactory::newCriteriaParams();
  ASSERT_FALSE(GeneratorCriteria::criteriaEligibleForGenerator(criteriap1));
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  vl.setUMinPu(0.2);
  criteriap1->addVoltageLevel(vl);
  ASSERT_FALSE(GeneratorCriteria::criteriaEligibleForGenerator(criteriap1));
  criteriap1->setPMax(200);
  ASSERT_TRUE(GeneratorCriteria::criteriaEligibleForGenerator(criteriap1));
  criteriap1->setPMin(50);
  criteriap1->setScope(CriteriaParams::DYNAMIC);
  criteriap1->setType(CriteriaParams::LOCAL_VALUE);
  ASSERT_TRUE(GeneratorCriteria::criteriaEligibleForGenerator(criteriap1));
  criteriap1->setId("MyCriteria");

  shared_ptr<DataInterface> data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 190, 100, 100));
  exportStates(data);
  std::vector<std::shared_ptr<GeneratorInterface> > generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  GeneratorCriteria criteria(criteriap1);
  // VNom lower than min
  for (size_t i = 0; i < generators.size(); ++i)
    criteria.addGenerator(generators[i]);
  ASSERT_TRUE(criteria.empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 425, 100, 100));
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // VNom higher than max
  for (size_t i = 0; i < generators.size(); ++i)
    criteria.addGenerator(generators[i]);
  ASSERT_TRUE(criteria.empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(190, 225, 250, 100));
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // V > uMaxPu*VNom
  for (size_t i = 0; i < generators.size(); ++i)
    criteria.addGenerator(generators[i]);
  ASSERT_FALSE(criteria.empty());
  ASSERT_TRUE(criteria.checkCriteria(0, true));
  ASSERT_TRUE(criteria.getFailingCriteria().empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(43, 225, 250, 100));
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // V < uMinPu*VNom
  GeneratorCriteria criteria2(criteriap1);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria2.addGenerator(generators[i]);
  ASSERT_FALSE(criteria2.empty());
  ASSERT_TRUE(criteria2.checkCriteria(0, true));
  ASSERT_TRUE(criteria2.getFailingCriteria().empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 100, 100));
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // OK
  GeneratorCriteria criteria3(criteriap1);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria3.addGenerator(generators[i]);
  ASSERT_FALSE(criteria3.empty());
  ASSERT_TRUE(criteria3.checkCriteria(0, true));
  ASSERT_TRUE(criteria3.getFailingCriteria().empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 250, 100));
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // P> PMax
  GeneratorCriteria criteria4(criteriap1);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria4.addGenerator(generators[i]);
  ASSERT_FALSE(criteria4.empty());
  ASSERT_FALSE(criteria4.checkCriteria(0, true));
  ASSERT_EQ(criteria4.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria4.getFailingCriteria()[0].second, "SourceAbovePower MyGen 250 200 MyCriteria");

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 40, 100));
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // P< PMin
  criteriap1->setScope(CriteriaParams::FINAL);
  GeneratorCriteria criteria5(criteriap1);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria5.addGenerator(generators[i]);
  ASSERT_FALSE(criteria5.empty());
  ASSERT_TRUE(criteria5.checkCriteria(0, false));
  ASSERT_TRUE(criteria5.getFailingCriteria().empty());
  ASSERT_FALSE(criteria5.checkCriteria(0, true));
  ASSERT_EQ(criteria5.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria5.getFailingCriteria()[0].second, "SourceUnderPower MyGen 40 50 MyCriteria");

  // Multiple voltage levels
  std::unique_ptr<CriteriaParams> criteriap2 = CriteriaParamsFactory::newCriteriaParams();
  vl.reset();
  vl.setUNomMin(300);
  vl.setUNomMax(400);
  criteriap2->addVoltageLevel(vl);
  criteria::CriteriaParamsVoltageLevel vl2;
  vl2.setUNomMin(225);
  vl2.setUNomMax(400);
  criteriap2->addVoltageLevel(vl2);
  criteriap2->setPMax(200);
  criteriap2->setPMin(50);
  criteriap2->setScope(CriteriaParams::DYNAMIC);
  criteriap2->setType(CriteriaParams::LOCAL_VALUE);
  criteriap2->setId("MyCriteria");

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 250, 100));
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // P> PMax
  GeneratorCriteria criteria6(std::move(criteriap2));
  for (size_t i = 0; i < generators.size(); ++i)
    criteria6.addGenerator(generators[i]);
  ASSERT_FALSE(criteria6.empty());
  ASSERT_FALSE(criteria6.checkCriteria(0, false));
  ASSERT_GT(criteria6.getFailingCriteria().size(), 0);
  ASSERT_EQ(criteria6.getFailingCriteria()[0].second, "SourceAbovePower MyGen 250 200 MyCriteria");
}

TEST(DataInterfaceIIDMTest, testGeneratorCriteriaSum) {
  std::shared_ptr<CriteriaParams> criteriap1 = CriteriaParamsFactory::newCriteriaParams();
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  vl.setUMinPu(0.2);
  criteriap1->addVoltageLevel(vl);
  criteriap1->setPMax(200);
  criteriap1->setPMin(50);
  criteriap1->setScope(CriteriaParams::DYNAMIC);
  criteriap1->setType(CriteriaParams::SUM);
  ASSERT_TRUE(GeneratorCriteria::criteriaEligibleForGenerator(criteriap1));
  criteriap1->setId("MyCriteria");

  shared_ptr<DataInterface> data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 190, 100, 100));
  exportStates(data);
  std::vector<std::shared_ptr<GeneratorInterface> > generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  GeneratorCriteria criteria(criteriap1);
  // VNom lower than min
  for (size_t i = 0; i < generators.size(); ++i)
    criteria.addGenerator(generators[i]);
  ASSERT_TRUE(criteria.empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 425, 100, 100));
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // VNom higher than max
  for (size_t i = 0; i < generators.size(); ++i)
    criteria.addGenerator(generators[i]);
  ASSERT_TRUE(criteria.empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(190, 225, 250, 100));
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // V > uMaxPu*VNom
  for (size_t i = 0; i < generators.size(); ++i)
    criteria.addGenerator(generators[i]);
  ASSERT_FALSE(criteria.empty());
  ASSERT_TRUE(criteria.checkCriteria(0, true));
  ASSERT_TRUE(criteria.getFailingCriteria().empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(43, 225, 250, 100));
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // V < uMinPu*VNom
  GeneratorCriteria criteria2(criteriap1);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria2.addGenerator(generators[i]);
  ASSERT_FALSE(criteria2.empty());
  ASSERT_TRUE(criteria2.checkCriteria(0, true));
  ASSERT_TRUE(criteria2.getFailingCriteria().empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 50, 50));
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // OK
  GeneratorCriteria criteria3(criteriap1);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria3.addGenerator(generators[i]);
  ASSERT_FALSE(criteria3.empty());
  ASSERT_TRUE(criteria3.checkCriteria(0, true));
  ASSERT_TRUE(criteria3.getFailingCriteria().empty());

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 250, 100));
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // P> PMax
  GeneratorCriteria criteria4(criteriap1);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria4.addGenerator(generators[i]);
  ASSERT_FALSE(criteria4.empty());
  ASSERT_FALSE(criteria4.checkCriteria(0, true));
  ASSERT_EQ(criteria4.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria4.getFailingCriteria()[0].second, "SourcePowerAboveMax 350 200 MyCriteria");

  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 10, 10));
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // P< PMin
  criteriap1->setScope(CriteriaParams::FINAL);
  GeneratorCriteria criteria5(criteriap1);
  for (size_t i = 0; i < generators.size(); ++i)
    criteria5.addGenerator(generators[i]);
  ASSERT_FALSE(criteria5.empty());
  ASSERT_TRUE(criteria5.checkCriteria(0, false));
  ASSERT_TRUE(criteria5.getFailingCriteria().empty());
  ASSERT_FALSE(criteria5.checkCriteria(0, true));
  ASSERT_EQ(criteria5.getFailingCriteria().size(), 1);
  ASSERT_EQ(criteria5.getFailingCriteria()[0].second, "SourcePowerBelowMin 20 50 MyCriteria");

  // Multiple voltage levels
  std::unique_ptr<CriteriaParams> criteriap2 = CriteriaParamsFactory::newCriteriaParams();
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(300);
  vl.setUMaxPu(0.8);
  vl.setUMinPu(0.2);
  criteriap2->addVoltageLevel(vl);
  criteria::CriteriaParamsVoltageLevel vl2;
  vl2.setUNomMin(400);
  vl.setUNomMax(600);
  vl.setUMaxPu(0.8);
  vl.setUMinPu(0.2);
  criteriap2->addVoltageLevel(vl2);
  criteriap2->setPMax(200);
  criteriap2->setPMin(50);
  criteriap2->setScope(CriteriaParams::DYNAMIC);
  criteriap2->setType(CriteriaParams::SUM);
  criteriap2->setId("MyCriteria");
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 250, 100));
  exportStates(data);
  generators = data->getNetwork()->getVoltageLevels()[0]->getGenerators();
  // P> PMax
  GeneratorCriteria criteria6(std::move(criteriap2));
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
  std::shared_ptr<CriteriaParams> criteriap1 = CriteriaParamsFactory::newCriteriaParams();
  criteriap1->setType(CriteriaParams::LOCAL_VALUE);
  criteriap1->setScope(CriteriaParams::DYNAMIC);
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap1->addVoltageLevel(vl);
  std::shared_ptr<criteria::Criteria> criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap1);
  std::unique_ptr<CriteriaCollection> collection1 = CriteriaCollectionFactory::newInstance();
  collection1->add(CriteriaCollection::GENERATOR, criteria);
  shared_ptr<DataInterface> data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 100, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection1));
  // not eligible
  ASSERT_TRUE(data->checkCriteria(0, false));

  criteriap1 = CriteriaParamsFactory::newCriteriaParams();
  criteriap1->setType(CriteriaParams::LOCAL_VALUE);
  criteriap1->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap1->addVoltageLevel(vl);
  criteriap1->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(criteriap1);
  std::unique_ptr<CriteriaCollection> collection2 = CriteriaCollectionFactory::newInstance();
  collection2->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(190, 200, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection2));
  // vNom < min
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap2 = CriteriaParamsFactory::newCriteriaParams();
  criteriap2->setType(CriteriaParams::LOCAL_VALUE);
  criteriap2->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap2->addVoltageLevel(vl);
  criteriap2->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap2));
  std::unique_ptr<CriteriaCollection> collection3 = CriteriaCollectionFactory::newInstance();
  collection3->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(190, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection3));
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap3 = CriteriaParamsFactory::newCriteriaParams();
  criteriap3->setType(CriteriaParams::LOCAL_VALUE);
  criteriap3->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap3->addVoltageLevel(vl);
  criteriap3->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap3));
  std::unique_ptr<CriteriaCollection> collection4 = CriteriaCollectionFactory::newInstance();
  collection4->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection4));
  // P > PMax
  ASSERT_FALSE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap4 = CriteriaParamsFactory::newCriteriaParams();
  criteriap4->setType(CriteriaParams::LOCAL_VALUE);
  criteriap4->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap4->addVoltageLevel(vl);
  criteriap4->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap4));
  criteria->addCountry("BE");
  std::unique_ptr<CriteriaCollection> collection5 = CriteriaCollectionFactory::newInstance();
  collection5->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection5));
  // P > PMax but country filter is KO
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap5 = CriteriaParamsFactory::newCriteriaParams();
  criteriap5->setType(CriteriaParams::LOCAL_VALUE);
  criteriap5->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap5->addVoltageLevel(vl);
  criteriap5->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap5));
  criteria->addCountry("FRANCE");
  std::unique_ptr<CriteriaCollection> collection6 = CriteriaCollectionFactory::newInstance();
  collection6->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection6));
  // P > PMax and country filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap6 = CriteriaParamsFactory::newCriteriaParams();
  criteriap6->setType(CriteriaParams::LOCAL_VALUE);
  criteriap6->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap6->addVoltageLevel(vl);
  criteriap6->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap6));
  criteria->addCountry("FRANCE");
  std::unique_ptr<CriteriaCollection> collection7 = CriteriaCollectionFactory::newInstance();
  collection7->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 200, 100, false));
  exportStates(data);
  data->configureCriteria(std::move(collection7));
  // P > PMax and country filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap7 = CriteriaParamsFactory::newCriteriaParams();
  criteriap7->setType(CriteriaParams::LOCAL_VALUE);
  criteriap7->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap7->addVoltageLevel(vl);
  criteriap7->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap7));
  criteria->addComponentId("MyDummyName");
  std::unique_ptr<CriteriaCollection> collection8 = CriteriaCollectionFactory::newInstance();
  collection8->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 200, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection8));
  // generator not found
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap8 = CriteriaParamsFactory::newCriteriaParams();
  criteriap8->setType(CriteriaParams::LOCAL_VALUE);
  criteriap8->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap8->addVoltageLevel(vl);
  criteriap8->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap8));
  criteria->addComponentId("MyGen");
  std::unique_ptr<CriteriaCollection> collection9 = CriteriaCollectionFactory::newInstance();
  collection9->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection9));
  // P > PMax
  ASSERT_FALSE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap9 = CriteriaParamsFactory::newCriteriaParams();
  criteriap9->setType(CriteriaParams::LOCAL_VALUE);
  criteriap9->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap9->addVoltageLevel(vl);
  criteriap9->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap9));
  criteria->addComponentId("MyGend2");
  std::unique_ptr<CriteriaCollection> collection10 = CriteriaCollectionFactory::newInstance();
  collection10->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection10));
  // P < PMax
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap10 = CriteriaParamsFactory::newCriteriaParams();
  criteriap10->setType(CriteriaParams::LOCAL_VALUE);
  criteriap10->setScope(CriteriaParams::FINAL);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap10->addVoltageLevel(vl);
  criteriap10->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap10));
  criteria->addComponentId("MyGen");
  std::unique_ptr<CriteriaCollection> collection11 = CriteriaCollectionFactory::newInstance();
  collection11->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection11));
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(0, false));
  ASSERT_FALSE(data->checkCriteria(0, true));

  std::unique_ptr<CriteriaParams> criteriap11 = CriteriaParamsFactory::newCriteriaParams();
  criteriap11->setType(CriteriaParams::LOCAL_VALUE);
  criteriap11->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap11->addVoltageLevel(vl);
  criteriap11->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap11));
  criteria->addComponentId("MyGen");
  criteria->addCountry("BE");
  std::unique_ptr<CriteriaCollection> collection12 = CriteriaCollectionFactory::newInstance();
  collection12->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection12));
  // P > PMax but criteria filter is KO
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap12 = CriteriaParamsFactory::newCriteriaParams();
  criteriap12->setType(CriteriaParams::LOCAL_VALUE);
  criteriap12->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap12->addVoltageLevel(vl);
  criteriap12->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap12));
  criteria->addComponentId("MyGen");
  criteria->addCountry("FRANCE");
  std::unique_ptr<CriteriaCollection> collection13 = CriteriaCollectionFactory::newInstance();
  collection13->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection13));
  // P > PMax and criteria filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap13 = CriteriaParamsFactory::newCriteriaParams();
  criteriap13->setType(CriteriaParams::LOCAL_VALUE);
  criteriap13->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap13->addVoltageLevel(vl);
  criteriap13->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap13));
  criteria->addComponentId("MyGen");
  criteria->addCountry("FRANCE");
  std::unique_ptr<CriteriaCollection> collection14 = CriteriaCollectionFactory::newInstance();
  collection14->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 200, 100, false));
  exportStates(data);
  data->configureCriteria(std::move(collection14));
  // P > PMax and criteria filter is OK
  ASSERT_FALSE(data->checkCriteria(0, false));
}

TEST(DataInterfaceIIDMTest, testGeneratorCriteriaDataIIDMSum) {
  std::unique_ptr<CriteriaParams> criteriap1 = CriteriaParamsFactory::newCriteriaParams();
  criteriap1->setType(CriteriaParams::SUM);
  criteriap1->setScope(CriteriaParams::DYNAMIC);
  criteria::CriteriaParamsVoltageLevel vl;
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap1->addVoltageLevel(vl);
  std::shared_ptr<criteria::Criteria> criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap1));
  std::unique_ptr<CriteriaCollection> collection1 = CriteriaCollectionFactory::newInstance();
  collection1->add(CriteriaCollection::GENERATOR, criteria);
  shared_ptr<DataInterface> data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 100, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection1));
  // not eligible
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap2 = CriteriaParamsFactory::newCriteriaParams();
  criteriap2->setType(CriteriaParams::SUM);
  criteriap2->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap2->addVoltageLevel(vl);
  criteriap2->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap2));
  std::unique_ptr<CriteriaCollection> collection2 = CriteriaCollectionFactory::newInstance();
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(190, 200, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection2));
  // vNom < min
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap3 = CriteriaParamsFactory::newCriteriaParams();
  criteriap3->setType(CriteriaParams::SUM);
  criteriap3->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap3->addVoltageLevel(vl);
  criteriap3->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap3));
  std::unique_ptr<CriteriaCollection> collection3 = CriteriaCollectionFactory::newInstance();
  collection3->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(190, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection3));
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap4 = CriteriaParamsFactory::newCriteriaParams();
  criteriap4->setType(CriteriaParams::SUM);
  criteriap4->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap4->addVoltageLevel(vl);
  criteriap4->setPMax(200);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap4));
  criteria->addComponentId("MyDummyName");
  std::unique_ptr<CriteriaCollection> collection4 = CriteriaCollectionFactory::newInstance();
  collection4->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 200, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection4));
  // generator not found
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap5 = CriteriaParamsFactory::newCriteriaParams();
  criteriap5->setType(CriteriaParams::SUM);
  criteriap5->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap5->addVoltageLevel(vl);
  criteriap5->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap5));
  std::unique_ptr<CriteriaCollection> collection5 = CriteriaCollectionFactory::newInstance();
  collection5->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 50, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection5));
  // sum(P)<= PMax
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap6 = CriteriaParamsFactory::newCriteriaParams();
  criteriap6->setType(CriteriaParams::SUM);
  criteriap6->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap6->addVoltageLevel(vl);
  criteriap6->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap6));
  std::unique_ptr<CriteriaCollection> collection6 = CriteriaCollectionFactory::newInstance();
  collection6->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection6));
  // P > PMax
  ASSERT_FALSE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap7 = CriteriaParamsFactory::newCriteriaParams();
  criteriap7->setType(CriteriaParams::SUM);
  criteriap7->setScope(CriteriaParams::DYNAMIC);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap7->addVoltageLevel(vl);
  criteriap7->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap7));
  criteria->addComponentId("MyGen2");
  std::unique_ptr<CriteriaCollection> collection7 = CriteriaCollectionFactory::newInstance();
  collection7->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection7));
  // P < PMax
  ASSERT_TRUE(data->checkCriteria(0, false));

  std::unique_ptr<CriteriaParams> criteriap8 = CriteriaParamsFactory::newCriteriaParams();
  criteriap8->setType(CriteriaParams::SUM);
  criteriap8->setScope(CriteriaParams::FINAL);
  vl.reset();
  vl.setUNomMin(225);
  vl.setUNomMax(400);
  vl.setUMaxPu(0.8);
  criteriap8->addVoltageLevel(vl);
  criteriap8->setPMax(150);
  criteria = CriteriaFactory::newCriteria();
  criteria->setParams(std::move(criteriap8));
  std::unique_ptr<CriteriaCollection> collection8 = CriteriaCollectionFactory::newInstance();
  collection8->add(CriteriaCollection::GENERATOR, criteria);
  data = createDataItfFromNetworkCriteria(createBusBreakerNetworkWithGenerators(180, 225, 200, 100));
  exportStates(data);
  data->configureCriteria(std::move(collection8));
  // v > 0.8*vNom
  ASSERT_TRUE(data->checkCriteria(0, false));
  ASSERT_FALSE(data->checkCriteria(0, true));
}

TEST(DataInterfaceIIDMTest, NoVoltageLevelInCriteria) {
  criteria::CriteriaParamsVoltageLevel criteriaVoltageLevel1;
  criteriaVoltageLevel1.setUMinPu(0.9);
  criteriaVoltageLevel1.setUMaxPu(1.05);
  criteria::CriteriaParamsVoltageLevel criteriaVoltageLevel2;
  criteriaVoltageLevel2.setUMinPu(0.95);
  criteriaVoltageLevel2.setUMaxPu(1.1);

  struct VLTestConfig {
    criteria::CriteriaParams::CriteriaType_t vlTestType;
    criteria::CriteriaParams::CriteriaScope_t vlTestScope;
    bool isFinalStep;
    int failingCriteriaSizeWithoutVL;
    int failingCriteriaSizeWithVL;
    bool filtering;
  };

  std::vector<VLTestConfig> vlTestConfigArray = {
                  {criteria::CriteriaParams::LOCAL_VALUE, criteria::CriteriaParams::DYNAMIC, false, 4, 2, true},
                  {criteria::CriteriaParams::LOCAL_VALUE, criteria::CriteriaParams::FINAL,   true,  4, 2, true},
                  {criteria::CriteriaParams::SUM,         criteria::CriteriaParams::DYNAMIC, false, 1, 1, true},
                  {criteria::CriteriaParams::SUM,         criteria::CriteriaParams::FINAL,   true,  1, 1, true},
                  {criteria::CriteriaParams::LOCAL_VALUE, criteria::CriteriaParams::DYNAMIC, false, 4, 4, false},
                  {criteria::CriteriaParams::LOCAL_VALUE, criteria::CriteriaParams::FINAL,   true,  4, 4, false},
                  {criteria::CriteriaParams::SUM,         criteria::CriteriaParams::DYNAMIC, false, 1, 1, false},
                  {criteria::CriteriaParams::SUM,         criteria::CriteriaParams::FINAL,   true,  1, 1, false}
                };

  for (VLTestConfig& vlTestConfig : vlTestConfigArray) {
    std::shared_ptr<criteria::CriteriaParams> criteriaParamsWithoutVoltageLevel = CriteriaParamsFactory::newCriteriaParams();
    criteriaParamsWithoutVoltageLevel->setType(vlTestConfig.vlTestType);
    criteriaParamsWithoutVoltageLevel->setScope(vlTestConfig.vlTestScope);
    criteriaParamsWithoutVoltageLevel->setPMax(40);

    std::shared_ptr<criteria::CriteriaParams> criteriaParamsWithVoltageLevel = CriteriaParamsFactory::newCriteriaParams();
    criteriaParamsWithVoltageLevel->setType(vlTestConfig.vlTestType);
    criteriaParamsWithVoltageLevel->setScope(vlTestConfig.vlTestScope);
    criteriaParamsWithVoltageLevel->setPMax(40);
    criteriaParamsWithVoltageLevel->addVoltageLevel(criteriaVoltageLevel1);
    criteriaParamsWithVoltageLevel->addVoltageLevel(criteriaVoltageLevel2);

    std::vector<double> busVarray;
    if (vlTestConfig.filtering) {
      busVarray = {225, 70};
    } else {
      busVarray = {225, 225};
    }

    // Test on LoadCriteria
    boost::shared_ptr<powsybl::iidm::Network> loadNetwork = createBusBreakerNetworkWithLoads2(busVarray.at(0),
                                                                                              busVarray.at(1),
                                                                                              225,
                                                                                              190,
                                                                                              190);
    boost::shared_ptr<DataInterface> dataWithLoads = createDataItfFromNetworkCriteria(loadNetwork);
    exportStates(dataWithLoads);
    const std::vector<std::shared_ptr<VoltageLevelInterface> > loadVoltageLevels = dataWithLoads->getNetwork()->getVoltageLevels();
    LoadCriteria loadCriteriaWithoutVoltageLevel(criteriaParamsWithoutVoltageLevel);
    LoadCriteria loadCriteriaWithVoltageLevel(criteriaParamsWithVoltageLevel);
    for (size_t vlIdx = 0; vlIdx < loadVoltageLevels.size(); ++vlIdx) {
      const std::vector<std::shared_ptr<LoadInterface> > loads = loadVoltageLevels[vlIdx]->getLoads();
      for (size_t loadIdx = 0; loadIdx < loads.size(); ++loadIdx) {
        loadCriteriaWithoutVoltageLevel.addLoad(loads[loadIdx]);
        loadCriteriaWithVoltageLevel.addLoad(loads[loadIdx]);
      }
    }

    loadCriteriaWithoutVoltageLevel.checkCriteria(0, vlTestConfig.isFinalStep);
    const std::vector<std::pair<double, std::string> > loadFailingCriteriaWithoutVL = loadCriteriaWithoutVoltageLevel.getFailingCriteria();
    ASSERT_EQ(loadFailingCriteriaWithoutVL.size(), vlTestConfig.failingCriteriaSizeWithoutVL);
    checkNoLoadIsTestedSeveralTimes(loadFailingCriteriaWithoutVL);

    loadCriteriaWithVoltageLevel.checkCriteria(0, vlTestConfig.isFinalStep);
    const std::vector<std::pair<double, std::string> > loadFailingCriteriaWithVL = loadCriteriaWithVoltageLevel.getFailingCriteria();
    ASSERT_EQ(loadFailingCriteriaWithVL.size(), vlTestConfig.failingCriteriaSizeWithVL);
    checkNoLoadIsTestedSeveralTimes(loadFailingCriteriaWithVL);

    if (vlTestConfig.filtering) {
      if (vlTestConfig.vlTestType == criteria::CriteriaParams::LOCAL_VALUE) {
        ASSERT_GT(loadFailingCriteriaWithoutVL.size(), loadFailingCriteriaWithVL.size());
      } else if (vlTestConfig.vlTestType == criteria::CriteriaParams::SUM) {
        ASSERT_EQ(loadFailingCriteriaWithoutVL.size(), loadFailingCriteriaWithVL.size());
      } else {
        throw std::logic_error("Unknown criteria type");
      }
      ASSERT_NE(loadFailingCriteriaWithoutVL, loadFailingCriteriaWithVL);
    } else {
      ASSERT_EQ(loadFailingCriteriaWithoutVL.size(), loadFailingCriteriaWithVL.size());
      ASSERT_EQ(loadFailingCriteriaWithoutVL, loadFailingCriteriaWithVL);
    }

    if (vlTestConfig.vlTestType == criteria::CriteriaParams::SUM) {
      ASSERT_EQ(loadFailingCriteriaWithoutVL.size(), 1);
      ASSERT_EQ(loadFailingCriteriaWithVL.size(), 1);
    }

    // Test on GeneratorCriteria
    boost::shared_ptr<powsybl::iidm::Network> generatorNetwork = createBusBreakerNetworkWithGenerators2(busVarray.at(0),
                                                                                                        busVarray.at(1),
                                                                                                        225,
                                                                                                        190,
                                                                                                        190);
    boost::shared_ptr<DataInterface> dataWithGenerators = createDataItfFromNetworkCriteria(generatorNetwork);
    exportStates(dataWithGenerators);
    const std::vector<std::shared_ptr<VoltageLevelInterface> > generatorVoltageLevels = dataWithGenerators->getNetwork()->getVoltageLevels();
    GeneratorCriteria generatorCriteriaWithoutVoltageLevel(criteriaParamsWithoutVoltageLevel);
    GeneratorCriteria generatorCriteriaWithVoltageLevel(criteriaParamsWithVoltageLevel);
    for (size_t genVLidx = 0; genVLidx < generatorVoltageLevels.size(); ++genVLidx) {
      const std::vector<std::shared_ptr<GeneratorInterface> > generators = generatorVoltageLevels[genVLidx]->getGenerators();
      for (size_t generatorIdx = 0; generatorIdx < generators.size(); ++generatorIdx) {
        generatorCriteriaWithoutVoltageLevel.addGenerator(generators[generatorIdx]);
        generatorCriteriaWithVoltageLevel.addGenerator(generators[generatorIdx]);
      }
    }

    generatorCriteriaWithoutVoltageLevel.checkCriteria(0, vlTestConfig.isFinalStep);
    const std::vector<std::pair<double, std::string> > generatorFailingCriteriaWithoutVL = generatorCriteriaWithoutVoltageLevel.getFailingCriteria();
    ASSERT_EQ(generatorFailingCriteriaWithoutVL.size(), vlTestConfig.failingCriteriaSizeWithoutVL);
    checkNoLoadIsTestedSeveralTimes(generatorFailingCriteriaWithoutVL);

    generatorCriteriaWithVoltageLevel.checkCriteria(0, vlTestConfig.isFinalStep);
    const std::vector<std::pair<double, std::string> > generatorFailingCriteriaWithVL = generatorCriteriaWithVoltageLevel.getFailingCriteria();
    ASSERT_EQ(generatorFailingCriteriaWithVL.size(), vlTestConfig.failingCriteriaSizeWithVL);
    checkNoLoadIsTestedSeveralTimes(generatorFailingCriteriaWithVL);

    if (vlTestConfig.filtering) {
      if (vlTestConfig.vlTestType == criteria::CriteriaParams::LOCAL_VALUE) {
        ASSERT_GT(generatorFailingCriteriaWithoutVL.size(), generatorFailingCriteriaWithVL.size());
      } else if (vlTestConfig.vlTestType == criteria::CriteriaParams::SUM) {
        ASSERT_EQ(generatorFailingCriteriaWithoutVL.size(), generatorFailingCriteriaWithVL.size());
      } else {
        throw std::logic_error("Unknown criteria type");
      }
      ASSERT_NE(generatorFailingCriteriaWithoutVL, generatorFailingCriteriaWithVL);
    } else {
      ASSERT_EQ(generatorFailingCriteriaWithoutVL.size(), generatorFailingCriteriaWithVL.size());
      ASSERT_EQ(generatorFailingCriteriaWithoutVL, generatorFailingCriteriaWithVL);
    }

    if (vlTestConfig.vlTestType == criteria::CriteriaParams::SUM) {
      ASSERT_EQ(generatorFailingCriteriaWithoutVL.size(), 1);
      ASSERT_EQ(generatorFailingCriteriaWithVL.size(), 1);
    }
  }
}

}  // namespace DYN
