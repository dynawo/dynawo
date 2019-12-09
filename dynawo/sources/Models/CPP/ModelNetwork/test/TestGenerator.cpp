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

#include <IIDM/builders/GeneratorBuilder.h>
#include <IIDM/builders/VoltageLevelBuilder.h>
#include <IIDM/builders/BusBuilder.h>
#include <IIDM/components/VoltageLevel.h>
#include <IIDM/components/Bus.h>
#include <IIDM/components/Generator.h>

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
std::pair<shared_ptr<ModelGenerator>, shared_ptr<ModelVoltageLevel> >  // need to return the voltage level so that it is not destroyed
createModelGenerator(bool open, bool initModel) {
  IIDM::connection_status_t cs = {!open};
  IIDM::Port p1("MyBus1", cs);
  IIDM::Connection c1("MyVoltageLevel", p1, IIDM::side_1);

  IIDM::builders::BusBuilder bb;
  IIDM::Bus bus1IIDM = bb.build("MyBus1");

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::bus_breaker);
  vlb.nominalV(5.);
  IIDM::VoltageLevel vlIIDM = vlb.build("MyVoltageLevel");
  vlIIDM.add(bus1IIDM);
  vlIIDM.lowVoltageLimit(0.5);
  vlIIDM.highVoltageLimit(2.);

  IIDM::builders::GeneratorBuilder gb;
  gb.p(800.);
  gb.q(400.);
  IIDM::MinMaxReactiveLimits limits(1., 10.);
  gb.minMaxReactiveLimits(limits);
  IIDM::Generator genIIDM = gb.build("MyGenerator");
  vlIIDM.add(genIIDM, c1);
  shared_ptr<GeneratorInterfaceIIDM> genItfIIDM = shared_ptr<GeneratorInterfaceIIDM>(new GeneratorInterfaceIIDM(vlIIDM.get_generator("MyGenerator")));
  shared_ptr<BusInterfaceIIDM> bus1ItfIIDM = shared_ptr<BusInterfaceIIDM>(new BusInterfaceIIDM(vlIIDM.get_bus("MyBus1")));
  shared_ptr<VoltageLevelInterfaceIIDM> vlItfIIDM = shared_ptr<VoltageLevelInterfaceIIDM>(new VoltageLevelInterfaceIIDM(vlIIDM));
  genItfIIDM->setBusInterface(bus1ItfIIDM);

  shared_ptr<ModelGenerator> gen = shared_ptr<ModelGenerator>(new ModelGenerator(genItfIIDM));
  ModelNetwork* network = new ModelNetwork();
  network->setIsInitModel(initModel);
  network->setTimeline(timeline::TimelineFactory::newInstance("Test"));
  gen->setNetwork(network);
  shared_ptr<ModelBus> bus1 = shared_ptr<ModelBus>(new ModelBus(bus1ItfIIDM));
  shared_ptr<ModelVoltageLevel> vl = shared_ptr<ModelVoltageLevel>(new ModelVoltageLevel(vlItfIIDM));
  gen->setModelBus(bus1);
  bus1->setNetwork(network);
  bus1->setVoltageLevel(vl);
  bus1->initSize();
  // There is a memory leak here, but whatever ...
  double* y1 = new double[bus1->sizeY()];
  double* yp1 = new double[bus1->sizeY()];
  double* f1 = new double[bus1->sizeF()];
  double* z1 = new double[bus1->sizeZ()];
  bus1->setReferenceZ(&z1[0], 0);
  bus1->setReferenceY(y1, yp1, f1, 0, 0);
  y1[ModelBus::urNum_] = 0.35;
  y1[ModelBus::uiNum_] = 0.02;
  z1[ModelBus::switchOffNum_] = -1;
  int offset = 0;
  bus1->init(offset);
  return std::make_pair(gen, vl);
}

TEST(ModelsModelNetwork, ModelNetworkGeneratorInitialization) {
  std::pair<shared_ptr<ModelGenerator>, shared_ptr<ModelVoltageLevel> > p = createModelGenerator(false, false);
  shared_ptr<ModelGenerator> gen = p.first;
  ASSERT_EQ(gen->id(), "MyGenerator");
  ASSERT_EQ(gen->getConnected(), CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->Pc(), -8.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->Qc(), -4.);
  ASSERT_TRUE(gen->isConnected());

  shared_ptr<ModelGenerator> genOpened = createModelGenerator(true, false).first;
  ASSERT_EQ(genOpened->id(), "MyGenerator");
  ASSERT_EQ(genOpened->getConnected(), OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(genOpened->Pc(), -0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(genOpened->Qc(), -0.);
  ASSERT_TRUE(!genOpened->isConnected());
}


TEST(ModelsModelNetwork, ModelNetworkGeneratorCalculatedVariables) {
  std::pair<shared_ptr<ModelGenerator>, shared_ptr<ModelVoltageLevel> > p = createModelGenerator(false, false);
  shared_ptr<ModelGenerator> gen = p.first;
  gen->initSize();
  std::vector<double> y(gen->sizeY(), 0.);
  std::vector<double> yp(gen->sizeY(), 0.);
  std::vector<double> f(gen->sizeF(), 0.);
  std::vector<double> z(gen->sizeZ(), 3.);
  gen->setReferenceZ(&z[0], 0);
  gen->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  ASSERT_EQ(gen->sizeCalculatedVar(), ModelGenerator::nbCalculatedVariables_);

  std::vector<double> calculatedVars(ModelGenerator::nbCalculatedVariables_, 0.);
  gen->setReferenceCalculatedVar(&calculatedVars[0], 0);
  gen->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelGenerator::pNum_], -8.0000000000000002);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelGenerator::qNum_], -4.0000000000000008);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelGenerator::genStateNum_], CLOSED);
  std::vector<double> yI(2, 0.);
  yI[0] = 0.35;
  yI[1] = 0.02;
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->evalCalculatedVarI(ModelGenerator::pNum_, &yI[0], &yp[0]), calculatedVars[ModelGenerator::pNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->evalCalculatedVarI(ModelGenerator::qNum_, &yI[0], &yp[0]), calculatedVars[ModelGenerator::qNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->evalCalculatedVarI(ModelGenerator::genStateNum_, &yI[0], &yp[0]), calculatedVars[ModelGenerator::genStateNum_]);
  ASSERT_THROW_DYNAWO(gen->evalCalculatedVarI(42, &yI[0], &yp[0]), Error::MODELER, KeyError_t::UndefCalculatedVarI);

  gen->setConnected(OPEN);
  gen->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelGenerator::pNum_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelGenerator::qNum_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelGenerator::genStateNum_], OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->evalCalculatedVarI(ModelGenerator::pNum_, &yI[0], &yp[0]), calculatedVars[ModelGenerator::pNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->evalCalculatedVarI(ModelGenerator::qNum_, &yI[0], &yp[0]), calculatedVars[ModelGenerator::qNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->evalCalculatedVarI(ModelGenerator::genStateNum_, &yI[0], &yp[0]), calculatedVars[ModelGenerator::genStateNum_]);
  gen->setConnected(CLOSED);

  std::vector<double> res(2, 0.);
  ASSERT_THROW_DYNAWO(gen->evalJCalculatedVarI(42, &yI[0], &yp[0], res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(gen->evalJCalculatedVarI(ModelGenerator::pNum_, &yI[0], &yp[0], res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 1.0380585280245214e-14);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 1.9984014443252818e-15);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(gen->evalJCalculatedVarI(ModelGenerator::qNum_, &yI[0], &yp[0], res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 2.2204460492503131e-15);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -0.);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(gen->evalJCalculatedVarI(ModelGenerator::genStateNum_, &yI[0], &yp[0], res));
  for (size_t i = 0; i < res.size(); ++i) {
    ASSERT_DOUBLE_EQUALS_DYNAWO(res[i], 0.);
  }

  gen->setConnected(OPEN);
  res.clear();
  ASSERT_NO_THROW(gen->evalJCalculatedVarI(ModelGenerator::pNum_, &yI[0], &yp[0], res));
  ASSERT_NO_THROW(gen->evalJCalculatedVarI(ModelGenerator::qNum_, &yI[0], &yp[0], res));
  ASSERT_NO_THROW(gen->evalJCalculatedVarI(ModelGenerator::genStateNum_, &yI[0], &yp[0], res));
  gen->setConnected(CLOSED);

  int offset = 2;
  gen->init(offset);
  std::vector<int> numVars;
  ASSERT_THROW_DYNAWO(gen->getDefJCalculatedVarI(42, numVars), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(gen->getDefJCalculatedVarI(ModelGenerator::pNum_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(gen->getDefJCalculatedVarI(ModelGenerator::qNum_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(gen->getDefJCalculatedVarI(ModelGenerator::genStateNum_, numVars));
  ASSERT_EQ(numVars.size(), 0);

  shared_ptr<ModelGenerator> genInit = createModelGenerator(false, true).first;
  genInit->initSize();
  ASSERT_EQ(genInit->sizeCalculatedVar(), 0);
}

TEST(ModelsModelNetwork, ModelNetworkGeneratorDiscreteVariables) {
  std::pair<shared_ptr<ModelGenerator>, shared_ptr<ModelVoltageLevel> > p = createModelGenerator(false, false);
  shared_ptr<ModelGenerator> gen = p.first;
  gen->initSize();
  unsigned nbZ = 3;
  unsigned nbG = 0;
  ASSERT_EQ(gen->sizeZ(), nbZ);
  ASSERT_EQ(gen->sizeG(), nbG);
  std::vector<double> y(gen->sizeY(), 0.);
  std::vector<double> yp(gen->sizeY(), 0.);
  std::vector<double> f(gen->sizeF(), 0.);
  std::vector<double> z(nbZ, 0.);
  std::vector<state_g> g(nbG, NO_ROOT);
  gen->setReferenceG(&g[0], 0);
  gen->setReferenceZ(&z[0], 0);
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
  gen->evalZ(0.);
  ASSERT_EQ(gen->getConnected(), OPEN);
  ASSERT_EQ(z[0], OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->Pc(), 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->Qc(), 2.);

  ASSERT_EQ(gen->evalState(0.), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(gen->getConnected(), OPEN);
  z[0] = CLOSED;
  gen->evalZ(0.);
  ASSERT_EQ(gen->evalState(0.), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(gen->getConnected(), CLOSED);
  ASSERT_EQ(gen->evalState(0.), NetworkComponent::NO_CHANGE);
  ASSERT_DOUBLE_EQUALS_DYNAWO(gen->getConnected(), CLOSED);

  std::map<int, std::string> gEquationIndex;
  gen->setGequations(gEquationIndex);
  ASSERT_EQ(gEquationIndex.size(), nbG);
  ASSERT_NO_THROW(gen->evalG(0.));

  shared_ptr<ModelGenerator> genInit = createModelGenerator(false, true).first;
  genInit->initSize();
  ASSERT_EQ(genInit->sizeZ(), 0);
  ASSERT_EQ(genInit->sizeG(), 0);
}

TEST(ModelsModelNetwork, ModelNetworkGeneratorContinuousVariables) {
  std::pair<shared_ptr<ModelGenerator>, shared_ptr<ModelVoltageLevel> > p = createModelGenerator(false, false);
  shared_ptr<ModelGenerator> gen = p.first;
  unsigned nbY = 0;
  unsigned nbF = 0;
  ASSERT_EQ(gen->sizeY(), nbY);
  ASSERT_EQ(gen->sizeF(), nbF);

  // test evalYType
  ASSERT_NO_THROW(gen->evalYType());
  ASSERT_NO_THROW(gen->evalFType());

  // test evalF
  ASSERT_NO_THROW(gen->evalF());

  // test setFequations
  std::map<int, std::string> fEquationIndex;
  ASSERT_NO_THROW(gen->setFequations(fEquationIndex));
  ASSERT_EQ(fEquationIndex.size(), 0);

  shared_ptr<ModelGenerator> genInit = createModelGenerator(false, true).first;
  genInit->initSize();
  ASSERT_EQ(genInit->sizeY(), 0);
  ASSERT_EQ(genInit->sizeF(), 0);
  ASSERT_NO_THROW(genInit->getY0());
  ASSERT_NO_THROW(genInit->evalF());
  fEquationIndex.clear();
  ASSERT_NO_THROW(genInit->setFequations(fEquationIndex));
}

TEST(ModelsModelNetwork, ModelNetworkGeneratorDefineInstantiate) {
  std::pair<shared_ptr<ModelGenerator>, shared_ptr<ModelVoltageLevel> > p = createModelGenerator(false, false);
  shared_ptr<ModelGenerator> gen = p.first;

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


  std::vector<ParameterModeler> parameters;
  gen->defineNonGenericParameters(parameters);
  ASSERT_TRUE(parameters.empty());
  boost::unordered_map<std::string, ParameterModeler> parametersModels;
  ASSERT_NO_THROW(gen->setSubModelParameters(parametersModels));
}

TEST(ModelsModelNetwork, ModelNetworkGeneratorJt) {
  std::pair<shared_ptr<ModelGenerator>, shared_ptr<ModelVoltageLevel> > p = createModelGenerator(false, false);
  shared_ptr<ModelGenerator> gen = p.first;
  gen->initSize();
  gen->evalYMat();
  SparseMatrix smj;
  int size = gen->sizeF();
  smj.init(size, size);
  gen->evalJt(smj, 1., 0);
  ASSERT_EQ(smj.nbElem(), 0);

  SparseMatrix smjPrime;
  smjPrime.init(size, size);
  gen->evalJtPrim(smjPrime, 0);
  ASSERT_EQ(smjPrime.nbElem(), 0);
}

}  // namespace DYN
