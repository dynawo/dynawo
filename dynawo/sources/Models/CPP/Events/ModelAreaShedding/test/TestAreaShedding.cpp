//
// Copyright (c) 2022, RTE (http://www.rte-france.com)
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

/**
 * @file Models/CPP/ModelAreaShedding/TestAreaShedding
 * @brief Unit tests for AreaShedding model
 *
 */

#include <boost/shared_ptr.hpp>

#include "DYNElement.h"
#include "DYNModelAreaShedding.h"
#include "DYNModelAreaShedding.hpp"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"
#include "DYNSubModel.h"
#include "DYNVariable.h"
#include "PARParametersSet.h"

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> initModelAreaShedding(double PRefLoad2, double QRefLoad2) {
  boost::shared_ptr<SubModel> modelAreaShedding =
      SubModelFactory::createSubModelFromLib("../DYNModelAreaShedding" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelAreaShedding->defineParameters(parameters);
  boost::shared_ptr<parameters::ParametersSet> parametersSet =
      boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
  parametersSet->createParameter("nbLoads", 2);
  parametersSet->createParameter("deltaTime", 0.5);
  parametersSet->createParameter("deltaP_0", 5.);
  parametersSet->createParameter("deltaQ_0", 10.);
  parametersSet->createParameter("deltaP_1", 15.);
  parametersSet->createParameter("deltaQ_1", 20.);
  parametersSet->createParameter("PRef_load_0", 0.05);
  parametersSet->createParameter("PRef_load_1", PRefLoad2);
  parametersSet->createParameter("QRef_load_0", 0.2);
  parametersSet->createParameter("QRef_load_1", QRefLoad2);
  modelAreaShedding->setPARParameters(parametersSet);
  modelAreaShedding->addParameters(parameters, false);
  modelAreaShedding->setParametersFromPARFile();
  modelAreaShedding->setSubModelParameters();

  modelAreaShedding->getSize();

  return modelAreaShedding;
}

TEST(ModelsModelAreaShedding, ModelAreaSheddingDefineMethods) {
  boost::shared_ptr<SubModel> modelAreaShedding = SubModelFactory::createSubModelFromLib("../DYNModelAreaShedding" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelAreaShedding->defineParameters(parameters);
  ASSERT_EQ(parameters.size(), 6);

  boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
  parametersSet->createParameter("nbLoads", 2);
  parametersSet->createParameter("deltaTime", 0.);
  parametersSet->createParameter("deltaP_0", 5.);
  parametersSet->createParameter("deltaQ_0", 10.);
  parametersSet->createParameter("deltaP_1", 15.);
  parametersSet->createParameter("deltaQ_1", 20.);
  parametersSet->createParameter("PRef_load_0", 0.2);
  parametersSet->createParameter("PRef_load_1", 0.1);
  parametersSet->createParameter("QRef_load_0", 0.5);
  parametersSet->createParameter("QRef_load_1", 0.05);
  ASSERT_NO_THROW(modelAreaShedding->setPARParameters(parametersSet));

  modelAreaShedding->addParameters(parameters, false);
  ASSERT_NO_THROW(modelAreaShedding->setParametersFromPARFile());
  ASSERT_NO_THROW(modelAreaShedding->setSubModelParameters());


  std::vector<boost::shared_ptr<Variable> > variables;
  modelAreaShedding->defineVariables(variables);
  ASSERT_EQ(variables.size(), 5);
  boost::shared_ptr<Variable> variableAreaShedding = variables[0];
  ASSERT_EQ(variableAreaShedding->getName(), "PRef_load_0_value");
  ASSERT_EQ(variableAreaShedding->getType(), CONTINUOUS);
  ASSERT_EQ(variableAreaShedding->getNegated(), false);
  ASSERT_EQ(variableAreaShedding->isState(), true);
  ASSERT_EQ(variableAreaShedding->isAlias(), false);
  variableAreaShedding = variables[1];
  ASSERT_EQ(variableAreaShedding->getName(), "QRef_load_0_value");
  ASSERT_EQ(variableAreaShedding->getType(), CONTINUOUS);
  ASSERT_EQ(variableAreaShedding->getNegated(), false);
  ASSERT_EQ(variableAreaShedding->isState(), true);
  ASSERT_EQ(variableAreaShedding->isAlias(), false);
  variableAreaShedding = variables[2];
  ASSERT_EQ(variableAreaShedding->getName(), "PRef_load_1_value");
  ASSERT_EQ(variableAreaShedding->getType(), CONTINUOUS);
  ASSERT_EQ(variableAreaShedding->getNegated(), false);
  ASSERT_EQ(variableAreaShedding->isState(), true);
  ASSERT_EQ(variableAreaShedding->isAlias(), false);
  variableAreaShedding = variables[3];
  ASSERT_EQ(variableAreaShedding->getName(), "QRef_load_1_value");
  ASSERT_EQ(variableAreaShedding->getType(), CONTINUOUS);
  ASSERT_EQ(variableAreaShedding->getNegated(), false);
  ASSERT_EQ(variableAreaShedding->isState(), true);
  ASSERT_EQ(variableAreaShedding->isAlias(), false);
  variableAreaShedding = variables[4];
  ASSERT_EQ(variableAreaShedding->getName(), "state");
  ASSERT_EQ(variableAreaShedding->getType(), DISCRETE);
  ASSERT_EQ(variableAreaShedding->getNegated(), false);
  ASSERT_EQ(variableAreaShedding->isState(), true);
  ASSERT_EQ(variableAreaShedding->isAlias(), false);

  std::vector<Element> elements;
  std::map<std::string, int> mapElements;
  modelAreaShedding->defineElements(elements, mapElements);
  ASSERT_EQ(elements.size(), mapElements.size());
  ASSERT_EQ(elements.size(), 8);
  Element element = elements[0];
  ASSERT_EQ(element.getTypeElement(), Element::STRUCTURE);
  ASSERT_EQ(element.name(), element.id());
  ASSERT_EQ(element.name(), "PRef_load_0");
  ASSERT_EQ(element.subElementsNum()[0], 1);
  ASSERT_EQ(mapElements["PRef_load_0"], 0);
  element = elements[1];
  ASSERT_EQ(element.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(element.name(), "value");
  ASSERT_EQ(element.id(), "PRef_load_0_value");
  ASSERT_EQ(element.subElementsNum().size(), 0);
  ASSERT_EQ(mapElements["PRef_load_0_value"], 1);
  element = elements[2];
  ASSERT_EQ(element.getTypeElement(), Element::STRUCTURE);
  ASSERT_EQ(element.name(), element.id());
  ASSERT_EQ(element.id(), "QRef_load_0");
  ASSERT_EQ(element.subElementsNum()[0], 3);
  ASSERT_EQ(mapElements["QRef_load_0"], 2);
  element = elements[3];
  ASSERT_EQ(element.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(element.name(), "value");
  ASSERT_EQ(element.id(), "QRef_load_0_value");
  ASSERT_EQ(element.subElementsNum().size(), 0);
  ASSERT_EQ(mapElements["QRef_load_0_value"], 3);
  element = elements[4];
  ASSERT_EQ(element.getTypeElement(), Element::STRUCTURE);
  ASSERT_EQ(element.name(), element.id());
  ASSERT_EQ(element.name(), "PRef_load_1");
  ASSERT_EQ(element.subElementsNum()[0], 5);
  ASSERT_EQ(mapElements["PRef_load_1"], 4);
  element = elements[5];
  ASSERT_EQ(element.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(element.name(), "value");
  ASSERT_EQ(element.id(), "PRef_load_1_value");
  ASSERT_EQ(element.subElementsNum().size(), 0);
  ASSERT_EQ(mapElements["PRef_load_1_value"], 5);
  element = elements[6];
  ASSERT_EQ(element.getTypeElement(), Element::STRUCTURE);
  ASSERT_EQ(element.name(), element.id());
  ASSERT_EQ(element.id(), "QRef_load_1");
  ASSERT_EQ(element.subElementsNum()[0], 7);
  ASSERT_EQ(mapElements["QRef_load_1"], 6);
  element = elements[7];
  ASSERT_EQ(element.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(element.name(), "value");
  ASSERT_EQ(element.id(), "QRef_load_1_value");
  ASSERT_EQ(element.subElementsNum().size(), 0);
  ASSERT_EQ(mapElements["QRef_load_1_value"], 7);
}

TEST(ModelsModelAreaShedding, ModelAreaSheddingTypeMethods) {
  boost::shared_ptr<SubModel> ModelAreaShedding = initModelAreaShedding(.1, .01);
  unsigned nbY = 4;
  unsigned nbF = 4;
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  ModelAreaShedding->setBufferYType(&yTypes[0], 0);
  ModelAreaShedding->setBufferFType(&fTypes[0], 0);

  ASSERT_EQ(ModelAreaShedding->sizeY(), nbY);
  ASSERT_EQ(ModelAreaShedding->sizeF(), nbF);
  ASSERT_EQ(ModelAreaShedding->sizeZ(), 1);
  ASSERT_EQ(ModelAreaShedding->sizeG(), 1);
  ASSERT_EQ(ModelAreaShedding->sizeMode(), 1);

  ModelAreaShedding->evalStaticYType();
  ModelAreaShedding->evalDynamicYType();
  for (size_t i = 0; i < nbY; ++i) {
    ASSERT_EQ(yTypes[i], ALGEBRAIC);
  }

  ModelAreaShedding->evalStaticFType();
  ModelAreaShedding->evalDynamicFType();
  for (size_t i = 0; i < nbF; ++i) {
    ASSERT_EQ(fTypes[i], ALGEBRAIC_EQ);
  }
  ASSERT_NO_THROW(ModelAreaShedding->dumpUserReadableElementList("MyElement"));
}

TEST(ModelsModelAreaShedding, ModelAreaSheddingInit) {
  boost::shared_ptr<SubModel> ModelAreaShedding = initModelAreaShedding(.1, .01);
  std::vector<double> y(ModelAreaShedding->sizeY(), 0);
  std::vector<double> yp(ModelAreaShedding->sizeY(), 0);
  ModelAreaShedding->setBufferY(&y[0], &yp[0], 0.);
  std::vector<double> z(ModelAreaShedding->sizeZ(), 0);
  bool* zConnected = new bool[ModelAreaShedding->sizeZ()];
  for (size_t i = 0; i < ModelAreaShedding->sizeZ(); ++i)
    zConnected[i] = true;
  ModelAreaShedding->setBufferZ(&z[0], zConnected, 0);
  ModelAreaShedding->init(0);
  ModelAreaShedding->getY0();
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[0], 0.05);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[1], 0.2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[2], 0.1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(y[3], 0.01);
  for (size_t i = 0; i < ModelAreaShedding->sizeY(); ++i) {
    ASSERT_DOUBLE_EQUALS_DYNAWO(yp[i], 0.);
  }
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], 0.);
  boost::shared_ptr<DataInterface> data;
  ASSERT_NO_THROW(ModelAreaShedding->initializeFromData(data));
  ASSERT_NO_THROW(ModelAreaShedding->initializeStaticData());
  delete[] zConnected;
}

TEST(ModelsModelAreaShedding, ModelAreaSheddingContinuousAndDiscreteMethods) {
  boost::shared_ptr<SubModel> ModelAreaShedding = initModelAreaShedding(.1, .01);
  std::vector<double> y(ModelAreaShedding->sizeY(), 0);
  std::vector<double> yp(ModelAreaShedding->sizeY(), 0);
  ModelAreaShedding->setBufferY(&y[0], &yp[0], 0.);
  std::vector<double> z(ModelAreaShedding->sizeZ(), 0);
  bool* zConnected = new bool[ModelAreaShedding->sizeZ()];
  for (size_t i = 0; i < ModelAreaShedding->sizeZ(); ++i)
    zConnected[i] = true;
  ModelAreaShedding->setBufferZ(&z[0], zConnected, 0);
  BitMask* silentZ = new BitMask[ModelAreaShedding->sizeZ()];
  std::vector<state_g> g(ModelAreaShedding->sizeG(), ROOT_DOWN);
  ModelAreaShedding->setBufferG(&g[0], 0);
  std::vector<double> f(ModelAreaShedding->sizeF(), 0);
  ModelAreaShedding->setBufferF(&f[0], 0);
  ModelAreaShedding->init(0);
  ModelAreaShedding->getY0();
  ASSERT_NO_THROW(ModelAreaShedding->setFequations());
  ASSERT_NO_THROW(ModelAreaShedding->setGequations());
  std::vector<double> res;
  ASSERT_NO_THROW(ModelAreaShedding->evalJCalculatedVarI(0, res));
  std::vector<int> indexes;
  ASSERT_NO_THROW(ModelAreaShedding->getIndexesOfVariablesUsedForCalculatedVarI(0, indexes));
  ASSERT_NO_THROW(ModelAreaShedding->evalCalculatedVarI(0));
  ASSERT_NO_THROW(ModelAreaShedding->evalCalculatedVars());
  ASSERT_NO_THROW(ModelAreaShedding->evalDynamicFType());
  ASSERT_NO_THROW(ModelAreaShedding->evalDynamicYType());
  ModelAreaShedding->collectSilentZ(silentZ);
  for (size_t i = 0; i < ModelAreaShedding->sizeZ(); ++i) {
    if (i == 0)
      ASSERT_TRUE(silentZ[i].getFlags(NotUsedInDiscreteEquations));
    else
      ASSERT_FALSE(silentZ[i].getFlags(NotUsedInDiscreteEquations));
  }

  ModelAreaShedding->evalF(0, UNDEFINED_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[3], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], 0);
  ModelAreaShedding->evalF(0, DIFFERENTIAL_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[3], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], 0);
  SparseMatrix smj;
  int size = ModelAreaShedding->sizeF();
  smj.init(size, size);
  ModelAreaShedding->evalJt(0, 0, smj, 0);
  ASSERT_EQ(smj.nbElem(), 4);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[1], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[2], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[3], 1);

  ModelAreaShedding->evalG(2.);
  ModelAreaShedding->evalZ(2.);
  ModelAreaShedding->evalF(2., UNDEFINED_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[0], 0.0025);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[1], 0.02);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[2], 0.015);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[3], 0.002);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], 1);

  SparseMatrix smjPrim;
  smjPrim.init(size, size);
  ModelAreaShedding->evalJtPrim(0, 0, smjPrim, 0);
  ASSERT_EQ(smjPrim.nbElem(), 0);
  modeChangeType_t mode = ModelAreaShedding->evalMode(1);
  ASSERT_EQ(mode, ALGEBRAIC_MODE);
  mode = ModelAreaShedding->evalMode(6);
  ASSERT_EQ(mode, NO_MODE);
  delete[] zConnected;
}

}  // namespace DYN
