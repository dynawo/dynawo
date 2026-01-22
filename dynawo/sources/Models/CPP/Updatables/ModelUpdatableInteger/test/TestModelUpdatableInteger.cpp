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
 * @file Models/CPP/Updatables/ModelUpdatableInteger/TestModelUpdatableInteger
 * @brief Unit tests for ModelUpdatableInteger model
 *
 */

#include <boost/shared_ptr.hpp>

#include "DYNElement.h"
#include "DYNModelUpdatableInteger.h"
#include "DYNModelUpdatableInteger.hpp"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"
#include "DYNSubModel.h"
#include "DYNVariable.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> initModelModelUpdatableInteger() {
  boost::shared_ptr<SubModel> modelModelUpdatableInteger =
      SubModelFactory::createSubModelFromLib("../DYNModelUpdatableInteger" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelModelUpdatableInteger->defineParameters(parameters);
  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter(UPDATABLE_INPUT_NAME, 2);
  modelModelUpdatableInteger->setPARParameters(parametersSet);
  modelModelUpdatableInteger->addParameters(parameters, false);
  modelModelUpdatableInteger->setParametersFromPARFile();
  modelModelUpdatableInteger->setSubModelParameters();

  modelModelUpdatableInteger->getSize();

  return modelModelUpdatableInteger;
}

TEST(ModelsModelModelUpdatableInteger, ModelModelUpdatableIntegerDefineMethods) {
  boost::shared_ptr<SubModel> modelModelUpdatableInteger = SubModelFactory::createSubModelFromLib("../DYNModelUpdatableInteger" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelModelUpdatableInteger->defineParameters(parameters);
  ASSERT_EQ(parameters.size(), 1);

  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter(UPDATABLE_INPUT_NAME, 3);
  ASSERT_NO_THROW(modelModelUpdatableInteger->setPARParameters(parametersSet));

  modelModelUpdatableInteger->addParameters(parameters, false);
  ASSERT_NO_THROW(modelModelUpdatableInteger->setParametersFromPARFile());
  ASSERT_NO_THROW(modelModelUpdatableInteger->setSubModelParameters());

  std::vector<boost::shared_ptr<Variable> > variables;
  modelModelUpdatableInteger->defineVariables(variables);
  ASSERT_EQ(variables.size(), 1);
  boost::shared_ptr<Variable> variableModelUpdatableInteger = variables[0];
  ASSERT_EQ(variableModelUpdatableInteger->getName(), UPDATABLE_INPUT_NAME);
  ASSERT_EQ(variableModelUpdatableInteger->getType(), INTEGER);
  ASSERT_EQ(variableModelUpdatableInteger->getNegated(), false);
  ASSERT_EQ(variableModelUpdatableInteger->isState(), false);
  ASSERT_EQ(variableModelUpdatableInteger->isAlias(), false);

  std::vector<Element> elements;
  std::map<std::string, int> mapElements;
  modelModelUpdatableInteger->defineElements(elements, mapElements);
  ASSERT_EQ(elements.size(), mapElements.size());
  ASSERT_EQ(elements.size(), 1);
  Element element = elements[0];
  ASSERT_EQ(element.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(element.name(), element.id());
  ASSERT_EQ(element.name(), UPDATABLE_INPUT_NAME);
  ASSERT_EQ(mapElements[UPDATABLE_INPUT_NAME], 0);
}

TEST(ModelsModelModelUpdatableInteger, ModelModelUpdatableIntegerTypeMethods) {
  boost::shared_ptr<SubModel> modelModelUpdatableInteger = initModelModelUpdatableInteger();
  unsigned nbY = 0;
  unsigned nbF = 0;
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  modelModelUpdatableInteger->setBufferYType(&yTypes[0], 0);
  modelModelUpdatableInteger->setBufferFType(&fTypes[0], 0);

  ASSERT_EQ(modelModelUpdatableInteger->sizeY(), nbY);
  ASSERT_EQ(modelModelUpdatableInteger->sizeF(), nbF);
  ASSERT_EQ(modelModelUpdatableInteger->sizeZ(), 0);
  ASSERT_EQ(modelModelUpdatableInteger->sizeG(), 1);
  ASSERT_EQ(modelModelUpdatableInteger->sizeMode(), 1);

  ASSERT_NO_THROW(modelModelUpdatableInteger->dumpUserReadableElementList("MyElement"));
}

TEST(ModelsModelModelUpdatableInteger, ModelModelUpdatableIntegerUpdate) {
  boost::shared_ptr<SubModel> modelModelUpdatableInteger = initModelModelUpdatableInteger();
  std::vector<state_g> g(modelModelUpdatableInteger->sizeG(), ROOT_DOWN);
  modelModelUpdatableInteger->setBufferG(&g[0], 0);
  modelModelUpdatableInteger->evalG(0);
  modeChangeType_t mode = modelModelUpdatableInteger->evalMode(0);
  ASSERT_EQ(mode, NO_MODE);

  modelModelUpdatableInteger->setParameterValue(UPDATABLE_INPUT_NAME, DYN::FINAL, 5, false);
  modelModelUpdatableInteger->setSubModelParameters();
  modelModelUpdatableInteger->evalG(0);
  mode = modelModelUpdatableInteger->evalMode(0);
  ASSERT_EQ(mode, ALGEBRAIC_MODE);

  modelModelUpdatableInteger->evalG(0);
  mode = modelModelUpdatableInteger->evalMode(0);
  ASSERT_EQ(mode, NO_MODE);

  modelModelUpdatableInteger->setParameterValue(UPDATABLE_INPUT_NAME, DYN::FINAL, 2, false);
  modelModelUpdatableInteger->setSubModelParameters();
  modelModelUpdatableInteger->evalG(0);
  mode = modelModelUpdatableInteger->evalMode(0);
  ASSERT_EQ(mode, ALGEBRAIC_MODE);
}

}  // namespace DYN
