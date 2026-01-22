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
 * @file Models/CPP/Updatables/ModelUpdatableContinuous/TestModelUpdatableContinuous
 * @brief Unit tests for ModelUpdatableContinuous model
 *
 */

#include <boost/shared_ptr.hpp>

#include "DYNElement.h"
#include "DYNModelUpdatableContinuous.h"
#include "DYNModelUpdatableContinuous.hpp"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"
#include "DYNSubModel.h"
#include "DYNVariable.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> initModelModelUpdatableContinuous() {
  boost::shared_ptr<SubModel> modelModelUpdatableContinuous =
      SubModelFactory::createSubModelFromLib("../DYNModelUpdatableContinuous" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelModelUpdatableContinuous->defineParameters(parameters);
  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter(UPDATABLE_INPUT_NAME, 1.2);
  modelModelUpdatableContinuous->setPARParameters(parametersSet);
  modelModelUpdatableContinuous->addParameters(parameters, false);
  modelModelUpdatableContinuous->setParametersFromPARFile();
  modelModelUpdatableContinuous->setSubModelParameters();

  modelModelUpdatableContinuous->getSize();

  return modelModelUpdatableContinuous;
}

TEST(ModelsModelModelUpdatableContinuous, ModelModelUpdatableContinuousDefineMethods) {
  boost::shared_ptr<SubModel> modelModelUpdatableContinuous = SubModelFactory::createSubModelFromLib("../DYNModelUpdatableContinuous" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelModelUpdatableContinuous->defineParameters(parameters);
  ASSERT_EQ(parameters.size(), 1);

  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter(UPDATABLE_INPUT_NAME, 1.5);
  ASSERT_NO_THROW(modelModelUpdatableContinuous->setPARParameters(parametersSet));

  modelModelUpdatableContinuous->addParameters(parameters, false);
  ASSERT_NO_THROW(modelModelUpdatableContinuous->setParametersFromPARFile());
  ASSERT_NO_THROW(modelModelUpdatableContinuous->setSubModelParameters());

  std::vector<boost::shared_ptr<Variable> > variables;
  modelModelUpdatableContinuous->defineVariables(variables);
  ASSERT_EQ(variables.size(), 1);
  boost::shared_ptr<Variable> variableModelUpdatableContinuous = variables[0];
  ASSERT_EQ(variableModelUpdatableContinuous->getName(), UPDATABLE_INPUT_NAME);
  ASSERT_EQ(variableModelUpdatableContinuous->getType(), CONTINUOUS);
  ASSERT_EQ(variableModelUpdatableContinuous->getNegated(), false);
  ASSERT_EQ(variableModelUpdatableContinuous->isState(), false);
  ASSERT_EQ(variableModelUpdatableContinuous->isAlias(), false);

  std::vector<Element> elements;
  std::map<std::string, int> mapElements;
  modelModelUpdatableContinuous->defineElements(elements, mapElements);
  ASSERT_EQ(elements.size(), mapElements.size());
  ASSERT_EQ(elements.size(), 1);
  Element element = elements[0];
  ASSERT_EQ(element.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(element.name(), element.id());
  ASSERT_EQ(element.name(), UPDATABLE_INPUT_NAME);
  ASSERT_EQ(mapElements[UPDATABLE_INPUT_NAME], 0);
}

TEST(ModelsModelModelUpdatableContinuous, ModelModelUpdatableContinuousTypeMethods) {
  boost::shared_ptr<SubModel> modelModelUpdatableContinuous = initModelModelUpdatableContinuous();
  unsigned nbY = 0;
  unsigned nbF = 0;
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  std::vector<state_g> g(modelModelUpdatableContinuous->sizeG(), ROOT_DOWN);
  modelModelUpdatableContinuous->setBufferYType(&yTypes[0], 0);
  modelModelUpdatableContinuous->setBufferFType(&fTypes[0], 0);
  ASSERT_EQ(modelModelUpdatableContinuous->sizeY(), nbY);
  ASSERT_EQ(modelModelUpdatableContinuous->sizeF(), nbF);
  ASSERT_EQ(modelModelUpdatableContinuous->sizeZ(), 0);
  ASSERT_EQ(modelModelUpdatableContinuous->sizeG(), 1);
  ASSERT_EQ(modelModelUpdatableContinuous->sizeMode(), 1);

  ASSERT_NO_THROW(modelModelUpdatableContinuous->dumpUserReadableElementList("MyElement"));
}

TEST(ModelsModelModelUpdatableContinuous, ModelModelUpdatableContinuousUpdate) {
  boost::shared_ptr<SubModel> modelModelUpdatableContinuous = initModelModelUpdatableContinuous();
  std::vector<state_g> g(modelModelUpdatableContinuous->sizeG(), ROOT_DOWN);
  modelModelUpdatableContinuous->setBufferG(&g[0], 0);
  modelModelUpdatableContinuous->evalG(0);
  modeChangeType_t mode = modelModelUpdatableContinuous->evalMode(0);
  ASSERT_EQ(mode, NO_MODE);

  modelModelUpdatableContinuous->setParameterValue(UPDATABLE_INPUT_NAME, DYN::FINAL, 2.5, false);
  modelModelUpdatableContinuous->setSubModelParameters();
  modelModelUpdatableContinuous->evalG(0);
  mode = modelModelUpdatableContinuous->evalMode(0);
  ASSERT_EQ(mode, ALGEBRAIC_MODE);

  modelModelUpdatableContinuous->evalG(0);
  mode = modelModelUpdatableContinuous->evalMode(0);
  ASSERT_EQ(mode, NO_MODE);

  modelModelUpdatableContinuous->setParameterValue(UPDATABLE_INPUT_NAME, DYN::FINAL, 3.1, false);
  modelModelUpdatableContinuous->setSubModelParameters();
  modelModelUpdatableContinuous->evalG(0);
  mode = modelModelUpdatableContinuous->evalMode(0);
  ASSERT_EQ(mode, ALGEBRAIC_MODE);
}

}  // namespace DYN
