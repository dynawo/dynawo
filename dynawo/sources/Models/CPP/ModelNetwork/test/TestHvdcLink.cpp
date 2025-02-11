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

#include <boost/shared_ptr.hpp>
#include <boost/algorithm/string/replace.hpp>

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>
#include <powsybl/iidm/TopologyKind.hpp>
#include <powsybl/iidm/HvdcLine.hpp>
#include <powsybl/iidm/HvdcLineAdder.hpp>
#include <powsybl/iidm/LccConverterStation.hpp>
#include <powsybl/iidm/LccConverterStationAdder.hpp>
#include <powsybl/iidm/VscConverterStation.hpp>
#include <powsybl/iidm/VscConverterStationAdder.hpp>

#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNVscConverterInterfaceIIDM.h"
#include "DYNLccConverterInterfaceIIDM.h"
#include "DYNBusInterfaceIIDM.h"
#include "DYNModelVoltageLevel.h"
#include "DYNNetworkInterfaceIIDM.h"
#include "DYNHvdcLineInterfaceIIDM.h"
#include "DYNModelVoltageLevel.h"
#include "DYNModelBus.h"
#include "DYNModelNetwork.h"
#include "TLTimelineFactory.h"
#include "DYNSparseMatrix.h"
#include "DYNVariable.h"
#include "DYNVariableAlias.h"
#include "CSTRConstraintsCollectionFactory.h"
#include "CSTRConstraintsCollection.h"
#include "CSTRConstraint.h"

#include "DYNModelHvdcLink.h"
#include "make_unique.hpp"
#include "gtest_dynawo.h"

using boost::shared_ptr;

#define VSC true
#define LCC false
namespace DYN {
static std::tuple<std::shared_ptr<ModelHvdcLink>, std::shared_ptr<NetworkInterfaceIIDM>,
std::shared_ptr<ModelVoltageLevel> >  // need to return the voltage level so that it is not destroyed
createModelHvdcLink(bool initModel, bool withVsc, powsybl::iidm::Network& networkIIDM, bool withP = true, bool withQ = true) {
  powsybl::iidm::Substation& s = networkIIDM.newSubstation()
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
              .setId("MyBus1")
              .add();
  iidmBus.setV(100);
  iidmBus.setAngle(90.);

  powsybl::iidm::Bus& iidmBus2 = vlIIDM.getBusBreakerView().newBus()
              .setId("MyBus2")
              .add();
  iidmBus2.setV(100);
  iidmBus2.setAngle(90.);

  if (withVsc) {
    powsybl::iidm::VscConverterStation& vsc = vlIIDM.newVscConverterStation()
        .setId("MyVscConverterStation")
        .setName("MyVscConverterStation_NAME")
        .setBus(iidmBus.getId())
        .setConnectableBus(iidmBus.getId())
        .setLossFactor(3.0)
        .setVoltageRegulatorOn(true)
        .setVoltageSetpoint(1.2)
        .setReactivePowerSetpoint(-1.5)
        .add();
    vsc.newMinMaxReactiveLimits().setMinQ(1.).setMaxQ(2.).add();
    if (withP)
      vsc.getTerminal().setP(2.);
    if (withQ)
      vsc.getTerminal().setQ(3.);

    powsybl::iidm::VscConverterStation& vsc2 = vlIIDM.newVscConverterStation()
        .setId("MyVscConverterStation2")
        .setName("MyVscConverterStation2_NAME")
        .setBus(iidmBus.getId())
        .setConnectableBus(iidmBus.getId())
        .setLossFactor(3.0)
        .setVoltageRegulatorOn(true)
        .setVoltageSetpoint(1.2)
        .setReactivePowerSetpoint(-1.5)
        .add();
    vsc2.newMinMaxReactiveLimits().setMinQ(1.).setMaxQ(2.).add();
    if (withP)
      vsc2.getTerminal().setP(2.);
    if (withQ)
      vsc2.getTerminal().setQ(3.);

    networkIIDM.newHvdcLine()
        .setId("MyHvdcLine")
        .setName("MyHvdcLine_NAME")
        .setConvertersMode(powsybl::iidm::HvdcLine::ConvertersMode::SIDE_1_RECTIFIER_SIDE_2_INVERTER)
        .setConverterStationId1("MyVscConverterStation")
        .setConverterStationId2("MyVscConverterStation2")
        .setMaxP(12.0)
        .setNominalV(13.0)
        .setR(14.0)
        .setActivePowerSetpoint(111.1)
        .add();
  } else {
    powsybl::iidm::LccConverterStation& lcc = vlIIDM.newLccConverterStation()
        .setId("MyLccConverter")
        .setName("MyLccConverter_NAME")
        .setBus(iidmBus.getId())
        .setConnectableBus(iidmBus.getId())
        .setLossFactor(2.0)
        .setPowerFactor(-.2)
        .add();
    if (withP)
      lcc.getTerminal().setP(2.);
    if (withQ)
      lcc.getTerminal().setQ(3.);
    powsybl::iidm::LccConverterStation& lcc2 = vlIIDM.newLccConverterStation()
        .setId("MyLccConverter2")
        .setName("MyLccConverter2_NAME")
        .setBus(iidmBus.getId())
        .setConnectableBus(iidmBus.getId())
        .setLossFactor(2.0)
        .setPowerFactor(-.2)
        .add();
    if (withP)
      lcc2.getTerminal().setP(2.);
    if (withQ)
      lcc2.getTerminal().setQ(3.);

    networkIIDM.newHvdcLine()
        .setId("MyHvdcLine")
        .setName("MyHvdcLine_NAME")
        .setConvertersMode(powsybl::iidm::HvdcLine::ConvertersMode::SIDE_1_RECTIFIER_SIDE_2_INVERTER)
        .setConverterStationId1("MyLccConverter")
        .setConverterStationId2("MyLccConverter2")
        .setMaxP(12.0)
        .setNominalV(13.0)
        .setR(14.0)
        .setActivePowerSetpoint(111.1)
        .add();
  }
  std::shared_ptr<NetworkInterfaceIIDM> networkItfIIDM = std::make_shared<NetworkInterfaceIIDM>(networkIIDM);
  std::shared_ptr<VoltageLevelInterfaceIIDM> vlItfIIDM = std::make_shared<VoltageLevelInterfaceIIDM>(vlIIDM);
  std::shared_ptr<BusInterfaceIIDM> bus1ItfIIDM = std::make_shared<BusInterfaceIIDM>(iidmBus);
  std::shared_ptr<BusInterfaceIIDM> bus2ItfIIDM = std::make_shared<BusInterfaceIIDM>(iidmBus2);
  vlItfIIDM->addBus(bus1ItfIIDM);
  vlItfIIDM->addBus(bus2ItfIIDM);
  std::shared_ptr<ModelVoltageLevel> vl = std::make_shared<ModelVoltageLevel>(vlItfIIDM);

  ModelNetwork* network = new ModelNetwork();
  network->setIsInitModel(initModel);
  std::unique_ptr<constraints::ConstraintsCollection> constraints =
      constraints::ConstraintsCollectionFactory::newInstance("MyConstraintsCollection");
  network->setTimeline(timeline::TimelineFactory::newInstance("Test"));
  network->setConstraints(std::move(constraints));
  std::shared_ptr<ModelHvdcLink> hvdc;
  std::shared_ptr<HvdcLineInterfaceIIDM> hvdcItfIIDM;
  if (withVsc) {
    for (auto& vscConverterIIDM : vlIIDM.getVscConverterStations()) {
      std::unique_ptr<VscConverterInterfaceIIDM> vsc = DYN::make_unique<VscConverterInterfaceIIDM>(vscConverterIIDM);
      vsc->setVoltageLevelInterface(vlItfIIDM);
      vsc->setBusInterface(bus1ItfIIDM);
      vlItfIIDM->addVscConverter(std::move(vsc));
    }
    const std::vector<std::shared_ptr<VscConverterInterface> >& vscConverters = vlItfIIDM->getVscConverters();
    hvdcItfIIDM = std::make_shared<HvdcLineInterfaceIIDM>(networkIIDM.getHvdcLine("MyHvdcLine"), vscConverters[0], vscConverters[1]);
    hvdc = std::make_shared<ModelHvdcLink>(hvdcItfIIDM);
  } else {
    for (auto& lccConverterIIDM : vlIIDM.getLccConverterStations()) {
      std::unique_ptr<LccConverterInterfaceIIDM> lcc = DYN::make_unique<LccConverterInterfaceIIDM>(lccConverterIIDM);
      lcc->setVoltageLevelInterface(vlItfIIDM);
      lcc->setBusInterface(bus1ItfIIDM);
      vlItfIIDM->addLccConverter(std::move(lcc));
    }
    const std::vector<std::shared_ptr<LccConverterInterface> >& lccConverters = vlItfIIDM->getLccConverters();
    hvdcItfIIDM = std::make_shared<HvdcLineInterfaceIIDM>(networkIIDM.getHvdcLine("MyHvdcLine"), lccConverters[0], lccConverters[1]);
    hvdc = std::make_shared<ModelHvdcLink>(hvdcItfIIDM);
  }
  networkItfIIDM->addHvdcLine(hvdcItfIIDM);
  hvdc->setNetwork(network);
  std::shared_ptr<ModelBus> bus1 = std::make_shared<ModelBus>(bus1ItfIIDM, false);
  bus1->setNetwork(network);
  bus1->initSize();
  vl->addBus(bus1);
  // There is a memory leak here, but whatever ...
  double* y1 = new double[bus1->sizeY()];
  double* yp1 = new double[bus1->sizeY()];
  double* f1 = new double[bus1->sizeF()];
  double* z1 = new double[bus1->sizeZ()];
  bool* zConnected1 = new bool[bus1->sizeZ()];
  for (int i = 0; i < bus1->sizeZ(); ++i)
    zConnected1[i] = true;
  bus1->setReferenceZ(&z1[0], zConnected1, 0);
  bus1->setReferenceY(y1, yp1, f1, 0, 0);
  y1[ModelBus::urNum_] = 3.5;
  y1[ModelBus::uiNum_] = 2;
  if (!initModel)
    z1[ModelBus::switchOffNum_] = -1;
  int offset = 0;
  bus1->init(offset);
  bus1->setVoltageLevel(vl);
  std::unique_ptr<ModelBus> bus2 = DYN::make_unique<ModelBus>(bus2ItfIIDM, false);
  bus2->setNetwork(network);
  bus2->initSize();
  // There is a memory leak here, but whatever ...
  double* y2 = new double[bus2->sizeY()];
  double* yp2 = new double[bus2->sizeY()];
  double* f2 = new double[bus2->sizeF()];
  double* z2 = new double[bus2->sizeZ()];
  bool* zConnected2 = new bool[bus2->sizeZ()];
  for (int i = 0; i < bus2->sizeZ(); ++i)
    zConnected2[i] = true;
  bus2->setReferenceZ(&z2[0], zConnected2, 0);
  bus2->setReferenceY(y2, yp2, f2, 0, 0);
  y2[ModelBus::urNum_] = 5.;
  y2[ModelBus::uiNum_] = 2.5;
  if (!initModel)
    z2[ModelBus::switchOffNum_] = -1;
  bus2->init(offset);
  bus2->setVoltageLevel(vl);
  hvdc->setModelBus1(bus1);
  hvdc->setModelBus2(std::move(bus2));
  return std::tuple<std::shared_ptr<ModelHvdcLink>, std::shared_ptr<NetworkInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> >(hvdc, networkItfIIDM, vl);
}

static void
fillParameters(const std::shared_ptr<ModelHvdcLink>& hvdc, std::string& startingPoint) {
  std::unordered_map<std::string, ParameterModeler> parametersModels;
  {
    ParameterModeler param = ParameterModeler("startingPointMode", VAR_TYPE_STRING, EXTERNAL_PARAMETER);
    param.setValue<std::string>(startingPoint, PAR);
    parametersModels.insert(std::make_pair(param.getName(), param));
  }
  hvdc->setSubModelParameters(parametersModels);
}

TEST(ModelsModelNetwork, ModelNetworkHvdcLinkInitializationVCS) {
  powsybl::iidm::Network networkIIDM("MyNetwork", "MyNetwork");
  std::tuple<std::shared_ptr<ModelHvdcLink>, std::shared_ptr<NetworkInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p
      = createModelHvdcLink(false, VSC, networkIIDM);
  std::shared_ptr<ModelHvdcLink> hvdc = std::get<0>(p);
  int offSet = 0;
  hvdc->init(offSet);
  ASSERT_EQ(hvdc->id(), "MyHvdcLine");
  ASSERT_TRUE(hvdc->isConnected1());
  ASSERT_TRUE(hvdc->isConnected2());
  ASSERT_EQ(hvdc->getConnected1(), CLOSED);
  ASSERT_EQ(hvdc->getConnected2(), CLOSED);
}

TEST(ModelsModelNetwork, ModelNetworkHvdcLinkInitializationVCSNoPNoQ) {
  powsybl::iidm::Network networkIIDM("MyNetwork", "MyNetwork");
  std::tuple<std::shared_ptr<ModelHvdcLink>, std::shared_ptr<NetworkInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p
      = createModelHvdcLink(false, VSC, networkIIDM, false, false);
  std::shared_ptr<ModelHvdcLink> hvdc = std::get<0>(p);
  int offSet = 0;
  hvdc->init(offSet);
  ASSERT_EQ(hvdc->id(), "MyHvdcLine");
  ASSERT_TRUE(hvdc->isConnected1());
  ASSERT_TRUE(hvdc->isConnected2());
  ASSERT_EQ(hvdc->getConnected1(), CLOSED);
  ASSERT_EQ(hvdc->getConnected2(), CLOSED);
}

TEST(ModelsModelNetwork, ModelNetworkHvdcLinkInitializationLCC) {
  powsybl::iidm::Network networkIIDM("MyNetwork", "MyNetwork");
  std::tuple<std::shared_ptr<ModelHvdcLink>, std::shared_ptr<NetworkInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p
      = createModelHvdcLink(false, LCC, networkIIDM);
  std::shared_ptr<ModelHvdcLink> hvdc = std::get<0>(p);
  int offSet = 0;
  hvdc->init(offSet);
  ASSERT_EQ(hvdc->id(), "MyHvdcLine");
  ASSERT_TRUE(hvdc->isConnected1());
  ASSERT_TRUE(hvdc->isConnected2());
  ASSERT_EQ(hvdc->getConnected1(), CLOSED);
  ASSERT_EQ(hvdc->getConnected2(), CLOSED);
}

TEST(ModelsModelNetwork, ModelNetworkHvdcLinkInitializationLCCNoPNoQ) {
  powsybl::iidm::Network networkIIDM("MyNetwork", "MyNetwork");
  std::tuple<std::shared_ptr<ModelHvdcLink>, std::shared_ptr<NetworkInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p
      = createModelHvdcLink(false, LCC, networkIIDM, false, false);
  std::shared_ptr<ModelHvdcLink> hvdc = std::get<0>(p);
  int offSet = 0;
  hvdc->init(offSet);
  ASSERT_EQ(hvdc->id(), "MyHvdcLine");
  ASSERT_TRUE(hvdc->isConnected1());
  ASSERT_TRUE(hvdc->isConnected2());
  ASSERT_EQ(hvdc->getConnected1(), CLOSED);
  ASSERT_EQ(hvdc->getConnected2(), CLOSED);
}

TEST(ModelsModelNetwork, ModelNetworkHvdcLinkCalculatedVariablesFlat) {
  powsybl::iidm::Network networkIIDM("MyNetwork", "MyNetwork");
  std::tuple<std::shared_ptr<ModelHvdcLink>, std::shared_ptr<NetworkInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p
      = createModelHvdcLink(false, VSC, networkIIDM);
  std::shared_ptr<ModelHvdcLink> hvdc = std::get<0>(p);
  int offSet = 0;
  std::string startingPoint = "flat";
  fillParameters(hvdc, startingPoint);
  hvdc->init(offSet);
  hvdc->initSize();
  std::vector<double> y(hvdc->sizeY(), 0.);
  std::vector<double> yp(hvdc->sizeY(), 0.);
  std::vector<double> f(hvdc->sizeF(), 0.);
  std::vector<double> z(hvdc->sizeZ(), 0.);
  bool* zConnected = new bool[hvdc->sizeZ()];
  for (int i = 0; i < hvdc->sizeZ(); ++i)
    zConnected[i] = true;
  hvdc->setReferenceZ(&z[0], zConnected, 0);
  hvdc->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  ASSERT_EQ(hvdc->sizeCalculatedVar(), ModelHvdcLink::nbCalculatedVariables_);

  std::vector<double> calculatedVars(ModelHvdcLink::nbCalculatedVariables_, 0.);
  hvdc->setReferenceCalculatedVar(&calculatedVars[0], 0);
  hvdc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelHvdcLink::p1Num_], -1.111);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelHvdcLink::q1Num_], -0.015);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelHvdcLink::p2Num_], -8.87305);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelHvdcLink::q2Num_], -0.015);
}


TEST(ModelsModelNetwork, ModelNetworkHvdcLinkCalculatedVariables) {
  powsybl::iidm::Network networkIIDM("MyNetwork", "MyNetwork");
  std::tuple<std::shared_ptr<ModelHvdcLink>, std::shared_ptr<NetworkInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p
      = createModelHvdcLink(false, VSC, networkIIDM);
  std::shared_ptr<ModelHvdcLink> hvdc = std::get<0>(p);
  int offSet = 0;
  hvdc->init(offSet);
  hvdc->initSize();
  std::vector<double> y(hvdc->sizeY(), 0.);
  std::vector<double> yp(hvdc->sizeY(), 0.);
  std::vector<double> f(hvdc->sizeF(), 0.);
  std::vector<double> z(hvdc->sizeZ(), 0.);
  bool* zConnected = new bool[hvdc->sizeZ()];
  for (int i = 0; i < hvdc->sizeZ(); ++i)
    zConnected[i] = true;
  hvdc->setReferenceZ(&z[0], zConnected, 0);
  hvdc->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  ASSERT_EQ(hvdc->sizeCalculatedVar(), ModelHvdcLink::nbCalculatedVariables_);

  std::vector<double> calculatedVars(ModelHvdcLink::nbCalculatedVariables_, 0.);
  hvdc->setReferenceCalculatedVar(&calculatedVars[0], 0);
  hvdc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelHvdcLink::p1Num_], -0.02);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelHvdcLink::q1Num_], -0.029999999999999999);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelHvdcLink::p2Num_], -0.02);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelHvdcLink::q2Num_], -0.029999999999999999);
  std::vector<double> yI(2, 0.);
  yI[0] = 0.35;
  yI[1] = 0.02;
  ASSERT_DOUBLE_EQUALS_DYNAWO(hvdc->evalCalculatedVarI(ModelHvdcLink::p1Num_), calculatedVars[ModelHvdcLink::p1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(hvdc->evalCalculatedVarI(ModelHvdcLink::q1Num_), calculatedVars[ModelHvdcLink::q1Num_]);
  yI[0] = 5;
  yI[1] = 2.5;
  ASSERT_DOUBLE_EQUALS_DYNAWO(hvdc->evalCalculatedVarI(ModelHvdcLink::p2Num_), calculatedVars[ModelHvdcLink::p2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(hvdc->evalCalculatedVarI(ModelHvdcLink::q2Num_), calculatedVars[ModelHvdcLink::q2Num_]);
  ASSERT_THROW_DYNAWO(hvdc->evalCalculatedVarI(42), Error::MODELER, KeyError_t::UndefCalculatedVarI);
  hvdc->setConnected1(OPEN);
  hvdc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelHvdcLink::p1Num_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelHvdcLink::q1Num_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelHvdcLink::p2Num_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelHvdcLink::q2Num_], -0.029999999999999999);
  yI[0] = 0.35;
  yI[1] = 0.02;
  ASSERT_DOUBLE_EQUALS_DYNAWO(hvdc->evalCalculatedVarI(ModelHvdcLink::p1Num_), calculatedVars[ModelHvdcLink::p1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(hvdc->evalCalculatedVarI(ModelHvdcLink::q1Num_), calculatedVars[ModelHvdcLink::q1Num_]);
  yI[0] = 5;
  yI[1] = 2.5;
  ASSERT_DOUBLE_EQUALS_DYNAWO(hvdc->evalCalculatedVarI(ModelHvdcLink::p2Num_), calculatedVars[ModelHvdcLink::p2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(hvdc->evalCalculatedVarI(ModelHvdcLink::q2Num_), calculatedVars[ModelHvdcLink::q2Num_]);
  ASSERT_THROW_DYNAWO(hvdc->evalCalculatedVarI(42), Error::MODELER, KeyError_t::UndefCalculatedVarI);
  hvdc->setConnected1(CLOSED);
  hvdc->setConnected2(OPEN);
  hvdc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelHvdcLink::p1Num_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelHvdcLink::q1Num_], -0.029999999999999999);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelHvdcLink::p2Num_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelHvdcLink::q2Num_], 0.);
  yI[0] = 0.35;
  yI[1] = 0.02;
  ASSERT_DOUBLE_EQUALS_DYNAWO(hvdc->evalCalculatedVarI(ModelHvdcLink::p1Num_), calculatedVars[ModelHvdcLink::p1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(hvdc->evalCalculatedVarI(ModelHvdcLink::q1Num_), calculatedVars[ModelHvdcLink::q1Num_]);
  yI[0] = 5;
  yI[1] = 2.5;
  ASSERT_DOUBLE_EQUALS_DYNAWO(hvdc->evalCalculatedVarI(ModelHvdcLink::p2Num_), calculatedVars[ModelHvdcLink::p2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(hvdc->evalCalculatedVarI(ModelHvdcLink::q2Num_), calculatedVars[ModelHvdcLink::q2Num_]);
  ASSERT_THROW_DYNAWO(hvdc->evalCalculatedVarI(42), Error::MODELER, KeyError_t::UndefCalculatedVarI);
  hvdc->setConnected2(CLOSED);

  std::vector<double> res(2, 0.);
  ASSERT_THROW_DYNAWO(hvdc->evalJCalculatedVarI(42, res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(hvdc->evalJCalculatedVarI(ModelHvdcLink::p1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 7.8062556418956319e-18);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 8.6736173798840355e-19);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(hvdc->evalJCalculatedVarI(ModelHvdcLink::q1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 1.3010426069826053e-17);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 1.3877787807814457e-17);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(hvdc->evalJCalculatedVarI(ModelHvdcLink::p2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 8.4025668367626594e-19);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 4.3368086899420177e-19);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(hvdc->evalJCalculatedVarI(ModelHvdcLink::q2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -4.3368086899420177e-19);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -0);
  std::fill(res.begin(), res.end(), 0);
  hvdc->setConnected1(OPEN);
  ASSERT_NO_THROW(hvdc->evalJCalculatedVarI(ModelHvdcLink::p1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(hvdc->evalJCalculatedVarI(ModelHvdcLink::q1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(hvdc->evalJCalculatedVarI(ModelHvdcLink::p2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(hvdc->evalJCalculatedVarI(ModelHvdcLink::q2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 6.5052130349130266e-19);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 4.3368086899420177e-19);
  std::fill(res.begin(), res.end(), 0);
  hvdc->setConnected1(CLOSED);
  hvdc->setConnected2(OPEN);
  ASSERT_NO_THROW(hvdc->evalJCalculatedVarI(ModelHvdcLink::p1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(hvdc->evalJCalculatedVarI(ModelHvdcLink::q1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 1.7347234759768071e-18);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 1.7347234759768071e-18);
  ASSERT_NO_THROW(hvdc->evalJCalculatedVarI(ModelHvdcLink::p2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(hvdc->evalJCalculatedVarI(ModelHvdcLink::q2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  std::fill(res.begin(), res.end(), 0);
  hvdc->setConnected2(CLOSED);

  int offset = 2;
  hvdc->init(offset);
  std::vector<int> numVars;
  ASSERT_THROW_DYNAWO(hvdc->getIndexesOfVariablesUsedForCalculatedVarI(42, numVars), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(hvdc->getIndexesOfVariablesUsedForCalculatedVarI(ModelHvdcLink::p1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(hvdc->getIndexesOfVariablesUsedForCalculatedVarI(ModelHvdcLink::q1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(hvdc->getIndexesOfVariablesUsedForCalculatedVarI(ModelHvdcLink::p2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i + 2);
  }
  numVars.clear();
  ASSERT_NO_THROW(hvdc->getIndexesOfVariablesUsedForCalculatedVarI(ModelHvdcLink::q2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i + 2);
  }
  numVars.clear();

  powsybl::iidm::Network networkIIDM2("MyNetwork", "MyNetwork");
  std::tuple<std::shared_ptr<ModelHvdcLink>, std::shared_ptr<NetworkInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> >
      p2 = createModelHvdcLink(true, VSC, networkIIDM2);
  std::shared_ptr<ModelHvdcLink> hvdcInit = std::get<0>(p2);
  hvdcInit->init(offSet);
  hvdcInit->initSize();
  ASSERT_EQ(hvdcInit->sizeCalculatedVar(), 0);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkHvdcLinkDiscreteVariables) {
  powsybl::iidm::Network networkIIDM("MyNetwork", "MyNetwork");
  std::tuple<std::shared_ptr<ModelHvdcLink>, std::shared_ptr<NetworkInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p
      = createModelHvdcLink(false, VSC, networkIIDM);
  std::shared_ptr<ModelHvdcLink> hvdc = std::get<0>(p);
  int offSet = 0;
  hvdc->init(offSet);
  hvdc->initSize();
  unsigned nbZ = 2;
  unsigned nbG = 0;
  ASSERT_EQ(hvdc->sizeZ(), nbZ);
  ASSERT_EQ(hvdc->sizeG(), nbG);
  std::vector<double> y(hvdc->sizeY(), 0.);
  std::vector<double> yp(hvdc->sizeY(), 0.);
  std::vector<double> f(hvdc->sizeF(), 0.);
  std::vector<double> z(nbZ, 0.);
  std::vector<state_g> g(nbG, NO_ROOT);
  hvdc->setReferenceG(&g[0], 0);
  bool* zConnected = new bool[hvdc->sizeZ()];
  for (int i = 0; i < hvdc->sizeZ(); ++i)
    zConnected[i] = true;
  hvdc->setReferenceZ(&z[0], zConnected, 0);
  hvdc->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);

  hvdc->getY0();
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[1], CLOSED);

  z[0] = OPEN;
  z[1] = OPEN;
  ASSERT_EQ(hvdc->getConnected1(), CLOSED);
  ASSERT_EQ(hvdc->getConnected2(), CLOSED);
  hvdc->evalZ(0.);
  ASSERT_EQ(hvdc->getConnected1(), OPEN);
  ASSERT_EQ(hvdc->getConnected2(), OPEN);

  ASSERT_EQ(hvdc->evalState(0.), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(hvdc->getConnected1(), OPEN);
  ASSERT_EQ(hvdc->getConnected2(), OPEN);
  z[0] = CLOSED;
  hvdc->evalZ(0.);
  ASSERT_EQ(hvdc->evalState(0.), NetworkComponent::STATE_CHANGE);
  z[1] = CLOSED;
  hvdc->evalZ(0.);
  ASSERT_EQ(hvdc->evalState(0.), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(hvdc->getConnected1(), CLOSED);
  ASSERT_EQ(hvdc->getConnected2(), CLOSED);
  ASSERT_EQ(hvdc->evalState(0.), NetworkComponent::NO_CHANGE);
  ASSERT_EQ(hvdc->getConnected1(), CLOSED);
  ASSERT_EQ(hvdc->getConnected2(), CLOSED);

  ASSERT_NO_THROW(hvdc->evalG(0.));
  std::map<int, std::string> gEquationIndex;
  hvdc->setGequations(gEquationIndex);
  ASSERT_EQ(gEquationIndex.size(), nbG);

  powsybl::iidm::Network networkIIDM2("MyNetwork", "MyNetwork");
  std::tuple<std::shared_ptr<ModelHvdcLink>, std::shared_ptr<NetworkInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> >
      p2 = createModelHvdcLink(true, VSC, networkIIDM2);
  std::shared_ptr<ModelHvdcLink> hvdcInit = std::get<0>(p2);
  hvdcInit->init(offSet);
  hvdcInit->initSize();
  ASSERT_EQ(hvdcInit->sizeZ(), 0);
  ASSERT_EQ(hvdcInit->sizeG(), 0);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkHvdcLinkContinuousVariables) {
  powsybl::iidm::Network networkIIDM("MyNetwork", "MyNetwork");
  std::tuple<std::shared_ptr<ModelHvdcLink>, std::shared_ptr<NetworkInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p
      = createModelHvdcLink(false, VSC, networkIIDM);
  std::shared_ptr<ModelHvdcLink> hvdc = std::get<0>(p);
  int offSet = 0;
  hvdc->init(offSet);
  unsigned nbY = 0;
  unsigned nbF = 0;
  hvdc->initSize();
  ASSERT_EQ(hvdc->sizeY(), nbY);
  ASSERT_EQ(hvdc->sizeF(), nbF);

  // test evalStaticYType
  ASSERT_NO_THROW(hvdc->evalStaticYType());
  ASSERT_NO_THROW(hvdc->evalStaticFType());
  ASSERT_NO_THROW(hvdc->evalDynamicYType());
  ASSERT_NO_THROW(hvdc->evalDynamicFType());
  ASSERT_NO_THROW(hvdc->evalF(UNDEFINED_EQ));

  // test setFequations
  std::map<int, std::string> fEquationIndex;
  ASSERT_NO_THROW(hvdc->setFequations(fEquationIndex));
  ASSERT_EQ(fEquationIndex.size(), nbF);

  powsybl::iidm::Network networkIIDM2("MyNetwork", "MyNetwork");
  std::tuple<std::shared_ptr<ModelHvdcLink>, std::shared_ptr<NetworkInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> >
      p2 = createModelHvdcLink(true, VSC, networkIIDM2);
  std::shared_ptr<ModelHvdcLink> hvdcInit = std::get<0>(p2);
  hvdcInit->init(offSet);
  hvdcInit->initSize();
  ASSERT_EQ(hvdcInit->sizeY(), 0);
  ASSERT_EQ(hvdcInit->sizeF(), 0);
}

TEST(ModelsModelNetwork, ModelNetworkHvdcLinkDefineInstantiate) {
  powsybl::iidm::Network networkIIDM("MyNetwork", "MyNetwork");
  std::tuple<std::shared_ptr<ModelHvdcLink>, std::shared_ptr<NetworkInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p
      = createModelHvdcLink(false, VSC, networkIIDM);
  std::shared_ptr<ModelHvdcLink> hvdc = std::get<0>(p);
  int offSet = 0;
  hvdc->init(offSet);

  std::vector<shared_ptr<Variable> > definedVariables;
  std::vector<shared_ptr<Variable> > instantiatedVariables;
  hvdc->defineVariables(definedVariables);
  hvdc->instantiateVariables(instantiatedVariables);
  ASSERT_EQ(definedVariables.size(), instantiatedVariables.size());

  unsigned nbAlias = 0;
  unsigned nbCalc = 0;
  unsigned nbVar = 0;
  for (size_t i = 0, iEnd = definedVariables.size(); i < iEnd; ++i) {
    std::string var = instantiatedVariables[i]->getName();
    boost::replace_all(var, hvdc->id(), "@ID@");
    ASSERT_EQ(definedVariables[i]->getName(), var);
    if (instantiatedVariables[i]->isAlias()) {
      std::string alias = boost::dynamic_pointer_cast<VariableAlias>(instantiatedVariables[i])->getReferenceVariableName();
      boost::replace_all(alias, hvdc->id(), "@ID@");
      ASSERT_EQ(boost::dynamic_pointer_cast<VariableAlias>(definedVariables[i])->getReferenceVariableName(), alias);
      ++nbAlias;
    } else {
      ASSERT_EQ(definedVariables[i]->getType(), instantiatedVariables[i]->getType());
      if (definedVariables[i]->isState())
        ++nbVar;
      else
        ++nbCalc;
    }
  }
  ASSERT_EQ(nbAlias, 0);
  ASSERT_EQ(nbCalc, 4);
  ASSERT_EQ(nbVar, 2);

  std::vector<ParameterModeler> parameters;
  hvdc->defineNonGenericParameters(parameters);
  ASSERT_TRUE(parameters.empty());
  std::unordered_map<std::string, ParameterModeler> parametersModels;
  ASSERT_NO_THROW(hvdc->setSubModelParameters(parametersModels));
}

TEST(ModelsModelNetwork, ModelNetworkHvdcLinkJt) {
  powsybl::iidm::Network networkIIDM("MyNetwork", "MyNetwork");
  std::tuple<std::shared_ptr<ModelHvdcLink>, std::shared_ptr<NetworkInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p
      = createModelHvdcLink(false, VSC, networkIIDM);
  std::shared_ptr<ModelHvdcLink> hvdc = std::get<0>(p);
  int offSet = 0;
  hvdc->init(offSet);

  hvdc->initSize();
  hvdc->evalYMat();
  SparseMatrix smj;
  int size = hvdc->sizeY();
  smj.init(size, size);
  hvdc->evalJt(smj, 1., 0);
  ASSERT_EQ(smj.nbElem(), 0);

  SparseMatrix smjPrime;
  smjPrime.init(size, size);
  hvdc->evalJtPrim(smjPrime, 0);
  ASSERT_EQ(smjPrime.nbElem(), 0);
}
}  // namespace DYN
