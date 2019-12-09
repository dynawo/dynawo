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

#include <IIDM/builders/DanglingLineBuilder.h>
#include <IIDM/builders/VoltageLevelBuilder.h>
#include <IIDM/builders/BusBuilder.h>
#include <IIDM/components/DanglingLine.h>
#include <IIDM/components/CurrentLimit.h>
#include <IIDM/components/VoltageLevel.h>
#include <IIDM/components/Bus.h>

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

#include "gtest_dynawo.h"

using boost::shared_ptr;

namespace DYN {
std::pair<shared_ptr<ModelDanglingLine>, shared_ptr<ModelVoltageLevel> >  // need to return the voltage level so that it is not destroyed
createModelDanglingLine(bool open, bool initModel) {
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


  IIDM::builders::DanglingLineBuilder dlb;
  dlb.r(3.);
  dlb.x(3.);
  dlb.g(3.);
  dlb.b(3.);
  dlb.p0(105.);
  dlb.p(105.);
  dlb.q0(90.);
  dlb.q(90.);
  IIDM::CurrentLimits limits(200.);
  limits.add("MyLimit", 10., 5.);
  limits.add("MyLimit2", 15., 10.);
  limits.add("DeactivatedLimit", std::numeric_limits<double>::quiet_NaN(), std::numeric_limits<double>::quiet_NaN());
  dlb.currentLimits(limits);
  IIDM::DanglingLine dlIIDM = dlb.build("MyDanglingLine");
  vlIIDM.add(dlIIDM, c1);
  IIDM::DanglingLine dlIIDM2 = vlIIDM.get_danglingLine("MyDanglingLine");  // was copied...
  shared_ptr<DanglingLineInterfaceIIDM> dlItfIIDM = shared_ptr<DanglingLineInterfaceIIDM>(new DanglingLineInterfaceIIDM(dlIIDM2));
  shared_ptr<VoltageLevelInterfaceIIDM> vlItfIIDM = shared_ptr<VoltageLevelInterfaceIIDM>(new VoltageLevelInterfaceIIDM(vlIIDM));
  shared_ptr<BusInterfaceIIDM> bus1ItfIIDM = shared_ptr<BusInterfaceIIDM>(new BusInterfaceIIDM(vlIIDM.get_bus("MyBus1")));
  dlItfIIDM->setVoltageLevelInterface(vlItfIIDM);
  dlItfIIDM->setBusInterface(bus1ItfIIDM);
  IIDM::CurrentLimits currentLimits = dlIIDM2.currentLimits();
  for (IIDM::CurrentLimits::const_iterator it = currentLimits.begin(); it != currentLimits.end(); ++it) {
    shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(it->value, it->acceptableDuration));
    dlItfIIDM->addCurrentLimitInterface(cLimit);
  }

  shared_ptr<ModelDanglingLine> dl = shared_ptr<ModelDanglingLine>(new ModelDanglingLine(dlItfIIDM));
  ModelNetwork* network = new ModelNetwork();
  network->setIsInitModel(initModel);
  network->setTimeline(timeline::TimelineFactory::newInstance("Test"));
  dl->setNetwork(network);
  shared_ptr<ModelVoltageLevel> vl = shared_ptr<ModelVoltageLevel>(new ModelVoltageLevel(vlItfIIDM));
  shared_ptr<ModelBus> bus1 = shared_ptr<ModelBus>(new ModelBus(bus1ItfIIDM));
  bus1->setNetwork(network);
  bus1->setVoltageLevel(vl);
  dl->setModelBus(bus1);
  bus1->initSize();
  // There is a memory leak here, but whatever ...
  double* y1 = new double[bus1->sizeY()];
  double* yp1 = new double[bus1->sizeY()];
  double* f1 = new double[bus1->sizeF()];
  double* z1 = new double[bus1->sizeZ()];
  bus1->setReferenceZ(&z1[0], 0);
  bus1->setReferenceY(y1, yp1, f1, 0, 0);
  y1[ModelBus::urNum_] = 3.5;
  y1[ModelBus::uiNum_] = 2;
  z1[ModelBus::switchOffNum_] = -1;
  int offset = 0;
  bus1->init(offset);
  return std::make_pair(dl, vl);
}


TEST(ModelsModelNetwork, ModelNetworkDanglingLineInitializationClosed) {
  shared_ptr<ModelDanglingLine> dl = createModelDanglingLine(false, false).first;
  ASSERT_EQ(dl->id(), "MyDanglingLine");
  ASSERT_EQ(dl->getConnectionState(), CLOSED);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getCurrentLimitsDesactivate(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getP(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getQ(), 0.);
}

TEST(ModelsModelNetwork, ModelNetworkDanglingLineInitializationOpened) {
  shared_ptr<ModelDanglingLine> dl = createModelDanglingLine(true, false).first;
  ASSERT_EQ(dl->id(), "MyDanglingLine");
  ASSERT_EQ(dl->getConnectionState(), OPEN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getCurrentLimitsDesactivate(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getP(), 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->getQ(), 0.);
}

TEST(ModelsModelNetwork, ModelNetworkDanglingLineCalculatedVariables) {
  shared_ptr<ModelDanglingLine> dl = createModelDanglingLine(false, false).first;
  dl->initSize();
  std::vector<double> y(dl->sizeY(), 0.);
  std::vector<double> yp(dl->sizeY(), 0.);
  std::vector<double> f(dl->sizeF(), 0.);
  std::vector<double> z(dl->sizeZ(), 0.);
  dl->setReferenceZ(&z[0], 0);
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
  std::vector<double> yI(4, 0.);
  yI[0] = 3.5;
  yI[1] = 2;
  yI[2] = 4.;
  yI[3] = 1.5;
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelDanglingLine::iNum_, &yI[0], &yp[0]), calculatedVars[ModelDanglingLine::iNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelDanglingLine::pNum_, &yI[0], &yp[0]), calculatedVars[ModelDanglingLine::pNum_]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(dl->evalCalculatedVarI(ModelDanglingLine::qNum_, &yI[0], &yp[0]), calculatedVars[ModelDanglingLine::qNum_]);
  ASSERT_THROW_DYNAWO(dl->evalCalculatedVarI(42, &yI[0], &yp[0]), Error::MODELER, KeyError_t::UndefCalculatedVarI);

  std::vector<double> res(4, 0.);
  ASSERT_THROW_DYNAWO(dl->evalJCalculatedVarI(42, &yI[0], &yp[0], res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelDanglingLine::iNum_, &yI[0], &yp[0], res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 0.89020606654237955);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 0.57965971165276509);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], 0.029365134594484289);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -0.051087288952047991);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelDanglingLine::pNum_, &yI[0], &yp[0], res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], 5.3124999999999991);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], 3.270833333333333);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], -0.062499999999999972);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], -0.22916666666666669);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelDanglingLine::qNum_, &yI[0], &yp[0], res));
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[0], -5.0625000000000009);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[1], -3.0625);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[2], -0.22916666666666669);
  ASSERT_DOUBLE_EQUALS_DYNAWO(res[3], 0.062499999999999972);
  dl->setConnectionState(OPEN);
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelDanglingLine::iNum_, &yI[0], &yp[0], res));
  for (size_t i = 0; i < res.size(); ++i) {
    ASSERT_DOUBLE_EQUALS_DYNAWO(res[i], 0.);
  }
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelDanglingLine::pNum_, &yI[0], &yp[0], res));
  for (size_t i = 0; i < res.size(); ++i) {
    ASSERT_DOUBLE_EQUALS_DYNAWO(res[i], 0.);
  }
  ASSERT_NO_THROW(dl->evalJCalculatedVarI(ModelDanglingLine::qNum_, &yI[0], &yp[0], res));
  for (size_t i = 0; i < res.size(); ++i) {
    ASSERT_DOUBLE_EQUALS_DYNAWO(res[i], 0.);
  }

  int offset = 2;
  dl->init(offset);
  std::vector<int> numVars;
  ASSERT_THROW_DYNAWO(dl->getDefJCalculatedVarI(42, numVars), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(dl->getDefJCalculatedVarI(ModelDanglingLine::iNum_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getDefJCalculatedVarI(ModelDanglingLine::pNum_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();
  ASSERT_NO_THROW(dl->getDefJCalculatedVarI(ModelDanglingLine::qNum_, numVars));
  ASSERT_EQ(numVars.size(), 4);
  for (size_t i = 0; i < numVars.size(); ++i) {
    ASSERT_EQ(numVars[i], i);
  }
  numVars.clear();

  shared_ptr<ModelDanglingLine> dlInit = createModelDanglingLine(false, true).first;
  dlInit->initSize();
  ASSERT_EQ(dlInit->sizeCalculatedVar(), 0);
}

TEST(ModelsModelNetwork, ModelNetworkDanglingLineDiscreteVariables) {
  std::pair<shared_ptr<ModelDanglingLine>, shared_ptr<ModelVoltageLevel> > p = createModelDanglingLine(false, false);
  shared_ptr<ModelDanglingLine> dl = p.first;
  dl->initSize();
  unsigned nbZ = 2;
  unsigned nbG = 9;
  ASSERT_EQ(dl->sizeZ(), nbZ);
  ASSERT_EQ(dl->sizeG(), nbG);
  std::vector<double> y(dl->sizeY(), 0.);
  std::vector<double> yp(dl->sizeY(), 0.);
  std::vector<double> f(dl->sizeF(), 0.);
  std::vector<double> z(nbZ, 0.);
  std::vector<state_g> g(nbG, NO_ROOT);
  dl->setReferenceG(&g[0], 0);
  dl->setReferenceZ(&z[0], 0);
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
  for (size_t i = 0; i < nbG; ++i) {
    ASSERT_TRUE(gEquationIndex.find(i) != gEquationIndex.end());
  }
  ASSERT_NO_THROW(dl->evalG(0.));
  ASSERT_DOUBLE_EQUALS_DYNAWO(g[0], ROOT_DOWN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(g[1], ROOT_DOWN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(g[2], ROOT_DOWN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(g[3], ROOT_DOWN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(g[4], ROOT_DOWN);
  ASSERT_DOUBLE_EQUALS_DYNAWO(g[5], ROOT_DOWN);

  shared_ptr<ModelDanglingLine> dlInit = createModelDanglingLine(false, true).first;
  dlInit->initSize();
  ASSERT_EQ(dlInit->sizeZ(), 0);
  ASSERT_EQ(dlInit->sizeG(), 0);
}

TEST(ModelsModelNetwork, ModelNetworkDanglingLineContinuousVariables) {
  std::pair<shared_ptr<ModelDanglingLine>, shared_ptr<ModelVoltageLevel> > p = createModelDanglingLine(false, false);
  shared_ptr<ModelDanglingLine> dl = p.first;
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
  dl->setReferenceZ(&z[0], 0);
  dl->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  dl->evalYMat();
  y[ModelDanglingLine::urFictNum_] = 4.;
  y[ModelDanglingLine::uiFictNum_] = 1.5;
  dl->setBufferYType(&yTypes[0], 0);
  dl->setBufferFType(&fTypes[0], 0);

  // test evalYType
  dl->evalYType();
  ASSERT_EQ(yTypes[urIndex], ALGEBRIC);
  ASSERT_EQ(yTypes[uiIndex], ALGEBRIC);
  dl->evalFType();
  ASSERT_EQ(fTypes[urIndex], ALGEBRIC_EQ);
  ASSERT_EQ(fTypes[uiIndex], ALGEBRIC_EQ);

  // test getY0
  y[urIndex] = 2.;
  y[uiIndex] = 5.;
  dl->getY0();
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[urIndex], -116.8);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[uiIndex], -5.3999999999999844);

  // test evalF
  dl->evalF();
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[urIndex], -5.3301593716322637);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[uiIndex], 4.7114409765398335);

  // test setFequations
  std::map<int, std::string> fEquationIndex;
  dl->setFequations(fEquationIndex);
  ASSERT_EQ(fEquationIndex.size(), 2);
  for (size_t i = 0; i < nbF; ++i) {
    ASSERT_TRUE(fEquationIndex.find(i) != fEquationIndex.end());
  }

  // test getY0 (bus switchoff)
  dl->getModelBus()->switchOff();
  dl->getY0();
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[urIndex], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[uiIndex], 0.);

  // test evalF (bus switchoff)
  dl->evalF();
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[urIndex], y[urIndex]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[uiIndex], y[uiIndex]);

  // test setFequations
  fEquationIndex.clear();
  dl->setFequations(fEquationIndex);
  ASSERT_EQ(fEquationIndex.size(), 2);
  for (size_t i = 0; i < nbF; ++i) {
    ASSERT_TRUE(fEquationIndex.find(i) != fEquationIndex.end());
  }

  shared_ptr<ModelDanglingLine> dlInit = createModelDanglingLine(false, true).first;
  dlInit->initSize();
  ASSERT_EQ(dlInit->sizeY(), 0);
  ASSERT_EQ(dlInit->sizeF(), 0);
  ASSERT_NO_THROW(dlInit->getY0());
  ASSERT_NO_THROW(dlInit->evalF());
  fEquationIndex.clear();
  ASSERT_NO_THROW(dlInit->setFequations(fEquationIndex));
}

TEST(ModelsModelNetwork, ModelNetworkDanglingLineDefineInstantiate) {
  std::pair<shared_ptr<ModelDanglingLine>, shared_ptr<ModelVoltageLevel> > p = createModelDanglingLine(false, false);
  shared_ptr<ModelDanglingLine> dl = p.first;

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
  boost::unordered_map<std::string, ParameterModeler> parametersModels;
  const std::string paramName = "dangling_line_currentLimit_maxTimeOperation";
  ParameterModeler param = ParameterModeler(paramName, VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER);
  param.setValue<double>(10., PAR);
  parametersModels.insert(std::make_pair(paramName, param));
  ASSERT_NO_THROW(dl->setSubModelParameters(parametersModels));
}

TEST(ModelsModelNetwork, ModelNetworkDanglingLineJt) {
  std::pair<shared_ptr<ModelDanglingLine>, shared_ptr<ModelVoltageLevel> > p = createModelDanglingLine(false, false);
  shared_ptr<ModelDanglingLine> dl = p.first;
  dl->initSize();
  std::vector<double> y(dl->sizeY(), 0.);
  std::vector<double> yp(dl->sizeY(), 0.);
  std::vector<double> f(dl->sizeF(), 0.);
  std::vector<double> z(dl->sizeZ(), 0.);
  dl->setReferenceZ(&z[0], 0);
  dl->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  dl->evalYMat();
  y[ModelDanglingLine::urFictNum_] = 4.;
  y[ModelDanglingLine::uiFictNum_] = 1.5;
  SparseMatrix smj;
  int size = dl->sizeF();
  smj.init(size, size);
  dl->evalJt(smj, 1., 0);
  ASSERT_EQ(smj.nbElem(), 8);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[0], -0.041666666666666664);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[1], -0.041666666666666671);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[2], -0.034107399762306888);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[3],  0.040991117783198847);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[4],  0.041666666666666671);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[5], -0.041666666666666664);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[6], -0.042342215550134496);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[7],  0.11744073309564021);
  ASSERT_EQ(smj.Ap_[0], 0);
  ASSERT_EQ(smj.Ap_[1], 4);
  ASSERT_EQ(smj.Ap_[2], 8);

  dl->getModelBus()->switchOff();
  SparseMatrix smj2;
  smj2.init(size, size);
  dl->evalJt(smj2, 1., 0);
  ASSERT_EQ(smj2.nbElem(), 2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[0], 1.0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[1], 1.0);
  ASSERT_EQ(smj2.Ap_[0], 0);
  ASSERT_EQ(smj2.Ap_[1], 1);

  SparseMatrix smjPrime;
  smjPrime.init(size, size);
  dl->evalJtPrim(smjPrime, 0);
  ASSERT_EQ(smjPrime.nbElem(), 0);

  shared_ptr<ModelDanglingLine> dlInit = createModelDanglingLine(false, true).first;
  dlInit->initSize();
  SparseMatrix smjInit;
  smjInit.init(dlInit->sizeY(), dlInit->sizeY());
  ASSERT_NO_THROW(dlInit->evalJt(smjInit, 1., 0));
  ASSERT_EQ(smjInit.nbElem(), 0);
}


}  // namespace DYN
