//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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

/*
 * @file Modeler/Common/test/Test.cpp
 * @brief Unit tests for common Modeler methods
 *
 */
#include <vector>
#include <map>
#include <sstream>
#include <string>

#include <boost/shared_ptr.hpp>
#include <boost/pointer_cast.hpp>

#ifdef USE_POWSYBL
#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>
#include <powsybl/iidm/DanglingLineAdder.hpp>
#include <powsybl/iidm/LoadAdder.hpp>
#include <powsybl/iidm/ShuntCompensatorAdder.hpp>
#include <powsybl/iidm/TwoWindingsTransformerAdder.hpp>
#include <powsybl/iidm/RatioTapChangerAdder.hpp>
#include <powsybl/iidm/LineAdder.hpp>
#else
#include <IIDM/Network.h>
#include <IIDM/components/Connection.h>
#include <IIDM/components/ConnectionPoint.h>
#include <IIDM/components/TapChanger.h>
#include <IIDM/components/Bus.h>
#include <IIDM/components/VoltageLevel.h>
#include <IIDM/components/Transformer2Windings.h>
#include <IIDM/components/Substation.h>
#include <IIDM/components/Line.h>
#include <IIDM/components/DanglingLine.h>
#include <IIDM/components/Load.h>
#include <IIDM/components/ShuntCompensator.h>
#include <IIDM/components/Switch.h>
#include <IIDM/builders/NetworkBuilder.h>
#include <IIDM/builders/Transformer2WindingsBuilder.h>
#include <IIDM/builders/VoltageLevelBuilder.h>
#include <IIDM/builders/BusBuilder.h>
#include <IIDM/builders/SubstationBuilder.h>
#include <IIDM/builders/LineBuilder.h>
#include <IIDM/builders/DanglingLineBuilder.h>
#include <IIDM/builders/LoadBuilder.h>
#include <IIDM/builders/ShuntCompensatorBuilder.h>
#include <IIDM/builders/SwitchBuilder.h>
#endif


#include "gtest_dynawo.h"
#include "DYNDataInterfaceIIDM.h"
#include "DYNSubModel.h"
#include "DYNExecUtils.h"
#include "DYNSubModelFactory.h"
#include "DYNElement.h"


using boost::shared_ptr;

namespace DYN {

//-----------------------------------------------------
// TEST DYNParameter
//-----------------------------------------------------

shared_ptr<SubModel>
initializeModelNetwork(shared_ptr<DataInterface> data) {
  shared_ptr<SubModel> modelNetwork = SubModelFactory::createSubModelFromLib("../DYNModelNetwork" + std::string(sharedLibraryExtension()));
  modelNetwork->initFromData(data);
  data->setModelNetwork(modelNetwork);
  modelNetwork->name("NETWORK");
  return modelNetwork;
}

struct NetworkProperty {
  bool instantiateTwoWindingTransformer;
  bool instantiateRatioTap;
  bool instantiateDanglingLine;
  bool instantiateLine;
  bool instantiateLoad;
  bool instantiateCapacitorShuntCompensator;
  bool instantiateReactanceShuntCompensator;
  bool instantiateSwitch;
};

#ifdef USE_POWSYBL
shared_ptr<DataInterface>
createDataItfFromNetwork(const boost::shared_ptr<powsybl::iidm::Network>& network) {
  shared_ptr<DataInterfaceIIDM> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  return data;
}
#endif

#ifdef USE_POWSYBL
shared_ptr<powsybl::iidm::Network>
#else
shared_ptr<DataInterface>
#endif
createNetwork(const NetworkProperty& properties) {
#ifdef USE_POWSYBL
  auto network = boost::make_shared<powsybl::iidm::Network>("test", "test");

  powsybl::iidm::Substation& s = network->newSubstation()
      .setId("S")
      .add();

  powsybl::iidm::VoltageLevel& vlIIDM = s.newVoltageLevel()
      .setId("MyVoltageLevel")
      .setNominalV(5.)
      .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
      .setHighVoltageLimit(2.)
      .setLowVoltageLimit(.5)
      .add();

  powsybl::iidm::Bus& iidmBus = vlIIDM.getBusBreakerView().newBus()
              .setId("MyBus")
              .add();
  iidmBus.setV(1);
  iidmBus.setAngle(0.);

  powsybl::iidm::Bus& iidmBus2 = vlIIDM.getBusBreakerView().newBus()
              .setId("MyBus2")
              .add();
  iidmBus2.setV(1);
  iidmBus2.setAngle(0.);
  if (properties.instantiateDanglingLine) {
    vlIIDM.newDanglingLine()
           .setId("MyDanglingLine")
           .setBus("MyBus")
           .setConnectableBus("MyBus")
           .setName("MyDanglingLine_NAME")
           .setB(3.0)
           .setG(3.0)
           .setP0(105.0)
           .setQ0(90.0)
           .setR(3.0)
           .setX(3.0)
           .setUcteXnodeCode("ucteXnodeCodeTest")
           .add();
  }

  if (properties.instantiateLoad) {
    vlIIDM.newLoad()
        .setId("MyLoad")
        .setBus("MyBus")
        .setConnectableBus("MyBus")
        .setName("LOAD1_NAME")
        .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
        .setP0(105.0)
        .setQ0(90.0)
        .add();
  }

  if (properties.instantiateCapacitorShuntCompensator) {
    vlIIDM.newShuntCompensator()
        .setId("MyCapacitorShuntCompensator")
        .setName("MyCapacitorShuntCompensator_NAME")
        .setBus("MyBus")
        .setConnectableBus("MyBus")
        .newLinearModel()
        .setBPerSection(8.0)
        .setMaximumSectionCount(3UL)
        .add()
        .setSectionCount(2UL)
        .add();
  }

  if (properties.instantiateReactanceShuntCompensator) {
    vlIIDM.newShuntCompensator()
        .setId("MyReactanceShuntCompensator")
        .setName("MyReactanceShuntCompensator_NAME")
        .setBus("MyBus")
        .setConnectableBus("MyBus")
        .newLinearModel()
        .setBPerSection(-8.0)
        .setMaximumSectionCount(3UL)
        .add()
        .setSectionCount(2UL)
        .add();
  }

  if (properties.instantiateSwitch) {
    vlIIDM.getBusBreakerView().newSwitch()
        .setId("MySwitch")
        .setName("MySwitchName")
        .setFictitious(false)
        .setBus1("MyBus")
        .setBus2("MyBus2")
        .add();
  }

  if (properties.instantiateTwoWindingTransformer) {
    powsybl::iidm::TwoWindingsTransformer& transformer = s.newTwoWindingsTransformer()
        .setId("MyTransformer2Winding")
        .setVoltageLevel1(vlIIDM.getId())
        .setBus1("MyBus")
        .setConnectableBus1("MyBus")
        .setVoltageLevel2(vlIIDM.getId())
        .setBus2("MyBus2")
        .setConnectableBus2("MyBus2")
        .setR(3.0)
        .setX(33.0)
        .setG(1.0)
        .setB(0.2)
        .setRatedU1(2.0)
        .setRatedU2(0.4)
        .setRatedS(3.0)
        .add();
    if (properties.instantiateRatioTap) {
      transformer.newRatioTapChanger()
          .setTapPosition(1)
          .setLowTapPosition(0)
          .setRegulationTerminal(stdcxx::ref<powsybl::iidm::Terminal>(transformer.getTerminal1()))
          .setRegulating(true)
          .setLoadTapChangingCapabilities(10.)
          .setTargetV(2.)
          .setTargetDeadband(1.)
          .beginStep()
          .setR(1.)
          .setX(1.)
          .setG(1.)
          .setB(1.)
          .setRho(1.)
          .endStep()
          .beginStep()
          .setR(2.)
          .setX(1.)
          .setG(1.)
          .setB(1.)
          .setRho(1.)
          .endStep()
          .add();
    }
  }

  if (properties.instantiateLine) {
    network->newLine()
                                      .setId("VL1_VL2")
                                      .setName("VL1_VL2_NAME")
                                      .setVoltageLevel1(vlIIDM.getId())
                                      .setBus1("MyBus")
                                      .setConnectableBus1("MyBus")
                                      .setVoltageLevel2(vlIIDM.getId())
                                      .setBus2("MyBus2")
                                      .setConnectableBus2("MyBus2")
                                      .setR(3.0)
                                      .setX(33.33)
                                      .setG1(1.0)
                                      .setB1(0.2)
                                      .setG2(2.0)
                                      .setB2(0.4)
                                      .add();
  }
#else
  IIDM::builders::NetworkBuilder nb;
  boost::shared_ptr<IIDM::Network> network = boost::make_shared<IIDM::Network>(nb.build("MyNetwork"));
  IIDM::connection_status_t cs = {true /*connected*/};
  IIDM::Port p1("MyBus1", cs), p2("MyBus2", cs);
  IIDM::Connection c1("MyVoltageLevel", p1, IIDM::side_1), c2("MyVoltageLevel", p2, IIDM::side_1);

  IIDM::builders::SubstationBuilder ssb;
  IIDM::Substation ss = ssb.build("MySubStation");

  IIDM::builders::BusBuilder bb;
  IIDM::Bus bus1 = bb.build("MyBus1");
  IIDM::Bus bus2 = bb.build("MyBus2");

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::bus_breaker);
  vlb.nominalV(5.);
  IIDM::VoltageLevel vl = vlb.build("MyVoltageLevel");
  vl.add(bus1);
  vl.add(bus2);
  vl.lowVoltageLimit(0.5);
  vl.highVoltageLimit(2.);

  if (properties.instantiateDanglingLine) {
    IIDM::builders::DanglingLineBuilder dlb;
    IIDM::DanglingLine dl = dlb.build("MyDanglingLine");
    vl.add(dl);
  }

  if (properties.instantiateLoad) {
    IIDM::builders::LoadBuilder lb;
    IIDM::Load load = lb.build("MyLoad");
    vl.add(load, c1);
  }

  if (properties.instantiateCapacitorShuntCompensator) {
    IIDM::builders::ShuntCompensatorBuilder scb;
    scb.b_per_section(8.);
    IIDM::ShuntCompensator sc = scb.build("MyCapacitorShuntCompensator");
    vl.add(sc, c1);
  }

  if (properties.instantiateReactanceShuntCompensator) {
    IIDM::builders::ShuntCompensatorBuilder scb;
    scb.b_per_section(-8.);
    IIDM::ShuntCompensator sc = scb.build("MyReactanceShuntCompensator");
    vl.add(sc, c1);
  }

  if (properties.instantiateSwitch) {
    IIDM::builders::SwitchBuilder sb;
    sb.opened(false);
    IIDM::Switch sw = sb.build("MySwitch");
    vl.add(sw, "MyBus1", "MyBus2");
  }

  ss.add(vl);

  if (properties.instantiateTwoWindingTransformer) {
    IIDM::builders::Transformer2WindingsBuilder t2Wb;
    IIDM::Transformer2Windings t2W = t2Wb.build("MyTransformer2Winding");
    if (properties.instantiateRatioTap) {
      IIDM::RatioTapChanger rtp(0, 0, true);
      IIDM::TerminalReference tr("", IIDM::side_1);
      rtp.terminalReference(tr);
      t2W.ratioTapChanger(rtp);
    }
    ss.add(t2W, c1, c2);
  }

  network->add(ss);

  if (properties.instantiateLine) {
    IIDM::builders::LineBuilder lb;
    IIDM::Line dl = lb.build("MyLine");
    network->add(dl, c1, c2);
  }
#endif

#ifdef USE_POWSYBL
  return network;
#else
  shared_ptr<DataInterface> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  return data;
#endif
}

TEST(ModelsModelNetwork, TestNetworkCreation) {
  const NetworkProperty properties = {
      true /*instantiateTwoWindingTransformer*/,
      true /*instantiateRatioTap*/,
      true /*instantiateDanglingLine*/,
      true /*instantiateLine*/,
      true /*instantiateLoad*/,
      true /*instantiateCapacitorShuntCompensator*/,
      true /*instantiateReactanceShuntCompensator*/,
      true /*instantiateSwitch*/
  };
#ifdef USE_POWSYBL
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
#else
  shared_ptr<DataInterface> data = createNetwork(properties);
#endif
  assert(data.get() != NULL);
  assert(data->getNetwork().get() != NULL);

  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);
  assert(modelNetwork.get() != NULL);
}

TEST(ModelsModelNetwork, ModelNetworkTwoWindingTransformerParam) {
  const NetworkProperty properties = {
      true /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTap*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateReactanceShuntCompensator*/,
      false /*instantiateSwitch*/
  };
#ifdef USE_POWSYBL
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
#else
  shared_ptr<DataInterface> data = createNetwork(properties);
#endif
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("transformer_currentLimit_maxTimeOperation", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("transformer_t1st_THT", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("transformer_tNext_THT", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("transformer_t1st_HT", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("transformer_tNext_HT", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("transformer_tolV", isInitParam), true);

  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());

  modelNetwork->setParameterValue("transformer_currentLimit_maxTimeOperation", PAR, 7., isInitParam);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());
}

TEST(ModelsModelNetwork, ModelNetworkTwoWindingTransformerWithRatioTapChangerParam) {
  const NetworkProperty properties = {
      true /*instantiateTwoWindingTransformer*/,
      true /*instantiateRatioTap*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateReactanceShuntCompensator*/,
      false /*instantiateSwitch*/
  };
#ifdef USE_POWSYBL
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
#else
  shared_ptr<DataInterface> data = createNetwork(properties);
#endif
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;

  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);

  modelNetwork->setParameterValue("transformer_currentLimit_maxTimeOperation", PAR, 7., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);

  modelNetwork->setParameterValue("transformer_t1st_THT", PAR, 9., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);

  modelNetwork->setParameterValue("transformer_tNext_THT", PAR, 10., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);

  modelNetwork->setParameterValue("transformer_t1st_HT", PAR, 11., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);

  modelNetwork->setParameterValue("transformer_tNext_HT", PAR, 12., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);

  modelNetwork->setParameterValue("transformer_tolV", PAR, 13., isInitParam);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());
}

TEST(ModelsModelNetwork, ModelNetworkBusParam) {
  const NetworkProperty properties = {
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTap*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateReactanceShuntCompensator*/,
      false /*instantiateSwitch*/
  };
#ifdef USE_POWSYBL
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
#else
  shared_ptr<DataInterface> data = createNetwork(properties);
#endif
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("bus_uMax", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("bus_uMin", isInitParam), true);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());

  modelNetwork->setParameterValue("bus_uMax", PAR, 7., isInitParam);
  ParameterModeler param = modelNetwork->findParameter("bus_uMin", isInitParam);
  ASSERT_THROW_DYNAWO(param.getValue<double>(), Error::MODELER, KeyError_t::ParameterHasNoValue);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());

  modelNetwork->setParameterValue("bus_uMin", PAR, 8., isInitParam);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());
}

TEST(ModelsModelNetwork, ModelNetworkDanglingLineParam) {
  const NetworkProperty properties = {
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTap*/,
      true /*instantiateDanglingLine*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateReactanceShuntCompensator*/,
      false /*instantiateSwitch*/
  };
#ifdef USE_POWSYBL
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
#else
  shared_ptr<DataInterface> data = createNetwork(properties);
#endif
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("dangling_line_currentLimit_maxTimeOperation", isInitParam), true);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());

  modelNetwork->setParameterValue("dangling_line_currentLimit_maxTimeOperation", PAR, 7., isInitParam);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());
}

TEST(ModelsModelNetwork, ModelNetworkLineParam) {
  const NetworkProperty properties = {
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTap*/,
      false /*instantiateDanglingLine*/,
      true /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateReactanceShuntCompensator*/,
      false /*instantiateSwitch*/
  };
#ifdef USE_POWSYBL
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
#else
  shared_ptr<DataInterface> data = createNetwork(properties);
#endif
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("line_currentLimit_maxTimeOperation", isInitParam), true);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());

  modelNetwork->setParameterValue("line_currentLimit_maxTimeOperation", PAR, 7., isInitParam);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());
}

TEST(ModelsModelNetwork, ModelNetworkLoadParam) {
  const NetworkProperty properties = {
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTap*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateLine*/,
      true /*instantiateLoad*/,
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateReactanceShuntCompensator*/,
      false /*instantiateSwitch*/
  };
#ifdef USE_POWSYBL
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
#else
  shared_ptr<DataInterface> data = createNetwork(properties);
#endif
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("load_alpha", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("load_beta", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("load_isRestorative", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("load_isControllable", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("load_Tp", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("load_Tq", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("load_zPMax", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("load_zQMax", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("load_alphaLong", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("load_betaLong", isInitParam), true);

  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_alpha", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_beta", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_isRestorative", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_isControllable", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_Tp", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_Tq", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_zPMax", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_zQMax", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_alphaLong", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_betaLong", isInitParam), true);

  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);

  modelNetwork->setParameterValue("load_alpha", PAR, 7., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("load_beta", PAR, 8., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("load_isRestorative", PAR, true, isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("load_isControllable", PAR, true, isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("load_Tp", PAR, 9., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("load_Tq", PAR, 10., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("load_zPMax", PAR, 11., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("load_zQMax", PAR, 12., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("load_alphaLong", PAR, 13., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("load_betaLong", PAR, 14., isInitParam);

  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());
}

TEST(ModelsModelNetwork, ModelNetworkCapacitorShuntCompensatorParam) {
  const NetworkProperty properties = {
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTap*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      true /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateReactanceShuntCompensator*/,
      false /*instantiateSwitch*/
  };
#ifdef USE_POWSYBL
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
#else
  shared_ptr<DataInterface> data = createNetwork(properties);
#endif
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("capacitor_no_reclosing_delay", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("reactance_no_reclosing_delay", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyCapacitorShuntCompensator_no_reclosing_delay", isInitParam), true);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);

  modelNetwork->setParameterValue("reactance_no_reclosing_delay", PAR, 7., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("capacitor_no_reclosing_delay", PAR, 8., isInitParam);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());
}

TEST(ModelsModelNetwork, ModelNetworkReactanceShuntCompensatorParam) {
  const NetworkProperty properties = {
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTap*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateCapacitorShuntCompensator*/,
      true /*instantiateReactanceShuntCompensator*/,
      false /*instantiateSwitch*/
  };
#ifdef USE_POWSYBL
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
#else
  shared_ptr<DataInterface> data = createNetwork(properties);
#endif
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("capacitor_no_reclosing_delay", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("reactance_no_reclosing_delay", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyReactanceShuntCompensator_no_reclosing_delay", isInitParam), true);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);

  modelNetwork->setParameterValue("capacitor_no_reclosing_delay", PAR, 7., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("reactance_no_reclosing_delay", PAR, 8., isInitParam);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());
}

TEST(ModeslModelNetwork, ModelNetworkSwitchVariablesCheck) {
  const NetworkProperty properties = {
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTap*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateReactanceShuntCompensator*/,
      true /*instantiateSwitch*/
  };
#ifdef USE_POWSYBL
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
#else
  shared_ptr<DataInterface> data = createNetwork(properties);
#endif
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineVariables();
  ASSERT_EQ(true, modelNetwork->hasVariable("MySwitch_swState_value"));
  ASSERT_EQ(true, modelNetwork->hasVariable("MySwitch_state_value"));
  ASSERT_EQ(true, modelNetwork->hasVariable("MySwitch_irsw"));
  ASSERT_EQ(true, modelNetwork->hasVariable("MySwitch_iisw"));

  modelNetwork->defineElements();
  std::vector<Element> elt = modelNetwork->getElements("MySwitch_swState");
  ASSERT_EQ(elt.size(), 1);
  ASSERT_EQ(elt[0].name(), "value");
  ASSERT_EQ(elt[0].id(), "MySwitch_swState_value");
  ASSERT_EQ(elt[0].getTypeElement(), Element::TERMINAL);

  std::vector<Element> elt1 = modelNetwork->getElements("MySwitch_state");
  ASSERT_EQ(elt1.size(), 1);
  ASSERT_EQ(elt1[0].name(), "value");
  ASSERT_EQ(elt1[0].id(), "MySwitch_state_value");
  ASSERT_EQ(elt1[0].getTypeElement(), Element::TERMINAL);
}

}  // namespace DYN
