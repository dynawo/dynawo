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
#include <powsybl/iidm/GeneratorAdder.hpp>

#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNBusInterfaceIIDM.h"
#include "DYNGeneratorInterfaceIIDM.h"
#include "DYNModelGenerator.h"
#include "DYNModelBus.h"
#include "DYNModelNetwork.h"
#include "TLTimelineFactory.h"
#include "DYNModelVoltageLevel.h"
#include "DYNSparseMatrix.h"
#include "DYNVariable.h"
#include "DYNVariableAlias.h"

#include "gtest_dynawo.h"

using boost::shared_ptr;

namespace DYN {
static std::tuple<std::shared_ptr<ModelGenerator>, std::shared_ptr<VoltageLevelInterfaceIIDM>,
std::shared_ptr<ModelVoltageLevel> >  // need to return the voltage level so that it is not destroyed
createModelGenerator(bool open, bool initModel, powsybl::iidm::Network& networkIIDM) {
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

  powsybl::iidm::Generator& genIIDM = vlIIDM.newGenerator()
      .setId("MyGenerator")
      .setName("MyGenerator_NAME")
      .setBus(iidmBus.getId())
      .setConnectableBus(iidmBus.getId())
      .setEnergySource(powsybl::iidm::EnergySource::WIND)
      .setMaxP(50.0)
      .setMinP(3.0)
      .setRatedS(4.0)
      .setTargetP(45.0)
      .setTargetQ(5.0)
      .setTargetV(24.0)
      .setVoltageRegulatorOn(true)
      .add();
  if (open)
    genIIDM.getTerminal().disconnect();
  genIIDM.getTerminal().setP(800.);
  genIIDM.getTerminal().setQ(400.);
  genIIDM.newMinMaxReactiveLimits().setMinQ(1.).setMaxQ(10.).add();
  std::shared_ptr<GeneratorInterfaceIIDM> genItfIIDM = std::make_shared<GeneratorInterfaceIIDM>(genIIDM);
  std::shared_ptr<BusInterfaceIIDM> bus1ItfIIDM = std::make_shared<BusInterfaceIIDM>(iidmBus);
  std::shared_ptr<VoltageLevelInterfaceIIDM> vlItfIIDM = std::make_shared<VoltageLevelInterfaceIIDM>(vlIIDM);
  vlItfIIDM->addBus(bus1ItfIIDM);
  vlItfIIDM->addGenerator(genItfIIDM);
  genItfIIDM->setBusInterface(bus1ItfIIDM);
  genItfIIDM->setVoltageLevelInterface(vlItfIIDM);

  std::shared_ptr<ModelGenerator> gen = std::make_shared<ModelGenerator>(genItfIIDM);
  ModelNetwork* network = new ModelNetwork();
  network->setIsInitModel(initModel);
  network->setTimeline(timeline::TimelineFactory::newInstance("Test"));
  gen->setNetwork(network);
  std::shared_ptr<ModelBus> bus1 = std::make_shared<ModelBus>(bus1ItfIIDM, false);
  std::shared_ptr<ModelVoltageLevel> vl = std::make_shared<ModelVoltageLevel>(vlItfIIDM);
  vl->addComponent(gen);
  vl->addBus(bus1);
  gen->setModelBus(bus1);
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
  y1[ModelBus::urNum_] = 0.35;
  y1[ModelBus::uiNum_] = 0.02;
  if (!initModel)
    z1[ModelBus::switchOffNum_] = -1;
  int offset = 0;
  bus1->init(offset);
  return std::tuple<std::shared_ptr<ModelGenerator>, std::shared_ptr<VoltageLevelInterfaceIIDM>,
          std::shared_ptr<ModelVoltageLevel> >(gen, vlItfIIDM, vl);
}

static void
fillParameters(std::shared_ptr<ModelGenerator> gen, std::string& startingPoint, double alpha, double beta, bool isVoltageDependant) {
  std::unordered_map<std::string, ParameterModeler> parametersModels;
  {
    ParameterModeler param = ParameterModeler("startingPointMode", VAR_TYPE_STRING, EXTERNAL_PARAMETER);
    param.setValue<std::string>(startingPoint, PAR);
    parametersModels.insert(std::make_pair(param.getName(), param));
  }
  {
    ParameterModeler param = ParameterModeler("generator_alpha", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
    param.setValue<double>(alpha, PAR);
    parametersModels.insert(std::make_pair(param.getName(), param));
  }
  {
    ParameterModeler param = ParameterModeler("generator_beta", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
    param.setValue<double>(beta, PAR);
    parametersModels.insert(std::make_pair(param.getName(), param));
  }
  {
    ParameterModeler param = ParameterModeler("generator_isVoltageDependant", VAR_TYPE_BOOL, EXTERNAL_PARAMETER);
    param.setValue<bool>(isVoltageDependant, PAR);
    parametersModels.insert(std::make_pair(param.getName(), param));
  }
  gen->setSubModelParameters(parametersModels);
}

TEST(ModelsModelNetwork, ModelNetworkGeneratorInitialization) {
  powsybl::iidm::Network networkIIDM("test", "test");
  std::tuple<std::shared_ptr<ModelGenerator>, std::shared_ptr<VoltageLevelInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p
      = createModelGenerator(false, false, networkIIDM);
  std::shared_ptr<ModelGenerator> gen =  std::get<0>(p);
  std::string startingPoint = "warm";
  fillParameters(gen, startingPoint, 1.5, 2.5, false);
  int yOffset = 0;
  gen->init(yOffset);
  ASSERT_EQ(gen->id(), "MyGenerator");
  ASSERT_EQ(gen->getConnected(), CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->PcPu(), -8.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->QcPu(), -4.);
  ASSERT_TRUE(gen->isConnected());

  powsybl::iidm::Network networkIIDM2("test", "test");
  std::tuple<std::shared_ptr<ModelGenerator>, std::shared_ptr<VoltageLevelInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p2
      = createModelGenerator(true, false, networkIIDM2);
  std::shared_ptr<ModelGenerator> genOpened = std::get<0>(p2);
  ASSERT_EQ(genOpened->id(), "MyGenerator");
  ASSERT_EQ(genOpened->getConnected(), OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(genOpened->PcPu(), -0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(genOpened->QcPu(), -0.);
  ASSERT_TRUE(!genOpened->isConnected());
}

TEST(ModelsModelNetwork, ModelNetworkGeneratorInitializationWrongStartingPoint) {
  powsybl::iidm::Network networkIIDM("test", "test");
  std::tuple<std::shared_ptr<ModelGenerator>, std::shared_ptr<VoltageLevelInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p
      = createModelGenerator(false, false, networkIIDM);
  std::shared_ptr<ModelGenerator> gen =  std::get<0>(p);
  std::string startingPoint = "notexisting";
  fillParameters(gen, startingPoint, 1.5, 2.5, false);
  int yOffset = 0;
  gen->init(yOffset);
  ASSERT_EQ(gen->id(), "MyGenerator");
  ASSERT_EQ(gen->getConnected(), CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->PcPu(), -8.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->QcPu(), -4.);
  ASSERT_TRUE(gen->isConnected());
}

TEST(ModelsModelNetwork, ModelNetworkGeneratorInitializationFlat) {
  powsybl::iidm::Network networkIIDM("test", "test");
  std::tuple<std::shared_ptr<ModelGenerator>, std::shared_ptr<VoltageLevelInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p
      = createModelGenerator(false, false, networkIIDM);
  std::shared_ptr<ModelGenerator> gen =  std::get<0>(p);
  std::string startingPoint = "flat";
  fillParameters(gen, startingPoint, 1.5, 2.5, false);
  int yOffset = 0;
  gen->init(yOffset);
  ASSERT_EQ(gen->id(), "MyGenerator");
  ASSERT_EQ(gen->getConnected(), CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->PcPu(), 0.45);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->QcPu(), 0.05);
  ASSERT_TRUE(gen->isConnected());

  powsybl::iidm::Network networkIIDM2("test", "test");
  std::tuple<std::shared_ptr<ModelGenerator>, std::shared_ptr<VoltageLevelInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p2
      = createModelGenerator(true, false, networkIIDM2);
  std::shared_ptr<ModelGenerator> genOpened = std::get<0>(p2);
  ASSERT_EQ(genOpened->id(), "MyGenerator");
  ASSERT_EQ(genOpened->getConnected(), OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(genOpened->PcPu(), -0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(genOpened->QcPu(), -0.);
  ASSERT_TRUE(!genOpened->isConnected());
}


TEST(ModelsModelNetwork, ModelNetworkGeneratorCalculatedVariables) {
  powsybl::iidm::Network networkIIDM("test", "test");
  std::tuple<std::shared_ptr<ModelGenerator>, std::shared_ptr<VoltageLevelInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p
      = createModelGenerator(false, false, networkIIDM);
  std::shared_ptr<ModelGenerator> gen =  std::get<0>(p);
  int yOffset = 0;
  gen->init(yOffset);
  gen->initSize();
  std::vector<double> y(gen->sizeY(), 0.);
  std::vector<double> yp(gen->sizeY(), 0.);
  std::vector<double> f(gen->sizeF(), 0.);
  std::vector<double> z(gen->sizeZ(), 3.);
  bool* zConnected = new bool[gen->sizeZ()];
  for (int i = 0; i < gen->sizeZ(); ++i)
    zConnected[i] = true;
  gen->setReferenceZ(&z[0], zConnected, 0);
  gen->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  ASSERT_EQ(gen->sizeCalculatedVar(), ModelGenerator::nbCalculatedVariables_);

  std::vector<double> calculatedVars(ModelGenerator::nbCalculatedVariables_, 0.);
  gen->setReferenceCalculatedVar(&calculatedVars[0], 0);
  gen->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelGenerator::pNum_], -8.0000000000000002);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelGenerator::qNum_], -4.0000000000000008);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelGenerator::genStateNum_], CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->evalCalculatedVarI(ModelGenerator::pNum_), calculatedVars[ModelGenerator::pNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->evalCalculatedVarI(ModelGenerator::qNum_), calculatedVars[ModelGenerator::qNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->evalCalculatedVarI(ModelGenerator::genStateNum_), calculatedVars[ModelGenerator::genStateNum_]);
  ASSERT_THROW_DYNAWO(gen->evalCalculatedVarI(42), Error::MODELER, KeyError_t::UndefCalculatedVarI);

  gen->setConnected(OPEN);
  gen->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelGenerator::pNum_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelGenerator::qNum_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelGenerator::genStateNum_], OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->evalCalculatedVarI(ModelGenerator::pNum_), calculatedVars[ModelGenerator::pNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->evalCalculatedVarI(ModelGenerator::qNum_), calculatedVars[ModelGenerator::qNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->evalCalculatedVarI(ModelGenerator::genStateNum_), calculatedVars[ModelGenerator::genStateNum_]);
  gen->setConnected(CLOSED);

  std::vector<double> res(2, 0.);
  ASSERT_THROW_DYNAWO(gen->evalJCalculatedVarI(42, res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(gen->evalJCalculatedVarI(ModelGenerator::pNum_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 1.0380585280245214e-14);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 1.9984014443252818e-15);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(gen->evalJCalculatedVarI(ModelGenerator::qNum_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 2.2204460492503131e-15);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(gen->evalJCalculatedVarI(ModelGenerator::genStateNum_, res));
  for (size_t i = 0; i < res.size(); ++i) {
    ASSERT_DOUBLE_EQUALS_DYNAWO(res[i], 0.);
  }

  gen->setConnected(OPEN);
  res.clear();
  ASSERT_NO_THROW(gen->evalJCalculatedVarI(ModelGenerator::pNum_, res));
  ASSERT_NO_THROW(gen->evalJCalculatedVarI(ModelGenerator::qNum_, res));
  ASSERT_NO_THROW(gen->evalJCalculatedVarI(ModelGenerator::genStateNum_, res));
  gen->setConnected(CLOSED);

  int offset = 2;
  gen->init(offset);
  std::vector<int> numVars;
  ASSERT_THROW_DYNAWO(gen->getIndexesOfVariablesUsedForCalculatedVarI(42, numVars), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(gen->getIndexesOfVariablesUsedForCalculatedVarI(ModelGenerator::pNum_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(gen->getIndexesOfVariablesUsedForCalculatedVarI(ModelGenerator::qNum_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(gen->getIndexesOfVariablesUsedForCalculatedVarI(ModelGenerator::genStateNum_, numVars));
  ASSERT_EQ(numVars.size(), 0);

  powsybl::iidm::Network networkIIDM2("test", "test");
  std::tuple<std::shared_ptr<ModelGenerator>, std::shared_ptr<VoltageLevelInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p2
      = createModelGenerator(false, true, networkIIDM2);
  std::shared_ptr<ModelGenerator> genInit = std::get<0>(p2);
  genInit->initSize();
  genInit->init(yOffset);
  ASSERT_EQ(genInit->sizeCalculatedVar(), 0);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkGeneratorDiscreteVariables) {
  powsybl::iidm::Network networkIIDM("test", "test");
  bool deactivateRootFunctions = false;
  std::tuple<std::shared_ptr<ModelGenerator>, std::shared_ptr<VoltageLevelInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p
      = createModelGenerator(false, false, networkIIDM);
  std::shared_ptr<ModelGenerator> gen =  std::get<0>(p);
  int yOffset = 0;
  gen->init(yOffset);
  gen->initSize();
  unsigned nbZ = 3;
  unsigned nbG = 0;
  ASSERT_EQ(gen->sizeZ(), nbZ);
  ASSERT_EQ(gen->sizeG(), nbG);
  std::vector<double> y(gen->sizeY(), 0.);
  std::vector<double> yp(gen->sizeY(), 0.);
  std::vector<double> f(gen->sizeF(), 0.);
  std::vector<double> z(nbZ, 0.);
  bool* zConnected = new bool[nbZ];
  for (size_t i = 0; i < nbZ; ++i)
    zConnected[i] = true;
  std::vector<state_g> g(nbG, NO_ROOT);
  gen->setReferenceG(&g[0], 0);
  gen->setReferenceZ(&z[0], zConnected, 0);
  gen->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);

  gen->getY0();
  ASSERT_EQ(gen->getConnected(), CLOSED);
  ASSERT_EQ(z[0], gen->getConnected());
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[1], -800.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[2], -400.);
  gen->setConnected(OPEN);
  gen->getY0();
  ASSERT_EQ(gen->getConnected(), OPEN);
  ASSERT_EQ(z[0], gen->getConnected());
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[1], -800.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[2], -400.);
  gen->setConnected(CLOSED);

  z[0] = OPEN;
  z[1] = 100.;
  z[2] = 200.;
  gen->evalZ(0., deactivateRootFunctions);
  ASSERT_EQ(gen->getConnected(), OPEN);
  ASSERT_EQ(z[0], OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->PcPu(), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->QcPu(), 2.);

  ASSERT_EQ(gen->evalState(0.), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(gen->getConnected(), OPEN);
  z[0] = CLOSED;
  gen->evalZ(0., deactivateRootFunctions);
  ASSERT_EQ(gen->evalState(0.), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(gen->getConnected(), CLOSED);
  ASSERT_EQ(gen->evalState(0.), NetworkComponent::NO_CHANGE);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->getConnected(), CLOSED);

  std::map<int, std::string> gEquationIndex;
  gen->setGequations(gEquationIndex);
  ASSERT_EQ(gEquationIndex.size(), nbG);
  ASSERT_NO_THROW(gen->evalG(0.));

  powsybl::iidm::Network networkIIDM2("test", "test");
  std::tuple<std::shared_ptr<ModelGenerator>, std::shared_ptr<VoltageLevelInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p2
      = createModelGenerator(false, true, networkIIDM2);
  std::shared_ptr<ModelGenerator> genInit = std::get<0>(p2);
  genInit->initSize();
  genInit->init(yOffset);
  ASSERT_EQ(genInit->sizeZ(), 0);
  ASSERT_EQ(genInit->sizeG(), 0);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkGeneratorContinuousVariables) {
  powsybl::iidm::Network networkIIDM("test", "test");
  std::tuple<std::shared_ptr<ModelGenerator>, std::shared_ptr<VoltageLevelInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p
      = createModelGenerator(false, false, networkIIDM);
  std::shared_ptr<ModelGenerator> gen =  std::get<0>(p);
  int yOffset = 0;
  gen->init(yOffset);
  gen->initSize();
  unsigned nbY = 0;
  unsigned nbF = 0;
  ASSERT_EQ(gen->sizeY(), nbY);
  ASSERT_EQ(gen->sizeF(), nbF);

  // test evalStaticYType
  ASSERT_NO_THROW(gen->evalStaticYType());
  ASSERT_NO_THROW(gen->evalStaticFType());
  ASSERT_NO_THROW(gen->evalDynamicYType());
  ASSERT_NO_THROW(gen->evalDynamicFType());

  // test evalF
  ASSERT_NO_THROW(gen->evalF(UNDEFINED_EQ));

  // test setFequations
  std::map<int, std::string> fEquationIndex;
  ASSERT_NO_THROW(gen->setFequations(fEquationIndex));
  ASSERT_EQ(fEquationIndex.size(), 0);

  powsybl::iidm::Network networkIIDM2("test", "test");
  std::tuple<std::shared_ptr<ModelGenerator>, std::shared_ptr<VoltageLevelInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p2
      = createModelGenerator(false, true, networkIIDM2);
  std::shared_ptr<ModelGenerator> genInit = std::get<0>(p2);
  genInit->initSize();
  genInit->init(yOffset);
  ASSERT_EQ(genInit->sizeY(), 0);
  ASSERT_EQ(genInit->sizeF(), 0);
  ASSERT_NO_THROW(genInit->getY0());
  ASSERT_NO_THROW(genInit->evalF(UNDEFINED_EQ));
  fEquationIndex.clear();
  ASSERT_NO_THROW(genInit->setFequations(fEquationIndex));
}

TEST(ModelsModelNetwork, ModelNetworkGeneratorDefineInstantiate) {
  powsybl::iidm::Network networkIIDM("test", "test");
  std::tuple<std::shared_ptr<ModelGenerator>, std::shared_ptr<VoltageLevelInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p
      = createModelGenerator(false, false, networkIIDM);
  std::shared_ptr<ModelGenerator> gen =  std::get<0>(p);
  int yOffset = 0;
  gen->init(yOffset);
  gen->initSize();

  std::vector<shared_ptr<Variable> > definedVariables;
  std::vector<shared_ptr<Variable> > instantiatedVariables;
  gen->defineVariables(definedVariables);
  gen->instantiateVariables(instantiatedVariables);
  ASSERT_EQ(definedVariables.size(), instantiatedVariables.size());

  unsigned nbAlias = 0;
  unsigned nbCalc = 0;
  unsigned nbVar = 0;
  for (size_t i = 0, iEnd = definedVariables.size(); i < iEnd; ++i) {
    std::string var = instantiatedVariables[i]->getName();
    boost::replace_all(var, gen->id(), "@ID@");
    ASSERT_EQ(definedVariables[i]->getName(), var);
    if (instantiatedVariables[i]->isAlias()) {
      std::string alias = boost::dynamic_pointer_cast<VariableAlias>(instantiatedVariables[i])->getReferenceVariableName();
      boost::replace_all(alias, gen->id(), "@ID@");
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
  ASSERT_EQ(nbAlias, 1);
  ASSERT_EQ(nbCalc, 3);
  ASSERT_EQ(nbVar, 3);

  std::vector<ParameterModeler> genericParameters;
  gen->defineParameters(genericParameters);
  ASSERT_EQ(genericParameters.size(), 3);

  std::vector<ParameterModeler> parameters;
  gen->defineNonGenericParameters(parameters);
  ASSERT_FALSE(parameters.empty());
  ASSERT_EQ(parameters.size(), 3);

  for (size_t i = 0, iEnd = parameters.size(); i < iEnd; ++i) {
    std::string var = genericParameters[i].getName();
    boost::replace_all(var, "generator", gen->id());
    ASSERT_EQ(parameters[i].getName(), var);
    ASSERT_EQ(parameters[i].getScope(), genericParameters[i].getScope());
    ASSERT_EQ(parameters[i].getValueType(), genericParameters[i].getValueType());
  }
}

TEST(ModelsModelNetwork, ModelNetworkGeneratorJt) {
  powsybl::iidm::Network networkIIDM("test", "test");
  std::tuple<std::shared_ptr<ModelGenerator>, std::shared_ptr<VoltageLevelInterfaceIIDM>, std::shared_ptr<ModelVoltageLevel> > p
      = createModelGenerator(false, false, networkIIDM);
  std::shared_ptr<ModelGenerator> gen =  std::get<0>(p);
  int yOffset = 0;
  gen->init(yOffset);
  gen->initSize();
  gen->initSize();
  gen->evalYMat();
  SparseMatrix smj;
  int size = gen->sizeY();
  smj.init(size, size);
  gen->evalJt(smj, 1., 0);
  ASSERT_EQ(smj.nbElem(), 0);

  SparseMatrix smjPrime;
  smjPrime.init(size, size);
  gen->evalJtPrim(smjPrime, 0);
  ASSERT_EQ(smjPrime.nbElem(), 0);
}

}  // namespace DYN
