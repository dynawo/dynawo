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

#include <string>
#include <vector>
#include <boost/shared_ptr.hpp>
#include <boost/algorithm/string/replace.hpp>

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>
#include <powsybl/iidm/TopologyKind.hpp>

#include "make_unique.hpp"
#include "gtest_dynawo.h"
#include "DYNVariable.h"
#include "DYNSwitchInterfaceIIDM.h"
#include "DYNBusInterfaceIIDM.h"
#include "DYNModelSwitchFactory.h"
#include "DYNModelNetwork.h"
#include "DYNSparseMatrix.h"
#include "TLTimelineFactory.h"

using boost::shared_ptr;

namespace DYN {

static std::shared_ptr<ModelSwitch>
createModelSwitch(bool open, bool initModel) {
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

  powsybl::iidm::Bus& iidmBus2 = vlIIDM.getBusBreakerView().newBus()
              .setId("MyBus2")
              .add();
  iidmBus2.setV(1);
  iidmBus2.setAngle(0.);
  powsybl::iidm::Switch& swIIDM = vlIIDM.getBusBreakerView()
      .newSwitch()
      .setId("MySwitch")
      .setName("MySwitchName")
      .setFictitious(false)
      .setBus1("MyBus1")
      .setBus2("MyBus2")
      .add();
  swIIDM.setOpen(open);

  std::unique_ptr<BusInterfaceIIDM> bus1ItfIIDM = DYN::make_unique<BusInterfaceIIDM>(iidmBus);
  std::unique_ptr<BusInterfaceIIDM> bus2ItfIIDM = DYN::make_unique<BusInterfaceIIDM>(iidmBus2);
  std::unique_ptr<SwitchInterfaceIIDM> swItfIIDM = DYN::make_unique<SwitchInterfaceIIDM>(swIIDM);

  std::shared_ptr<ModelSwitch> sw = ModelSwitchFactory::newInstance(std::move(swItfIIDM));
  std::shared_ptr<ModelBus> bus1 = std::make_shared<ModelBus>(std::move(bus1ItfIIDM), false);
  sw->setModelBus1(bus1);
  std::shared_ptr<ModelBus> bus2 = std::make_shared<ModelBus>(std::move(bus2ItfIIDM), false);
  sw->setModelBus2(bus2);
  ModelNetwork* network = new ModelNetwork();
  network->setIsInitModel(initModel);
  network->setTimeline(timeline::TimelineFactory::newInstance("Test"));
  sw->setNetwork(network);
  bus1->setNetwork(network);
  bus2->setNetwork(network);
  return sw;
}

TEST(ModelsModelNetwork, ModelNetworkSwitchInitializationOpened) {
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

  powsybl::iidm::Bus& iidmBus2 = vlIIDM.getBusBreakerView().newBus()
              .setId("MyBus2")
              .add();
  iidmBus2.setV(1);
  iidmBus2.setAngle(0.);
  powsybl::iidm::Switch& swIIDM = vlIIDM.getBusBreakerView()
      .newSwitch()
      .setId("MySwitch")
      .setName("MySwitchName")
      .setFictitious(false)
      .setBus1("MyBus1")
      .setBus2("MyBus2")
      .add();
  swIIDM.setOpen(true);

  std::unique_ptr<BusInterfaceIIDM> bus1ItfIIDM = DYN::make_unique<BusInterfaceIIDM>(iidmBus);
  std::unique_ptr<BusInterfaceIIDM> bus2ItfIIDM = DYN::make_unique<BusInterfaceIIDM>(iidmBus2);
  std::unique_ptr<SwitchInterfaceIIDM> swItfIIDM = DYN::make_unique<SwitchInterfaceIIDM>(swIIDM);

  std::shared_ptr<ModelSwitch> sw = ModelSwitchFactory::newInstance(std::move(swItfIIDM));
  ASSERT_EQ(sw->isInLoop(), false);
  ASSERT_EQ(sw->getConnectionState(), OPEN);
  ASSERT_EQ(sw->irYNum(), 0);
  ASSERT_EQ(sw->iiYNum(), 0);
  ASSERT_THROW_DYNAWO(sw->getModelBus1(), Error::MODELER, KeyError_t::SwitchMissingBus1);
  std::shared_ptr<ModelBus> bus1 = std::make_shared<ModelBus>(std::move(bus1ItfIIDM), false);
  sw->setModelBus1(bus1);
  ASSERT_THROW_DYNAWO(sw->getModelBus2(), Error::MODELER, KeyError_t::SwitchMissingBus2);
  std::shared_ptr<ModelBus> bus2 = std::make_shared<ModelBus>(std::move(bus2ItfIIDM), false);
  sw->setModelBus2(bus2);
  ASSERT_EQ(sw->getModelBus1(), bus1);
  ASSERT_EQ(sw->getModelBus2(), bus2);
  ASSERT_EQ(sw->id(), "MySwitch");
}

TEST(ModelsModelNetwork, ModelNetworkSwitchInitializationClosed) {
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

  powsybl::iidm::Bus& iidmBus2 = vlIIDM.getBusBreakerView().newBus()
              .setId("MyBus2")
              .add();
  iidmBus2.setV(1);
  iidmBus2.setAngle(0.);
  powsybl::iidm::Switch& swIIDM = vlIIDM.getBusBreakerView()
      .newSwitch()
      .setId("MySwitch")
      .setName("MySwitchName")
      .setFictitious(false)
      .setBus1("MyBus1")
      .setBus2("MyBus2")
      .add();
  swIIDM.setOpen(false);

  std::unique_ptr<BusInterfaceIIDM> bus1ItfIIDM = DYN::make_unique<BusInterfaceIIDM>(iidmBus);
  std::unique_ptr<BusInterfaceIIDM> bus2ItfIIDM = DYN::make_unique<BusInterfaceIIDM>(iidmBus2);
  std::unique_ptr<SwitchInterfaceIIDM> swItfIIDM = DYN::make_unique<SwitchInterfaceIIDM>(swIIDM);

  std::shared_ptr<ModelSwitch> sw = ModelSwitchFactory::newInstance(std::move(swItfIIDM));
  ASSERT_EQ(sw->isInLoop(), false);
  ASSERT_EQ(sw->getConnectionState(), CLOSED);
  ASSERT_EQ(sw->irYNum(), 0);
  ASSERT_EQ(sw->iiYNum(), 0);
  ASSERT_THROW_DYNAWO(sw->getModelBus1(), Error::MODELER, KeyError_t::SwitchMissingBus1);
  std::shared_ptr<ModelBus> bus1 = std::make_shared<ModelBus>(std::move(bus1ItfIIDM), false);
  sw->setModelBus1(bus1);
  ASSERT_THROW_DYNAWO(sw->getModelBus2(), Error::MODELER, KeyError_t::SwitchMissingBus2);
  std::shared_ptr<ModelBus> bus2 = std::make_shared<ModelBus>(std::move(bus2ItfIIDM), false);
  sw->setModelBus2(bus2);
  ASSERT_EQ(sw->getModelBus1(), bus1);
  ASSERT_EQ(sw->getModelBus2(), bus2);
  ASSERT_EQ(sw->id(), "MySwitch");
}

TEST(ModelsModelNetwork, ModelNetworkSwitchCalculatedVariables) {
  std::shared_ptr<ModelSwitch> sw = createModelSwitch(false, false);
  sw->initSize();
  ASSERT_EQ(sw->sizeCalculatedVar(), ModelSwitch::nbCalculatedVariables_);

  std::vector<double> calculatedVars(1, 0.);
  sw->setReferenceCalculatedVar(&calculatedVars[0], 0);
  sw->evalCalculatedVars();
  ASSERT_EQ(calculatedVars[0], CLOSED);
  ASSERT_EQ(sw->evalCalculatedVarI(ModelSwitch::swStateNum_), CLOSED);

  sw->setConnectionState(OPEN);
  ASSERT_EQ(sw->evalCalculatedVarI(ModelSwitch::swStateNum_), OPEN);
  sw->evalCalculatedVars();
  ASSERT_EQ(calculatedVars[0], OPEN);

  ASSERT_THROW_DYNAWO(sw->evalCalculatedVarI(1), Error::MODELER, KeyError_t::UndefCalculatedVarI);
  std::vector<double> res;
  ASSERT_THROW_DYNAWO(sw->evalJCalculatedVarI(1, res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(sw->evalJCalculatedVarI(ModelSwitch::swStateNum_, res));
  std::vector<int> numVars;
  ASSERT_THROW_DYNAWO(sw->getIndexesOfVariablesUsedForCalculatedVarI(1, numVars), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(sw->getIndexesOfVariablesUsedForCalculatedVarI(ModelSwitch::swStateNum_, numVars));

  std::shared_ptr<ModelSwitch> swInit = createModelSwitch(false, true);
  swInit->initSize();
  ASSERT_EQ(swInit->sizeCalculatedVar(), 0);
}

TEST(ModelsModelNetwork, ModelNetworkSwitchDiscreteVariables) {
  std::shared_ptr<ModelSwitch> sw = createModelSwitch(false, false);
  bool deactivateRootFunctions = false;
  sw->initSize();
  unsigned nbZ = 1;
  unsigned nbG = 0;
  ASSERT_EQ(sw->sizeZ(), nbZ);
  ASSERT_EQ(sw->sizeG(), nbG);
  std::vector<double> y(sw->sizeY(), 0.);
  std::vector<double> yp(sw->sizeY(), 0.);
  std::vector<double> f(sw->sizeF(), 0.);
  std::vector<double> z(nbZ, 0.);
  bool* zConnected = new bool[nbZ];
  for (size_t i = 0; i < nbZ; ++i)
    zConnected[i] = true;
  sw->setReferenceZ(&z[0], zConnected, 0);
  sw->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);

  sw->getY0();
  ASSERT_EQ(z[0], CLOSED);
  sw->open();
  ASSERT_EQ(z[0], OPEN);
  sw->close();
  ASSERT_EQ(z[0], CLOSED);

  z[0] = OPEN;
  sw->evalZ(0., deactivateRootFunctions);
  ASSERT_EQ(sw->getConnectionState(), OPEN);
  ASSERT_EQ(z[0], OPEN);

  z[0] = OPEN;
  ASSERT_EQ(sw->evalState(0.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(sw->getConnectionState(), OPEN);
  ASSERT_EQ(z[0], OPEN);
  z[0] = CLOSED;
  sw->evalZ(0., deactivateRootFunctions);
  ASSERT_EQ(sw->evalState(0.), NetworkComponent::TOPO_CHANGE);
  ASSERT_EQ(sw->getConnectionState(), CLOSED);
  ASSERT_EQ(z[0], CLOSED);
  sw->evalZ(0., deactivateRootFunctions);
  ASSERT_EQ(sw->evalState(0.), NetworkComponent::NO_CHANGE);
  ASSERT_EQ(sw->getConnectionState(), CLOSED);
  ASSERT_EQ(z[0], CLOSED);

  std::shared_ptr<ModelSwitch> swInit = createModelSwitch(false, true);
  swInit->initSize();
  ASSERT_EQ(swInit->sizeZ(), 0);
  ASSERT_EQ(swInit->sizeG(), 0);

  std::map<int, std::string> gEquationIndex;
  sw->setGequations(gEquationIndex);
  ASSERT_TRUE(gEquationIndex.empty());
  ASSERT_NO_THROW(sw->evalG(0.));  // Reference G was not defined on purpose
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkSwitchBuses) {
  std::shared_ptr<ModelSwitch> sw = createModelSwitch(false, false);
  bool deactivateRootFunctions = false;
  sw->initSize();
  const unsigned nbZ = 1;
  ASSERT_EQ(sw->sizeZ(), nbZ);
  std::vector<double> y(sw->sizeY(), 0.);
  std::vector<double> yp(sw->sizeY(), 0.);
  std::vector<double> f(sw->sizeF(), 0.);
  std::vector<double> z(nbZ, 0.);
  bool* zConnected = new bool[nbZ];
  for (size_t i = 0; i < nbZ; ++i)
    zConnected[i] = true;
  sw->setReferenceZ(&z[0], zConnected, 0);
  sw->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);

  std::shared_ptr<ModelBus> bus1 = sw->getModelBus1();
  bus1->initSize();
  std::vector<double> y1(bus1->sizeY(), 0.);
  std::vector<double> yp1(bus1->sizeY(), 0.);
  std::vector<double> f1(bus1->sizeF(), 0.);
  std::vector<double> z1(bus1->sizeZ(), 0.);
  bool* zConnected1 = new bool[bus1->sizeZ()];
  for (int i = 0; i < bus1->sizeZ(); ++i)
    zConnected1[i] = true;
  std::vector<state_g> g1(bus1->sizeG(), NO_ROOT);
  bus1->setReferenceG(&g1[0], 0);
  bus1->setReferenceZ(&z1[0], zConnected1, 0);
  bus1->setReferenceY(&y1[0], &yp1[0], &f1[0], 0, 0);
  bus1->numSubNetwork(2);

  std::shared_ptr<ModelBus> bus2 = sw->getModelBus2();
  bus2->initSize();
  std::vector<double> y2(bus2->sizeY(), 0.);
  std::vector<double> yp2(bus2->sizeY(), 0.);
  std::vector<double> f2(bus2->sizeF(), 0.);
  std::vector<double> z2(bus2->sizeZ(), 0.);
  bool* zConnected2 = new bool[bus2->sizeZ()];
  for (int i = 0; i < bus2->sizeZ(); ++i)
    zConnected2[i] = true;
  std::vector<state_g> g2(bus2->sizeG(), NO_ROOT);
  bus2->setReferenceG(&g2[0], 0);
  bus2->setReferenceZ(&z2[0], zConnected2, 0);
  bus2->setReferenceY(&y2[0], &yp2[0], &f2[0], 0, 0);
  bus2->numSubNetwork(2);

  const unsigned indexConnectionStateBus = 2;
  sw->close();
  ASSERT_EQ(z[0], CLOSED);
  z1[indexConnectionStateBus] = OPEN;
  bus1->evalZ(0., deactivateRootFunctions);
  ASSERT_EQ(z[0], OPEN);  // Was opened by the bus

  sw->close();
  ASSERT_EQ(z[0], CLOSED);
  z2[indexConnectionStateBus] = OPEN;
  bus2->evalZ(0., deactivateRootFunctions);
  ASSERT_EQ(z[0], OPEN);  // Was opened by the bus
  delete[] zConnected;
  delete[] zConnected1;
  delete[] zConnected2;
}

TEST(ModelsModelNetwork, ModelNetworkSwitchContinuousVariables) {
  // init
  std::shared_ptr<ModelSwitch> sw = createModelSwitch(false, false);
  bool deactivateRootFunctions = false;
  sw->initSize();
  unsigned nbY = 2;
  unsigned nbF = 2;
  unsigned urIndex = 0;
  unsigned uiIndex = 1;
  ASSERT_EQ(sw->sizeY(), nbY);
  ASSERT_EQ(sw->sizeF(), nbF);
  std::vector<double> y(nbY, 0.);
  std::vector<double> yp(nbY, 0.);
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<double> f(nbF, 0.);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  std::vector<double> z(sw->sizeZ(), 0.);
  bool* zConnected = new bool[sw->sizeZ()];
  for (int i = 0; i < sw->sizeZ(); ++i)
    zConnected[i] = true;
  sw->setReferenceZ(&z[0], zConnected, 0);
  sw->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);
  sw->setBufferYType(&yTypes[0], 0);
  sw->setBufferFType(&fTypes[0], 0);

  std::shared_ptr<ModelBus> bus1 = sw->getModelBus1();
  bus1->initSize();
  std::vector<double> y1(bus1->sizeY(), 0.);
  std::vector<double> yp1(bus1->sizeY(), 0.);
  std::vector<double> f1(bus1->sizeF(), 0.);
  std::vector<double> z1(bus1->sizeZ(), 0.);
  bool* zConnected1 = new bool[bus1->sizeZ()];
  for (int i = 0; i < bus1->sizeZ(); ++i)
    zConnected1[i] = true;
  bus1->setReferenceZ(&z1[0], zConnected1, 0);
  bus1->setReferenceY(&y1[0], &yp1[0], &f1[0], 0, 0);

  std::shared_ptr<ModelBus> bus2 = sw->getModelBus2();
  bus2->initSize();
  std::vector<double> y2(bus2->sizeY(), 0.);
  std::vector<double> yp2(bus2->sizeY(), 0.);
  std::vector<double> f2(bus2->sizeF(), 0.);
  std::vector<double> z2(bus2->sizeZ(), 0.);
  bool* zConnected2 = new bool[bus2->sizeZ()];
  for (int i = 0; i < bus2->sizeZ(); ++i)
    zConnected2[i] = true;
  bus2->setReferenceZ(&z2[0], zConnected2, 0);
  bus2->setReferenceY(&y2[0], &yp2[0], &f2[0], 0, 0);

  // test evalYType
  sw->evalStaticYType();
  sw->evalDynamicYType();
  ASSERT_EQ(yTypes[urIndex], ALGEBRAIC);
  ASSERT_EQ(yTypes[uiIndex], ALGEBRAIC);
  sw->evalStaticFType();
  sw->evalDynamicFType();
  ASSERT_EQ(fTypes[urIndex], ALGEBRAIC_EQ);
  ASSERT_EQ(fTypes[uiIndex], ALGEBRAIC_EQ);

  // test getY0
  y[urIndex] = 2.;
  y[uiIndex] = 5.;
  sw->setInitialCurrents();
  sw->inLoop(true);
  sw->getY0();
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[urIndex], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[uiIndex], 1.);
  sw->inLoop(false);
  sw->getY0();
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[urIndex], 2.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[uiIndex], 5.);

  // test evalF
  sw->open();
  sw->evalZ(0., deactivateRootFunctions);
  sw->evalF(UNDEFINED_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[urIndex], y[urIndex]);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[uiIndex], y[uiIndex]);
  sw->close();
  sw->evalZ(0., deactivateRootFunctions);
  sw->inLoop(true);
  sw->evalF(UNDEFINED_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[urIndex], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[uiIndex], 4.);
  sw->inLoop(false);
  y1[ModelBus::urNum_] = 8.;
  y2[ModelBus::urNum_] = 3.;
  y1[ModelBus::uiNum_] = 12.;
  y2[ModelBus::uiNum_] = 10.;
  sw->evalZ(0., deactivateRootFunctions);
  sw->evalF(UNDEFINED_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[urIndex], 5.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[uiIndex], 2.);

  // test setFequations
  std::map<int, std::string> fEquationIndex;
  sw->setFequations(fEquationIndex);
  ASSERT_EQ(fEquationIndex.size(), 2);
  sw->inLoop(true);
  fEquationIndex.clear();
  sw->setFequations(fEquationIndex);
  ASSERT_EQ(fEquationIndex.size(), 2);
  sw->inLoop(false);
  sw->setConnectionState(OPEN);
  fEquationIndex.clear();
  sw->setFequations(fEquationIndex);
  ASSERT_EQ(fEquationIndex.size(), 2);
  delete[] zConnected;
  delete[] zConnected1;
  delete[] zConnected2;
}

TEST(ModelsModelNetwork, ModelNetworkSwitchContinuousVariablesInit) {
  std::shared_ptr<ModelSwitch> sw = createModelSwitch(false, true);
  sw->initSize();
  unsigned nbY = 2;
  unsigned nbF = 2;
  unsigned urIndex = 0;
  unsigned uiIndex = 1;
  ASSERT_EQ(sw->sizeY(), nbY);
  ASSERT_EQ(sw->sizeF(), nbF);
  std::vector<double> y(nbY, 0.);
  std::vector<double> yp(nbY, 0.);
  std::vector<double> f(nbF, 0.);
  std::vector<double> z(sw->sizeZ(), 0.);
  bool* zConnected = new bool[sw->sizeZ()];
  for (int i = 0; i < sw->sizeZ(); ++i)
    zConnected[i] = true;
  sw->setReferenceZ(&z[0], zConnected, 0);
  sw->setReferenceY(&y[0], &yp[0], &f[0], 0, 0);

  sw->inLoop(true);
  sw->getY0();
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[urIndex], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[uiIndex], 1.);
  sw->inLoop(false);
  sw->getY0();
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[urIndex], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[uiIndex], 0.);
  delete[] zConnected;
}

TEST(ModelsModelNetwork, ModelNetworkSwitchDefineInstantiate) {
  std::shared_ptr<ModelSwitch> sw = createModelSwitch(false, false);

  std::vector<shared_ptr<Variable> > definedVariables;
  std::vector<shared_ptr<Variable> > instantiatedVariables;
  sw->defineVariables(definedVariables);
  sw->instantiateVariables(instantiatedVariables);
  ASSERT_EQ(definedVariables.size(), instantiatedVariables.size());

  for (size_t i = 0, iEnd = definedVariables.size(); i < iEnd; ++i) {
    std::string var = instantiatedVariables[i]->getName();
    boost::replace_all(var, sw->id(), "@ID@");
    ASSERT_EQ(definedVariables[i]->getName(), var);
    ASSERT_EQ(definedVariables[i]->getType(), instantiatedVariables[i]->getType());
  }


  std::vector<ParameterModeler> parameters;
  sw->defineNonGenericParameters(parameters);
  ASSERT_TRUE(parameters.empty());
  std::unordered_map<std::string, ParameterModeler> parametersModels;
  ASSERT_NO_THROW(sw->setSubModelParameters(parametersModels));
}

TEST(ModelsModelNetwork, ModelNetworkSwitchJt) {
  std::shared_ptr<ModelSwitch> sw = createModelSwitch(false, false);
  sw->initSize();

  std::shared_ptr<ModelBus> bus1 = sw->getModelBus1();
  bus1->initSize();
  std::vector<double> y1(bus1->sizeY(), 0.);
  std::vector<double> yp1(bus1->sizeY(), 0.);
  std::vector<double> f1(bus1->sizeF(), 0.);
  std::vector<double> z1(bus1->sizeZ(), 0.);
  bool* zConnected1 = new bool[bus1->sizeZ()];
  for (int i = 0; i < bus1->sizeZ(); ++i)
    zConnected1[i] = true;
  bus1->setReferenceZ(&z1[0], zConnected1, 0);
  bus1->setReferenceY(&y1[0], &yp1[0], &f1[0], 0, 0);

  std::shared_ptr<ModelBus> bus2 = sw->getModelBus2();
  bus2->initSize();
  std::vector<double> y2(bus2->sizeY(), 0.);
  std::vector<double> yp2(bus2->sizeY(), 0.);
  std::vector<double> f2(bus2->sizeF(), 0.);
  std::vector<double> z2(bus2->sizeZ(), 0.);
  bool* zConnected2 = new bool[bus2->sizeZ()];
  for (int i = 0; i < bus2->sizeZ(); ++i)
    zConnected2[i] = true;
  bus2->setReferenceZ(&z2[0], zConnected2, 0);
  bus2->setReferenceY(&y2[0], &yp2[0], &f2[0], 0, 0);

  SparseMatrix smj;
  int size = sw->sizeY();
  smj.init(size, size);
  sw->evalJt(1., 0, smj);
  ASSERT_EQ(smj.nbElem(), 4);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[0], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[1], -1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[2], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[3], -1.);
  ASSERT_EQ(smj.Ap_[0], 0);
  ASSERT_EQ(smj.Ap_[1], 2);
  ASSERT_EQ(smj.Ap_[2], 4);

  sw->inLoop(true);
  SparseMatrix smj2;
  smj2.init(size, size);
  sw->evalJt(1., 0, smj2);
  ASSERT_EQ(smj2.nbElem(), 2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[0], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[1], 1.);
  ASSERT_EQ(smj2.Ap_[0], 0);
  ASSERT_EQ(smj2.Ap_[1], 1);
  sw->inLoop(false);

  sw->setConnectionState(OPEN);
  SparseMatrix smj3;
  smj3.init(size, size);
  sw->evalJt(1., 0, smj3);
  ASSERT_EQ(smj3.nbElem(), 2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj3.Ax_[0], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj3.Ax_[1], 1.);
  ASSERT_EQ(smj3.Ap_[0], 0);
  ASSERT_EQ(smj3.Ap_[1], 1);
  sw->setConnectionState(CLOSED);

  int offset = 3;
  sw->init(offset);
  SparseMatrix smj4;
  smj4.init(size, size);
  sw->evalJt(1., 0, smj4);
  ASSERT_EQ(smj.nbElem(), 4);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[0], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[1], -1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[2], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[3], -1.);
  ASSERT_EQ(smj.Ap_[0], 0);
  ASSERT_EQ(smj.Ap_[1], 2);
  ASSERT_EQ(smj.Ap_[2], 4);


  SparseMatrix smjPrime;
  smjPrime.init(size, size);
  sw->evalJtPrim(0, smjPrime);
  ASSERT_EQ(smjPrime.nbElem(), 0);
  delete[] zConnected1;
  delete[] zConnected2;
}

}  // namespace DYN
