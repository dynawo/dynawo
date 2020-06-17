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

/**
 * @file Models/CPP/ModelAlphaSum/TestAlphaSum
 * @brief Unit tests for AlphaSum model
 *
 */

#include <boost/shared_ptr.hpp>

#include "DYNElement.h"
#include "DYNModelAlphaSum.h"
#include "DYNModelAlphaSum.hpp"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"
#include "DYNSubModel.h"
#include "DYNVariable.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"

#include "gtest_dynawo.h"

namespace DYN {

boost::shared_ptr<SubModel> initModelAlphaSum() {
  boost::shared_ptr<SubModel> modelAlphaSum = SubModelFactory::createSubModelFromLib("../DYNModelAlphaSum" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelAlphaSum->defineParameters(parameters);
  boost::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newInstance("Parameterset");
  parametersSet->createParameter("nbGen", 2);
  modelAlphaSum->setPARParameters(parametersSet);
  modelAlphaSum->addParameters(parameters, false);
  modelAlphaSum->setParametersFromPARFile();
  modelAlphaSum->setSubModelParameters();

  modelAlphaSum->getSize();

  return modelAlphaSum;
}

TEST(ModelsModelAlphaSum, ModelAlphaSumDefineMethods) {
  boost::shared_ptr<SubModel> modelAlphaSum = SubModelFactory::createSubModelFromLib("../DYNModelAlphaSum" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelAlphaSum->defineParameters(parameters);
  ASSERT_EQ(parameters.size(), 1);

  boost::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newInstance("Parameterset");
  parametersSet->createParameter("nbGen", 1);
  ASSERT_NO_THROW(modelAlphaSum->setPARParameters(parametersSet));

  modelAlphaSum->addParameters(parameters, false);
  ASSERT_NO_THROW(modelAlphaSum->setParametersFromPARFile());
  ASSERT_NO_THROW(modelAlphaSum->setSubModelParameters());

  std::vector<boost::shared_ptr<Variable> > variables;
  modelAlphaSum->defineVariables(variables);
  ASSERT_EQ(variables.size(), 7);
  boost::shared_ptr<Variable> variableN = variables[0];
  ASSERT_EQ(variableN->getName(), "n_0_value");
  ASSERT_EQ(variableN->getType(), CONTINUOUS);
  ASSERT_EQ(variableN->getNegated(), false);
  ASSERT_EQ(variableN->isState(), true);
  ASSERT_EQ(variableN->isAlias(), false);
  boost::shared_ptr<Variable> variableNGrp = variables[1];
  ASSERT_EQ(variableNGrp->getName(), "n_grp_0_value");
  ASSERT_EQ(variableNGrp->getType(), CONTINUOUS);
  boost::shared_ptr<Variable> variableTetaRef = variables[2];
  ASSERT_EQ(variableTetaRef->getName(), "tetaRef_0_value");
  ASSERT_EQ(variableTetaRef->getType(), CONTINUOUS);
  boost::shared_ptr<Variable> variablealphaSum = variables[3];
  ASSERT_EQ(variablealphaSum->getName(), "alphaSum_0_value");
  ASSERT_EQ(variablealphaSum->getType(), DISCRETE);
  boost::shared_ptr<Variable> variablealphaGrp = variables[4];
  ASSERT_EQ(variablealphaGrp->getName(), "alpha_grp_0_value");
  ASSERT_EQ(variablealphaGrp->getType(), DISCRETE);
  boost::shared_ptr<Variable> variablealphaSumGrp = variables[5];
  ASSERT_EQ(variablealphaSumGrp->getName(), "alphaSum_grp_0_value");
  ASSERT_EQ(variablealphaSumGrp->getType(), DISCRETE);
  boost::shared_ptr<Variable> numccGrp = variables[6];
  ASSERT_EQ(numccGrp->getName(), "numcc_node_0_value");
  ASSERT_EQ(numccGrp->getType(), DISCRETE);

  std::vector<Element> elements;
  std::map<std::string, int> mapElements;
  modelAlphaSum->defineElements(elements, mapElements);
  ASSERT_EQ(elements.size(), mapElements.size());
  ASSERT_EQ(elements.size(), 14);
  Element elementAlphaSum = elements[0];
  ASSERT_EQ(elementAlphaSum.getTypeElement(), Element::STRUCTURE);
  ASSERT_EQ(elementAlphaSum.name(), elementAlphaSum.id());
  ASSERT_EQ(elementAlphaSum.name(), "alphaSum_0");
  ASSERT_EQ(elementAlphaSum.subElementsNum()[0], 1);
  ASSERT_EQ(mapElements["alphaSum_0"], 0);
  Element elementAlphaSumValue = elements[1];
  ASSERT_EQ(elementAlphaSumValue.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(elementAlphaSumValue.name(), "value");
  ASSERT_EQ(elementAlphaSumValue.id(), "alphaSum_0_value");
  ASSERT_EQ(elementAlphaSumValue.subElementsNum().size(), 0);
  ASSERT_EQ(mapElements["alphaSum_0_value"], 1);
}

TEST(ModelsModelAlphaSum, ModelAlphaSumTypeMethods) {
  boost::shared_ptr<SubModel> modelAlphaSum = initModelAlphaSum();
  unsigned nbY = 4;
  unsigned nbF = 3;
  unsigned nbZ = 7;
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  modelAlphaSum->setBufferYType(&yTypes[0], 0);
  modelAlphaSum->setBufferFType(&fTypes[0], 0);

  ASSERT_EQ(modelAlphaSum->sizeY(), nbY);
  ASSERT_EQ(modelAlphaSum->sizeF(), nbF);
  ASSERT_EQ(modelAlphaSum->sizeZ(), nbZ);
  ASSERT_EQ(modelAlphaSum->sizeG(), 0);
  ASSERT_EQ(modelAlphaSum->sizeMode(), 1);

  modelAlphaSum->evalYType();
  propertyContinuousVar_t* yTypeGet = modelAlphaSum->getYType();
  ASSERT_EQ(yTypeGet[0], ALGEBRAIC);
  ASSERT_EQ(yTypeGet[1], ALGEBRAIC);
  ASSERT_EQ(yTypeGet[2], ALGEBRAIC);
  ASSERT_NE(yTypeGet[1], EXTERNAL);

  modelAlphaSum->evalFType();
  ASSERT_EQ(fTypes[0], ALGEBRAIC_EQ);
  ASSERT_EQ(fTypes[1], ALGEBRAIC_EQ);
}

TEST(ModelsModelAlphaSum, ModelAlphaSumInit) {
  boost::shared_ptr<SubModel> modelAlphaSum = initModelAlphaSum();
  std::vector<double> y(modelAlphaSum->sizeY(), 0);
  std::vector<double> yp(modelAlphaSum->sizeY(), 0);
  modelAlphaSum->setBufferY(&y[0], &yp[0], 0.);
  std::vector<double> z(modelAlphaSum->sizeZ(), 0);
  bool* zConnected = new bool[modelAlphaSum->sizeZ()];
  for (size_t i = 0; i < modelAlphaSum->sizeZ(); ++i)
    zConnected[i] = true;
  modelAlphaSum->setBufferZ(&z[0], zConnected, 0);
  modelAlphaSum->init(0);
  modelAlphaSum->getY0();

  ASSERT_EQ(y[0], 0);
  ASSERT_EQ(yp[0], 0);
  ASSERT_EQ(y[1], 0);
  ASSERT_EQ(yp[1], 0);
  ASSERT_EQ(y[2], 0);
  ASSERT_EQ(yp[2], 0);

  ASSERT_EQ(z[0], 0);
  ASSERT_EQ(z[1], 1);
  ASSERT_EQ(z[3], 0);
  delete[] zConnected;
}

TEST(ModelsModelAlphaSum, ModelAlphaSumContinuousAndDiscreteMethods) {
  boost::shared_ptr<SubModel> modelAlphaSum = initModelAlphaSum();
  std::vector<double> y(modelAlphaSum->sizeY(), 0);
  std::vector<double> yp(modelAlphaSum->sizeY(), 0);
  modelAlphaSum->setBufferY(&y[0], &yp[0], 0.);
  std::vector<double> z(modelAlphaSum->sizeZ(), 0);
  bool* zConnected = new bool[modelAlphaSum->sizeZ()];
  for (size_t i = 0; i < modelAlphaSum->sizeZ(); ++i)
    zConnected[i] = true;
  modelAlphaSum->setBufferZ(&z[0], zConnected, 0);
  z[2] = 1;
  z[3] = 1;
  std::vector<double> f(modelAlphaSum->sizeF(), 0);
  modelAlphaSum->setBufferF(&f[0], 0);
  modelAlphaSum->init(0);
  modelAlphaSum->getY0();
  ASSERT_NO_THROW(modelAlphaSum->setFequations());

  modelAlphaSum->evalF(0, UNDEFINED_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[3], 0);
  SparseMatrix smj;
  int size = modelAlphaSum->sizeY();
  smj.init(size, size);
  modelAlphaSum->evalJt(0, 0, smj, 0);
  smj.changeCol();
  ASSERT_EQ(smj.nbElem(), 5);
  ASSERT_EQ(smj.Ap_[0], 0);
  ASSERT_EQ(smj.Ap_[1], 2);
  ASSERT_EQ(smj.Ap_[2], 4);
  ASSERT_EQ(smj.Ai_[0], 0);
  ASSERT_EQ(smj.Ai_[1], 1);
  ASSERT_EQ(smj.Ai_[2], 0);
  ASSERT_EQ(smj.Ax_[0], 1);
  ASSERT_EQ(smj.Ax_[1], -1);
  ASSERT_EQ(smj.Ax_[2], 1);

  y[1] = 2.5;
  modelAlphaSum->evalF(1, UNDEFINED_EQ);
  modelAlphaSum->evalZ(1);
  ASSERT_EQ(f[0], -2.5);
  ASSERT_EQ(f[1], 0);
  ASSERT_EQ(z[0], 2);
  ASSERT_EQ(z[1], 1);

  y[0] = 2;
  modelAlphaSum->evalF(1, UNDEFINED_EQ);
  ASSERT_EQ(f[1], 2);
  ASSERT_EQ(f[2], 0);
  SparseMatrix smjPrim;
  smjPrim.init(size, size);
  modelAlphaSum->evalJtPrim(0, 0, smjPrim, 0);
  ASSERT_EQ(smjPrim.nbElem(), 0);
  modeChangeType_t mode = modelAlphaSum->evalMode(1);
  ASSERT_EQ(mode, NO_MODE);
  delete[] zConnected;
}

}  // namespace DYN
