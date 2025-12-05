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
 * @file Models/CPP/Updatables/ModelUpdatableBoolean/TestModelUpdatableBoolean
 * @brief Unit tests for ModelUpdatableBoolean model
 *
 */

#include <boost/shared_ptr.hpp>

#include "DYNElement.h"
#include "DYNModelUpdatableBoolean.h"
#include "DYNModelUpdatableBoolean.hpp"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"
#include "DYNSubModel.h"
#include "DYNVariable.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> initModelModelUpdatableBoolean() {
  boost::shared_ptr<SubModel> modelModelUpdatableBoolean =
      SubModelFactory::createSubModelFromLib("../DYNModelUpdatableBoolean" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelModelUpdatableBoolean->defineParameters(parameters);
  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter(UPDATABLE_INPUT_NAME, true);
  modelModelUpdatableBoolean->setPARParameters(parametersSet);
  modelModelUpdatableBoolean->addParameters(parameters, false);
  modelModelUpdatableBoolean->setParametersFromPARFile();
  modelModelUpdatableBoolean->setSubModelParameters();
  modelModelUpdatableBoolean->getSize();

  return modelModelUpdatableBoolean;
}

TEST(ModelsModelModelUpdatableBoolean, ModelModelUpdatableBooleanDefineMethods) {
  boost::shared_ptr<SubModel> modelModelUpdatableBoolean = SubModelFactory::createSubModelFromLib("../DYNModelUpdatableBoolean" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelModelUpdatableBoolean->defineParameters(parameters);
  ASSERT_EQ(parameters.size(), 1);

  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter(UPDATABLE_INPUT_NAME, true);
  ASSERT_NO_THROW(modelModelUpdatableBoolean->setPARParameters(parametersSet));

  modelModelUpdatableBoolean->addParameters(parameters, false);
  ASSERT_NO_THROW(modelModelUpdatableBoolean->setParametersFromPARFile());
  ASSERT_NO_THROW(modelModelUpdatableBoolean->setSubModelParameters());

  std::vector<boost::shared_ptr<Variable> > variables;
  modelModelUpdatableBoolean->defineVariables(variables);
  ASSERT_EQ(variables.size(), 1);
  boost::shared_ptr<Variable> variableModelUpdatableBoolean = variables[0];
  ASSERT_EQ(variableModelUpdatableBoolean->getName(), UPDATABLE_INPUT_NAME);
  ASSERT_EQ(variableModelUpdatableBoolean->getType(), BOOLEAN);
  ASSERT_EQ(variableModelUpdatableBoolean->getNegated(), false);
  ASSERT_EQ(variableModelUpdatableBoolean->isState(), false);
  ASSERT_EQ(variableModelUpdatableBoolean->isAlias(), false);

  std::vector<Element> elements;
  std::map<std::string, int> mapElements;
  modelModelUpdatableBoolean->defineElements(elements, mapElements);
  ASSERT_EQ(elements.size(), mapElements.size());
  ASSERT_EQ(elements.size(), 1);
  Element element = elements[0];
  ASSERT_EQ(element.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(element.name(), element.id());
  ASSERT_EQ(element.name(), UPDATABLE_INPUT_NAME);
  ASSERT_EQ(mapElements[UPDATABLE_INPUT_NAME], 0);
}

TEST(ModelsModelModelUpdatableBoolean, ModelModelUpdatableBooleanTypeMethods) {
  boost::shared_ptr<SubModel> modelModelUpdatableBoolean = initModelModelUpdatableBoolean();
  unsigned nbY = 0;
  unsigned nbF = 0;
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  modelModelUpdatableBoolean->setBufferYType(&yTypes[0], 0);
  modelModelUpdatableBoolean->setBufferFType(&fTypes[0], 0);

  ASSERT_EQ(modelModelUpdatableBoolean->sizeY(), nbY);
  ASSERT_EQ(modelModelUpdatableBoolean->sizeF(), nbF);
  ASSERT_EQ(modelModelUpdatableBoolean->sizeZ(), 0);
  ASSERT_EQ(modelModelUpdatableBoolean->sizeG(), 1);
  ASSERT_EQ(modelModelUpdatableBoolean->sizeMode(), 1);

  ASSERT_NO_THROW(modelModelUpdatableBoolean->dumpUserReadableElementList("MyElement"));
}

TEST(ModelsModelModelUpdatableBoolean, ModelModelUpdatableBooleanUpdate) {
  boost::shared_ptr<SubModel> modelModelUpdatableBoolean = initModelModelUpdatableBoolean();
  std::vector<state_g> g(modelModelUpdatableBoolean->sizeG(), ROOT_DOWN);
  modelModelUpdatableBoolean->setBufferG(&g[0], 0);
  modelModelUpdatableBoolean->evalG(0);
  modeChangeType_t mode = modelModelUpdatableBoolean->evalMode(0);
  ASSERT_EQ(mode, NO_MODE);

  modelModelUpdatableBoolean->setParameterValue(UPDATABLE_INPUT_NAME, DYN::FINAL, true, false);
  modelModelUpdatableBoolean->setSubModelParameters();
  modelModelUpdatableBoolean->evalG(0);
  mode = modelModelUpdatableBoolean->evalMode(0);
  ASSERT_EQ(mode, ALGEBRAIC_MODE);

  modelModelUpdatableBoolean->evalG(0);
  mode = modelModelUpdatableBoolean->evalMode(0);
  ASSERT_EQ(mode, NO_MODE);

  modelModelUpdatableBoolean->setParameterValue(UPDATABLE_INPUT_NAME, DYN::FINAL, false, false);
  modelModelUpdatableBoolean->setSubModelParameters();
  modelModelUpdatableBoolean->evalG(0);
  mode = modelModelUpdatableBoolean->evalMode(0);
  ASSERT_EQ(mode, ALGEBRAIC_MODE);
}

}  // namespace DYN
