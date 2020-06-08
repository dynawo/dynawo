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

#include <IIDM/builders/ShuntCompensatorBuilder.h>
#include <IIDM/builders/VoltageLevelBuilder.h>
#include <IIDM/builders/BusBuilder.h>
#include <IIDM/components/ShuntCompensator.h>
#include <IIDM/components/CurrentLimit.h>
#include <IIDM/components/VoltageLevel.h>
#include <IIDM/components/Bus.h>

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

#include "gtest_dynawo.h"

using boost::shared_ptr;

namespace DYN {
std::pair<shared_ptr<ModelShuntCompensator>, shared_ptr<ModelVoltageLevel> >  // need to return the voltage level so that it is not destroyed
createModelShuntCompensator(bool open, bool capacitor, bool initModel) {
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



  IIDM::builders::ShuntCompensatorBuilder scb;
  if (capacitor)
    scb.b_per_section(8.);
  else
    scb.b_per_section(-8.);
  scb.p(3);
  scb.q(5);
  scb.section_max(5);
  scb.section_current(1);
  IIDM::ShuntCompensator scIIDM = scb.build("MyShuntCompensator");
  vlIIDM.add(scIIDM, c1);
  IIDM::ShuntCompensator scIIDM2 = vlIIDM.get_shuntCompensator("MyShuntCompensator");  // was copied...
  shared_ptr<ShuntCompensatorInterfaceIIDM> scItfIIDM = shared_ptr<ShuntCompensatorInterfaceIIDM>(new ShuntCompensatorInterfaceIIDM(scIIDM2));
  shared_ptr<VoltageLevelInterfaceIIDM> vlItfIIDM = shared_ptr<VoltageLevelInterfaceIIDM>(new VoltageLevelInterfaceIIDM(vlIIDM));
  shared_ptr<BusInterfaceIIDM> bus1ItfIIDM = shared_ptr<BusInterfaceIIDM>(new BusInterfaceIIDM(vlIIDM.get_bus("MyBus1")));
  scItfIIDM->setVoltageLevelInterface(vlItfIIDM);
  scItfIIDM->setBusInterface(bus1ItfIIDM);

  shared_ptr<ModelShuntCompensator> sc = shared_ptr<ModelShuntCompensator>(new ModelShuntCompensator(scItfIIDM));
  ModelNetwork* network = new ModelNetwork();
  network->setIsInitModel(initModel);
  network->setTimeline(timeline::TimelineFactory::newInstance("Test"));
  sc->setNetwork(network);
  shared_ptr<ModelVoltageLevel> vl = shared_ptr<ModelVoltageLevel>(new ModelVoltageLevel(vlItfIIDM));
  shared_ptr<ModelBus> bus1 = shared_ptr<ModelBus>(new ModelBus(bus1ItfIIDM));
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
  return std::make_pair(sc, vl);
}


static const bool capacitance = true;
static const bool reactance = false;

TEST(ModelsModelNetwork, ModelNetworkShuntCompensatorInitialization) {
  shared_ptr<ModelShuntCompensator> capa = createModelShuntCompensator(false, capacitance, false).first;
  ASSERT_EQ(capa->id(), "MyShuntCompensator");
  ASSERT_TRUE(capa->isConnected());
  ASSERT_EQ(capa->getConnected(), CLOSED);
  ASSERT_EQ(capa->getCurrentSection(), 1);
  ASSERT_TRUE(capa->isCapacitor());

  shared_ptr<ModelShuntCompensator> rea = createModelShuntCompensator(true, reactance, false).first;
  ASSERT_EQ(rea->id(), "MyShuntCompensator");
  ASSERT_FALSE(rea->isConnected());
  ASSERT_EQ(rea->getConnected(), OPEN);
  ASSERT_EQ(rea->getCurrentSection(), 1);
  ASSERT_FALSE(rea->isCapacitor());
}

TEST(ModelsModelNetwork, ModelNetworkShuntCompensatorCalculatedVariables) {
  shared_ptr<ModelShuntCompensator> capa = createModelShuntCompensator(false, capacitance, false).first;
  capa->initSize();
  std::vector<double> y(capa->sizeY(), 0.);
  std::vector<double> yp(capa->sizeY(), 0.);
  std::vector<double> f(capa->sizeF(), 0.);
  std::vector<double> z(capa->sizeZ(), 0.);
  bool* zConnected = new bool[capa->sizeZ()];
  for (size_t i = 0; i < capa->sizeZ(); ++i)
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

  shared_ptr<ModelShuntCompensator> capaInit = createModelShuntCompensator(false, capacitance, true).first;
  capaInit->initSize();
  ASSERT_EQ(capaInit->sizeCalculatedVar(), 0);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkShuntCompensatorDiscreteVariables) {
  std::pair<shared_ptr<ModelShuntCompensator>, shared_ptr<ModelVoltageLevel> > p = createModelShuntCompensator(false, capacitance, false);
  shared_ptr<ModelShuntCompensator> capa = p.first;
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
  for (size_t i = 0; i < nbG; ++i) {
    ASSERT_TRUE(gEquationIndex.find(i) != gEquationIndex.end());
  }
  ASSERT_NO_THROW(capa->evalG(20.));
  ASSERT_DOUBLE_EQUALS_DYNAWO(g[0], ROOT_UP);
  ASSERT_NO_THROW(capa->evalG(1.));
  ASSERT_DOUBLE_EQUALS_DYNAWO(g[0], ROOT_DOWN);

  shared_ptr<ModelShuntCompensator> capaInit = createModelShuntCompensator(false, capacitance, true).first;
  capaInit->initSize();
  ASSERT_EQ(capaInit->sizeZ(), 0);
  ASSERT_EQ(capaInit->sizeG(), 0);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkShuntCompensatorContinuousVariables) {
  std::pair<shared_ptr<ModelShuntCompensator>, shared_ptr<ModelVoltageLevel> > p = createModelShuntCompensator(false, capacitance, false);
  shared_ptr<ModelShuntCompensator> capa = p.first;
  capa->initSize();
  unsigned nbY = 0;
  unsigned nbF = 0;
  unsigned urIndex = 0;
  unsigned uiIndex = 1;
  ASSERT_EQ(capa->sizeY(), nbY);
  ASSERT_EQ(capa->sizeF(), nbF);

  // test evalYType
  ASSERT_NO_THROW(capa->evalYType());
  ASSERT_NO_THROW(capa->evalFType());

  // test evalF
  ASSERT_NO_THROW(capa->evalF(UNDEFINED_EQ));

  // test setFequations
  std::map<int, std::string> fEquationIndex;
  capa->setFequations(fEquationIndex);
  ASSERT_EQ(fEquationIndex.size(), 0);

  shared_ptr<ModelShuntCompensator> capaInit = createModelShuntCompensator(false, capacitance, true).first;
  capaInit->initSize();
  ASSERT_EQ(capaInit->sizeY(), 0);
  ASSERT_EQ(capaInit->sizeF(), 0);
  ASSERT_NO_THROW(capaInit->getY0());
  ASSERT_NO_THROW(capaInit->evalF(UNDEFINED_EQ));
  fEquationIndex.clear();
  ASSERT_NO_THROW(capaInit->setFequations(fEquationIndex));
  ASSERT_EQ(fEquationIndex.size(), 0);
}

TEST(ModelsModelNetwork, ModelNetworkShuntCompensatorDefineInstantiate) {
  std::pair<shared_ptr<ModelShuntCompensator>, shared_ptr<ModelVoltageLevel> > p = createModelShuntCompensator(false, capacitance, false);
  shared_ptr<ModelShuntCompensator> capa = p.first;
  std::pair<shared_ptr<ModelShuntCompensator>, shared_ptr<ModelVoltageLevel> > p2 = createModelShuntCompensator(false, reactance, false);
  shared_ptr<ModelShuntCompensator> rea = p2.first;

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
  boost::unordered_map<std::string, ParameterModeler> parametersModels;
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
}

TEST(ModelsModelNetwork, ModelNetworkShuntCompensatorJt) {
  std::pair<shared_ptr<ModelShuntCompensator>, shared_ptr<ModelVoltageLevel> > p = createModelShuntCompensator(false, capacitance, false);
  shared_ptr<ModelShuntCompensator> capa = p.first;
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

  shared_ptr<ModelShuntCompensator> capaInit = createModelShuntCompensator(false, capacitance, true).first;
  capaInit->initSize();
  SparseMatrix smjInit;
  smjInit.init(capaInit->sizeY(), capaInit->sizeY());
  ASSERT_NO_THROW(capaInit->evalJt(smjInit, 1., 0));
  ASSERT_EQ(smjInit.nbElem(), 0);
}

}  // namespace DYN
