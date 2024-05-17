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
#include <powsybl/iidm/ShuntCompensator.hpp>
#include <powsybl/iidm/ShuntCompensatorAdder.hpp>

#include "DYNShuntCompensatorInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNCurrentLimitInterfaceIIDM.h"
#include "DYNBusInterfaceIIDM.h"
#include "DYNModelShuntCompensator.h"
#include "DYNModelVoltageLevel.h"
#include "DYNModelBus.h"
#include "DYNModelNetwork.h"
#include "TLTimelineFactory.h"
#include "DYNSparseMatrix.h"
#include "DYNVariable.h"
#include "DYNElement.h"

#include "gtest_dynawo.h"

using boost::shared_ptr;

namespace DYN {
static std::tuple<shared_ptr<ModelShuntCompensator>, shared_ptr<ModelVoltageLevel>,
shared_ptr<VoltageLevelInterfaceIIDM> >  // need to return the voltage level so that it is not destroyed
createModelShuntCompensator(bool open, bool capacitor, bool initModel, powsybl::iidm::Network& networkIIDM) {
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

  double bPerSection = 8.;
  if (!capacitor)
    bPerSection = -8.;
  powsybl::iidm::ShuntCompensator& shuntIIDM = vlIIDM.newShuntCompensator()
      .setId("MyShuntCompensator")
      .setName("MyShuntCompensator_NAME")
      .setBus(iidmBus.getId())
      .setConnectableBus(iidmBus.getId())
      .newLinearModel()
      .setBPerSection(bPerSection)
      .setMaximumSectionCount(5UL)
      .add()
      .setSectionCount(1UL)
      .add();
  shuntIIDM.getTerminal().setQ(5.);
  if (open)
    shuntIIDM.getTerminal().disconnect();
  shared_ptr<ShuntCompensatorInterfaceIIDM> scItfIIDM = shared_ptr<ShuntCompensatorInterfaceIIDM>(new ShuntCompensatorInterfaceIIDM(shuntIIDM));
  shared_ptr<VoltageLevelInterfaceIIDM> vlItfIIDM = shared_ptr<VoltageLevelInterfaceIIDM>(new VoltageLevelInterfaceIIDM(vlIIDM));
  shared_ptr<BusInterfaceIIDM> bus1ItfIIDM = shared_ptr<BusInterfaceIIDM>(new BusInterfaceIIDM(iidmBus));
  scItfIIDM->setVoltageLevelInterface(vlItfIIDM);
  scItfIIDM->setBusInterface(bus1ItfIIDM);
  vlItfIIDM->addBus(bus1ItfIIDM);
  vlItfIIDM->addShuntCompensator(scItfIIDM);

  shared_ptr<ModelShuntCompensator> sc = shared_ptr<ModelShuntCompensator>(new ModelShuntCompensator(scItfIIDM));
  ModelNetwork* network = new ModelNetwork();
  network->setIsInitModel(initModel);
  network->setTimeline(timeline::TimelineFactory::newInstance("Test"));
  sc->setNetwork(network);
  shared_ptr<ModelVoltageLevel> vl = shared_ptr<ModelVoltageLevel>(new ModelVoltageLevel(vlItfIIDM));
  shared_ptr<ModelBus> bus1 = shared_ptr<ModelBus>(new ModelBus(bus1ItfIIDM, false));
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
  if (!initModel)
    z1[ModelBus::switchOffNum_] = -1;
  int offset = 0;
  bus1->init(offset);
  return std::make_tuple(sc, vl, vlItfIIDM);
}

static const bool capacitance = true;
static const bool reactance = false;

TEST(ModelsModelNetwork, ModelNetworkShuntCompensatorInitialization) {
  powsybl::iidm::Network networkIIDM("test", "test");
  auto tuple = createModelShuntCompensator(false, capacitance, false, networkIIDM);
  shared_ptr<ModelShuntCompensator> capa = std::get<0>(tuple);
  ASSERT_EQ(capa->id(), "MyShuntCompensator");
  ASSERT_TRUE(capa->isConnected());
  ASSERT_EQ(capa->getConnected(), CLOSED);
  ASSERT_EQ(capa->getCurrentSection(), 1);
  ASSERT_TRUE(capa->isCapacitor());

  powsybl::iidm::Network networkIIDM2("test", "test");
  auto tuple2 = createModelShuntCompensator(true, reactance, false, networkIIDM2);
  shared_ptr<ModelShuntCompensator> rea = std::get<0>(tuple2);

  ASSERT_EQ(rea->id(), "MyShuntCompensator");
  ASSERT_FALSE(rea->isConnected());
  ASSERT_EQ(rea->getConnected(), OPEN);
  ASSERT_EQ(rea->getCurrentSection(), 1);
  ASSERT_FALSE(rea->isCapacitor());
}

static void
fillParameters(shared_ptr<ModelShuntCompensator> shunt, std::string& startingPoint) {
  std::unordered_map<std::string, ParameterModeler> parametersModels;
  {
    ParameterModeler param = ParameterModeler("startingPointMode", VAR_TYPE_STRING, EXTERNAL_PARAMETER);
    param.setValue<std::string>(startingPoint, PAR);
    parametersModels.insert(std::make_pair(param.getName(), param));
  }
  {
    ParameterModeler param = ParameterModeler("capacitor_no_reclosing_delay", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
    param.setValue<double>(10., PAR);
    parametersModels.insert(std::make_pair(param.getName(), param));
  }
  {
    ParameterModeler param = ParameterModeler("reactance_no_reclosing_delay", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
    param.setValue<double>(10., PAR);
    parametersModels.insert(std::make_pair(param.getName(), param));
  }
  shunt->setSubModelParameters(parametersModels);
}

TEST(ModelsModelNetwork, ModelNetworkShuntCompensatorCalculatedVariables) {
  powsybl::iidm::Network networkIIDM("test", "test");
  auto tuple = createModelShuntCompensator(false, capacitance, false, networkIIDM);
  shared_ptr<ModelShuntCompensator> capa = std::get<0>(tuple);
  int yOffSet = 0;
  capa->init(yOffSet);
  capa->initSize();
  std::vector<double> y(capa->sizeY(), 0.);
  std::vector<double> yp(capa->sizeY(), 0.);
  std::vector<double> f(capa->sizeF(), 0.);
  std::vector<double> z(capa->sizeZ(), 0.);
  bool* zConnected = new bool[capa->sizeZ()];
  for (int i = 0; i < capa->sizeZ(); ++i)
    zConnected[i] = true;
  capa->setReferenceZ(&z[0], zConnected, 0);
  capa->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  capa->evalYMat();
  ASSERT_EQ(capa->sizeCalculatedVar(), ModelShuntCompensator::nbCalculatedVariables_);

  std::vector<double> calculatedVars(ModelShuntCompensator::nbCalculatedVariables_, 0.);
  capa->setReferenceCalculatedVar(&calculatedVars[0], 0);
  capa->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelShuntCompensator::qNum_], -32.5);
  ASSERT_DOUBLE_EQUALS_DYNAWO(capa->evalCalculatedVarI(ModelShuntCompensator::qNum_), calculatedVars[ModelShuntCompensator::qNum_]);
  ASSERT_THROW_DYNAWO(capa->evalCalculatedVarI(42), Error::MODELER, KeyError_t::UndefCalculatedVarI);

  std::vector<double> res(2, 0.);
  ASSERT_THROW_DYNAWO(capa->evalJCalculatedVarI(42, res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(capa->evalJCalculatedVarI(ModelShuntCompensator::qNum_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -14);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -8);
  res.clear();
  capa->setConnected(OPEN);
  ASSERT_NO_THROW(capa->evalJCalculatedVarI(ModelShuntCompensator::qNum_, res));
  ASSERT_TRUE(res.empty());

  capa->setConnected(CLOSED);
  int offset = 2;
  capa->init(offset);
  std::vector<int> numVars;
  ASSERT_THROW_DYNAWO(capa->getIndexesOfVariablesUsedForCalculatedVarI(42, numVars), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(capa->getIndexesOfVariablesUsedForCalculatedVarI(ModelShuntCompensator::qNum_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();

  powsybl::iidm::Network networkIIDM2("test", "test");
  auto tuple2 = createModelShuntCompensator(false, capacitance, true, networkIIDM2);
  shared_ptr<ModelShuntCompensator> capaInit = std::get<0>(tuple2);
  capaInit->initSize();
  capaInit->init(yOffSet);
  ASSERT_EQ(capaInit->sizeCalculatedVar(), 0);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkShuntCompensatorCalculatedVariablesFlat) {
  powsybl::iidm::Network networkIIDM("test", "test");
  auto tuple = createModelShuntCompensator(false, capacitance, false, networkIIDM);
  shared_ptr<ModelShuntCompensator> capa = std::get<0>(tuple);
  int yOffSet = 0;
  std::string startingPoint = "flat";
  fillParameters(capa, startingPoint);
  capa->init(yOffSet);
  capa->initSize();
  std::vector<double> y(capa->sizeY(), 0.);
  std::vector<double> yp(capa->sizeY(), 0.);
  std::vector<double> f(capa->sizeF(), 0.);
  std::vector<double> z(capa->sizeZ(), 0.);
  bool* zConnected = new bool[capa->sizeZ()];
  for (int i = 0; i < capa->sizeZ(); ++i)
    zConnected[i] = true;
  capa->setReferenceZ(&z[0], zConnected, 0);
  capa->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  capa->evalYMat();
  ASSERT_EQ(capa->sizeCalculatedVar(), ModelShuntCompensator::nbCalculatedVariables_);

  std::vector<double> calculatedVars(ModelShuntCompensator::nbCalculatedVariables_, 0.);
  capa->setReferenceCalculatedVar(&calculatedVars[0], 0);
  capa->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelShuntCompensator::qNum_], -32.5);
  ASSERT_DOUBLE_EQUALS_DYNAWO(capa->evalCalculatedVarI(ModelShuntCompensator::qNum_), calculatedVars[ModelShuntCompensator::qNum_]);
  ASSERT_THROW_DYNAWO(capa->evalCalculatedVarI(42), Error::MODELER, KeyError_t::UndefCalculatedVarI);

  std::vector<double> res(2, 0.);
  ASSERT_THROW_DYNAWO(capa->evalJCalculatedVarI(42, res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(capa->evalJCalculatedVarI(ModelShuntCompensator::qNum_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -14);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -8);
  res.clear();
  capa->setConnected(OPEN);
  ASSERT_NO_THROW(capa->evalJCalculatedVarI(ModelShuntCompensator::qNum_, res));
  ASSERT_TRUE(res.empty());
}

TEST(ModelsModelNetwork, ModelNetworkShuntCompensatorDiscreteVariables) {
  powsybl::iidm::Network networkIIDM("test", "test");
  auto tuple = createModelShuntCompensator(false, capacitance, false, networkIIDM);
  shared_ptr<ModelShuntCompensator> capa = std::get<0>(tuple);
  int yOffSet = 0;
  capa->init(yOffSet);
  capa->initSize();
  unsigned nbZ = 4;
  unsigned nbG = 1;
  ASSERT_EQ(capa->sizeZ(), nbZ);
  ASSERT_EQ(capa->sizeG(), nbG);
  std::vector<double> y(capa->sizeY(), 0.);
  std::vector<double> yp(capa->sizeY(), 0.);
  std::vector<double> f(capa->sizeF(), 0.);
  std::vector<double> z(nbZ, 0.);
  std::vector<state_g> g(nbG, NO_ROOT);
  capa->setReferenceG(&g[0], 0);
  bool* zConnected = new bool[nbZ];
  for (size_t i = 0; i < nbZ; ++i)
    zConnected[i] = true;
  capa->setReferenceZ(&z[0], zConnected, 0);
  capa->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);

  capa->getY0();
  ASSERT_EQ(capa->getConnected(), CLOSED);
  ASSERT_EQ(z[ModelShuntCompensator::connectionStateNum_], capa->getConnected());
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelShuntCompensator::isCapacitorNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelShuntCompensator::isAvailableNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelShuntCompensator::currentSectionNum_], 1.);
  capa->setConnected(OPEN);
  capa->getY0();
  ASSERT_EQ(capa->getConnected(), OPEN);
  ASSERT_EQ(z[ModelShuntCompensator::connectionStateNum_], capa->getConnected());
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelShuntCompensator::isCapacitorNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelShuntCompensator::isAvailableNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelShuntCompensator::currentSectionNum_], 1.);
  capa->setConnected(CLOSED);

  z[ModelShuntCompensator::connectionStateNum_] = OPEN;
  z[ModelShuntCompensator::isCapacitorNum_] = 0.;
  z[ModelShuntCompensator::isAvailableNum_] = 0.;
  z[ModelShuntCompensator::currentSectionNum_] = 0.;
  capa->evalG(10.);
  capa->evalZ(10.);
  ASSERT_EQ(capa->getConnected(), OPEN);
  ASSERT_EQ(z[ModelShuntCompensator::connectionStateNum_], OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(capa->getCurrentSection(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelShuntCompensator::currentSectionNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelShuntCompensator::isCapacitorNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelShuntCompensator::isAvailableNum_], 1.);

  ASSERT_EQ(capa->evalState(0.), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(capa->getConnected(), OPEN);
  z[ModelShuntCompensator::connectionStateNum_] = CLOSED;
  capa->evalG(0.);
  capa->evalZ(0.);
  ASSERT_EQ(capa->evalState(0.), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(capa->getConnected(), CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(capa->getCurrentSection(), 5.);
  ASSERT_EQ(capa->evalState(0.), NetworkComponent::NO_CHANGE);
  ASSERT_EQ(capa->getConnected(), CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(capa->getCurrentSection(), 5.);
  z[ModelShuntCompensator::currentSectionNum_] = 42.;
  z[ModelShuntCompensator::isCapacitorNum_] = 0.;
  z[ModelShuntCompensator::isAvailableNum_] = 0.;
  capa->evalG(0.);
  capa->evalZ(0.);
  ASSERT_EQ(capa->evalState(0.), NetworkComponent::NO_CHANGE);
  ASSERT_DOUBLE_EQUALS_DYNAWO(capa->getCurrentSection(), 5.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelShuntCompensator::isCapacitorNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelShuntCompensator::isAvailableNum_], 0.);

  zConnected[ModelShuntCompensator::isAvailableNum_] = false;
  capa->evalG(0.);
  capa->evalZ(0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelShuntCompensator::isAvailableNum_], 1.);

  std::map<int, std::string> gEquationIndex;
  capa->setGequations(gEquationIndex);
  ASSERT_EQ(gEquationIndex.size(), nbG);
  for (unsigned i = 0; i < nbG; ++i) {
    ASSERT_TRUE(gEquationIndex.find(i) != gEquationIndex.end());
  }
  ASSERT_NO_THROW(capa->evalG(20.));
  ASSERT_DOUBLE_EQUALS_DYNAWO(g[0], ROOT_UP);
  ASSERT_NO_THROW(capa->evalG(1.));
  ASSERT_DOUBLE_EQUALS_DYNAWO(g[0], ROOT_DOWN);

  BitMask* silentZ = new BitMask[capa->sizeZ()];
  ASSERT_NO_THROW(capa->collectSilentZ(silentZ));

  powsybl::iidm::Network networkIIDM2("test", "test");
  auto tuple2 = createModelShuntCompensator(false, capacitance, true, networkIIDM2);
  shared_ptr<ModelShuntCompensator> capaInit = std::get<0>(tuple2);
  capaInit->initSize();
  capaInit->init(yOffSet);
  ASSERT_EQ(capaInit->sizeZ(), 0);
  ASSERT_EQ(capaInit->sizeG(), 0);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkShuntCompensatorContinuousVariables) {
  powsybl::iidm::Network networkIIDM("test", "test");
  auto tuple = createModelShuntCompensator(false, capacitance, false, networkIIDM);
  shared_ptr<ModelShuntCompensator> capa = std::get<0>(tuple);
  int yOffSet = 0;
  capa->init(yOffSet);
  capa->initSize();
  unsigned nbY = 0;
  unsigned nbF = 0;
  ASSERT_EQ(capa->sizeY(), nbY);
  ASSERT_EQ(capa->sizeF(), nbF);

  // test evalYType
  ASSERT_NO_THROW(capa->evalStaticYType());
  ASSERT_NO_THROW(capa->evalStaticFType());
  ASSERT_NO_THROW(capa->evalDynamicYType());
  ASSERT_NO_THROW(capa->evalDynamicFType());

  // test evalF
  ASSERT_NO_THROW(capa->evalF(UNDEFINED_EQ));

  // test setFequations
  std::map<int, std::string> fEquationIndex;
  capa->setFequations(fEquationIndex);
  ASSERT_EQ(fEquationIndex.size(), 0);

  powsybl::iidm::Network networkIIDM2("test", "test");
  auto tuple2 = createModelShuntCompensator(false, capacitance, true, networkIIDM2);
  shared_ptr<ModelShuntCompensator> capaInit = std::get<0>(tuple2);
  capaInit->initSize();
  capaInit->init(yOffSet);
  ASSERT_EQ(capaInit->sizeY(), 0);
  ASSERT_EQ(capaInit->sizeF(), 0);
  ASSERT_NO_THROW(capaInit->getY0());
  ASSERT_NO_THROW(capaInit->evalF(UNDEFINED_EQ));
  fEquationIndex.clear();
  ASSERT_NO_THROW(capaInit->setFequations(fEquationIndex));
  ASSERT_EQ(fEquationIndex.size(), 0);
  ASSERT_NO_THROW(capa->evalDerivatives(1));
  ASSERT_NO_THROW(capa->evalNodeInjection());
}

TEST(ModelsModelNetwork, ModelNetworkShuntCompensatorDefineInstantiate) {
  powsybl::iidm::Network networkIIDM("test", "test");
  powsybl::iidm::Network networkIIDM2("test", "test");
  auto tuple = createModelShuntCompensator(false, capacitance, false, networkIIDM);
  shared_ptr<ModelShuntCompensator> capa = std::get<0>(tuple);
  auto tuple2 = createModelShuntCompensator(false, reactance, false, networkIIDM2);
  shared_ptr<ModelShuntCompensator> rea = std::get<0>(tuple2);
  int yOffSet = 0;
  capa->init(yOffSet);
  capa->initSize();
  rea->init(yOffSet);
  rea->initSize();

  std::vector<shared_ptr<Variable> > definedVariables;
  std::vector<shared_ptr<Variable> > instantiatedVariables;
  capa->defineVariables(definedVariables);
  capa->instantiateVariables(instantiatedVariables);
  ASSERT_EQ(definedVariables.size(), instantiatedVariables.size());

  for (size_t i = 0, iEnd = definedVariables.size(); i < iEnd; ++i) {
    std::string var = instantiatedVariables[i]->getName();
    boost::replace_all(var, capa->id(), "@ID@");
    ASSERT_EQ(definedVariables[i]->getName(), var);
    ASSERT_EQ(definedVariables[i]->getType(), instantiatedVariables[i]->getType());
  }


  std::vector<ParameterModeler> parameters;
  capa->defineNonGenericParameters(parameters);
  ASSERT_EQ(parameters.size(), 1);
  std::unordered_map<std::string, ParameterModeler> parametersModels;
  const std::string paramName = "capacitor_no_reclosing_delay";
  ParameterModeler param = ParameterModeler(paramName, VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
  param.setValue<double>(10., PAR);
  parametersModels.insert(std::make_pair(paramName, param));
  ASSERT_NO_THROW(capa->setSubModelParameters(parametersModels));

  parameters.clear();
  rea->defineNonGenericParameters(parameters);
  ASSERT_EQ(parameters.size(), 1);
  parametersModels.clear();
  const std::string paramName2 = "reactance_no_reclosing_delay";
  ParameterModeler param2 = ParameterModeler(paramName2, VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
  param2.setValue<double>(10., PAR);
  parametersModels.insert(std::make_pair(paramName2, param2));
  ASSERT_NO_THROW(rea->setSubModelParameters(parametersModels));

  std::vector<Element> elements;
  std::map<std::string, int> mapElement;
  ASSERT_NO_THROW(capa->defineElements(elements, mapElement));
  ASSERT_EQ(elements.size(), 10);
}

TEST(ModelsModelNetwork, ModelNetworkShuntCompensatorJt) {
  powsybl::iidm::Network networkIIDM("test", "test");
  auto tuple = createModelShuntCompensator(false, capacitance, false, networkIIDM);
  shared_ptr<ModelShuntCompensator> capa = std::get<0>(tuple);
  int yOffSet = 0;
  capa->init(yOffSet);
  capa->initSize();
  capa->evalYMat();
  SparseMatrix smj;
  int size = capa->sizeY();
  smj.init(size, size);
  capa->evalJt(smj, 1., 0);
  ASSERT_EQ(smj.nbElem(), 0);

  SparseMatrix smjPrime;
  smjPrime.init(size, size);
  capa->evalJtPrim(smjPrime, 0);
  ASSERT_EQ(smjPrime.nbElem(), 0);

  powsybl::iidm::Network networkIIDM2("test", "test");
  auto tuple2 = createModelShuntCompensator(false, capacitance, true, networkIIDM2);
  shared_ptr<ModelShuntCompensator> capaInit = std::get<0>(tuple2);
  capaInit->initSize();
  capaInit->init(yOffSet);
  SparseMatrix smjInit;
  smjInit.init(capaInit->sizeY(), capaInit->sizeY());
  ASSERT_NO_THROW(capaInit->evalJt(smjInit, 1., 0));
  ASSERT_EQ(smjInit.nbElem(), 0);
}

}  // namespace DYN
