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

#include <IIDM/builders/StaticVarCompensatorBuilder.h>
#include <IIDM/builders/VoltageLevelBuilder.h>
#include <IIDM/builders/BusBuilder.h>
#include <IIDM/components/StaticVarCompensator.h>
#include <IIDM/components/CurrentLimit.h>
#include <IIDM/components/VoltageLevel.h>
#include <IIDM/components/Bus.h>
#include <IIDM/extensions/StandbyAutomaton.h>

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
std::pair<shared_ptr<ModelStaticVarCompensator>, shared_ptr<ModelVoltageLevel> >  // need to return the voltage level so that it is not destroyed
createModelStaticVarCompensator(bool open, bool initModel) {
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



  IIDM::builders::StaticVarCompensatorBuilder svcb;
  svcb.p(3);
  svcb.q(5);
  svcb.regulationMode(IIDM::StaticVarCompensator::regulation_reactive_power);
  svcb.voltageSetPoint(0.5);
  svcb.reactivePowerSetPoint(0.8);
  svcb.bmin(0.);
  svcb.bmax(5.);
  IIDM::StaticVarCompensator scIIDM = svcb.build("MyStaticVarCompensator");
  IIDM::extensions::standbyautomaton::StandbyAutomatonBuilder sbb;
  scIIDM.setExtension(sbb.build().standBy(false).highVoltageSetPoint(5.0).lowVoltageSetPoint(0.0).highVoltageThreshold(10).lowVoltageThreshold(30).b0(0.));
  vlIIDM.add(scIIDM, c1);
  IIDM::StaticVarCompensator scIIDM2 = vlIIDM.get_staticVarCompensator("MyStaticVarCompensator");  // was copied...
  shared_ptr<StaticVarCompensatorInterfaceIIDM> scItfIIDM = shared_ptr<StaticVarCompensatorInterfaceIIDM>(new StaticVarCompensatorInterfaceIIDM(scIIDM2));
  shared_ptr<VoltageLevelInterfaceIIDM> vlItfIIDM = shared_ptr<VoltageLevelInterfaceIIDM>(new VoltageLevelInterfaceIIDM(vlIIDM));
  shared_ptr<BusInterfaceIIDM> bus1ItfIIDM = shared_ptr<BusInterfaceIIDM>(new BusInterfaceIIDM(vlIIDM.get_bus("MyBus1")));
  scItfIIDM->setVoltageLevelInterface(vlItfIIDM);
  scItfIIDM->setBusInterface(bus1ItfIIDM);

  shared_ptr<ModelStaticVarCompensator> sc = shared_ptr<ModelStaticVarCompensator>(new ModelStaticVarCompensator(scItfIIDM));
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
  z1[ModelBus::switchOffNum_] = -1;
  int offset = 0;
  bus1->init(offset);
  return std::make_pair(sc, vl);
}


TEST(ModelsModelNetwork, ModelNetworkStaticVarCompensatorInitialization) {
  shared_ptr<ModelStaticVarCompensator> svc = createModelStaticVarCompensator(false, false).first;
  ASSERT_EQ(svc->id(), "MyStaticVarCompensator");
  ASSERT_TRUE(svc->isConnected());
  ASSERT_EQ(svc->getConnected(), CLOSED);
}

TEST(ModelsModelNetwork, ModelNetworkStaticVarCompensatorCalculatedVariables) {
  shared_ptr<ModelStaticVarCompensator> svc = createModelStaticVarCompensator(false, false).first;
  svc->initSize();
  std::vector<double> y(svc->sizeY(), 0.);
  std::vector<double> yp(svc->sizeY(), 0.);
  std::vector<double> f(svc->sizeF(), 0.);
  std::vector<double> z(svc->sizeZ(), 0.);
  bool* zConnected = new bool[svc->sizeZ()];
  for (size_t i = 0; i < svc->sizeZ(); ++i)
    zConnected[i] = true;
  svc->setReferenceZ(&z[0], zConnected, 0);
  svc->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  svc->evalYMat();
  ASSERT_EQ(svc->sizeCalculatedVar(), ModelStaticVarCompensator::nbCalculatedVariables_);

  y[ModelStaticVarCompensator::bSvcNum_] = 2;
  std::vector<double> calculatedVars(ModelStaticVarCompensator::nbCalculatedVariables_, 0.);
  svc->setReferenceCalculatedVar(&calculatedVars[0], 0);
  svc->evalCalculatedVars();
  ASSERT_DOUBLE_EQUALS_DYNAWO(calculatedVars[ModelStaticVarCompensator::qNum_], 32.50);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelStaticVarCompensator::qNum_), calculatedVars[ModelStaticVarCompensator::qNum_]);
  svc->setConnected(OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(svc->evalCalculatedVarI(ModelStaticVarCompensator::qNum_), 0.);
  svc->setConnected(CLOSED);
  ASSERT_THROW_DYNAWO(svc->evalCalculatedVarI(42), Error::MODELER, KeyError_t::UndefCalculatedVarI);


  std::vector<double> res(3, 0.);
  ASSERT_THROW_DYNAWO(svc->evalJCalculatedVarI(42, res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(svc->evalJCalculatedVarI(ModelStaticVarCompensator::qNum_, res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 14.00);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 8.00);
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
  ASSERT_EQ(numVars.size(), 3);
  ASSERT_EQ(numVars[0], 0);
  ASSERT_EQ(numVars[1], 1);
  ASSERT_EQ(numVars[2], 4);
  numVars.clear();
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkStaticVarCompensatorDiscreteVariables) {
  std::pair<shared_ptr<ModelStaticVarCompensator>, shared_ptr<ModelVoltageLevel> > p = createModelStaticVarCompensator(false, false);
  shared_ptr<ModelStaticVarCompensator> svc = p.first;
  svc->initSize();
  unsigned nbZ = 2;
  unsigned nbG = 8;
  ASSERT_EQ(svc->sizeZ(), nbZ);
  ASSERT_EQ(svc->sizeG(), nbG);
  std::vector<double> y(svc->sizeY(), 0.);
  std::vector<double> yp(svc->sizeY(), 0.);
  std::vector<double> f(svc->sizeF(), 0.);
  std::vector<double> z(nbZ, 0.);
  std::vector<state_g> g(nbG, NO_ROOT);
  svc->setReferenceG(&g[0], 0);
  bool* zConnected = new bool[svc->sizeZ()];
  for (size_t i = 0; i < svc->sizeZ(); ++i)
    zConnected[i] = true;
  svc->setReferenceZ(&z[0], zConnected, 0);
  svc->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);

  svc->getY0();
  ASSERT_EQ(svc->getConnected(), CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelStaticVarCompensator::modeNum_], StaticVarCompensatorInterface::RUNNING_Q);
  ASSERT_EQ(z[ModelStaticVarCompensator::connectionStateNum_], svc->getConnected());

  z[ModelStaticVarCompensator::connectionStateNum_] = OPEN;
  ASSERT_EQ(svc->evalZ(10.), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(svc->evalState(10.), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(svc->getConnected(), OPEN);
  ASSERT_EQ(z[ModelStaticVarCompensator::connectionStateNum_], OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelStaticVarCompensator::modeNum_], StaticVarCompensatorInterface::RUNNING_Q);

  g[7] =  ROOT_UP;
  z[ModelStaticVarCompensator::connectionStateNum_] = CLOSED;
  ASSERT_EQ(svc->evalZ(10.), NetworkComponent::STATE_CHANGE);
  ASSERT_EQ(svc->evalState(10.), NetworkComponent::STATE_CHANGE);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelStaticVarCompensator::modeNum_], StaticVarCompensatorInterface::RUNNING_V);

  g[7] =  ROOT_DOWN;
  g[6] =  ROOT_UP;
  ASSERT_EQ(svc->evalZ(10.), NetworkComponent::NO_CHANGE);
  ASSERT_EQ(svc->evalState(10.), NetworkComponent::NO_CHANGE);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[ModelStaticVarCompensator::modeNum_], StaticVarCompensatorInterface::RUNNING_V);

  std::map<int, std::string> gEquationIndex;
  svc->setGequations(gEquationIndex);
  ASSERT_EQ(gEquationIndex.size(), nbG);
  for (size_t i = 0; i < nbG; ++i) {
    ASSERT_TRUE(gEquationIndex.find(i) != gEquationIndex.end());
  }
  g[6] =  ROOT_DOWN;
  y[ModelStaticVarCompensator::piOutNum_] = 2;
  z[ModelStaticVarCompensator::modeNum_] = StaticVarCompensatorInterface::OFF;
  ASSERT_NO_THROW(svc->evalZ(20.));
  ASSERT_NO_THROW(svc->evalG(20.));
  ASSERT_EQ(g[0], ROOT_DOWN);
  ASSERT_EQ(g[1], ROOT_UP);
  ASSERT_EQ(g[2], ROOT_DOWN);
  ASSERT_EQ(g[3], ROOT_UP);
  ASSERT_EQ(g[4], ROOT_UP);
  ASSERT_EQ(g[5], ROOT_DOWN);
  ASSERT_EQ(g[6], ROOT_DOWN);
  ASSERT_EQ(g[7], ROOT_DOWN);
  z[ModelStaticVarCompensator::modeNum_] = StaticVarCompensatorInterface::RUNNING_V;
  y[ModelStaticVarCompensator::piOutNum_] = -1;
  ASSERT_NO_THROW(svc->evalZ(20.));
  ASSERT_NO_THROW(svc->evalG(20.));
  ASSERT_EQ(g[0], ROOT_UP);
  ASSERT_EQ(g[1], ROOT_DOWN);
  ASSERT_EQ(g[2], ROOT_UP);
  ASSERT_EQ(g[3], ROOT_DOWN);
  ASSERT_EQ(g[4], ROOT_DOWN);
  ASSERT_EQ(g[5], ROOT_UP);
  ASSERT_EQ(g[6], ROOT_DOWN);
  ASSERT_EQ(g[7], ROOT_DOWN);
  y[ModelStaticVarCompensator::piOutNum_] = 6;
  ASSERT_NO_THROW(svc->evalZ(20.));
  ASSERT_NO_THROW(svc->evalG(20.));
  ASSERT_EQ(g[0], ROOT_DOWN);
  ASSERT_EQ(g[1], ROOT_DOWN);
  ASSERT_EQ(g[2], ROOT_DOWN);
  ASSERT_EQ(g[3], ROOT_UP);
  ASSERT_EQ(g[4], ROOT_UP);
  ASSERT_EQ(g[5], ROOT_DOWN);
  ASSERT_EQ(g[6], ROOT_DOWN);
  ASSERT_EQ(g[7], ROOT_DOWN);
  z[ModelStaticVarCompensator::modeNum_] = StaticVarCompensatorInterface::STANDBY;
  ASSERT_NO_THROW(svc->evalZ(20.));
  ASSERT_NO_THROW(svc->evalG(20.));
  ASSERT_EQ(g[0], ROOT_DOWN);
  ASSERT_EQ(g[1], ROOT_DOWN);
  ASSERT_EQ(g[2], ROOT_DOWN);
  ASSERT_EQ(g[3], ROOT_UP);
  ASSERT_EQ(g[4], ROOT_UP);
  ASSERT_EQ(g[5], ROOT_DOWN);
  ASSERT_EQ(g[6], ROOT_UP);
  ASSERT_EQ(g[7], ROOT_UP);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkStaticVarCompensatorContinuousVariables) {
  std::pair<shared_ptr<ModelStaticVarCompensator>, shared_ptr<ModelVoltageLevel> > p = createModelStaticVarCompensator(false, false);
  shared_ptr<ModelStaticVarCompensator> svc = p.first;
  svc->initSize();
  unsigned nbY = 4;
  unsigned nbF = 4;
  std::vector<double> y(nbY, 0.);
  y[0] = 1.;
  y[1] = 2.;
  y[2] = 3.;
  y[3] = 4.;
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
  for (size_t i = 0; i < svc->sizeZ(); ++i)
    zConnected[i] = true;
  svc->setReferenceZ(&z[0], zConnected, 0);
  svc->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  ASSERT_EQ(svc->sizeY(), nbY);
  ASSERT_EQ(svc->sizeF(), nbF);

  // test evalYType
  ASSERT_NO_THROW(svc->evalYType());
  ASSERT_EQ(yTypes[ModelStaticVarCompensator::piInNum_], ALGEBRAIC);
  ASSERT_EQ(yTypes[ModelStaticVarCompensator::piOutNum_], ALGEBRAIC);
  ASSERT_EQ(yTypes[ModelStaticVarCompensator::bSvcNum_], ALGEBRAIC);
  ASSERT_EQ(yTypes[ModelStaticVarCompensator::feedBackNum_], DIFFERENTIAL);
  ASSERT_NO_THROW(svc->evalFType());
  ASSERT_EQ(fTypes[ModelStaticVarCompensator::piInNum_], ALGEBRAIC_EQ);
  ASSERT_EQ(fTypes[ModelStaticVarCompensator::piOutNum_], ALGEBRAIC_EQ);
  ASSERT_EQ(fTypes[ModelStaticVarCompensator::bSvcNum_], ALGEBRAIC_EQ);
  ASSERT_EQ(fTypes[ModelStaticVarCompensator::feedBackNum_], DIFFERENTIAL_EQ);

  // test evalF
  ASSERT_NO_THROW(svc->evalF(UNDEFINED_EQ));
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[ModelStaticVarCompensator::piInNum_], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[ModelStaticVarCompensator::piOutNum_], -3.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[ModelStaticVarCompensator::bSvcNum_], 1.75);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[ModelStaticVarCompensator::feedBackNum_], 1.);

  // test setFequations
  std::map<int, std::string> fEquationIndex;
  svc->setFequations(fEquationIndex);
  ASSERT_EQ(fEquationIndex.size(), nbF);
  ASSERT_NO_THROW(svc->evalDerivatives(0.));
  ASSERT_NO_THROW(svc->evalDerivativesPrim());
  ASSERT_NO_THROW(svc->addBusNeighbors());
  ASSERT_NO_THROW(svc->updateYType());
  ASSERT_NO_THROW(svc->updateFType());
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkStaticVarCompensatorDefineInstantiate) {
  std::pair<shared_ptr<ModelStaticVarCompensator>, shared_ptr<ModelVoltageLevel> > p = createModelStaticVarCompensator(false, false);
  shared_ptr<ModelStaticVarCompensator> svc = p.first;

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
  boost::unordered_map<std::string, ParameterModeler> parametersModels;
  ASSERT_NO_THROW(svc->setSubModelParameters(parametersModels));
}

TEST(ModelsModelNetwork, ModelNetworkStaticVarCompensatorJt) {
  std::pair<shared_ptr<ModelStaticVarCompensator>, shared_ptr<ModelVoltageLevel> > p = createModelStaticVarCompensator(false, false);
  shared_ptr<ModelStaticVarCompensator> svc = p.first;
  svc->initSize();
  std::vector<double> y(svc->sizeY(), 0.);
  y[0] = 1.;
  y[1] = 2.;
  y[2] = 3.;
  y[3] = 4.;
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
  for (size_t i = 0; i < svc->sizeZ(); ++i)
    zConnected[i] = true;
  svc->setReferenceZ(&z[0], zConnected, 0);
  svc->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  svc->evalYMat();
  SparseMatrix smj;
  int size = svc->sizeY();
  smj.init(size, size);
  svc->evalJt(smj, 1., 0);
  ASSERT_EQ(smj.nbElem(), 7);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[0], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[1], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[2], -1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[3], -1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[4], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[5], 1.005);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[6], -1.);
  ASSERT_EQ(smj.Ap_[0], 0);
  ASSERT_EQ(smj.Ap_[1], 1);
  ASSERT_EQ(smj.Ap_[2], 4);
  ASSERT_EQ(smj.Ap_[3], 5);
  ASSERT_EQ(smj.Ap_[4], 7);
  g[0] =  ROOT_UP;
  z[ModelStaticVarCompensator::connectionStateNum_] = CLOSED;
  svc->evalZ(10.);  // isRunning = true
  SparseMatrix smj2;
  smj2.init(size, size);
  svc->evalJt(smj2, 1., 0);
  ASSERT_EQ(smj2.nbElem(), 10);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[0], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[1], 4.3129725684978375);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[2], 2.4645557534273355);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[3], 0.65);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[4], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[5], -1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[6], -1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[7], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[8], 1.005);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[9], -1.);
  ASSERT_EQ(smj2.Ap_[0], 0);
  ASSERT_EQ(smj2.Ap_[1], 4);
  ASSERT_EQ(smj2.Ap_[2], 7);
  ASSERT_EQ(smj2.Ap_[3], 8);
  ASSERT_EQ(smj2.Ap_[4], 10);

  SparseMatrix smjPrime;
  smjPrime.init(size, size);
  svc->evalJtPrim(smjPrime, 0);
  ASSERT_EQ(smjPrime.nbElem(), 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smjPrime.Ax_[0], 0.005);
  ASSERT_EQ(smjPrime.Ap_[0], 0);
  ASSERT_EQ(smjPrime.Ap_[1], 0);
  delete[] zConnected;
}

}  // namespace DYN
