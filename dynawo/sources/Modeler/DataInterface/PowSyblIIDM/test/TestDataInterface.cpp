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
 * @file Modeler/DataInterface/PowSyblIIDM/test/TestDataInterfaceIIDM.cpp
 * @brief Unit tests for DataInterfaceIIDM class
 *
 */


#include "gtest_dynawo.h"
#include "DYNDataInterfaceIIDM.h"
#include "DYNBatteryInterfaceIIDM.h"
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
#include "DYNLoadInterfaceIIDM.h"
#include "DYNModelMulti.h"
#include "DYNNetworkInterface.h"
#include "DYNThreeWTransformerInterfaceIIDM.h"
#include "DYNModelConstants.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNLoadInterfaceIIDM.h"

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
#include <powsybl/iidm/BatteryAdder.hpp>
#include <powsybl/iidm/StaticVarCompensator.hpp>
#include <powsybl/iidm/StaticVarCompensatorAdder.hpp>
#include <powsybl/iidm/CurrentLimitsAdder.hpp>

#include <thread>

using boost::shared_ptr;

namespace DYN {

static shared_ptr<DataInterfaceIIDM>
createDataItfFromNetwork(const boost::shared_ptr<powsybl::iidm::Network>& network) {
  shared_ptr<DataInterfaceIIDM> data;
  DataInterfaceIIDM* ptr = new DataInterfaceIIDM(network);
  ptr->initFromIIDM();
  data.reset(ptr);
  return data;
}

static boost::shared_ptr<powsybl::iidm::Network>
createNodeBreakerNetworkIIDM() {
  auto network = boost::make_shared<powsybl::iidm::Network>("MyNetwork", "MyNetwork");

  powsybl::iidm::Substation& substation = network->newSubstation()
                                     .setId("MySubStation")
                                     .setName("MySubStation_NAME")
                                     .setTso("TSO")
                                     .add();

  powsybl::iidm::VoltageLevel& vl = substation.newVoltageLevel()
                                     .setId("MyVoltageLevel")
                                     .setName("MyVoltageLevel_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::NODE_BREAKER)
                                     .setNominalV(190.)
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
  vl.getNodeBreakerView().newInternalConnection()
      .setNode1(0)
      .setNode2(8)
      .add();
  vl.getNodeBreakerView().newInternalConnection()
      .setNode1(1)
      .setNode2(9)
      .add();
  vl.getNodeBreakerView().newBreaker()
      .setId("BK1")
      .setNode1(8)
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
  vl.getNodeBreakerView().newBreaker()
      .setId("BK11")
      .setNode1(5)
      .setNode2(3)
      .setRetained(true)
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
      .setNode1(9)
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
  bool instantiateLccConverterWithConnectedHvdc;
  bool instantiateLccConverterWithDisconnectedHvdc;
  bool instantiateLine;
  bool instantiateLoad;
  bool instantiateSwitch;
  bool instantiateVscConverterWithConnectedHvdc;
  bool instantiateVscConverterWithDisconnectedHvdc;
  bool instantiateThreeWindingTransformer;
  bool instantiateBattery;
};

static powsybl::iidm::VscConverterStation&
initializeVscConverterStation(powsybl::iidm::VoltageLevel& vl,
                                const std::string& vscConverterId,
                                const std::string& vscConverterName,
                                const bool setBus) {
  powsybl::iidm::VscConverterStationAdder vscAdder = vl.newVscConverterStation()
                                                        .setId(vscConverterId)
                                                        .setName(vscConverterName)
                                                        .setConnectableBus("MyBus")
                                                        .setLossFactor(3.0)
                                                        .setVoltageRegulatorOn(true)
                                                        .setVoltageSetpoint(1.2)
                                                        .setReactivePowerSetpoint(-1.5);
  if (setBus) {
    vscAdder.setBus("MyBus");
  }

  powsybl::iidm::VscConverterStation& vsc = vscAdder.add();
  return vsc;
}

static powsybl::iidm::LccConverterStation&
initializeLccConverterStation(powsybl::iidm::VoltageLevel& vl,
                              const std::string& lccConverterId,
                              const std::string& lccConverterName,
                              const bool setBus) {
  powsybl::iidm::LccConverterStationAdder lccAdder = vl.newLccConverterStation()
                                                        .setId(lccConverterId)
                                                        .setName(lccConverterName)
                                                        .setConnectableBus("MyBus")
                                                        .setLossFactor(3.0)
                                                        .setPowerFactor(1.);
  if (setBus) {
    lccAdder.setBus("MyBus");
  }

  powsybl::iidm::LccConverterStation& lcc = lccAdder.add();
  return lcc;
}

static void
initializeHvdcLine(const boost::shared_ptr<powsybl::iidm::Network>& network,
                    const std::string& converterStationId1,
                    const std::string& converterStationId2) {
  network->newHvdcLine()
          .setId("MyHvdcLine")
          .setName("MyHvdcLine_NAME")
          .setActivePowerSetpoint(111.1)
          .setConvertersMode(powsybl::iidm::HvdcLine::ConvertersMode::SIDE_1_RECTIFIER_SIDE_2_INVERTER)
          .setConverterStationId1(converterStationId1)
          .setConverterStationId2(converterStationId2)
          .setMaxP(12.0)
          .setNominalV(13.0)
          .setR(14.0)
          .add();
}

static boost::shared_ptr<powsybl::iidm::Network>
createBusBreakerNetwork(const BusBreakerNetworkProperty& properties) {
  auto network = boost::make_shared<powsybl::iidm::Network>("MyNetwork", "MyNetwork");

  powsybl::iidm::Substation& s = network->newSubstation()
      .setId("MySubStation")
      .add();

  powsybl::iidm::VoltageLevel& vl1 = s.newVoltageLevel()
      .setId("VL1")
      .setNominalV(150.)
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
                                     .setNominalV(225.0)
                                     .setLowVoltageLimit(200.0)
                                     .setHighVoltageLimit(260.0)
                                     .add();

  vl2.getBusBreakerView().newBus().setId("VL2_BUS1").add();

  powsybl::iidm::VoltageLevel& vl3 = s.newVoltageLevel()
                                     .setId("VL3")
                                     .setName("VL3_NAME")
                                     .setTopologyKind(powsybl::iidm::TopologyKind::BUS_BREAKER)
                                     .setNominalV(225.0)
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

  if (properties.instantiateBattery) {
    powsybl::iidm:: Battery& bat = vl1.newBattery()
        .setId("MyBattery")
        .setName("MyBattery_NAME")
        .setBus("MyBus")
        .setConnectableBus("MyBus")
        .setMaxP(200.0)
        .setMinP(-150.0)
        .setP0(5.0)
        .setQ0(5.0)
        .add();
    bat.getTerminal().setP(-105.);
    bat.getTerminal().setQ(-90.);
    bat.newMinMaxReactiveLimits().setMinQ(1.).setMaxQ(20.).add();
  }

  if (properties.instantiateVscConverterWithConnectedHvdc) {
    powsybl::iidm::VscConverterStation& vsc = initializeVscConverterStation(vl1,
                                                                            "MyVscConverter",
                                                                            "MyVscConverter_NAME",
                                                                            true);
    vsc.getTerminal().setP(150.);
    vsc.getTerminal().setQ(90.);

    powsybl::iidm::VscConverterStation& vsc2 = initializeVscConverterStation(vl1,
                                                                              "MyVscConverter2",
                                                                              "MyVscConverter2_NAME",
                                                                              true);
    vsc2.getTerminal().setP(150.);
    vsc2.getTerminal().setQ(90.);

    initializeHvdcLine(network, "MyVscConverter", "MyVscConverter2");
  }

  if (properties.instantiateVscConverterWithDisconnectedHvdc) {
    initializeVscConverterStation(vl1, "MyVscConverter", "MyVscConverter_NAME", false);
    initializeVscConverterStation(vl1, "MyVscConverter2", "MyVscConverter2_NAME", false);
    initializeHvdcLine(network, "MyVscConverter", "MyVscConverter2");
  }

  if (properties.instantiateLccConverterWithConnectedHvdc) {
    powsybl::iidm::LccConverterStation& lcc = initializeLccConverterStation(vl1,
                                                                            "MyLccConverter",
                                                                            "MyLccConverter_NAME",
                                                                            true);
    lcc.getTerminal().setP(105.);
    lcc.getTerminal().setQ(90.);

    powsybl::iidm::LccConverterStation& lcc2 = initializeLccConverterStation(vl1,
                                                                              "MyLccConverter2",
                                                                              "MyLccConverter2_NAME",
                                                                              true);
    lcc2.getTerminal().setP(105.);
    lcc2.getTerminal().setQ(90.);

    initializeHvdcLine(network, "MyLccConverter", "MyLccConverter2");
  }

  if (properties.instantiateLccConverterWithDisconnectedHvdc) {
    initializeLccConverterStation(vl1, "MyLccConverter", "MyLccConverter_NAME", false);
    initializeLccConverterStation(vl1, "MyLccConverter2", "MyLccConverter2_NAME", false);
    initializeHvdcLine(network, "MyLccConverter", "MyLccConverter2");
  }

  if (properties.instantiateCapacitorShuntCompensator) {
    powsybl::iidm::ShuntCompensator& shuntIIDM = vl1.newShuntCompensator()
        .setId("MyCapacitorShuntCompensator")
        .setName("MyCapacitorShuntCompensator_NAME")
        .setBus("MyBus")
        .setConnectableBus("MyBus")
        .newLinearModel()
        .setBPerSection(2.0)
        .setMaximumSectionCount(3UL)
        .add()
        .setSectionCount(2UL)
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
    powsybl::iidm::Line& line = network->newLine()
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
  parametersSet->createParameter("transformer_t1st_THT", 9.);
  parametersSet->createParameter("transformer_tNext_THT", 10.);
  parametersSet->createParameter("transformer_t1st_HT", 11.);
  parametersSet->createParameter("transformer_tNext_HT", 12.);
  parametersSet->createParameter("transformer_tolV", 13.);
  modelNetwork->setPARParameters(parametersSet);

  return modelNetwork;
}  // initializeModel(shared_ptr<DataInterface> data);

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

TEST(DataInterfaceIIDMTest, testNodeBreakerBusIIDM) {
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createNodeBreakerNetworkIIDM());
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_0", "U"), 190.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_0", "Theta"), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_2", "U"), 190.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_2", "Theta"), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_5", "U"), 190.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_5", "Theta"), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_6", "U"), 190.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_6", "Theta"), 0.);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_3", "U"), 110.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_3", "Theta"), 1.5);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_3", "Upu"), 110./190.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_3", "Theta_pu"), 1.5 * M_PI / 180);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_1", "U"), 220.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_1", "Theta"), 3);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_1", "Upu"), 220./190.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_1", "Theta_pu"), 3 * M_PI / 180);

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_4", "U"), 220.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_4", "Theta"), 3);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_4", "Upu"), 220./190.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("calculatedBus_MyVoltageLevel_4", "Theta_pu"), 3 * M_PI / 180);

  ASSERT_EQ(data->getBusName("calculatedBus_MyVoltageLevel_0", ""), "calculatedBus_MyVoltageLevel_0");
  powsybl::iidm::Bus& busIIDM4 = network.getVoltageLevel("MyVoltageLevel").getBusBreakerView().getBus("MyVoltageLevel_4");
  ASSERT_DOUBLE_EQUALS_DYNAWO(busIIDM4.getV(), 220.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(busIIDM4.getAngle(), 3.);
  std::shared_ptr<CalculatedBusInterfaceIIDM> bus4 =
      std::dynamic_pointer_cast<CalculatedBusInterfaceIIDM>(data->findComponent("calculatedBus_MyVoltageLevel_4"));
  bus4->setValue(BusInterfaceIIDM::VAR_V, 100.);
  bus4->setValue(BusInterfaceIIDM::VAR_ANGLE, 90.);
  std::shared_ptr<CalculatedBusInterfaceIIDM> bus1 =
      std::dynamic_pointer_cast<CalculatedBusInterfaceIIDM>(data->findComponent("calculatedBus_MyVoltageLevel_1"));
  bus1->setValue(BusInterfaceIIDM::VAR_V, 100.);
  bus1->setValue(BusInterfaceIIDM::VAR_ANGLE, 90.);

  std::shared_ptr<VoltageLevelInterfaceIIDM> vl =
      std::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(data->getNetwork()->getVoltageLevels()[0]);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(busIIDM4.getV(), 100.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(busIIDM4.getAngle(), 90.);

  std::shared_ptr<SwitchInterfaceIIDM> switchBK2 =
      std::dynamic_pointer_cast<SwitchInterfaceIIDM>(data->findComponent("BK2"));
  std::shared_ptr<SwitchInterfaceIIDM> switchBK1 =
      std::dynamic_pointer_cast<SwitchInterfaceIIDM>(data->findComponent("BK1"));
  std::shared_ptr<SwitchInterfaceIIDM> switchDC11 =
      std::dynamic_pointer_cast<SwitchInterfaceIIDM>(data->findComponent("DC11"));
  std::shared_ptr<SwitchInterfaceIIDM> switchBK11 =
      std::dynamic_pointer_cast<SwitchInterfaceIIDM>(data->findComponent("BK11"));
  ASSERT_FALSE(switchBK2->isOpen());
  ASSERT_TRUE(switchBK1->isOpen());
  ASSERT_TRUE(switchDC11->isOpen());
  ASSERT_TRUE(vl->isNodeConnected(1));
  ASSERT_FALSE(vl->isNodeConnected(0));
  vl->disconnectNode(1);
  ASSERT_TRUE(switchBK2->isOpen());
  ASSERT_TRUE(switchBK1->isOpen());
  ASSERT_TRUE(switchDC11->isOpen());
  ASSERT_TRUE(switchBK11->isOpen());
  ASSERT_FALSE(vl->isNodeConnected(1));
  ASSERT_FALSE(vl->isNodeConnected(0));
  vl->connectNode(0);
  ASSERT_TRUE(switchBK2->isOpen());
  ASSERT_FALSE(switchBK1->isOpen());
  ASSERT_TRUE(switchDC11->isOpen());
  ASSERT_FALSE(switchBK11->isOpen());
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
      false /*instantiateLccConverterWithConnectedHvdc*/,
      false /*instantiateLccConverterWithDisconnectedHvdc*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverterWithConnectedHvdc*/,
      false /*instantiateVscConverterWithDisconnectedHvdc*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };

  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBus", "U"), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBus", "Theta"), 1.5);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBus", "Upu"), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyBus", "Theta_pu"), 1.5 * M_PI / 180);
  ASSERT_EQ(data->getBusName("MyBus", ""), "MyBus");
  powsybl::iidm::Bus& busIIDM = network.getVoltageLevel("VL1").getBusBreakerView().getBus("MyBus");
  ASSERT_DOUBLE_EQUALS_DYNAWO(busIIDM.getV(), 150.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(busIIDM.getAngle(), 1.5);
  std::shared_ptr<BusInterfaceIIDM> bus = std::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("MyBus"));
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
      false /*instantiateLccConverterWithConnectedHvdc*/,
      false /*instantiateLccConverterWithDisconnectedHvdc*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverterWithConnectedHvdc*/,
      false /*instantiateVscConverterWithDisconnectedHvdc*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
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
  std::shared_ptr<DanglingLineInterfaceIIDM> dl = std::dynamic_pointer_cast<DanglingLineInterfaceIIDM>(data->findComponent("MyDanglingLine"));
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
      false /*instantiateLccConverterWithConnectedHvdc*/,
      false /*instantiateLccConverterWithDisconnectedHvdc*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverterWithConnectedHvdc*/,
      false /*instantiateVscConverterWithDisconnectedHvdc*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
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
  std::shared_ptr<GeneratorInterfaceIIDM> gen = std::dynamic_pointer_cast<GeneratorInterfaceIIDM>(data->findComponent("MyGenerator"));
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

TEST(DataInterfaceIIDMTest, testBatteryIIDM) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverterWithConnectedHvdc*/,
      false /*instantiateLccConverterWithDisconnectedHvdc*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverterWithConnectedHvdc*/,
      false /*instantiateVscConverterWithDisconnectedHvdc*/,
      false /*instantiateThreeWindingTransformer*/,
      true /*instantiateBattery*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();

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
  ASSERT_EQ(data->getBusName("MyBattery", ""), "MyBus");
  powsybl::iidm::Battery& batIIDM = network.getBattery("MyBattery");
  ASSERT_DOUBLE_EQUALS_DYNAWO(batIIDM.getTerminal().getP(), -105.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(batIIDM.getTerminal().getQ(), -90.);
  ASSERT_TRUE(batIIDM.getTerminal().isConnected());
  std::shared_ptr<BatteryInterfaceIIDM> bat = std::dynamic_pointer_cast<BatteryInterfaceIIDM>(data->findComponent("MyBattery"));
  bat->setValue(BatteryInterfaceIIDM::VAR_P, 2.);
  bat->setValue(BatteryInterfaceIIDM::VAR_Q, 4.);
  bat->setValue(BatteryInterfaceIIDM::VAR_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(batIIDM.getTerminal().getP(), -200.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(batIIDM.getTerminal().getQ(), -400.);
  ASSERT_FALSE(batIIDM.getTerminal().isConnected());
  bat->setValue(BatteryInterfaceIIDM::VAR_STATE, CLOSED);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_TRUE(batIIDM.getTerminal().isConnected());
}

TEST(DataInterfaceIIDMTest, testConnectedHvdcLineVscConvertersIIDM) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverterWithConnectedHvdc*/,
      false /*instantiateLccConverterWithDisconnectedHvdc*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      true /*instantiateVscConverterWithConnectedHvdc*/,
      false /*instantiateVscConverterWithDisconnectedHvdc*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
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

  std::shared_ptr<HvdcLineInterfaceIIDM> hvdc = std::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(data->findComponent("MyHvdcLine"));
  std::shared_ptr<VscConverterInterfaceIIDM> vsc1 = std::dynamic_pointer_cast<VscConverterInterfaceIIDM>(hvdc->getConverter1());
  std::shared_ptr<VscConverterInterfaceIIDM> vsc2 = std::dynamic_pointer_cast<VscConverterInterfaceIIDM>(hvdc->getConverter2());
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
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_P1, 0.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_Q1, 0.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_P2, 0.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_Q2, 0.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE1, CLOSED);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE2, CLOSED);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc1->getVscIIDM().getTerminal().getP(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc1->getVscIIDM().getTerminal().getQ(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc2->getVscIIDM().getTerminal().getP(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc2->getVscIIDM().getTerminal().getQ(), 0.);
  ASSERT_TRUE(vsc1->getVscIIDM().getTerminal().isConnected());
  ASSERT_TRUE(vsc2->getVscIIDM().getTerminal().isConnected());
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_P1, 2.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_Q1, 4.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_P2, 6.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_Q2, 8.);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc1->getVscIIDM().getTerminal().getP(), -200.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc1->getVscIIDM().getTerminal().getQ(), -400.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc2->getVscIIDM().getTerminal().getP(), -600.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc2->getVscIIDM().getTerminal().getQ(), -800.);

  std::shared_ptr<BusInterfaceIIDM> bus = std::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("MyBus"));
  ASSERT_FALSE(bus->hasConnection());
  hvdc->hasDynamicModel(true);
  ASSERT_FALSE(bus->hasConnection());
  data->mapConnections();
  ASSERT_TRUE(bus->hasConnection());
  hvdc->hasDynamicModel(false);
  ASSERT_TRUE(bus->hasConnection());
}  // TEST(DataInterfaceIIDMTest, testConnectedHvdcLineVscConvertersIIDM)

TEST(DataInterfaceIIDMTest, testDisconnectedHvdcLineVscConvertersIIDM) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverterWithConnectedHvdc*/,
      false /*instantiateLccConverterWithDisconnectedHvdc*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverterWithConnectedHvdc*/,
      true /*instantiateVscConverterWithDisconnectedHvdc*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  std::shared_ptr<HvdcLineInterfaceIIDM> hvdc = std::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(data->findComponent("MyHvdcLine"));
  std::shared_ptr<VscConverterInterfaceIIDM> vsc1 = std::dynamic_pointer_cast<VscConverterInterfaceIIDM>(hvdc->getConverter1());
  std::shared_ptr<VscConverterInterfaceIIDM> vsc2 = std::dynamic_pointer_cast<VscConverterInterfaceIIDM>(hvdc->getConverter2());

  ASSERT_TRUE(std::isnan(vsc1->getVscIIDM().getTerminal().getP()));
  ASSERT_TRUE(std::isnan(vsc1->getVscIIDM().getTerminal().getQ()));
  ASSERT_TRUE(std::isnan(vsc2->getVscIIDM().getTerminal().getP()));
  ASSERT_TRUE(std::isnan(vsc2->getVscIIDM().getTerminal().getQ()));
  ASSERT_FALSE(vsc1->getVscIIDM().getTerminal().isConnected());
  ASSERT_FALSE(vsc2->getVscIIDM().getTerminal().isConnected());

  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE1, CLOSED);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE2, CLOSED);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc1->getVscIIDM().getTerminal().getP(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc1->getVscIIDM().getTerminal().getQ(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc2->getVscIIDM().getTerminal().getP(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(vsc2->getVscIIDM().getTerminal().getQ(), 0.);
  ASSERT_TRUE(vsc1->getVscIIDM().getTerminal().isConnected());
  ASSERT_TRUE(vsc2->getVscIIDM().getTerminal().isConnected());

  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE1, OPEN);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE2, OPEN);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_TRUE(std::isnan(vsc1->getVscIIDM().getTerminal().getP()));
  ASSERT_TRUE(std::isnan(vsc1->getVscIIDM().getTerminal().getQ()));
  ASSERT_TRUE(std::isnan(vsc2->getVscIIDM().getTerminal().getP()));
  ASSERT_TRUE(std::isnan(vsc2->getVscIIDM().getTerminal().getQ()));
  ASSERT_FALSE(vsc1->getVscIIDM().getTerminal().isConnected());
  ASSERT_FALSE(vsc2->getVscIIDM().getTerminal().isConnected());
}  // TEST(DataInterfaceIIDMTest, testDisconnectedHvdcLineVscConvertersIIDM)

TEST(DataInterfaceIIDMTest, testConnectedHvdcLineLccConvertersIIDM) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      true /*instantiateLccConverterWithConnectedHvdc*/,
      false /*instantiateLccConverterWithDisconnectedHvdc*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverterWithConnectedHvdc*/,
      false /*instantiateVscConverterWithDisconnectedHvdc*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
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

  std::shared_ptr<HvdcLineInterfaceIIDM> hvdc = std::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(data->findComponent("MyHvdcLine"));
  std::shared_ptr<LccConverterInterfaceIIDM> lcc1 = std::dynamic_pointer_cast<LccConverterInterfaceIIDM>(hvdc->getConverter1());
  std::shared_ptr<LccConverterInterfaceIIDM> lcc2 = std::dynamic_pointer_cast<LccConverterInterfaceIIDM>(hvdc->getConverter2());
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
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_P1, 0.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_Q1, 0.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_P2, 0.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_Q2, 0.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE1, CLOSED);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE2, CLOSED);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc1->getLccIIDM().getTerminal().getP(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc1->getLccIIDM().getTerminal().getQ(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc2->getLccIIDM().getTerminal().getP(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc2->getLccIIDM().getTerminal().getQ(), 0.);
  ASSERT_TRUE(lcc1->getLccIIDM().getTerminal().isConnected());
  ASSERT_TRUE(lcc2->getLccIIDM().getTerminal().isConnected());
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_P1, 2.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_Q1, 4.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_P2, 6.);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_Q2, 8.);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc1->getLccIIDM().getTerminal().getP(), -200.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc1->getLccIIDM().getTerminal().getQ(), -400.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc2->getLccIIDM().getTerminal().getP(), -600.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc2->getLccIIDM().getTerminal().getQ(), -800.);

  std::shared_ptr<BusInterfaceIIDM> bus = std::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("MyBus"));
  ASSERT_FALSE(bus->hasConnection());
  hvdc->hasDynamicModel(true);
  ASSERT_FALSE(bus->hasConnection());
  data->mapConnections();
  ASSERT_TRUE(bus->hasConnection());
  hvdc->hasDynamicModel(false);
  ASSERT_TRUE(bus->hasConnection());
}  // TEST(DataInterfaceIIDMTest, testConnectedHvdcLineLccConvertersIIDM)

TEST(DataInterfaceIIDMTest, testDisconnectedHvdcLineLccConvertersIIDM) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverterWithConnectedHvdc*/,
      true /*instantiateLccConverterWithDisconnectedHvdc*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverterWithConnectedHvdc*/,
      false /*instantiateVscConverterWithDisconnectedHvdc*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };

  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  std::shared_ptr<HvdcLineInterfaceIIDM> hvdc = std::dynamic_pointer_cast<HvdcLineInterfaceIIDM>(data->findComponent("MyHvdcLine"));
  std::shared_ptr<LccConverterInterfaceIIDM> lcc1 = std::dynamic_pointer_cast<LccConverterInterfaceIIDM>(hvdc->getConverter1());
  std::shared_ptr<LccConverterInterfaceIIDM> lcc2 = std::dynamic_pointer_cast<LccConverterInterfaceIIDM>(hvdc->getConverter2());

  ASSERT_TRUE(std::isnan(lcc1->getLccIIDM().getTerminal().getP()));
  ASSERT_TRUE(std::isnan(lcc1->getLccIIDM().getTerminal().getQ()));
  ASSERT_TRUE(std::isnan(lcc2->getLccIIDM().getTerminal().getP()));
  ASSERT_TRUE(std::isnan(lcc2->getLccIIDM().getTerminal().getQ()));
  ASSERT_FALSE(lcc1->getLccIIDM().getTerminal().isConnected());
  ASSERT_FALSE(lcc2->getLccIIDM().getTerminal().isConnected());

  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE1, CLOSED);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE2, CLOSED);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc1->getLccIIDM().getTerminal().getP(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc1->getLccIIDM().getTerminal().getQ(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc2->getLccIIDM().getTerminal().getP(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lcc2->getLccIIDM().getTerminal().getQ(), 0.);
  ASSERT_TRUE(lcc1->getLccIIDM().getTerminal().isConnected());
  ASSERT_TRUE(lcc2->getLccIIDM().getTerminal().isConnected());

  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE1, OPEN);
  hvdc->setValue(HvdcLineInterfaceIIDM::VAR_STATE2, OPEN);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_TRUE(std::isnan(lcc1->getLccIIDM().getTerminal().getP()));
  ASSERT_TRUE(std::isnan(lcc1->getLccIIDM().getTerminal().getQ()));
  ASSERT_TRUE(std::isnan(lcc2->getLccIIDM().getTerminal().getP()));
  ASSERT_TRUE(std::isnan(lcc2->getLccIIDM().getTerminal().getQ()));
  ASSERT_FALSE(lcc1->getLccIIDM().getTerminal().isConnected());
  ASSERT_FALSE(lcc2->getLccIIDM().getTerminal().isConnected());
}  // TEST(DataInterfaceIIDMTest, testDisconnectedHvdcLineLccConvertersIIDM)

TEST(DataInterfaceIIDMTest, testLineIIDM) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverterWithConnectedHvdc*/,
      false /*instantiateLccConverterWithDisconnectedHvdc*/,
      true /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverterWithConnectedHvdc*/,
      false /*instantiateVscConverterWithDisconnectedHvdc*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();

  ASSERT_THROW_DYNAWO(data->getStaticParameterDoubleValue("VL1_VL2", "p_pu"), Error::MODELER, KeyError_t::UnknownStaticParameter);
  ASSERT_EQ(data->getBusName("VL1_VL2", "@NODE1@"), "MyBus");
  ASSERT_EQ(data->getBusName("VL1_VL2", "@NODE2@"), "VL2_BUS1");

  powsybl::iidm::Line& lineIIDM = network.getLine("VL1_VL2");
  ASSERT_DOUBLE_EQUALS_DYNAWO(lineIIDM.getTerminal1().getP(), 22517.549846707054);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lineIIDM.getTerminal1().getQ(), -4501.348315393675);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lineIIDM.getTerminal2().getP(), 44982.491461969461);
  ASSERT_DOUBLE_EQUALS_DYNAWO(lineIIDM.getTerminal2().getQ(), -8998.1927452102718);
  ASSERT_TRUE(lineIIDM.getTerminal1().isConnected());
  ASSERT_TRUE(lineIIDM.getTerminal2().isConnected());
  std::shared_ptr<LineInterfaceIIDM> line = std::dynamic_pointer_cast<LineInterfaceIIDM>(data->findComponent("VL1_VL2"));
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

  std::shared_ptr<BusInterfaceIIDM> bus1 = std::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("MyBus"));
  std::shared_ptr<BusInterfaceIIDM> bus2 = std::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("VL2_BUS1"));
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

TEST(DataInterfaceIIDMTest, testLoadInterfaceIIDM) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverterWithConnectedHvdc*/,
      false /*instantiateLccConverterWithDisconnectedHvdc*/,
      false /*instantiateLine*/,
      true /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverterWithConnectedHvdc*/,
      false /*instantiateVscConverterWithDisconnectedHvdc*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
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
  std::shared_ptr<LoadInterfaceIIDM> load = std::dynamic_pointer_cast<LoadInterfaceIIDM>(data->findComponent("MyLoad"));
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
}  // TEST(DataInterfaceIIDMTest, testLoadInterfaceIIDM)

TEST(DataInterfaceIIDMTest, testShuntCompensatorIIDM) {
  const BusBreakerNetworkProperty properties = {
      true /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      false /*instantiateGenerator*/,
      false /*instantiateLccConverterWithConnectedHvdc*/,
      false /*instantiateLccConverterWithDisconnectedHvdc*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverterWithConnectedHvdc*/,
      false /*instantiateVscConverterWithDisconnectedHvdc*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
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
  ASSERT_EQ(shuntIIDM.getSectionCount(), 2UL);
  ASSERT_TRUE(shuntIIDM.getTerminal().isConnected());
  std::shared_ptr<ShuntCompensatorInterfaceIIDM> shunt =
      std::dynamic_pointer_cast<ShuntCompensatorInterfaceIIDM>(data->findComponent("MyCapacitorShuntCompensator"));
  shunt->setValue(ShuntCompensatorInterfaceIIDM::VAR_Q, 4.);
  shunt->setValue(ShuntCompensatorInterfaceIIDM::VAR_CURRENTSECTION, 1);
  shunt->setValue(ShuntCompensatorInterfaceIIDM::VAR_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(shuntIIDM.getTerminal().getQ(), 400.);
  ASSERT_EQ(shuntIIDM.getSectionCount(), 1);
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
    false /*instantiateLccConverterWithConnectedHvdc*/,
    false /*instantiateLccConverterWithDisconnectedHvdc*/,
    false /*instantiateLine*/,
    false /*instantiateLoad*/,
    false /*instantiateSwitch*/,
    false /*instantiateVscConverterWithConnectedHvdc*/,
    false /*instantiateVscConverterWithDisconnectedHvdc*/,
    false /*instantiateThreeWindingTransformer*/,
    false /*instantiateBattery*/
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
  std::shared_ptr<StaticVarCompensatorInterfaceIIDM> svc =
    std::dynamic_pointer_cast<StaticVarCompensatorInterfaceIIDM>(data->findComponent("MyStaticVarCompensator"));
  ASSERT_DOUBLE_EQUALS_DYNAWO(svcIIDM.getTerminal().getP(), 5.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svcIIDM.getTerminal().getQ(), 85.);
  ASSERT_TRUE(svcIIDM.getTerminal().isConnected());
  svc->setValue(StaticVarCompensatorInterfaceIIDM::VAR_P, 4.);
  svc->setValue(StaticVarCompensatorInterfaceIIDM::VAR_Q, 1);
  svc->setValue(StaticVarCompensatorInterfaceIIDM::VAR_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_DOUBLE_EQUALS_DYNAWO(svcIIDM.getTerminal().getP(), -400.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svcIIDM.getTerminal().getQ(), -100.);
  ASSERT_FALSE(svcIIDM.getTerminal().isConnected());
  svc->setValue(StaticVarCompensatorInterfaceIIDM::VAR_STATE, CLOSED);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_TRUE(svcIIDM.getTerminal().isConnected());
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
      false /*instantiateLccConverterWithConnectedHvdc*/,
      false /*instantiateLccConverterWithDisconnectedHvdc*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      true /*instantiateSwitch*/,
      false /*instantiateVscConverterWithConnectedHvdc*/,
      false /*instantiateVscConverterWithDisconnectedHvdc*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();
  ASSERT_EQ(data->getBusName("Sw", ""), "");

  powsybl::iidm::Switch& switchIIDM = network.getSwitch("Sw");
  ASSERT_FALSE(switchIIDM.isOpen());
  std::shared_ptr<SwitchInterfaceIIDM> sw = std::dynamic_pointer_cast<SwitchInterfaceIIDM>(data->findComponent("Sw"));
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
      false /*instantiateLccConverterWithConnectedHvdc*/,
      false /*instantiateLccConverterWithDisconnectedHvdc*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverterWithConnectedHvdc*/,
      false /*instantiateVscConverterWithDisconnectedHvdc*/,
      true /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "p1_pu"), 9.1056576660651096);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "p2_pu"), 1.1227046302116885);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "q1_pu"), -3.5651020975900325);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "q2_pu"), 12.931602063519245);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "p1"), 910.56576660651096);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "p2"), 112.27046302116885);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "q1"), -356.51020975900325);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "q2"), 1293.1602063519245);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "i1"), 9.778699018673759);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "i2"), 12.980246438951532);
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
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal1().getP(), 910.56576660651096);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal1().getQ(), -356.51020975900325);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal2().getP(), 112.27046302116885);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal2().getQ(), 1293.1602063519245);
  ASSERT_EQ(twoWTIIDM.getPhaseTapChanger().getTapPosition(), 2);
  ASSERT_TRUE(twoWTIIDM.getTerminal1().isConnected());
  ASSERT_TRUE(twoWTIIDM.getTerminal2().isConnected());
  std::shared_ptr<TwoWTransformerInterfaceIIDM> twoWT =
      std::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(data->findComponent("MyTransformer2Winding"));
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
  ASSERT_EQ(twoWTIIDM.getPhaseTapChanger().getTapPosition(), 1);
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
      false /*instantiateLccConverterWithConnectedHvdc*/,
      false /*instantiateLccConverterWithDisconnectedHvdc*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverterWithConnectedHvdc*/,
      false /*instantiateVscConverterWithDisconnectedHvdc*/,
      true /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();

  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "p1_pu"), 8.982839358453246);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "p2_pu"), 1.1459501635987903);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "q1_pu"), -3.5626432005015611);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "q2_pu"), 13.059301622068336);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "p1"), 898.2839358453246);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "p2"), 114.59501635987903);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "q1"), -356.26432005015611);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "q2"), 1305.9301622068336);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "i1"), 9.6635309030321181);
  ASSERT_DOUBLE_EQUALS_DYNAWO(data->getStaticParameterDoubleValue("MyTransformer2Winding", "i2"), 13.109483614300327);
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
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal1().getP(), 898.2839358453246);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal1().getQ(), -356.26432005015611);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal2().getP(), 114.59501635987903);
  ASSERT_DOUBLE_EQUALS_DYNAWO(twoWTIIDM.getTerminal2().getQ(), 1305.9301622068336);
  ASSERT_EQ(twoWTIIDM.getRatioTapChanger().getTapPosition(), 1);
  ASSERT_TRUE(twoWTIIDM.getTerminal1().isConnected());
  ASSERT_TRUE(twoWTIIDM.getTerminal2().isConnected());
  std::shared_ptr<TwoWTransformerInterfaceIIDM> twoWT =
      std::dynamic_pointer_cast<TwoWTransformerInterfaceIIDM>(data->findComponent("MyTransformer2Winding"));
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
  ASSERT_EQ(twoWTIIDM.getRatioTapChanger().getTapPosition(), 0);
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

  std::shared_ptr<BusInterfaceIIDM> bus1 = std::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("MyBus"));
  std::shared_ptr<BusInterfaceIIDM> bus2 = std::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("VL2_BUS1"));
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
      false /*instantiateLccConverterWithConnectedHvdc*/,
      false /*instantiateLccConverterWithDisconnectedHvdc*/,
      false /*instantiateLine*/,
      false /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverterWithConnectedHvdc*/,
      false /*instantiateVscConverterWithDisconnectedHvdc*/,
      true /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  std::shared_ptr<BusInterface> fictBus =
      std::dynamic_pointer_cast<BusInterface>(data->findComponent("MyTransformer3Winding_FictBUS"));
  std::shared_ptr<BusInterface> bus1 = std::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("MyBus"));
  std::shared_ptr<BusInterface> bus2 = std::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("VL2_BUS1"));
  std::shared_ptr<BusInterface> bus3 = std::dynamic_pointer_cast<BusInterfaceIIDM>(data->findComponent("VL3_BUS1"));
  std::vector<std::shared_ptr<VoltageLevelInterface> > Vls = data->getNetwork()->getVoltageLevels();
  std::string FictVLId = "MyTransformer3Winding_FictVL";
  auto it_vl = std::find_if(Vls.begin(), Vls.end(), [&FictVLId](std::shared_ptr<VoltageLevelInterface>& vl) {return vl->getID() == FictVLId;});
  ASSERT_TRUE(it_vl != Vls.end());
  powsybl::iidm::Network& network = data->getNetworkIIDM();
  powsybl::iidm::ThreeWindingsTransformer& threeWTIIDM = network.getThreeWindingsTransformer("MyTransformer3Winding");
  std::string FictTwoWTransf1_Id = "MyTransformer3Winding_1";
  std::string FictTwoWTransf2_Id = "MyTransformer3Winding_2";
  std::string FictTwoWTransf3_Id = "MyTransformer3Winding_3";
  std::shared_ptr<TwoWTransformerInterface> FictTwoWTransf1 =
      std::dynamic_pointer_cast<TwoWTransformerInterface>(data->findComponent(FictTwoWTransf1_Id));
  std::shared_ptr<TwoWTransformerInterface> FictTwoWTransf2 =
      std::dynamic_pointer_cast<TwoWTransformerInterface>(data->findComponent(FictTwoWTransf2_Id));
  std::shared_ptr<TwoWTransformerInterface> FictTwoWTransf3 =
      std::dynamic_pointer_cast<TwoWTransformerInterface>(data->findComponent(FictTwoWTransf3_Id));

  ASSERT_EQ(data->getBusName(FictTwoWTransf1_Id, "@NODE1@"), "MyTransformer3Winding_FictBUS");
  ASSERT_EQ(data->getBusName(FictTwoWTransf1_Id, "@NODE2@"), "MyBus");
  ASSERT_EQ(data->getBusName(FictTwoWTransf2_Id, "@NODE1@"), "MyTransformer3Winding_FictBUS");
  ASSERT_EQ(data->getBusName(FictTwoWTransf2_Id, "@NODE2@"), "VL2_BUS1");
  ASSERT_EQ(data->getBusName(FictTwoWTransf3_Id, "@NODE1@"), "MyTransformer3Winding_FictBUS");
  ASSERT_EQ(data->getBusName(FictTwoWTransf3_Id, "@NODE2@"), "VL3_BUS1");
  double VNomLeg1 = threeWTIIDM.getLeg1().getTerminal().getVoltageLevel().getNominalV();
  double VNomLeg2 = threeWTIIDM.getLeg2().getTerminal().getVoltageLevel().getNominalV();
  double VNomLeg3 = threeWTIIDM.getLeg3().getTerminal().getVoltageLevel().getNominalV();
  double VRebase1 = VNomLeg1 * VNomLeg1 / (threeWTIIDM.getRatedU0() * threeWTIIDM.getRatedU0());
  double VRebase2 = VNomLeg2 * VNomLeg2 / (threeWTIIDM.getRatedU0() * threeWTIIDM.getRatedU0());
  double VRebase3 = VNomLeg3 * VNomLeg3 / (threeWTIIDM.getRatedU0() * threeWTIIDM.getRatedU0());
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf1->getR(), threeWTIIDM.getLeg1().getR() * VRebase1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf1->getX(), threeWTIIDM.getLeg1().getX() * VRebase1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf1->getG(), threeWTIIDM.getLeg1().getG() * VRebase1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf1->getB(), threeWTIIDM.getLeg1().getB() * VRebase1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf1->getRatedU1(), threeWTIIDM.getRatedU0());
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf1->getRatedU2(), threeWTIIDM.getLeg1().getRatedU());

  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf2->getR(), threeWTIIDM.getLeg2().getR() * VRebase2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf2->getX(), threeWTIIDM.getLeg2().getX() * VRebase2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf2->getG(), threeWTIIDM.getLeg2().getG() * VRebase2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf2->getB(), threeWTIIDM.getLeg2().getB() * VRebase2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf2->getRatedU1(), threeWTIIDM.getRatedU0());
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf2->getRatedU2(), threeWTIIDM.getLeg2().getRatedU());

  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf3->getR(), threeWTIIDM.getLeg3().getR() * VRebase3);
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf3->getX(), threeWTIIDM.getLeg3().getX() * VRebase3);
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf3->getG(), threeWTIIDM.getLeg3().getG() * VRebase3);
  ASSERT_DOUBLE_EQUALS_DYNAWO(FictTwoWTransf3->getB(), threeWTIIDM.getLeg3().getB() * VRebase3);
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
      false /*instantiateLccConverterWithConnectedHvdc*/,
      false /*instantiateLccConverterWithDisconnectedHvdc*/,
      false /*instantiateLine*/,
      true /*instantiateLoad*/,
      false /*instantiateSwitch*/,
      false /*instantiateVscConverterWithConnectedHvdc*/,
      false /*instantiateVscConverterWithDisconnectedHvdc*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };
  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);

  std::shared_ptr<LoadInterface> loadItf = data->getNetwork()->getVoltageLevels()[0]->getLoads()[0];
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
  auto network = createNodeBreakerNetworkIIDM();

  shared_ptr<DataInterfaceIIDM> dataOutput = createDataItfFromNetwork(createNodeBreakerNetworkIIDM());
  ASSERT_NO_THROW(dataOutput->dumpToFile("network.xml"));
  const powsybl::iidm::Network& outputNetwork = dataOutput->getNetworkIIDM();
  ASSERT_THROW_DYNAWO(dataOutput->dumpToFile(".."), Error::GENERAL, KeyError_t::XmlFileParsingError);

  shared_ptr<DataInterface> dataInput = DataInterfaceIIDM::build("network.xml");
  shared_ptr<DataInterfaceIIDM> dataInputIIDM = boost::dynamic_pointer_cast<DataInterfaceIIDM>(dataInput);
  const powsybl::iidm::Network& inputNetwork = dataInputIIDM->getNetworkIIDM();

  ASSERT_EQ(outputNetwork.getId(), inputNetwork.getId());
  ASSERT_EQ(outputNetwork.getId(), network->getId());
  ASSERT_EQ(inputNetwork.getId(), network->getId());
}

TEST(DataInterfaceIIDMTest, testClone) {
  auto network = createNodeBreakerNetworkIIDM();

  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(network);
  shared_ptr<DataInterfaceIIDM> data2 = boost::dynamic_pointer_cast<DataInterfaceIIDM>(data->clone());

  ASSERT_TRUE(data);
  ASSERT_NE(data, data2);
  ASSERT_NE(data->getServiceManager(), data2->getServiceManager());

  ASSERT_EQ(data->getNetworkIIDM().getId(), data2->getNetworkIIDM().getId());

  boost::shared_ptr<NetworkInterfaceIIDM> network_interface = boost::dynamic_pointer_cast<NetworkInterfaceIIDM>(data->getNetwork());
  boost::shared_ptr<NetworkInterfaceIIDM> network_interface2 = boost::dynamic_pointer_cast<NetworkInterfaceIIDM>(data2->getNetwork());
  ASSERT_NE(network_interface, network_interface2);
  ASSERT_EQ(network_interface->getLines().size(), network_interface2->getLines().size());

  ASSERT_EQ(network_interface->getVoltageLevels().size(), network_interface2->getVoltageLevels().size());
  for (unsigned int i = 0; i < network_interface->getVoltageLevels().size(); i++) {
    ASSERT_NE(network_interface->getVoltageLevels().at(i), network_interface2->getVoltageLevels().at(i));
    ASSERT_EQ(std::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(network_interface->getVoltageLevels().at(i))->getID(),
              std::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(network_interface2->getVoltageLevels().at(i))->getID());
    ASSERT_EQ(std::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(network_interface->getVoltageLevels().at(i))->getVNom(),
              std::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(network_interface2->getVoltageLevels().at(i))->getVNom());
    ASSERT_EQ(std::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(network_interface->getVoltageLevels().at(i))->getVoltageLevelTopologyKind(),
              std::dynamic_pointer_cast<VoltageLevelInterfaceIIDM>(network_interface2->getVoltageLevels().at(i))->getVoltageLevelTopologyKind());

    const std::vector<std::shared_ptr<LoadInterface> >& loads = network_interface->getVoltageLevels().at(i)->getLoads();
    const std::vector<std::shared_ptr<LoadInterface> >& loads2 = network_interface2->getVoltageLevels().at(i)->getLoads();
    ASSERT_EQ(loads.size(), loads2.size());
    for (unsigned int j = 0; j < loads.size(); j++) {
      ASSERT_EQ(std::dynamic_pointer_cast<LoadInterfaceIIDM>(loads[j])->getInitialConnected(),
                std::dynamic_pointer_cast<LoadInterfaceIIDM>(loads2[j])->getInitialConnected());
      ASSERT_EQ(std::dynamic_pointer_cast<LoadInterfaceIIDM>(loads[j])->getP(), std::dynamic_pointer_cast<LoadInterfaceIIDM>(loads2[j])->getP());
      ASSERT_EQ(std::dynamic_pointer_cast<LoadInterfaceIIDM>(loads[j])->getP0(), std::dynamic_pointer_cast<LoadInterfaceIIDM>(loads2[j])->getP0());
      ASSERT_EQ(std::dynamic_pointer_cast<LoadInterfaceIIDM>(loads[j])->getQ(), std::dynamic_pointer_cast<LoadInterfaceIIDM>(loads2[j])->getQ());
      ASSERT_EQ(std::dynamic_pointer_cast<LoadInterfaceIIDM>(loads[j])->getQ0(), std::dynamic_pointer_cast<LoadInterfaceIIDM>(loads2[j])->getQ0());
      ASSERT_EQ(std::dynamic_pointer_cast<LoadInterfaceIIDM>(loads[j])->getID(), std::dynamic_pointer_cast<LoadInterfaceIIDM>(loads2[j])->getID());
      ASSERT_EQ(std::dynamic_pointer_cast<LoadInterfaceIIDM>(loads[j])->getPUnderVoltage(),
                std::dynamic_pointer_cast<LoadInterfaceIIDM>(loads2[j])->getPUnderVoltage());
      ASSERT_EQ(std::dynamic_pointer_cast<LoadInterfaceIIDM>(loads[j])->getCountry(),
                std::dynamic_pointer_cast<LoadInterfaceIIDM>(loads2[j])->getCountry());
    }
    const std::vector<std::shared_ptr<DYN::BusInterface> >& buses = network_interface->getVoltageLevels().at(i)->getBuses();
    const std::vector<std::shared_ptr<DYN::BusInterface> >& buses2 = network_interface2->getVoltageLevels().at(i)->getBuses();
    ASSERT_EQ(buses.size(), buses2.size());
    for (unsigned int j = 0; j < buses.size(); j++) {
      const std::vector<std::string>& ids = buses[j]->getBusBarSectionIdentifiers();
      const std::vector<std::string>& ids2 = buses2[j]->getBusBarSectionIdentifiers();
      ASSERT_EQ(ids.size(), ids2.size());
      for (unsigned k = 0; k < ids.size(); k++) {
        ASSERT_EQ(ids[k], ids2[k]);
      }
    }
    const std::vector<std::shared_ptr<DYN::SwitchInterface> >& switches = network_interface->getVoltageLevels().at(i)->getSwitches();
    const std::vector<std::shared_ptr<DYN::SwitchInterface> >& switches2 = network_interface2->getVoltageLevels().at(i)->getSwitches();
    ASSERT_EQ(switches.size(), switches2.size());
    for (unsigned int j = 0; j < switches.size(); j++) {
      ASSERT_EQ(switches[j]->getID(), switches2[j]->getID());
    }
  }
  ASSERT_EQ(network_interface->getTwoWTransformers().size(), network_interface2->getTwoWTransformers().size());
  ASSERT_EQ(network_interface->getThreeWTransformers().size(), network_interface2->getThreeWTransformers().size());
}

TEST(DataInterfaceIIDMTest, testMultiThreading) {
  auto network = createNodeBreakerNetworkIIDM();

  shared_ptr<DataInterfaceIIDM> dataOutput = createDataItfFromNetwork(createNodeBreakerNetworkIIDM());
  ASSERT_NO_THROW(dataOutput->dumpToFile("network.xml"));
  const powsybl::iidm::Network& outputNetwork = dataOutput->getNetworkIIDM();
  ASSERT_THROW_DYNAWO(dataOutput->dumpToFile(".."), Error::GENERAL, KeyError_t::XmlFileParsingError);

  shared_ptr<DataInterface> dataInput = DataInterfaceIIDM::build("network.xml");
  ASSERT_FALSE(dataInput->canUseVariant());
  dataInput = DataInterfaceIIDM::build("network.xml", 2);
  ASSERT_TRUE(dataInput->canUseVariant());
  shared_ptr<DataInterfaceIIDM> dataInputIIDM = boost::dynamic_pointer_cast<DataInterfaceIIDM>(dataInput);
  powsybl::iidm::Network& inputNetwork = dataInputIIDM->getNetworkIIDM();

  ASSERT_EQ(outputNetwork.getId(), inputNetwork.getId());
  ASSERT_EQ(outputNetwork.getId(), network->getId());
  ASSERT_EQ(inputNetwork.getId(), network->getId());

  auto& load = inputNetwork.getLoad("MyLoad");

  std::thread launch0([&dataInput, &load](){
    dataInput->selectVariant("0");
    load.setP0(3.0);
    load.setQ0(5.0);
  });
  std::thread launch1([&dataInput, &load](){
    dataInput->selectVariant("1");
    load.setP0(2.0);
    load.setQ0(4.0);
  });

  launch0.join();
  launch1.join();

  dataInput->selectVariant("0");
  ASSERT_EQ(load.getP0(), 3.0);
  ASSERT_EQ(load.getQ0(), 5.0);

  dataInput->selectVariant("1");
  ASSERT_EQ(load.getP0(), 2.0);
  ASSERT_EQ(load.getQ0(), 4.0);
}

TEST(DataInterfaceIIDMTest, testFindLostEquipments) {
  const BusBreakerNetworkProperty properties = {
      false /*instantiateCapacitorShuntCompensator*/,
      false /*instantiateStaticVarCompensator*/,
      false /*instantiateTwoWindingTransformer*/,
      false /*instantiateRatioTapChanger*/,
      false /*instantiatePhaseTapChanger*/,
      false /*instantiateDanglingLine*/,
      true /*instantiateGenerator*/,
      false /*instantiateLccConverterWithConnectedHvdc*/,
      false /*instantiateLccConverterWithDisconnectedHvdc*/,
      false /*instantiateLine*/,
      true /*instantiateLoad*/,
      true /*instantiateSwitch*/,
      false /*instantiateVscConverterWithConnectedHvdc*/,
      false /*instantiateVscConverterWithDisconnectedHvdc*/,
      false /*instantiateThreeWindingTransformer*/,
      false /*instantiateBattery*/
  };

  shared_ptr<DataInterfaceIIDM> data = createDataItfFromNetwork(createBusBreakerNetwork(properties));
  exportStateVariables(data);
  powsybl::iidm::Network& network = data->getNetworkIIDM();

  std::shared_ptr<std::vector<std::shared_ptr<ComponentInterface> > > connectedComponents = data->findConnectedComponents();
  ASSERT_EQ(connectedComponents->size(), 3);
  std::shared_ptr<lostEquipments::LostEquipmentsCollection> lostEquipments = data->findLostEquipments(connectedComponents);
  ASSERT_TRUE(lostEquipments->cbegin() == lostEquipments->cend());

  std::shared_ptr<GeneratorInterfaceIIDM> gen = std::dynamic_pointer_cast<GeneratorInterfaceIIDM>(data->findComponent("MyGenerator"));
  powsybl::iidm::Generator& genIIDM = network.getGenerator("MyGenerator");
  gen->setValue(GeneratorInterfaceIIDM::VAR_STATE, OPEN);
  data->exportStateVariablesNoReadFromModel();
  ASSERT_FALSE(genIIDM.getTerminal().isConnected());

  lostEquipments = data->findLostEquipments(connectedComponents);
  ASSERT_TRUE(lostEquipments->cbegin() != lostEquipments->cend());
  lostEquipments::LostEquipmentsCollection::LostEquipmentsCollectionConstIterator itLostEquipment = lostEquipments->cbegin();
  ASSERT_TRUE(++itLostEquipment == lostEquipments->cend());
  connectedComponents = data->findConnectedComponents();
  ASSERT_EQ(connectedComponents->size(), 2);
}
}  // namespace DYN
