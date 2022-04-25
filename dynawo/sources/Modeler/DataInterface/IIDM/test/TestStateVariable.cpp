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

/**
 * @file Modeler/DataInterface/test/TestStateVariable.cpp
 * @brief Unit tests for DataInterface/StateVariable class
 *
 */

#include <IIDM/Network.h>
#include <IIDM/components/Connection.h>
#include <IIDM/components/ConnectionPoint.h>
#include <IIDM/components/TapChanger.h>
#include <IIDM/components/Bus.h>
#include <IIDM/components/VoltageLevel.h>
#include <IIDM/components/ShuntCompensator.h>
#include <IIDM/components/Substation.h>
#include <IIDM/components/StaticVarCompensator.h>
#include <IIDM/components/DanglingLine.h>
#include <IIDM/components/Generator.h>
#include <IIDM/components/LccConverterStation.h>
#include <IIDM/components/HvdcLine.h>
#include <IIDM/components/Line.h>
#include <IIDM/components/Load.h>
#include <IIDM/components/Switch.h>
#include <IIDM/components/VscConverterStation.h>
#include <IIDM/builders/NetworkBuilder.h>
#include <IIDM/builders/Transformer2WindingsBuilder.h>
#include <IIDM/builders/VoltageLevelBuilder.h>
#include <IIDM/builders/ShuntCompensatorBuilder.h>
#include <IIDM/builders/SubstationBuilder.h>
#include <IIDM/builders/BusBuilder.h>
#include <IIDM/builders/StaticVarCompensatorBuilder.h>
#include <IIDM/builders/DanglingLineBuilder.h>
#include <IIDM/builders/GeneratorBuilder.h>
#include <IIDM/builders/LccConverterStationBuilder.h>
#include <IIDM/builders/HvdcLineBuilder.h>
#include <IIDM/builders/LineBuilder.h>
#include <IIDM/builders/LoadBuilder.h>
#include <IIDM/builders/SwitchBuilder.h>
#include <IIDM/builders/VscConverterStationBuilder.h>
#include <IIDM/extensions/standbyAutomaton/StandbyAutomaton.h>
#include <IIDM/extensions/standbyAutomaton/StandbyAutomatonBuilder.h>

#include <IIDM/extensions/generatorActivePowerControl/GeneratorActivePowerControl.h>
#include <IIDM/extensions/generatorActivePowerControl/GeneratorActivePowerControlBuilder.h>

#include "gtest_dynawo.h"
#include "DYNStateVariable.h"
#include "DYNVariableNative.h"
#include "DYNDataInterfaceIIDM.h"
#include "DYNSubModel.h"
#include "DYNExecUtils.h"
#include "DYNSubModelFactory.h"
#include "DYNModelMulti.h"
#include "DYNNetworkInterface.h"
#include "DYNVoltageLevelInterface.h"
#include "DYNShuntCompensatorInterface.h"
#include "DYNStaticVarCompensatorInterface.h"
#include "DYNTwoWTransformerInterface.h"
#include "DYNPhaseTapChangerInterface.h"
#include "DYNRatioTapChangerInterface.h"

#include <boost/make_shared.hpp>

using boost::shared_ptr;

namespace DYN {

struct NetworkProperty {
  bool instantiateCapacitorShuntCompensator;
  bool instantiateStaticVarCompensatorStandByAutomatonExt;
  bool instantiateStaticVarCompensator;
  bool instantiateTwoWindingTransformer;
  bool instantiateRatioTapChanger;
  bool instantiatePhaseTapChanger;
  bool instantiateDanglingLine;
  bool instantiateGenerator;
  bool instantiateGeneratorWithActivePowerControlExt;
  bool instantiateLccConverter;
  bool instantiateLine;
  bool instantiateLoad;
  bool instantiateSwitch;
  bool instantiateVscConverter;
};

static shared_ptr<SubModel>
initializeModelNetwork(shared_ptr<DataInterface> data) {
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

  bool hasRatioTapChanger = !data->getNetwork()->getTwoWTransformers().empty() && data->getNetwork()->getTwoWTransformers()[0]->getRatioTapChanger();
  bool hasPhaseTapChanger = !data->getNetwork()->getTwoWTransformers().empty() && data->getNetwork()->getTwoWTransformers()[0]->getPhaseTapChanger();
  if (hasRatioTapChanger || hasPhaseTapChanger) {
    parametersSet->createParameter("transformer_t1st_THT", 9.);
    parametersSet->createParameter("transformer_tNext_THT", 10.);
    parametersSet->createParameter("transformer_t1st_HT", 11.);
    parametersSet->createParameter("transformer_tNext_HT", 12.);
  }
  if (hasRatioTapChanger) {
    parametersSet->createParameter("transformer_tolV", 13.);
    }
  modelNetwork->setPARParameters(parametersSet);
  return modelNetwork;
}

static shared_ptr<DataInterface>
createNetwork(const NetworkProperty& properties) {
  IIDM::builders::NetworkBuilder nb;
  boost::shared_ptr<IIDM::Network> network = boost::make_shared<IIDM::Network>(nb.build("MyNetwork"));
  IIDM::connection_status_t cs = {true /*connected*/};
  IIDM::Port p1("MyBus", cs), p2("MyBus", cs);
  IIDM::Connection c1("MyVoltageLevel", p1, IIDM::side_1), c2("MyVoltageLevel", p2, IIDM::side_2);

  IIDM::builders::SubstationBuilder ssb;
  IIDM::Substation ss = ssb.build("MySubStation");

  IIDM::builders::BusBuilder bb;
  bb.v(0.5);
  bb.angle(1.);
  IIDM::Bus bus = bb.build("MyBus");

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::bus_breaker);
  vlb.nominalV(5.);
  IIDM::VoltageLevel vl = vlb.build("MyVoltageLevel");
  vl.add(bus);
  vl.lowVoltageLimit(0.5);
  vl.highVoltageLimit(2.);

  if (properties.instantiateDanglingLine) {
    IIDM::builders::DanglingLineBuilder dlb;
    IIDM::DanglingLine dl = dlb.build("MyDanglingLine");
    dl.connectTo("MyVoltageLevel", p1);
    vl.add(dl);
  }

  if (properties.instantiateLoad) {
    IIDM::builders::LoadBuilder lb;
    IIDM::Load load = lb.build("MyLoad");
    vl.add(load, c1);
  }

  if (properties.instantiateSwitch) {
    IIDM::builders::SwitchBuilder sb;
    IIDM::Switch s = sb.build("MySwitch");
    vl.add(s, "MyBus", "MyBus");
  }

  if (properties.instantiateGenerator) {
    IIDM::builders::GeneratorBuilder gb;
    IIDM::MinMaxReactiveLimits limits(1., 2.);
    gb.minMaxReactiveLimits(limits);
    IIDM::Generator g = gb.build("MyGenerator");
    g.connectTo("MyVoltageLevel", p1);
    vl.add(g);
  }

  if (properties.instantiateGeneratorWithActivePowerControlExt) {
    IIDM::builders::GeneratorBuilder gb;
    IIDM::MinMaxReactiveLimits limits(1., 2.);
    gb.minMaxReactiveLimits(limits);
    IIDM::Generator g = gb.build("MyGenerator");
    g.connectTo("MyVoltageLevel", p1);
    IIDM::extensions::generatoractivepowercontrol::GeneratorActivePowerControlBuilder gapc;
    gapc.droop(4.);
    gapc.participate(true);
    g.setExtension(gapc.build());
    vl.add(g);
  }

  if (properties.instantiateVscConverter) {
    IIDM::builders::VscConverterStationBuilder vsccb;
    vsccb.p(2.);
    vsccb.q(3.);
    IIDM::MinMaxReactiveLimits limits(1., 2.);
    vsccb.minMaxReactiveLimits(limits);
    IIDM::VscConverterStation vsc = vsccb.build("MyVscConverterStation");
    vsc.connectTo("MyVoltageLevel", p1);
    vl.add(vsc);
    IIDM::VscConverterStation vsc2 = vsccb.build("MyVscConverterStation2");
    vsc2.connectTo("MyVoltageLevel", p1);
    vl.add(vsc2);

    IIDM::builders::HvdcLineBuilder hvdcb;
    hvdcb.converterStation1("MyVscConverterStation");
    hvdcb.converterStation2("MyVscConverterStation2");
    hvdcb.convertersMode(IIDM::HvdcLine::mode_InverterRectifier);
    IIDM::HvdcLine hvdc = hvdcb.build("MyHvdcLine2");
    network->add(hvdc);
  }

  if (properties.instantiateLccConverter) {
    IIDM::builders::LccConverterStationBuilder lcsb;
    lcsb.p(2.);
    lcsb.q(3.);
    IIDM::LccConverterStation lcc = lcsb.build("MyLccConverter");
    lcc.connectTo("MyVoltageLevel", p1);
    vl.add(lcc);
    IIDM::LccConverterStation lcc2 = lcsb.build("MyLccConverter2");
    lcc2.connectTo("MyVoltageLevel", p1);
    vl.add(lcc2);

    IIDM::builders::HvdcLineBuilder hvdcb;
    hvdcb.converterStation1("MyLccConverter");
    hvdcb.converterStation2("MyLccConverter2");
    hvdcb.convertersMode(IIDM::HvdcLine::mode_InverterRectifier);
    IIDM::HvdcLine hvdc = hvdcb.build("MyHvdcLine");
    network->add(hvdc);
  }

  if (properties.instantiateCapacitorShuntCompensator) {
    IIDM::builders::ShuntCompensatorBuilder scb;
    scb.section_max(20);
    scb.b_per_section(8.);
    IIDM::ShuntCompensator sc = scb.build("MyCapacitorShuntCompensator");
    sc.currentSection(8);
    vl.add(sc, c1);
  }

  if (properties.instantiateStaticVarCompensatorStandByAutomatonExt) {
    IIDM::builders::StaticVarCompensatorBuilder svcb;
    IIDM::extensions::standbyautomaton::StandbyAutomatonBuilder sbab;
    sbab.standBy(true);
    svcb.regulationMode(IIDM::StaticVarCompensator::regulation_voltage);
    svcb.bmin(1.0);
    svcb.bmax(10.0);
    IIDM::StaticVarCompensator svc = svcb.build("MyStaticVarCompensatorStandByAutomatonExt");
    svc.setExtension(sbab.build());
    vl.add(svc, c1);
  }

  if (properties.instantiateStaticVarCompensator) {
    IIDM::builders::StaticVarCompensatorBuilder svcb;
    svcb.regulationMode(IIDM::StaticVarCompensator::regulation_voltage);
    svcb.bmin(1.0);
    svcb.bmax(10.0);
    IIDM::StaticVarCompensator svc = svcb.build("MyStaticVarCompensator");
    vl.add(svc, c1);
  }

  ss.add(vl);

  if (properties.instantiateTwoWindingTransformer) {
    IIDM::builders::Transformer2WindingsBuilder t2Wb;
    IIDM::Transformer2Windings t2W = t2Wb.build("MyTransformer2Winding");
    if (properties.instantiateRatioTapChanger) {
      IIDM::RatioTapChanger rtp(0, 0, true);
      IIDM::RatioTapChangerStep step(1., 1., 1., 1., 1.);
      IIDM::RatioTapChangerStep step2(2., 1., 1., 1., 1.);
      rtp.add(step);
      rtp.add(step2);
      rtp.tapPosition(1);
      t2W.ratioTapChanger(rtp);
    }
    if (properties.instantiatePhaseTapChanger) {
      IIDM::PhaseTapChanger ptc(0, 0, IIDM::PhaseTapChanger::mode_active_power_control);
      IIDM::PhaseTapChangerStep step(1., 1., 1., 1., 1., 1.);
      IIDM::PhaseTapChangerStep step2(2., 1., 1., 1., 1., 1.);
      IIDM::PhaseTapChangerStep step3(3., 1., 1., 1., 1., 1.);
      ptc.add(step);
      ptc.add(step2);
      ptc.add(step3);
      ptc.tapPosition(2);
      t2W.phaseTapChanger(ptc);
    }
    ss.add(t2W, c1, c2);
  }

  network->add(ss);

  if (properties.instantiateLine) {
    IIDM::builders::LineBuilder lb;
    IIDM::Line dl = lb.build("MyLine");
    network->add(dl, c1, c2);
  }

  shared_ptr<DataInterface> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  return data;
}

TEST(ModelsModelNetwork, TestNetworkCreation) {
  const NetworkProperty properties = {
      true /*instantiateCapacitorShuntCompensator*/,
      true /*instantiateStaticVarCompensatorStandByAutomatonExt*/,
      false /*instantiateStaticVarCompensator*/,
      true /*instantiateTwoWindingTransformer*/,
      true /*instantiateRatioTapChanger*/,
      true /*instantiatePhaseTapChanger*/,
      true /*instantiateDanglingLine*/,
      true /*instantiateGenerator*/,
      false /*instantiateGeneratorWithActivePowerControlExt*/,
      true /*instantiateLccConverter*/,
      true /*instantiateLine*/,
      true /*instantiateLoad*/,
      true /*instantiateSwitch*/,
      true /*instantiateVscConverter*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  assert(data.get() != NULL);
  assert(data->getNetwork().get() != NULL);

  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);
  assert(modelNetwork.get() != NULL);

  shared_ptr<NetworkInterface> network = data->getNetwork();
  const std::vector< shared_ptr<VoltageLevelInterface> >& voltageLevels = network->getVoltageLevels();
  ASSERT_EQ(voltageLevels.size(), 1);
  for (std::size_t i = 0, iEnd = voltageLevels.size(); i < iEnd; ++i) {
    shared_ptr<VoltageLevelInterface> voltageLevel = voltageLevels[i];
    const std::vector< shared_ptr<LccConverterInterface> >&  lccConverters = voltageLevel->getLccConverters();
    ASSERT_EQ(lccConverters.size(), 2);

    const std::vector< shared_ptr<ShuntCompensatorInterface> >&  shuntCompensators = voltageLevel->getShuntCompensators();
    ASSERT_EQ(shuntCompensators.size(), 1);
    for (std::size_t j = 0, jEnd = shuntCompensators.size(); j < jEnd; ++j) {
      shared_ptr<ShuntCompensatorInterface> shuntCompensator = shuntCompensators[j];
      ASSERT_EQ(shuntCompensator->getCurrentSection(), 8);
    }

    const std::vector< shared_ptr<StaticVarCompensatorInterface> >&  staticVarCompensators = voltageLevel->getStaticVarCompensators();
    ASSERT_EQ(staticVarCompensators.size(), 1);
    for (std::size_t j = 0, jEnd = staticVarCompensators.size(); j < jEnd; ++j) {
      shared_ptr<StaticVarCompensatorInterface> staticVarCompensator = staticVarCompensators[j];
      ASSERT_EQ(staticVarCompensator->getRegulationMode(), StaticVarCompensatorInterface::STANDBY);
    }

    ASSERT_EQ(voltageLevel->getDanglingLines().size(), 1);
    ASSERT_EQ(voltageLevel->getLoads().size(), 1);
    ASSERT_EQ(voltageLevel->getGenerators().size(), 1);
    ASSERT_EQ(voltageLevel->getSwitches().size(), 0);
    ASSERT_EQ(voltageLevel->getLccConverters().size(), 2);
    ASSERT_EQ(voltageLevel->getVscConverters().size(), 2);
  }
  const std::vector< shared_ptr<TwoWTransformerInterface> >& twoWTransformers = network->getTwoWTransformers();
  ASSERT_EQ(twoWTransformers.size(), 1);
  for (std::size_t i = 0, iEnd = twoWTransformers.size(); i < iEnd; ++i) {
    shared_ptr<TwoWTransformerInterface> twoWTransformer = twoWTransformers[i];
    ASSERT_TRUE(twoWTransformer->isConnected());
    ASSERT_TRUE(twoWTransformer->isPartiallyConnected());
    shared_ptr<PhaseTapChangerInterface> phaseTapChanger = twoWTransformer->getPhaseTapChanger();
    ASSERT_EQ(phaseTapChanger->getCurrentPosition(), 2);
    ASSERT_DOUBLE_EQUALS_DYNAWO(phaseTapChanger->getTargetDeadBand(), 0.);
    shared_ptr<RatioTapChangerInterface> ratioTapChanger = twoWTransformer->getRatioTapChanger();
    ASSERT_EQ(ratioTapChanger->getCurrentPosition(), 1);  // Not set
    ASSERT_DOUBLE_EQUALS_DYNAWO(ratioTapChanger->getTargetDeadBand(), 0.);
  }

  ASSERT_EQ(network->getLines().size(), 1);
}

static void
testexportStateVariables(shared_ptr<DataInterface> data) {
  shared_ptr<SubModel> modelNetwork = initializeModelNetwork(data);
  ModelMulti mm;
  mm.addSubModel(modelNetwork, "MyLib");
  mm.initBuffers();
  mm.init(0.0);
  data->getStateVariableReference();
  data->exportStateVariables();
}

TEST(DataInterfaceTest, testStateVariableShuntCompensator) {
  const NetworkProperty properties = {
      true /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensatorStandByAutomatonExt*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateGeneratorWithActivePowerControlExt*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  ASSERT_NO_THROW(testexportStateVariables(data));
}

TEST(DataInterfaceTest, testStateVariableStaticVarCompensatorStandByAutomatonExt) {
  const NetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      true /*instantiateStaticVarCompensatorStandByAutomatonExt*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateGeneratorWithActivePowerControlExt*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  ASSERT_NO_THROW(testexportStateVariables(data));
  shared_ptr<NetworkInterface> network = data->getNetwork();
  const std::vector< shared_ptr<VoltageLevelInterface> >& voltageLevels = network->getVoltageLevels();
  for (std::size_t i = 0, iEnd = voltageLevels.size(); i < iEnd; ++i) {
    for (std::size_t g =0, gEnd = voltageLevels[i]->getStaticVarCompensators().size(); g < gEnd; ++g) {
      ASSERT_FALSE(voltageLevels[i]->getStaticVarCompensators()[g]->hasVoltagePerReactivePowerControl());
      ASSERT_DOUBLE_EQUALS_DYNAWO(voltageLevels[i]->getStaticVarCompensators()[g]->getSlope(), 0.);
    }
  }
}

TEST(DataInterfaceTest, testStateVariableStaticVarCompensator) {
  const NetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensatorStandByAutomatonExt*/,
      true /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateGeneratorWithActivePowerControlExt*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  ASSERT_NO_THROW(testexportStateVariables(data));
  shared_ptr<NetworkInterface> network = data->getNetwork();
  const std::vector< shared_ptr<VoltageLevelInterface> >& voltageLevels = network->getVoltageLevels();
  for (std::size_t i = 0, iEnd = voltageLevels.size(); i < iEnd; ++i) {
    for (std::size_t g =0, gEnd = voltageLevels[i]->getStaticVarCompensators().size(); g < gEnd; ++g) {
      ASSERT_FALSE(voltageLevels[i]->getStaticVarCompensators()[g]->hasStandbyAutomaton());
      ASSERT_EQ(voltageLevels[i]->getStaticVarCompensators()[g]->getRegulationMode(), StaticVarCompensatorInterface::RUNNING_V);
    }
  }
}

TEST(DataInterfaceTest, testStateVariableTwoWTransformerWithPhaseTapChanger) {
  const NetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensatorStandByAutomatonExt*/,
      false /*instantiateStaticVarCompensator*/,
      true /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      true /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateGeneratorWithActivePowerControlExt*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  ASSERT_NO_THROW(testexportStateVariables(data));
}

TEST(DataInterfaceTest, testStateVariableTwoWTransformerWithRatioTapChanger) {
  const NetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensatorStandByAutomatonExt*/,
      false /*instantiateStaticVarCompensator*/,
      true /*instantiateTwoWindingTransformer*/,
      true /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateGeneratorWithActivePowerControlExt*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  ASSERT_NO_THROW(testexportStateVariables(data));
}

TEST(DataInterfaceTest, testStateVariableTwoWTransformerWithRatioTapChangerAndPhaseTapChanger) {
  const NetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensatorStandByAutomatonExt*/,
      false /*instantiateStaticVarCompensator*/,
      true /*instantiateTwoWindingTransformer*/,
      true /*instantiateRatioTapChanger*/,
      true /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateGeneratorWithActivePowerControlExt*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  ASSERT_NO_THROW(testexportStateVariables(data));
}

TEST(DataInterfaceTest, testStateVariableDanglingLine) {
  const NetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensatorStandByAutomatonExt*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      true /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateGeneratorWithActivePowerControlExt*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  ASSERT_NO_THROW(testexportStateVariables(data));
}

TEST(DataInterfaceTest, testStateVariableGenerator) {
  const NetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensatorStandByAutomatonExt*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      true /*instantiateGenerator*/,
      false /*instantiateGeneratorWithActivePowerControlExt*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  ASSERT_NO_THROW(testexportStateVariables(data));
  shared_ptr<NetworkInterface> network = data->getNetwork();
  const std::vector< shared_ptr<VoltageLevelInterface> >& voltageLevels = network->getVoltageLevels();
  for (std::size_t i = 0, iEnd = voltageLevels.size(); i < iEnd; ++i) {
    for (std::size_t g =0, gEnd = voltageLevels[i]->getGenerators().size(); g < gEnd; ++g) {
      ASSERT_FALSE(voltageLevels[i]->getGenerators()[g]->isParticipating());
      ASSERT_FALSE(voltageLevels[i]->getGenerators()[g]->hasActivePowerControl());
      ASSERT_DOUBLE_EQUALS_DYNAWO(voltageLevels[i]->getGenerators()[g]->getActivePowerControlDroop(), 0.);
      ASSERT_FALSE(voltageLevels[i]->getGenerators()[g]->hasCoordinatedReactiveControl());
      ASSERT_DOUBLE_EQUALS_DYNAWO(voltageLevels[i]->getGenerators()[g]->getCoordinatedReactiveControlPercentage(), 0.);
    }
  }
}

TEST(DataInterfaceTest, testStateVariableGeneratorWithActivePowerControlExt) {
  const NetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensatorStandByAutomatonExt*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      true /*instantiateGeneratorWithActivePowerControlExt*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  ASSERT_NO_THROW(testexportStateVariables(data));
  shared_ptr<NetworkInterface> network = data->getNetwork();
  const std::vector< shared_ptr<VoltageLevelInterface> >& voltageLevels = network->getVoltageLevels();
  for (std::size_t i = 0, iEnd = voltageLevels.size(); i < iEnd; ++i) {
    for (std::size_t g =0, gEnd = voltageLevels[i]->getGenerators().size(); g < gEnd; ++g) {
      ASSERT_TRUE(voltageLevels[i]->getGenerators()[g]->isParticipating());
      ASSERT_TRUE(voltageLevels[i]->getGenerators()[g]->hasActivePowerControl());
      ASSERT_DOUBLE_EQUALS_DYNAWO(voltageLevels[i]->getGenerators()[g]->getActivePowerControlDroop(), 4.);
      ASSERT_FALSE(voltageLevels[i]->getGenerators()[g]->hasCoordinatedReactiveControl());
      ASSERT_DOUBLE_EQUALS_DYNAWO(voltageLevels[i]->getGenerators()[g]->getCoordinatedReactiveControlPercentage(), 0.);
    }
  }
}

TEST(DataInterfaceTest, testStateVariableLccConverter) {
  const NetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensatorStandByAutomatonExt*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateGeneratorWithActivePowerControlExt*/,
      true /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  ASSERT_NO_THROW(testexportStateVariables(data));
}

TEST(DataInterfaceTest, testStateVariableLine) {
  const NetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensatorStandByAutomatonExt*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateGeneratorWithActivePowerControlExt*/,
      false /*instantiateLccConverter*/,
      true /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  ASSERT_NO_THROW(testexportStateVariables(data));
}

TEST(DataInterfaceTest, testStateVariableLoad) {
  const NetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensatorStandByAutomatonExt*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateGeneratorWithActivePowerControlExt*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      true /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  ASSERT_NO_THROW(testexportStateVariables(data));
}

TEST(DataInterfaceTest, testStateVariableSwitch) {
  const NetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensatorStandByAutomatonExt*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateGeneratorWithActivePowerControlExt*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      true /*instantiateSwitch*/,
      false /*instantiateVscConverter*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  ASSERT_NO_THROW(testexportStateVariables(data));
}

TEST(DataInterfaceTest, testStateVariableSwitchWithSameExtremities) {
  IIDM::builders::NetworkBuilder nb;
  boost::shared_ptr<IIDM::Network> network = boost::make_shared<IIDM::Network>(nb.build("MyNetwork"));
  IIDM::connection_status_t cs = {true /*connected*/};
  IIDM::Port p1("MyBus", cs), p2("MyBus", cs);
  IIDM::Connection c1("MyVoltageLevel", p1, IIDM::side_1), c2("MyVoltageLevel", p2, IIDM::side_1);
  IIDM::builders::SubstationBuilder ssb;
  IIDM::Substation ss = ssb.build("MySubStation");
  IIDM::builders::BusBuilder bb;
  bb.v(0.5);
  bb.angle(1.);
  IIDM::Bus bus = bb.build("MyBus");
  IIDM::Bus bus2 = bb.build("MyBus2");
  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::bus_breaker);
  vlb.nominalV(5.);
  IIDM::VoltageLevel vl = vlb.build("MyVoltageLevel");
  vl.add(bus);
  vl.add(bus2);
  vl.lowVoltageLimit(0.5);
  vl.highVoltageLimit(2.);
  IIDM::builders::SwitchBuilder sb;
  IIDM::Switch s = sb.build("MySwitch");
  IIDM::Switch s2 = sb.build("MySwitchSameBus");
  vl.add(s2, "MyBus", "MyBus");
  vl.add(s, "MyBus", "MyBus2");
  ss.add(vl);
  network->add(ss);
  shared_ptr<DataInterfaceIIDM> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  ASSERT_EQ(data->getNetwork()->getVoltageLevels().at(0)->getSwitches().size(), 1);
}

TEST(DataInterfaceTest, testStateVariableVscConverter) {
  const NetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensatorStandByAutomatonExt*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateGeneratorWithActivePowerControlExt*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      true /*instantiateVscConverter*/
  };
  shared_ptr<DataInterface> data = createNetwork(properties);
  ASSERT_NO_THROW(testexportStateVariables(data));
}

}  // namespace DYN
