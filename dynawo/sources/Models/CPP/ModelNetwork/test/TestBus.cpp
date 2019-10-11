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

#include <IIDM/builders/VoltageLevelBuilder.h>
#include <IIDM/builders/BusBuilder.h>
#include <IIDM/components/VoltageLevel.h>
#include <IIDM/components/Bus.h>

#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNBusInterfaceIIDM.h"
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

#include "DYNModelBus.h"
#include "gtest_dynawo.h"

using boost::shared_ptr;


namespace DYN {

std::pair<shared_ptr<ModelBus>, shared_ptr<ModelVoltageLevel> >  // need to return the voltage level so that it is not destroyed
createModelBus(bool initModel) {
  IIDM::builders::BusBuilder bb;
  bb.angle(90);
  bb.v(100);
  IIDM::Bus bus1IIDM = bb.build("MyBus1");

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::bus_breaker);
  vlb.nominalV(5.);
  IIDM::VoltageLevel vlIIDM = vlb.build("MyVoltageLevel");
  vlIIDM.add(bus1IIDM);
  vlIIDM.lowVoltageLimit(0.5);
  vlIIDM.highVoltageLimit(2.);

  shared_ptr<VoltageLevelInterfaceIIDM> vlItfIIDM = shared_ptr<VoltageLevelInterfaceIIDM>(new VoltageLevelInterfaceIIDM(vlIIDM));
  shared_ptr<BusInterfaceIIDM> bus1ItfIIDM = shared_ptr<BusInterfaceIIDM>(new BusInterfaceIIDM(vlIIDM.get_bus("MyBus1")));
  bus1ItfIIDM->hasConnection(true);

  ModelNetwork* network = new ModelNetwork();
  network->setIsInitModel(initModel);
  boost::shared_ptr<constraints::ConstraintsCollection> constraints =
      constraints::ConstraintsCollectionFactory::newInstance("MyConstraintsCollection");
  network->setTimeline(timeline::TimelineFactory::newInstance("Test"));
  network->setConstraints(constraints);
  shared_ptr<ModelVoltageLevel> vl = shared_ptr<ModelVoltageLevel>(new ModelVoltageLevel(vlItfIIDM));
  shared_ptr<ModelBus> bus1 = shared_ptr<ModelBus>(new ModelBus(bus1ItfIIDM));
  bus1->setNetwork(network);
  bus1->setVoltageLevel(vl);
  return std::make_pair(bus1, vl);
}

TEST(ModelsModelNetwork, ModelNetworkSubNetwork) {
  SubNetwork sub;
  ASSERT_EQ(sub.getNum(), 0);
  SubNetwork sub2(4);
  ASSERT_EQ(sub2.getNum(), 4);

  sub.setNum(8);
  ASSERT_EQ(sub.getNum(), 8);
  ASSERT_EQ(sub.nbBus(), 0);
  ASSERT_DEATH(sub.bus(1), "Bus index unknown");

  ASSERT_DEATH(sub.addBus(shared_ptr<ModelBus>()), "Undefined bus");

  std::pair<shared_ptr<ModelBus>, shared_ptr<ModelVoltageLevel> > p = createModelBus(false);
  shared_ptr<ModelBus> bus = p.first;
  sub.addBus(bus);
  ASSERT_EQ(sub.nbBus(), 1);
  ASSERT_EQ(bus, sub.bus(0));

  ASSERT_FALSE(bus->getSwitchOff());
  sub.shutDownNodes();
  ASSERT_TRUE(bus->getSwitchOff());
  sub.turnOnNodes();
  ASSERT_FALSE(bus->getSwitchOff());
}

TEST(ModelsModelNetwork, ModelNetworkBusInitialization) {
  std::pair<shared_ptr<ModelBus>, shared_ptr<ModelVoltageLevel> > p = createModelBus(false);
  shared_ptr<ModelBus> bus = p.first;
  ASSERT_EQ(bus->id(), "MyBus1");
  ASSERT_FALSE(bus->getSwitchOff());
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus->getAngle0(), M_PI/2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus->getU0(), 20.);
  ASSERT_EQ(bus->getRefIslands(), 0);
  ASSERT_FALSE(bus->numSubNetworkSet());
  ASSERT_THROW(bus->numSubNetwork(), boost::bad_optional_access);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus->getVNom(), 5.);
  ASSERT_FALSE(bus->hasBBS());
  ASSERT_EQ(bus->getBusIndex(), 0);
}

TEST(ModelsModelNetwork, ModelNetworkBusCalculatedVariables) {
  std::pair<shared_ptr<ModelBus>, shared_ptr<ModelVoltageLevel> > p = createModelBus(false);
  shared_ptr<ModelBus> bus = p.first;
  bus->initSize();
  std::vector<double> y(bus->sizeY(), 0.);
  std::vector<double> yp(bus->sizeY(), 0.);
  std::vector<double> f(bus->sizeF(), 0.);
  std::vector<double> z(bus->sizeZ(), 0.);
  bus->setReferenceZ(&z[0], 0);
  bus->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  y[ModelBus::urNum_] = 0.35;
  y[ModelBus::uiNum_] = 0.02;
  ASSERT_EQ(bus->sizeCalculatedVar(), ModelBus::nbCalculatedVariables_);

  std::vector<double> calculatedVars(ModelBus::nbCalculatedVariables_, 0.);
  bus->setReferenceCalculatedVar(&calculatedVars[0], 0);
  bus->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelBus::upuNum_], 0.35057096285916206);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelBus::phipuNum_], 0.057080782406264609);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelBus::uNum_], 1.7528548142958102);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelBus::phiNum_], 3.2704879231835657);
  std::vector<double> yI(2, 0.);
  yI[0] = 0.35;
  yI[1] = 0.02;
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus->evalCalculatedVarI(ModelBus::upuNum_, &yI[0], &yp[0]), calculatedVars[ModelBus::upuNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus->evalCalculatedVarI(ModelBus::phipuNum_, &yI[0], &yp[0]), calculatedVars[ModelBus::phipuNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus->evalCalculatedVarI(ModelBus::uNum_, &yI[0], &yp[0]), calculatedVars[ModelBus::uNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus->evalCalculatedVarI(ModelBus::phiNum_, &yI[0], &yp[0]), calculatedVars[ModelBus::phiNum_]);
  ASSERT_THROW_DYNAWO(bus->evalCalculatedVarI(42, &yI[0], &yp[0]), Error::MODELER, KeyError_t::UndefCalculatedVarI);

  bus->switchOff();
  bus->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelBus::upuNum_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelBus::phipuNum_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelBus::uNum_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelBus::phiNum_], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus->evalCalculatedVarI(ModelBus::upuNum_, &yI[0], &yp[0]), calculatedVars[ModelBus::upuNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus->evalCalculatedVarI(ModelBus::phipuNum_, &yI[0], &yp[0]), calculatedVars[ModelBus::phipuNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus->evalCalculatedVarI(ModelBus::uNum_, &yI[0], &yp[0]), calculatedVars[ModelBus::uNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus->evalCalculatedVarI(ModelBus::phiNum_, &yI[0], &yp[0]), calculatedVars[ModelBus::phiNum_]);
  bus->switchOn();

  std::vector<double> res(2, 0.);
  ASSERT_THROW_DYNAWO(bus->evalJCalculatedVarI(42, &yI[0], &yp[0], res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(bus->evalJCalculatedVarI(ModelBus::upuNum_, &yI[0], &yp[0], res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.99837133442397663);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.057049790538512953);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(bus->evalJCalculatedVarI(ModelBus::phipuNum_, &yI[0], &yp[0], res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -0.16273393002441011);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 2.8478437754271764);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(bus->evalJCalculatedVarI(ModelBus::uNum_, &yI[0], &yp[0], res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 4.9918566721198836);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.28524895269256478);
  std::fill(res.begin(), res.end(), 0);
  ASSERT_NO_THROW(bus->evalJCalculatedVarI(ModelBus::phiNum_, &yI[0], &yp[0], res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -9.3239673739759699);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 163.16942904457943);
  std::fill(res.begin(), res.end(), 0);

  bus->switchOff();
  ASSERT_NO_THROW(bus->evalJCalculatedVarI(ModelBus::upuNum_, &yI[0], &yp[0], res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  ASSERT_NO_THROW(bus->evalJCalculatedVarI(ModelBus::phipuNum_, &yI[0], &yp[0], res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  ASSERT_NO_THROW(bus->evalJCalculatedVarI(ModelBus::uNum_, &yI[0], &yp[0], res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  ASSERT_NO_THROW(bus->evalJCalculatedVarI(ModelBus::phiNum_, &yI[0], &yp[0], res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.);
  bus->switchOn();
//
  int offset = 2;
  bus->init(offset);
  std::vector<int> numVars;
  ASSERT_THROW_DYNAWO(bus->getDefJCalculatedVarI(42, numVars), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(bus->getDefJCalculatedVarI(ModelBus::upuNum_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i + 2);
  }
  numVars.clear();
  ASSERT_NO_THROW(bus->getDefJCalculatedVarI(ModelBus::phipuNum_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i + 2);
  }
  numVars.clear();
  ASSERT_NO_THROW(bus->getDefJCalculatedVarI(ModelBus::uNum_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i + 2);
  }
  numVars.clear();
  ASSERT_NO_THROW(bus->getDefJCalculatedVarI(ModelBus::phiNum_, numVars));
  ASSERT_EQ(numVars.size(), 2);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i + 2);
  }
  numVars.clear();

  shared_ptr<ModelBus> busInit = createModelBus(true).first;
  busInit->initSize();
  ASSERT_EQ(busInit->sizeCalculatedVar(), 0);
}

TEST(ModelsModelNetwork, ModelNetworkBusDiscreteVariables) {
  std::pair<shared_ptr<ModelBus>, shared_ptr<ModelVoltageLevel> > p = createModelBus(false);
  shared_ptr<ModelBus> bus = p.first;
  bus->initSize();
  unsigned nbZ = 3;
  unsigned nbG = 4;
  ASSERT_EQ(bus->sizeZ(), nbZ);
  ASSERT_EQ(bus->sizeG(), nbG);
  std::vector<double> y(bus->sizeY(), 0.);
  std::vector<double> yp(bus->sizeY(), 0.);
  std::vector<double> f(bus->sizeF(), 0.);
  std::vector<double> z(nbZ, 0.);
  std::vector<state_g> g(nbG, NO_ROOT);
  bus->setReferenceG(&g[0], 0);
  bus->setReferenceZ(&z[0], 0);
  bus->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  ModelNetwork* network = new ModelNetwork();
  boost::shared_ptr<constraints::ConstraintsCollection> constraints =
      constraints::ConstraintsCollectionFactory::newInstance("MyConstraintsCollection");
  network->setTimeline(timeline::TimelineFactory::newInstance("Test"));
  network->setConstraints(constraints);
  bus->setNetwork(network);


  bus->numSubNetwork(2);
  ASSERT_TRUE(bus->numSubNetworkSet());
  bus->getY0();
  ASSERT_EQ(z[0], bus->numSubNetwork());
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[1], fromNativeBool(bus->getSwitchOff()));
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[2], CLOSED);

  z[0] = 42;
  z[1] = fromNativeBool(!bus->getSwitchOff());
  z[2] = OPEN;
  ASSERT_FALSE(bus->getSwitchOff());
  ASSERT_EQ(bus->getConnectionState(), CLOSED);
  g[0] = ROOT_UP;
  g[1] = ROOT_UP;
  bus->evalZ(0.);
  ASSERT_TRUE(bus->getSwitchOff());
  ASSERT_EQ(bus->getConnectionState(), OPEN);
  unsigned i = 0;
  for (constraints::ConstraintsCollection::const_iterator it = constraints->cbegin(),
      itEnd = constraints->cend(); it != itEnd; ++it) {
    boost::shared_ptr<constraints::Constraint> constraint = (*it);
    if (i == 0) {
      ASSERT_EQ(constraint->getModelName(), "MyBus1");
      ASSERT_EQ(constraint->getDescription(), "UInfUmin");
      ASSERT_DOUBLE_EQUALS_DYNAWO(constraint->getTime(), 0.);
      ASSERT_EQ(constraint->getType(), constraints::CONSTRAINT_BEGIN);
    } else if (i == 1) {
      ASSERT_EQ(constraint->getModelName(), "MyBus1");
      ASSERT_EQ(constraint->getDescription(), "USupUmax");
      ASSERT_DOUBLE_EQUALS_DYNAWO(constraint->getTime(), 0.);
      ASSERT_EQ(constraint->getType(), constraints::CONSTRAINT_BEGIN);
    } else {
      assert(0);
    }
    ++i;
  }
  ASSERT_EQ(i, 2);
  g[0] = ROOT_DOWN;
  g[1] = ROOT_DOWN;
  g[2] = ROOT_UP;
  g[3] = ROOT_UP;
  bus->evalZ(10.);
  network->setCurrentTime(10);
  for (constraints::ConstraintsCollection::const_iterator it = constraints->cbegin(),
      itEnd = constraints->cend(); it != itEnd; ++it) {
    boost::shared_ptr<constraints::Constraint> constraint = (*it);
    assert(0);
  }

  ASSERT_EQ(bus->evalState(0.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(bus->getConnectionState(), OPEN);
  z[2] = CLOSED;
  bus->evalZ(0.);
  ASSERT_EQ(bus->evalState(0.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(bus->getConnectionState(), CLOSED);
  ASSERT_EQ(bus->evalState(0.), NetworkComponent::NO_CHANGE);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus->getConnectionState(), CLOSED);

  y[0] = 2;
  y[1] = 3;
  std::fill(g.begin(), g.end(), ROOT_DOWN);
  bus->evalG(0.);
  ASSERT_EQ(g[0], ROOT_UP);
  ASSERT_EQ(g[1], ROOT_DOWN);
  ASSERT_EQ(g[2], ROOT_DOWN);
  ASSERT_EQ(g[3], ROOT_UP);
  std::map<int, std::string> gEquationIndex;
  bus->setGequations(gEquationIndex);
  ASSERT_EQ(gEquationIndex.size(), nbG);

  bus->clearNumSubNetwork();
  ASSERT_FALSE(bus->numSubNetworkSet());

  shared_ptr<ModelBus> busInit = createModelBus(true).first;
  busInit->initSize();
  ASSERT_EQ(busInit->sizeZ(), 0);
  ASSERT_EQ(busInit->sizeG(), 0);
}

TEST(ModelsModelNetwork, ModelNetworkBusContinuousVariables) {
  std::pair<shared_ptr<ModelBus>, shared_ptr<ModelVoltageLevel> > p = createModelBus(false);
  shared_ptr<ModelBus> bus = p.first;

  unsigned nbY = 4;
  unsigned nbF = 2;
  bus->initSize();
  std::vector<double> y(nbY, 0.);
  y[ModelBus::urNum_] = 0.35;
  y[ModelBus::uiNum_] = 0.02;
  y[ModelBus::irNum_] = 0.8;
  y[ModelBus::iiNum_] = 0.4;
  std::vector<double> yp(nbY, 0.);
  std::vector<double> f(nbF, 0.);
  std::vector<double> z(bus->sizeZ(), 0.);
  std::vector<state_g> g(bus->sizeG(), NO_ROOT);
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  bus->setReferenceG(&g[0], 0);
  bus->setReferenceZ(&z[0], 0);
  bus->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  bus->evalYMat();
  bus->setBufferYType(&yTypes[0], 0);
  bus->setBufferFType(&fTypes[0], 0);
  ASSERT_EQ(bus->sizeY(), nbY);
  ASSERT_EQ(bus->sizeF(), nbF);

  // test evalYType
  bus->evalYType();
  ASSERT_EQ(yTypes[ModelBus::urNum_], ALGEBRIC);
  ASSERT_EQ(yTypes[ModelBus::uiNum_], ALGEBRIC);
  ASSERT_EQ(yTypes[ModelBus::irNum_], ALGEBRIC);
  ASSERT_EQ(yTypes[ModelBus::iiNum_], ALGEBRIC);
  bus->evalFType();
  ASSERT_EQ(fTypes[ModelBus::urNum_], ALGEBRIC_EQ);
  ASSERT_EQ(fTypes[ModelBus::uiNum_], ALGEBRIC_EQ);

  // test evalF
  bus->irAdd(3.2);
  bus->iiAdd(5.5);
  ASSERT_NO_THROW(bus->evalF());
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[0], 2.4);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[1], 5.1);

  // test setFequations
  std::map<int, std::string> fEquationIndex;
  ASSERT_NO_THROW(bus->setFequations(fEquationIndex));
  ASSERT_EQ(fEquationIndex.size(), nbF);

  bus->switchOff();

  // test evalF
  y[ModelBus::urNum_] = 0.35;
  y[ModelBus::uiNum_] = 0.02;
  ASSERT_NO_THROW(bus->evalF());
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[0], 0.35);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[1], 0.02);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus->getCurrentV(), 1.7528548142958102);

  // test setFequations
  fEquationIndex.clear();
  ASSERT_NO_THROW(bus->setFequations(fEquationIndex));
  ASSERT_EQ(fEquationIndex.size(), nbF);
}

TEST(ModelsModelNetwork, ModelNetworkBusContinuousVariablesInitModel) {
  std::pair<shared_ptr<ModelBus>, shared_ptr<ModelVoltageLevel> > p = createModelBus(true);
  shared_ptr<ModelBus> bus = p.first;

  unsigned nbY = 2;
  unsigned nbF = 2;
  bus->initSize();
  std::vector<double> y(nbY, 0.);
  y[ModelBus::urNum_] = 0.35;
  y[ModelBus::uiNum_] = 0.02;
  std::vector<double> yp(nbY, 0.);
  std::vector<double> f(nbF, 0.);
  std::vector<double> z(bus->sizeZ(), 0.);
  std::vector<state_g> g(bus->sizeG(), NO_ROOT);
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  bus->setReferenceG(&g[0], 0);
  bus->setReferenceZ(&z[0], 0);
  bus->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  bus->evalYMat();
  bus->setBufferYType(&yTypes[0], 0);
  bus->setBufferFType(&fTypes[0], 0);
  ASSERT_EQ(bus->sizeY(), nbY);
  ASSERT_EQ(bus->sizeF(), nbF);

  // test evalYType
  bus->evalYType();
  ASSERT_EQ(yTypes[ModelBus::urNum_], ALGEBRIC);
  ASSERT_EQ(yTypes[ModelBus::uiNum_], ALGEBRIC);
  bus->evalFType();
  ASSERT_EQ(fTypes[ModelBus::urNum_], ALGEBRIC_EQ);
  ASSERT_EQ(fTypes[ModelBus::uiNum_], ALGEBRIC_EQ);

  // test evalF
  bus->irAdd(3.2);
  bus->iiAdd(5.5);
  ASSERT_NO_THROW(bus->evalF());
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[0], 3.2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[1], 5.5);

  // test setFequations
  std::map<int, std::string> fEquationIndex;
  ASSERT_NO_THROW(bus->setFequations(fEquationIndex));
  ASSERT_EQ(fEquationIndex.size(), nbF);
}

TEST(ModelsModelNetwork, ModelNetworkBusDefineInstantiate) {
  std::pair<shared_ptr<ModelBus>, shared_ptr<ModelVoltageLevel> > p = createModelBus(false);
  shared_ptr<ModelBus> bus = p.first;

  std::vector<shared_ptr<Variable> > definedVariables;
  std::vector<shared_ptr<Variable> > instantiatedVariables;
  bus->defineVariables(definedVariables);
  bus->instantiateVariables(instantiatedVariables);
  ASSERT_EQ(definedVariables.size(), instantiatedVariables.size());

  unsigned nbAlias = 0;
  unsigned nbCalc = 0;
  unsigned nbVar = 0;
  for (size_t i = 0, iEnd = definedVariables.size(); i < iEnd; ++i) {
    std::string var = instantiatedVariables[i]->getName();
    boost::replace_all(var, bus->id(), "@ID@");
    ASSERT_EQ(definedVariables[i]->getName(), var);
    if (instantiatedVariables[i]->isAlias()) {
      std::string alias = boost::dynamic_pointer_cast<VariableAlias>(instantiatedVariables[i])->getReferenceVariableName();
      boost::replace_all(alias, bus->id(), "@ID@");
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
  ASSERT_EQ(nbAlias, 4);
  ASSERT_EQ(nbCalc, 4);
  ASSERT_EQ(nbVar, 7);


  std::vector<ParameterModeler> parameters;
  bus->defineNonGenericParameters(parameters);
  ASSERT_TRUE(parameters.empty());
  boost::unordered_map<std::string, ParameterModeler> parametersModels;
  const std::string paramName = "bus_uMax";
  ParameterModeler param = ParameterModeler(paramName, VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
  param.setValue<double>(10., PAR);
  parametersModels.insert(std::make_pair(paramName, param));
  const std::string param2Name = "bus_uMin";
  ParameterModeler param2 = ParameterModeler(param2Name, VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
  param2.setValue<double>(1., PAR);
  parametersModels.insert(std::make_pair(param2Name, param2));
  ASSERT_NO_THROW(bus->setSubModelParameters(parametersModels));
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus->getUMax(), 10.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(bus->getUMin(), 1.);
}

TEST(ModelsModelNetwork, ModelNetworkBusJt) {
  std::pair<shared_ptr<ModelBus>, shared_ptr<ModelVoltageLevel> > p = createModelBus(false);
  shared_ptr<ModelBus> bus = p.first;

  bus->initSize();
  std::vector<double> y(bus->sizeY(), 0.);
  std::vector<double> yp(bus->sizeY(), 0.);
  std::vector<double> f(bus->sizeF(), 0.);
  std::vector<double> z(bus->sizeZ(), 0.);
  bus->setReferenceZ(&z[0], 0);
  bus->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  bus->evalYMat();
  y[ModelBus::urNum_] = 0.35;
  y[ModelBus::uiNum_] = 0.02;
  SparseMatrix smj;
  int size = bus->sizeF();
  smj.init(size, size);
  bus->evalJt(smj, 1., 0);
  ASSERT_EQ(smj.nbElem(), 0);
  ASSERT_EQ(smj.Ap_[0], 0);
  ASSERT_EQ(smj.Ap_[1], 0);

  int yNum = 2;
  bus->init(yNum);
  ASSERT_EQ(yNum, 6);
  bus->evalDerivatives();
  SparseMatrix smj2;
  smj2.init(size, size);
  bus->evalJt(smj2, 1., 0);
  ASSERT_EQ(smj2.nbElem(), 2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[0], -1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[1], -1.);
  ASSERT_EQ(smj2.Ap_[0], 0);
  ASSERT_EQ(smj2.Ap_[1], 1);
  ASSERT_EQ(smj2.Ap_[2], 2);

  bus->switchOff();
  SparseMatrix smj3;
  smj3.init(size, size);
  bus->evalJt(smj3, 1., 0);
  ASSERT_EQ(smj3.nbElem(), 2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj3.Ax_[0], 1.0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj3.Ax_[1], 1.0);
  ASSERT_EQ(smj3.Ap_[0], 0);
  ASSERT_EQ(smj3.Ap_[1], 1);

  SparseMatrix smjPrime;
  smjPrime.init(size, size);
  bus->evalJtPrim(smjPrime, 0);
  ASSERT_EQ(smjPrime.nbElem(), 0);
}

TEST(ModelsModelNetwork, ModelNetworkBusContainer) {
  IIDM::builders::BusBuilder bb;
  bb.angle(90);
  bb.v(100);
  IIDM::Bus bus1IIDM = bb.build("MyBus1");
  IIDM::Bus bus2IIDM = bb.build("MyBus2");
  IIDM::Bus bus3IIDM = bb.build("MyBus3");

  IIDM::builders::VoltageLevelBuilder vlb;
  vlb.mode(IIDM::VoltageLevel::bus_breaker);
  vlb.nominalV(5.);
  IIDM::VoltageLevel vlIIDM = vlb.build("MyVoltageLevel");
  vlIIDM.add(bus1IIDM);
  vlIIDM.add(bus2IIDM);
  vlIIDM.add(bus3IIDM);
  vlIIDM.lowVoltageLimit(0.5);
  vlIIDM.highVoltageLimit(2.);

  shared_ptr<VoltageLevelInterfaceIIDM> vlItfIIDM = shared_ptr<VoltageLevelInterfaceIIDM>(new VoltageLevelInterfaceIIDM(vlIIDM));
  shared_ptr<BusInterfaceIIDM> bus1ItfIIDM = shared_ptr<BusInterfaceIIDM>(new BusInterfaceIIDM(vlIIDM.get_bus("MyBus1")));
  shared_ptr<BusInterfaceIIDM> bus2ItfIIDM = shared_ptr<BusInterfaceIIDM>(new BusInterfaceIIDM(vlIIDM.get_bus("MyBus2")));
  shared_ptr<BusInterfaceIIDM> bus3ItfIIDM = shared_ptr<BusInterfaceIIDM>(new BusInterfaceIIDM(vlIIDM.get_bus("MyBus3")));
  bus1ItfIIDM->hasConnection(true);
  bus2ItfIIDM->hasConnection(true);
  bus3ItfIIDM->hasConnection(true);

  ModelNetwork* network = new ModelNetwork();
  boost::shared_ptr<constraints::ConstraintsCollection> constraints =
      constraints::ConstraintsCollectionFactory::newInstance("MyConstraintsCollection");
  network->setTimeline(timeline::TimelineFactory::newInstance("Test"));
  network->setConstraints(constraints);
  shared_ptr<ModelVoltageLevel> vl = shared_ptr<ModelVoltageLevel>(new ModelVoltageLevel(vlItfIIDM));
  shared_ptr<ModelBus> bus1 = shared_ptr<ModelBus>(new ModelBus(bus1ItfIIDM));
  bus1->setNetwork(network);
  bus1->setVoltageLevel(vl);
  shared_ptr<ModelBus> bus2 = shared_ptr<ModelBus>(new ModelBus(bus2ItfIIDM));
  bus2->setNetwork(network);
  bus2->setVoltageLevel(vl);
  shared_ptr<ModelBus> bus3 = shared_ptr<ModelBus>(new ModelBus(bus3ItfIIDM));
  bus3->setNetwork(network);
  bus3->setVoltageLevel(vl);


  bus1->addNeighbor(bus2);


  ModelBusContainer container;
  container.add(bus1);
  container.add(bus2);
  container.add(bus3);

  ASSERT_FALSE(bus1->numSubNetworkSet());
  ASSERT_FALSE(bus2->numSubNetworkSet());
  ASSERT_FALSE(bus3->numSubNetworkSet());
  container.exploreNeighbors();
  ASSERT_EQ(bus1->numSubNetwork(), 0);
  ASSERT_EQ(bus2->numSubNetwork(), 0);
  ASSERT_EQ(bus3->numSubNetwork(), 1);
  ASSERT_EQ(container.getSubNetworks().size(), 2);
  container.resetSubNetwork();
  ASSERT_FALSE(bus1->numSubNetworkSet());
  ASSERT_FALSE(bus2->numSubNetworkSet());
  ASSERT_FALSE(bus3->numSubNetworkSet());
  ASSERT_EQ(container.getSubNetworks().size(), 0);

  bus1->evalDerivatives();
  bus1->initSize();
  std::vector<double> y1(bus1->sizeY(), 0.);
  std::vector<double> yp1(bus1->sizeY(), 0.);
  std::vector<double> f1(bus1->sizeF(), 0.);
  std::vector<double> z1(bus1->sizeZ(), 0.);
  bus1->setReferenceZ(&z1[0], 0);
  bus1->setReferenceY(&y1[0], &yp1[0], &f1[0], 0, 0);
  bus1->evalYMat();
  bus1->irAdd(0.1);
  bus1->iiAdd(0.01);

  bus2->evalDerivatives();
  bus2->initSize();
  std::vector<double> y2(bus2->sizeY(), 0.);
  std::vector<double> yp2(bus2->sizeY(), 0.);
  std::vector<double> f2(bus2->sizeF(), 0.);
  std::vector<double> z2(bus2->sizeZ(), 0.);
  bus2->setReferenceZ(&z2[0], 0);
  bus2->setReferenceY(&y2[0], &yp2[0], &f2[0], 0, 0);
  bus2->evalYMat();
  bus2->irAdd(0.2);
  bus2->iiAdd(0.02);

  bus3->evalDerivatives();
  bus3->initSize();
  std::vector<double> y3(bus3->sizeY(), 0.);
  std::vector<double> yp3(bus3->sizeY(), 0.);
  std::vector<double> f3(bus3->sizeF(), 0.);
  std::vector<double> z3(bus3->sizeZ(), 0.);
  bus3->setReferenceZ(&z3[0], 0);
  bus3->setReferenceY(&y3[0], &yp3[0], &f3[0], 0, 0);
  bus3->evalYMat();
  bus3->irAdd(0.3);
  bus3->iiAdd(0.03);

  container.evalF();
  ASSERT_DOUBLE_EQUALS_DYNAWO(f1[0], 0.1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f1[1], 0.01);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f2[0], 0.2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f2[1], 0.02);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f3[0], 0.3);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f3[1], 0.03);
  container.resetNodeInjections();
  container.evalF();
  ASSERT_DOUBLE_EQUALS_DYNAWO(f1[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f1[1], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f2[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f2[1], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f3[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f3[1], 0.);


  SparseMatrix smj;
  int size = bus1->sizeF()+ bus2->sizeF() + bus3->sizeF();
  smj.init(size, size);
  container.evalJt(smj, 1., 0);
  ASSERT_EQ(smj.nbElem(), 6);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[0], -1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[1], -1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[2], -1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[3], -1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[4], -1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[5], -1.);
  ASSERT_EQ(smj.Ap_[0], 0);
  ASSERT_EQ(smj.Ap_[1], 1);
  ASSERT_EQ(smj.Ap_[2], 2);
  ASSERT_EQ(smj.Ap_[3], 3);
  ASSERT_EQ(smj.Ap_[4], 4);
  ASSERT_EQ(smj.Ap_[5], 5);
  ASSERT_EQ(smj.Ap_[6], 6);
  container.initDerivatives();
  SparseMatrix smj2;
  smj2.init(size, size);
  container.evalJt(smj2, 1., 0);
  ASSERT_EQ(smj2.nbElem(), 0);

  SparseMatrix smjPrime;
  smjPrime.init(size, size);
  container.evalJtPrim(smjPrime, 0);
  ASSERT_EQ(smjPrime.nbElem(), 0);


  container.initRefIslands();
  ASSERT_EQ(bus1->getRefIslands(), 0);
  ASSERT_EQ(bus2->getRefIslands(), 0);
  ASSERT_EQ(bus3->getRefIslands(), 0);
}
}  // namespace DYN
