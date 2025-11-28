//
// Copyright (c) 2022, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file Models/CPP/Updatables/ModelUpdatableDiscrete/TestModelUpdatableDiscrete
 * @brief Unit tests for ModelUpdatableDiscrete model
 *
 */

#include <boost/shared_ptr.hpp>

#include "DYNElement.h"
#include "DYNModelUpdatableDiscrete.h"
#include "DYNModelUpdatableDiscrete.hpp"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"
#include "DYNSubModel.h"
#include "DYNVariable.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> initModelModelUpdatableDiscrete() {
  boost::shared_ptr<SubModel> modelModelUpdatableDiscrete =
      SubModelFactory::createSubModelFromLib("../DYNModelUpdatableDiscrete" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelModelUpdatableDiscrete->defineParameters(parameters);
  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter(UPDATABLE_INPUT_NAME, 1.2);
  modelModelUpdatableDiscrete->setPARParameters(parametersSet);
  modelModelUpdatableDiscrete->addParameters(parameters, false);
  modelModelUpdatableDiscrete->setParametersFromPARFile();
  modelModelUpdatableDiscrete->setSubModelParameters();

  modelModelUpdatableDiscrete->getSize();

  return modelModelUpdatableDiscrete;
}

TEST(ModelsModelModelUpdatableDiscrete, ModelModelUpdatableDiscreteDefineMethods) {
  boost::shared_ptr<SubModel> modelModelUpdatableDiscrete = SubModelFactory::createSubModelFromLib("../DYNModelUpdatableDiscrete" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelModelUpdatableDiscrete->defineParameters(parameters);
  ASSERT_EQ(parameters.size(), 1);

  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter(UPDATABLE_INPUT_NAME, 2.);
  ASSERT_NO_THROW(modelModelUpdatableDiscrete->setPARParameters(parametersSet));

  modelModelUpdatableDiscrete->addParameters(parameters, false);
  ASSERT_NO_THROW(modelModelUpdatableDiscrete->setParametersFromPARFile());
  ASSERT_NO_THROW(modelModelUpdatableDiscrete->setSubModelParameters());

  std::vector<boost::shared_ptr<Variable> > variables;
  modelModelUpdatableDiscrete->defineVariables(variables);
  ASSERT_EQ(variables.size(), 1);
  boost::shared_ptr<Variable> variableModelUpdatableDiscrete = variables[0];
  ASSERT_EQ(variableModelUpdatableDiscrete->getName(), UPDATABLE_INPUT_NAME);
  ASSERT_EQ(variableModelUpdatableDiscrete->getType(), DISCRETE);
  ASSERT_EQ(variableModelUpdatableDiscrete->getNegated(), false);
  ASSERT_EQ(variableModelUpdatableDiscrete->isState(), false);
  ASSERT_EQ(variableModelUpdatableDiscrete->isAlias(), false);

  std::vector<Element> elements;
  std::map<std::string, int> mapElements;
  modelModelUpdatableDiscrete->defineElements(elements, mapElements);
  ASSERT_EQ(elements.size(), mapElements.size());
  ASSERT_EQ(elements.size(), 1);
  Element element = elements[0];
  ASSERT_EQ(element.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(element.name(), element.id());
  ASSERT_EQ(element.name(), UPDATABLE_INPUT_NAME);
  ASSERT_EQ(mapElements[UPDATABLE_INPUT_NAME], 0);
}

TEST(ModelsModelModelUpdatableDiscrete, ModelModelUpdatableDiscreteTypeMethods) {
  boost::shared_ptr<SubModel> modelModelUpdatableDiscrete = initModelModelUpdatableDiscrete();
  unsigned nbY = 0;
  unsigned nbF = 0;
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  modelModelUpdatableDiscrete->setBufferYType(&yTypes[0], 0);
  modelModelUpdatableDiscrete->setBufferFType(&fTypes[0], 0);

  ASSERT_EQ(modelModelUpdatableDiscrete->sizeY(), nbY);
  ASSERT_EQ(modelModelUpdatableDiscrete->sizeF(), nbF);
  ASSERT_EQ(modelModelUpdatableDiscrete->sizeZ(), 0);
  ASSERT_EQ(modelModelUpdatableDiscrete->sizeG(), 1);
  ASSERT_EQ(modelModelUpdatableDiscrete->sizeMode(), 1);

  ASSERT_NO_THROW(modelModelUpdatableDiscrete->dumpUserReadableElementList("MyElement"));
}

TEST(ModelsModelModelUpdatableDiscrete, ModelModelUpdatableDiscreteUpdate) {
  boost::shared_ptr<SubModel> modelModelUpdatableDiscrete = initModelModelUpdatableDiscrete();
  std::vector<state_g> g(modelModelUpdatableDiscrete->sizeG(), ROOT_DOWN);
  modelModelUpdatableDiscrete->setBufferG(&g[0], 0);
  modelModelUpdatableDiscrete->evalG(0);
  modeChangeType_t mode = modelModelUpdatableDiscrete->evalMode(0);
  ASSERT_EQ(mode, NO_MODE);

  modelModelUpdatableDiscrete->setParameterValue(UPDATABLE_INPUT_NAME, DYN::FINAL, 3., false);
  modelModelUpdatableDiscrete->setSubModelParameters();
  modelModelUpdatableDiscrete->evalG(0);
  mode = modelModelUpdatableDiscrete->evalMode(0);
  ASSERT_EQ(mode, ALGEBRAIC_MODE);

  modelModelUpdatableDiscrete->evalG(0);
  mode = modelModelUpdatableDiscrete->evalMode(0);
  ASSERT_EQ(mode, NO_MODE);

  modelModelUpdatableDiscrete->setParameterValue(UPDATABLE_INPUT_NAME, DYN::FINAL, 3.1, false);
  modelModelUpdatableDiscrete->setSubModelParameters();
  modelModelUpdatableDiscrete->evalG(0);
  mode = modelModelUpdatableDiscrete->evalMode(0);
  ASSERT_EQ(mode, ALGEBRAIC_MODE);
}

}  // namespace DYN
