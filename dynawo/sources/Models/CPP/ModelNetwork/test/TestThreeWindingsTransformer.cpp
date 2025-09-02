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

#include <boost/algorithm/string/replace.hpp>

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Substation.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>
#include <powsybl/iidm/TopologyKind.hpp>
#include <powsybl/iidm/ThreeWindingsTransformerAdder.hpp>

#include "DYNThreeWTransformerInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNBusInterfaceIIDM.h"
#include "DYNModelThreeWindingsTransformer.h"
#include "DYNModelVoltageLevel.h"
#include "DYNModelBus.h"
#include "DYNModelNetwork.h"
#include "TLTimelineFactory.h"
#include "DYNSparseMatrix.h"
#include "DYNVariable.h"

#include "make_unique.hpp"
#include "gtest_dynawo.h"


using boost::shared_ptr;

namespace DYN {
static std::pair<std::shared_ptr<ModelThreeWindingsTransformer>,
std::shared_ptr<ModelVoltageLevel> >  // need to return the voltage level so that it is not destroyed
createModelThreeWindingsTransformer(bool open, bool initModel) {
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

  powsybl::iidm::Bus& iidmBus3 = vlIIDM.getBusBreakerView().newBus()
              .setId("MyBus3")
              .add();
  iidmBus3.setV(1);
  iidmBus.setAngle(0.);

  powsybl::iidm::ThreeWindingsTransformer& transformer = s.newThreeWindingsTransformer()
      .setId("MyThreeWindingsTransformer")
      .setName("MyThreeWindingsTransformer_NAME")
      .newLeg1()
      .setR(1.3)
      .setX(1.4)
      .setG(1.6)
      .setB(1.7)
      .setRatedU(1.1)
      .setRatedS(2.2)
      .setVoltageLevel(vlIIDM.getId())
      .setBus(iidmBus.getId())
      .setConnectableBus(iidmBus.getId())
      .add()
      .newLeg2()
      .setR(2.3)
      .setX(2.4)
      .setG(0.0)
      .setB(0.0)
      .setRatedU(2.1)
      .setVoltageLevel(vlIIDM.getId())
      .setBus(iidmBus2.getId())
      .setConnectableBus(iidmBus2.getId())
      .add()
      .newLeg3()
      .setR(3.3)
      .setX(3.4)
      .setG(0.0)
      .setB(0.0)
      .setRatedU(3.1)
      .setVoltageLevel(vlIIDM.getId())
      .setBus(iidmBus3.getId())
      .setConnectableBus(iidmBus3.getId())
      .add()
      .add();
  if (open) {
    transformer.getLeg1().getTerminal().disconnect();
    transformer.getLeg2().getTerminal().disconnect();
    transformer.getLeg3().getTerminal().disconnect();
  }
  std::unique_ptr<ThreeWTransformerInterfaceIIDM> tw3ItfIIDM = DYN::make_unique<ThreeWTransformerInterfaceIIDM>(transformer);
  std::shared_ptr<VoltageLevelInterfaceIIDM> vlItfIIDM = std::make_shared<VoltageLevelInterfaceIIDM>(vlIIDM);
  std::shared_ptr<BusInterfaceIIDM> bus1ItfIIDM = std::make_shared<BusInterfaceIIDM>(iidmBus);
  std::shared_ptr<BusInterfaceIIDM> bus2ItfIIDM = std::make_shared<BusInterfaceIIDM>(iidmBus2);
  std::shared_ptr<BusInterfaceIIDM> bus3ItfIIDM = std::make_shared<BusInterfaceIIDM>(iidmBus3);
  tw3ItfIIDM->setVoltageLevelInterface1(vlItfIIDM);
  tw3ItfIIDM->setBusInterface1(bus1ItfIIDM);
  tw3ItfIIDM->setBusInterface2(bus2ItfIIDM);
  tw3ItfIIDM->setBusInterface2(bus3ItfIIDM);

  std::shared_ptr<ModelThreeWindingsTransformer> t3w = std::make_shared<ModelThreeWindingsTransformer>(std::move(tw3ItfIIDM));
  ModelNetwork* network = new ModelNetwork();
  network->setIsInitModel(initModel);
  t3w->setNetwork(network);
  std::shared_ptr<ModelVoltageLevel> vl = std::make_shared<ModelVoltageLevel>(vlItfIIDM);
  std::unique_ptr<ModelBus> bus1 = DYN::make_unique<ModelBus>(bus1ItfIIDM, false);
  std::unique_ptr<ModelBus> bus2 = DYN::make_unique<ModelBus>(bus2ItfIIDM, false);
  std::unique_ptr<ModelBus> bus3 = DYN::make_unique<ModelBus>(bus3ItfIIDM, false);
  t3w->setModelBus1(std::move(bus1));
  t3w->setModelBus2(std::move(bus2));
  t3w->setModelBus3(std::move(bus3));
  return std::make_pair(t3w, vl);
}


TEST(ModelsModelNetwork, ModelNetworkThreeWindingsTransformerInitializationClosed) {
  std::shared_ptr<ModelThreeWindingsTransformer> tw3 = createModelThreeWindingsTransformer(false, false).first;
  bool deactivateRootFunctions = false;
  ASSERT_EQ(tw3->id(), "MyThreeWindingsTransformer");

  tw3->initSize();
  std::vector<double> y(tw3->sizeY(), 0.);
  std::vector<double> yp(tw3->sizeY(), 0.);
  std::vector<double> f(tw3->sizeF(), 0.);
  std::vector<double> z(tw3->sizeZ(), 0.);
  ASSERT_EQ(tw3->sizeF(), 0);
  ASSERT_EQ(tw3->sizeY(), 0);
  ASSERT_EQ(tw3->sizeMode(), 0);
  ASSERT_EQ(tw3->sizeZ(), 0);
  ASSERT_EQ(tw3->sizeG(), 0);
  ASSERT_EQ(tw3->sizeCalculatedVar(), ModelThreeWindingsTransformer::nbCalculatedVariables_);

  tw3->evalYMat();
  ASSERT_NO_THROW(tw3->init());
  ASSERT_NO_THROW(tw3->evalF(UNDEFINED_EQ));
  ASSERT_NO_THROW(tw3->evalStaticYType());
  ASSERT_NO_THROW(tw3->evalStaticFType());
  ASSERT_NO_THROW(tw3->evalDynamicYType());
  ASSERT_NO_THROW(tw3->evalDynamicFType());
  std::map<int, std::string> fEquationIndex;
  tw3->setFequations(fEquationIndex);
  ASSERT_EQ(fEquationIndex.size(), 0);
  ASSERT_NO_THROW(tw3->evalG(0.));
  ASSERT_NO_THROW(tw3->evalZ(0., deactivateRootFunctions));
  ASSERT_NO_THROW(tw3->evalState(0.));
  ASSERT_NO_THROW(tw3->evalCalculatedVars());
  ASSERT_THROW_DYNAWO(tw3->evalCalculatedVarI(42), Error::MODELER, KeyError_t::UndefCalculatedVarI);
  std::vector<double> res;
  ASSERT_THROW_DYNAWO(tw3->evalJCalculatedVarI(42, res), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  std::vector<int> numVars;
  ASSERT_THROW_DYNAWO(tw3->getIndexesOfVariablesUsedForCalculatedVarI(42, numVars), Error::MODELER, KeyError_t::UndefJCalculatedVarI);
  ASSERT_NO_THROW(tw3->getY0());
  std::map<int, std::string> gEquationIndex;
  tw3->setGequations(gEquationIndex);
  ASSERT_EQ(gEquationIndex.size(), 0);
  std::vector<shared_ptr<Variable> > definedVariables;
  std::vector<shared_ptr<Variable> > instantiatedVariables;
  tw3->defineVariables(definedVariables);
  tw3->instantiateVariables(instantiatedVariables);
  ASSERT_EQ(definedVariables.size(), instantiatedVariables.size());
  SparseMatrix smj;
  int size = tw3->sizeY();
  smj.init(size, size);
  tw3->evalJt(1., 0, smj);
  ASSERT_EQ(smj.nbElem(), 0);

  SparseMatrix smjPrime;
  smjPrime.init(size, size);
  tw3->evalJtPrim(0, smjPrime);
  ASSERT_EQ(smjPrime.nbElem(), 0);
  ASSERT_NO_THROW(tw3->evalNodeInjection());
  ASSERT_NO_THROW(tw3->evalDerivatives(0.));
  ASSERT_NO_THROW(tw3->evalDerivativesPrim());
  ASSERT_NO_THROW(tw3->addBusNeighbors());

  std::vector<ParameterModeler> parameters;
  tw3->defineNonGenericParameters(parameters);
  ASSERT_TRUE(parameters.empty());
  std::unordered_map<std::string, ParameterModeler> parametersModels;
  ASSERT_NO_THROW(tw3->setSubModelParameters(parametersModels));

  std::shared_ptr<ModelThreeWindingsTransformer> tw3Init = createModelThreeWindingsTransformer(false, true).first;
  tw3Init->initSize();
  ASSERT_EQ(tw3->sizeF(), 0);
  ASSERT_EQ(tw3->sizeY(), 0);
  ASSERT_EQ(tw3->sizeMode(), 0);
  ASSERT_EQ(tw3->sizeZ(), 0);
  ASSERT_EQ(tw3->sizeG(), 0);
  ASSERT_EQ(tw3->sizeCalculatedVar(), 0);
}

}  // namespace DYN
