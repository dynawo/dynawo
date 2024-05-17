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
#include <powsybl/iidm/DanglingLine.hpp>
#include <powsybl/iidm/DanglingLineAdder.hpp>
#include <powsybl/iidm/CurrentLimitsAdder.hpp>

#include "DYNDanglingLineInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNCurrentLimitInterfaceIIDM.h"
#include "DYNBusInterfaceIIDM.h"
#include "DYNModelDanglingLine.h"
#include "DYNModelVoltageLevel.h"
#include "DYNModelBus.h"
#include "DYNModelNetwork.h"
#include "TLTimelineFactory.h"
#include "DYNSparseMatrix.h"
#include "DYNVariable.h"

#include "make_unique.hpp"
#include "gtest_dynawo.h"

using boost::shared_ptr;

namespace DYN {
static std::pair<std::unique_ptr<ModelDanglingLine>, std::shared_ptr<ModelVoltageLevel> >  // need to return the voltage level so that it is not destroyed
createModelDanglingLine(bool open, bool initModel) {
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

  powsybl::iidm::DanglingLine& dlIIDM = vlIIDM.newDanglingLine()
       .setId("MyDanglingLine")
       .setBus("MyBus1")
       .setConnectableBus("MyBus1")
       .setName("MyDanglingLine_NAME")
       .setB(3.0)
       .setG(3.0)
       .setP0(105.0)
       .setQ0(90.0)
       .setR(3.0)
       .setX(3.0)
       .setUcteXnodeCode("ucteXnodeCodeTest")
       .add();
  dlIIDM.getTerminal().setP(105.);
  dlIIDM.getTerminal().setQ(90.);
  dlIIDM.newCurrentLimits().setPermanentLimit(200)
      .beginTemporaryLimit().setName("MyLimit").setValue(10.).setAcceptableDuration(5.).endTemporaryLimit()
      .beginTemporaryLimit().setName("MyLimit2").setValue(15.).setAcceptableDuration(10.).endTemporaryLimit()
      .add();
  if (open)
    dlIIDM.getTerminal().disconnect();
  std::shared_ptr<DanglingLineInterfaceIIDM> dlItfIIDM = std::make_shared<DanglingLineInterfaceIIDM>(dlIIDM);
  std::shared_ptr<VoltageLevelInterfaceIIDM> vlItfIIDM = std::make_shared<VoltageLevelInterfaceIIDM>(vlIIDM);
  std::shared_ptr<BusInterfaceIIDM> bus1ItfIIDM = std::make_shared<BusInterfaceIIDM>(iidmBus);
  dlItfIIDM->setVoltageLevelInterface(vlItfIIDM);
  dlItfIIDM->setBusInterface(bus1ItfIIDM);
  powsybl::iidm::CurrentLimits& currentLimits = dlIIDM.getCurrentLimits();

  // permanent limit
  if (!std::isnan(currentLimits.getPermanentLimit())) {
    std::unique_ptr<CurrentLimitInterfaceIIDM> cLimit = DYN::make_unique<CurrentLimitInterfaceIIDM>(currentLimits.getPermanentLimit(),
                                                                                                    std::numeric_limits<unsigned long>::max());
    dlItfIIDM->addCurrentLimitInterface(std::move(cLimit));
  }

  // temporary limit
  for (auto& currentLimit : currentLimits.getTemporaryLimits()) {
    if (!currentLimit.isFictitious()) {
      std::unique_ptr<CurrentLimitInterfaceIIDM> cLimit = DYN::make_unique<CurrentLimitInterfaceIIDM>(currentLimit.getValue(),
                                                                                                      currentLimit.getAcceptableDuration());
      dlItfIIDM->addCurrentLimitInterface(std::move(cLimit));
    }
  }

  std::unique_ptr<ModelDanglingLine> dl = DYN::make_unique<ModelDanglingLine>(dlItfIIDM);
  ModelNetwork* network = new ModelNetwork();
  network->setIsInitModel(initModel);
  network->setTimeline(timeline::TimelineFactory::newInstance("Test"));
  dl->setNetwork(network);
  std::shared_ptr<ModelVoltageLevel> vl = std::make_shared<ModelVoltageLevel>(vlItfIIDM);
  std::shared_ptr<ModelBus> bus1 = std::make_shared<ModelBus>(bus1ItfIIDM, true);
  bus1->setNetwork(network);
  bus1->setVoltageLevel(vl);
  dl->setModelBus(bus1);
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
  int offset = 0;
  bus1->init(offset);
  return std::make_pair(std::move(dl), vl);
}


TEST(ModelsModelNetwork, ModelNetworkDanglingLineInitializationClosed) {
  const std::unique_ptr<ModelDanglingLine> dl = createModelDanglingLine(false, false).first;
  ASSERT_EQ(dl->id(), "MyDanglingLine");
  ASSERT_EQ(dl->getConnectionState(), CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getCurrentLimitsDesactivate(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getP(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getQ(), 0.);
}

TEST(ModelsModelNetwork, ModelNetworkDanglingLineInitializationOpened) {
  const std::unique_ptr<ModelDanglingLine> dl = createModelDanglingLine(true, false).first;
  ASSERT_EQ(dl->id(), "MyDanglingLine");
  ASSERT_EQ(dl->getConnectionState(), OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getCurrentLimitsDesactivate(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getP(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getQ(), 0.);
}

TEST(ModelsModelNetwork, ModelNetworkDanglingLineCalculatedVariables) {
  const std::unique_ptr<ModelDanglingLine> dl = createModelDanglingLine(false, false).first;
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
  y[ModelDanglingLine::urFictNum_] = 4.;
  y[ModelDanglingLine::uiFictNum_] = 1.5;
  ASSERT_EQ(dl->sizeCalculatedVar(), ModelDanglingLine::nbCalculatedVariables_);

  std::vector<double> calculatedVars(ModelDanglingLine::nbCalculatedVariables_, 0.);
  dl->setReferenceCalculatedVar(&calculatedVars[0], 0);
  dl->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelDanglingLine::iNum_], 4.3158702611537239);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelDanglingLine::pNum_], 12.270833333333332);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelDanglingLine::qNum_], -12.333333333333336);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelDanglingLine::iNum_), calculatedVars[ModelDanglingLine::iNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelDanglingLine::pNum_), calculatedVars[ModelDanglingLine::pNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelDanglingLine::qNum_), calculatedVars[ModelDanglingLine::qNum_]);
  ASSERT_THROW_DYNAWO(dl->evalCalculatedVarI(42), Error::MODELER, KeyError_t::UndefCalculatedVarI);

  std::vector<double> res(4, 0.);
  ASSERT_THROW_DYNAWO(dl->evalJCalculatedVarI(42, res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelDanglingLine::iNum_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.89020606654237955);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.57965971165276509);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.029365134594484289);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -0.051087288952047991);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelDanglingLine::pNum_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 5.3124999999999991);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 3.270833333333333);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], -0.062499999999999972);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -0.22916666666666669);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelDanglingLine::qNum_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -5.0625000000000009);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -3.0625);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], -0.22916666666666669);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.062499999999999972);
  dl->setConnectionState(OPEN);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelDanglingLine::iNum_, res));
  for (size_t i = 0; i < res.size(); ++i) {
    ASSERT_DOUBLE_EQUALS_DYNAWO(res[i], 0.);
  }
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelDanglingLine::pNum_, res));
  for (size_t i = 0; i < res.size(); ++i) {
    ASSERT_DOUBLE_EQUALS_DYNAWO(res[i], 0.);
  }
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelDanglingLine::qNum_, res));
  for (size_t i = 0; i < res.size(); ++i) {
    ASSERT_DOUBLE_EQUALS_DYNAWO(res[i], 0.);
  }

  int offset = 2;
  dl->init(offset);
  std::vector<int> numVars;
  ASSERT_THROW_DYNAWO(dl->getIndexesOfVariablesUsedForCalculatedVarI(42, numVars), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelDanglingLine::iNum_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelDanglingLine::pNum_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getIndexesOfVariablesUsedForCalculatedVarI(ModelDanglingLine::qNum_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();

  const std::unique_ptr<ModelDanglingLine> dlInit = createModelDanglingLine(false, true).first;
  dlInit->initSize();
  ASSERT_EQ(dlInit->sizeCalculatedVar(), 0);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkDanglingLineDiscreteVariables) {
  std::pair<std::unique_ptr<ModelDanglingLine>, std::shared_ptr<ModelVoltageLevel> > p = createModelDanglingLine(false, false);
  const std::unique_ptr<ModelDanglingLine>& dl = p.first;
  dl->initSize();
  unsigned nbZ = 2;
  unsigned nbG = 6;
  ASSERT_EQ(dl->sizeZ(), nbZ);
  ASSERT_EQ(dl->sizeG(), nbG);
  std::vector<double> y(dl->sizeY(), 0.);
  std::vector<double> yp(dl->sizeY(), 0.);
  std::vector<double> f(dl->sizeF(), 0.);
  std::vector<double> z(nbZ, 0.);
  bool* zConnected = new bool[dl->sizeZ()];
  for (int i = 0; i < dl->sizeZ(); ++i)
    zConnected[i] = true;
  std::vector<state_g> g(nbG, NO_ROOT);
  dl->setReferenceG(&g[0], 0);
  dl->setReferenceZ(&z[0], zConnected, 0);
  dl->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);

  dl->getY0();
  ASSERT_EQ(dl->getConnectionState(), CLOSED);
  ASSERT_EQ(z[0], dl->getConnectionState());
  dl->setConnectionState(OPEN);
  dl->getY0();
  ASSERT_EQ(dl->getConnectionState(), OPEN);
  ASSERT_EQ(z[0], dl->getConnectionState());
  dl->setConnectionState(CLOSED);

  z[0] = OPEN;
  z[1] = 0.;
  dl->evalZ(0.);
  ASSERT_EQ(dl->getConnectionState(), OPEN);
  ASSERT_EQ(z[0], OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getCurrentLimitsDesactivate(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[1], dl->getCurrentLimitsDesactivate());

  ASSERT_EQ(dl->evalState(0.), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(dl->getConnectionState(), OPEN);
  z[0] = CLOSED;
  dl->evalZ(0.);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(dl->getConnectionState(), CLOSED);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::NO_CHANGE);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getConnectionState(), CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getCurrentLimitsDesactivate(), 0.);
  z[1] = 42.;
  dl->evalZ(0.);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::NO_CHANGE);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getCurrentLimitsDesactivate(), 42.);
  z[1] = 0.;
  dl->evalZ(0.);
  ASSERT_EQ(dl->evalState(0.), NetworkComponent::NO_CHANGE);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getCurrentLimitsDesactivate(), 0.);

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

  const std::unique_ptr<ModelDanglingLine> dlInit = createModelDanglingLine(false, true).first;
  dlInit->initSize();
  ASSERT_EQ(dlInit->sizeZ(), 0);
  ASSERT_EQ(dlInit->sizeG(), 0);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkDanglingLineContinuousVariables) {
  std::pair<std::unique_ptr<ModelDanglingLine>, std::shared_ptr<ModelVoltageLevel> > p = createModelDanglingLine(false, false);
  const std::unique_ptr<ModelDanglingLine>& dl = p.first;
  dl->initSize();
  unsigned nbY = 2;
  unsigned nbF = 2;
  unsigned urIndex = 0;
  unsigned uiIndex = 1;
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
  y[ModelDanglingLine::urFictNum_] = 4.;
  y[ModelDanglingLine::uiFictNum_] = 1.5;
  dl->setBufferYType(&yTypes[0], 0);
  dl->setBufferFType(&fTypes[0], 0);

  // test evalStaticYType
  dl->evalStaticYType();
  dl->evalDynamicYType();
  ASSERT_EQ(yTypes[urIndex], ALGEBRAIC);
  ASSERT_EQ(yTypes[uiIndex], ALGEBRAIC);
  dl->evalStaticFType();
  dl->evalDynamicFType();
  ASSERT_EQ(fTypes[urIndex], ALGEBRAIC_EQ);
  ASSERT_EQ(fTypes[uiIndex], ALGEBRAIC_EQ);

  // test getY0
  y[urIndex] = 2.;
  y[uiIndex] = 5.;
  dl->getY0();
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[urIndex], -116.8);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[uiIndex], -5.3999999999999844);

  // test evalF
  dl->evalF(UNDEFINED_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[urIndex], -5.3301593716322637);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[uiIndex], 4.7114409765398335);

  // test setFequations
  std::map<int, std::string> fEquationIndex;
  dl->setFequations(fEquationIndex);
  ASSERT_EQ(fEquationIndex.size(), 2);
  for (unsigned i = 0; i < nbF; ++i) {
    ASSERT_TRUE(fEquationIndex.find(i) != fEquationIndex.end());
  }

  // test getY0 (bus switchoff)
  dl->getModelBus()->switchOff();
  dl->getY0();
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[urIndex], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[uiIndex], 0.);

  // test evalF (bus switchoff)
  dl->evalF(UNDEFINED_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[urIndex], y[urIndex]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[uiIndex], y[uiIndex]);

  // test setFequations
  fEquationIndex.clear();
  dl->setFequations(fEquationIndex);
  ASSERT_EQ(fEquationIndex.size(), 2);
  for (unsigned i = 0; i < nbF; ++i) {
    ASSERT_TRUE(fEquationIndex.find(i) != fEquationIndex.end());
  }

  const std::unique_ptr<ModelDanglingLine> dlInit = createModelDanglingLine(false, true).first;
  dlInit->initSize();
  ASSERT_EQ(dlInit->sizeY(), 0);
  ASSERT_EQ(dlInit->sizeF(), 0);
  ASSERT_NO_THROW(dlInit->getY0());
  ASSERT_NO_THROW(dlInit->evalF(UNDEFINED_EQ));
  fEquationIndex.clear();
  ASSERT_NO_THROW(dlInit->setFequations(fEquationIndex));
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkDanglingLineDefineInstantiate) {
  std::pair<std::unique_ptr<ModelDanglingLine>, std::shared_ptr<ModelVoltageLevel> > p = createModelDanglingLine(false, false);
  const std::unique_ptr<ModelDanglingLine>& dl = p.first;

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


  std::vector<ParameterModeler> parameters;
  dl->defineNonGenericParameters(parameters);
  ASSERT_TRUE(parameters.empty());
  std::unordered_map<std::string, ParameterModeler> parametersModels;
  const std::string paramName = "dangling_line_currentLimit_maxTimeOperation";
  ParameterModeler param = ParameterModeler(paramName, VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
  param.setValue<double>(10., PAR);
  parametersModels.insert(std::make_pair(paramName, param));
  ASSERT_NO_THROW(dl->setSubModelParameters(parametersModels));
}

TEST(ModelsModelNetwork, ModelNetworkDanglingLineJt) {
  std::pair<std::unique_ptr<ModelDanglingLine>, std::shared_ptr<ModelVoltageLevel> > p = createModelDanglingLine(false, false);
  const std::unique_ptr<ModelDanglingLine>& dl = p.first;
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
  y[ModelDanglingLine::urFictNum_] = 4.;
  y[ModelDanglingLine::uiFictNum_] = 1.5;
  SparseMatrix smj;
  int size = dl->sizeY();
  smj.init(size, size);
  dl->evalJt(1., 0, smj);
  ASSERT_EQ(smj.nbElem(), 8);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.getAx()[0], -0.041666666666666664);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.getAx()[1], -0.041666666666666671);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.getAx()[2], -0.034107399762306888);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.getAx()[3],  0.040991117783198847);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.getAx()[4],  0.041666666666666671);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.getAx()[5], -0.041666666666666664);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.getAx()[6], -0.042342215550134496);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.getAx()[7],  0.11744073309564021);
  ASSERT_EQ(smj.getAp()[0], 0);
  ASSERT_EQ(smj.getAp()[1], 4);
  ASSERT_EQ(smj.getAp()[2], 8);

  dl->getModelBus()->switchOff();
  SparseMatrix smj2;
  smj2.init(size, size);
  dl->evalJt(1., 0, smj2);
  ASSERT_EQ(smj2.nbElem(), 2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.getAx()[0], 1.0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.getAx()[1], 1.0);
  ASSERT_EQ(smj2.getAp()[0], 0);
  ASSERT_EQ(smj2.getAp()[1], 1);

  SparseMatrix smjPrime;
  smjPrime.init(size, size);
  dl->evalJtPrim(0, smjPrime);
  ASSERT_EQ(smjPrime.nbElem(), 0);

  const std::unique_ptr<ModelDanglingLine> dlInit = createModelDanglingLine(false, true).first;
  dlInit->initSize();
  SparseMatrix smjInit;
  smjInit.init(dlInit->sizeY(), dlInit->sizeY());
  ASSERT_NO_THROW(dlInit->evalJt(1., 0, smjInit));
  ASSERT_EQ(smjInit.nbElem(), 0);
  delete[] zConnected;
}


}  // namespace DYN
