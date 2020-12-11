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
 * @file Modeler/DataInterface/PowSyblIIDM/test/TestIIDMModels.cpp
 * @brief Unit tests for DataInterfaceIIDM class
 *
 */


#include "gtest_dynawo.h"
#include "DYNDataInterfaceIIDM.h"
#include "DYNBusInterfaceIIDM.h"
#include "DYNDanglingLineInterfaceIIDM.h"
#include "DYNHvdcLineInterfaceIIDM.h"
#include "DYNLccConverterInterfaceIIDM.h"
#include "DYNVscConverterInterfaceIIDM.h"
#include "DYNLineInterfaceIIDM.h"
#include "DYNLoadInterfaceIIDM.h"
#include "DYNGeneratorInterfaceIIDM.h"
#include "DYNShuntCompensatorInterfaceIIDM.h"
#include "DYNStaticVarCompensatorInterfaceIIDM.h"
#include "DYNSwitchInterfaceIIDM.h"
#include "DYNTwoWTransformerInterfaceIIDM.h"
#include "DYNSubModelFactory.h"
#include "DYNSubModel.h"
#include "DYNModelMulti.h"
#include "DYNNetworkInterface.h"
#include "DYNThreeWTransformerInterfaceIIDM.h"
#include "DYNModelConstants.h"
#include "DYNVoltageLevelInterfaceIIDM.h"

#include <powsybl/iidm/Network.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/SubstationAdder.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>
#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Load.hpp>
#include <powsybl/iidm/LoadAdder.hpp>
#include <powsybl/iidm/Switch.hpp>
#include <powsybl/iidm/Line.hpp>
#include <powsybl/iidm/LineAdder.hpp>
#include <powsybl/iidm/TwoWindingsTransformerAdder.hpp>
#include <powsybl/iidm/RatioTapChangerAdder.hpp>
#include <powsybl/iidm/PhaseTapChangerAdder.hpp>
#include <powsybl/iidm/ThreeWindingsTransformerAdder.hpp>
#include <powsybl/iidm/DanglingLine.hpp>
#include <powsybl/iidm/DanglingLineAdder.hpp>
#include <powsybl/iidm/VscConverterStation.hpp>
#include <powsybl/iidm/VscConverterStationAdder.hpp>
#include <powsybl/iidm/HvdcLine.hpp>
#include <powsybl/iidm/HvdcLineAdder.hpp>
#include <powsybl/iidm/LccConverterStation.hpp>
#include <powsybl/iidm/LccConverterStationAdder.hpp>
#include <powsybl/iidm/ShuntCompensator.hpp>
#include <powsybl/iidm/ShuntCompensatorAdder.hpp>
#include <powsybl/iidm/GeneratorAdder.hpp>
#include <powsybl/iidm/StaticVarCompensator.hpp>
#include <powsybl/iidm/StaticVarCompensatorAdder.hpp>

using boost::shared_ptr;

namespace DYN {

shared_ptr<DataInterfaceIIDM>
createDataItfFromNetwork(powsybl::iidm::Network&& network) {
  shared_ptr<DataInterfaceIIDM> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(std::forward<powsybl::iidm::Network>(network));
  ptr->initFromIIDM();
  data.reset(ptr);
  return data;
}

powsybl::iidm::Network
createNodeBreakerNetworkIIDM() {
  powsybl::iidm::Network network("MyNetwork", "MyNetwork");

  powsybl::iidm::Substation& substation = network.newSubstation()
                                     .setId("MySubStation")
                                     .setName("MySubStation_NAME")
                                     .setTso("TSO")
                                     .add();

  powsybl::iidm::VoltageLevel& vl = substation.newVoltageLevel()
                                     .setId("MyVoltageLevel")
                                     .setName("MyVoltageLevel_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::NODE_BREAKER)
                                     .setNominalVoltage(190.)
                                     .setLowVoltageLimit(120.)
                                     .setHighVoltageLimit(150.)
                                     .add();
  vl.getNodeBreakerView().newBusbarSection()
      .setId("BBS")
      .setName("BBS_NAME")
      .setNode(3)
      .add();
  vl.getNodeBreakerView().newBusbarSection()
      .setId("BBS2")
      .setName("BBS2_NAME")
      .setNode(4)
      .add();
  vl.getNodeBreakerView().newBreaker()
      .setId("BK1")
      .setNode1(0)
      .setNode2(5)
      .setRetained(true)
      .setOpen(true)
      .add();
  vl.getNodeBreakerView().newDisconnector()
      .setId("DC11")
      .setNode1(5)
      .setNode2(3)
      .setRetained(false)
      .setOpen(true)
      .add();
  vl.getNodeBreakerView().newDisconnector()
      .setId("DC12")
      .setNode1(5)
      .setNode2(4)
      .setRetained(false)
      .setOpen(true)
      .add();
  vl.getNodeBreakerView().newBreaker()
      .setId("BK2")
      .setNode1(1)
      .setNode2(6)
      .setRetained(true)
      .setOpen(false)
      .add();
  vl.getNodeBreakerView().newDisconnector()
      .setId("DC21")
      .setNode1(6)
      .setNode2(3)
      .setRetained(false)
      .setOpen(true)
      .add();
  vl.getNodeBreakerView().newDisconnector()
      .setId("DC22")
      .setNode1(6)
      .setNode2(4)
      .setRetained(false)
      .setOpen(false)
      .add();
  vl.getNodeBreakerView().newBreaker()
      .setId("BK3")
      .setNode1(2)
      .setNode2(7)
      .setRetained(true)
      .setOpen(true)
      .add();
  vl.getNodeBreakerView().newDisconnector()
      .setId("DC31")
      .setNode1(7)
      .setNode2(3)
      .setRetained(false)
      .setOpen(true)
      .add();
  vl.newLoad()
      .setId("MyLoad")
      .setNode(1)
      .setName("LOAD1_NAME")
      .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
      .setP0(105.0)
      .setQ0(90.0)
      .add();
  vl.newLoad()
      .setId("MyLoad2")
      .setNode(0)
      .setName("LOAD2_NAME")
      .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
      .setP0(0.0)
      .setQ0(0.0)
      .add();

  powsybl::iidm::Bus& calculatedIIDMBus3 = vl.getBusBreakerView().getBus("MyVoltageLevel_3").get();
  calculatedIIDMBus3.setV(110.);
  calculatedIIDMBus3.setAngle(1.5);

  powsybl::iidm::Bus& calculatedIIDMBus4 = vl.getBusBreakerView().getBus("MyVoltageLevel_4").get();
  calculatedIIDMBus4.setV(220.);
  calculatedIIDMBus4.setAngle(3);
  return network;
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
};

powsybl::iidm::Network
createBusBreakerNetwork(const BusBreakerNetworkProperty& properties) {
  powsybl::iidm::Network network("MyNetwork", "MyNetwork");

  powsybl::iidm::Substation& s = network.newSubstation()
      .setId("MySubStation")
      .add();

  powsybl::iidm::VoltageLevel& vl1 = s.newVoltageLevel()
      .setId("VL1")
      .setNominalVoltage(150.)
      .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
      .add();

  powsybl::iidm::Bus& iidmBus = vl1.getBusBreakerView().newBus()
      .setId("MyBus")
      .add();
  iidmBus.setV(150.);
  iidmBus.setAngle(1.5);

  vl1.getBusBreakerView().newBus().setId("VL1_BUS1").add();

  powsybl::iidm::VoltageLevel& vl2 = s.newVoltageLevel()
                                     .setId("VL2")
                                     .setName("VL2_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalVoltage(225.0)
                                     .setLowVoltageLimit(200.0)
                                     .setHighVoltageLimit(260.0)
                                     .add();

  vl2.getBusBreakerView().newBus().setId("VL2_BUS1").add();

  powsybl::iidm::VoltageLevel& vl3 = s.newVoltageLevel()
                                     .setId("VL3")
                                     .setName("VL3_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalVoltage(225.0)
                                     .setLowVoltageLimit(200.0)
                                     .setHighVoltageLimit(260.0)
                                     .add();

  vl3.getBusBreakerView().newBus().setId("VL3_BUS1").add();

  if (properties.instantiateDanglingLine) {
    powsybl::iidm::DanglingLine& dl = vl1.newDanglingLine()
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
    dl.newCurrentLimits().setPermanentLimit(200).beginTemporaryLimit().setName("TL1").setValue(10.).setAcceptableDuration(5.).endTemporaryLimit().add();
    dl.getTerminal().setP(105.);
    dl.getTerminal().setQ(90.);
  }

  if (properties.instantiateLoad) {
    powsybl::iidm::Load& load = vl1.newLoad()
        .setId("MyLoad")
        .setBus("MyBus")
        .setConnectableBus("MyBus")
        .setName("LOAD1_NAME")
        .setLoadType(powsybl::iidm::LoadType::UNDEFINED)
        .setP0(105.0)
        .setQ0(90.0)
        .add();
    load.getTerminal().setP(105.);
    load.getTerminal().setQ(90.);
  }

  if (properties.instantiateSwitch) {
    vl1.getBusBreakerView().newSwitch()
        .setId("Sw")
        .setName("SwName")
        .setFictitious(false)
        .setBus1("MyBus")
        .setBus2("VL1_BUS1")
        .add();
  }

  if (properties.instantiateGenerator) {
    powsybl::iidm:: Generator& gen = vl1.newGenerator()
        .setId("MyGenerator")
        .setName("MyGenerator_NAME")
        .setBus("MyBus")
        .setConnectableBus("MyBus")
        .setEnergySource(powsybl::iidm::EnergySource::NUCLEAR)
        .setTargetP(-105.)
        .setMaxP(200.0)
        .setMinP(-150.0)
        .setRatedS(4.0)
        .setTargetQ(-90.0)
        .setTargetV(150.0)
        .setVoltageRegulatorOn(true)
        .add();
    gen.getTerminal().setP(-105.);
    gen.getTerminal().setQ(-90.);
    gen.newMinMaxReactiveLimits().setMinQ(1.).setMaxQ(20.).add();
  }

  if (properties.instantiateVscConverter) {
    powsybl::iidm::VscConverterStation& vsc = vl1.newVscConverterStation()
        .setId("MyVscConverter")
        .setName("MyVscConverter_NAME")
        .setBus("MyBus")
        .setConnectableBus("MyBus")
        .setLossFactor(3.0)
        .setVoltageRegulatorOn(true)
        .setVoltageSetpoint(1.2)
        .setReactivePowerSetpoint(-1.5)
        .add();
    vsc.getTerminal().setP(150.);
    vsc.getTerminal().setQ(90.);

    powsybl::iidm::VscConverterStation& vsc2 = vl1.newVscConverterStation()
        .setId("MyVscConverter2")
        .setName("MyVscConverter2_NAME")
        .setBus("MyBus")
        .setConnectableBus("MyBus")
        .setLossFactor(3.0)
        .setVoltageRegulatorOn(true)
        .setVoltageSetpoint(1.2)
        .setReactivePowerSetpoint(-1.5)
        .add();
    vsc2.getTerminal().setP(150.);
    vsc2.getTerminal().setQ(90.);

    network.newHvdcLine()
        .setId("MyHvdcLine")
        .setName("MyHvdcLine_NAME")
        .setActivePowerSetpoint(111.1)
        .setConvertersMode(powsybl::iidm::HvdcLine::ConvertersMode::SIDE_1_RECTIFIER_SIDE_2_INVERTER)
        .setConverterStationId1("MyVscConverter")
        .setConverterStationId2("MyVscConverter2")
        .setMaxP(12.0)
        .setNominalVoltage(13.0)
        .setR(14.0)
        .add();
  }

  if (properties.instantiateLccConverter) {
    powsybl::iidm::LccConverterStation& lcc = vl1.newLccConverterStation()
        .setId("MyLccConverter")
        .setName("MyLccConverter_NAME")
        .setBus("MyBus")
        .setConnectableBus("MyBus")
        .setLossFactor(3.0)
        .setPowerFactor(1.)
        .add();
    lcc.getTerminal().setP(105.);
    lcc.getTerminal().setQ(90.);

    powsybl::iidm::LccConverterStation& lcc2 = vl1.newLccConverterStation()
        .setId("MyLccConverter2")
        .setName("MyLccConverter2_NAME")
        .setBus("MyBus")
        .setConnectableBus("MyBus")
        .setLossFactor(3.0)
        .setPowerFactor(1.)
        .add();
    lcc2.getTerminal().setP(105.);
    lcc2.getTerminal().setQ(90.);

    network.newHvdcLine()
        .setId("MyHvdcLine")
        .setName("MyHvdcLine_NAME")
        .setActivePowerSetpoint(111.1)
        .setConvertersMode(powsybl::iidm::HvdcLine::ConvertersMode::SIDE_1_RECTIFIER_SIDE_2_INVERTER)
        .setConverterStationId1("MyLccConverter")
        .setConverterStationId2("MyLccConverter2")
        .setMaxP(12.0)
        .setNominalVoltage(13.0)
        .setR(14.0)
        .add();
  }

  if (properties.instantiateCapacitorShuntCompensator) {
    powsybl::iidm::ShuntCompensator& shuntIIDM = vl1.newShuntCompensator()
        .setId("MyCapacitorShuntCompensator")
        .setName("MyCapacitorShuntCompensator_NAME")
        .setBus("MyBus")
        .setConnectableBus("MyBus")
        .setbPerSection(2.0)
        .setCurrentSectionCount(2UL)
        .setMaximumSectionCount(3UL)
        .add();
    shuntIIDM.getTerminal().setQ(90.);
  }

  if (properties.instantiateStaticVarCompensator) {
    powsybl::iidm::StaticVarCompensator& svc = vl1.newStaticVarCompensator()
      .setId("MyStaticVarCompensator")
      .setName("MyStaticVarCompensator_NAME")
      .setBus("MyBus")
      .setConnectableBus("MyBus")
      .setBmin(-0.01)
      .setBmax(0.02)
      .setVoltageSetpoint(380.0)
      .setReactivePowerSetpoint(80.0)
      .setRegulationMode(powsybl::iidm::StaticVarCompensator::RegulationMode::OFF)
      .add();
    svc.getTerminal().setP(5.);
    svc.getTerminal().setQ(85.);
  }

  if (properties.instantiateTwoWindingTransformer) {
    powsybl::iidm::TwoWindingsTransformer& transformer = s.newTwoWindingsTransformer()
        .setId("MyTransformer2Winding")
        .setVoltageLevel1(vl1.getId())
        .setBus1("MyBus")
        .setConnectableBus1("MyBus")
        .setVoltageLevel2(vl2.getId())
        .setBus2("VL2_BUS1")
        .setConnectableBus2("VL2_BUS1")
        .setR(3.0)
        .setX(33.0)
        .setG(1.0)
        .setB(0.2)
        .setRatedU1(2.0)
        .setRatedU2(0.4)
        .setRatedS(3.0)
        .add();
    transformer.getTerminal1().setP(100.);
    transformer.getTerminal1().setQ(110.);
    transformer.getTerminal2().setP(120.);
    transformer.getTerminal2().setQ(130.);
    if (properties.instantiateRatioTapChanger) {
      transformer.newRatioTapChanger()
          .setTapPosition(1)
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
    if (properties.instantiatePhaseTapChanger) {
      transformer.newPhaseTapChanger()
          .setTapPosition(2)
          .beginStep()
          .setAlpha(1.)
          .setR(1.)
          .setX(1.)
          .setG(1.)
          .setB(1.)
          .setRho(1.)
          .endStep()
          .beginStep()
          .setAlpha(1.)
          .setR(2.)
          .setX(1.)
          .setG(1.)
          .setB(1.)
          .setRho(1.)
          .endStep()
          .beginStep()
          .setAlpha(1.)
          .setR(3.)
          .setX(1.)
          .setG(1.)
          .setB(1.)
          .setRho(1.)
          .endStep()
          .add();
    }
  }

  if (properties.instantiateThreeWindingTransformer) {
    powsybl::iidm::ThreeWindingsTransformer& transformer = s.newThreeWindingsTransformer()
        .setId("MyTransformer3Winding")
        .setName("MyTransformer3Winding_NAME")
        .setRatedU0(3.1)
        .newLeg1()
        .setR(1.3)
        .setX(1.4)
        .setG(1.6)
        .setB(1.7)
        .setRatedU(1.1)
        .setRatedS(2.2)
        .setVoltageLevel(vl1.getId())
        .setBus("MyBus")
        .setConnectableBus("MyBus")
        .add()
        .newLeg2()
        .setR(2.3)
        .setX(2.4)
        .setG(0.0)
        .setB(0.0)
        .setRatedU(2.1)
        .setVoltageLevel(vl2.getId())
        .setBus("VL2_BUS1")
        .setConnectableBus("VL2_BUS1")
        .add()
        .newLeg3()
        .setR(3.3)
        .setX(3.4)
        .setG(0.0)
        .setB(0.0)
        .setRatedU(3.1)
        .setVoltageLevel(vl3.getId())
        .setBus("VL3_BUS1")
        .setConnectableBus("VL3_BUS1")
        .add()
        .add();
    transformer.getLeg1().newCurrentLimits().setPermanentLimit(200).beginTemporaryLimit().
        setName("TL1").setValue(10.).setAcceptableDuration(5.).endTemporaryLimit().add();
    transformer.getLeg2().newCurrentLimits().setPermanentLimit(200).beginTemporaryLimit().
        setName("TL1").setValue(10.).setAcceptableDuration(5.).endTemporaryLimit().add();
    transformer.getLeg3().newCurrentLimits().setPermanentLimit(200).beginTemporaryLimit().
        setName("TL1").setValue(20.).setAcceptableDuration(5.).endTemporaryLimit().add();
    if (properties.instantiateRatioTapChanger) {
      transformer.getLeg1().newRatioTapChanger()
          .setTapPosition(1)
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
    if (properties.instantiatePhaseTapChanger) {
      transformer.getLeg2().newPhaseTapChanger()
          .setTapPosition(1)
          .setLowTapPosition(1)
          .beginStep()
          .setAlpha(1.)
          .setR(1.)
          .setX(1.)
          .setG(1.)
          .setB(1.)
          .setRho(1.)
          .endStep()
          .beginStep()
          .setAlpha(1.)
          .setR(2.)
          .setX(1.)
          .setG(1.)
          .setB(1.)
          .setRho(1.)
          .endStep()
          .beginStep()
          .setAlpha(1.)
          .setR(3.)
          .setX(1.)
          .setG(1.)
          .setB(1.)
          .setRho(1.)
          .endStep()
          .add();
    }
  }

  if (properties.instantiateLine) {
    powsybl::iidm::Line& line = network.newLine()
                                      .setId("VL1_VL2")
                                      .setName("VL1_VL2_NAME")
                                      .setVoltageLevel1(vl1.getId())
                                      .setBus1("MyBus")
                                      .setConnectableBus1("MyBus")
                                      .setVoltageLevel2(vl2.getId())
                                      .setBus2("VL2_BUS1")
                                      .setConnectableBus2("VL2_BUS1")
                                      .setR(3.0)
                                      .setX(33.33)
                                      .setG1(1.0)
                                      .setB1(0.2)
                                      .setG2(2.0)
                                      .setB2(0.4)
                                      .add();
    line.getTerminal1().setP(105.);
    line.getTerminal1().setQ(190.);
    line.getTerminal2().setP(150.);
    line.getTerminal2().setQ(180.);
    line.newCurrentLimits1().beginTemporaryLimit().setName("TL1").setValue(10.).setAcceptableDuration(5.).endTemporaryLimit().add();
    line.newCurrentLimits2().beginTemporaryLimit().setName("TL2").setValue(20.).setAcceptableDuration(5.).endTemporaryLimit().add();
  }
  return network;
}  // createBusBreakerNetwork(const BusBreakerNetworkProperty& properties);

shared_ptr<SubModel>
initializeModel(shared_ptr<DataInterface> data) {
  shared_ptr<SubModel> modelNetwork = SubModelFactory::createSubModelFromLib("../../../../Models/CPP/ModelNetwork/DYNModelNetwork" +
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

TEST(DataInterfaceIIDMTest, testNodeBreakerBusIIDM) {
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createNodeBreakerNetworkIIDM());
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_0", "U"), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_0", "Teta"), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_2", "U"), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_2", "Teta"), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_5", "U"), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_5", "Teta"), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_6", "U"), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_6", "Teta"), 0.);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_3", "U"), 110.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_3", "Teta"), 1.5);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_3", "Upu"), 110./190.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_3", "Teta_pu"), 1.5 * M_PI / 180);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_1", "U"), 220.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_1", "Teta"), 3);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_1", "Upu"), 220./190.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_1", "Teta_pu"), 3 * M_PI / 180);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_4", "U"), 220.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_4", "Teta"), 3);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_4", "Upu"), 220./190.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_4", "Teta_pu"), 3 * M_PI / 180);

  ASSERT_EQ(data->getBusName("calculatedBus_MyVoltageLevel_0", ""), "calculatedBus_MyVoltageLevel_0");
  powsybl::iidm::Bus& busIIDM4 = network.getVoltageLevel("MyVoltageLevel").getBusBreakerView().getBus("MyVoltageLevel_4");
  ASSERT_DOUBLE_EQUALS_DYNAWO(busIIDM4.getV(), 220.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(busIIDM4.getAngle(), 3.);
  boost::shared_ptr<CalculatedBusInterfaceIIDM> bus4 =
      boost::dynamic_pointer_cast<CalculatedBusInterfaceIIDM>(data->findComponent("calculatedBus_MyVoltageLevel_4"));
  bus4->setValue(BusInterfaceIIDM::VAR_V, 100.);
  bus4->setValue(BusInterfaceIIDM::VAR_ANGLE, 90.);
  boost::shared_ptr<CalculatedBusInterfaceIIDM> bus1 =
      boost::dynamic_pointer_cast<CalculatedBusInterfaceIIDM>(data->findComponent("calculatedBus_MyVoltageLevel_1"));
  bus1->setValue(BusInterfaceIIDM::VAR_V, 100.);
  bus1->setValue(BusInterfaceIIDM::VAR_ANGLE, 90.);

  boost::shared_ptr<VoltageLevelInterfaceIIDM> vl =
      boost::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(data->getNetwork()->getVoltageLevels()[0]);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(busIIDM4.getV(), 100.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(busIIDM4.getAngle(), 90.);

  boost::shared_ptr<SwitchInterfaceIIDM> switchBK2 =
      boost::dynamic_pointer_cast<SwitchInterfaceIIDM>(data->findComponent("BK2"));
  boost::shared_ptr<SwitchInterfaceIIDM> switchBK1 =
      boost::dynamic_pointer_cast<SwitchInterfaceIIDM>(data->findComponent("BK1"));
  boost::shared_ptr<SwitchInterfaceIIDM> switchDC11 =
      boost::dynamic_pointer_cast<SwitchInterfaceIIDM>(data->findComponent("DC11"));
  ASSERT_FALSE(switchBK2->isOpen());
  ASSERT_TRUE(switchBK1->isOpen());
  ASSERT_TRUE(switchDC11->isOpen());
  ASSERT_TRUE(vl->isNodeConnected(1));
  ASSERT_FALSE(vl->isNodeConnected(0));
  vl->disconnectNode(1);
  ASSERT_TRUE(switchBK2->isOpen());
  ASSERT_TRUE(switchBK1->isOpen());
  ASSERT_TRUE(switchDC11->isOpen());
  ASSERT_FALSE(vl->isNodeConnected(1));
  ASSERT_FALSE(vl->isNodeConnected(0));
  vl->connectNode(0);
  ASSERT_TRUE(switchBK2->isOpen());
  ASSERT_FALSE(switchBK1->isOpen());
  ASSERT_FALSE(switchDC11->isOpen());
  ASSERT_FALSE(vl->isNodeConnected(1));
  ASSERT_TRUE(vl->isNodeConnected(0));
}

TEST(DataInterfaceIIDMTest, testBusIIDM) {
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
      false /*instantiateThreeWindingTransformer*/
  };

  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBus", "U"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBus", "Teta"), 1.5);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBus", "Upu"), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBus", "Teta_pu"), 1.5 * M_PI / 180);
  ASSERT_EQ(data->getBusName("MyBus", ""), "MyBus");
  powsybl::iidm::Bus& busIIDM = network.getVoltageLevel("VL1").getBusBreakerView().getBus("MyBus");
  ASSERT_DOUBLE_EQUALS_DYNAWO(busIIDM.getV(), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(busIIDM.getAngle(), 1.5);
  boost::shared_ptr<BusInterfaceIIDM> bus = boost::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("MyBus"));
  bus->setValue(BusInterfaceIIDM::VAR_V, 200.);
  bus->setValue(BusInterfaceIIDM::VAR_ANGLE, 3.14);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(busIIDM.getV(), 200.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(busIIDM.getAngle(), 3.14);
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
      false /*instantiateThreeWindingTransformer*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyDanglingLine", "p_pu"), 1.05);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyDanglingLine", "q_pu"), 0.9);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyDanglingLine", "p"), 105);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyDanglingLine", "q"), 90);
  ASSERT_EQ(data->getBusName("MyDanglingLine", ""), "MyBus");
  powsybl::iidm::DanglingLine& dlIIDM = network.getDanglingLine("MyDanglingLine");
  ASSERT_DOUBLE_EQUALS_DYNAWO(dlIIDM.getTerminal().getP(), 105.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dlIIDM.getTerminal().getQ(), 90.);
  ASSERT_TRUE(dlIIDM.getTerminal().isConnected());
  boost::shared_ptr<DanglingLineInterfaceIIDM> dl = boost::dynamic_pointer_cast<DanglingLineInterfaceIIDM>(data->findComponent("MyDanglingLine"));
  dl->setValue(DanglingLineInterfaceIIDM::VAR_P, 2.);
  dl->setValue(DanglingLineInterfaceIIDM::VAR_Q, 4.);
  dl->setValue(DanglingLineInterfaceIIDM::VAR_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(dlIIDM.getTerminal().getP(), 200.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dlIIDM.getTerminal().getQ(), 400.);
  ASSERT_FALSE(dlIIDM.getTerminal().isConnected());
  dl->setValue(DanglingLineInterfaceIIDM::VAR_STATE, CLOSED);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_TRUE(dlIIDM.getTerminal().isConnected());
}

TEST(DataInterfaceIIDMTest, testGeneratorIIDM) {
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
      false /*instantiateThreeWindingTransformer*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();

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
  ASSERT_EQ(data->getBusName("MyGenerator", ""), "MyBus");
  powsybl::iidm::Generator& genIIDM = network.getGenerator("MyGenerator");
  ASSERT_DOUBLE_EQUALS_DYNAWO(genIIDM.getTerminal().getP(), -105.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(genIIDM.getTerminal().getQ(), -90.);
  ASSERT_TRUE(genIIDM.getTerminal().isConnected());
  boost::shared_ptr<GeneratorInterfaceIIDM> gen = boost::dynamic_pointer_cast<GeneratorInterfaceIIDM>(data->findComponent("MyGenerator"));
  gen->setValue(GeneratorInterfaceIIDM::VAR_P, 2.);
  gen->setValue(GeneratorInterfaceIIDM::VAR_Q, 4.);
  gen->setValue(GeneratorInterfaceIIDM::VAR_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(genIIDM.getTerminal().getP(), -200.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(genIIDM.getTerminal().getQ(), -400.);
  ASSERT_FALSE(genIIDM.getTerminal().isConnected());
  gen->setValue(GeneratorInterfaceIIDM::VAR_STATE, CLOSED);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_TRUE(genIIDM.getTerminal().isConnected());
}

TEST(DataInterfaceIIDMTest, testHvdcLineVscConvertersIIDM) {
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
      false /*instantiateThreeWindingTransformer*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverter", "p_pu"), -150. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverter", "q_pu"), -90. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverter", "p"), -150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverter", "q"), -90.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverter", "v_pu"), 11.538461538461538);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverter", "angle_pu"), 0.02617993877991494148);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverter", "v"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverter", "angle"), 1.5);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverter2", "p_pu"), -150. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverter2", "q_pu"), -90. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverter2", "p"), -150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverter2", "q"), -90.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverter2", "v_pu"), 11.538461538461538);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverter2", "angle_pu"), 0.02617993877991494148);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverter2", "v"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyVscConverter2", "angle"), 1.5);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "p1_pu"), 150. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "q1_pu"), 90. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "p2_pu"), 150. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "q2_pu"), 90. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "p1"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "q1"), 90.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "p2"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "q2"), 90.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "v1_pu"), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "angle1_pu"), 0.02617993877991494148);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "v1"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "angle1"), 1.5);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "v2_pu"), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "angle2_pu"), 0.02617993877991494148);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "v2"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "angle2"), 1.5);
  ASSERT_EQ(data->getBusName("MyHvdcLine", ""), "");
  ASSERT_EQ(data->getBusName("MyHvdcLine", "@NODE1@"), "MyBus");
  ASSERT_EQ(data->getBusName("MyHvdcLine", "@NODE2@"), "MyBus");
  ASSERT_EQ(data->getBusName("MyVscConverter", ""), "MyBus");
  ASSERT_EQ(data->getBusName("MyVscConverter2", ""), "MyBus");

  boost::shared_ptr<HvdcLineInterfaceIIDM> hvdc = boost::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(data->findComponent("MyHvdcLine"));
  boost::shared_ptr<VscConverterInterfaceIIDM> vsc1 = boost::dynamic_pointer_cast<VscConverterInterfaceIIDM>(hvdc->getConverter1());
  boost::shared_ptr<VscConverterInterfaceIIDM> vsc2 = boost::dynamic_pointer_cast<VscConverterInterfaceIIDM>(hvdc->getConverter2());
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc1->getVscIIDM().getTerminal().getP(), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc1->getVscIIDM().getTerminal().getQ(), 90.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc2->getVscIIDM().getTerminal().getP(), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc2->getVscIIDM().getTerminal().getQ(), 90.);
  ASSERT_TRUE(vsc1->getVscIIDM().getTerminal().isConnected());
  ASSERT_TRUE(vsc2->getVscIIDM().getTerminal().isConnected());
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_P1, 2.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_Q1, 4.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_P2, 6.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_Q2, 8.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE1, OPEN);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE2, OPEN);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc1->getVscIIDM().getTerminal().getP(), -200.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc1->getVscIIDM().getTerminal().getQ(), -400.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc2->getVscIIDM().getTerminal().getP(), -600.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc2->getVscIIDM().getTerminal().getQ(), -800.);
  ASSERT_FALSE(vsc1->getVscIIDM().getTerminal().isConnected());
  ASSERT_FALSE(vsc2->getVscIIDM().getTerminal().isConnected());
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE1, CLOSED);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE2, CLOSED);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_TRUE(vsc1->getVscIIDM().getTerminal().isConnected());
  ASSERT_TRUE(vsc2->getVscIIDM().getTerminal().isConnected());

  boost::shared_ptr<BusInterfaceIIDM> bus = boost::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("MyBus"));
  ASSERT_FALSE(bus->hasConnection());
  hvdc->hasDynamicModel(true);
  ASSERT_FALSE(bus->hasConnection());
  data->mapConnections();
  ASSERT_TRUE(bus->hasConnection());
  hvdc->hasDynamicModel(false);
  ASSERT_TRUE(bus->hasConnection());
}  // TEST(DataInterfaceIIDMTest, testHvdcLineVscConvertersIIDM)

TEST(DataInterfaceIIDMTest, testHvdcLineLccConvertersIIDM) {
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
      false /*instantiateThreeWindingTransformer*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter", "p_pu"), -105. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter", "q_pu"), -90. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter", "p"), -105.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter", "q"), -90.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter", "v_pu"), 11.538461538461538);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter", "angle_pu"), 0.026179938779914941);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter", "v"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter", "angle"), 1.5);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter2", "p_pu"), -105. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter2", "q_pu"), -90. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter2", "p"), -105.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter2", "q"), -90.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter2", "v_pu"), 11.538461538461538);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter2", "angle_pu"), 0.026179938779914941);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter2", "v"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyLccConverter2", "angle"), 1.5);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "p1_pu"), 105. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "q1_pu"), 90. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "p2_pu"), 105. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "q2_pu"), 90. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "p1"), 105.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "q1"), 90.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "p2"), 105.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "q2"), 90.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "v1_pu"), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "angle1_pu"), 0.02617993877991494148);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "v1"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "angle1"), 1.5);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "v2_pu"), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "angle2_pu"), 0.02617993877991494148);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "v2"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyHvdcLine", "angle2"), 1.5);
  ASSERT_EQ(data->getBusName("MyHvdcLine", ""), "");
  ASSERT_EQ(data->getBusName("MyHvdcLine", "@NODE1@"), "MyBus");
  ASSERT_EQ(data->getBusName("MyHvdcLine", "@NODE2@"), "MyBus");
  ASSERT_EQ(data->getBusName("MyLccConverter", ""), "MyBus");
  ASSERT_EQ(data->getBusName("MyLccConverter2", ""), "MyBus");

  boost::shared_ptr<HvdcLineInterfaceIIDM> hvdc = boost::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(data->findComponent("MyHvdcLine"));
  boost::shared_ptr<LccConverterInterfaceIIDM> lcc1 = boost::dynamic_pointer_cast<LccConverterInterfaceIIDM>(hvdc->getConverter1());
  boost::shared_ptr<LccConverterInterfaceIIDM> lcc2 = boost::dynamic_pointer_cast<LccConverterInterfaceIIDM>(hvdc->getConverter2());
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc1->getLccIIDM().getTerminal().getP(), 105.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc1->getLccIIDM().getTerminal().getQ(), 90.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc2->getLccIIDM().getTerminal().getP(), 105.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc2->getLccIIDM().getTerminal().getQ(), 90.);
  ASSERT_TRUE(lcc1->getLccIIDM().getTerminal().isConnected());
  ASSERT_TRUE(lcc2->getLccIIDM().getTerminal().isConnected());
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_P1, 2.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_Q1, 4.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_P2, 6.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_Q2, 8.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE1, OPEN);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE2, OPEN);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc1->getLccIIDM().getTerminal().getP(), -200.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc1->getLccIIDM().getTerminal().getQ(), -400.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc2->getLccIIDM().getTerminal().getP(), -600.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc2->getLccIIDM().getTerminal().getQ(), -800.);
  ASSERT_FALSE(lcc1->getLccIIDM().getTerminal().isConnected());
  ASSERT_FALSE(lcc2->getLccIIDM().getTerminal().isConnected());
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE1, CLOSED);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE2, CLOSED);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_TRUE(lcc1->getLccIIDM().getTerminal().isConnected());
  ASSERT_TRUE(lcc2->getLccIIDM().getTerminal().isConnected());

  boost::shared_ptr<BusInterfaceIIDM> bus = boost::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("MyBus"));
  ASSERT_FALSE(bus->hasConnection());
  hvdc->hasDynamicModel(true);
  ASSERT_FALSE(bus->hasConnection());
  data->mapConnections();
  ASSERT_TRUE(bus->hasConnection());
  hvdc->hasDynamicModel(false);
  ASSERT_TRUE(bus->hasConnection());
}  // TEST(DataInterfaceIIDMTest, testHvdcLineLccConvertersIIDM)

TEST(DataInterfaceIIDMTest, testLineIIDM) {
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
      false /*instantiateThreeWindingTransformer*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();

  ASSERT_THROW_DYNAWO(data->getStaticParameterDoubleValue("VL1_VL2", "p_pu"), Error::MODELER, KeyError_t::UnknownStaticParameter);
  ASSERT_EQ(data->getBusName("VL1_VL2", "@NODE1@"), "MyBus");
  ASSERT_EQ(data->getBusName("VL1_VL2", "@NODE2@"), "VL2_BUS1");

  powsybl::iidm::Line& lineIIDM = network.getLine("VL1_VL2");
  ASSERT_DOUBLE_EQUALS_DYNAWO(lineIIDM.getTerminal1().getP(), 22560.083951694862);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lineIIDM.getTerminal1().getQ(), -3833.3398616136255);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lineIIDM.getTerminal2().getP(), 0.54438004263684103);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lineIIDM.getTerminal2().getQ(), -3.1327061160422587);
  ASSERT_TRUE(lineIIDM.getTerminal1().isConnected());
  ASSERT_TRUE(lineIIDM.getTerminal2().isConnected());
  boost::shared_ptr<LineInterfaceIIDM> line = boost::dynamic_pointer_cast<LineInterfaceIIDM>(data->findComponent("VL1_VL2"));
  line->setValue(LineInterfaceIIDM::VAR_P1, 2.);
  line->setValue(LineInterfaceIIDM::VAR_Q1, 4.);
  line->setValue(LineInterfaceIIDM::VAR_P2, 6.);
  line->setValue(LineInterfaceIIDM::VAR_Q2, 8.);
  line->setValue(LineInterfaceIIDM::VAR_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(lineIIDM.getTerminal1().getP(), 200.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lineIIDM.getTerminal1().getQ(), 400.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lineIIDM.getTerminal2().getP(), 600.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lineIIDM.getTerminal2().getQ(), 800.);
  ASSERT_FALSE(lineIIDM.getTerminal1().isConnected());
  ASSERT_FALSE(lineIIDM.getTerminal2().isConnected());
  line->setValue(LineInterfaceIIDM::VAR_STATE, CLOSED);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_TRUE(lineIIDM.getTerminal1().isConnected());
  ASSERT_TRUE(lineIIDM.getTerminal2().isConnected());
  line->setValue(LineInterfaceIIDM::VAR_STATE, CLOSED_1);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_TRUE(lineIIDM.getTerminal1().isConnected());
  ASSERT_FALSE(lineIIDM.getTerminal2().isConnected());
  line->setValue(LineInterfaceIIDM::VAR_STATE, CLOSED_2);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_FALSE(lineIIDM.getTerminal1().isConnected());
  ASSERT_TRUE(lineIIDM.getTerminal2().isConnected());

  boost::shared_ptr<BusInterfaceIIDM> bus1 = boost::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("MyBus"));
  boost::shared_ptr<BusInterfaceIIDM> bus2 = boost::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("VL2_BUS1"));
  ASSERT_FALSE(bus1->hasConnection());
  ASSERT_FALSE(bus2->hasConnection());
  line->hasDynamicModel(true);
  ASSERT_FALSE(bus1->hasConnection());
  ASSERT_FALSE(bus2->hasConnection());
  data->mapConnections();
  ASSERT_TRUE(bus1->hasConnection());
  ASSERT_TRUE(bus2->hasConnection());
  line->hasDynamicModel(false);
  ASSERT_TRUE(bus1->hasConnection());
  ASSERT_TRUE(bus2->hasConnection());
}  // TEST(DataInterfaceIIDMTest, testLineIIDM)

TEST(DataInterfaceIIDMTest, testLoadIIDM) {
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
      false /*instantiateThreeWindingTransformer*/
  };

  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();

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
  ASSERT_EQ(data->getBusName("MyLoad", ""), "MyBus");

  powsybl::iidm::Load& loadIIDM = network.getLoad("MyLoad");
  ASSERT_DOUBLE_EQUALS_DYNAWO(loadIIDM.getTerminal().getP(), 105.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(loadIIDM.getTerminal().getQ(), 90.);
  ASSERT_TRUE(loadIIDM.getTerminal().isConnected());
  boost::shared_ptr<LoadInterfaceIIDM> load = boost::dynamic_pointer_cast<LoadInterfaceIIDM>(data->findComponent("MyLoad"));
  load->setValue(LoadInterfaceIIDM::VAR_P, 2.);
  load->setValue(LoadInterfaceIIDM::VAR_Q, 4.);
  load->setValue(LoadInterfaceIIDM::VAR_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(loadIIDM.getTerminal().getP(), 200.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(loadIIDM.getTerminal().getQ(), 400.);
  ASSERT_FALSE(loadIIDM.getTerminal().isConnected());
  load->setValue(LoadInterfaceIIDM::VAR_STATE, CLOSED);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_TRUE(loadIIDM.getTerminal().isConnected());
}  // TEST(DataInterfaceIIDMTest, testLoadIIDM)

TEST(DataInterfaceIIDMTest, testShuntCompensatorIIDM) {
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
      false /*instantiateThreeWindingTransformer*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyCapacitorShuntCompensator", "q_pu"), -90000. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyCapacitorShuntCompensator", "q"), -90000.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterBoolValue("MyCapacitorShuntCompensator", "isCapacitor"), 1.);
  ASSERT_EQ(data->getBusName("MyCapacitorShuntCompensator", ""), "MyBus");

  powsybl::iidm::ShuntCompensator& shuntIIDM = network.getShuntCompensator("MyCapacitorShuntCompensator");
  ASSERT_DOUBLE_EQUALS_DYNAWO(shuntIIDM.getTerminal().getQ(), -90000.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(shuntIIDM.getCurrentSectionCount(), 2UL);
  ASSERT_TRUE(shuntIIDM.getTerminal().isConnected());
  boost::shared_ptr<ShuntCompensatorInterfaceIIDM> shunt =
      boost::dynamic_pointer_cast<ShuntCompensatorInterfaceIIDM>(data->findComponent("MyCapacitorShuntCompensator"));
  shunt->setValue(ShuntCompensatorInterfaceIIDM::VAR_Q, 4.);
  shunt->setValue(ShuntCompensatorInterfaceIIDM::VAR_CURRENTSECTION, 1);
  shunt->setValue(ShuntCompensatorInterfaceIIDM::VAR_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(shuntIIDM.getTerminal().getQ(), 400.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(shuntIIDM.getCurrentSectionCount(), 1);
  ASSERT_FALSE(shuntIIDM.getTerminal().isConnected());
  shunt->setValue(ShuntCompensatorInterfaceIIDM::VAR_STATE, CLOSED);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_TRUE(shuntIIDM.getTerminal().isConnected());
}

TEST(DataInterfaceIIDMTest, testStaticVarCompensatorIIDM) {
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
    false /*instantiateThreeWindingTransformer*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();
  ASSERT_EQ(data->getBusName("MyStaticVarCompensator", ""), "MyBus");
  ASSERT_EQ(data->getBusName("nothing", ""), "");

  // p will always be 0. because it is set to 0. in the CPP model for SVarC
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyStaticVarCompensator", "p"), 5.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyStaticVarCompensator", "p_pu"), 5. / SNREF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyStaticVarCompensator", "q"), 85.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyStaticVarCompensator", "q_pu"), 85. / SNREF);
  ASSERT_EQ(data->getStaticParameterIntValue("MyStaticVarCompensator", "regulatingMode"), StaticVarCompensatorInterface::OFF);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyStaticVarCompensator", "v"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyStaticVarCompensator", "angle"), 1.5);

  powsybl::iidm::StaticVarCompensator& svcIIDM = network.getStaticVarCompensator("MyStaticVarCompensator");
  boost::shared_ptr<StaticVarCompensatorInterfaceIIDM> svc =
    boost::dynamic_pointer_cast<StaticVarCompensatorInterfaceIIDM>(data->findComponent("MyStaticVarCompensator"));
  ASSERT_DOUBLE_EQUALS_DYNAWO(svcIIDM.getTerminal().getP(), 5.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svcIIDM.getTerminal().getQ(), 85.);
  ASSERT_TRUE(svcIIDM.getTerminal().isConnected());
  svc->setValue(StaticVarCompensatorInterfaceIIDM::VAR_P, 4.);
  svc->setValue(StaticVarCompensatorInterfaceIIDM::VAR_Q, 1);
  svc->setValue(StaticVarCompensatorInterfaceIIDM::VAR_STATE, OPEN);
  svc->setValue(StaticVarCompensatorInterfaceIIDM::VAR_REGULATINGMODE, StaticVarCompensatorInterface::RUNNING_V);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(svcIIDM.getTerminal().getP(), -400.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svcIIDM.getTerminal().getQ(), -100.);
  ASSERT_FALSE(svcIIDM.getTerminal().isConnected());
  ASSERT_EQ(svcIIDM.getRegulationMode(), powsybl::iidm::StaticVarCompensator::RegulationMode::VOLTAGE);
  svc->setValue(StaticVarCompensatorInterfaceIIDM::VAR_STATE, CLOSED);
  svc->setValue(StaticVarCompensatorInterfaceIIDM::VAR_REGULATINGMODE, StaticVarCompensatorInterface::RUNNING_Q);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_TRUE(svcIIDM.getTerminal().isConnected());
  ASSERT_EQ(svcIIDM.getRegulationMode(), powsybl::iidm::StaticVarCompensator::RegulationMode::REACTIVE_POWER);
  svc->setValue(StaticVarCompensatorInterfaceIIDM::VAR_REGULATINGMODE, StaticVarCompensatorInterface::OFF);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_EQ(svcIIDM.getRegulationMode(), powsybl::iidm::StaticVarCompensator::RegulationMode::OFF);
}

TEST(DataInterfaceIIDMTest, testSwitchIIDM) {
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
      false /*instantiateThreeWindingTransformer*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();
  ASSERT_EQ(data->getBusName("Sw", ""), "");

  powsybl::iidm::Switch& switchIIDM = network.getSwitch("Sw");
  ASSERT_FALSE(switchIIDM.isOpen());
  boost::shared_ptr<SwitchInterfaceIIDM> sw = boost::dynamic_pointer_cast<SwitchInterfaceIIDM>(data->findComponent("Sw"));
  sw->setValue(SwitchInterfaceIIDM::VAR_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_TRUE(switchIIDM.isOpen());
  sw->setValue(SwitchInterfaceIIDM::VAR_STATE, CLOSED);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_FALSE(switchIIDM.isOpen());
}

TEST(DataInterfaceIIDMTest, testRatioTwoWindingTransformerIIDM) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      true /*instantiateTwoWindingTransformer*/,
      true /*instantiateRatioTapChanger*/,
      true /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/,
      true /*instantiateThreeWindingTransformer*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "p1_pu"), 9.2043642724743098);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "p2_pu"), -0.0011838723553420131);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "q1_pu"), -1.5798045729283614);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "q2_pu"), -0.0084962943718131304);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "p1"), 920.43642724743098);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "p2"), -0.11838723553420131);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "q1"), -157.98045729283614);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "q2"), -0.84962943718131304);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "i1"), 9.338956266577485);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "i2"), 1.9301350853479737);
  ASSERT_EQ(data->getStaticParameterDoubleValue("MyTransformer2Winding", "iMax"), 259.80502305912023);
  ASSERT_EQ(data->getStaticParameterDoubleValue("MyTransformer2Winding", "iStop"), 259.80502305912023);
  ASSERT_EQ(data->getStaticParameterDoubleValue("MyTransformer2Winding", "regulating"), 0);
  ASSERT_EQ(data->getStaticParameterDoubleValue("MyTransformer2Winding", "increasePhase"), -1);
  ASSERT_EQ(data->getStaticParameterDoubleValue("MyTransformer2Winding", "tapPosition"), 2);
  ASSERT_EQ(data->getStaticParameterDoubleValue("MyTransformer2Winding", "lowTapPosition"), 0);
  ASSERT_EQ(data->getStaticParameterDoubleValue("MyTransformer2Winding", "highTapPosition"), 2);
  ASSERT_EQ(data->getBusName("MyTransformer2Winding", "@NODE1@"), "MyBus");
  ASSERT_EQ(data->getBusName("MyTransformer2Winding", "@NODE2@"), "VL2_BUS1");

  powsybl::iidm::TwoWindingsTransformer& twoWTIIDM = network.getTwoWindingsTransformer("MyTransformer2Winding");
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal1().getP(), 920.43642724743098);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal1().getQ(), -157.98045729283614);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal2().getP(), -0.11838723553420131);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal2().getQ(), -0.84962943718131304);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getPhaseTapChanger().getTapPosition(), 2);
  ASSERT_TRUE(twoWTIIDM.getTerminal1().isConnected());
  ASSERT_TRUE(twoWTIIDM.getTerminal2().isConnected());
  boost::shared_ptr<TwoWTransformerInterfaceIIDM> twoWT =
      boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(data->findComponent("MyTransformer2Winding"));
  twoWT->setValue(TwoWTransformerInterfaceIIDM::VAR_P1, 2.);
  twoWT->setValue(TwoWTransformerInterfaceIIDM::VAR_Q1, 4.);
  twoWT->setValue(TwoWTransformerInterfaceIIDM::VAR_P2, 6.);
  twoWT->setValue(TwoWTransformerInterfaceIIDM::VAR_Q2, 8.);
  twoWT->setValue(TwoWTransformerInterfaceIIDM::VAR_TAPINDEX, 1.);
  twoWT->setValue(TwoWTransformerInterfaceIIDM::VAR_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal1().getP(), 200.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal1().getQ(), 400.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal2().getP(), 600.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal2().getQ(), 800.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getPhaseTapChanger().getTapPosition(), 1);
  ASSERT_FALSE(twoWTIIDM.getTerminal1().isConnected());
  ASSERT_FALSE(twoWTIIDM.getTerminal2().isConnected());
  twoWT->setValue(TwoWTransformerInterfaceIIDM::VAR_STATE, CLOSED);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_TRUE(twoWTIIDM.getTerminal1().isConnected());
  ASSERT_TRUE(twoWTIIDM.getTerminal2().isConnected());
  twoWT->setValue(TwoWTransformerInterfaceIIDM::VAR_STATE, CLOSED_1);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_TRUE(twoWTIIDM.getTerminal1().isConnected());
  ASSERT_FALSE(twoWTIIDM.getTerminal2().isConnected());
  twoWT->setValue(TwoWTransformerInterfaceIIDM::VAR_STATE, CLOSED_2);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_FALSE(twoWTIIDM.getTerminal1().isConnected());
  ASSERT_TRUE(twoWTIIDM.getTerminal2().isConnected());
}

TEST(DataInterfaceIIDMTest, testTwoWindingTransformerIIDM) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      true /*instantiateTwoWindingTransformer*/,
      true /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/,
      true /*instantiateThreeWindingTransformer*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "p1_pu"), 9.1139982127973873);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "p2_pu"), -0.0010255087406258725);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "q1_pu"), -1.5591740692665068);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "q2_pu"), -0.0086036345858491441);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "p1"), 911.39982127973873);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "p2"), -0.10255087406258725);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "q1"), -155.91740692665068);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "q2"), -0.86036345858491441);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "i1"), 9.2464040145965409);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "i2"), 1.9495207579969318);
  ASSERT_THROW_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "iMax"), Error::MODELER, KeyError_t::UnknownStaticParameter);
  ASSERT_THROW_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "iStop"), Error::MODELER, KeyError_t::UnknownStaticParameter);
  ASSERT_THROW_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "regulating"), Error::MODELER, KeyError_t::UnknownStaticParameter);
  ASSERT_THROW_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "increasePhase"), Error::MODELER, KeyError_t::UnknownStaticParameter);
  ASSERT_EQ(data->getStaticParameterDoubleValue("MyTransformer2Winding", "tapPosition"), 1);
  ASSERT_EQ(data->getStaticParameterDoubleValue("MyTransformer2Winding", "lowTapPosition"), 0);
  ASSERT_EQ(data->getStaticParameterDoubleValue("MyTransformer2Winding", "highTapPosition"), 1);
  ASSERT_EQ(data->getBusName("MyTransformer2Winding", "@NODE1@"), "MyBus");
  ASSERT_EQ(data->getBusName("MyTransformer2Winding", "@NODE2@"), "VL2_BUS1");

  powsybl::iidm::TwoWindingsTransformer& twoWTIIDM = network.getTwoWindingsTransformer("MyTransformer2Winding");
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal1().getP(), 911.39982127973873);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal1().getQ(), -155.91740692665068);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal2().getP(), -0.10255087406258725);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal2().getQ(), -0.86036345858491441);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getRatioTapChanger().getTapPosition(), 1);
  ASSERT_TRUE(twoWTIIDM.getTerminal1().isConnected());
  ASSERT_TRUE(twoWTIIDM.getTerminal2().isConnected());
  boost::shared_ptr<TwoWTransformerInterfaceIIDM> twoWT =
      boost::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(data->findComponent("MyTransformer2Winding"));
  twoWT->setValue(TwoWTransformerInterfaceIIDM::VAR_P1, 2.);
  twoWT->setValue(TwoWTransformerInterfaceIIDM::VAR_Q1, 4.);
  twoWT->setValue(TwoWTransformerInterfaceIIDM::VAR_P2, 6.);
  twoWT->setValue(TwoWTransformerInterfaceIIDM::VAR_Q2, 8.);
  twoWT->setValue(TwoWTransformerInterfaceIIDM::VAR_TAPINDEX, 0.);
  twoWT->setValue(TwoWTransformerInterfaceIIDM::VAR_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal1().getP(), 200.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal1().getQ(), 400.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal2().getP(), 600.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal2().getQ(), 800.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getRatioTapChanger().getTapPosition(), 0);
  ASSERT_FALSE(twoWTIIDM.getTerminal1().isConnected());
  ASSERT_FALSE(twoWTIIDM.getTerminal2().isConnected());
  twoWT->setValue(TwoWTransformerInterfaceIIDM::VAR_STATE, CLOSED);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_TRUE(twoWTIIDM.getTerminal1().isConnected());
  ASSERT_TRUE(twoWTIIDM.getTerminal2().isConnected());
  twoWT->setValue(TwoWTransformerInterfaceIIDM::VAR_STATE, CLOSED_1);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_TRUE(twoWTIIDM.getTerminal1().isConnected());
  ASSERT_FALSE(twoWTIIDM.getTerminal2().isConnected());
  twoWT->setValue(TwoWTransformerInterfaceIIDM::VAR_STATE, CLOSED_2);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_FALSE(twoWTIIDM.getTerminal1().isConnected());
  ASSERT_TRUE(twoWTIIDM.getTerminal2().isConnected());

  boost::shared_ptr<BusInterfaceIIDM> bus1 = boost::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("MyBus"));
  boost::shared_ptr<BusInterfaceIIDM> bus2 = boost::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("VL2_BUS1"));
  ASSERT_FALSE(bus1->hasConnection());
  ASSERT_FALSE(bus2->hasConnection());
  twoWT->hasDynamicModel(true);
  ASSERT_FALSE(bus1->hasConnection());
  ASSERT_FALSE(bus2->hasConnection());
  data->mapConnections();
  ASSERT_TRUE(bus1->hasConnection());
  ASSERT_TRUE(bus2->hasConnection());
  twoWT->hasDynamicModel(false);
  ASSERT_TRUE(bus1->hasConnection());
  ASSERT_TRUE(bus2->hasConnection());
}  // TEST(DataInterfaceIIDMTest, testTwoWindingTransformerIIDM)

TEST(DataInterfaceIIDMTest, testThreeWindingTransformerIIDM) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      true /*instantiateRatioTapChanger*/,
      true /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverter*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverter*/,
      true /*instantiateThreeWindingTransformer*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  boost::shared_ptr<BusInterface> fictBus =
      boost::dynamic_pointer_cast<BusInterface>(data->findComponent("MyTransformer3Winding_FictBUS"));
  boost::shared_ptr<BusInterface> bus1 = boost::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("MyBus"));
  boost::shared_ptr<BusInterface> bus2 = boost::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("VL2_BUS1"));
  boost::shared_ptr<BusInterface> bus3 = boost::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("VL3_BUS1"));
  std::vector<boost::shared_ptr<VoltageLevelInterface> > Vls = data->getNetwork()->getVoltageLevels();
  std::string FictVLId = "MyTransformer3Winding_FictVL";
  auto it_vl = std::find_if(Vls.begin(), Vls.end(), [&FictVLId](boost::shared_ptr<VoltageLevelInterface>& vl) {return vl->getID() == FictVLId;});
  ASSERT_TRUE(it_vl != Vls.end());
  powsybl::iidm::Network& network = data->getNetworkIIDM();
  powsybl::iidm::ThreeWindingsTransformer& threeWTIIDM = network.getThreeWindingsTransformer("MyTransformer3Winding");
  std::string FictTwoWTransf1_Id = "MyTransformer3Winding_1";
  std::string FictTwoWTransf2_Id = "MyTransformer3Winding_2";
  std::string FictTwoWTransf3_Id = "MyTransformer3Winding_3";
  boost::shared_ptr<TwoWTransformerInterface> FictTwoWTransf1 =
      boost::dynamic_pointer_cast<TwoWTransformerInterface>(data->findComponent(FictTwoWTransf1_Id));
  boost::shared_ptr<TwoWTransformerInterface> FictTwoWTransf2 =
      boost::dynamic_pointer_cast<TwoWTransformerInterface>(data->findComponent(FictTwoWTransf2_Id));
  boost::shared_ptr<TwoWTransformerInterface> FictTwoWTransf3 =
      boost::dynamic_pointer_cast<TwoWTransformerInterface>(data->findComponent(FictTwoWTransf3_Id));

  ASSERT_EQ(data->getBusName(FictTwoWTransf1_Id, "@NODE1@"), "MyTransformer3Winding_FictBUS");
  ASSERT_EQ(data->getBusName(FictTwoWTransf1_Id, "@NODE2@"), "MyBus");
  ASSERT_EQ(data->getBusName(FictTwoWTransf2_Id, "@NODE1@"), "MyTransformer3Winding_FictBUS");
  ASSERT_EQ(data->getBusName(FictTwoWTransf2_Id, "@NODE2@"), "VL2_BUS1");
  ASSERT_EQ(data->getBusName(FictTwoWTransf3_Id, "@NODE1@"), "MyTransformer3Winding_FictBUS");
  ASSERT_EQ(data->getBusName(FictTwoWTransf3_Id, "@NODE2@"), "VL3_BUS1");

  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf1->getR(), threeWTIIDM.getLeg1().getR());
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf1->getX(), threeWTIIDM.getLeg1().getX());
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf1->getG(), threeWTIIDM.getLeg1().getG());
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf1->getB(), threeWTIIDM.getLeg1().getB());
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf1->getRatedU1(), threeWTIIDM.getRatedU0());
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf1->getRatedU2(), threeWTIIDM.getLeg1().getRatedU());

  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf2->getR(), threeWTIIDM.getLeg2().getR());
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf2->getX(), threeWTIIDM.getLeg2().getX());
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf2->getG(), threeWTIIDM.getLeg2().getG());
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf2->getB(), threeWTIIDM.getLeg2().getB());
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf2->getRatedU1(), threeWTIIDM.getRatedU0());
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf2->getRatedU2(), threeWTIIDM.getLeg2().getRatedU());

  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf3->getR(), threeWTIIDM.getLeg3().getR());
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf3->getX(), threeWTIIDM.getLeg3().getX());
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf3->getG(), threeWTIIDM.getLeg3().getG());
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf3->getB(), threeWTIIDM.getLeg3().getB());
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf3->getRatedU1(), threeWTIIDM.getRatedU0());
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf3->getRatedU2(), threeWTIIDM.getLeg3().getRatedU());

  ASSERT_DOUBLE_EQUALS_DYNAWO(it_vl->get()->getVNom(), threeWTIIDM.getRatedU0());

  data->hasDynamicModel("MyTransformer3Winding_1");
  data->hasDynamicModel("MyTransformer3Winding_2");
  data->hasDynamicModel("MyTransformer3Winding_3");
  ASSERT_FALSE(fictBus->hasConnection());
  ASSERT_FALSE(bus1->hasConnection());
  ASSERT_FALSE(bus2->hasConnection());
  ASSERT_FALSE(bus3->hasConnection());
  data->mapConnections();
  ASSERT_TRUE(fictBus->hasConnection());
  ASSERT_TRUE(bus1->hasConnection());
  ASSERT_TRUE(bus2->hasConnection());
  ASSERT_TRUE(bus3->hasConnection());
  FictTwoWTransf1->hasDynamicModel(false);
  FictTwoWTransf2->hasDynamicModel(false);
  FictTwoWTransf3->hasDynamicModel(false);
  ASSERT_TRUE(fictBus->hasConnection());
  ASSERT_TRUE(bus1->hasConnection());
  ASSERT_TRUE(bus2->hasConnection());
  ASSERT_TRUE(bus3->hasConnection());
}  // TEST(DataInterfaceIIDMTest, testThreeWindingTransformerIIDM)

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
      false /*instantiateThreeWindingTransformer*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);

  boost::shared_ptr<LoadInterface> loadItf = data->getNetwork()->getVoltageLevels()[0]->getLoads()[0];
  ASSERT_NO_THROW(data->setReference("p", "MyLoad", "MyLoad", "P_value"));
  ASSERT_THROW_DYNAWO(data->setReference("badParam", loadItf->getID(), "MyLoad", "p_pu"), Error::MODELER, KeyError_t::UnknownStateVariable);
  ASSERT_THROW_DYNAWO(data->setReference("p", "", "MyLoad", "p_pu"), Error::MODELER, KeyError_t::WrongReferenceId);
  ASSERT_NO_THROW(data->setReference("p", "MyLoad", "MyLoad", "myBadModelVar"));
  ASSERT_THROW_DYNAWO(data->getStateVariableReference(), Error::MODELER, KeyError_t::StateVariableNoReference);
  const bool filterForCriteriaCheck = false;
  ASSERT_NO_THROW(data->updateFromModel(filterForCriteriaCheck));

  // Reset
  data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  loadItf = data->getNetwork()->getVoltageLevels()[0]->getLoads()[0];
  ASSERT_NO_THROW(data->setReference("p", "MyLoad", "MyBadLoad", "p_pu"));
  ASSERT_THROW_DYNAWO(data->getStateVariableReference(), Error::MODELER, KeyError_t::StateVariableNoReference);
  ASSERT_NO_THROW(data->updateFromModel(filterForCriteriaCheck));

  // Reset
  data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  loadItf = data->getNetwork()->getVoltageLevels()[0]->getLoads()[0];
  ASSERT_THROW_DYNAWO(data->setReference("p", "MyBadLoad", "MyLoad", "p_pu"), Error::MODELER, KeyError_t::UnknownStaticComponent);
}

TEST(DataInterfaceIIDMTest, testImportError) {
  ASSERT_THROW_DYNAWO(DataInterfaceIIDM::build("invalid"), Error::GENERAL, KeyError_t::XmlFileParsingError);
}

TEST(DataInterfaceIIDMTest, testImportExport) {
  const powsybl::iidm::Network& network = createNodeBreakerNetworkIIDM();

  shared_ptr<DataInterfaceIIDM> dataOutput = createDataItfFromNetwork(createNodeBreakerNetworkIIDM());
  ASSERT_NO_THROW(dataOutput->dumpToFile("network.xml"));
  const powsybl::iidm::Network& outputNetwork = dataOutput->getNetworkIIDM();
  ASSERT_THROW_DYNAWO(dataOutput->dumpToFile(".."), Error::GENERAL, KeyError_t::FileGenerationFailed);

  shared_ptr<DataInterface> dataInput = DataInterfaceIIDM::build("network.xml");
  shared_ptr<DataInterfaceIIDM> dataInputIIDM = boost::dynamic_pointer_cast<DataInterfaceIIDM>(dataInput);
  const powsybl::iidm::Network& inputNetwork = dataInputIIDM->getNetworkIIDM();

  ASSERT_EQ(outputNetwork.getId(), inputNetwork.getId());
  ASSERT_EQ(outputNetwork.getId(), network.getId());
  ASSERT_EQ(inputNetwork.getId(), network.getId());
}
}  // namespace DYN
