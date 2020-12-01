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
 * @file API/DYD/test/TestCollection.cpp
 * @brief Unit tests for API_DYD
 *
 */

#include "gtest_dynawo.h"

#include "DYDDynamicModelsCollectionFactory.h"
#include "DYDBlackBoxModelFactory.h"
#include "DYDBlackBoxModel.h"
#include "DYDModelTemplateFactory.h"
#include "DYDModelTemplate.h"
#include "DYDMacroConnectFactory.h"
#include "DYDMacroConnect.h"
#include "DYDMacroConnectorFactory.h"
#include "DYDMacroConnector.h"
#include "DYDMacroStaticReferenceFactory.h"
#include "DYDMacroStaticReference.h"
#include "DYDIterators.h"
#include "DYDConnector.h"
#include "DYDStaticRef.h"
#include "DYDMacroStaticRef.h"
#include "DYDMacroStaticRefFactory.h"


namespace dynamicdata {

//-----------------------------------------------------
// TEST for Dynamic Models collection
//-----------------------------------------------------

TEST(APIDYDTest, CollectionCreate) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  boost::shared_ptr<BlackBoxModel> model = BlackBoxModelFactory::newModel("blackBoxModel");
  boost::shared_ptr<ModelTemplate> model1 = ModelTemplateFactory::newModel("modelTemplate");

  collection->addModel(model);
  collection->addModel(model1);
  int nbModels = 0;
  for (dynamicModel_iterator itModel = collection->beginModel();
          itModel != collection->endModel();
          ++itModel)
    ++nbModels;

  ASSERT_EQ(nbModels, 2);
  dynamicModel_iterator itModel(collection->beginModel());
  ASSERT_EQ((++itModel)->get()->getId(), model1.get()->getId());
  ASSERT_EQ((--itModel)->get()->getId(), model.get()->getId());
  ASSERT_EQ((*itModel++)->getId(), model.get()->getId());
  ASSERT_EQ((*itModel--)->getId(), model1.get()->getId());
}

TEST(APIDYDTest, CollectionCopy) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  boost::shared_ptr<BlackBoxModel> model = BlackBoxModelFactory::newModel("blackBoxModel");
  boost::shared_ptr<ModelTemplate> model1 = ModelTemplateFactory::newModel("modelTemplate");

  collection->addModel(model);
  collection->addModel(model1);

  boost::shared_ptr<DynamicModelsCollection> collection1;
  collection1 = DynamicModelsCollectionFactory::copyCollection(collection);

  int nbModels = 0;
  for (dynamicModel_iterator itModel = collection1->beginModel();
          itModel != collection1->endModel();
          ++itModel)
    ++nbModels;

  ASSERT_EQ(nbModels, 2);

  nbModels = 0;
  for (dynamicModel_const_iterator itModel = collection1->cbeginModel();
      itModel != collection1->cendModel();
      ++itModel)
    ++nbModels;

  ASSERT_EQ(nbModels, 2);
}

TEST(APIDYDTest, CollectionSameModel) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  boost::shared_ptr<BlackBoxModel> model = BlackBoxModelFactory::newModel("blackBoxModel");
  collection->addModel(model);
  ASSERT_THROW_DYNAWO(collection->addModel(model), DYN::Error::API, DYN::KeyError_t::ModelIDNotUnique);  // model already stored
}

TEST(APIDYDTest, CollectionAddConnect) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  collection->addConnect("model1", "var1", "model2", "var2");
  // no internal connection between same models
  ASSERT_THROW_DYNAWO(collection->addConnect("model1", "var1", "model1", "var2"), DYN::Error::API, DYN::KeyError_t::InternalConnectDoneInSystem);
  collection->addConnect("model1", "var2", "model2", "var1");

  int nbConnect = 0;
  for (connector_iterator itC = collection->beginConnector();
          itC != collection->endConnector();
          ++itC)
    ++nbConnect;

  ASSERT_EQ(nbConnect, 2);
  connector_iterator itC(collection->beginConnector());
  ASSERT_EQ((++itC)->get()->getSecondVariableId(), "var1");
  ASSERT_EQ((--itC)->get()->getSecondVariableId(), "var2");
  ASSERT_EQ((*itC++)->getSecondVariableId(), "var2");
  ASSERT_EQ((*itC--)->getSecondVariableId(), "var1");

  nbConnect = 0;
  for (connector_const_iterator itC2 = collection->cbeginConnector();
      itC2 != collection->cendConnector();
      ++itC2)
    ++nbConnect;

  ASSERT_EQ(nbConnect, 2);
}

TEST(APIDYDTest, CollectionAddMacroConnector) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  boost::shared_ptr<MacroConnector> mc1 = MacroConnectorFactory::newMacroConnector("mc1");
  boost::shared_ptr<MacroConnector> mc2 = MacroConnectorFactory::newMacroConnector("mc2");

  collection->addMacroConnector(mc1);
  collection->addMacroConnector(mc2);

  int nbMacroConnectors = 0;
  for (macroConnector_iterator itMC = collection->beginMacroConnector();
          itMC != collection->endMacroConnector();
          ++itMC)
    ++nbMacroConnectors;

  ASSERT_EQ(nbMacroConnectors, 2);
  macroConnector_iterator itC(collection->beginMacroConnector());
  ASSERT_EQ((++itC)->get()->getId(), "mc2");
  ASSERT_EQ((--itC)->get()->getId(), "mc1");
  ASSERT_EQ((*itC++)->getId(), "mc1");
  ASSERT_EQ((*itC--)->getId(), "mc2");

  nbMacroConnectors = 0;
  for (macroConnector_const_iterator itMC = collection->cbeginMacroConnector();
      itMC != collection->cendMacroConnector();
      ++itMC)
    ++nbMacroConnectors;

  ASSERT_EQ(nbMacroConnectors, 2);
}

TEST(APIDYDTest, CollectionAddMacroConnectorNotUnique) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  boost::shared_ptr<MacroConnector> mc1 = MacroConnectorFactory::newMacroConnector("mc1");
  boost::shared_ptr<MacroConnector> mc2 = MacroConnectorFactory::newMacroConnector("mc1");

  collection->addMacroConnector(mc1);
  ASSERT_THROW_DYNAWO(collection->addMacroConnector(mc2), DYN::Error::API, DYN::KeyError_t::MacroConnectorIDNotUnique);
}

TEST(APIDYDTest, CollectionFindMacroConnector) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  boost::shared_ptr<MacroConnector> mc1 = MacroConnectorFactory::newMacroConnector("mc1");
  boost::shared_ptr<MacroConnector> mc2 = MacroConnectorFactory::newMacroConnector("mc2");
  boost::shared_ptr<MacroConnector> mc3 = MacroConnectorFactory::newMacroConnector("mc3");

  collection->addMacroConnector(mc1);
  collection->addMacroConnector(mc2);
  collection->addMacroConnector(mc3);
  ASSERT_NO_THROW(collection->findMacroConnector("mc2"));
  ASSERT_THROW_DYNAWO(collection->findMacroConnector("mc4"), DYN::Error::API, DYN::KeyError_t::MacroConnectorUndefined);
}

TEST(APIDYDTest, CollectionAddMacroConnect) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  boost::shared_ptr<MacroConnect> mc1 = MacroConnectFactory::newMacroConnect("mc1", "model1", "model2");
  boost::shared_ptr<MacroConnect> mc2 = MacroConnectFactory::newMacroConnect("mc2", "model1", "model2");

  collection->addMacroConnect(mc1);
  collection->addMacroConnect(mc2);

  int nbMacroConnects = 0;
  for (macroConnect_iterator itMC = collection->beginMacroConnect();
          itMC != collection->endMacroConnect();
          ++itMC)
    ++nbMacroConnects;

  ASSERT_EQ(nbMacroConnects, 2);
  macroConnect_iterator itC(collection->beginMacroConnect());
  ASSERT_EQ((++itC)->get()->getConnector(), "mc2");
  ASSERT_EQ((--itC)->get()->getConnector(), "mc1");
  ASSERT_EQ((*itC++)->getConnector(), "mc1");
  ASSERT_EQ((*itC--)->getConnector(), "mc2");

  nbMacroConnects = 0;
  for (macroConnect_const_iterator itMC = collection->cbeginMacroConnect();
      itMC != collection->cendMacroConnect();
      ++itMC)
    ++nbMacroConnects;

  ASSERT_EQ(nbMacroConnects, 2);
}

TEST(APIDYDTest, CollectionMacroStaticReference) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  boost::shared_ptr<MacroStaticReference> mStRef1 = MacroStaticReferenceFactory::newMacroStaticReference("mStRef1");
  boost::shared_ptr<MacroStaticReference> mStRef2 = MacroStaticReferenceFactory::newMacroStaticReference("mStRef2");
  boost::shared_ptr<MacroStaticReference> mStRef3 = MacroStaticReferenceFactory::newMacroStaticReference("mStRef3");
  boost::shared_ptr<MacroStaticReference> mStRef11 = MacroStaticReferenceFactory::newMacroStaticReference("mStRef1");

  // addMacroStaticReference
  ASSERT_NO_THROW(collection->addMacroStaticReference(mStRef1));
  ASSERT_NO_THROW(collection->addMacroStaticReference(mStRef2));
  ASSERT_NO_THROW(collection->addMacroStaticReference(mStRef3));
  ASSERT_THROW_DYNAWO(collection->addMacroStaticReference(mStRef11), DYN::Error::API, DYN::KeyError_t::MacroStaticReferenceNotUnique);

  int nbMacroStaticReferences = 0;
  for (macroStaticReference_iterator itMStRef = collection->beginMacroStaticReference();
      itMStRef != collection->endMacroStaticReference();
      ++itMStRef)
    ++nbMacroStaticReferences;
  ASSERT_EQ(nbMacroStaticReferences, 3);
  macroStaticReference_iterator itC(collection->beginMacroStaticReference());
  ASSERT_EQ((++itC)->get()->getId(), mStRef2->getId());
  ASSERT_EQ((--itC)->get()->getId(), mStRef1->getId());
  ASSERT_EQ((*itC++)->getId(), mStRef1->getId());
  ASSERT_EQ((*itC--)->getId(), mStRef2->getId());

  nbMacroStaticReferences = 0;
  for (macroStaticReference_const_iterator itMStRef = collection->cbeginMacroStaticReference();
          itMStRef != collection->cendMacroStaticReference();
          ++itMStRef)
    ++nbMacroStaticReferences;
  ASSERT_EQ(nbMacroStaticReferences, 3);

  // findMacroStaticReference
  ASSERT_NO_THROW(collection->findMacroStaticReference("mStRef1"));
  ASSERT_THROW_DYNAWO(collection->findMacroStaticReference("mStRef4"), DYN::Error::API, DYN::KeyError_t::MacroStaticReferenceUndefined);
}

TEST(APIDYDTest, StaticRefIterators) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  boost::shared_ptr<BlackBoxModel> model = BlackBoxModelFactory::newModel("blackBoxModel");

  collection->addModel(model);
  model->addStaticRef("MyVar", "MyStaticVar");
  model->addStaticRef("MyVar2", "MyStaticVar2");

  int nbStaticReferences = 0;
  for (staticRef_iterator it = model->beginStaticRef(), itEnd = model->endStaticRef(); it != itEnd; ++it)
    ++nbStaticReferences;
  ASSERT_EQ(nbStaticReferences, 2);
  staticRef_iterator itC(model->beginStaticRef());
  ASSERT_EQ((++itC)->get()->getModelVar(), "MyVar");
  ASSERT_EQ((--itC)->get()->getModelVar(), "MyVar2");
  ASSERT_EQ((*itC++)->getModelVar(), "MyVar2");
  ASSERT_EQ((*itC--)->getModelVar(), "MyVar");

  nbStaticReferences = 0;
  for (staticRef_const_iterator it = model->cbeginStaticRef(), itEnd = model->cendStaticRef(); it != itEnd; ++it)
    ++nbStaticReferences;
  ASSERT_EQ(nbStaticReferences, 2);
}

TEST(APIDYDTest, MacroStaticRefIterators) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  boost::shared_ptr<BlackBoxModel> model = BlackBoxModelFactory::newModel("blackBoxModel");

  collection->addModel(model);
  boost::shared_ptr<MacroStaticRef> macroStaticRef = MacroStaticRefFactory::newMacroStaticRef("MyMacroStaticRef");
  model->addMacroStaticRef(macroStaticRef);
  boost::shared_ptr<MacroStaticRef> macroStaticRef2 = MacroStaticRefFactory::newMacroStaticRef("MyMacroStaticRef2");
  model->addMacroStaticRef(macroStaticRef2);

  int nbMacroStaticReferences = 0;
  for (macroStaticRef_iterator it = model->beginMacroStaticRef(), itEnd = model->endMacroStaticRef(); it != itEnd; ++it)
    ++nbMacroStaticReferences;
  ASSERT_EQ(nbMacroStaticReferences, 2);
  macroStaticRef_iterator itC(model->beginMacroStaticRef());
  ASSERT_EQ((++itC)->get()->getId(), "MyMacroStaticRef2");
  ASSERT_EQ((--itC)->get()->getId(), "MyMacroStaticRef");
  ASSERT_EQ((*itC++)->getId(), "MyMacroStaticRef");
  ASSERT_EQ((*itC--)->getId(), "MyMacroStaticRef2");

  nbMacroStaticReferences = 0;
  for (macroStaticRef_const_iterator it = model->cbeginMacroStaticRef(), itEnd = model->cendMacroStaticRef(); it != itEnd; ++it)
    ++nbMacroStaticReferences;
  ASSERT_EQ(nbMacroStaticReferences, 2);
}

}  // namespace dynamicdata
