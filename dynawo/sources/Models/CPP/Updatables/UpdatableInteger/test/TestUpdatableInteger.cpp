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
 * @file Models/CPP/Updatables/UpdatableInteger/TestUpdatableInteger
 * @brief Unit tests for UpdatableInteger model
 *
 */

#include <boost/shared_ptr.hpp>

#include "DYNElement.h"
#include "DYNUpdatableInteger.h"
#include "DYNUpdatableInteger.hpp"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"
#include "DYNSubModel.h"
#include "DYNVariable.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> initModelUpdatableInteger() {
  boost::shared_ptr<SubModel> modelUpdatableInteger =
      SubModelFactory::createSubModelFromLib("../DYNUpdatableInteger" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelUpdatableInteger->defineParameters(parameters);
  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter(UPDATABLE_INPUT_NAME, 2);
  modelUpdatableInteger->setPARParameters(parametersSet);
  modelUpdatableInteger->addParameters(parameters, false);
  modelUpdatableInteger->setParametersFromPARFile();
  modelUpdatableInteger->setSubModelParameters();

  modelUpdatableInteger->getSize();

  return modelUpdatableInteger;
}

TEST(ModelsModelUpdatableInteger, ModelUpdatableIntegerDefineMethods) {
  boost::shared_ptr<SubModel> modelUpdatableInteger = SubModelFactory::createSubModelFromLib("../DYNUpdatableInteger" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelUpdatableInteger->defineParameters(parameters);
  ASSERT_EQ(parameters.size(), 1);

  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter(UPDATABLE_INPUT_NAME, 3);
  ASSERT_NO_THROW(modelUpdatableInteger->setPARParameters(parametersSet));

  modelUpdatableInteger->addParameters(parameters, false);
  ASSERT_NO_THROW(modelUpdatableInteger->setParametersFromPARFile());
  ASSERT_NO_THROW(modelUpdatableInteger->setSubModelParameters());

  std::vector<boost::shared_ptr<Variable> > variables;
  modelUpdatableInteger->defineVariables(variables);
  ASSERT_EQ(variables.size(), 1);
  boost::shared_ptr<Variable> variableUpdatableInteger = variables[0];
  ASSERT_EQ(variableUpdatableInteger->getName(), UPDATABLE_INPUT_NAME);
  ASSERT_EQ(variableUpdatableInteger->getType(), INTEGER);
  ASSERT_EQ(variableUpdatableInteger->getNegated(), false);
  ASSERT_EQ(variableUpdatableInteger->isState(), false);
  ASSERT_EQ(variableUpdatableInteger->isAlias(), false);

  std::vector<Element> elements;
  std::map<std::string, int> mapElements;
  modelUpdatableInteger->defineElements(elements, mapElements);
  ASSERT_EQ(elements.size(), mapElements.size());
  ASSERT_EQ(elements.size(), 1);
  Element element = elements[0];
  ASSERT_EQ(element.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(element.name(), element.id());
  ASSERT_EQ(element.name(), UPDATABLE_INPUT_NAME);
  ASSERT_EQ(mapElements[UPDATABLE_INPUT_NAME], 0);
}

TEST(ModelsModelUpdatableInteger, ModelUpdatableIntegerTypeMethods) {
  boost::shared_ptr<SubModel> modelUpdatableInteger = initModelUpdatableInteger();
  unsigned nbY = 0;
  unsigned nbF = 0;
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  modelUpdatableInteger->setBufferYType(&yTypes[0], 0);
  modelUpdatableInteger->setBufferFType(&fTypes[0], 0);

  ASSERT_EQ(modelUpdatableInteger->sizeY(), nbY);
  ASSERT_EQ(modelUpdatableInteger->sizeF(), nbF);
  ASSERT_EQ(modelUpdatableInteger->sizeZ(), 0);
  ASSERT_EQ(modelUpdatableInteger->sizeG(), 1);
  ASSERT_EQ(modelUpdatableInteger->sizeMode(), 1);

  ASSERT_NO_THROW(modelUpdatableInteger->dumpUserReadableElementList("MyElement"));
}

TEST(ModelsModelUpdatableInteger, ModelUpdatableIntegerUpdate) {
  boost::shared_ptr<SubModel> modelUpdatableInteger = initModelUpdatableInteger();
  std::vector<state_g> g(modelUpdatableInteger->sizeG(), ROOT_DOWN);
  modelUpdatableInteger->setBufferG(&g[0], 0);
  modelUpdatableInteger->evalG(0);
  modeChangeType_t mode = modelUpdatableInteger->evalMode(0);
  ASSERT_EQ(mode, NO_MODE);

  modelUpdatableInteger->setParameterValue(UPDATABLE_INPUT_NAME, DYN::FINAL, 5, false);
  modelUpdatableInteger->setSubModelParameters();
  modelUpdatableInteger->evalG(0);
  mode = modelUpdatableInteger->evalMode(0);
  ASSERT_EQ(mode, ALGEBRAIC_MODE);

  modelUpdatableInteger->evalG(0);
  mode = modelUpdatableInteger->evalMode(0);
  ASSERT_EQ(mode, NO_MODE);

  modelUpdatableInteger->setParameterValue(UPDATABLE_INPUT_NAME, DYN::FINAL, 2, false);
  modelUpdatableInteger->setSubModelParameters();
  modelUpdatableInteger->evalG(0);
  mode = modelUpdatableInteger->evalMode(0);
  ASSERT_EQ(mode, ALGEBRAIC_MODE);
}

}  // namespace DYN
