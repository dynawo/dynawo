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
 * @file Models/CPP/Updatables/UpdatableBoolean/TestUpdatableBoolean
 * @brief Unit tests for UpdatableBoolean model
 *
 */

#include <boost/shared_ptr.hpp>

#include "DYNElement.h"
#include "DYNUpdatableBoolean.h"
#include "DYNUpdatableBoolean.hpp"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"
#include "DYNSubModel.h"
#include "DYNVariable.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> initModelUpdatableBoolean() {
  boost::shared_ptr<SubModel> modelUpdatableBoolean =
      SubModelFactory::createSubModelFromLib("../DYNUpdatableBoolean" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelUpdatableBoolean->defineParameters(parameters);
  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter(UPDATABLE_INPUT_NAME, true);
  modelUpdatableBoolean->setPARParameters(parametersSet);
  modelUpdatableBoolean->addParameters(parameters, false);
  modelUpdatableBoolean->setParametersFromPARFile();
  modelUpdatableBoolean->setSubModelParameters();
  modelUpdatableBoolean->getSize();

  return modelUpdatableBoolean;
}

TEST(ModelsModelUpdatableBoolean, ModelUpdatableBooleanDefineMethods) {
  boost::shared_ptr<SubModel> modelUpdatableBoolean = SubModelFactory::createSubModelFromLib("../DYNUpdatableBoolean" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelUpdatableBoolean->defineParameters(parameters);
  ASSERT_EQ(parameters.size(), 1);

  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter(UPDATABLE_INPUT_NAME, true);
  ASSERT_NO_THROW(modelUpdatableBoolean->setPARParameters(parametersSet));

  modelUpdatableBoolean->addParameters(parameters, false);
  ASSERT_NO_THROW(modelUpdatableBoolean->setParametersFromPARFile());
  ASSERT_NO_THROW(modelUpdatableBoolean->setSubModelParameters());

  std::vector<boost::shared_ptr<Variable> > variables;
  modelUpdatableBoolean->defineVariables(variables);
  ASSERT_EQ(variables.size(), 1);
  boost::shared_ptr<Variable> variableUpdatableBoolean = variables[0];
  ASSERT_EQ(variableUpdatableBoolean->getName(), UPDATABLE_INPUT_NAME);
  ASSERT_EQ(variableUpdatableBoolean->getType(), BOOLEAN);
  ASSERT_EQ(variableUpdatableBoolean->getNegated(), false);
  ASSERT_EQ(variableUpdatableBoolean->isState(), false);
  ASSERT_EQ(variableUpdatableBoolean->isAlias(), false);

  std::vector<Element> elements;
  std::map<std::string, int> mapElements;
  modelUpdatableBoolean->defineElements(elements, mapElements);
  ASSERT_EQ(elements.size(), mapElements.size());
  ASSERT_EQ(elements.size(), 1);
  Element element = elements[0];
  ASSERT_EQ(element.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(element.name(), element.id());
  ASSERT_EQ(element.name(), UPDATABLE_INPUT_NAME);
  ASSERT_EQ(mapElements[UPDATABLE_INPUT_NAME], 0);
}

TEST(ModelsModelUpdatableBoolean, ModelUpdatableBooleanTypeMethods) {
  boost::shared_ptr<SubModel> modelUpdatableBoolean = initModelUpdatableBoolean();
  unsigned nbY = 0;
  unsigned nbF = 0;
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  modelUpdatableBoolean->setBufferYType(&yTypes[0], 0);
  modelUpdatableBoolean->setBufferFType(&fTypes[0], 0);

  ASSERT_EQ(modelUpdatableBoolean->sizeY(), nbY);
  ASSERT_EQ(modelUpdatableBoolean->sizeF(), nbF);
  ASSERT_EQ(modelUpdatableBoolean->sizeZ(), 0);
  ASSERT_EQ(modelUpdatableBoolean->sizeG(), 1);
  ASSERT_EQ(modelUpdatableBoolean->sizeMode(), 1);

  ASSERT_NO_THROW(modelUpdatableBoolean->dumpUserReadableElementList("MyElement"));
}

TEST(ModelsModelUpdatableBoolean, ModelUpdatableBooleanUpdate) {
  boost::shared_ptr<SubModel> modelUpdatableBoolean = initModelUpdatableBoolean();
  std::vector<state_g> g(modelUpdatableBoolean->sizeG(), ROOT_DOWN);
  modelUpdatableBoolean->setBufferG(&g[0], 0);
  modelUpdatableBoolean->evalG(0);
  modeChangeType_t mode = modelUpdatableBoolean->evalMode(0);
  ASSERT_EQ(mode, NO_MODE);

  modelUpdatableBoolean->setParameterValue(UPDATABLE_INPUT_NAME, DYN::FINAL, true, false);
  modelUpdatableBoolean->setSubModelParameters();
  modelUpdatableBoolean->evalG(0);
  mode = modelUpdatableBoolean->evalMode(0);
  ASSERT_EQ(mode, ALGEBRAIC_MODE);

  modelUpdatableBoolean->evalG(0);
  mode = modelUpdatableBoolean->evalMode(0);
  ASSERT_EQ(mode, NO_MODE);

  modelUpdatableBoolean->setParameterValue(UPDATABLE_INPUT_NAME, DYN::FINAL, false, false);
  modelUpdatableBoolean->setSubModelParameters();
  modelUpdatableBoolean->evalG(0);
  mode = modelUpdatableBoolean->evalMode(0);
  ASSERT_EQ(mode, ALGEBRAIC_MODE);
}

}  // namespace DYN
