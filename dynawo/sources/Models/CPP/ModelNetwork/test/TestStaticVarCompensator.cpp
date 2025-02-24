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
#include <powsybl/iidm/StaticVarCompensatorAdder.hpp>

#include "DYNStaticVarCompensatorInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNCurrentLimitInterfaceIIDM.h"
#include "DYNBusInterfaceIIDM.h"
#include "DYNModelStaticVarCompensator.h"
#include "DYNModelVoltageLevel.h"
#include "DYNModelBus.h"
#include "DYNModelNetwork.h"
#include "TLTimelineFactory.h"
#include "DYNSparseMatrix.h"
#include "DYNVariable.h"

#include "gtest_dynawo.h"

using boost::shared_ptr;

namespace DYN {
static std::tuple<std::shared_ptr<ModelStaticVarCompensator>, std::shared_ptr<ModelVoltageLevel>,
std::shared_ptr<VoltageLevelInterfaceIIDM> >  // need to return the voltage level so that it is not destroyed
createModelStaticVarCompensator(bool open, bool initModel, powsybl::iidm::Network& networkIIDM) {
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

  powsybl::iidm::StaticVarCompensator& svcIIDM = vlIIDM.newStaticVarCompensator()
    .setId("MyStaticVarCompensator")
    .setName("MyStaticVarCompensator_NAME")
    .setBus(iidmBus.getId())
    .setConnectableBus(iidmBus.getId())
    .setBmin(0.)
    .setBmax(5.)
    .setVoltageSetpoint(0.5)
    .setReactivePowerSetpoint(0.8)
    .setRegulationMode(powsybl::iidm::StaticVarCompensator::RegulationMode::REACTIVE_POWER)
    .add();
  svcIIDM.getTerminal().setP(3.);
  svcIIDM.getTerminal().setQ(5.);
  if (open)
    svcIIDM.getTerminal().disconnect();

  std::shared_ptr<StaticVarCompensatorInterfaceIIDM> scItfIIDM = std::make_shared<StaticVarCompensatorInterfaceIIDM>(svcIIDM);
  std::shared_ptr<VoltageLevelInterfaceIIDM> vlItfIIDM = std::make_shared<VoltageLevelInterfaceIIDM>(vlIIDM);
  std::shared_ptr<BusInterfaceIIDM> bus1ItfIIDM = std::make_shared<BusInterfaceIIDM>(iidmBus);
  vlItfIIDM->addBus(bus1ItfIIDM);
  vlItfIIDM->addStaticVarCompensator(scItfIIDM);
  scItfIIDM->setVoltageLevelInterface(vlItfIIDM);
  scItfIIDM->setBusInterface(bus1ItfIIDM);

  std::shared_ptr<ModelStaticVarCompensator> sc = std::make_shared<ModelStaticVarCompensator>(scItfIIDM);
  ModelNetwork* network = new ModelNetwork();
  network->setIsInitModel(initModel);
  network->setTimeline(timeline::TimelineFactory::newInstance("Test"));
  sc->setNetwork(network);
  std::shared_ptr<ModelVoltageLevel> vl = std::make_shared<ModelVoltageLevel>(vlItfIIDM);
  std::shared_ptr<ModelBus> bus1 = std::make_shared<ModelBus>(bus1ItfIIDM, false);
  vl->addComponent(sc);
  vl->addBus(bus1);
  bus1->setNetwork(network);
  bus1->setVoltageLevel(vl);
  sc->setModelBus(bus1);
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
  z1[ModelBus::switchOffNum_] = -1;
  int offset = 0;
  bus1->init(offset);
  return std::make_tuple(sc, vl, vlItfIIDM);
}

static void
fillParameters(std::shared_ptr<ModelStaticVarCompensator> svc, std::string& startingPoint) {
  std::unordered_map<std::string, ParameterModeler> parametersModels;
  {
    ParameterModeler param = ParameterModeler("startingPointMode", VAR_TYPE_STRING, EXTERNAL_PARAMETER);
    param.setValue<std::string>(startingPoint, PAR);
    parametersModels.insert(std::make_pair(param.getName(), param));
  }
  svc->setSubModelParameters(parametersModels);
}

TEST(ModelsModelNetwork, ModelNetworkStaticVarCompensatorInitialization) {
  powsybl::iidm::Network networkIIDM("MyNetwork", "MyNetwork");
  auto tuple = createModelStaticVarCompensator(false, false, networkIIDM);
  std::shared_ptr<ModelStaticVarCompensator> svc = std::get<0>(tuple);
  int offSet = 0;
  svc->init(offSet);
  ASSERT_EQ(svc->id(), "MyStaticVarCompensator");
  ASSERT_TRUE(svc->isConnected());
  ASSERT_EQ(svc->getConnected(), CLOSED);
}

TEST(ModelsModelNetwork, ModelNetworkStaticVarCompensatorCalculatedVariables) {
  powsybl::iidm::Network networkIIDM("MyNetwork", "MyNetwork");
  auto tuple = createModelStaticVarCompensator(false, false, networkIIDM);
  std::shared_ptr<ModelStaticVarCompensator> svc = std::get<0>(tuple);
  int offSet = 0;
  svc->init(offSet);
  svc->initSize();
  std::vector<double> y(svc->sizeY(), 0.);
  std::vector<double> yp(svc->sizeY(), 0.);
  std::vector<double> f(svc->sizeF(), 0.);
  std::vector<double> z(svc->sizeZ(), 0.);
  bool* zConnected = new bool[svc->sizeZ()];
  for (int i = 0; i < svc->sizeZ(); ++i)
    zConnected[i] = true;
  svc->setReferenceZ(&z[0], zConnected, 0);
  svc->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  svc->evalYMat();
  ASSERT_EQ(svc->sizeCalculatedVar(), ModelStaticVarCompensator::nbCalculatedVariables_);

  std::vector<double> calculatedVars(ModelStaticVarCompensator::nbCalculatedVariables_, 0.);
  svc->setReferenceCalculatedVar(&calculatedVars[0], 0);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelStaticVarCompensator::pNum_], -12.1875);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelStaticVarCompensator::qNum_], -20.3125);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelStaticVarCompensator::pNum_), calculatedVars[ModelStaticVarCompensator::pNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelStaticVarCompensator::qNum_), calculatedVars[ModelStaticVarCompensator::qNum_]);
  svc->setConnected(OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelStaticVarCompensator::pNum_), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelStaticVarCompensator::qNum_), 0.);
  svc->setConnected(CLOSED);
  ASSERT_THROW_DYNAWO(svc->evalCalculatedVarI(42), Error::MODELER, KeyError_t::UndefCalculatedVarI);

  std::vector<double> res(3, 0.);
  ASSERT_THROW_DYNAWO(svc->evalJCalculatedVarI(42, res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(svc->evalJCalculatedVarI(ModelStaticVarCompensator::qNum_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -8.75);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -5);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 16.25);
  res.clear();
  svc->setConnected(OPEN);
  ASSERT_NO_THROW(svc->evalJCalculatedVarI(ModelStaticVarCompensator::qNum_, res));
  ASSERT_TRUE(res.empty());

  svc->setConnected(CLOSED);
  int offset = 2;
  svc->init(offset);
  std::vector<int> numVars;
  ASSERT_THROW_DYNAWO(svc->getIndexesOfVariablesUsedForCalculatedVarI(42, numVars), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(svc->getIndexesOfVariablesUsedForCalculatedVarI(ModelStaticVarCompensator::qNum_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  numVars.clear();
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkStaticVarCompensatorCalculatedVariablesFlat) {
  powsybl::iidm::Network networkIIDM("MyNetwork", "MyNetwork");
  auto tuple = createModelStaticVarCompensator(false, false, networkIIDM);
  std::shared_ptr<ModelStaticVarCompensator> svc = std::get<0>(tuple);
  int offSet = 0;
  std::string startingPoint = "flat";
  fillParameters(svc, startingPoint);
  svc->init(offSet);
  svc->initSize();
  std::vector<double> y(svc->sizeY(), 0.);
  std::vector<double> yp(svc->sizeY(), 0.);
  std::vector<double> f(svc->sizeF(), 0.);
  std::vector<double> z(svc->sizeZ(), 0.);
  bool* zConnected = new bool[svc->sizeZ()];
  for (int i = 0; i < svc->sizeZ(); ++i)
    zConnected[i] = true;
  svc->setReferenceZ(&z[0], zConnected, 0);
  svc->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  svc->evalYMat();
  ASSERT_EQ(svc->sizeCalculatedVar(), ModelStaticVarCompensator::nbCalculatedVariables_);

  std::vector<double> calculatedVars(ModelStaticVarCompensator::nbCalculatedVariables_, 0.);
  svc->setReferenceCalculatedVar(&calculatedVars[0], 0);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelStaticVarCompensator::pNum_], -0.4875);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelStaticVarCompensator::qNum_], -0.13);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelStaticVarCompensator::pNum_), calculatedVars[ModelStaticVarCompensator::pNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelStaticVarCompensator::qNum_), calculatedVars[ModelStaticVarCompensator::qNum_]);
  svc->setConnected(OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelStaticVarCompensator::pNum_), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelStaticVarCompensator::qNum_), 0.);
  svc->setConnected(CLOSED);
  ASSERT_THROW_DYNAWO(svc->evalCalculatedVarI(42), Error::MODELER, KeyError_t::UndefCalculatedVarI);

  std::vector<double> res(3, 0.);
  ASSERT_THROW_DYNAWO(svc->evalJCalculatedVarI(42, res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(svc->evalJCalculatedVarI(ModelStaticVarCompensator::qNum_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -0.056);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -0.032);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 16.25);
  res.clear();
  svc->setConnected(OPEN);
  ASSERT_NO_THROW(svc->evalJCalculatedVarI(ModelStaticVarCompensator::qNum_, res));
  ASSERT_TRUE(res.empty());

  svc->setConnected(CLOSED);
  int offset = 2;
  svc->init(offset);
  std::vector<int> numVars;
  ASSERT_THROW_DYNAWO(svc->getIndexesOfVariablesUsedForCalculatedVarI(42, numVars), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(svc->getIndexesOfVariablesUsedForCalculatedVarI(ModelStaticVarCompensator::qNum_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  numVars.clear();
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkStaticVarCompensatorDiscreteVariables) {
  powsybl::iidm::Network networkIIDM("MyNetwork", "MyNetwork");
  bool deactivateRootFunctions = false;
  auto tuple = createModelStaticVarCompensator(false, false, networkIIDM);
  std::shared_ptr<ModelStaticVarCompensator> svc = std::get<0>(tuple);
  int offSet = 0;
  svc->init(offSet);
  svc->initSize();
  unsigned nbZ = 2;
  unsigned nbG = 0;
  ASSERT_EQ(svc->sizeZ(), nbZ);
  ASSERT_EQ(svc->sizeG(), nbG);
  std::vector<double> y(svc->sizeY(), 0.);
  std::vector<double> yp(svc->sizeY(), 0.);
  std::vector<double> f(svc->sizeF(), 0.);
  std::vector<double> z(nbZ, 0.);
  std::vector<state_g> g(nbG, NO_ROOT);
  svc->setReferenceG(&g[0], 0);
  bool* zConnected = new bool[svc->sizeZ()];
  for (int i = 0; i < svc->sizeZ(); ++i)
    zConnected[i] = true;
  svc->setReferenceZ(&z[0], zConnected, 0);
  svc->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);

  svc->getY0();
  ASSERT_EQ(svc->getConnected(), CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelStaticVarCompensator::modeNum_], StaticVarCompensatorInterface::RUNNING_Q);
  ASSERT_EQ(z[ModelStaticVarCompensator::connectionStateNum_], svc->getConnected());

  z[ModelStaticVarCompensator::connectionStateNum_] = OPEN;
  ASSERT_EQ(svc->evalZ(10., deactivateRootFunctions), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(svc->evalState(10.), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(svc->getConnected(), OPEN);
  ASSERT_EQ(z[ModelStaticVarCompensator::connectionStateNum_], OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelStaticVarCompensator::modeNum_], StaticVarCompensatorInterface::RUNNING_Q);

  std::map<int, std::string> gEquationIndex;
  svc->setGequations(gEquationIndex);
  ASSERT_EQ(gEquationIndex.size(), nbG);
  for (unsigned i = 0; i < nbG; ++i) {
    ASSERT_TRUE(gEquationIndex.find(i) != gEquationIndex.end());
  }
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkStaticVarCompensatorContinuousVariables) {
  powsybl::iidm::Network networkIIDM("MyNetwork", "MyNetwork");
  auto tuple = createModelStaticVarCompensator(false, false, networkIIDM);
  std::shared_ptr<ModelStaticVarCompensator> svc = std::get<0>(tuple);
  int offSet = 0;
  svc->init(offSet);
  svc->initSize();
  unsigned nbY = 0;
  unsigned nbF = 0;
  std::vector<double> y(nbY, 0.);
  std::vector<double> yp(nbY, 0.);
  std::vector<double> f(nbF, 0.);
  std::vector<double> z(svc->sizeZ(), 0.);
  std::vector<state_g> g(svc->sizeG(), NO_ROOT);
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  svc->evalYMat();
  svc->setBufferYType(&yTypes[0], 0);
  svc->setBufferFType(&fTypes[0], 0);
  svc->setReferenceG(&g[0], 0);
  bool* zConnected = new bool[svc->sizeZ()];
  for (int i = 0; i < svc->sizeZ(); ++i)
    zConnected[i] = true;
  svc->setReferenceZ(&z[0], zConnected, 0);
  svc->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  ASSERT_EQ(svc->sizeY(), nbY);
  ASSERT_EQ(svc->sizeF(), nbF);

  // test evalStaticYType
  ASSERT_NO_THROW(svc->evalStaticYType());
  ASSERT_NO_THROW(svc->evalDynamicYType());
  ASSERT_NO_THROW(svc->evalStaticFType());
  ASSERT_NO_THROW(svc->evalDynamicFType());

  // test evalF
  ASSERT_NO_THROW(svc->evalF(UNDEFINED_EQ));

  // test setFequations
  std::map<int, std::string> fEquationIndex;
  svc->setFequations(fEquationIndex);
  ASSERT_EQ(fEquationIndex.size(), nbF);
  ASSERT_NO_THROW(svc->evalDerivatives(0.));
  ASSERT_NO_THROW(svc->evalDerivativesPrim());
  ASSERT_NO_THROW(svc->addBusNeighbors());
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkStaticVarCompensatorDefineInstantiate) {
  powsybl::iidm::Network networkIIDM("MyNetwork", "MyNetwork");
  auto tuple = createModelStaticVarCompensator(false, false, networkIIDM);
  std::shared_ptr<ModelStaticVarCompensator> svc = std::get<0>(tuple);
  int offSet = 0;
  svc->init(offSet);
  svc->initSize();

  std::vector<shared_ptr<Variable> > definedVariables;
  std::vector<shared_ptr<Variable> > instantiatedVariables;
  svc->defineVariables(definedVariables);
  svc->instantiateVariables(instantiatedVariables);
  ASSERT_EQ(definedVariables.size(), instantiatedVariables.size());

  for (size_t i = 0, iEnd = definedVariables.size(); i < iEnd; ++i) {
    std::string var = instantiatedVariables[i]->getName();
    boost::replace_all(var, svc->id(), "@ID@");
    ASSERT_EQ(definedVariables[i]->getName(), var);
    ASSERT_EQ(definedVariables[i]->getType(), instantiatedVariables[i]->getType());
  }


  std::vector<ParameterModeler> parameters;
  svc->defineNonGenericParameters(parameters);
  ASSERT_EQ(parameters.size(), 0);
  std::unordered_map<std::string, ParameterModeler> parametersModels;
  ASSERT_NO_THROW(svc->setSubModelParameters(parametersModels));
}

TEST(ModelsModelNetwork, ModelNetworkStaticVarCompensatorJt) {
  powsybl::iidm::Network networkIIDM("MyNetwork", "MyNetwork");
  auto tuple = createModelStaticVarCompensator(false, false, networkIIDM);
  std::shared_ptr<ModelStaticVarCompensator> svc = std::get<0>(tuple);
  int offSet = 0;
  svc->init(offSet);
  svc->initSize();
  std::vector<double> y(svc->sizeY(), 0.);
  std::vector<double> yp(svc->sizeY(), 0.);
  std::vector<double> f(svc->sizeF(), 0.);
  std::vector<double> z(svc->sizeZ(), 0.);
  std::vector<state_g> g(svc->sizeG(), NO_ROOT);
  std::vector<propertyContinuousVar_t> yTypes(svc->sizeY(), UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(svc->sizeF(), UNDEFINED_EQ);
  svc->evalYMat();
  svc->setBufferYType(&yTypes[0], 0);
  svc->setBufferFType(&fTypes[0], 0);
  svc->setReferenceG(&g[0], 0);
  bool* zConnected = new bool[svc->sizeZ()];
  for (int i = 0; i < svc->sizeZ(); ++i)
    zConnected[i] = true;
  svc->setReferenceZ(&z[0], zConnected, 0);
  svc->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  svc->evalYMat();
  SparseMatrix smj;
  int size = svc->sizeY();
  smj.init(size, size);
  svc->evalJt(smj, 1., 0);
  ASSERT_EQ(smj.nbElem(), 0);

  SparseMatrix smjPrime;
  smjPrime.init(size, size);
  svc->evalJtPrim(smjPrime, 0);
  ASSERT_EQ(smjPrime.nbElem(), 0);
  delete[] zConnected;
}

}  // namespace DYN
