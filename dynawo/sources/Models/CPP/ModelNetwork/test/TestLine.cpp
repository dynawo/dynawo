//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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

#include <boost/algorithm/string/replace.hpp>

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>
#include <powsybl/iidm/TopologyKind.hpp>
#include <powsybl/iidm/Line.hpp>
#include <powsybl/iidm/LineAdder.hpp>
#include <powsybl/iidm/CurrentLimitsAdder.hpp>

#include "DYNLineInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNCurrentLimitInterfaceIIDM.h"
#include "DYNBusInterfaceIIDM.h"
#include "DYNModelLine.h"
#include "DYNModelVoltageLevel.h"
#include "DYNModelBus.h"
#include "DYNModelNetwork.h"
#include "TLTimelineFactory.h"
#include "DYNSparseMatrix.h"
#include "DYNVariable.h"
#include "DYNElement.h"

#include "make_unique.hpp"
#include "gtest_dynawo.h"

using boost::shared_ptr;

namespace DYN {
static std::pair<std::unique_ptr<ModelLine>, std::shared_ptr<ModelVoltageLevel> >  // need to return the voltage level so that it is not destroyed
createModelLine(bool open, bool initModel, bool closed1 = true, bool closed2 = true) {
  powsybl::iidm::Network networkIIDM("test", "test");

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

  std::string idBus1 ="MyBus1";
  std::string idBus2 ="MyBus2";
  powsybl::iidm::Bus& iidmBus = vlIIDM.getBusBreakerView().newBus()
              .setId(idBus1)
              .add();
  iidmBus.setV(1);
  iidmBus.setAngle(0.);

  powsybl::iidm::Bus& iidmBus2 = vlIIDM.getBusBreakerView().newBus()
              .setId(idBus2)
              .add();
  iidmBus2.setV(1);
  iidmBus2.setAngle(0.);

  powsybl::iidm::Line& lIIDM = networkIIDM.newLine()
       .setId("MyLine")
       .setVoltageLevel1(vlIIDM.getId())
       .setBus1(idBus1)
       .setConnectableBus1(idBus1)
       .setVoltageLevel2(vlIIDM.getId())
       .setBus2(idBus2)
       .setConnectableBus2(idBus2)
       .setR(3.)
       .setX(3.)
       .setG1(3.)
       .setB1(3.)
       .setG2(6.0)
       .setB2(1.5)
       .add();
  lIIDM.getTerminal1().setP(105.);
  lIIDM.getTerminal1().setQ(90.);
  lIIDM.getTerminal2().setP(50.);
  lIIDM.getTerminal2().setQ(45.);
  lIIDM.newCurrentLimits1().setPermanentLimit(200)
      .beginTemporaryLimit().setName("MyLimit").setValue(10.).setAcceptableDuration(5.).endTemporaryLimit()
      .beginTemporaryLimit().setName("MyLimit").setValue(8.).setAcceptableDuration(std::numeric_limits<unsigned long>::max())
        .setFictitious(true).endTemporaryLimit()
      .add();
  lIIDM.newCurrentLimits2()
      .beginTemporaryLimit().setName("MyLimit2").setValue(15.).setAcceptableDuration(10.).endTemporaryLimit()
      .beginTemporaryLimit().setName("MyLimit2").setValue(13.).setAcceptableDuration(std::numeric_limits<unsigned long>::max())
        .setFictitious(true).endTemporaryLimit()
      .add();
  if (open || !closed1) {
    lIIDM.getTerminal1().disconnect();
  }
  if (open || !closed2) {
    lIIDM.getTerminal2().disconnect();
  }
  std::unique_ptr<LineInterfaceIIDM> dlItfIIDM = DYN::make_unique<LineInterfaceIIDM>(lIIDM);
  std::shared_ptr<VoltageLevelInterfaceIIDM> vlItfIIDM = std::make_shared<VoltageLevelInterfaceIIDM>(vlIIDM);
  dlItfIIDM->setVoltageLevelInterface1(vlItfIIDM);
  dlItfIIDM->setVoltageLevelInterface2(vlItfIIDM);
  std::shared_ptr<BusInterfaceIIDM> bus1ItfIIDM;
  if (closed1)
    bus1ItfIIDM = std::make_shared<BusInterfaceIIDM>(iidmBus);
  std::shared_ptr<BusInterfaceIIDM> bus2ItfIIDM;
  if (closed2)
    bus2ItfIIDM = std::make_shared<BusInterfaceIIDM>(iidmBus2);
  if (closed1)
    dlItfIIDM->setBusInterface1(bus1ItfIIDM);
  if (closed2)
    dlItfIIDM->setBusInterface2(bus2ItfIIDM);

  powsybl::iidm::CurrentLimits& currentLimits1 = lIIDM.getCurrentLimits1();
  if (!std::isnan(currentLimits1.getPermanentLimit())) {
    std::unique_ptr<CurrentLimitInterfaceIIDM> cLimit = DYN::make_unique<CurrentLimitInterfaceIIDM>(currentLimits1.getPermanentLimit(),
        std::numeric_limits<unsigned long>::max(),
        false);
    dlItfIIDM->addCurrentLimitInterface1(std::move(cLimit));
  }
  for (auto& currentLimit : currentLimits1.getTemporaryLimits()) {
    if (!currentLimit.isFictitious()) {
      std::unique_ptr<CurrentLimitInterfaceIIDM> cLimit = DYN::make_unique<CurrentLimitInterfaceIIDM>(currentLimit.getValue(),
          currentLimit.getAcceptableDuration(),
          currentLimit.isFictitious());
      dlItfIIDM->addCurrentLimitInterface1(std::move(cLimit));
    }
  }
  powsybl::iidm::CurrentLimits& currentLimits2 = lIIDM.getCurrentLimits2();
  if (!std::isnan(currentLimits2.getPermanentLimit())) {
    std::unique_ptr<CurrentLimitInterfaceIIDM> cLimit = DYN::make_unique<CurrentLimitInterfaceIIDM>(currentLimits2.getPermanentLimit(),
        std::numeric_limits<unsigned long>::max(),
        false);
    dlItfIIDM->addCurrentLimitInterface1(std::move(cLimit));
  }
  for (auto& currentLimit : currentLimits2.getTemporaryLimits()) {
    if (!currentLimit.isFictitious()) {
      std::unique_ptr<CurrentLimitInterfaceIIDM> cLimit = DYN::make_unique<CurrentLimitInterfaceIIDM>(currentLimit.getValue(),
          currentLimit.getAcceptableDuration(),
          currentLimit.isFictitious());
      dlItfIIDM->addCurrentLimitInterface1(std::move(cLimit));
    }
  }

  std::unique_ptr<ModelLine> dl = DYN::make_unique<ModelLine>(std::move(dlItfIIDM));
  ModelNetwork* network = new ModelNetwork();
  network->setIsInitModel(initModel);
  network->setTimeline(timeline::TimelineFactory::newInstance("Test"));
  dl->setNetwork(network);
  std::shared_ptr<ModelVoltageLevel> vl = std::make_shared<ModelVoltageLevel>(vlItfIIDM);
  int offset = 0;
  if (closed1) {
    std::shared_ptr<ModelBus> bus1 = std::make_shared<ModelBus>(bus1ItfIIDM, false);
    bus1->setNetwork(network);
    bus1->setVoltageLevel(vl);
    dl->setModelBus1(bus1);
    bus1->initSize();
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
    bus1->init(offset);
  }
  if (closed2) {
    std::shared_ptr<ModelBus> bus2 = std::make_shared<ModelBus>(bus2ItfIIDM, false);
    bus2->setNetwork(network);
    bus2->setVoltageLevel(vl);
    dl->setModelBus2(bus2);
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
    y2[ModelBus::urNum_] = 4.;
    y2[ModelBus::uiNum_] = 1.5;
    if (!initModel)
      z2[ModelBus::switchOffNum_] = -1;
    bus2->init(offset);
  }
  return std::make_pair(std::move(dl), vl);
}


TEST(ModelsModelNetwork, ModelNetworkLineInitializationClosed) {
  const std::unique_ptr<ModelLine> dl = createModelLine(false, false).first;
  ASSERT_EQ(dl->id(), "MyLine");
  ASSERT_EQ(dl->getConnectionState(), CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getCurrentLimitsDesactivate(), 0.);
}

TEST(ModelsModelNetwork, ModelNetworkLineInitializationOpened) {
  const std::unique_ptr<ModelLine> dl = createModelLine(true, false).first;
  ASSERT_EQ(dl->id(), "MyLine");
  ASSERT_EQ(dl->getConnectionState(), OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getCurrentLimitsDesactivate(), 0.);
}

TEST(ModelsModelNetwork, ModelNetworkLineInitializationClosed2) {
  const std::unique_ptr<ModelLine> dl = createModelLine(false, false, false).first;
  ASSERT_EQ(dl->id(), "MyLine");
  ASSERT_EQ(dl->getConnectionState(), CLOSED_2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getCurrentLimitsDesactivate(), 0.);

  dl->evalYMat();
}

TEST(ModelsModelNetwork, ModelNetworkLineInitializationClosed1) {
  const std::unique_ptr<ModelLine> dl = createModelLine(false, false, true, false).first;
  ASSERT_EQ(dl->id(), "MyLine");
  ASSERT_EQ(dl->getConnectionState(), CLOSED_1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getCurrentLimitsDesactivate(), 0.);

  dl->evalYMat();
}

TEST(ModelsModelNetwork, ModelNetworkLineCalculatedVariables) {
  const std::unique_ptr<ModelLine> dl = createModelLine(false, false).first;
  dl->initSize();
  std::vector<double> y(dl->sizeY(), 0.);
  std::vector<double> yp(dl->sizeY(), 0.);
  std::vector<double> f(dl->sizeF(), 0.);
  std::vector<double> z(dl->sizeZ(), 0.);
  bool* zConnected = new bool[dl->sizeZ()];
  for (int i = 0; i < dl->sizeZ(); ++i)
    zConnected[i] = true;
  dl->setReferenceZ(&z[0], zConnected, 0);
  dl->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  dl->evalYMat();
  ASSERT_EQ(dl->sizeCalculatedVar(), ModelLine::nbCalculatedVariables_);

  std::vector<double> calculatedVars(ModelLine::nbCalculatedVariables_, 0.);
  dl->setReferenceCalculatedVar(&calculatedVars[0], 0);
  dl->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::i1Num_], 4.3158702611537239);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::i2Num_], 6.5816519477340263);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::p1Num_], 12.270833333333332);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::p2Num_], 27.3125);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::q1Num_], -12.333333333333336);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::q2Num_], -6.6770833333333321);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::iS1ToS2Side1Num_], 49835.377141292069);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::iS2ToS1Side1Num_], -49835.377141292069);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::iS1ToS2Side2Num_], -75998.37047473331);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::iS2ToS1Side2Num_], 75998.37047473331);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::iSide1Num_], 49835.377141292069);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::iSide2Num_], 75998.37047473331);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::u1Num_], 4.0311288741492746);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::u2Num_], 4.2720018726587652);
  ASSERT_EQ(calculatedVars[ModelLine::lineStateNum_], CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::i1Num_), calculatedVars[ModelLine::i1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::i2Num_), calculatedVars[ModelLine::i2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::p1Num_), calculatedVars[ModelLine::p1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::p2Num_), calculatedVars[ModelLine::p2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::q1Num_), calculatedVars[ModelLine::q1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::q2Num_), calculatedVars[ModelLine::q2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::iS1ToS2Side1Num_), calculatedVars[ModelLine::iS1ToS2Side1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::iS2ToS1Side1Num_), calculatedVars[ModelLine::iS2ToS1Side1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::iS1ToS2Side2Num_), calculatedVars[ModelLine::iS1ToS2Side2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::iS2ToS1Side2Num_), calculatedVars[ModelLine::iS2ToS1Side2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::iSide1Num_), calculatedVars[ModelLine::iSide1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::iSide2Num_), calculatedVars[ModelLine::iSide2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::u1Num_), calculatedVars[ModelLine::u1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::u2Num_), calculatedVars[ModelLine::u2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::lineStateNum_), calculatedVars[ModelLine::lineStateNum_]);
  ASSERT_THROW_DYNAWO(dl->evalCalculatedVarI(42), Error::MODELER, KeyError_t::UndefCalculatedVarI);

  std::vector<double> res(4, 0.);
  ASSERT_THROW_DYNAWO(dl->evalJCalculatedVarI(42, res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::i1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.89020606654237955);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.57965971165276509);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.029365134594484289);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -0.051087288952047991);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::iS1ToS2Side1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 10279.214243049617);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 6693.3338112220972);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 339.07936725830194);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -589.90520057266212);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::iS2ToS1Side1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -10279.214243049617);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -6693.3338112220972);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], -339.07936725830194);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 589.90520057266212);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::iSide1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 10279.214243049617);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 6693.3338112220972);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 339.07936725830194);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -589.90520057266212);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::i2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -0.010946888666137453);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -0.057899808728124606);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 1.4614755820417966);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.59324223156971401);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::iS1ToS2Side2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 126.40378236366647);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 668.5694031042118);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], -16875.666414117928);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -6850.1712418285751);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::iS2ToS1Side2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -126.40378236366647);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -668.5694031042118);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 16875.666414117928);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 6850.1712418285751);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::iSide2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -126.40378236366647);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -668.5694031042118);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 16875.666414117928);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 6850.1712418285751);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::p1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 5.3124999999999991);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 3.270833333333333);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], -0.062499999999999972);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -0.22916666666666669);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::p2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -0.10416666666666666);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -0.22916666666666669);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 12.104166666666668);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 4.6875);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::q1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -5.0625000000000009);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -3.0625);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], -0.22916666666666669);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.062499999999999972);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::q2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -0.22916666666666669);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.10416666666666666);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], -2.7291666666666661);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -1.229166666666667);
  std::fill(res.begin(), res.end(), 0);
  res.resize(2);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::u1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.8682431421244593);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.49613893835683387);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::u2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.93632917756904455);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.3511234415883917);
  std::fill(res.begin(), res.end(), 0);
  res.resize(0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::lineStateNum_, res));

  int offset = 4;
  dl->init(offset);
  std::vector<int> numVars;
  ASSERT_THROW_DYNAWO(dl->getIndexesOfVariablesUsedForCalculatedVarI(42, numVars), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::i1Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::iS1ToS2Side1Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::iS2ToS1Side1Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::iSide1Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::i2Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::iS1ToS2Side2Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::iS2ToS1Side2Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::iSide2Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::p1Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::p2Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::q1Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::q2Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::u1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::u2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i+2);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::lineStateNum_, numVars));
  ASSERT_EQ(numVars.size(), 0);
  numVars.clear();

  const std::unique_ptr<ModelLine> dlInit = createModelLine(false, true).first;
  dlInit->initSize();
  ASSERT_EQ(dlInit->sizeCalculatedVar(), 0);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkLineCalculatedVariablesClosed2) {
  const std::unique_ptr<ModelLine> dl = createModelLine(false, false, false).first;
  dl->initSize();
  std::vector<double> y(dl->sizeY(), 0.);
  std::vector<double> yp(dl->sizeY(), 0.);
  std::vector<double> f(dl->sizeF(), 0.);
  std::vector<double> z(dl->sizeZ(), 0.);
  bool* zConnected = new bool[dl->sizeZ()];
  for (int i = 0; i < dl->sizeZ(); ++i)
    zConnected[i] = true;
  dl->setReferenceZ(&z[0], zConnected, 0);
  dl->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  dl->evalYMat();
  ASSERT_EQ(dl->sizeCalculatedVar(), ModelLine::nbCalculatedVariables_);

  std::vector<double> calculatedVars(ModelLine::nbCalculatedVariables_, 0.);
  dl->setReferenceCalculatedVar(&calculatedVars[0], 0);
  dl->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::i1Num_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::i2Num_], 6.7494951734299242);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::p1Num_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::p2Num_], 28.175192307692306);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::q1Num_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::q2Num_], -6.1277884615384632);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::iS1ToS2Side1Num_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::iS2ToS1Side1Num_], -0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::iS1ToS2Side2Num_], -77936.457105476948);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::iS2ToS1Side2Num_], 77936.457105476948);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::iSide1Num_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::iSide2Num_], 77936.457105476948);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::u1Num_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::u2Num_], 4.2720018726587652);
  ASSERT_EQ(calculatedVars[ModelLine::lineStateNum_], CLOSED_2);
  std::vector<double> yI(2, 0.);
  yI[0] = 4.;
  yI[1] = 1.5;
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::i1Num_), calculatedVars[ModelLine::i1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::i2Num_), calculatedVars[ModelLine::i2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::p1Num_), calculatedVars[ModelLine::p1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::p2Num_), calculatedVars[ModelLine::p2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::q1Num_), calculatedVars[ModelLine::q1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::q2Num_), calculatedVars[ModelLine::q2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::iS1ToS2Side1Num_), calculatedVars[ModelLine::iS1ToS2Side1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::iS2ToS1Side1Num_), calculatedVars[ModelLine::iS2ToS1Side1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::iS1ToS2Side2Num_), calculatedVars[ModelLine::iS1ToS2Side2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::iS2ToS1Side2Num_), calculatedVars[ModelLine::iS2ToS1Side2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::iSide1Num_), calculatedVars[ModelLine::iSide1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::iSide2Num_), calculatedVars[ModelLine::iSide2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::u1Num_), calculatedVars[ModelLine::u1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::u2Num_), calculatedVars[ModelLine::u2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::lineStateNum_), calculatedVars[ModelLine::lineStateNum_]);
  ASSERT_THROW_DYNAWO(dl->evalCalculatedVarI(42), Error::MODELER, KeyError_t::UndefCalculatedVarI);

  std::vector<double> res(4, 0.);
  ASSERT_THROW_DYNAWO(dl->evalJCalculatedVarI(42, res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::i1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::iS1ToS2Side1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::iS2ToS1Side1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::iSide1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::i2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 1.479341407875052);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.55475302795314463);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::iS1ToS2Side2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], -17081.963201200426);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -6405.736200450161);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::iS2ToS1Side2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 17081.963201200426);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 6405.736200450161);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::iSide2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 17081.963201200426);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 6405.736200450161);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::p1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::p2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 12.350769230769231);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 4.6315384615384616);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::q1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::q2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], -2.6861538461538466);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -1.0073076923076929);
  std::fill(res.begin(), res.end(), 0);
  res.resize(2);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::u1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::u2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.93632917756904455);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.3511234415883917);
  std::fill(res.begin(), res.end(), 0);
  res.resize(0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::lineStateNum_, res));

  int offset = 2;
  dl->init(offset);
  std::vector<int> numVars;
  ASSERT_THROW_DYNAWO(dl->getIndexesOfVariablesUsedForCalculatedVarI(42, numVars), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::i1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::iS1ToS2Side1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::iS2ToS1Side1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::iSide1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::i2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::iS1ToS2Side2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::iS2ToS1Side2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::iSide2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::p1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::p2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::q1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::q2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::u1Num_, numVars));
  ASSERT_EQ(numVars.size(), 0);
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::u2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::lineStateNum_, numVars));
  ASSERT_EQ(numVars.size(), 0);
  numVars.clear();
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkLineCalculatedVariablesClosed1) {
  const std::unique_ptr<ModelLine> dl = createModelLine(false, false, true, false).first;
  dl->initSize();
  std::vector<double> y(dl->sizeY(), 0.);
  std::vector<double> yp(dl->sizeY(), 0.);
  std::vector<double> f(dl->sizeF(), 0.);
  std::vector<double> z(dl->sizeZ(), 0.);
  bool* zConnected = new bool[dl->sizeZ()];
  for (int i = 0; i < dl->sizeZ(); ++i)
    zConnected[i] = true;
  dl->setReferenceZ(&z[0], zConnected, 0);
  dl->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  dl->evalYMat();
  ASSERT_EQ(dl->sizeCalculatedVar(), ModelLine::nbCalculatedVariables_);

  std::vector<double> calculatedVars(ModelLine::nbCalculatedVariables_, 0.);
  dl->setReferenceCalculatedVar(&calculatedVars[0], 0);
  dl->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::i1Num_], 4.2894353098502478);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::i2Num_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::p1Num_], 12.872143230983951);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::p2Num_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::q1Num_], -11.545381193300766);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::q2Num_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::iS1ToS2Side1Num_], 49530.132616270537);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::iS2ToS1Side1Num_], -49530.132616270537);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::iS1ToS2Side2Num_], -0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::iS2ToS1Side2Num_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::iSide1Num_], 49530.132616270537);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::iSide2Num_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::u1Num_], 4.0311288741492746);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLine::u2Num_], 0.);
  ASSERT_EQ(calculatedVars[ModelLine::lineStateNum_], CLOSED_1);
  std::vector<double> yI(2, 0.);
  yI[0] = 3.5;
  yI[1] = 2;
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::i1Num_), calculatedVars[ModelLine::i1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::i2Num_), calculatedVars[ModelLine::i2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::p1Num_), calculatedVars[ModelLine::p1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::p2Num_), calculatedVars[ModelLine::p2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::q1Num_), calculatedVars[ModelLine::q1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::q2Num_), calculatedVars[ModelLine::q2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::iS1ToS2Side1Num_), calculatedVars[ModelLine::iS1ToS2Side1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::iS2ToS1Side1Num_), calculatedVars[ModelLine::iS2ToS1Side1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::iS1ToS2Side2Num_), calculatedVars[ModelLine::iS1ToS2Side2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::iS2ToS1Side2Num_), calculatedVars[ModelLine::iS2ToS1Side2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::iSide1Num_), calculatedVars[ModelLine::iSide1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::iSide2Num_), calculatedVars[ModelLine::iSide2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::u1Num_), calculatedVars[ModelLine::u1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::u2Num_), calculatedVars[ModelLine::u2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelLine::lineStateNum_), calculatedVars[ModelLine::lineStateNum_]);
  ASSERT_THROW_DYNAWO(dl->evalCalculatedVarI(42), Error::MODELER, KeyError_t::UndefCalculatedVarI);

  std::vector<double> res(4, 0.);
  ASSERT_THROW_DYNAWO(dl->evalJCalculatedVarI(42, res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::i1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.92387837442928422);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.52793049967387662);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::iS1ToS2Side1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 10668.028563504424);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 6096.016322002527);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::iS2ToS1Side1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -10668.028563504424);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -6096.016322002527);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], -0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::iSide1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 10668.028563504424);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 6096.016322002527);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::i2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::iS1ToS2Side2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::iS2ToS1Side2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::iSide2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::p1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 5.5449232379623172);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 3.1685275645498958);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::p2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::q1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -4.9733949755757152);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -2.8419399860432657);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::q2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.);
  std::fill(res.begin(), res.end(), 0);
  res.resize(2);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::u1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.8682431421244593);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.49613893835683387);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::u2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  std::fill(res.begin(), res.end(), 0);
  res.resize(0);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelLine::lineStateNum_, res));

  int offset = 2;
  dl->init(offset);
  std::vector<int> numVars;
  ASSERT_THROW_DYNAWO(dl->getIndexesOfVariablesUsedForCalculatedVarI(42, numVars), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::i1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::iS1ToS2Side1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::iS2ToS1Side1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::iSide1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::i2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::iS1ToS2Side2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::iS2ToS1Side2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::iSide2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::p1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::p2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::q1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::q2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::u1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::u2Num_, numVars));
  ASSERT_EQ(numVars.size(), 0);
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelLine::lineStateNum_, numVars));
  ASSERT_EQ(numVars.size(), 0);
  numVars.clear();
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkLineDiscreteVariables) {
  std::pair<std::unique_ptr<ModelLine>, std::shared_ptr<ModelVoltageLevel> > p = createModelLine(false, false);
  const std::unique_ptr<ModelLine>& dl = p.first;
  dl->initSize();
  unsigned nbZ = 2;
  unsigned nbG = 6;
  ASSERT_EQ(dl->sizeZ(), nbZ);
  ASSERT_EQ(dl->sizeG(), nbG);
  std::vector<double> y(dl->sizeY(), 0.);
  std::vector<double> yp(dl->sizeY(), 0.);
  std::vector<double> f(dl->sizeF(), 0.);
  std::vector<double> z(nbZ, 0.);
  bool* zConnected = new bool[nbZ];
  for (size_t i = 0; i < nbZ; ++i)
    zConnected[i] = true;
  std::vector<state_g> g(nbG, NO_ROOT);
  dl->setReferenceG(&g[0], 0);
  dl->setReferenceZ(&z[0], zConnected, 0);
  dl->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  dl->setCurrentLimitsDesactivate(10.);

  dl->getY0();
  ASSERT_EQ(dl->getConnectionState(), CLOSED);
  ASSERT_EQ(z[0], dl->getConnectionState());
  dl->setConnectionState(OPEN);
  dl->getY0();
  ASSERT_EQ(dl->getConnectionState(), OPEN);
  ASSERT_EQ(z[0], dl->getConnectionState());
  dl->setConnectionState(CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getCurrentLimitsDesactivate(), 10.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[1], dl->getCurrentLimitsDesactivate());

  z[0] = OPEN;
  z[1] = 0.;
  ASSERT_EQ(dl->evalZ(0.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(dl->getConnectionState(), OPEN);
  ASSERT_EQ(z[0], OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getCurrentLimitsDesactivate(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[1], dl->getCurrentLimitsDesactivate());
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::TOPO_CHANGE);

  dl->setConnectionState(OPEN);
  ASSERT_EQ(dl->evalZ(0.), NetworkComponent::NO_CHANGE);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::NO_CHANGE);

  dl->setConnectionState(CLOSED_1);
  ASSERT_EQ(dl->evalZ(0.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::TOPO_CHANGE);

  dl->setConnectionState(CLOSED_2);
  ASSERT_EQ(dl->evalZ(0.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::TOPO_CHANGE);

  dl->setConnectionState(CLOSED_3);
  ASSERT_THROW_DYNAWO(dl->evalZ(0.), Error::MODELER, KeyError_t::NoThirdSide);

  dl->setConnectionState(UNDEFINED_STATE);
  ASSERT_THROW_DYNAWO(dl->evalZ(0.), Error::MODELER, KeyError_t::UnsupportedComponentState);

  z[0] = CLOSED;
  dl->setConnectionState(OPEN);
  ASSERT_EQ(dl->evalZ(0.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::TOPO_CHANGE);

  dl->setConnectionState(CLOSED);
  ASSERT_EQ(dl->evalZ(0.), NetworkComponent::NO_CHANGE);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::NO_CHANGE);

  dl->setConnectionState(CLOSED_1);
  ASSERT_EQ(dl->evalZ(0.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::TOPO_CHANGE);

  dl->setConnectionState(CLOSED_2);
  ASSERT_EQ(dl->evalZ(0.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::TOPO_CHANGE);

  dl->setConnectionState(CLOSED_3);
  ASSERT_THROW_DYNAWO(dl->evalZ(0.), Error::MODELER, KeyError_t::NoThirdSide);

  dl->setConnectionState(UNDEFINED_STATE);
  ASSERT_THROW_DYNAWO(dl->evalZ(0.), Error::MODELER, KeyError_t::UnsupportedComponentState);

  z[0] = CLOSED_1;
  dl->setConnectionState(OPEN);
  ASSERT_EQ(dl->evalZ(0.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::TOPO_CHANGE);

  dl->setConnectionState(CLOSED);
  ASSERT_EQ(dl->evalZ(0.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::TOPO_CHANGE);

  dl->setConnectionState(CLOSED_1);
  ASSERT_EQ(dl->evalZ(0.), NetworkComponent::NO_CHANGE);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::NO_CHANGE);

  dl->setConnectionState(CLOSED_2);
  ASSERT_EQ(dl->evalZ(0.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::TOPO_CHANGE);

  dl->setConnectionState(CLOSED_3);
  ASSERT_THROW_DYNAWO(dl->evalZ(0.), Error::MODELER, KeyError_t::NoThirdSide);

  dl->setConnectionState(UNDEFINED_STATE);
  ASSERT_THROW_DYNAWO(dl->evalZ(0.), Error::MODELER, KeyError_t::UnsupportedComponentState);

  z[0] = CLOSED_2;
  dl->setConnectionState(OPEN);
  ASSERT_EQ(dl->evalZ(0.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::TOPO_CHANGE);

  dl->setConnectionState(CLOSED);
  ASSERT_EQ(dl->evalZ(0.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::TOPO_CHANGE);

  dl->setConnectionState(CLOSED_1);
  ASSERT_EQ(dl->evalZ(0.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::TOPO_CHANGE);

  dl->setConnectionState(CLOSED_2);
  ASSERT_EQ(dl->evalZ(0.), NetworkComponent::NO_CHANGE);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::NO_CHANGE);

  dl->setConnectionState(CLOSED_3);
  ASSERT_THROW_DYNAWO(dl->evalZ(0.), Error::MODELER, KeyError_t::NoThirdSide);

  dl->setConnectionState(UNDEFINED_STATE);
  ASSERT_THROW_DYNAWO(dl->evalZ(0.), Error::MODELER, KeyError_t::UnsupportedComponentState);

  ASSERT_EQ(dl->evalState(0.), NetworkComponent::NO_CHANGE);

  z[0] = UNDEFINED_STATE;
  dl->setConnectionState(CLOSED);
  ASSERT_THROW_DYNAWO(dl->evalZ(0.), Error::MODELER, KeyError_t::UndefinedComponentState);
  z[0] = CLOSED_3;
  ASSERT_THROW_DYNAWO(dl->evalZ(0.), Error::MODELER, KeyError_t::NoThirdSide);
  z[0] = CLOSED;

  std::map<int, std::string> gEquationIndex;
  dl->setGequations(gEquationIndex);
  ASSERT_EQ(gEquationIndex.size(), nbG);
  for (unsigned i = 0; i < nbG; ++i) {
    ASSERT_TRUE(gEquationIndex.find(i) != gEquationIndex.end());
  }
  ASSERT_NO_THROW(dl->evalG(0.));
  ASSERT_DOUBLE_EQUALS_DYNAWO(g[0], ROOT_DOWN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(g[1], NO_ROOT);
  ASSERT_DOUBLE_EQUALS_DYNAWO(g[2], ROOT_DOWN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(g[3], ROOT_DOWN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(g[4], ROOT_DOWN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(g[5], ROOT_DOWN);

  const std::unique_ptr<ModelLine> dlInit = createModelLine(false, true).first;
  dlInit->initSize();
  ASSERT_EQ(dlInit->sizeZ(), 0);
  ASSERT_EQ(dlInit->sizeG(), 0);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkLineContinuousVariables) {
  std::pair<std::unique_ptr<ModelLine>, std::shared_ptr<ModelVoltageLevel> > p = createModelLine(false, false);
  const std::unique_ptr<ModelLine>& dl = p.first;
  dl->initSize();
  unsigned nbY = 0;
  unsigned nbF = 0;
  ASSERT_EQ(dl->sizeY(), nbY);
  ASSERT_EQ(dl->sizeF(), nbF);
  std::vector<double> y(nbY, 0.);
  std::vector<double> yp(nbY, 0.);
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<double> f(nbF, 0.);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  std::vector<double> z(dl->sizeZ(), 0.);
  bool* zConnected = new bool[dl->sizeZ()];
  for (int i = 0; i < dl->sizeZ(); ++i)
    zConnected[i] = true;
  dl->setReferenceZ(&z[0], zConnected, 0);
  dl->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  dl->evalYMat();
  dl->setBufferYType(&yTypes[0], 0);
  dl->setBufferFType(&fTypes[0], 0);

  // test evalStaticYType
  ASSERT_NO_THROW(dl->evalStaticYType());
  ASSERT_NO_THROW(dl->evalStaticFType());
  ASSERT_NO_THROW(dl->evalDynamicYType());
  ASSERT_NO_THROW(dl->evalDynamicFType());

  // test getY0
  ASSERT_NO_THROW(dl->getY0());

  // test evalF
  ASSERT_NO_THROW(dl->evalF(UNDEFINED_EQ));

  // test setFequations
  std::map<int, std::string> fEquationIndex;
  dl->setFequations(fEquationIndex);
  ASSERT_TRUE(fEquationIndex.empty());

  // test evalNodeInjection
  ASSERT_NO_THROW(dl->evalNodeInjection());

  // test evalDerivatives
  ASSERT_NO_THROW(dl->evalDerivatives(1));

  const std::shared_ptr<ModelLine> dlInit = createModelLine(false, true).first;
  dlInit->initSize();
  ASSERT_EQ(dlInit->sizeY(), 0);
  ASSERT_EQ(dlInit->sizeF(), 0);
  ASSERT_NO_THROW(dlInit->getY0());
  ASSERT_NO_THROW(dlInit->evalF(UNDEFINED_EQ));
  fEquationIndex.clear();
  ASSERT_NO_THROW(dlInit->setFequations(fEquationIndex));
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkDynamicLine) {
  std::pair<std::unique_ptr<ModelLine>, std::shared_ptr<ModelVoltageLevel> > p = createModelLine(false, false);
  const std::unique_ptr<ModelLine>& dl = p.first;

  std::vector<ParameterModeler> parameters;
  dl->defineParameters(parameters);
  std::unordered_map<std::string, ParameterModeler> parametersModels;
  parameters[0].setValue<double>(10., PAR);
  parametersModels.insert(std::make_pair(parameters[0].getName(), parameters[0]));
  parameters[1].setValue<bool>(true, PAR);
  parametersModels.insert(std::make_pair(parameters[1].getName(), parameters[1]));
  dl->setSubModelParameters(parametersModels);

  dl->initSize();
  unsigned nbY = 3;
  unsigned nbF = 2;
  ASSERT_EQ(dl->sizeY(), nbY);
  ASSERT_EQ(dl->sizeF(), nbF);

  std::vector<double> y(nbY, 0.);
  std::vector<double> yp(nbY, 0.);
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<double> f(nbF, 0.);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  std::vector<double> z(dl->sizeZ(), 0.);
  bool* zConnected = new bool[dl->sizeZ()];
  for (int i = 0; i < dl->sizeZ(); ++i)
    zConnected[i] = true;
  dl->setReferenceZ(&z[0], zConnected, 0);
  dl->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  dl->evalYMat();
  dl->setBufferYType(&yTypes[0], 0);
  dl->setBufferFType(&fTypes[0], 0);

  // test evalStaticYType
  ASSERT_NO_THROW(dl->evalStaticYType());
  ASSERT_NO_THROW(dl->evalDynamicYType());
  ASSERT_NO_THROW(dl->evalDynamicFType());
  ASSERT_EQ(yTypes[0], DIFFERENTIAL);
  ASSERT_EQ(yTypes[2], EXTERNAL);
  ASSERT_EQ(fTypes[0], DIFFERENTIAL_EQ);
  std::vector<propertyF_t> fTypesSave(nbF, UNDEFINED_EQ);
  std::vector<propertyContinuousVar_t> yTypesSave(nbY, UNDEFINED_PROPERTY);
  fTypesSave = fTypes;
  yTypesSave = yTypes;
  ASSERT_NO_THROW(dl->evalDynamicYType());
  ASSERT_NO_THROW(dl->evalDynamicFType());
  ASSERT_EQ(fTypes[0], fTypesSave[0]);
  ASSERT_EQ(yTypes[0], yTypesSave[0]);
  ASSERT_EQ(yTypes[2], yTypesSave[2]);

  // test init
  int yNum = 0;
  dl->init(yNum);
  ASSERT_EQ(yNum, 3);

  // test getY0
  ASSERT_NO_THROW(dl->getY0());
  ASSERT_EQ(y[2], 1);
  ASSERT_EQ(yp[2], 0);

  // test evalF
  ASSERT_NO_THROW(dl->evalF(UNDEFINED_EQ));

  // test setFequations
  std::map<int, std::string> fEquationIndex;
  dl->setFequations(fEquationIndex);
  ASSERT_EQ(fEquationIndex.size(), 2);

  // test evalNodeInjection
  ASSERT_NO_THROW(dl->evalNodeInjection());

  // test evalJt, evalJtPrim, evalDerivatives and evalDerivativesPrim
  SparseMatrix smj;
  int size = dl->sizeY() + 1;
  smj.init(size, size);
  dl->evalJt(1., 0, smj);
  smj.changeCol();
  smj.changeCol();
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[2], -smj.Ax_[3]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[6], -smj.Ax_[7]);
  ASSERT_EQ(smj.nbElem(), 8);

  SparseMatrix smjPrime;
  smjPrime.init(size, size);
  dl->evalJtPrim(0, smjPrime);
  smjPrime.changeCol();
  smjPrime.changeCol();
  ASSERT_DOUBLE_EQUALS_DYNAWO(smjPrime.Ax_[0], smjPrime.Ax_[1]);
  ASSERT_EQ(smjPrime.nbElem(), 2);

  ASSERT_NO_THROW(dl->evalDerivatives(1));
  ASSERT_NO_THROW(dl->evalDerivativesPrim());

  // Closed_1 line
  std::pair<std::unique_ptr<ModelLine>, std::shared_ptr<ModelVoltageLevel> > p2 = createModelLine(false, false, true, false);
  const std::unique_ptr<ModelLine>& dl2 = p2.first;

  ASSERT_THROW_DYNAWO(dl2->setSubModelParameters(parametersModels), Error::MODELER, KeyError_t::DynamicLineStatusNotSupported);

  // Open line
  std::pair<std::unique_ptr<ModelLine>, std::shared_ptr<ModelVoltageLevel> > p3 = createModelLine(true, false);
  const std::unique_ptr<ModelLine>& dl3 = p3.first;

  ASSERT_NO_THROW(dl3->setSubModelParameters(parametersModels));
  std::vector<propertyContinuousVar_t> yTypes3(nbY, UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes3(nbF, UNDEFINED_EQ);
  dl3->initSize();
  dl3->setBufferYType(&yTypes3[0], 0);
  dl3->setBufferFType(&fTypes3[0], 0);
  std::vector<double> y3(nbY, 0.);
  std::vector<double> yp3(nbY, 0.);
  std::vector<double> f3(nbF, 0.);
  dl3->setReferenceY(&y3[0], &yp3[0], &f3[0], 0, 0);
  std::vector<double> z3(dl3->sizeZ(), 0.);
  bool* zConnected3 = new bool[dl3->sizeZ()];
  for (int i = 0; i < dl3->sizeZ(); ++i)
    zConnected3[i] = true;
  dl3->setReferenceZ(&z3[0], zConnected3, 0);
  yNum = 0;
  dl3->init(yNum);
  dl3->getY0();

  // test evalStaticYType
  ASSERT_NO_THROW(dl3->evalStaticYType());
  ASSERT_NO_THROW(dl3->evalDynamicYType());
  ASSERT_NO_THROW(dl3->evalDynamicFType());
  ASSERT_EQ(yTypes3[0], ALGEBRAIC);
  ASSERT_EQ(yTypes3[2], EXTERNAL);
  ASSERT_EQ(fTypes3[0], ALGEBRAIC_EQ);
  std::vector<propertyF_t> fTypesSave3(nbF, UNDEFINED_EQ);
  std::vector<propertyContinuousVar_t> yTypesSave3(nbY, UNDEFINED_PROPERTY);
  fTypesSave3 = fTypes3;
  yTypesSave3 = yTypes3;
  ASSERT_NO_THROW(dl3->evalDynamicYType());
  ASSERT_NO_THROW(dl3->evalDynamicFType());
  ASSERT_EQ(fTypes3[0], fTypesSave3[0]);
  ASSERT_EQ(yTypes3[0], yTypesSave3[0]);
  ASSERT_EQ(yTypes3[2], yTypesSave3[2]);

  // test evalF
  ASSERT_NO_THROW(dl3->evalF(UNDEFINED_EQ));
  ASSERT_EQ(f3[0], 0);

  // test evalJt
  SparseMatrix smj3;
  int size3 = dl3->sizeF();
  smj3.init(size3, size3);
  dl3->evalJt(1., 0, smj3);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj3.Ax_[0], 1);
  ASSERT_EQ(smj3.nbElem(), 2);

  // Close side2 then only side1 then both sides
  unsigned nbG = 9;
  std::vector<state_g> g3(nbG, NO_ROOT);
  dl3->setReferenceG(&g3[0], 0);
  z3[0] = CLOSED_2;
  ASSERT_THROW_DYNAWO(dl3->evalZ(0), Error::MODELER, KeyError_t::DynamicLineStatusNotSupported);
  z3[0] = CLOSED_1;
  ASSERT_THROW_DYNAWO(dl3->evalZ(0), Error::MODELER, KeyError_t::DynamicLineStatusNotSupported);
  z3[0] = CLOSED;
  ASSERT_NO_THROW(dl3->evalZ(0));
  delete[] zConnected;
  delete[] zConnected3;
}

TEST(ModelsModelNetwork, ModelNetworkLineDefineInstantiate) {
  std::pair<std::unique_ptr<ModelLine>, std::shared_ptr<ModelVoltageLevel> > p = createModelLine(false, false);
  const std::unique_ptr<ModelLine>& dl = p.first;

  std::vector<ParameterModeler> parameters;
  dl->defineNonGenericParameters(parameters);
  ASSERT_TRUE(parameters.empty());
  std::unordered_map<std::string, ParameterModeler> parametersModels;
  dl->defineParameters(parameters);
  ASSERT_EQ(parameters.size(), 2);
  ASSERT_EQ(parameters[0].getName(), "line_currentLimit_maxTimeOperation");
  parameters[0].setValue<double>(10., PAR);
  parametersModels.insert(std::make_pair(parameters[0].getName(), parameters[0]));
  parameters[1].setValue<bool>(true, PAR);
  parametersModels.insert(std::make_pair(parameters[1].getName(), parameters[1]));
  ASSERT_NO_THROW(dl->setSubModelParameters(parametersModels));

  std::vector<shared_ptr<Variable> > definedVariables;
  std::vector<shared_ptr<Variable> > instantiatedVariables;
  dl->defineVariables(definedVariables);
  dl->instantiateVariables(instantiatedVariables);
  ASSERT_EQ(definedVariables.size(), instantiatedVariables.size());

  for (size_t i = 0, iEnd = definedVariables.size(); i < iEnd; ++i) {
    std::string var = instantiatedVariables[i]->getName();
    boost::replace_all(var, dl->id(), "@ID@");
    ASSERT_EQ(definedVariables[i]->getName(), var);
    ASSERT_EQ(definedVariables[i]->getType(), instantiatedVariables[i]->getType());
  }

  std::vector<Element> elements;
  std::map<std::string, int> mapElement;
  dl->defineElements(elements, mapElement);
  ASSERT_EQ(elements.size(), 39);
}

TEST(ModelsModelNetwork, ModelNetworkLineJt) {
  std::pair<std::unique_ptr<ModelLine>, std::shared_ptr<ModelVoltageLevel> > p = createModelLine(false, false);
  const std::unique_ptr<ModelLine>& dl = p.first;
  dl->initSize();
  SparseMatrix smj;
  int size = dl->sizeY();
  smj.init(size, size);
  dl->evalJt(1., 0, smj);
  ASSERT_EQ(smj.nbElem(), 0);

  SparseMatrix smjPrime;
  smjPrime.init(size, size);
  dl->evalJtPrim(0, smjPrime);
  ASSERT_EQ(smjPrime.nbElem(), 0);

  const std::unique_ptr<ModelLine> dlInit = createModelLine(false, true).first;
  dlInit->initSize();
  SparseMatrix smjInit;
  smjInit.init(dlInit->sizeY(), dlInit->sizeY());
  ASSERT_NO_THROW(dlInit->evalJt(1., 0, smjInit));
  ASSERT_EQ(smjInit.nbElem(), 0);
}


}  // namespace DYN
