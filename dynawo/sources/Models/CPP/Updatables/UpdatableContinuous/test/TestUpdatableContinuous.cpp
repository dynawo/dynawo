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
 * @file Models/CPP/Updatables/UpdatableContinuous/TestUpdatableContinuous
 * @brief Unit tests for UpdatableContinuous model
 *
 */

#include <boost/shared_ptr.hpp>

#include "DYNElement.h"
#include "DYNUpdatableContinuous.h"
#include "DYNUpdatableContinuous.hpp"
#include "DYNParameterModeler.h"
#include "DYNSparseMatrix.h"
#include "DYNSubModel.h"
#include "DYNVariable.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"

#include "gtest_dynawo.h"

namespace DYN {

static boost::shared_ptr<SubModel> initModelUpdatableContinuous() {
  boost::shared_ptr<SubModel> modelUpdatableContinuous =
      SubModelFactory::createSubModelFromLib("../DYNUpdatableContinuous" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelUpdatableContinuous->defineParameters(parameters);
  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter(UPDATABLE_INPUT_NAME, 1.2);
  modelUpdatableContinuous->setPARParameters(parametersSet);
  modelUpdatableContinuous->addParameters(parameters, false);
  modelUpdatableContinuous->setParametersFromPARFile();
  modelUpdatableContinuous->setSubModelParameters();

  modelUpdatableContinuous->getSize();

  return modelUpdatableContinuous;
}

TEST(ModelsModelUpdatableContinuous, ModelUpdatableContinuousDefineMethods) {
  boost::shared_ptr<SubModel> modelUpdatableContinuous = SubModelFactory::createSubModelFromLib("../DYNUpdatableContinuous" + std::string(sharedLibraryExtension()));

  std::vector<ParameterModeler> parameters;
  modelUpdatableContinuous->defineParameters(parameters);
  ASSERT_EQ(parameters.size(), 1);

  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("Parameterset");
  parametersSet->createParameter(UPDATABLE_INPUT_NAME, 1.5);
  ASSERT_NO_THROW(modelUpdatableContinuous->setPARParameters(parametersSet));

  modelUpdatableContinuous->addParameters(parameters, false);
  ASSERT_NO_THROW(modelUpdatableContinuous->setParametersFromPARFile());
  ASSERT_NO_THROW(modelUpdatableContinuous->setSubModelParameters());

  std::vector<boost::shared_ptr<Variable> > variables;
  modelUpdatableContinuous->defineVariables(variables);
  ASSERT_EQ(variables.size(), 1);
  boost::shared_ptr<Variable> variableUpdatableContinuous = variables[0];
  ASSERT_EQ(variableUpdatableContinuous->getName(), UPDATABLE_INPUT_NAME);
  ASSERT_EQ(variableUpdatableContinuous->getType(), CONTINUOUS);
  ASSERT_EQ(variableUpdatableContinuous->getNegated(), false);
  ASSERT_EQ(variableUpdatableContinuous->isState(), false);
  ASSERT_EQ(variableUpdatableContinuous->isAlias(), false);

  std::vector<Element> elements;
  std::map<std::string, int> mapElements;
  modelUpdatableContinuous->defineElements(elements, mapElements);
  ASSERT_EQ(elements.size(), mapElements.size());
  ASSERT_EQ(elements.size(), 1);
  Element element = elements[0];
  ASSERT_EQ(element.getTypeElement(), Element::TERMINAL);
  ASSERT_EQ(element.name(), element.id());
  ASSERT_EQ(element.name(), UPDATABLE_INPUT_NAME);
  ASSERT_EQ(mapElements[UPDATABLE_INPUT_NAME], 0);
}

TEST(ModelsModelUpdatableContinuous, ModelUpdatableContinuousTypeMethods) {
  boost::shared_ptr<SubModel> modelUpdatableContinuous = initModelUpdatableContinuous();
  unsigned nbY = 0;
  unsigned nbF = 0;
  std::vector<propertyContinuousVar_t> yTypes(nbY, UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(nbF, UNDEFINED_EQ);
  std::vector<state_g> g(modelUpdatableContinuous->sizeG(), ROOT_DOWN);
  modelUpdatableContinuous->setBufferYType(&yTypes[0], 0);
  modelUpdatableContinuous->setBufferFType(&fTypes[0], 0);
  ASSERT_EQ(modelUpdatableContinuous->sizeY(), nbY);
  ASSERT_EQ(modelUpdatableContinuous->sizeF(), nbF);
  ASSERT_EQ(modelUpdatableContinuous->sizeZ(), 0);
  ASSERT_EQ(modelUpdatableContinuous->sizeG(), 1);
  ASSERT_EQ(modelUpdatableContinuous->sizeMode(), 1);

  ASSERT_NO_THROW(modelUpdatableContinuous->dumpUserReadableElementList("MyElement"));
}

TEST(ModelsModelUpdatableContinuous, ModelUpdatableContinuousUpdate) {
  boost::shared_ptr<SubModel> modelUpdatableContinuous = initModelUpdatableContinuous();
  std::vector<state_g> g(modelUpdatableContinuous->sizeG(), ROOT_DOWN);
  modelUpdatableContinuous->setBufferG(&g[0], 0);
  modelUpdatableContinuous->evalG(0);
  modeChangeType_t mode = modelUpdatableContinuous->evalMode(0);
  ASSERT_EQ(mode, NO_MODE);

  modelUpdatableContinuous->setParameterValue(UPDATABLE_INPUT_NAME, DYN::FINAL, 2.5, false);
  modelUpdatableContinuous->setSubModelParameters();
  modelUpdatableContinuous->evalG(0);
  mode = modelUpdatableContinuous->evalMode(0);
  ASSERT_EQ(mode, ALGEBRAIC_MODE);

  modelUpdatableContinuous->evalG(0);
  mode = modelUpdatableContinuous->evalMode(0);
  ASSERT_EQ(mode, NO_MODE);

  modelUpdatableContinuous->setParameterValue(UPDATABLE_INPUT_NAME, DYN::FINAL, 3.1, false);
  modelUpdatableContinuous->setSubModelParameters();
  modelUpdatableContinuous->evalG(0);
  mode = modelUpdatableContinuous->evalMode(0);
  ASSERT_EQ(mode, ALGEBRAIC_MODE);
}

}  // namespace DYN
