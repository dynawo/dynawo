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

#include <boost/shared_ptr.hpp>
#include <boost/algorithm/string/replace.hpp>

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>
#include <powsybl/iidm/TopologyKind.hpp>
#include <powsybl/iidm/TwoWindingsTransformerAdder.hpp>
#include <powsybl/iidm/PhaseTapChangerAdder.hpp>
#include <powsybl/iidm/RatioTapChangerAdder.hpp>
#include <powsybl/iidm/CurrentLimitsAdder.hpp>

#include "DYNTwoWTransformerInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNCurrentLimitInterfaceIIDM.h"
#include "DYNRatioTapChangerInterfaceIIDM.h"
#include "DYNPhaseTapChangerInterfaceIIDM.h"
#include "DYNStepInterfaceIIDM.h"
#include "DYNBusInterfaceIIDM.h"
#include "DYNModelTwoWindingsTransformer.h"
#include "DYNModelVoltageLevel.h"
#include "DYNModelBus.h"
#include "DYNModelNetwork.h"
#include "TLTimelineFactory.h"
#include "DYNSparseMatrix.h"
#include "DYNVariable.h"

#include "gtest_dynawo.h"

using boost::shared_ptr;

namespace DYN {
static std::pair<shared_ptr<ModelTwoWindingsTransformer>, shared_ptr<ModelVoltageLevel> >  // need to return the voltage level so that it is not destroyed
createModelTwoWindingsTransformer(bool open, bool initModel, bool ratioTapChanger, bool phaseTapChanger,
                                  bool loadTapChangingCapabilities = true, bool closed1 = true, bool closed2 = true) {
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

  powsybl::iidm::Bus& iidmBus = vlIIDM.getBusBreakerView().newBus()
              .setId("MyBus1")
              .add();
  iidmBus.setV(1);
  iidmBus.setAngle(0.);

  powsybl::iidm::Bus& iidmBus2 = vlIIDM.getBusBreakerView().newBus()
              .setId("MyBus2")
              .add();
  iidmBus2.setV(1);
  iidmBus2.setAngle(0.);

  powsybl::iidm::TwoWindingsTransformer& transformer = s.newTwoWindingsTransformer()
      .setId("MyTwoWindingsTransformer")
      .setVoltageLevel1(vlIIDM.getId())
      .setBus1(iidmBus.getId())
      .setConnectableBus1(iidmBus.getId())
      .setVoltageLevel2(vlIIDM.getId())
      .setBus2(iidmBus2.getId())
      .setConnectableBus2(iidmBus2.getId())
      .setR(4.0)
      .setX(8.0)
      .setG(5.0)
      .setB(7.2)
      .setRatedU1(3.)
      .setRatedU2(5.)
      .setRatedS(3.0)
      .add();
  if (ratioTapChanger) {
    transformer.newRatioTapChanger()
        .setTapPosition(1)
        .setLowTapPosition(0)
        .setLoadTapChangingCapabilities(loadTapChangingCapabilities)
        .setRegulationTerminal(stdcxx::ref<powsybl::iidm::Terminal>(transformer.getTerminal1()))
        .setRegulating(true)
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
  if (phaseTapChanger) {
    transformer.newPhaseTapChanger()
        .setTapPosition(2)
        .setLowTapPosition(0)
        .setRegulationMode(powsybl::iidm::PhaseTapChanger::RegulationMode::ACTIVE_POWER_CONTROL)
        .setRegulationTerminal(stdcxx::ref<powsybl::iidm::Terminal>(transformer.getTerminal1()))
        .setRegulationValue(4.)
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
  transformer.newCurrentLimits1().beginTemporaryLimit().
      setName("MyLimit").setValue(10.).setAcceptableDuration(5.).endTemporaryLimit().add();
  transformer.newCurrentLimits2().beginTemporaryLimit().
      setName("MyLimit2").setValue(20.).setAcceptableDuration(2.).endTemporaryLimit().add();
  if (open || !closed1) {
    transformer.getTerminal1().disconnect();
  }
  if (open || !closed2) {
    transformer.getTerminal2().disconnect();
  }
  shared_ptr<TwoWTransformerInterfaceIIDM> tw2ItfIIDM = shared_ptr<TwoWTransformerInterfaceIIDM>(new TwoWTransformerInterfaceIIDM(transformer));
  // add phase tapChanger and steps if exists
  if (transformer.hasPhaseTapChanger()) {
    shared_ptr<PhaseTapChangerInterfaceIIDM> tapChanger(new PhaseTapChangerInterfaceIIDM(transformer.getPhaseTapChanger()));
    tw2ItfIIDM->setPhaseTapChanger(tapChanger);
  }
  // add ratio tapChanger and steps if exists
  if (transformer.hasRatioTapChanger()) {
    std::string side;
    if (transformer.getRatioTapChanger().isRegulating()) {
      if (stdcxx::areSame(transformer.getTerminal1(), transformer.getRatioTapChanger().getRegulationTerminal().get()))
        side = "ONE";
      else if (stdcxx::areSame(transformer.getTerminal2(), transformer.getRatioTapChanger().getRegulationTerminal().get()))
        side = "TWO";
    }
    shared_ptr<RatioTapChangerInterfaceIIDM> tapChanger(new RatioTapChangerInterfaceIIDM(transformer.getRatioTapChanger(), side));
    tw2ItfIIDM->setRatioTapChanger(tapChanger);
  }

  if (transformer.getCurrentLimits1()) {
    powsybl::iidm::CurrentLimits& currentLimits = transformer.getCurrentLimits1();

    // permanent limit
    if (!std::isnan(currentLimits.getPermanentLimit())) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.getPermanentLimit(), std::numeric_limits<unsigned long>::max()));
      tw2ItfIIDM->addCurrentLimitInterface1(cLimit);
    }

    // temporary limit
    for (auto& currentLimit : currentLimits.getTemporaryLimits()) {
      if (!currentLimit.isFictitious()) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimit.getValue(), currentLimit.getAcceptableDuration()));
        tw2ItfIIDM->addCurrentLimitInterface1(cLimit);
      }
    }
  }

  if (transformer.getCurrentLimits2()) {
    powsybl::iidm::CurrentLimits& currentLimits = transformer.getCurrentLimits2();

    // permanent limit
    if (!std::isnan(currentLimits.getPermanentLimit())) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.getPermanentLimit(), std::numeric_limits<unsigned long>::max()));
      tw2ItfIIDM->addCurrentLimitInterface2(cLimit);
    }

    // temporary limit
    for (auto& currentLimit : currentLimits.getTemporaryLimits()) {
      if (!currentLimit.isFictitious()) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimit.getValue(), currentLimit.getAcceptableDuration()));
        tw2ItfIIDM->addCurrentLimitInterface2(cLimit);
      }
    }
  }
  shared_ptr<VoltageLevelInterfaceIIDM> vlItfIIDM = shared_ptr<VoltageLevelInterfaceIIDM>(new VoltageLevelInterfaceIIDM(vlIIDM));
  tw2ItfIIDM->setVoltageLevelInterface1(vlItfIIDM);
  tw2ItfIIDM->setVoltageLevelInterface2(vlItfIIDM);
  shared_ptr<BusInterfaceIIDM> bus1ItfIIDM = shared_ptr<BusInterfaceIIDM>(new BusInterfaceIIDM(iidmBus));
  shared_ptr<BusInterfaceIIDM> bus2ItfIIDM = shared_ptr<BusInterfaceIIDM>(new BusInterfaceIIDM(iidmBus2));
  tw2ItfIIDM->setVoltageLevelInterface1(vlItfIIDM);
  if (closed1)
    tw2ItfIIDM->setBusInterface1(bus1ItfIIDM);
  if (closed2)
    tw2ItfIIDM->setBusInterface2(bus2ItfIIDM);

  shared_ptr<ModelTwoWindingsTransformer> t2w = shared_ptr<ModelTwoWindingsTransformer>(new ModelTwoWindingsTransformer(tw2ItfIIDM));
  ModelNetwork* network = new ModelNetwork();
  network->setTimeline(timeline::TimelineFactory::newInstance("Test"));
  network->setIsInitModel(initModel);
  t2w->setNetwork(network);
  shared_ptr<ModelVoltageLevel> vl = shared_ptr<ModelVoltageLevel>(new ModelVoltageLevel(vlItfIIDM));
  int offset = 0;
  if (closed1) {
    shared_ptr<ModelBus> bus1 = shared_ptr<ModelBus>(new ModelBus(bus1ItfIIDM, false));
    bus1->setNetwork(network);
    bus1->setVoltageLevel(vl);
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
    t2w->setModelBus1(bus1);
  }
  if (closed2) {
    shared_ptr<ModelBus> bus2 = shared_ptr<ModelBus>(new ModelBus(bus2ItfIIDM, false));
    bus2->setNetwork(network);
    bus2->setVoltageLevel(vl);
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
    t2w->setModelBus2(bus2);
  }
  return std::make_pair(t2w, vl);
}


TEST(ModelsModelNetwork, ModelNetworkTwoWindingsTransformerInitialization) {
  shared_ptr<ModelTwoWindingsTransformer> t2w = createModelTwoWindingsTransformer(false, false, true, false).first;
  ASSERT_EQ(t2w->id(), "MyTwoWindingsTransformer");
  ASSERT_EQ(t2w->getConnectionState(), CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->getCurrentLimitsDesactivate(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->getDisableInternalTapChanger(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->getTapChangerLocked(), 0.);
  ASSERT_EQ(t2w->getTapChangerIndex(), 0);
  ASSERT_EQ(t2w->getTerminalRefId(), "MyTwoWindingsTransformer");
  ASSERT_EQ(t2w->getSide(), "ONE");

  shared_ptr<ModelTwoWindingsTransformer> t2wNoLTCCapabilities = createModelTwoWindingsTransformer(false, false, true, false, false).first;
  ASSERT_EQ(t2wNoLTCCapabilities->id(), "MyTwoWindingsTransformer");
  ASSERT_EQ(t2wNoLTCCapabilities->getConnectionState(), CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2wNoLTCCapabilities->getCurrentLimitsDesactivate(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2wNoLTCCapabilities->getDisableInternalTapChanger(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2wNoLTCCapabilities->getTapChangerLocked(), 0.);
  ASSERT_EQ(t2wNoLTCCapabilities->getTapChangerIndex(), 0);
  ASSERT_EQ(t2wNoLTCCapabilities->getTerminalRefId(), "");
  ASSERT_EQ(t2wNoLTCCapabilities->getSide(), "");

  shared_ptr<ModelTwoWindingsTransformer> t2wPhase = createModelTwoWindingsTransformer(true, false, false, true, true, false, false).first;
  ASSERT_EQ(t2wPhase->id(), "MyTwoWindingsTransformer");
  ASSERT_EQ(t2wPhase->getConnectionState(), OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2wPhase->getCurrentLimitsDesactivate(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2wPhase->getDisableInternalTapChanger(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2wPhase->getTapChangerLocked(), 0.);
  ASSERT_EQ(t2wPhase->getTapChangerIndex(), 0);
  ASSERT_EQ(t2wPhase->getTerminalRefId(), "");
  ASSERT_EQ(t2wPhase->getSide(), "");
}

TEST(ModelsModelNetwork, ModelNetworkTwoWindingsTransformerCalculatedVariables) {
  shared_ptr<ModelTwoWindingsTransformer> t2w = createModelTwoWindingsTransformer(false, false, true, false).first;
  t2w->initSize();
  std::vector<double> y(t2w->sizeY(), 0.);
  std::vector<double> yp(t2w->sizeY(), 0.);
  std::vector<double> f(t2w->sizeF(), 0.);
  std::vector<double> z(t2w->sizeZ(), 0.);
  bool* zConnected = new bool[t2w->sizeZ()];
  for (int i = 0; i < t2w->sizeZ(); ++i)
    zConnected[i] = true;
  t2w->setReferenceZ(&z[0], zConnected, 0);
  t2w->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  t2w->evalYMat();
  ASSERT_EQ(t2w->sizeCalculatedVar(), ModelTwoWindingsTransformer::nbCalculatedVariables_);

  std::vector<double> calculatedVars(ModelTwoWindingsTransformer::nbCalculatedVariables_, 0.);
  t2w->setReferenceCalculatedVar(&calculatedVars[0], 0);
  t2w->evalCalculatedVars();

  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::i1Num_], 24.757516580070948);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::i2Num_], 0.071608989099576165);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::q1Num_], -81.705228892187009);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::iS1ToS2Side1Num_], 285875.17723941174);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::iS2ToS1Side1Num_], -285875.17723941174);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::iSide1Num_],  285875.17723941174);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::q2Num_], -0.19153908243503626);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::p1Num_], 57.310062501084907);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::p2Num_], -0.23852881060251008);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::iS1ToS2Side2Num_], 826.8693826607456);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::iS2ToS1Side2Num_], -826.8693826607456);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::iSide2Num_], 826.8693826607456);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::twtStateNum_], 2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::i1Num_),
      calculatedVars[ModelTwoWindingsTransformer::i1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::i2Num_),
      calculatedVars[ModelTwoWindingsTransformer::i2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::p1Num_),
      calculatedVars[ModelTwoWindingsTransformer::p1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::p2Num_),
      calculatedVars[ModelTwoWindingsTransformer::p2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::q1Num_),
      calculatedVars[ModelTwoWindingsTransformer::q1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::q2Num_),
      calculatedVars[ModelTwoWindingsTransformer::q2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::iS1ToS2Side1Num_),
      calculatedVars[ModelTwoWindingsTransformer::iS1ToS2Side1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::iS2ToS1Side1Num_),
      calculatedVars[ModelTwoWindingsTransformer::iS2ToS1Side1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::iS1ToS2Side2Num_),
      calculatedVars[ModelTwoWindingsTransformer::iS1ToS2Side2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::iS2ToS1Side2Num_),
      calculatedVars[ModelTwoWindingsTransformer::iS2ToS1Side2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::iSide1Num_),
      calculatedVars[ModelTwoWindingsTransformer::iSide1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::iSide2Num_),
      calculatedVars[ModelTwoWindingsTransformer::iSide2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::twtStateNum_),
      calculatedVars[ModelTwoWindingsTransformer::twtStateNum_]);
  ASSERT_THROW_DYNAWO(t2w->evalCalculatedVarI(42), Error::MODELER, KeyError_t::UndefCalculatedVarI);


  std::vector<double> res(4, 0.);
  ASSERT_THROW_DYNAWO(t2w->evalJCalculatedVarI(42, res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::i1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 5.287451914198817);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 3.0660650075063498);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.038997534699257062);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -0.024456848956426063);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::i2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.03254954049980735);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.032549540499807343);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], -0.019529724299884407);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -0.019529724299884404);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::p1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 24.646048685969205);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 14.29934179121318);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.0095606806228193536);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -0.18531446909337082);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::p2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -0.021358967348851739);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -0.19548540592615737);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], -0.055207845128365379);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.13966730458782481);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::q1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -35.003849116457509);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -20.070693489732513);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], -0.18531446909337082);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -0.0095606806228193536);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::q2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -0.19548540592615737);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.021358967348851739);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.094915182523564012);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -0.080838605946987468);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::iS1ToS2Side1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 61054.235719797791);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 35403.869148733662);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 450.30474312695685);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -282.40336657045214);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::iS2ToS1Side1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -61054.235719797791);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -35403.869148733662);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], -450.30474312695685);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 282.40336657045214);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::iS1ToS2Side2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 375.84971939124802);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 375.84971939124796);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], -225.50983163474882);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -225.50983163474879);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::iS2ToS1Side2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -375.84971939124802);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -375.84971939124796);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 225.50983163474882);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 225.50983163474879);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::iSide1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 61054.235719797791);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 35403.869148733662);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 450.30474312695685);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -282.40336657045214);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::iSide2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 375.84971939124802);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 375.84971939124796);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], -225.50983163474882);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -225.50983163474879);
  res.clear();
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::twtStateNum_, res));
  ASSERT_EQ(res.size(), 0);

  int offset = 4;
  t2w->init(offset);
  std::vector<int> numVars;
  ASSERT_THROW_DYNAWO(t2w->getIndexesOfVariablesUsedForCalculatedVarI(42, numVars), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::i1Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  ASSERT_EQ(numVars[2], 2);
  ASSERT_EQ(numVars[3], 3);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::i2Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  ASSERT_EQ(numVars[2], 2);
  ASSERT_EQ(numVars[3], 3);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::p1Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  ASSERT_EQ(numVars[2], 2);
  ASSERT_EQ(numVars[3], 3);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::p2Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  ASSERT_EQ(numVars[2], 2);
  ASSERT_EQ(numVars[3], 3);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::q1Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  ASSERT_EQ(numVars[2], 2);
  ASSERT_EQ(numVars[3], 3);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::q2Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  ASSERT_EQ(numVars[2], 2);
  ASSERT_EQ(numVars[3], 3);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::iS1ToS2Side1Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  ASSERT_EQ(numVars[2], 2);
  ASSERT_EQ(numVars[3], 3);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::iS2ToS1Side1Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  ASSERT_EQ(numVars[2], 2);
  ASSERT_EQ(numVars[3], 3);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::iS1ToS2Side2Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  ASSERT_EQ(numVars[2], 2);
  ASSERT_EQ(numVars[3], 3);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::iS2ToS1Side2Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  ASSERT_EQ(numVars[2], 2);
  ASSERT_EQ(numVars[3], 3);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::iSide1Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  ASSERT_EQ(numVars[2], 2);
  ASSERT_EQ(numVars[3], 3);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::iSide2Num_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  ASSERT_EQ(numVars[2], 2);
  ASSERT_EQ(numVars[3], 3);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::twtStateNum_, numVars));
  ASSERT_EQ(numVars.size(), 0);
  numVars.clear();
  delete[] zConnected;
}
TEST(ModelsModelNetwork, ModelNetworkTwoWindingsTransformerCalculatedVariablesOpened) {
  shared_ptr<ModelTwoWindingsTransformer> t2w = createModelTwoWindingsTransformer(true, false, true, false, true, true, false).first;
  t2w->initSize();
  std::vector<double> y(t2w->sizeY(), 0.);
  std::vector<double> yp(t2w->sizeY(), 0.);
  std::vector<double> f(t2w->sizeF(), 0.);
  std::vector<double> z(t2w->sizeZ(), 0.);
  bool* zConnected = new bool[t2w->sizeZ()];
  for (int i = 0; i < t2w->sizeZ(); ++i)
    zConnected[i] = true;
  t2w->setReferenceZ(&z[0], zConnected, 0);
  t2w->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  t2w->evalYMat();
  ASSERT_EQ(t2w->sizeCalculatedVar(), ModelTwoWindingsTransformer::nbCalculatedVariables_);

  std::vector<double> calculatedVars(ModelTwoWindingsTransformer::nbCalculatedVariables_, 0.);
  t2w->setReferenceCalculatedVar(&calculatedVars[0], 0);
  t2w->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::i1Num_], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::i2Num_], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::p1Num_], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::p2Num_], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::q1Num_], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::q2Num_], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::iS1ToS2Side1Num_], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::iS2ToS1Side1Num_], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::iS1ToS2Side2Num_], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::iS2ToS1Side2Num_], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::iSide1Num_],  0);

  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::iSide2Num_], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelTwoWindingsTransformer::twtStateNum_], 1);
  std::vector<double> yI(2, 0.);
  yI[0] = 3.5;
  yI[1] = 2;
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::i1Num_),
      calculatedVars[ModelTwoWindingsTransformer::i1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::i2Num_),
      calculatedVars[ModelTwoWindingsTransformer::i2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::p1Num_),
      calculatedVars[ModelTwoWindingsTransformer::p1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::p2Num_),
      calculatedVars[ModelTwoWindingsTransformer::p2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::q1Num_),
      calculatedVars[ModelTwoWindingsTransformer::q1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::q2Num_),
      calculatedVars[ModelTwoWindingsTransformer::q2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::iS1ToS2Side1Num_),
      calculatedVars[ModelTwoWindingsTransformer::iS1ToS2Side1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::iS2ToS1Side1Num_),
      calculatedVars[ModelTwoWindingsTransformer::iS2ToS1Side1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::iS1ToS2Side2Num_),
      calculatedVars[ModelTwoWindingsTransformer::iS1ToS2Side2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::iS2ToS1Side2Num_),
      calculatedVars[ModelTwoWindingsTransformer::iS2ToS1Side2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::iSide1Num_),
      calculatedVars[ModelTwoWindingsTransformer::iSide1Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::iSide2Num_),
      calculatedVars[ModelTwoWindingsTransformer::iSide2Num_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->evalCalculatedVarI(ModelTwoWindingsTransformer::twtStateNum_),
      calculatedVars[ModelTwoWindingsTransformer::twtStateNum_]);
  ASSERT_THROW_DYNAWO(t2w->evalCalculatedVarI(42), Error::MODELER, KeyError_t::UndefCalculatedVarI);


  std::vector<double> res(4, 0.);
  ASSERT_THROW_DYNAWO(t2w->evalJCalculatedVarI(42, res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::i1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::i2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::p1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::p2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::q1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::q2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::iS1ToS2Side1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::iS2ToS1Side1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::iS1ToS2Side2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::iS2ToS1Side2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::iSide1Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0);
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::iSide2Num_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0);
  res.clear();
  ASSERT_NO_THROW(t2w->evalJCalculatedVarI(ModelTwoWindingsTransformer::twtStateNum_, res));
  ASSERT_EQ(res.size(), 0);

  int offset = 4;
  t2w->init(offset);
  std::vector<int> numVars;
  ASSERT_THROW_DYNAWO(t2w->getIndexesOfVariablesUsedForCalculatedVarI(42, numVars), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::i1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::i2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::p1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::p2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::q1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::q2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::iS1ToS2Side1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::iS2ToS1Side1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::iS1ToS2Side2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::iS2ToS1Side2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::iSide1Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::iSide2Num_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  numVars.clear();
  ASSERT_NO_THROW(t2w->getIndexesOfVariablesUsedForCalculatedVarI(ModelTwoWindingsTransformer::twtStateNum_, numVars));
  ASSERT_EQ(numVars.size(), 0);
  numVars.clear();
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkTwoWindingsTransformerDiscreteVariables) {
  std::pair<shared_ptr<ModelTwoWindingsTransformer>, shared_ptr<ModelVoltageLevel> > p = createModelTwoWindingsTransformer(false, false, true, false);
  shared_ptr<ModelTwoWindingsTransformer> t2w = p.first;
  t2w->initSize();
  unsigned nbZ = 6;
  unsigned nbG = 8;
  ASSERT_EQ(t2w->sizeZ(), nbZ);
  ASSERT_EQ(t2w->sizeG(), nbG);
  std::vector<double> y(t2w->sizeY(), 0.);
  std::vector<double> yp(t2w->sizeY(), 0.);
  std::vector<double> f(t2w->sizeF(), 0.);
  std::vector<double> z(nbZ, 0.);
  std::vector<state_g> g(nbG, ROOT_DOWN);
  t2w->setReferenceG(&g[0], 0);
  bool* zConnected = new bool[nbZ];
  for (size_t i = 0; i < nbZ; ++i)
    zConnected[i] = true;
  t2w->setReferenceZ(&z[0], zConnected, 0);
  t2w->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  t2w->evalYMat();

  t2w->getY0();
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelTwoWindingsTransformer::connectionStateNum_], CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelTwoWindingsTransformer::currentStepIndexNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelTwoWindingsTransformer::currentLimitsDesactivateNum_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelTwoWindingsTransformer::disableInternalTapChangerNum_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelTwoWindingsTransformer::tapChangerLockedNum_], 0.);

  z[ModelTwoWindingsTransformer::connectionStateNum_] = OPEN;
  ASSERT_EQ(t2w->evalZ(10.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(t2w->evalState(10.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(t2w->getConnectionState(), OPEN);

  z[ModelTwoWindingsTransformer::connectionStateNum_] = CLOSED_3;
  ASSERT_THROW_DYNAWO(t2w->evalZ(10.), Error::MODELER, KeyError_t::NoThirdSide);
  z[ModelTwoWindingsTransformer::connectionStateNum_] = CLOSED;
  ASSERT_EQ(t2w->evalZ(10.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(t2w->evalState(10.), NetworkComponent::TOPO_CHANGE);

  z[ModelTwoWindingsTransformer::currentStepIndexNum_] = 2.;
  z[ModelTwoWindingsTransformer::currentLimitsDesactivateNum_] = 2.;
  z[ModelTwoWindingsTransformer::disableInternalTapChangerNum_] = 4.;
  z[ModelTwoWindingsTransformer::tapChangerLockedNum_] = 6.;
  ASSERT_EQ(t2w->evalZ(10.), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(t2w->evalState(10.), NetworkComponent::STATE_CHANGE);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->getCurrentLimitsDesactivate(), 2.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->getDisableInternalTapChanger(), 4.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->getTapChangerLocked(), 6.);

  std::map<int, std::string> gEquationIndex;
  t2w->setGequations(gEquationIndex);
  ASSERT_EQ(gEquationIndex.size(), nbG);
  for (unsigned i = 0; i < nbG; ++i) {
    ASSERT_TRUE(gEquationIndex.find(i) != gEquationIndex.end());
  }

  ASSERT_NO_THROW(t2w->evalG(20.));
  ASSERT_EQ(g[0], ROOT_DOWN);
  ASSERT_EQ(g[1], ROOT_DOWN);
  ASSERT_EQ(g[2], ROOT_DOWN);
  ASSERT_EQ(g[3], ROOT_DOWN);
  ASSERT_EQ(g[4], ROOT_DOWN);
  ASSERT_EQ(g[5], ROOT_DOWN);
  ASSERT_EQ(g[6], ROOT_DOWN);
  ASSERT_EQ(g[7], ROOT_DOWN);

  shared_ptr<ModelTwoWindingsTransformer> t2wInit = createModelTwoWindingsTransformer(false, true, true, false).first;
  t2wInit->initSize();
  ASSERT_EQ(t2wInit->sizeF(), 0);
  ASSERT_EQ(t2wInit->sizeY(), 0);
  ASSERT_EQ(t2wInit->sizeZ(), 0);
  ASSERT_EQ(t2wInit->sizeG(), 0);

  shared_ptr<ModelTwoWindingsTransformer> t2wPhase = createModelTwoWindingsTransformer(false, false, false, true).first;
  t2wPhase->initSize();
  nbG = 10;
  ASSERT_EQ(t2wPhase->sizeZ(), nbZ);
  ASSERT_EQ(t2wPhase->sizeG(), nbG);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkTwoWindingsTransformerOpenedDiscreteVariables) {
  std::pair<shared_ptr<ModelTwoWindingsTransformer>, shared_ptr<ModelVoltageLevel> > p = createModelTwoWindingsTransformer(true, false, true,
      false, true, true, false);
  shared_ptr<ModelTwoWindingsTransformer> t2w = p.first;
  t2w->initSize();
  unsigned nbZ = 6;
  unsigned nbG = 8;
  ASSERT_EQ(t2w->sizeZ(), nbZ);
  ASSERT_EQ(t2w->sizeG(), nbG);
  std::vector<double> y(t2w->sizeY(), 0.);
  std::vector<double> yp(t2w->sizeY(), 0.);
  std::vector<double> f(t2w->sizeF(), 0.);
  std::vector<double> z(nbZ, 0.);
  bool* zConnected = new bool[nbZ];
  for (size_t i = 0; i < nbZ; ++i)
    zConnected[i] = true;
  std::vector<state_g> g(nbG, ROOT_DOWN);
  t2w->setReferenceG(&g[0], 0);
  t2w->setReferenceZ(&z[0], zConnected, 0);
  t2w->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  t2w->evalYMat();

  t2w->getY0();
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelTwoWindingsTransformer::connectionStateNum_], OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelTwoWindingsTransformer::currentStepIndexNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelTwoWindingsTransformer::currentLimitsDesactivateNum_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelTwoWindingsTransformer::disableInternalTapChangerNum_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelTwoWindingsTransformer::tapChangerLockedNum_], 0.);

  z[ModelTwoWindingsTransformer::connectionStateNum_] = CLOSED_1;
  ASSERT_EQ(t2w->evalZ(10.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(t2w->evalState(10.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(t2w->getConnectionState(), CLOSED_1);

  z[ModelTwoWindingsTransformer::connectionStateNum_] = CLOSED;
  ASSERT_EQ(t2w->evalZ(10.), NetworkComponent::NO_CHANGE);
  ASSERT_EQ(t2w->evalState(10.), NetworkComponent::NO_CHANGE);

  z[ModelTwoWindingsTransformer::currentStepIndexNum_] = 2.;
  z[ModelTwoWindingsTransformer::currentLimitsDesactivateNum_] = 2.;
  z[ModelTwoWindingsTransformer::disableInternalTapChangerNum_] = 4.;
  z[ModelTwoWindingsTransformer::tapChangerLockedNum_] = 6.;
  ASSERT_EQ(t2w->evalZ(10.), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(t2w->evalState(10.), NetworkComponent::STATE_CHANGE);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->getCurrentLimitsDesactivate(), 2.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->getDisableInternalTapChanger(), 4.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(t2w->getTapChangerLocked(), 6.);

  std::map<int, std::string> gEquationIndex;
  t2w->setGequations(gEquationIndex);
  ASSERT_EQ(gEquationIndex.size(), nbG);
  for (unsigned i = 0; i < nbG; ++i) {
    ASSERT_TRUE(gEquationIndex.find(i) != gEquationIndex.end());
  }

  ASSERT_NO_THROW(t2w->evalG(20.));
  ASSERT_EQ(g[0], ROOT_DOWN);
  ASSERT_EQ(g[1], ROOT_DOWN);
  ASSERT_EQ(g[2], ROOT_DOWN);
  ASSERT_EQ(g[3], ROOT_DOWN);
  ASSERT_EQ(g[4], ROOT_DOWN);
  ASSERT_EQ(g[5], ROOT_DOWN);
  ASSERT_EQ(g[6], ROOT_DOWN);

  shared_ptr<ModelTwoWindingsTransformer> t2wInit = createModelTwoWindingsTransformer(false, true, true, false).first;
  t2wInit->initSize();
  ASSERT_EQ(t2wInit->sizeF(), 0);
  ASSERT_EQ(t2wInit->sizeY(), 0);
  ASSERT_EQ(t2wInit->sizeZ(), 0);
  ASSERT_EQ(t2wInit->sizeG(), 0);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkTwoWindingsTransformerContinuousVariables) {
  std::pair<shared_ptr<ModelTwoWindingsTransformer>, shared_ptr<ModelVoltageLevel> > p = createModelTwoWindingsTransformer(false, false, true, false);
  shared_ptr<ModelTwoWindingsTransformer> t2w = p.first;
  t2w->initSize();
  unsigned nbY = 0;
  unsigned nbF = 0;
  t2w->evalYMat();
  ASSERT_EQ(t2w->sizeY(), nbY);
  ASSERT_EQ(t2w->sizeF(), nbF);

  // test evalYType
  ASSERT_NO_THROW(t2w->evalStaticYType());
  ASSERT_NO_THROW(t2w->evalStaticFType());
  ASSERT_NO_THROW(t2w->evalDynamicYType());
  ASSERT_NO_THROW(t2w->evalDynamicFType());

  // test evalF
  ASSERT_NO_THROW(t2w->evalF(UNDEFINED_EQ));

  // test setFequations
  std::map<int, std::string> fEquationIndex;
  t2w->setFequations(fEquationIndex);
  ASSERT_EQ(fEquationIndex.size(), nbF);
  ASSERT_NO_THROW(t2w->evalDerivativesPrim());
}

TEST(ModelsModelNetwork, ModelNetworkTwoWindingsTransformerDefineInstantiate) {
  std::pair<shared_ptr<ModelTwoWindingsTransformer>, shared_ptr<ModelVoltageLevel> > p = createModelTwoWindingsTransformer(false, false, true, false);
  shared_ptr<ModelTwoWindingsTransformer> t2w = p.first;

  std::vector<shared_ptr<Variable> > definedVariables;
  std::vector<shared_ptr<Variable> > instantiatedVariables;
  t2w->defineVariables(definedVariables);
  t2w->instantiateVariables(instantiatedVariables);
  ASSERT_EQ(definedVariables.size(), instantiatedVariables.size());

  for (size_t i = 0, iEnd = definedVariables.size(); i < iEnd; ++i) {
    std::string var = instantiatedVariables[i]->getName();
    boost::replace_all(var, t2w->id(), "@ID@");
    ASSERT_EQ(definedVariables[i]->getName(), var);
    ASSERT_EQ(definedVariables[i]->getType(), instantiatedVariables[i]->getType());
  }

  std::vector<ParameterModeler> parameters;
  t2w->defineNonGenericParameters(parameters);
  ASSERT_EQ(parameters.size(), 4);
  std::unordered_map<std::string, ParameterModeler> parametersModels;

  {
    ParameterModeler param = ParameterModeler("transformer_currentLimit_maxTimeOperation", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
    param.setValue<double>(10., PAR);
    parametersModels.insert(std::make_pair(param.getName(), param));
    ASSERT_THROW_DYNAWO(t2w->setSubModelParameters(parametersModels), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  }
  {
    ParameterModeler param = ParameterModeler("transformer_t1st_THT", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
    param.setValue<double>(1., PAR);
    parametersModels.insert(std::make_pair(param.getName(), param));
    ASSERT_THROW_DYNAWO(t2w->setSubModelParameters(parametersModels), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  }
  {
    ParameterModeler param = ParameterModeler("transformer_tNext_THT", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
    param.setValue<double>(1., PAR);
    parametersModels.insert(std::make_pair(param.getName(), param));
    ASSERT_THROW_DYNAWO(t2w->setSubModelParameters(parametersModels), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  }
  {
    ParameterModeler param = ParameterModeler("transformer_t1st_HT", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
    param.setValue<double>(1., PAR);
    parametersModels.insert(std::make_pair(param.getName(), param));
    ASSERT_THROW_DYNAWO(t2w->setSubModelParameters(parametersModels), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  }
  {
    ParameterModeler param = ParameterModeler("transformer_tNext_HT", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
    param.setValue<double>(1., PAR);
    parametersModels.insert(std::make_pair(param.getName(), param));
    ASSERT_THROW_DYNAWO(t2w->setSubModelParameters(parametersModels), Error::MODELER, KeyError_t::NetworkParameterNotFoundFor);
  }
  {
    ParameterModeler param = ParameterModeler("transformer_tolV", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
    param.setValue<double>(1., PAR);
    parametersModels.insert(std::make_pair(param.getName(), param));
    ASSERT_NO_THROW(t2w->setSubModelParameters(parametersModels));
  }
}

TEST(ModelsModelNetwork, ModelNetworkTwoWindingsTransformerJt) {
  std::pair<shared_ptr<ModelTwoWindingsTransformer>, shared_ptr<ModelVoltageLevel> > p = createModelTwoWindingsTransformer(false, false, true, false);
  shared_ptr<ModelTwoWindingsTransformer> t2w = p.first;
  t2w->initSize();
  t2w->evalYMat();
  SparseMatrix smj;
  int size = t2w->sizeY();
  smj.init(size, size);
  t2w->evalJt(smj, 1., 0);
  ASSERT_EQ(smj.nbElem(), 0);

  SparseMatrix smjPrime;
  smjPrime.init(size, size);
  t2w->evalJtPrim(smjPrime, 0);
  ASSERT_EQ(smjPrime.nbElem(), 0);
}

}  // namespace DYN
