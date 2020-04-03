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
 * @file Models/CPP/ModelFrequency/ModelSignalN/TestSignalN
 * @brief Unit tests for SignalN model
 *
 */

#include <boost/shared_ptr.hpp>

#include "DYNElement.h"
#include "DYNModelSignalN.h"
#include "DYNModelSignalN.hpp"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"
#include "DYNSubModel.h"
#include "DYNVariable.h"
#include "PARParametersSet.h"

#include "gtest_dynawo.h"

namespace DYN {

boost::shared_ptr<SubModel> initModelSignalN() {
  boost::shared_ptr<SubModel> modelSignalN = SubModelFactory::createSubModelFromLib("../DYNModelSignalN" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelSignalN->defineParameters(parameters);
  boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
  parametersSet->createParameter("nbGen", 2);
  modelSignalN->setPARParameters(parametersSet);
  modelSignalN->addParameters(parameters, false);
  modelSignalN->setParametersFromPARFile();
  modelSignalN->setSubModelParameters();

  modelSignalN->getSize();

  return modelSignalN;
}

TEST(ModelsModelSignalN, ModelSignalNDefineMethods) {
  boost::shared_ptr<SubModel> modelSignalN = SubModelFactory::createSubModelFromLib("../DYNModelSignalN" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelSignalN->defineParameters(parameters);
  ASSERT_EQ(parameters.size(), 1);

  boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
  parametersSet->createParameter("nbGen", 1);
  ASSERT_NO_THROW(modelSignalN->setPARParameters(parametersSet));

  modelSignalN->addParameters(parameters, false);
  ASSERT_NO_THROW(modelSignalN->setParametersFromPARFile());
  ASSERT_NO_THROW(modelSignalN->setSubModelParameters());

  std::vector<boost::shared_ptr<Variable> > variables;
  modelSignalN->defineVariables(variables);
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
  modelSignalN->defineElements(elements, mapElements);
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

TEST(ModelsModelSignalN, ModelSignalNTypeMethods) {
  boost::shared_ptr<SubModel> modelSignalN = initModelSignalN();
  unsigned nbY = 4;
  unsigned nbF = 3;
  unsigned nbZ = 7;
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  modelSignalN->setBufferYType(&yTypes[0], 0);
  modelSignalN->setBufferFType(&fTypes[0], 0);

  ASSERT_EQ(modelSignalN->sizeY(), nbY);
  ASSERT_EQ(modelSignalN->sizeF(), nbF);
  ASSERT_EQ(modelSignalN->sizeZ(), nbZ);
  ASSERT_EQ(modelSignalN->sizeG(), 0);
  ASSERT_EQ(modelSignalN->sizeMode(), 1);

  modelSignalN->evalStaticYType();
  modelSignalN->evalDynamicYType();
  propertyContinuousVar_t* yTypeGet = modelSignalN->getYType();
  ASSERT_EQ(yTypeGet[0], ALGEBRAIC);
  ASSERT_EQ(yTypeGet[1], ALGEBRAIC);
  ASSERT_EQ(yTypeGet[2], ALGEBRAIC);
  ASSERT_NE(yTypeGet[1], EXTERNAL);

  modelSignalN->evalStaticFType();
  modelSignalN->evalDynamicFType();
  ASSERT_EQ(fTypes[0], ALGEBRAIC_EQ);
  ASSERT_EQ(fTypes[1], ALGEBRAIC_EQ);
  ASSERT_NO_THROW(modelSignalN->dumpUserReadableElementList("MyElement"));
  ASSERT_NO_THROW(modelSignalN->initializeFromData(boost::shared_ptr<DataInterface>()));
  std:: vector<double> res;
  std::vector<int> indexes;
  ASSERT_NO_THROW(modelSignalN->evalJCalculatedVarI(0, res));
  ASSERT_NO_THROW(modelSignalN->getIndexesOfVariablesUsedForCalculatedVarI(0, indexes));
  ASSERT_NO_THROW(modelSignalN->evalCalculatedVars());
  ASSERT_NO_THROW(modelSignalN->updateFType());
  ASSERT_NO_THROW(modelSignalN->updateYType());
  ASSERT_NO_THROW(modelSignalN->initializeStaticData());
  ASSERT_NO_THROW(modelSignalN->setGequations());
  ASSERT_EQ(modelSignalN->evalCalculatedVarI(0), 0.);


  boost::shared_ptr<SubModel> modelSignalN2 = SubModelFactory::createSubModelFromLib("../DYNModelSignalN" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelSignalN2->defineParameters(parameters);
  boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
  parametersSet->createParameter("nbGen", 2);
  modelSignalN2->setPARParameters(parametersSet);
  modelSignalN2->addParameters(parameters, false);
  modelSignalN2->setParametersFromPARFile();
  modelSignalN2->setSubModelParameters();
  modelSignalN2->init(0.);
  modelSignalN2->getSize();
  std::vector<double> z(modelSignalN2->sizeZ(), 0);
  bool* zConnected = new bool[modelSignalN2->sizeZ()];
  for (size_t i = 0; i < modelSignalN2->sizeZ(); ++i)
    zConnected[i] = true;
  z[5] = 0.;
  z[6] = 1.;
  modelSignalN2->setBufferZ(&z[0], zConnected, 0);
  ASSERT_THROW_DYNAWO(modelSignalN2->evalZ(0.), Error::MODELER, KeyError_t::TooMuchSubNetwork);
}

TEST(ModelsModelSignalN, ModelSignalNInit) {
  boost::shared_ptr<SubModel> modelSignalN = initModelSignalN();
  std::vector<double> y(modelSignalN->sizeY(), 0);
  std::vector<double> yp(modelSignalN->sizeY(), 0);
  modelSignalN->setBufferY(&y[0], &yp[0], 0.);
  std::vector<double> z(modelSignalN->sizeZ(), 0);
  bool* zConnected = new bool[modelSignalN->sizeZ()];
  for (size_t i = 0; i < modelSignalN->sizeZ(); ++i)
    zConnected[i] = true;
  modelSignalN->setBufferZ(&z[0], zConnected, 0);
  modelSignalN->init(0);
  modelSignalN->getY0();

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

TEST(ModelsModelSignalN, ModelSignalNContinuousAndDiscreteMethods) {
  boost::shared_ptr<SubModel> modelSignalN = initModelSignalN();
  std::vector<double> y(modelSignalN->sizeY(), 0);
  std::vector<double> yp(modelSignalN->sizeY(), 0);
  modelSignalN->setBufferY(&y[0], &yp[0], 0.);
  std::vector<double> z(modelSignalN->sizeZ(), 0);
  bool* zConnected = new bool[modelSignalN->sizeZ()];
  for (size_t i = 0; i < modelSignalN->sizeZ(); ++i)
    zConnected[i] = true;
  modelSignalN->setBufferZ(&z[0], zConnected, 0);
  BitMask* silentZ = new BitMask[modelSignalN->sizeZ()];
  z[2] = 1;
  z[3] = 1;
  std::vector<double> f(modelSignalN->sizeF(), 0);
  modelSignalN->setBufferF(&f[0], 0);
  modelSignalN->init(0);
  modelSignalN->getY0();
  ASSERT_NO_THROW(modelSignalN->setFequations());
  ASSERT_NO_THROW(modelSignalN->evalG(0.));
  modelSignalN->collectSilentZ(silentZ);
  for (size_t i = 0; i < modelSignalN->sizeZ(); ++i)
    ASSERT_TRUE(silentZ[i].getFlags(NotUsedInDiscreteEquations));

  modelSignalN->evalF(0, UNDEFINED_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[3], 0);
  modelSignalN->evalF(0, DIFFERENTIAL_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[3], 0);
  SparseMatrix smj;
  int size = modelSignalN->sizeY();
  smj.init(size, size);
  modelSignalN->evalJt(0, 0, smj, 0);
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
  modelSignalN->evalF(1, UNDEFINED_EQ);
  modelSignalN->evalZ(1);
  ASSERT_EQ(f[0], -2.5);
  ASSERT_EQ(f[1], 0);
  ASSERT_EQ(z[0], 2);
  ASSERT_EQ(z[1], 1);

  y[0] = 2;
  modelSignalN->evalF(1, UNDEFINED_EQ);
  ASSERT_EQ(f[1], 2);
  ASSERT_EQ(f[2], 0);
  SparseMatrix smjPrim;
  smjPrim.init(size, size);
  modelSignalN->evalJtPrim(0, 0, smjPrim, 0);
  ASSERT_EQ(smjPrim.nbElem(), 0);
  modeChangeType_t mode = modelSignalN->evalMode(1);
  ASSERT_EQ(mode, NO_MODE);
  z[5] = 1.;
  z[6] = 1.;
  modelSignalN->evalZ(0.);
  mode = modelSignalN->evalMode(1);
  ASSERT_EQ(mode, ALGEBRAIC_J_UPDATE_MODE);
  delete[] zConnected;
}

}  // namespace DYN
