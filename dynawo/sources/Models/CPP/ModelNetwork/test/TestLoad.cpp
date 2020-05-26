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

#include <IIDM/builders/LoadBuilder.h>
#include <IIDM/builders/VoltageLevelBuilder.h>
#include <IIDM/builders/BusBuilder.h>
#include <IIDM/components/Load.h>
#include <IIDM/components/CurrentLimit.h>
#include <IIDM/components/VoltageLevel.h>
#include <IIDM/components/Bus.h>

#include "DYNLoadInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNCurrentLimitInterfaceIIDM.h"
#include "DYNBusInterfaceIIDM.h"
#include "DYNModelLoad.h"
#include "DYNModelVoltageLevel.h"
#include "DYNModelBus.h"
#include "DYNModelNetwork.h"
#include "TLTimelineFactory.h"
#include "DYNSparseMatrix.h"
#include "DYNVariable.h"
#include "gtest_dynawo.h"

using boost::shared_ptr;

namespace DYN {
std::pair<shared_ptr<ModelLoad>, shared_ptr<ModelVoltageLevel> >  // need to return the voltage level so that it is not destroyed
createModelLoad(bool open, bool initModel) {
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


  IIDM::builders::LoadBuilder lb;
  lb.p(42.);
  lb.q(64.);
  IIDM::Load loadIIDM = lb.build("MyLoad");
  vlIIDM.add(loadIIDM, c1);
  IIDM::Load loadIIDM2 = vlIIDM.get_load("MyLoad");  // was copied...
  shared_ptr<LoadInterfaceIIDM> loadItfIIDM = shared_ptr<LoadInterfaceIIDM>(new LoadInterfaceIIDM(loadIIDM2));
  shared_ptr<VoltageLevelInterfaceIIDM> vlItfIIDM = shared_ptr<VoltageLevelInterfaceIIDM>(new VoltageLevelInterfaceIIDM(vlIIDM));
  shared_ptr<BusInterfaceIIDM> bus1ItfIIDM = shared_ptr<BusInterfaceIIDM>(new BusInterfaceIIDM(vlIIDM.get_bus("MyBus1")));
  loadItfIIDM->setVoltageLevelInterface(vlItfIIDM);
  loadItfIIDM->setBusInterface(bus1ItfIIDM);

  shared_ptr<ModelLoad> load = shared_ptr<ModelLoad>(new ModelLoad(loadItfIIDM));
  ModelNetwork* network = new ModelNetwork();
  network->setIsInitModel(initModel);
  network->setTimeline(timeline::TimelineFactory::newInstance("Test"));
  load->setNetwork(network);
  shared_ptr<ModelVoltageLevel> vl = shared_ptr<ModelVoltageLevel>(new ModelVoltageLevel(vlItfIIDM));
  shared_ptr<ModelBus> bus1 = shared_ptr<ModelBus>(new ModelBus(bus1ItfIIDM));
  bus1->setNetwork(network);
  bus1->setVoltageLevel(vl);
  load->setModelBus(bus1);
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
  return std::make_pair(load, vl);
}

void
fillParameters(shared_ptr<ModelLoad> load) {
  boost::unordered_map<std::string, ParameterModeler> parametersModels;
  std::string paramName = "load_alpha";
  ParameterModeler param = ParameterModeler(paramName, VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
  param.setValue<double>(1., PAR);
  parametersModels.insert(std::make_pair(paramName, param));

  paramName = "load_beta";
  param = ParameterModeler(paramName, VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
  param.setValue<double>(0.5, PAR);
  parametersModels.insert(std::make_pair(paramName, param));

  paramName = "load_isRestorative";
  param = ParameterModeler(paramName, VAR_TYPE_BOOL, EXTERNAL_PARAMETER);
  param.setValue<bool>(true, PAR);
  parametersModels.insert(std::make_pair(paramName, param));

  paramName = "load_isControllable";
  param = ParameterModeler(paramName, VAR_TYPE_BOOL, EXTERNAL_PARAMETER);
  param.setValue<bool>(true, PAR);
  parametersModels.insert(std::make_pair(paramName, param));

  paramName = "load_Tp";
  param = ParameterModeler(paramName, VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
  param.setValue<double>(2., PAR);
  parametersModels.insert(std::make_pair(paramName, param));

  paramName = "load_Tq";
  param = ParameterModeler(paramName, VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
  param.setValue<double>(4., PAR);
  parametersModels.insert(std::make_pair(paramName, param));

  paramName = "load_zPMax";
  param = ParameterModeler(paramName, VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
  param.setValue<double>(6., PAR);
  parametersModels.insert(std::make_pair(paramName, param));

  paramName = "load_zQMax";
  param = ParameterModeler(paramName, VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
  param.setValue<double>(8., PAR);
  parametersModels.insert(std::make_pair(paramName, param));

  paramName = "load_alphaLong";
  param = ParameterModeler(paramName, VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
  param.setValue<double>(2., PAR);
  parametersModels.insert(std::make_pair(paramName, param));

  paramName = "load_betaLong";
  param = ParameterModeler(paramName, VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
  param.setValue<double>(0.2, PAR);
  parametersModels.insert(std::make_pair(paramName, param));

  load->setSubModelParameters(parametersModels);
}

TEST(ModelsModelNetwork, ModelNetworkLoadInitializationClosed) {
  shared_ptr<ModelLoad> load = createModelLoad(false, false).first;
  ASSERT_EQ(load->id(), "MyLoad");
  ASSERT_EQ(load->getConnected(), CLOSED);
  ASSERT_TRUE(load->isConnected());
  ASSERT_TRUE(load->isRunning());
}

TEST(ModelsModelNetwork, ModelNetworkLoadInitializationOpened) {
  shared_ptr<ModelLoad> load = createModelLoad(true, false).first;
  ASSERT_EQ(load->id(), "MyLoad");
  ASSERT_EQ(load->getConnected(), OPEN);
  ASSERT_FALSE(load->isConnected());
  ASSERT_FALSE(load->isRunning());
}

TEST(ModelsModelNetwork, ModelNetworkLoadCalculatedVariables) {
  shared_ptr<ModelLoad> load = createModelLoad(false, false).first;
  fillParameters(load);
  load->initSize();
  int yNum = 0;
  load->init(yNum);
  std::vector<double> y(load->sizeY(), 0.);
  std::vector<double> yp(load->sizeY(), 0.);
  std::vector<double> f(load->sizeF(), 0.);
  std::vector<double> z(load->sizeZ(), 0.);
  bool* zConnected = new bool[load->sizeZ()];
  for (size_t i = 0; i < load->sizeZ(); ++i)
    zConnected[i] = true;
  load->setReferenceZ(&z[0], zConnected, 0);
  load->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  const size_t DeltaPcIdx = 0;
  const size_t DeltaQcIdx = 1;
  const size_t zPIdx = 2;
  const size_t zQIdx = 3;
  y[DeltaPcIdx] = 5;
  y[DeltaQcIdx] = 7;
  y[zPIdx] = 9;
  y[zQIdx] = 11;
  load->evalYMat();
  ASSERT_EQ(load->sizeCalculatedVar(), ModelLoad::nbCalculatedVariables_);

  std::vector<double> calculatedVars(ModelLoad::nbCalculatedVariables_, 0.);
  load->setReferenceCalculatedVar(&calculatedVars[0], 0);
  load->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLoad::pNum_], 457.13001432852769);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLoad::qNum_], 252.8488540193365);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLoad::pcNum_], 12.6);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLoad::qcNum_], 11.448668044798923);
  ASSERT_EQ(calculatedVars[ModelLoad::loadStateNum_], CLOSED);
  std::vector<double> yI(4, 0.);
  yI[0] = 3.5;
  yI[1] = 2;
  yI[2] = 5.;
  yI[3] = 9.;
  ASSERT_DOUBLE_EQUALS_DYNAWO(load->evalCalculatedVarI(ModelLoad::pNum_, &yI[0], &yp[0]), calculatedVars[ModelLoad::pNum_]);
  yI[2] = 7.;
  yI[3] = 11.;
  ASSERT_DOUBLE_EQUALS_DYNAWO(load->evalCalculatedVarI(ModelLoad::qNum_, &yI[0], &yp[0]), calculatedVars[ModelLoad::qNum_]);
  yI[0] = 5.;
  ASSERT_DOUBLE_EQUALS_DYNAWO(load->evalCalculatedVarI(ModelLoad::pcNum_, &yI[0], &yp[0]), calculatedVars[ModelLoad::pcNum_]);
  yI[0] = 7.;
  ASSERT_DOUBLE_EQUALS_DYNAWO(load->evalCalculatedVarI(ModelLoad::qcNum_, &yI[0], &yp[0]), calculatedVars[ModelLoad::qcNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(load->evalCalculatedVarI(ModelLoad::loadStateNum_, &yI[0], &yp[0]), calculatedVars[ModelLoad::loadStateNum_]);
  ASSERT_THROW_DYNAWO(load->evalCalculatedVarI(42, &yI[0], &yp[0]), Error::MODELER, KeyError_t::UndefCalculatedVarI);
  load->setConnected(OPEN);
  load->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLoad::pNum_], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLoad::qNum_], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLoad::pcNum_], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelLoad::qcNum_], 0);
  load->setConnected(CLOSED);

  std::vector<double> res(4, 0.);
  ASSERT_THROW_DYNAWO(load->evalJCalculatedVarI(42, &yI[0], &yp[0], res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(load->evalJCalculatedVarI(ModelLoad::pNum_, &yI[0], &yp[0], res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 177.68962552402417);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 50.768464435435469);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 168.17053844237995);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 122.3058461399127);
  ASSERT_NO_THROW(load->evalJCalculatedVarI(ModelLoad::qNum_, &yI[0], &yp[0], res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 22.439273421249897);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 6.4112209774999709);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 42.4743389759373);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 30.890428346136222);
  res.resize(1, 0);
  ASSERT_NO_THROW(load->evalJCalculatedVarI(ModelLoad::pcNum_, &yI[0], &yp[0], res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 2.1000000000000001);
  ASSERT_NO_THROW(load->evalJCalculatedVarI(ModelLoad::qcNum_, &yI[0], &yp[0], res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 1.4310835055998654);
  res.resize(0);
  ASSERT_NO_THROW(load->evalJCalculatedVarI(ModelLoad::loadStateNum_, &yI[0], &yp[0], res));
  load->setConnected(OPEN);
  ASSERT_NO_THROW(load->evalJCalculatedVarI(ModelLoad::pNum_, &yI[0], &yp[0], res));
  ASSERT_NO_THROW(load->evalJCalculatedVarI(ModelLoad::qNum_, &yI[0], &yp[0], res));
  ASSERT_NO_THROW(load->evalJCalculatedVarI(ModelLoad::pcNum_, &yI[0], &yp[0], res));
  ASSERT_NO_THROW(load->evalJCalculatedVarI(ModelLoad::qcNum_, &yI[0], &yp[0], res));

  load->setConnected(CLOSED);
  int offset = 2;
  load->init(offset);
  std::vector<int> numVars;
  ASSERT_THROW_DYNAWO(load->getDefJCalculatedVarI(42, numVars), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(load->getDefJCalculatedVarI(ModelLoad::pNum_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  ASSERT_EQ(numVars[2], 2);
  ASSERT_EQ(numVars[3], 4);
  numVars.clear();
  ASSERT_NO_THROW(load->getDefJCalculatedVarI(ModelLoad::qNum_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  ASSERT_EQ(numVars[2], 3);
  ASSERT_EQ(numVars[3], 5);
  numVars.clear();
  ASSERT_NO_THROW(load->getDefJCalculatedVarI(ModelLoad::pcNum_, numVars));
  ASSERT_EQ(numVars.size(), 1);
  ASSERT_EQ(numVars[0], 2);
  numVars.clear();
  ASSERT_NO_THROW(load->getDefJCalculatedVarI(ModelLoad::qcNum_, numVars));
  ASSERT_EQ(numVars.size(), 1);
  ASSERT_EQ(numVars[0], 3);
  numVars.clear();
  ASSERT_NO_THROW(load->getDefJCalculatedVarI(ModelLoad::loadStateNum_, numVars));
  ASSERT_TRUE(numVars.empty());

  shared_ptr<ModelLoad> loadInit = createModelLoad(false, true).first;
  loadInit->initSize();
  ASSERT_EQ(loadInit->sizeCalculatedVar(), 0);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkLoadDiscreteVariables) {
  std::pair<shared_ptr<ModelLoad>, shared_ptr<ModelVoltageLevel> > p = createModelLoad(false, false);
  shared_ptr<ModelLoad> load = p.first;
  load->initSize();
  int yNum = 0;
  load->init(yNum);
  unsigned nbZ = 1;
  unsigned nbG = 0;
  ASSERT_EQ(load->sizeZ(), nbZ);
  ASSERT_EQ(load->sizeG(), nbG);
  std::vector<double> y(load->sizeY(), 0.);
  std::vector<double> yp(load->sizeY(), 0.);
  std::vector<double> f(load->sizeF(), 0.);
  std::vector<double> z(nbZ, 0.);
  std::vector<state_g> g(nbG, NO_ROOT);
  load->setReferenceG(&g[0], 0);
  bool* zConnected = new bool[load->sizeZ()];
  for (size_t i = 0; i < load->sizeZ(); ++i)
    zConnected[i] = true;
  load->setReferenceZ(&z[0], zConnected, 0);
  load->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);

  load->getY0();
  ASSERT_EQ(load->getConnected(), CLOSED);
  ASSERT_EQ(z[0], load->getConnected());
  load->setConnected(OPEN);
  load->getY0();
  ASSERT_EQ(load->getConnected(), OPEN);
  ASSERT_EQ(z[0], load->getConnected());
  load->setConnected(CLOSED);

  z[0] = OPEN;
  load->evalZ(0.);
  ASSERT_EQ(load->getConnected(), OPEN);
  ASSERT_EQ(z[0], OPEN);

  ASSERT_EQ(load->evalState(0.), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(load->getConnected(), OPEN);
  z[0] = CLOSED;
  load->evalZ(0.);
  ASSERT_EQ(load->evalState(0.), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(load->getConnected(), CLOSED);
  ASSERT_EQ(load->evalState(0.), NetworkComponent::NO_CHANGE);
  ASSERT_DOUBLE_EQUALS_DYNAWO(load->getConnected(), CLOSED);

  std::map<int, std::string> gEquationIndex;
  load->setGequations(gEquationIndex);
  ASSERT_EQ(gEquationIndex.size(), nbG);
  ASSERT_NO_THROW(load->evalG(0.));

  shared_ptr<ModelLoad> loadInit = createModelLoad(false, true).first;
  loadInit->initSize();
  ASSERT_EQ(loadInit->sizeZ(), 0);
  ASSERT_EQ(loadInit->sizeG(), 0);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkLoadContinuousVariables) {
  std::pair<shared_ptr<ModelLoad>, shared_ptr<ModelVoltageLevel> > p = createModelLoad(false, false);
  shared_ptr<ModelLoad> load = p.first;
  int yNum = 0;
  load->init(yNum);
  fillParameters(load);
  load->initSize();
  unsigned nbY = 4;
  unsigned nbF = 2;
  ASSERT_EQ(load->sizeY(), nbY);
  ASSERT_EQ(load->sizeF(), nbF);
  std::vector<double> y(nbY, 0.);
  std::vector<double> yp(nbY, 0.);
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<double> f(nbF, 0.);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  std::vector<double> z(load->sizeZ(), 0.);
  bool* zConnected = new bool[load->sizeZ()];
  for (size_t i = 0; i < load->sizeZ(); ++i)
    zConnected[i] = true;
  load->setReferenceZ(&z[0], zConnected, 0);
  load->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  load->evalYMat();
  const size_t DeltaPcIdx = 0;
  const size_t DeltaQcIdx = 1;
  const size_t zPIdx = 2;
  const size_t zQIdx = 3;
  y[DeltaPcIdx] = 5;
  y[DeltaQcIdx] = 7;
  y[zPIdx] = 9;
  y[zQIdx] = 11;
  load->setBufferYType(&yTypes[0], 0);
  load->setBufferFType(&fTypes[0], 0);

  // test evalYType
  load->evalYType();
  ASSERT_EQ(yTypes[DeltaPcIdx], EXTERNAL);
  ASSERT_EQ(yTypes[DeltaQcIdx], EXTERNAL);
  ASSERT_EQ(yTypes[zPIdx], DIFFERENTIAL);
  ASSERT_EQ(yTypes[zQIdx], DIFFERENTIAL);
  load->evalFType();
  ASSERT_EQ(fTypes[DeltaPcIdx], DIFFERENTIAL_EQ);
  ASSERT_EQ(fTypes[DeltaQcIdx], DIFFERENTIAL_EQ);

  // test getY0
  y[DeltaPcIdx] = 2.;
  y[DeltaQcIdx] = 5.;
  y[zPIdx] = 2.;
  y[zQIdx] = 5.;
  yp[DeltaPcIdx] = 2.;
  yp[DeltaQcIdx] = 5.;
  yp[zPIdx] = 2.;
  yp[zQIdx] = 5.;
  load->getY0();
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[DeltaPcIdx], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[DeltaQcIdx], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[zPIdx], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[zQIdx], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[DeltaPcIdx], 2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[DeltaQcIdx], 5);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[zPIdx], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[zQIdx], 0);

  // test evalF
  load->evalF();
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[DeltaPcIdx], -402.24999999999994);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[DeltaQcIdx], 6.1766109710079018);

  // test setFequations
  std::map<int, std::string> fEquationIndex;
  load->setFequations(fEquationIndex);
  ASSERT_EQ(fEquationIndex.size(), 2);
  for (size_t i = 0; i < nbF; ++i) {
    ASSERT_TRUE(fEquationIndex.find(i) != fEquationIndex.end());
  }

  // test getY0 (bus switchoff)
  load->getModelBus()->switchOff();
  load->getY0();
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[DeltaPcIdx], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[DeltaQcIdx], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[zPIdx], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[zQIdx], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[DeltaPcIdx], 2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[DeltaQcIdx], 5);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[zPIdx], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(yp[zQIdx], 0);

  // test evalF (bus switchoff)
  load->evalF();
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[DeltaPcIdx], 2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[DeltaPcIdx], 2);

  // test setFequations
  fEquationIndex.clear();
  load->setFequations(fEquationIndex);
  ASSERT_EQ(fEquationIndex.size(), 2);
  for (size_t i = 0; i < nbF; ++i) {
    ASSERT_TRUE(fEquationIndex.find(i) != fEquationIndex.end());
  }

  shared_ptr<ModelLoad> loadInit = createModelLoad(false, true).first;
  loadInit->initSize();
  ASSERT_EQ(loadInit->sizeY(), 0);
  ASSERT_EQ(loadInit->sizeF(), 0);
  ASSERT_NO_THROW(loadInit->getY0());
  ASSERT_NO_THROW(loadInit->evalF());
  fEquationIndex.clear();
  ASSERT_NO_THROW(loadInit->setFequations(fEquationIndex));
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkLoadDefineInstantiate) {
  std::pair<shared_ptr<ModelLoad>, shared_ptr<ModelVoltageLevel> > p = createModelLoad(false, false);
  shared_ptr<ModelLoad> load = p.first;
  fillParameters(load);

  std::vector<shared_ptr<Variable> > definedVariables;
  std::vector<shared_ptr<Variable> > instantiatedVariables;
  load->defineVariables(definedVariables);
  load->instantiateVariables(instantiatedVariables);
  ASSERT_EQ(definedVariables.size(), instantiatedVariables.size());

  for (size_t i = 0, iEnd = definedVariables.size(); i < iEnd; ++i) {
    std::string var = instantiatedVariables[i]->getName();
    boost::replace_all(var, load->id(), "@ID@");
    ASSERT_EQ(definedVariables[i]->getName(), var);
    ASSERT_EQ(definedVariables[i]->getType(), instantiatedVariables[i]->getType());
  }


  std::vector<ParameterModeler> parameters;
  load->defineNonGenericParameters(parameters);

  std::vector<ParameterModeler> genericParameters;
  load->defineParameters(genericParameters);


  ASSERT_EQ(parameters.size(), 10);
  for (size_t i = 0, iEnd = parameters.size(); i < iEnd; ++i) {
    std::string var = genericParameters[i].getName();
    boost::replace_all(var, "load", load->id());
    ASSERT_EQ(parameters[i].getName(), var);
    ASSERT_EQ(parameters[i].getScope(), genericParameters[i].getScope());
    ASSERT_EQ(parameters[i].getValueType(), genericParameters[i].getValueType());
  }
}

TEST(ModelsModelNetwork, ModelNetworkLoadJt) {
  std::pair<shared_ptr<ModelLoad>, shared_ptr<ModelVoltageLevel> > p = createModelLoad(false, false);
  shared_ptr<ModelLoad> load = p.first;
  fillParameters(load);
  load->initSize();
  std::vector<double> y(load->sizeY(), 0.);
  std::vector<double> yp(load->sizeY(), 0.);
  std::vector<double> f(load->sizeF(), 0.);
  std::vector<double> z(load->sizeZ(), 0.);
  bool* zConnected = new bool[load->sizeZ()];
  for (size_t i = 0; i < load->sizeZ(); ++i)
    zConnected[i] = true;
  load->setReferenceZ(&z[0], zConnected, 0);
  load->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  load->evalYMat();
  const size_t DeltaPcIdx = 0;
  const size_t DeltaQcIdx = 1;
  const size_t zPIdx = 2;
  const size_t zQIdx = 3;
  y[DeltaPcIdx] = 5;
  y[DeltaQcIdx] = 7;
  y[zPIdx] = 9;
  y[zQIdx] = 11;
  SparseMatrix smj;
  int size = load->sizeF();
  smj.init(size, size);
  load->evalJt(smj, 1., 0);
  ASSERT_EQ(smj.nbElem(), 6);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[0], 22.155644370746373);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[1], -153.29392144688848);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[2], -87.596526541079143);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[3],  8.4895038000592429);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[4],  2.3388791341676249);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[5],  1.3365023623815);
  ASSERT_EQ(smj.Ap_[0], 0);
  ASSERT_EQ(smj.Ap_[1], 3);
  ASSERT_EQ(smj.Ap_[2], 6);

  load->getModelBus()->switchOff();
  SparseMatrix smj2;
  smj2.init(size, size);
  load->evalJt(smj2, 1., 0);
  ASSERT_EQ(smj2.nbElem(), 2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[0], 1.0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[1], 1.0);
  ASSERT_EQ(smj2.Ap_[0], 0);
  ASSERT_EQ(smj2.Ap_[1], 1);

  load->getModelBus()->switchOn();
  SparseMatrix smjPrime;
  smjPrime.init(size, size);
  load->evalJtPrim(smjPrime, 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smjPrime.Ax_[0], 2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smjPrime.Ax_[1], 4);
  ASSERT_EQ(smjPrime.Ap_[0], 0);
  ASSERT_EQ(smjPrime.Ap_[1], 1);
  ASSERT_EQ(smjPrime.Ap_[2], 2);

  shared_ptr<ModelLoad> loadInit = createModelLoad(false, true).first;
  loadInit->initSize();
  SparseMatrix smjInit;
  smjInit.init(loadInit->sizeY(), loadInit->sizeY());
  ASSERT_NO_THROW(loadInit->evalJt(smjInit, 1., 0));
  ASSERT_EQ(smjInit.nbElem(), 0);
  delete[] zConnected;
}

}  // namespace DYN
