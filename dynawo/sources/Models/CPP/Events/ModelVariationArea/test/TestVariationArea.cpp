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

/**
 * @file Models/CPP/ModelVariationArea/TestVariationArea
 * @brief Unit tests for VariationArea model
 *
 */

#include <boost/shared_ptr.hpp>

#include "DYNElement.h"
#include "DYNModelVariationArea.h"
#include "DYNModelVariationArea.hpp"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"
#include "DYNSubModel.h"
#include "DYNVariable.h"
#include "PARParametersSet.h"

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> initModelVariationArea(double deltaPLoad2, double deltaQLoad2) {
  boost::shared_ptr<SubModel> modelVariationArea = SubModelFactory::createSubModelFromLib("../DYNModelVariationArea" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelVariationArea->defineParameters(parameters);
  boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
  parametersSet->createParameter("nbLoads", 2);
  parametersSet->createParameter("startTime", 0.);
  parametersSet->createParameter("stopTime", 5.);
  parametersSet->createParameter("deltaP_load_0", 0.2);
  parametersSet->createParameter("deltaQ_load_0", 0.05);
  parametersSet->createParameter("deltaP_load_1", deltaPLoad2);
  parametersSet->createParameter("deltaQ_load_1", deltaQLoad2);
  modelVariationArea->setPARParameters(parametersSet);
  modelVariationArea->addParameters(parameters, false);
  modelVariationArea->setParametersFromPARFile();
  modelVariationArea->setSubModelParameters();

  modelVariationArea->getSize();

  return modelVariationArea;
}

TEST(ModelsModelVariationArea, ModelVariationAreaDefineMethods) {
  boost::shared_ptr<SubModel> modelVariationArea = SubModelFactory::createSubModelFromLib("../DYNModelVariationArea" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelVariationArea->defineParameters(parameters);
  ASSERT_EQ(parameters.size(), 5);

  boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("Parameterset"));
  parametersSet->createParameter("nbLoads", 2);
  parametersSet->createParameter("startTime", 0.);
  parametersSet->createParameter("stopTime", 5.);
  parametersSet->createParameter("deltaP_load_0", .2);
  parametersSet->createParameter("deltaQ_load_0", .1);
  parametersSet->createParameter("deltaP_load_1", .5);
  parametersSet->createParameter("deltaQ_load_1", .05);
  ASSERT_NO_THROW(modelVariationArea->setPARParameters(parametersSet));

  modelVariationArea->addParameters(parameters, false);
  ASSERT_NO_THROW(modelVariationArea->setParametersFromPARFile());
  ASSERT_NO_THROW(modelVariationArea->setSubModelParameters());

  std::vector<boost::shared_ptr<Variable> > variables;
  modelVariationArea->defineVariables(variables);
  ASSERT_EQ(variables.size(), 5);
  boost::shared_ptr<Variable> variableVariationArea = variables[0];
  ASSERT_EQ(variableVariationArea->getName(), "DeltaPc_load_0_value");
  ASSERT_EQ(variableVariationArea->getType(), CONTINUOUS);
  ASSERT_EQ(variableVariationArea->getNegated(), false);
  ASSERT_EQ(variableVariationArea->isState(), true);
  ASSERT_EQ(variableVariationArea->isAlias(), false);
  variableVariationArea = variables[1];
  ASSERT_EQ(variableVariationArea->getName(), "DeltaQc_load_0_value");
  ASSERT_EQ(variableVariationArea->getType(), CONTINUOUS);
  ASSERT_EQ(variableVariationArea->getNegated(), false);
  ASSERT_EQ(variableVariationArea->isState(), true);
  ASSERT_EQ(variableVariationArea->isAlias(), false);
  variableVariationArea = variables[2];
  ASSERT_EQ(variableVariationArea->getName(), "DeltaPc_load_1_value");
  ASSERT_EQ(variableVariationArea->getType(), CONTINUOUS);
  ASSERT_EQ(variableVariationArea->getNegated(), false);
  ASSERT_EQ(variableVariationArea->isState(), true);
  ASSERT_EQ(variableVariationArea->isAlias(), false);
  variableVariationArea = variables[3];
  ASSERT_EQ(variableVariationArea->getName(), "DeltaQc_load_1_value");
  ASSERT_EQ(variableVariationArea->getType(), CONTINUOUS);
  ASSERT_EQ(variableVariationArea->getNegated(), false);
  ASSERT_EQ(variableVariationArea->isState(), true);
  ASSERT_EQ(variableVariationArea->isAlias(), false);
  variableVariationArea = variables[4];
  ASSERT_EQ(variableVariationArea->getName(), "state");
  ASSERT_EQ(variableVariationArea->getType(), DISCRETE);
  ASSERT_EQ(variableVariationArea->getNegated(), false);
  ASSERT_EQ(variableVariationArea->isState(), true);
  ASSERT_EQ(variableVariationArea->isAlias(), false);

  std::vector<Element> elements;
  std::map<std::string, int> mapElements;
  modelVariationArea->defineElements(elements, mapElements);
  ASSERT_EQ(elements.size(), mapElements.size());
  ASSERT_EQ(elements.size(), 8);
  Element element = elements[0];
  ASSERT_EQ(element.getTypeElement(), Element::STRUCTURE);
  ASSERT_EQ(element.name(), element.id());
  ASSERT_EQ(element.name(), "DeltaPc_load_0");
  ASSERT_EQ(element.subElementsNum()[0], 1);
  ASSERT_EQ(mapElements["DeltaPc_load_0"], 0);
  element = elements[1];
  ASSERT_EQ(element.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(element.name(), "value");
  ASSERT_EQ(element.id(), "DeltaPc_load_0_value");
  ASSERT_EQ(element.subElementsNum().size(), 0);
  ASSERT_EQ(mapElements["DeltaPc_load_0_value"], 1);
  element = elements[2];
  ASSERT_EQ(element.getTypeElement(), Element::STRUCTURE);
  ASSERT_EQ(element.name(), element.id());
  ASSERT_EQ(element.id(), "DeltaQc_load_0");
  ASSERT_EQ(element.subElementsNum()[0], 3);
  ASSERT_EQ(mapElements["DeltaQc_load_0"], 2);
  element = elements[3];
  ASSERT_EQ(element.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(element.name(), "value");
  ASSERT_EQ(element.id(), "DeltaQc_load_0_value");
  ASSERT_EQ(element.subElementsNum().size(), 0);
  ASSERT_EQ(mapElements["DeltaQc_load_0_value"], 3);
  element = elements[4];
  ASSERT_EQ(element.getTypeElement(), Element::STRUCTURE);
  ASSERT_EQ(element.name(), element.id());
  ASSERT_EQ(element.name(), "DeltaPc_load_1");
  ASSERT_EQ(element.subElementsNum()[0], 5);
  ASSERT_EQ(mapElements["DeltaPc_load_1"], 4);
  element = elements[5];
  ASSERT_EQ(element.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(element.name(), "value");
  ASSERT_EQ(element.id(), "DeltaPc_load_1_value");
  ASSERT_EQ(element.subElementsNum().size(), 0);
  ASSERT_EQ(mapElements["DeltaPc_load_1_value"], 5);
  element = elements[6];
  ASSERT_EQ(element.getTypeElement(), Element::STRUCTURE);
  ASSERT_EQ(element.name(), element.id());
  ASSERT_EQ(element.id(), "DeltaQc_load_1");
  ASSERT_EQ(element.subElementsNum()[0], 7);
  ASSERT_EQ(mapElements["DeltaQc_load_1"], 6);
  element = elements[7];
  ASSERT_EQ(element.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(element.name(), "value");
  ASSERT_EQ(element.id(), "DeltaQc_load_1_value");
  ASSERT_EQ(element.subElementsNum().size(), 0);
  ASSERT_EQ(mapElements["DeltaQc_load_1_value"], 7);
}

TEST(ModelsModelVariationArea, ModelVariationAreaTypeMethods) {
  boost::shared_ptr<SubModel> modelVariationArea = initModelVariationArea(.1, .01);
  unsigned nbY = 4;
  unsigned nbF = 4;
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  modelVariationArea->setBufferYType(&yTypes[0], 0);
  modelVariationArea->setBufferFType(&fTypes[0], 0);

  ASSERT_EQ(modelVariationArea->sizeY(), nbY);
  ASSERT_EQ(modelVariationArea->sizeF(), nbF);
  ASSERT_EQ(modelVariationArea->sizeZ(), 1);
  ASSERT_EQ(modelVariationArea->sizeG(), 2);
  ASSERT_EQ(modelVariationArea->sizeMode(), 2);

  modelVariationArea->evalStaticYType();
  modelVariationArea->evalDynamicYType();
  for (size_t i = 0; i < nbY; ++i) {
    ASSERT_EQ(yTypes[i], ALGEBRAIC);
  }

  modelVariationArea->evalStaticFType();
  modelVariationArea->evalDynamicFType();
  for (size_t i = 0; i < nbF; ++i) {
    ASSERT_EQ(fTypes[i], ALGEBRAIC_EQ);
  }
  ASSERT_NO_THROW(modelVariationArea->dumpUserReadableElementList("MyElement"));
}

TEST(ModelsModelVariationArea, ModelVariationAreaInit) {
  boost::shared_ptr<SubModel> modelVariationArea = initModelVariationArea(.1, .01);
  std::vector<double> y(modelVariationArea->sizeY(), 0);
  std::vector<double> yp(modelVariationArea->sizeY(), 0);
  modelVariationArea->setBufferY(&y[0], &yp[0], 0.);
  std::vector<double> z(modelVariationArea->sizeZ(), 0);
  bool* zConnected = new bool[modelVariationArea->sizeZ()];
  for (size_t i = 0; i < modelVariationArea->sizeZ(); ++i)
    zConnected[i] = true;
  modelVariationArea->setBufferZ(&z[0], zConnected, 0);
  modelVariationArea->init(0);
  modelVariationArea->getY0();
  for (size_t i = 0; i < modelVariationArea->sizeY(); ++i) {
    ASSERT_DOUBLE_EQUALS_DYNAWO(y[i], 0.);
    ASSERT_DOUBLE_EQUALS_DYNAWO(yp[i], 0.);
  }
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], 0.);
  boost::shared_ptr<DataInterface> data;
  ASSERT_NO_THROW(modelVariationArea->initializeFromData(data));
  ASSERT_NO_THROW(modelVariationArea->initializeStaticData());
  delete[] zConnected;
}

TEST(ModelsModelVariationArea, ModelVariationAreaContinuousAndDiscreteMethods) {
  boost::shared_ptr<SubModel> modelVariationArea = initModelVariationArea(.1, .01);
  std::vector<double> y(modelVariationArea->sizeY(), 0);
  std::vector<double> yp(modelVariationArea->sizeY(), 0);
  modelVariationArea->setBufferY(&y[0], &yp[0], 0.);
  std::vector<double> z(modelVariationArea->sizeZ(), 0);
  bool* zConnected = new bool[modelVariationArea->sizeZ()];
  for (size_t i = 0; i < modelVariationArea->sizeZ(); ++i)
    zConnected[i] = true;
  modelVariationArea->setBufferZ(&z[0], zConnected, 0);
  BitMask* silentZ = new BitMask[modelVariationArea->sizeZ()];
  std::vector<state_g> g(modelVariationArea->sizeG(), ROOT_DOWN);
  modelVariationArea->setBufferG(&g[0], 0);
  std::vector<double> f(modelVariationArea->sizeF(), 0);
  modelVariationArea->setBufferF(&f[0], 0);
  modelVariationArea->init(0);
  modelVariationArea->getY0();
  ASSERT_NO_THROW(modelVariationArea->setFequations());
  ASSERT_NO_THROW(modelVariationArea->setGequations());
  std::vector<double> res;
  ASSERT_NO_THROW(modelVariationArea->evalJCalculatedVarI(0, res));
  std::vector<int> indexes;
  ASSERT_NO_THROW(modelVariationArea->getIndexesOfVariablesUsedForCalculatedVarI(0, indexes));
  ASSERT_NO_THROW(modelVariationArea->evalCalculatedVarI(0));
  ASSERT_NO_THROW(modelVariationArea->evalCalculatedVars());
  ASSERT_NO_THROW(modelVariationArea->evalDynamicFType());
  ASSERT_NO_THROW(modelVariationArea->evalDynamicYType());
  modelVariationArea->collectSilentZ(silentZ);
  for (size_t i = 0; i < modelVariationArea->sizeZ(); ++i) {
    if (i == 0)
      ASSERT_TRUE(silentZ[i].getFlags(NotUsedInDiscreteEquations));
    else
      ASSERT_FALSE(silentZ[i].getFlags(NotUsedInDiscreteEquations));
  }

  modelVariationArea->evalF(0, UNDEFINED_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[3], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], 0);
  modelVariationArea->evalF(0, DIFFERENTIAL_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[0], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[1], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[2], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[3], 0);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], 0);
  SparseMatrix smj;
  int size = modelVariationArea->sizeF();
  smj.init(size, size);
  modelVariationArea->evalJt(0, 0, smj, 0);
  ASSERT_EQ(smj.nbElem(), 4);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.getAx()[0], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.getAx()[1], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.getAx()[2], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.getAx()[3], 1);

  modelVariationArea->evalG(2.);
  modelVariationArea->evalZ(2.);
  modelVariationArea->evalF(2., UNDEFINED_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[0], -0.08);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[1], -0.02);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[2], -0.04);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[3], -0.004);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], 1);

  modelVariationArea->evalG(6.);
  modelVariationArea->evalZ(6.);
  modelVariationArea->evalF(6., UNDEFINED_EQ);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[0], -0.2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[1], -0.05);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[2], -0.1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(f[3], -0.01);
  ASSERT_DOUBLE_EQUALS_DYNAWO(z[0], 2);

  SparseMatrix smjPrim;
  smjPrim.init(size, size);
  modelVariationArea->evalJtPrim(0, 0, smjPrim, 0);
  ASSERT_EQ(smjPrim.nbElem(), 0);
  modeChangeType_t mode = modelVariationArea->evalMode(1);
  ASSERT_EQ(mode, DIFFERENTIAL_MODE);
  mode = modelVariationArea->evalMode(6);
  ASSERT_EQ(mode, DIFFERENTIAL_MODE);
  mode = modelVariationArea->evalMode(7);
  ASSERT_EQ(mode, NO_MODE);
  delete[] zConnected;
}

}  // namespace DYN
