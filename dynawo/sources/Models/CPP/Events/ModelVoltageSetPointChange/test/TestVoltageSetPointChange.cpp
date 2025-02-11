//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file Models/CPP/ModelVoltageSetPointChange/TestVoltageSetPointChange
 * @brief Unit tests for VoltageSetPointChange model
 *
 */

#include <boost/shared_ptr.hpp>

#include "DYNElement.h"
#include "DYNModelVoltageSetPointChange.h"
#include "DYNModelVoltageSetPointChange.hpp"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"
#include "DYNSubModel.h"
#include "DYNVariable.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> initModelVoltageSetPointChange() {
  boost::shared_ptr<SubModel> modelVoltageSetPointChange =
    SubModelFactory::createSubModelFromLib("../DYNModelVoltageSetPointChange" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelVoltageSetPointChange->defineParameters(parameters);
  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter("numLoads", 2);
  parametersSet->createParameter("startTime", 1.);
  parametersSet->createParameter("stopTime", 3.);
  parametersSet->createParameter("voltageSetPointChange", -0.05);
  modelVoltageSetPointChange->setPARParameters(parametersSet);
  modelVoltageSetPointChange->addParameters(parameters, false);
  modelVoltageSetPointChange->setParametersFromPARFile();
  modelVoltageSetPointChange->setSubModelParameters();

  modelVoltageSetPointChange->getSize();

  return modelVoltageSetPointChange;
}

TEST(ModelsModelVoltageSetPointChange, ModelVoltageSetPointChangeDefineMethods) {
  boost::shared_ptr<SubModel> modelVoltageSetPointChange =
    SubModelFactory::createSubModelFromLib("../DYNModelVoltageSetPointChange" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelVoltageSetPointChange->defineParameters(parameters);
  ASSERT_EQ(parameters.size(), 4);

  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter("numLoads", 2);
  parametersSet->createParameter("startTime", 1.);
  parametersSet->createParameter("stopTime", 3.);
  parametersSet->createParameter("voltageSetPointChange", -0.05);
  ASSERT_NO_THROW(modelVoltageSetPointChange->setPARParameters(parametersSet));

  modelVoltageSetPointChange->addParameters(parameters, false);
  ASSERT_NO_THROW(modelVoltageSetPointChange->setParametersFromPARFile());
  ASSERT_NO_THROW(modelVoltageSetPointChange->setSubModelParameters());

  std::vector<boost::shared_ptr<Variable> > variables;
  modelVoltageSetPointChange->defineVariables(variables);
  ASSERT_EQ(variables.size(), 2);
  boost::shared_ptr<Variable> variableVoltageSetPointChange = variables[0];
  ASSERT_EQ(variableVoltageSetPointChange->getName(), "setPointChange_0");
  ASSERT_EQ(variableVoltageSetPointChange->getType(), DISCRETE);
  ASSERT_EQ(variableVoltageSetPointChange->getNegated(), false);
  ASSERT_EQ(variableVoltageSetPointChange->isState(), true);
  ASSERT_EQ(variableVoltageSetPointChange->isAlias(), false);
  variableVoltageSetPointChange = variables[1];
  ASSERT_EQ(variableVoltageSetPointChange->getName(), "setPointChange_1");
  ASSERT_EQ(variableVoltageSetPointChange->getType(), DISCRETE);
  ASSERT_EQ(variableVoltageSetPointChange->getNegated(), false);
  ASSERT_EQ(variableVoltageSetPointChange->isState(), true);
  ASSERT_EQ(variableVoltageSetPointChange->isAlias(), false);

  std::vector<Element> elements;
  std::map<std::string, int> mapElements;
  modelVoltageSetPointChange->defineElements(elements, mapElements);
  ASSERT_EQ(elements.size(), mapElements.size());
  ASSERT_EQ(elements.size(), 2);
  Element element = elements[0];
  ASSERT_EQ(element.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(element.name(), element.id());
  ASSERT_EQ(element.name(), "setPointChange_0");
  ASSERT_EQ(element.subElementsNum().size(), 0);
  ASSERT_EQ(mapElements["setPointChange_0"], 0);

  element = elements[1];
  ASSERT_EQ(element.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(element.name(), element.id());
  ASSERT_EQ(element.name(), "setPointChange_1");
  ASSERT_EQ(element.subElementsNum().size(), 0);
  ASSERT_EQ(mapElements["setPointChange_1"], 1);
}

TEST(ModelsModelVoltageSetPointChange, ModelVoltageSetPointChangeNoStopTime) {
  boost::shared_ptr<SubModel> modelVoltageSetPointChange =
    SubModelFactory::createSubModelFromLib("../DYNModelVoltageSetPointChange" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelVoltageSetPointChange->defineParameters(parameters);
  ASSERT_EQ(parameters.size(), 4);

  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter("numLoads", 2);
  parametersSet->createParameter("startTime", 1.);
  parametersSet->createParameter("voltageSetPointChange", -0.05);
  ASSERT_NO_THROW(modelVoltageSetPointChange->setPARParameters(parametersSet));

  modelVoltageSetPointChange->addParameters(parameters, false);
  ASSERT_NO_THROW(modelVoltageSetPointChange->setParametersFromPARFile());
  ASSERT_NO_THROW(modelVoltageSetPointChange->setSubModelParameters());
}

TEST(ModelsModelVoltageSetPointChange, ModelVoltageSetPointChangeTypeMethods) {
  boost::shared_ptr<SubModel> modelVoltageSetPointChange = initModelVoltageSetPointChange();

  ASSERT_EQ(modelVoltageSetPointChange->sizeY(), 0);
  ASSERT_EQ(modelVoltageSetPointChange->sizeF(), 0);
  ASSERT_EQ(modelVoltageSetPointChange->sizeZ(), 2);
  ASSERT_EQ(modelVoltageSetPointChange->sizeG(), 2);
  ASSERT_EQ(modelVoltageSetPointChange->sizeMode(), 0);

  modelVoltageSetPointChange->evalStaticYType();
  modelVoltageSetPointChange->evalDynamicYType();
  modelVoltageSetPointChange->evalStaticFType();

  ASSERT_NO_THROW(modelVoltageSetPointChange->dumpUserReadableElementList("MyElement"));
}

TEST(ModelsModelVoltageSetPointChange, ModelVoltageSetPointChangeInit) {
  boost::shared_ptr<SubModel> modelVoltageSetPointChange = initModelVoltageSetPointChange();
  std::vector<double> z(modelVoltageSetPointChange->sizeZ(), 0);
  bool* zConnected = new bool[modelVoltageSetPointChange->sizeZ()];
  for (size_t i = 0; i < modelVoltageSetPointChange->sizeZ(); ++i)
    zConnected[i] = true;
  modelVoltageSetPointChange->setBufferZ(&z[0], zConnected, 0);
  modelVoltageSetPointChange->init(0);
  modelVoltageSetPointChange->getY0();
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[1], 0.);
  boost::shared_ptr<DataInterface> data;
  ASSERT_NO_THROW(modelVoltageSetPointChange->initializeFromData(data));
  ASSERT_NO_THROW(modelVoltageSetPointChange->initializeStaticData());
  ASSERT_NO_THROW(modelVoltageSetPointChange->checkDataCoherence(0));
  delete[] zConnected;
}

TEST(ModelsModelVoltageSetPointChange, ModelVoltageSetPointChangeContinuousAndDiscreteMethods) {
  boost::shared_ptr<SubModel> modelVoltageSetPointChange = initModelVoltageSetPointChange();
  std::vector<double> z(modelVoltageSetPointChange->sizeZ(), 0);
  bool* zConnected = new bool[modelVoltageSetPointChange->sizeZ()];
  for (size_t i = 0; i < modelVoltageSetPointChange->sizeZ(); ++i)
    zConnected[i] = true;
  modelVoltageSetPointChange->setBufferZ(&z[0], zConnected, 0);
  BitMask* silentZ = new BitMask[modelVoltageSetPointChange->sizeZ()];
  std::vector<state_g> g(modelVoltageSetPointChange->sizeG(), ROOT_DOWN);
  modelVoltageSetPointChange->setBufferG(&g[0], 0);
  modelVoltageSetPointChange->init(0);
  modelVoltageSetPointChange->getY0();
  ASSERT_NO_THROW(modelVoltageSetPointChange->setFequations());
  ASSERT_NO_THROW(modelVoltageSetPointChange->setGequations());
  std::vector<double> res;
  ASSERT_NO_THROW(modelVoltageSetPointChange->evalJCalculatedVarI(0, res));
  std::vector<int> indexes;
  ASSERT_NO_THROW(modelVoltageSetPointChange->getIndexesOfVariablesUsedForCalculatedVarI(0, indexes));
  ASSERT_NO_THROW(modelVoltageSetPointChange->evalCalculatedVarI(0));
  ASSERT_NO_THROW(modelVoltageSetPointChange->evalCalculatedVars());
  ASSERT_NO_THROW(modelVoltageSetPointChange->evalDynamicFType());
  ASSERT_NO_THROW(modelVoltageSetPointChange->evalDynamicYType());
  modelVoltageSetPointChange->collectSilentZ(silentZ);
  for (size_t i = 0; i < modelVoltageSetPointChange->sizeZ(); ++i) {
    ASSERT_TRUE(silentZ[i].getFlags(NotUsedInContinuousEquations));
  }

  modelVoltageSetPointChange->evalF(0, UNDEFINED_EQ);
  SparseMatrix smj;
  int size = modelVoltageSetPointChange->sizeF();
  smj.init(size, size);
  modelVoltageSetPointChange->evalJt(0, 0, smj, 0);
  ASSERT_EQ(smj.nbElem(), 0);

  modelVoltageSetPointChange->evalG(2.);
  modelVoltageSetPointChange->evalZ(2.);
  modelVoltageSetPointChange->evalF(2., UNDEFINED_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], -0.05);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[1], -0.05);

  modelVoltageSetPointChange->evalG(6.);
  modelVoltageSetPointChange->evalZ(6.);
  modelVoltageSetPointChange->evalF(6., UNDEFINED_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], 0.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[1], 0.);

  SparseMatrix smjPrim;
  smjPrim.init(size, size);
  modelVoltageSetPointChange->evalJtPrim(0, 0, smjPrim, 0);
  ASSERT_EQ(smjPrim.nbElem(), 0);
  modeChangeType_t mode = modelVoltageSetPointChange->evalMode(1);
  ASSERT_EQ(mode, NO_MODE);
  delete[] zConnected;
}

}  // namespace DYN
