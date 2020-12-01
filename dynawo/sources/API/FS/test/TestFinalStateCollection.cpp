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
 * @file API/FS/test/TestFinalStateCollection.cpp
 * @brief Unit tests for API_FS
 *
 */

#include "gtest_dynawo.h"

#include "FSFinalStateCollection.h"
#include "FSFinalStateCollectionFactory.h"
#include "FSVariable.h"
#include "FSVariableFactory.h"
#include "FSModel.h"
#include "FSModelFactory.h"
#include "FSIterators.h"
#include "FSXmlExporter.h"

namespace finalState {

//-----------------------------------------------------
// TEST check final state collection factory
//-----------------------------------------------------

TEST(APIFSTest, FinalStateCollectionFactory) {
  boost::shared_ptr<FinalStateCollection> collection1 = FinalStateCollectionFactory::newInstance("collection");

  boost::shared_ptr<FinalStateCollection> collection2;
  boost::shared_ptr<FinalStateCollection> collection3;

  FinalStateCollection& refCollection1(*collection1);

  ASSERT_NO_THROW(collection2 = FinalStateCollectionFactory::copyInstance(collection1));
  ASSERT_NO_THROW(collection3 = FinalStateCollectionFactory::copyInstance(refCollection1));
}

//-----------------------------------------------------
// TEST add several variables to a final state collection
//-----------------------------------------------------

TEST(APIFSTest, FinalStateCollectionAddVariable) {
  boost::shared_ptr<FinalStateCollection> collection = FinalStateCollectionFactory::newInstance("collection");

  // add variables
  boost::shared_ptr<Variable> variable1 = VariableFactory::newVariable("var1");
  variable1->setValue(12.);
  boost::shared_ptr<Variable> variable2 = VariableFactory::newVariable("var2");
  collection->addVariable(variable1);
  collection->addVariable(variable2);

  // test const iterator
  int nbVariables = 0;
  for (finalStateVariable_const_iterator itVariable = collection->cbeginVariable();
          itVariable != collection->cendVariable();
          ++itVariable)
    ++nbVariables;
  ASSERT_EQ(nbVariables, 2);

  // test iterator
  nbVariables = 0;
  for (finalStateVariable_iterator itVariable = collection->beginVariable();
          itVariable != collection->endVariable();
          ++itVariable)
    ++nbVariables;
  ASSERT_EQ(nbVariables, 2);

  finalStateVariable_iterator itVariable(collection->beginVariable());
  ASSERT_EQ((++itVariable)->get()->getId(), variable2->getId());
  ASSERT_EQ((--itVariable)->get()->getId(), variable1->getId());
  ASSERT_EQ((itVariable++)->get()->getId(), variable1->getId());
  ASSERT_EQ((itVariable--)->get()->getId(), variable2->getId());
  finalStateVariable_iterator itVariable2 = collection->endVariable();
  itVariable2 = itVariable;
  ASSERT_TRUE(itVariable2 == itVariable);
  ASSERT_TRUE(*itVariable2 == *itVariable);

  XmlExporter exporter;
  ASSERT_NO_THROW(exporter.exportToFile(collection, "finalStateMultipleVariables.xml"));
}

//-----------------------------------------------------
// TEST add several models to a final state collection
//-----------------------------------------------------

TEST(APIFSTest, FinalStateCollectionAddModel) {
  boost::shared_ptr<FinalStateCollection> collection = FinalStateCollectionFactory::newInstance("collection");

  // add models
  boost::shared_ptr<FinalStateModel> model1 = ModelFactory::newModel("model1");
  // add subModels
  boost::shared_ptr<FinalStateModel> subModel1 = ModelFactory::newModel("subModel1");
  boost::shared_ptr<FinalStateModel> subModel2 = ModelFactory::newModel("subModel2");
  model1->addSubModel(subModel1);
  model1->addSubModel(subModel2);
  // add variables to submodel
  boost::shared_ptr<Variable> variable1 = VariableFactory::newVariable("var1");
  variable1->setValue(12.);
  boost::shared_ptr<Variable> variable2 = VariableFactory::newVariable("var2");
  subModel1->addVariable(variable1);
  subModel1->addVariable(variable2);
  // add second model
  boost::shared_ptr<FinalStateModel> model2 = ModelFactory::newModel("model2");
  collection->addFinalStateModel(model1);
  collection->addFinalStateModel(model2);

  // test const iterator
  int nbModels = 0;
  for (finalStateModel_const_iterator itModel = collection->cbeginFinalStateModel();
          itModel != collection->cendFinalStateModel();
          ++itModel)
    ++nbModels;
  ASSERT_EQ(nbModels, 2);

  // test iterator
  nbModels = 0;
  for (finalStateModel_iterator itModel = collection->beginFinalStateModel();
          itModel != collection->endFinalStateModel();
          ++itModel)
    ++nbModels;
  ASSERT_EQ(nbModels, 2);

  finalStateModel_iterator itVariable(collection->beginFinalStateModel());
  ASSERT_EQ((++itVariable)->get()->getId(), model2->getId());
  ASSERT_EQ((--itVariable)->get()->getId(), model1->getId());
  ASSERT_EQ((itVariable++)->get()->getId(), model1->getId());
  ASSERT_EQ((itVariable--)->get()->getId(), model2->getId());
  finalStateModel_iterator itVariable2 = collection->endFinalStateModel();
  itVariable2 = itVariable;
  ASSERT_TRUE(itVariable2 == itVariable);
  ASSERT_TRUE(*itVariable2 == *itVariable);

  // export
  XmlExporter exporter;
  ASSERT_NO_THROW(exporter.exportToFile(collection, "finalState.xml"));
}

}  // namespace finalState
