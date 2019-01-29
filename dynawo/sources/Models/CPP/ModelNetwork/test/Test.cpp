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
  shared_ptr<SubModel> modelNetwork;
  modelNetwork.reset(SubModelFactory::createSubModelFromLib("../DYNModelNetwork.so"));
  modelNetwork->initFromData(data);
  data->setModelNetwork(modelNetwork);
  modelNetwork->name("NETWORK");
  return modelNetwork;
}

struct NetworkProperty {
  bool instantiateTwoWindingTransformer;
  bool instantiateRadioTap;
  bool instantiateDanglingLine;
  bool instantiateLine;
  bool instantiateLoad;
  bool instantiateCapacitorShuntCompensator;
  bool instantiateReactanceShuntCompensator;
  bool instantiateSwitch;
};

shared_ptr<DataInterface>
createNetwork(const NetworkProperty& properties) {
  IIDM::builders::NetworkBuilder nb;
  IIDM::Network network = nb.build("MyNetwork");
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
    if (properties.instantiateRadioTap) {
      IIDM::RatioTapChanger rtp(0, 0, true);
      t2W.ratioTapChanger(rtp);
    }
    ss.add(t2W, c1, c2);
  }

  network.add(ss);

  if (properties.instantiateLine) {
    IIDM::builders::LineBuilder lb;
    IIDM::Line dl = lb.build("MyLine");
    network.add(dl, c1, c2);
  }

  shared_ptr<DataInterface> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  return data;
}

TEST(ModelsModelNetwork, TestNetworkCreation) {
  const NetworkProperty properties = {
      true /*instantiateTwoWindingTransformer*/,
      true /*instantiateRadioTap*/,
      true /*instantiateDanglingLine*/,
      true /*instantiateLine*/,
      true /*instantiateLoad*/,
      true /*instantiateCapacitorShuntCompensator*/,
      true /*instantiateReactanceShuntCompensator*/,
      true /*instantiateSwitch*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  assert(data.get() != NULL);
  assert(data->getNetwork().get() != NULL);

  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);
  assert(modelNetwork.get() != NULL);
}

TEST(ModelsModelNetwork, ModelNetworkTwoWindingTransformerParam) {
  const NetworkProperty properties = {
      true /*instantiateTwoWindingTransformer*/,
      false /*instantiateRadioTap*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateReactanceShuntCompensator*/,
      false /*instantiateSwitch*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("TFO_currentLimit_maxTimeOperation", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("TFO_t1st_THT", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("TFO_tNext_THT", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("TFO_t1st_HT", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("TFO_tNext_HT", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("TFO_tolV", isInitParam), true);

  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());

  modelNetwork->setParameterValue("TFO_currentLimit_maxTimeOperation", PAR, 7., isInitParam);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());
}

TEST(ModelsModelNetwork, ModelNetworkTwoWindingTransformerWithRatioTapChangerParam) {
  const NetworkProperty properties = {
      true /*instantiateTwoWindingTransformer*/,
      true /*instantiateRadioTap*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateReactanceShuntCompensator*/,
      false /*instantiateSwitch*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;

  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);

  modelNetwork->setParameterValue("TFO_currentLimit_maxTimeOperation", PAR, 7., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);

  modelNetwork->setParameterValue("TFO_t1st_THT", PAR, 9., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);

  modelNetwork->setParameterValue("TFO_tNext_THT", PAR, 10., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);

  modelNetwork->setParameterValue("TFO_t1st_HT", PAR, 11., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);

  modelNetwork->setParameterValue("TFO_tNext_HT", PAR, 12., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);

  modelNetwork->setParameterValue("TFO_tolV", PAR, 13., isInitParam);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());
}

TEST(ModelsModelNetwork, ModelNetworkBusParam) {
  const NetworkProperty properties = {
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRadioTap*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateReactanceShuntCompensator*/,
      false /*instantiateSwitch*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("BUS_uMax", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("BUS_uMin", isInitParam), true);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());

  modelNetwork->setParameterValue("BUS_uMax", PAR, 7., isInitParam);
  ParameterModeler param = modelNetwork->findParameter("BUS_uMin", isInitParam);
  ASSERT_THROW_DYNAWO(param.getValue<double>(), Error::MODELER, KeyError_t::ParameterHasNoValue);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());

  modelNetwork->setParameterValue("BUS_uMin", PAR, 8., isInitParam);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());
}

TEST(ModelsModelNetwork, ModelNetworkDanglingLineParam) {
  const NetworkProperty properties = {
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRadioTap*/,
      true /*instantiateDanglingLine*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateReactanceShuntCompensator*/,
      false /*instantiateSwitch*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("DANGLING_LINE_currentLimit_maxTimeOperation", isInitParam), true);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());

  modelNetwork->setParameterValue("DANGLING_LINE_currentLimit_maxTimeOperation", PAR, 7., isInitParam);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());
}

TEST(ModelsModelNetwork, ModelNetworkLineParam) {
  const NetworkProperty properties = {
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRadioTap*/,
      false /*instantiateDanglingLine*/,
      true /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateReactanceShuntCompensator*/,
      false /*instantiateSwitch*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("LINE_currentLimit_maxTimeOperation", isInitParam), true);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());

  modelNetwork->setParameterValue("LINE_currentLimit_maxTimeOperation", PAR, 7., isInitParam);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());
}

TEST(ModelsModelNetwork, ModelNetworkLoadParam) {
  const NetworkProperty properties = {
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRadioTap*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateLine*/,
      true /*instantiateLoad*/,
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateReactanceShuntCompensator*/,
      false /*instantiateSwitch*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("LOAD_alpha", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("LOAD_beta", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("LOAD_isRestorative", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("LOAD_isControllable", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("LOAD_Tp", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("LOAD_Tq", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("LOAD_zPMax", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("LOAD_zQMax", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("LOAD_alphaLong", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("LOAD_betaLong", isInitParam), true);

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

  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);

  modelNetwork->setParameterValue("LOAD_alpha", PAR, 7., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);
  modelNetwork->setParameterValue("LOAD_beta", PAR, 8., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);
  modelNetwork->setParameterValue("LOAD_isRestorative", PAR, true, isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);
  modelNetwork->setParameterValue("LOAD_isControllable", PAR, true, isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);
  modelNetwork->setParameterValue("LOAD_Tp", PAR, 9., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);
  modelNetwork->setParameterValue("LOAD_Tq", PAR, 10., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);
  modelNetwork->setParameterValue("LOAD_zPMax", PAR, 11., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);
  modelNetwork->setParameterValue("LOAD_zQMax", PAR, 12., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);
  modelNetwork->setParameterValue("LOAD_alphaLong", PAR, 13., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);
  modelNetwork->setParameterValue("LOAD_betaLong", PAR, 14., isInitParam);

  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());
}

TEST(ModelsModelNetwork, ModelNetworkCapacitorShuntCompensatorParam) {
  const NetworkProperty properties = {
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRadioTap*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      true /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateReactanceShuntCompensator*/,
      false /*instantiateSwitch*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("CAPACITOR_no_reclosing_delay", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("REACTANCE_no_reclosing_delay", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyCapacitorShuntCompensator_no_reclosing_delay", isInitParam), true);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);

  modelNetwork->setParameterValue("REACTANCE_no_reclosing_delay", PAR, 7., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);
  modelNetwork->setParameterValue("CAPACITOR_no_reclosing_delay", PAR, 8., isInitParam);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());
}

TEST(ModelsModelNetwork, ModelNetworkReactanceShuntCompensatorParam) {
  const NetworkProperty properties = {
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRadioTap*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateCapacitorShuntCompensator*/,
      true /*instantiateReactanceShuntCompensator*/,
      false /*instantiateSwitch*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);

  modelNetwork->defineParameters();
  const bool isInitParam = false;

  ASSERT_EQ(modelNetwork->hasParameter("CAPACITOR_no_reclosing_delay", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("REACTANCE_no_reclosing_delay", isInitParam), true);
  ASSERT_EQ(modelNetwork->hasParameter("MyReactanceShuntCompensator_no_reclosing_delay", isInitParam), true);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);

  modelNetwork->setParameterValue("CAPACITOR_no_reclosing_delay", PAR, 7., isInitParam);
  ASSERT_THROW_DYNAWO(modelNetwork->setSubModelParameters(), Error::MODELER, KeyError_t::ParameterNotFoundFor);
  modelNetwork->setParameterValue("REACTANCE_no_reclosing_delay", PAR, 8., isInitParam);
  ASSERT_NO_THROW(modelNetwork->setSubModelParameters());
}

TEST(ModeslModelNetwork, ModelNetworkSwitchVariablesCheck) {
  const NetworkProperty properties = {
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRadioTap*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateReactanceShuntCompensator*/,
      true /*instantiateSwitch*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
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
