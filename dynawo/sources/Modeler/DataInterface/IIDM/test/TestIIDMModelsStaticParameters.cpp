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
 * @file Modeler/DataInterface/IIDM/test/TestIIDMModelsStaticParameters.cpp
 * @brief Unit tests for Static parameter classes
 *
 */


#include <IIDM/Network.h>
#include <IIDM/components/Connection.h>
#include <IIDM/components/ConnectionPoint.h>
#include <IIDM/components/TapChanger.h>
#include <IIDM/components/Battery.h>
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
#include <IIDM/builders/BatteryBuilder.h>
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

#include <boost/make_shared.hpp>

using boost::shared_ptr;

namespace DYN {

static shared_ptr<DataInterface>
createNodeBreakerNetworkIIDM() {
  IIDM::builders::NetworkBuilder nb;
  boost::shared_ptr<IIDM::Network> network = boost::make_shared<IIDM::Network>(nb.build("MyNetwork"));
  IIDM::Port p1(0), p2(0);

  IIDM::builders::SubstationBuilder ssb;
  IIDM::Substation ss = ssb.build("MySubStation");

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::node_breaker);
  vlb.nominalV(190.);
  vlb.node_count(1);
  IIDM::VoltageLevel vl = vlb.build("MyVoltageLevel");
  vl.lowVoltageLimit(120.);
  vl.highVoltageLimit(150.);

  IIDM::builders::BusBarSectionBuilder bbsb;
  bbsb.node(0);
  IIDM::BusBarSection bbs = bbsb.build("MyBusBarSection");
  bbs.v(110.);
  bbs.angle(1.5);
  vl.add(bbs);

  ss.add(vl);

  network->add(ss);

  shared_ptr<DataInterface> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  return data;
}

struct BusBreakerNetworkProperty {
  bool instantiateCapacitorShuntCompensator;
  bool instantiateStaticVarCompensator;
  bool instantiateTwoWindingTransformer;
  bool instantiateRatioTapChanger;
  bool instantiatePhaseTapChanger;
  bool instantiateDanglingLine;
  bool instantiateGenerator;
  bool instantiateLccConverter;
  bool instantiateLine;
  bool instantiateLoad;
  bool instantiateSwitch;
  bool instantiateVscConverter;
  bool instantiateThreeWindingTransformer;
  bool instantiateBattery;
};

static shared_ptr<DataInterface>
createBusBreakerNetwork(const BusBreakerNetworkProperty& properties) {
  IIDM::builders::NetworkBuilder nb;
  boost::shared_ptr<IIDM::Network> network = boost::make_shared<IIDM::Network>(nb.build("MyNetwork"));
  IIDM::connection_status_t cs = {true /*connected*/};
  IIDM::Port p1("MyBus", cs), p2("MyBus", cs), p3("MyBus", cs);
  IIDM::Connection c1("MyVoltageLevel", p1, IIDM::side_1), c2("MyVoltageLevel", p2, IIDM::side_2),
      c3("MyVoltageLevel", p3, IIDM::side_3);

  IIDM::builders::SubstationBuilder ssb;
  IIDM::Substation ss = ssb.build("MySubStation");

  IIDM::builders::BusBuilder bb;
  bb.v(150);
  bb.angle(1.5);
  IIDM::Bus bus = bb.build("MyBus");

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::bus_breaker);
  vlb.nominalV(150.);
  IIDM::VoltageLevel vl = vlb.build("MyVoltageLevel");
  vl.add(bus);

  if (properties.instantiateDanglingLine) {
    IIDM::builders::DanglingLineBuilder dlb;
    IIDM::CurrentLimits limits(200.);
    limits.add("MyLimit", 10., 5.);
    dlb.currentLimits(limits);
    dlb.r(3.);
    dlb.x(3.);
    dlb.g(3.);
    dlb.b(3.);
    dlb.p0(105.);
    dlb.p(105.);
    dlb.q0(90.);
    dlb.q(90.);
    IIDM::DanglingLine dl = dlb.build("MyDanglingLine");
    dl.connectTo("MyVoltageLevel", p1);
    vl.add(dl);
  }

  if (properties.instantiateLoad) {
    IIDM::builders::LoadBuilder lb;
    lb.p0(105.);
    lb.p(105.);
    lb.q0(90.);
    lb.q(90.);
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
    IIDM::MinMaxReactiveLimits limits(1., 20.);
    gb.minMaxReactiveLimits(limits);
    gb.targetP(-105.);
    gb.pmin(-150.);
    gb.pmax(200.);
    gb.energySource(IIDM::Generator::source_nuclear);
    IIDM::Generator g = gb.build("MyGenerator");
    g.p(-105.);
    g.q(-90.);
    g.targetQ(-90.);
    g.targetV(150.);
    g.connectTo("MyVoltageLevel", p1);
    vl.add(g);
  }

  if (properties.instantiateBattery) {
    IIDM::builders::BatteryBuilder gb;
    IIDM::MinMaxReactiveLimits limits(1., 20.);
    gb.minMaxReactiveLimits(limits);
    gb.pmin(-150.);
    gb.pmax(200.);
    IIDM::Battery g = gb.build("MyBattery");
    g.p(-105.);
    g.q(-90.);
    g.connectTo("MyVoltageLevel", p1);
    vl.add(g);
  }

  if (properties.instantiateVscConverter) {
    IIDM::builders::VscConverterStationBuilder vsccb;
    vsccb.p(150.);
    vsccb.q(90.);
    vsccb.reactivePowerSetpoint(10.);
    vsccb.voltageSetpoint(225.);
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
    lcsb.p(105.);
    lcsb.q(90.);
    lcsb.powerFactor(2.);
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
    scb.q(90.);
    scb.section_max(20);
    scb.b_per_section(2.);
    scb.p(105.);
    scb.q(90.);
    IIDM::ShuntCompensator sc = scb.build("MyCapacitorShuntCompensator");
    sc.currentSection(8);
    vl.add(sc, c1);
  }

  if (properties.instantiateStaticVarCompensator) {
    IIDM::builders::StaticVarCompensatorBuilder svcb;
    svcb.regulationMode(IIDM::StaticVarCompensator::regulation_reactive_power);
    svcb.bmin(1.0);
    svcb.bmax(10.0);
    svcb.p(5.);
    svcb.q(90.);
    IIDM::StaticVarCompensator svc = svcb.build("MyStaticVarCompensator");
    IIDM::extensions::standbyautomaton::StandbyAutomatonBuilder sbab;
    sbab.standBy(true);
    svc.setExtension(sbab.build());
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

  if (properties.instantiateThreeWindingTransformer) {
    IIDM::builders::Transformer3WindingsBuilder t3Wb;
    IIDM::CurrentLimits limits(200.);
    limits.add("MyLimit", 10., 5.);
    IIDM::CurrentLimits limits2(200.);
    limits2.add("MyLimit2", 20., 5.);
    t3Wb.currentLimits1(limits);
    t3Wb.currentLimits2(limits);
    t3Wb.currentLimits3(limits2);
    IIDM::Transformer3Windings t3W = t3Wb.build("MyTransformer3Winding");
    ss.add(t3W, c1, c2, c3);
  }


  network->add(ss);

  if (properties.instantiateLine) {
    IIDM::CurrentLimits limits(200.);
    limits.add("MyLimit", 10., 5.);
    IIDM::CurrentLimits limits2(200.);
    limits2.add("MyLimit2", 20., 5.);
    IIDM::builders::LineBuilder lb;
    lb.currentLimits1(limits);
    lb.currentLimits2(limits2);
    lb.p1(105.);
    lb.q1(190.);
    lb.p2(150.);
    lb.q2(80.);
    IIDM::Line dl = lb.build("MyLine");
    network->add(dl, c1, c2);
  }

  shared_ptr<DataInterface> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  return data;
}

static shared_ptr<SubModel>
initializeModel(shared_ptr<DataInterface> data) {
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
  if (!data->getNetwork()->getTwoWTransformers().empty() && data->getNetwork()->getTwoWTransformers()[0]->getRatioTapChanger()) {
    parametersSet->createParameter("transformer_t1st_THT", 9.);
    parametersSet->createParameter("transformer_tNext_THT", 10.);
    parametersSet->createParameter("transformer_t1st_HT", 11.);
    parametersSet->createParameter("transformer_tNext_HT", 12.);
    parametersSet->createParameter("transformer_tolV", 13.);
  }
  modelNetwork->setPARParameters(parametersSet);

  return modelNetwork;
}

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

TEST(DataInterfaceIIDMTest, testNodeBreakerBusIIDMAndStaticParameters) {
  shared_ptr<DataInterface> data = createNodeBreakerNetworkIIDM();
  exportStateVariables(data);

  ASSERT_EQ(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_0", "U"), 110.);
  ASSERT_EQ(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_0", "Theta"), 1.5);
  ASSERT_EQ(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_0", "Upu"), 110./190.);
  ASSERT_EQ(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_0", "Theta_pu"), 1.5 * M_PI / 180);
}

TEST(DataInterfaceIIDMTest, testBusIIDMStaticParameters) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterface> data = createBusBreakerNetwork(properties);
  exportStateVariables(data);

  ASSERT_EQ(data->getStaticParameterDoubleValue("MyBus", "U"), 150.);
  ASSERT_EQ(data->getStaticParameterDoubleValue("MyBus", "Theta"), 1.5);
  ASSERT_EQ(data->getStaticParameterDoubleValue("MyBus", "Upu"), 1.);
  ASSERT_EQ(data->getStaticParameterDoubleValue("MyBus", "Theta_pu"), 1.5 * M_PI / 180);
}


TEST(DataInterfaceIIDMTest, testDanglingLineIIDMAndStaticParameters) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      true /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterface> data = createBusBreakerNetwork(properties);
  exportStateVariables(data);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyDanglingLine", "p_pu"), 1.05);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyDanglingLine", "q_pu"), 0.9);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyDanglingLine", "p"), 105);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyDanglingLine", "q"), 90);
}

TEST(DataInterfaceIIDMTest, testGeneratorIIDMAndStaticParameters) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      true /*instantiateGenerator*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterface> data = createBusBreakerNetwork(properties);
  exportStateVariables(data);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "p_pu"), -105. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "q_pu"), -90. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "p"), -105.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "q"), -90.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "v_pu"), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "angle_pu"), 0.02617993877991494148);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "uc_pu"), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "v"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "uc"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "angle"), 1.5);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "pMin"), -150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "pMax"), 200.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "pMin_pu"), -150. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "pMax_pu"), 200. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "qMax"), 20);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "qMax_pu"), 20. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "qMin"), 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "qMin_pu"), 1. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "sNom"), sqrt(20 * 20 + 200 * 200));
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "vNom"), 150);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "targetV"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "targetV_pu"), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "targetP_pu"), 105. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "targetP"), 105.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "targetQ_pu"), 90. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyGenerator", "targetQ"), 90.);
}

TEST(DataInterfaceIIDMTest, testBatteryIIDMAndStaticParameters) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/,
      false /*instantiateThreeWindingTransformer*/,
      true /*instantiateBattery*/
  };
  shared_ptr<DataInterface> data = createBusBreakerNetwork(properties);
  exportStateVariables(data);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "p_pu"), -105. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "q_pu"), -90. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "p"), -105.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "q"), -90.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "v_pu"), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "angle_pu"), 0.02617993877991494148);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "uc_pu"), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "v"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "uc"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "angle"), 1.5);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "pMin"), -150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "pMax"), 200.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "pMin_pu"), -150. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "pMax_pu"), 200. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "qMax"), 20);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "qMax_pu"), 20. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "qMin"), 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "qMin_pu"), 1. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "sNom"), sqrt(20 * 20 + 200 * 200));
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "vNom"), 150);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "targetV"), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "targetV_pu"), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "targetP_pu"), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "targetP"), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "targetQ_pu"), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBattery", "targetQ"), 0.);
}


TEST(DataInterfaceIIDMTest, testHvdcLineIIDMAndStaticParameters) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      true /*instantiateVscConverter*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterface> data = createBusBreakerNetwork(properties);
  exportStateVariables(data);
}

TEST(DataInterfaceIIDMTest, testLccConverterIIDMAndStaticParameters) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      true /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterface> data = createBusBreakerNetwork(properties);
  exportStateVariables(data);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter", "p_pu"), -105. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter", "q_pu"), -90. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter", "p"), -105.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter", "q"), -90.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter", "v_pu"), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter", "angle_pu"), 0.02617993877991494148);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter", "v"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter", "angle"), 1.5);
}

TEST(DataInterfaceIIDMTest, testVscConverterIIDMAndStaticParameters) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      true /*instantiateVscConverter*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterface> data = createBusBreakerNetwork(properties);
  exportStateVariables(data);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverterStation", "p_pu"), -150. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverterStation", "q_pu"), -90. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverterStation", "qMax_pu"), 2. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverterStation", "targetQ_pu"), -10. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverterStation", "targetV_pu"), 225. / 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverterStation", "p"), -150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverterStation", "q"), -90.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverterStation", "qMax"), 2.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverterStation", "targetQ"), -10.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverterStation", "targetV"), 225.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverterStation", "v_pu"), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverterStation", "angle_pu"), 0.02617993877991494148);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverterStation", "v"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverterStation", "angle"), 1.5);
}

TEST(DataInterfaceIIDMTest, testLineIIDMAndStaticParameters) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverter*/,
      true /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterface> data = createBusBreakerNetwork(properties);
  exportStateVariables(data);

  ASSERT_THROW_DYNAWO(data->getStaticParameterDoubleValue("MyLine", "p_pu"), Error::MODELER, KeyError_t::UnknownStaticParameter);
}

TEST(DataInterfaceIIDMTest, testLoadIIDMAndStaticParameters) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      true /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterface> data = createBusBreakerNetwork(properties);
  exportStateVariables(data);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLoad", "p_pu"), 105. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLoad", "p0_pu"), 105. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLoad", "q_pu"), 90. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLoad", "q0_pu"), 90. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLoad", "p"), 105.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLoad", "p0"), 105.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLoad", "q"), 90.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLoad", "q0"), 90.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLoad", "v_pu"), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLoad", "angle_pu"), 0.02617993877991494148);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLoad", "v"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLoad", "angle"), 1.5);
}

TEST(DataInterfaceIIDMTest, testShuntCompensatorIIDMAndStaticParameters) {
  const BusBreakerNetworkProperty properties = {
      true /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterface> data = createBusBreakerNetwork(properties);
  exportStateVariables(data);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyCapacitorShuntCompensator", "q_pu"), -360000. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyCapacitorShuntCompensator", "q"), -360000.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterBoolValue("MyCapacitorShuntCompensator", "isCapacitor"), 1.);
}

TEST(DataInterfaceIIDMTest, testStaticVarCompensatorIIDMAndStaticParameters) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      true /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterface> data = createBusBreakerNetwork(properties);
  exportStateVariables(data);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyStaticVarCompensator", "p"), 5.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyStaticVarCompensator", "q"), 90.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterIntValue("MyStaticVarCompensator", "regulatingMode"), 2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyStaticVarCompensator", "v"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyStaticVarCompensator", "angle"), 1.5);
}

TEST(DataInterfaceIIDMTest, testSwitchIIDMAndStaticParameters) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      true /*instantiateSwitch*/,
      false /*instantiateVscConverter*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterface> data = createBusBreakerNetwork(properties);
  exportStateVariables(data);
}

TEST(DataInterfaceIIDMTest, testThreeWindingTransformerIIDMAndStaticParameters) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/,
      true /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterface> data = createBusBreakerNetwork(properties);
  exportStateVariables(data);
}

TEST(DataInterfaceIIDMTest, testBadlyFormedStaticRefModel) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      true /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterface> data = createBusBreakerNetwork(properties);
  exportStateVariables(data);

  boost::shared_ptr<LoadInterface> loadItf = data->getNetwork()->getVoltageLevels()[0]->getLoads()[0];
  ASSERT_FALSE(loadItf->isFictitious());
  ASSERT_NO_THROW(data->setReference("p", "MyLoad", "MyLoad", "P_value"));
  ASSERT_THROW_DYNAWO(data->setReference("badParam", loadItf->getID(), "MyLoad", "p_pu"), Error::MODELER, KeyError_t::UnknownStateVariable);
  ASSERT_THROW_DYNAWO(data->setReference("p", "", "MyLoad", "p_pu"), Error::MODELER, KeyError_t::WrongReferenceId);
  ASSERT_NO_THROW(data->setReference("p", "MyLoad", "MyLoad", "myBadModelVar"));
  ASSERT_THROW_DYNAWO(data->getStateVariableReference(), Error::MODELER, KeyError_t::StateVariableNoReference);
  const bool filterForCriteriaCheck = false;

  // Reset
  data = createBusBreakerNetwork(properties);
  exportStateVariables(data);
  loadItf = data->getNetwork()->getVoltageLevels()[0]->getLoads()[0];
  ASSERT_NO_THROW(data->setReference("p", "MyLoad", "MyBadLoad", "p_pu"));
  ASSERT_THROW_DYNAWO(data->getStateVariableReference(), Error::MODELER, KeyError_t::StateVariableNoReference);
  ASSERT_NO_THROW(data->updateFromModel(filterForCriteriaCheck));

  // Reset
  data = createBusBreakerNetwork(properties);
  exportStateVariables(data);
  loadItf = data->getNetwork()->getVoltageLevels()[0]->getLoads()[0];
  ASSERT_THROW_DYNAWO(data->setReference("p", "MyBadLoad", "MyLoad", "p_pu"), Error::MODELER, KeyError_t::UnknownStaticComponent);
}

TEST(DataInterfaceIIDMTest, testBadlyFormedRegulatingRatioTapChangerNoTargetV) {
  IIDM::builders::NetworkBuilder nb;
  boost::shared_ptr<IIDM::Network> network = boost::make_shared<IIDM::Network>(nb.build("MyNetwork"));
  IIDM::connection_status_t cs = {true /*connected*/};
  IIDM::Port p1("MyBus", cs), p2("MyBus", cs), p3("MyBus", cs);
  IIDM::Connection c1("MyVoltageLevel", p1, IIDM::side_1), c2("MyVoltageLevel", p2, IIDM::side_2),
      c3("MyVoltageLevel", p3, IIDM::side_3);

  IIDM::builders::SubstationBuilder ssb;
  IIDM::Substation ss = ssb.build("MySubStation");

  IIDM::builders::BusBuilder bb;
  bb.v(150);
  bb.angle(1.5);
  IIDM::Bus bus = bb.build("MyBus");

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::bus_breaker);
  vlb.nominalV(150.);
  IIDM::VoltageLevel vl = vlb.build("MyVoltageLevel");
  vl.add(bus);
  ss.add(vl);

  IIDM::builders::Transformer2WindingsBuilder t2Wb;
  IIDM::Transformer2Windings t2W = t2Wb.build("MyTransformer2Winding");
  IIDM::RatioTapChanger rtp(0, 0, true);
  rtp.regulating(true);
  IIDM::TerminalReference tr("MyTerminalRef", IIDM::side_1);
  rtp.terminalReference(tr);
  t2W.ratioTapChanger(rtp);
  ss.add(t2W, c1, c2);
  network->add(ss);

  shared_ptr<DataInterface> data;
  DataInterfaceIIDM ptr(network);
  ASSERT_THROW_DYNAWO(ptr.initFromIIDM(), Error::STATIC_DATA, KeyError_t::MissingTargetVInRatioTapChanger);
}

TEST(DataInterfaceIIDMTest, testBadlyFormedRegulatingRatioTapChangerNoTerminalRef) {
  IIDM::builders::NetworkBuilder nb;
  boost::shared_ptr<IIDM::Network> network = boost::make_shared<IIDM::Network>(nb.build("MyNetwork"));
  IIDM::connection_status_t cs = {true /*connected*/};
  IIDM::Port p1("MyBus", cs), p2("MyBus", cs), p3("MyBus", cs);
  IIDM::Connection c1("MyVoltageLevel", p1, IIDM::side_1), c2("MyVoltageLevel", p2, IIDM::side_2),
      c3("MyVoltageLevel", p3, IIDM::side_3);

  IIDM::builders::SubstationBuilder ssb;
  IIDM::Substation ss = ssb.build("MySubStation");

  IIDM::builders::BusBuilder bb;
  bb.v(150);
  bb.angle(1.5);
  IIDM::Bus bus = bb.build("MyBus");

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::bus_breaker);
  vlb.nominalV(150.);
  IIDM::VoltageLevel vl = vlb.build("MyVoltageLevel");
  vl.add(bus);
  ss.add(vl);

  IIDM::builders::Transformer2WindingsBuilder t2Wb;
  IIDM::Transformer2Windings t2W = t2Wb.build("MyTransformer2Winding");
  IIDM::RatioTapChanger rtp(0, 0, true);
  rtp.regulating(true);
  rtp.targetV(20.);
  t2W.ratioTapChanger(rtp);
  ss.add(t2W, c1, c2);
  network->add(ss);

  shared_ptr<DataInterface> data;
  DataInterfaceIIDM ptr(network);
  ASSERT_THROW_DYNAWO(ptr.initFromIIDM(), Error::STATIC_DATA, KeyError_t::MissingTerminalRefInRatioTapChanger);
}

TEST(DataInterfaceIIDMTest, testBadlyFormedRegulatingRatioTapChangerNoTerminalRefSide) {
  IIDM::builders::NetworkBuilder nb;
  boost::shared_ptr<IIDM::Network> network = boost::make_shared<IIDM::Network>(nb.build("MyNetwork"));
  IIDM::connection_status_t cs = {true /*connected*/};
  IIDM::Port p1("MyBus", cs), p2("MyBus", cs), p3("MyBus", cs);
  IIDM::Connection c1("MyVoltageLevel", p1, IIDM::side_1), c2("MyVoltageLevel", p2, IIDM::side_2),
      c3("MyVoltageLevel", p3, IIDM::side_3);

  IIDM::builders::SubstationBuilder ssb;
  IIDM::Substation ss = ssb.build("MySubStation");

  IIDM::builders::BusBuilder bb;
  bb.v(150);
  bb.angle(1.5);
  IIDM::Bus bus = bb.build("MyBus");

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::bus_breaker);
  vlb.nominalV(150.);
  IIDM::VoltageLevel vl = vlb.build("MyVoltageLevel");
  vl.add(bus);
  ss.add(vl);

  IIDM::builders::Transformer2WindingsBuilder t2Wb;
  IIDM::Transformer2Windings t2W = t2Wb.build("MyTransformer2Winding");
  IIDM::RatioTapChanger rtp(0, 0, true);
  rtp.regulating(true);
  rtp.targetV(20.);
  IIDM::TerminalReference tr("MyTerminalRef");
  rtp.terminalReference(tr);
  t2W.ratioTapChanger(rtp);
  ss.add(t2W, c1, c2);
  network->add(ss);

  shared_ptr<DataInterface> data;
  DataInterfaceIIDM ptr(network);
  ASSERT_THROW_DYNAWO(ptr.initFromIIDM(), Error::STATIC_DATA, KeyError_t::MissingTerminalRefSideInRatioTapChanger);
}

TEST(DataInterfaceIIDMTest, testRegulatingRatioTapChanger) {
  IIDM::builders::NetworkBuilder nb;
  boost::shared_ptr<IIDM::Network> network = boost::make_shared<IIDM::Network>(nb.build("MyNetwork"));
  IIDM::connection_status_t cs = {true /*connected*/};
  IIDM::Port p1("MyBus", cs), p2("MyBus", cs), p3("MyBus", cs);
  IIDM::Connection c1("MyVoltageLevel", p1, IIDM::side_1), c2("MyVoltageLevel", p2, IIDM::side_2),
      c3("MyVoltageLevel", p3, IIDM::side_3);

  IIDM::builders::SubstationBuilder ssb;
  IIDM::Substation ss = ssb.build("MySubStation");

  IIDM::builders::BusBuilder bb;
  bb.v(150);
  bb.angle(1.5);
  IIDM::Bus bus = bb.build("MyBus");

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::bus_breaker);
  vlb.nominalV(150.);
  IIDM::VoltageLevel vl = vlb.build("MyVoltageLevel");
  vl.add(bus);
  ss.add(vl);

  IIDM::builders::Transformer2WindingsBuilder t2Wb;
  IIDM::Transformer2Windings t2W = t2Wb.build("MyTransformer2Winding");
  IIDM::RatioTapChanger rtp(0, 0, true);
  rtp.regulating(true);
  rtp.targetV(20.);
  IIDM::TerminalReference tr("MyTerminalRef", IIDM::side_1);
  rtp.terminalReference(tr);
  t2W.ratioTapChanger(rtp);
  ss.add(t2W, c1, c2);
  network->add(ss);

  shared_ptr<DataInterface> data;
  DataInterfaceIIDM ptr(network);
  ASSERT_NO_THROW(ptr.initFromIIDM());
}

}  // namespace DYN
