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

#include <IIDM/builders/NetworkBuilder.h>
#include <IIDM/builders/BusBuilder.h>
#include <IIDM/builders/HvdcLineBuilder.h>
#include <IIDM/builders/VscConverterStationBuilder.h>
#include <IIDM/builders/LccConverterStationBuilder.h>
#include <IIDM/builders/VoltageLevelBuilder.h>
#include <IIDM/Network.h>
#include <IIDM/components/VscConverterStation.h>
#include <IIDM/components/LccConverterStation.h>
#include <IIDM/components/VoltageLevel.h>
#include <IIDM/components/Bus.h>
#include <IIDM/components/HvdcLine.h>

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
#include "gtest_dynawo.h"

using boost::shared_ptr;

#define VSC true
#define LCC false
namespace DYN {

std::pair<shared_ptr<ModelHvdcLink>, shared_ptr<ModelVoltageLevel> >  // need to return the voltage level so that it is not destroyed
createModelHvdcLink(bool initModel, bool vsc, bool withP = true, bool withQ = true) {
  IIDM::builders::NetworkBuilder nb;
  IIDM::Network networkIIDM = nb.build("MyNetwork");

  IIDM::connection_status_t cs = {true /*connected*/};
  IIDM::Port p1("MyBus", cs), p2("MyBus", cs);
  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::bus_breaker);
  vlb.nominalV(5.);
  IIDM::VoltageLevel vlIIDM = vlb.build("MyVoltageLevel");
  vlIIDM.lowVoltageLimit(0.5);
  vlIIDM.highVoltageLimit(2.);

  IIDM::builders::BusBuilder bb;
  bb.angle(90);
  bb.v(100);
  IIDM::Bus bus1IIDM = bb.build("MyBus1");
  vlIIDM.add(bus1IIDM);
  IIDM::Bus bus2IIDM = bb.build("MyBus2");
  vlIIDM.add(bus2IIDM);

  if (vsc) {
    IIDM::builders::VscConverterStationBuilder vsccb;
    if (withP)
      vsccb.p(2.);
    if (withQ)
      vsccb.q(3.);
    IIDM::MinMaxReactiveLimits limits(1., 2.);
    vsccb.minMaxReactiveLimits(limits);
    IIDM::VscConverterStation vsc = vsccb.build("MyVscConverterStation");
    vsc.connectTo("MyVoltageLevel", p1);
    vlIIDM.add(vsc);
    IIDM::VscConverterStation vsc2 = vsccb.build("MyVscConverterStation2");
    vsc2.connectTo("MyVoltageLevel", p1);
    vlIIDM.add(vsc2);

    IIDM::builders::HvdcLineBuilder hlb;
    hlb.converterStation1("MyVscConverterStation");
    hlb.converterStation2("MyVscConverterStation2");
    hlb.convertersMode(IIDM::HvdcLine::mode_InverterRectifier);
    IIDM::HvdcLine hvdcIIDM = hlb.build("MyHvdcLine");
    networkIIDM.add(hvdcIIDM);
  } else {
    IIDM::builders::LccConverterStationBuilder lcsb;
    if (withP)
      lcsb.p(2.);
    if (withQ)
      lcsb.q(3.);
    IIDM::LccConverterStation lcc = lcsb.build("MyLccConverter");
    lcc.connectTo("MyVoltageLevel", p1);
    vlIIDM.add(lcc);
    IIDM::LccConverterStation lcc2 = lcsb.build("MyLccConverter2");
    lcc2.connectTo("MyVoltageLevel", p1);
    vlIIDM.add(lcc2);

    IIDM::builders::HvdcLineBuilder hvdcb;
    hvdcb.converterStation1("MyLccConverter");
    hvdcb.converterStation2("MyLccConverter2");
    hvdcb.convertersMode(IIDM::HvdcLine::mode_InverterRectifier);
    IIDM::HvdcLine hvdc = hvdcb.build("MyHvdcLine");
    networkIIDM.add(hvdc);
  }


  shared_ptr<NetworkInterfaceIIDM> networkItfIIDM = shared_ptr<NetworkInterfaceIIDM>(new NetworkInterfaceIIDM(networkIIDM));
  shared_ptr<VoltageLevelInterfaceIIDM> vlItfIIDM = shared_ptr<VoltageLevelInterfaceIIDM>(new VoltageLevelInterfaceIIDM(vlIIDM));
  shared_ptr<BusInterfaceIIDM> bus1ItfIIDM = shared_ptr<BusInterfaceIIDM>(new BusInterfaceIIDM(vlIIDM.get_bus("MyBus1")));
  shared_ptr<BusInterfaceIIDM> bus2ItfIIDM = shared_ptr<BusInterfaceIIDM>(new BusInterfaceIIDM(vlIIDM.get_bus("MyBus2")));
  shared_ptr<ModelVoltageLevel> vl = shared_ptr<ModelVoltageLevel>(new ModelVoltageLevel(vlItfIIDM));

  ModelNetwork* network = new ModelNetwork();
  network->setIsInitModel(initModel);
  boost::shared_ptr<constraints::ConstraintsCollection> constraints =
      constraints::ConstraintsCollectionFactory::newInstance("MyConstraintsCollection");
  network->setTimeline(timeline::TimelineFactory::newInstance("Test"));
  network->setConstraints(constraints);
  shared_ptr<ModelHvdcLink> hvdc;
  if (vsc) {
    for (IIDM::Contains<IIDM::VscConverterStation>::iterator itVSC = vlIIDM.vscConverterStations().begin();
        itVSC != vlIIDM.vscConverterStations().end(); ++itVSC) {
      shared_ptr<VscConverterInterfaceIIDM> vsc(new VscConverterInterfaceIIDM(*itVSC));
      vlItfIIDM->addVscConverter(vsc);
      vsc->setVoltageLevelInterface(vlItfIIDM);
      vsc->setBusInterface(bus1ItfIIDM);
    }
    const std::vector<shared_ptr<VscConverterInterface> >& vscConverters = vlItfIIDM->getVscConverters();
    shared_ptr<HvdcLineInterfaceIIDM> hvdcItfIIDM = shared_ptr<HvdcLineInterfaceIIDM>(new HvdcLineInterfaceIIDM(networkIIDM.get_hvdcline("MyHvdcLine"),
                                                                                      vscConverters[0], vscConverters[1]));
    hvdc = shared_ptr<ModelHvdcLink>(new ModelHvdcLink(hvdcItfIIDM));
  } else {
    for (IIDM::Contains<IIDM::LccConverterStation>::iterator itLCC = vlIIDM.lccConverterStations().begin();
        itLCC != vlIIDM.lccConverterStations().end(); ++itLCC) {
      shared_ptr<LccConverterInterface> lcc(new LccConverterInterfaceIIDM(*itLCC));
      vlItfIIDM->addLccConverter(lcc);
      lcc->setVoltageLevelInterface(vlItfIIDM);
      lcc->setBusInterface(bus1ItfIIDM);
    }
    const std::vector<shared_ptr<LccConverterInterface> >& lccConverters = vlItfIIDM->getLccConverters();
    shared_ptr<HvdcLineInterfaceIIDM> hvdcItfIIDM = shared_ptr<HvdcLineInterfaceIIDM>(new HvdcLineInterfaceIIDM(networkIIDM.get_hvdcline("MyHvdcLine"),
                                                                                      lccConverters[0], lccConverters[1]));
    hvdc = shared_ptr<ModelHvdcLink>(new ModelHvdcLink(hvdcItfIIDM));
  }
  hvdc->setNetwork(network);
  shared_ptr<ModelBus> bus1 = shared_ptr<ModelBus>(new ModelBus(bus1ItfIIDM));
  bus1->setNetwork(network);
  bus1->initSize();
  // There is a memory leak here, but whatever ...
  double* y1 = new double[bus1->sizeY()];
  double* yp1 = new double[bus1->sizeY()];
  double* f1 = new double[bus1->sizeF()];
  double* z1 = new double[bus1->sizeZ()];
  bool* zConnected1 = new bool[bus1->sizeZ()];
  for (size_t i = 0; i < bus1->sizeZ(); ++i)
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
  shared_ptr<ModelBus> bus2 = shared_ptr<ModelBus>(new ModelBus(bus2ItfIIDM));
  bus2->setNetwork(network);
  bus2->initSize();
  // There is a memory leak here, but whatever ...
  double* y2 = new double[bus2->sizeY()];
  double* yp2 = new double[bus2->sizeY()];
  double* f2 = new double[bus2->sizeF()];
  double* z2 = new double[bus2->sizeZ()];
  bool* zConnected2 = new bool[bus2->sizeZ()];
  for (size_t i = 0; i < bus2->sizeZ(); ++i)
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
  hvdc->setModelBus2(bus2);
  return std::make_pair(hvdc, vl);
}


TEST(ModelsModelNetwork, ModelNetworkHvdcLinkInitializationVCS) {
  std::pair<shared_ptr<ModelHvdcLink>, shared_ptr<ModelVoltageLevel> > p = createModelHvdcLink(false, VSC);
  shared_ptr<ModelHvdcLink> hvdc = p.first;
  ASSERT_EQ(hvdc->id(), "MyHvdcLine");
  ASSERT_TRUE(hvdc->isConnected1());
  ASSERT_TRUE(hvdc->isConnected2());
  ASSERT_EQ(hvdc->getConnected1(), CLOSED);
  ASSERT_EQ(hvdc->getConnected2(), CLOSED);
}

TEST(ModelsModelNetwork, ModelNetworkHvdcLinkInitializationVCSNoPNoQ) {
  std::pair<shared_ptr<ModelHvdcLink>, shared_ptr<ModelVoltageLevel> > p = createModelHvdcLink(false, VSC, false, false);
  shared_ptr<ModelHvdcLink> hvdc = p.first;
  ASSERT_EQ(hvdc->id(), "MyHvdcLine");
  ASSERT_TRUE(hvdc->isConnected1());
  ASSERT_TRUE(hvdc->isConnected2());
  ASSERT_EQ(hvdc->getConnected1(), CLOSED);
  ASSERT_EQ(hvdc->getConnected2(), CLOSED);
}

TEST(ModelsModelNetwork, ModelNetworkHvdcLinkInitializationLCC) {
  std::pair<shared_ptr<ModelHvdcLink>, shared_ptr<ModelVoltageLevel> > p = createModelHvdcLink(false, LCC);
  shared_ptr<ModelHvdcLink> hvdc = p.first;
  ASSERT_EQ(hvdc->id(), "MyHvdcLine");
  ASSERT_TRUE(hvdc->isConnected1());
  ASSERT_TRUE(hvdc->isConnected2());
  ASSERT_EQ(hvdc->getConnected1(), CLOSED);
  ASSERT_EQ(hvdc->getConnected2(), CLOSED);
}

TEST(ModelsModelNetwork, ModelNetworkHvdcLinkInitializationLCCNoPNoQ) {
  std::pair<shared_ptr<ModelHvdcLink>, shared_ptr<ModelVoltageLevel> > p = createModelHvdcLink(false, LCC, false, false);
  shared_ptr<ModelHvdcLink> hvdc = p.first;
  ASSERT_EQ(hvdc->id(), "MyHvdcLine");
  ASSERT_TRUE(hvdc->isConnected1());
  ASSERT_TRUE(hvdc->isConnected2());
  ASSERT_EQ(hvdc->getConnected1(), CLOSED);
  ASSERT_EQ(hvdc->getConnected2(), CLOSED);
}

TEST(ModelsModelNetwork, ModelNetworkHvdcLinkCalculatedVariables) {
  std::pair<shared_ptr<ModelHvdcLink>, shared_ptr<ModelVoltageLevel> > p = createModelHvdcLink(false, VSC);
  shared_ptr<ModelHvdcLink> hvdc = p.first;
  hvdc->initSize();
  std::vector<double> y(hvdc->sizeY(), 0.);
  std::vector<double> yp(hvdc->sizeY(), 0.);
  std::vector<double> f(hvdc->sizeF(), 0.);
  std::vector<double> z(hvdc->sizeZ(), 0.);
  bool* zConnected = new bool[hvdc->sizeZ()];
  for (size_t i = 0; i < hvdc->sizeZ(); ++i)
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

  shared_ptr<ModelHvdcLink> hvdcInit = createModelHvdcLink(true, VSC).first;
  hvdcInit->initSize();
  ASSERT_EQ(hvdcInit->sizeCalculatedVar(), 0);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkHvdcLinkDiscreteVariables) {
  std::pair<shared_ptr<ModelHvdcLink>, shared_ptr<ModelVoltageLevel> > p = createModelHvdcLink(false, VSC);
  shared_ptr<ModelHvdcLink> hvdc = p.first;
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
  for (size_t i = 0; i < hvdc->sizeZ(); ++i)
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

  shared_ptr<ModelHvdcLink> hvdcInit = createModelHvdcLink(true, VSC).first;
  hvdcInit->initSize();
  ASSERT_EQ(hvdcInit->sizeZ(), 0);
  ASSERT_EQ(hvdcInit->sizeG(), 0);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkHvdcLinkContinuousVariables) {
  std::pair<shared_ptr<ModelHvdcLink>, shared_ptr<ModelVoltageLevel> > p = createModelHvdcLink(false, VSC);
  shared_ptr<ModelHvdcLink> hvdc = p.first;

  unsigned nbY = 0;
  unsigned nbF = 0;
  hvdc->initSize();
  ASSERT_EQ(hvdc->sizeY(), nbY);
  ASSERT_EQ(hvdc->sizeF(), nbF);

  // test evalYType
  ASSERT_NO_THROW(hvdc->evalYType());
  ASSERT_NO_THROW(hvdc->evalFType());
  ASSERT_NO_THROW(hvdc->evalF(UNDEFINED_EQ));

  // test setFequations
  std::map<int, std::string> fEquationIndex;
  ASSERT_NO_THROW(hvdc->setFequations(fEquationIndex));
  ASSERT_EQ(fEquationIndex.size(), nbF);

  shared_ptr<ModelHvdcLink> hvdcInit = createModelHvdcLink(true, VSC).first;
  hvdcInit->initSize();
  ASSERT_EQ(hvdcInit->sizeY(), 0);
  ASSERT_EQ(hvdcInit->sizeF(), 0);
}

TEST(ModelsModelNetwork, ModelNetworkHvdcLinkDefineInstantiate) {
  std::pair<shared_ptr<ModelHvdcLink>, shared_ptr<ModelVoltageLevel> > p = createModelHvdcLink(false, VSC);
  shared_ptr<ModelHvdcLink> hvdc = p.first;

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
  boost::unordered_map<std::string, ParameterModeler> parametersModels;
  ASSERT_NO_THROW(hvdc->setSubModelParameters(parametersModels));
}

TEST(ModelsModelNetwork, ModelNetworkHvdcLinkJt) {
  std::pair<shared_ptr<ModelHvdcLink>, shared_ptr<ModelVoltageLevel> > p = createModelHvdcLink(false, VSC);
  shared_ptr<ModelHvdcLink> hvdc = p.first;

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
