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

#include <IIDM/builders/NetworkBuilder.h>
#include <IIDM/builders/Transformer3WindingsBuilder.h>
#include <IIDM/builders/VoltageLevelBuilder.h>
#include <IIDM/builders/SubstationBuilder.h>
#include <IIDM/builders/BusBuilder.h>
#include <IIDM/components/Transformer3Windings.h>
#include <IIDM/components/CurrentLimit.h>
#include <IIDM/components/VoltageLevel.h>
#include <IIDM/components/Bus.h>
#include <IIDM/components/Substation.h>
#include <IIDM/Network.h>

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

#include "gtest_dynawo.h"


using boost::shared_ptr;

namespace DYN {
std::pair<shared_ptr<ModelThreeWindingsTransformer>, shared_ptr<ModelVoltageLevel> >  // need to return the voltage level so that it is not destroyed
createModelThreeWindingsTransformer(bool open, bool initModel) {
  IIDM::builders::NetworkBuilder nb;
  IIDM::Network networkIIDM = nb.build("MyNetwork");

  IIDM::builders::SubstationBuilder ssb;
  IIDM::Substation ss = ssb.build("MySubStation");
  IIDM::connection_status_t cs = {!open};
  IIDM::Port p1("MyBus1", cs), p2("MyBus2", cs), p3("MyBus3", cs);
  IIDM::Connection c1("MyVoltageLevel", p1, IIDM::side_1), c2("MyVoltageLevel", p2, IIDM::side_2), c3("MyVoltageLevel", p3, IIDM::side_1);

  IIDM::builders::BusBuilder bb;
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
  ss.add(vlIIDM);
  networkIIDM.add(ss);

  IIDM::builders::Transformer3WindingsBuilder t3wb;
  IIDM::Transformer3Windings t3wIIDM = t3wb.build("MyThreeWindingsTransformer");
  ss.add(t3wIIDM, c1, c2, c3);
  IIDM::Transformer3Windings t3wIIDM2 = ss.get_threeWindingsTransformer("MyThreeWindingsTransformer");  // was copied...
  shared_ptr<ThreeWTransformerInterfaceIIDM> tw3ItfIIDM = shared_ptr<ThreeWTransformerInterfaceIIDM>(new ThreeWTransformerInterfaceIIDM(t3wIIDM2));
  shared_ptr<VoltageLevelInterfaceIIDM> vlItfIIDM = shared_ptr<VoltageLevelInterfaceIIDM>(new VoltageLevelInterfaceIIDM(vlIIDM));
  shared_ptr<BusInterfaceIIDM> bus1ItfIIDM = shared_ptr<BusInterfaceIIDM>(new BusInterfaceIIDM(vlIIDM.get_bus("MyBus1")));
  shared_ptr<BusInterfaceIIDM> bus2ItfIIDM = shared_ptr<BusInterfaceIIDM>(new BusInterfaceIIDM(vlIIDM.get_bus("MyBus2")));
  shared_ptr<BusInterfaceIIDM> bus3ItfIIDM = shared_ptr<BusInterfaceIIDM>(new BusInterfaceIIDM(vlIIDM.get_bus("MyBus3")));
  tw3ItfIIDM->setVoltageLevelInterface1(vlItfIIDM);
  tw3ItfIIDM->setBusInterface1(bus1ItfIIDM);
  tw3ItfIIDM->setBusInterface2(bus2ItfIIDM);
  tw3ItfIIDM->setBusInterface2(bus3ItfIIDM);

  shared_ptr<ModelThreeWindingsTransformer> t3w = shared_ptr<ModelThreeWindingsTransformer>(new ModelThreeWindingsTransformer(tw3ItfIIDM));
  ModelNetwork* network = new ModelNetwork();
  network->setIsInitModel(initModel);
  t3w->setNetwork(network);
  shared_ptr<ModelVoltageLevel> vl = shared_ptr<ModelVoltageLevel>(new ModelVoltageLevel(vlItfIIDM));
  shared_ptr<ModelBus> bus1 = shared_ptr<ModelBus>(new ModelBus(bus1ItfIIDM));
  shared_ptr<ModelBus> bus2 = shared_ptr<ModelBus>(new ModelBus(bus2ItfIIDM));
  shared_ptr<ModelBus> bus3 = shared_ptr<ModelBus>(new ModelBus(bus3ItfIIDM));
  t3w->setModelBus1(bus1);
  t3w->setModelBus2(bus2);
  t3w->setModelBus3(bus3);
  return std::make_pair(t3w, vl);
}


TEST(ModelsModelNetwork, ModelNetworkThreeWindingsTransformerInitializationClosed) {
  shared_ptr<ModelThreeWindingsTransformer> tw3 = createModelThreeWindingsTransformer(false, false).first;
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
  ASSERT_NO_THROW(tw3->evalYType());
  ASSERT_NO_THROW(tw3->evalFType());
  std::map<int, std::string> fEquationIndex;
  tw3->setFequations(fEquationIndex);
  ASSERT_EQ(fEquationIndex.size(), 0);
  ASSERT_NO_THROW(tw3->evalG(0.));
  ASSERT_NO_THROW(tw3->evalZ(0.));
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
  tw3->evalJt(smj, 1., 0);
  ASSERT_EQ(smj.nbElem(), 0);

  SparseMatrix smjPrime;
  smjPrime.init(size, size);
  tw3->evalJtPrim(smjPrime, 0);
  ASSERT_EQ(smjPrime.nbElem(), 0);
  ASSERT_NO_THROW(tw3->evalNodeInjection());
  ASSERT_NO_THROW(tw3->evalDerivatives(0.));
  ASSERT_NO_THROW(tw3->evalDerivativesPrim());
  ASSERT_NO_THROW(tw3->addBusNeighbors());
  ASSERT_NO_THROW(tw3->updateYType());
  ASSERT_NO_THROW(tw3->updateFType());

  std::vector<ParameterModeler> parameters;
  tw3->defineNonGenericParameters(parameters);
  ASSERT_TRUE(parameters.empty());
  boost::unordered_map<std::string, ParameterModeler> parametersModels;
  ASSERT_NO_THROW(tw3->setSubModelParameters(parametersModels));

  shared_ptr<ModelThreeWindingsTransformer> tw3Init = createModelThreeWindingsTransformer(false, true).first;
  tw3Init->initSize();
  ASSERT_EQ(tw3->sizeF(), 0);
  ASSERT_EQ(tw3->sizeY(), 0);
  ASSERT_EQ(tw3->sizeMode(), 0);
  ASSERT_EQ(tw3->sizeZ(), 0);
  ASSERT_EQ(tw3->sizeG(), 0);
  ASSERT_EQ(tw3->sizeCalculatedVar(), 0);
}

}  // namespace DYN
