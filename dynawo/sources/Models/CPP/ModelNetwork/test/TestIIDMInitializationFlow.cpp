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

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>
#include <powsybl/iidm/DanglingLineAdder.hpp>
#include <powsybl/iidm/LoadAdder.hpp>
#include <powsybl/iidm/ShuntCompensatorAdder.hpp>
#include <powsybl/iidm/TwoWindingsTransformerAdder.hpp>
#include <powsybl/iidm/RatioTapChangerAdder.hpp>
#include <powsybl/iidm/LineAdder.hpp>


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

static shared_ptr<SubModel>
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

static shared_ptr<DataInterface>
createDataItfFromNetwork(const boost::shared_ptr<powsybl::iidm::Network>& network) {
  shared_ptr<DataInterfaceIIDM> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  return data;
}

static
shared_ptr<powsybl::iidm::Network>
createNetwork(const NetworkProperty& properties) {
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
          .setLoadTapChangingCapabilities(true)
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

  return network;
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
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
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
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;
  const bool isLinearizeParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("transformer_currentLimit_maxTimeOperation", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("transformer_t1st_THT", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("transformer_tNext_THT", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("transformer_t1st_HT", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("transformer_tNext_HT", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("transformer_tolV", isInitParam, isLinearizeParam), true);

  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());

  modelNetwork->setParameterValue("transformer_currentLimit_maxTimeOperation", PAR, 7., isInitParam, isLinearizeParam);
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
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;
  const bool isLinearizeParam = false;

  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);

  modelNetwork->setParameterValue("transformer_currentLimit_maxTimeOperation", PAR, 7., isInitParam, isLinearizeParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);

  modelNetwork->setParameterValue("transformer_t1st_THT", PAR, 9., isInitParam, isLinearizeParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);

  modelNetwork->setParameterValue("transformer_tNext_THT", PAR, 10., isInitParam, isLinearizeParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);

  modelNetwork->setParameterValue("transformer_t1st_HT", PAR, 11., isInitParam, isLinearizeParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);

  modelNetwork->setParameterValue("transformer_tNext_HT", PAR, 12., isInitParam, isLinearizeParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);

  modelNetwork->setParameterValue("transformer_tolV", PAR, 13., isInitParam, isLinearizeParam);
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
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;
  const bool isLinearizeParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("bus_uMax", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("bus_uMin", isInitParam, isLinearizeParam), true);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());

  modelNetwork->setParameterValue("bus_uMax", PAR, 7., isInitParam, isLinearizeParam);
  ParameterModeler param = modelNetwork->findParameter("bus_uMin", isInitParam, isLinearizeParam);
  ASSERT_THROW_DYNAWO(param.getValue<double>(), Error::MODELER, KeyError_t::ParameterHasNoValue);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());

  modelNetwork->setParameterValue("bus_uMin", PAR, 8., isInitParam, isLinearizeParam);
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
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;
  const bool isLinearizeParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("dangling_line_currentLimit_maxTimeOperation", isInitParam, isLinearizeParam), true);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());

  modelNetwork->setParameterValue("dangling_line_currentLimit_maxTimeOperation", PAR, 7., isInitParam, isLinearizeParam);
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
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;
  const bool isLinearizeParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("line_currentLimit_maxTimeOperation", isInitParam, isLinearizeParam), true);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());

  modelNetwork->setParameterValue("line_currentLimit_maxTimeOperation", PAR, 7., isInitParam, isLinearizeParam);
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
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;
  const bool isLinearizeParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("load_alpha", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("load_beta", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("load_isRestorative", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("load_isControllable", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("load_Tp", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("load_Tq", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("load_zPMax", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("load_zQMax", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("load_alphaLong", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("load_betaLong", isInitParam, isLinearizeParam), true);

  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_alpha", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_beta", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_isRestorative", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_isControllable", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_Tp", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_Tq", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_zPMax", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_zQMax", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_alphaLong", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyLoad_betaLong", isInitParam, isLinearizeParam), true);

  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);

  modelNetwork->setParameterValue("load_alpha", PAR, 7., isInitParam, isLinearizeParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("load_beta", PAR, 8., isInitParam, isLinearizeParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("load_isRestorative", PAR, true, isInitParam, isLinearizeParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("load_isControllable", PAR, true, isInitParam, isLinearizeParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("load_Tp", PAR, 9., isInitParam, isLinearizeParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("load_Tq", PAR, 10., isInitParam, isLinearizeParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("load_zPMax", PAR, 11., isInitParam, isLinearizeParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("load_zQMax", PAR, 12., isInitParam, isLinearizeParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("load_alphaLong", PAR, 13., isInitParam, isLinearizeParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("load_betaLong", PAR, 14., isInitParam, isLinearizeParam);

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
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;
  const bool isLinearizeParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("capacitor_no_reclosing_delay", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("reactance_no_reclosing_delay", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyCapacitorShuntCompensator_no_reclosing_delay", isInitParam, isLinearizeParam), true);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);

  modelNetwork->setParameterValue("reactance_no_reclosing_delay", PAR, 7., isInitParam, isLinearizeParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("capacitor_no_reclosing_delay", PAR, 8., isInitParam, isLinearizeParam);
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
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;
  const bool isLinearizeParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("capacitor_no_reclosing_delay", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("reactance_no_reclosing_delay", isInitParam, isLinearizeParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyReactanceShuntCompensator_no_reclosing_delay", isInitParam, isLinearizeParam), true);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);

  modelNetwork->setParameterValue("capacitor_no_reclosing_delay", PAR, 7., isInitParam, isLinearizeParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  modelNetwork->setParameterValue("reactance_no_reclosing_delay", PAR, 8., isInitParam, isLinearizeParam);
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
  shared_ptr<DataInterface> data = createDataItfFromNetwork(createNetwork(properties));
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
