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
 * @file API/FS/test/TestModel.cpp
 * @brief Unit tests for API_FS
 *
 */

#include "gtest_dynawo.h"

#include "FSModel.h"
#include "FSModelFactory.h"
#include "FSVariable.h"
#include "FSVariableFactory.h"
#include "FSIterators.h"


namespace finalState {

//-----------------------------------------------------
// TEST check Model set and get functions
//-----------------------------------------------------

TEST(APIFSTest, Model) {
  boost::shared_ptr<FinalStateModel> model = ModelFactory::newModel("model");

  ASSERT_EQ(model->getId(), "model");
  model->setId("model2");
  ASSERT_EQ(model->getId(), "model2");
}

//-----------------------------------------------------
// TEST add several variables to a model
//-----------------------------------------------------

TEST(APIFSTest, ModelAddVariable) {
  boost::shared_ptr<FinalStateModel> model = ModelFactory::newModel("model");

  // add variables
  boost::shared_ptr<Variable> variable1 = VariableFactory::newVariable("var1");
  boost::shared_ptr<Variable> variable2 = VariableFactory::newVariable("var2");
  model->addVariable(variable1);
  model->addVariable(variable2);

  // test const iterator
  int nbVariables = 0;
  for (finalStateVariable_const_iterator itVariable = model->cbeginVariable();
          itVariable != model->cendVariable();
          ++itVariable)
    ++nbVariables;
  ASSERT_EQ(nbVariables, 2);

  // test iterator
  nbVariables = 0;
  for (finalStateVariable_iterator itVariable = model->beginVariable();
          itVariable != model->endVariable();
          ++itVariable)
    ++nbVariables;
  ASSERT_EQ(nbVariables, 2);
}

//-----------------------------------------------------
// TEST add several sub-models to a model
//-----------------------------------------------------

TEST(APIFSTest, ModelAddSubModel) {
  boost::shared_ptr<FinalStateModel> model = ModelFactory::newModel("model");

  // add subModels
  boost::shared_ptr<FinalStateModel> subModel1 = ModelFactory::newModel("subModel1");
  boost::shared_ptr<FinalStateModel> subModel2 = ModelFactory::newModel("subModel2");
  model->addSubModel(subModel1);
  model->addSubModel(subModel2);

  // test const iterator
  int nbModels = 0;
  for (finalStateModel_const_iterator itModel = model->cbeginFinalStateModel();
          itModel != model->cendFinalStateModel();
          ++itModel)
    ++nbModels;
  ASSERT_EQ(nbModels, 2);

  // test iterator
  nbModels = 0;
  for (finalStateModel_iterator itModel = model->beginFinalStateModel();
          itModel != model->endFinalStateModel();
          ++itModel)
    ++nbModels;
  ASSERT_EQ(nbModels, 2);
}

}  // namespace finalState
