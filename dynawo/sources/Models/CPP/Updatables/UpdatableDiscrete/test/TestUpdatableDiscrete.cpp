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
 * @file Models/CPP/Updatables/UpdatableDiscrete/TestUpdatableDiscrete
 * @brief Unit tests for UpdatableDiscrete model
 *
 */

#include <boost/shared_ptr.hpp>

#include "DYNElement.h"
#include "DYNUpdatableDiscrete.h"
#include "DYNUpdatableDiscrete.hpp"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"
#include "DYNSubModel.h"
#include "DYNVariable.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> initModelUpdatableDiscrete() {
  boost::shared_ptr<SubModel> modelUpdatableDiscrete =
      SubModelFactory::createSubModelFromLib("../DYNUpdatableDiscrete" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelUpdatableDiscrete->defineParameters(parameters);
  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter(UPDATABLE_INPUT_NAME, 1.2);
  modelUpdatableDiscrete->setPARParameters(parametersSet);
  modelUpdatableDiscrete->addParameters(parameters, false);
  modelUpdatableDiscrete->setParametersFromPARFile();
  modelUpdatableDiscrete->setSubModelParameters();

  modelUpdatableDiscrete->getSize();

  return modelUpdatableDiscrete;
}

TEST(ModelsModelUpdatableDiscrete, ModelUpdatableDiscreteDefineMethods) {
  boost::shared_ptr<SubModel> modelUpdatableDiscrete = SubModelFactory::createSubModelFromLib("../DYNUpdatableDiscrete" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelUpdatableDiscrete->defineParameters(parameters);
  ASSERT_EQ(parameters.size(), 1);

  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter(UPDATABLE_INPUT_NAME, 2.);
  ASSERT_NO_THROW(modelUpdatableDiscrete->setPARParameters(parametersSet));

  modelUpdatableDiscrete->addParameters(parameters, false);
  ASSERT_NO_THROW(modelUpdatableDiscrete->setParametersFromPARFile());
  ASSERT_NO_THROW(modelUpdatableDiscrete->setSubModelParameters());

  std::vector<boost::shared_ptr<Variable> > variables;
  modelUpdatableDiscrete->defineVariables(variables);
  ASSERT_EQ(variables.size(), 1);
  boost::shared_ptr<Variable> variableUpdatableDiscrete = variables[0];
  ASSERT_EQ(variableUpdatableDiscrete->getName(), UPDATABLE_INPUT_NAME);
  ASSERT_EQ(variableUpdatableDiscrete->getType(), DISCRETE);
  ASSERT_EQ(variableUpdatableDiscrete->getNegated(), false);
  ASSERT_EQ(variableUpdatableDiscrete->isState(), false);
  ASSERT_EQ(variableUpdatableDiscrete->isAlias(), false);

  std::vector<Element> elements;
  std::map<std::string, int> mapElements;
  modelUpdatableDiscrete->defineElements(elements, mapElements);
  ASSERT_EQ(elements.size(), mapElements.size());
  ASSERT_EQ(elements.size(), 1);
  Element element = elements[0];
  ASSERT_EQ(element.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(element.name(), element.id());
  ASSERT_EQ(element.name(), UPDATABLE_INPUT_NAME);
  ASSERT_EQ(mapElements[UPDATABLE_INPUT_NAME], 0);
}

TEST(ModelsModelUpdatableDiscrete, ModelUpdatableDiscreteTypeMethods) {
  boost::shared_ptr<SubModel> modelUpdatableDiscrete = initModelUpdatableDiscrete();
  unsigned nbY = 0;
  unsigned nbF = 0;
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  modelUpdatableDiscrete->setBufferYType(&yTypes[0], 0);
  modelUpdatableDiscrete->setBufferFType(&fTypes[0], 0);

  ASSERT_EQ(modelUpdatableDiscrete->sizeY(), nbY);
  ASSERT_EQ(modelUpdatableDiscrete->sizeF(), nbF);
  ASSERT_EQ(modelUpdatableDiscrete->sizeZ(), 0);
  ASSERT_EQ(modelUpdatableDiscrete->sizeG(), 1);
  ASSERT_EQ(modelUpdatableDiscrete->sizeMode(), 1);

  ASSERT_NO_THROW(modelUpdatableDiscrete->dumpUserReadableElementList("MyElement"));
}

TEST(ModelsModelUpdatableDiscrete, ModelUpdatableDiscreteUpdate) {
  boost::shared_ptr<SubModel> modelUpdatableDiscrete = initModelUpdatableDiscrete();
  std::vector<state_g> g(modelUpdatableDiscrete->sizeG(), ROOT_DOWN);
  modelUpdatableDiscrete->setBufferG(&g[0], 0);
  modelUpdatableDiscrete->evalG(0);
  modeChangeType_t mode = modelUpdatableDiscrete->evalMode(0);
  ASSERT_EQ(mode, NO_MODE);

  modelUpdatableDiscrete->setParameterValue(UPDATABLE_INPUT_NAME, DYN::FINAL, 3., false);
  modelUpdatableDiscrete->setSubModelParameters();
  modelUpdatableDiscrete->evalG(0);
  mode = modelUpdatableDiscrete->evalMode(0);
  ASSERT_EQ(mode, ALGEBRAIC_MODE);

  modelUpdatableDiscrete->evalG(0);
  mode = modelUpdatableDiscrete->evalMode(0);
  ASSERT_EQ(mode, NO_MODE);

  modelUpdatableDiscrete->setParameterValue(UPDATABLE_INPUT_NAME, DYN::FINAL, 3.1, false);
  modelUpdatableDiscrete->setSubModelParameters();
  modelUpdatableDiscrete->evalG(0);
  mode = modelUpdatableDiscrete->evalMode(0);
  ASSERT_EQ(mode, ALGEBRAIC_MODE);
}

}  // namespace DYN
