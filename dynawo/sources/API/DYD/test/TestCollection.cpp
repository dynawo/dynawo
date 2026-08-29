//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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

  std::shared_ptr<BlackBoxModel> model = BlackBoxModelFactory::newModel("blackBoxModel");
  std::shared_ptr<ModelTemplate> model1 = ModelTemplateFactory::newModel("modelTemplate");

  collection->addModel(model);
  collection->addModel(model1);
  const auto nbModels = collection->getModels().size();
  ASSERT_EQ(nbModels, 2);
}

TEST(APIDYDTest, CollectionCopy) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  std::unique_ptr<BlackBoxModel> model = BlackBoxModelFactory::newModel("blackBoxModel");
  std::unique_ptr<ModelTemplate> model1 = ModelTemplateFactory::newModel("modelTemplate");

  collection->addModel(std::move(model));
  collection->addModel(std::move(model1));

  boost::shared_ptr<DynamicModelsCollection> collection1;
  collection1 = DynamicModelsCollectionFactory::copyCollection(collection);

  const auto nbModels = collection1->getModels().size();
  ASSERT_EQ(nbModels, 2);
}

TEST(APIDYDTest, CollectionSameModel) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  std::shared_ptr<BlackBoxModel> model = BlackBoxModelFactory::newModel("blackBoxModel");
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

  const auto nbConnect = collection->getConnectors().size();
  ASSERT_EQ(nbConnect, 2);
}

TEST(APIDYDTest, CollectionAddMacroConnector) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  std::unique_ptr<MacroConnector> mc1 = MacroConnectorFactory::newMacroConnector("mc1");
  std::unique_ptr<MacroConnector> mc2 = MacroConnectorFactory::newMacroConnector("mc2");

  collection->addMacroConnector(std::move(mc1));
  collection->addMacroConnector(std::move(mc2));

  const auto nbMacroConnectors = collection->getMacroConnectors().size();
  ASSERT_EQ(nbMacroConnectors, 2);
}

TEST(APIDYDTest, CollectionAddMacroConnectorNotUnique) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  std::unique_ptr<MacroConnector> mc1 = MacroConnectorFactory::newMacroConnector("mc1");
  std::unique_ptr<MacroConnector> mc2 = MacroConnectorFactory::newMacroConnector("mc1");

  collection->addMacroConnector(std::move(mc1));
  ASSERT_THROW_DYNAWO(collection->addMacroConnector(std::move(mc2)), DYN::Error::API, DYN::KeyError_t::MacroConnectorIDNotUnique);
}

TEST(APIDYDTest, CollectionFindMacroConnector) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  std::unique_ptr<MacroConnector> mc1 = MacroConnectorFactory::newMacroConnector("mc1");
  std::unique_ptr<MacroConnector> mc2 = MacroConnectorFactory::newMacroConnector("mc2");
  std::unique_ptr<MacroConnector> mc3 = MacroConnectorFactory::newMacroConnector("mc3");

  collection->addMacroConnector(std::move(mc1));
  collection->addMacroConnector(std::move(mc2));
  collection->addMacroConnector(std::move(mc3));
  ASSERT_NO_THROW(collection->findMacroConnector("mc2"));
  ASSERT_THROW_DYNAWO(collection->findMacroConnector("mc4"), DYN::Error::API, DYN::KeyError_t::MacroConnectorUndefined);
}

TEST(APIDYDTest, CollectionAddMacroConnect) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  std::unique_ptr<MacroConnect> mc1 = MacroConnectFactory::newMacroConnect("mc1", "model1", "model2");
  std::unique_ptr<MacroConnect> mc2 = MacroConnectFactory::newMacroConnect("mc2", "model1", "model2");

  collection->addMacroConnect(std::move(mc1));
  collection->addMacroConnect(std::move(mc2));

  const auto nbMacroConnects = collection->getMacroConnects().size();
  ASSERT_EQ(nbMacroConnects, 2);
}

TEST(APIDYDTest, CollectionMacroStaticReference) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  std::shared_ptr<MacroStaticReference> mStRef1 = MacroStaticReferenceFactory::newMacroStaticReference("mStRef1");
  std::shared_ptr<MacroStaticReference> mStRef2 = MacroStaticReferenceFactory::newMacroStaticReference("mStRef2");
  std::unique_ptr<MacroStaticReference> mStRef3 = MacroStaticReferenceFactory::newMacroStaticReference("mStRef3");
  std::unique_ptr<MacroStaticReference> mStRef11 = MacroStaticReferenceFactory::newMacroStaticReference("mStRef1");

  // addMacroStaticReference
  ASSERT_NO_THROW(collection->addMacroStaticReference(mStRef1));
  ASSERT_NO_THROW(collection->addMacroStaticReference(mStRef2));
  ASSERT_NO_THROW(collection->addMacroStaticReference(std::move(mStRef3)));
  ASSERT_THROW_DYNAWO(collection->addMacroStaticReference(std::move(mStRef11)), DYN::Error::API, DYN::KeyError_t::MacroStaticReferenceNotUnique);

  const auto nbMacroStaticReferences = collection->getMacroStaticReferences().size();
  ASSERT_EQ(nbMacroStaticReferences, 3);

  // findMacroStaticReference
  ASSERT_NO_THROW(collection->findMacroStaticReference("mStRef1"));
  ASSERT_THROW_DYNAWO(collection->findMacroStaticReference("mStRef4"), DYN::Error::API, DYN::KeyError_t::MacroStaticReferenceUndefined);
}

TEST(APIDYDTest, StaticRefIterators) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  std::shared_ptr<BlackBoxModel> model = BlackBoxModelFactory::newModel("blackBoxModel");

  collection->addModel(model);
  model->addStaticRef("MyVar", "MyStaticVar");
  model->addStaticRef("MyVar2", "MyStaticVar2");

  const auto nbStaticReferences = model->getStaticRefs().size();
  ASSERT_EQ(nbStaticReferences, 2);
}

TEST(APIDYDTest, MacroStaticRefIterators) {
  boost::shared_ptr<DynamicModelsCollection> collection;
  collection = boost::shared_ptr<DynamicModelsCollection>(DynamicModelsCollectionFactory::newCollection());

  std::shared_ptr<BlackBoxModel> model = BlackBoxModelFactory::newModel("blackBoxModel");

  collection->addModel(model);
  std::unique_ptr<MacroStaticRef> macroStaticRef = MacroStaticRefFactory::newMacroStaticRef("MyMacroStaticRef");
  model->addMacroStaticRef(std::move(macroStaticRef));
  std::unique_ptr<MacroStaticRef> macroStaticRef2 = MacroStaticRefFactory::newMacroStaticRef("MyMacroStaticRef2");
  model->addMacroStaticRef(std::move(macroStaticRef2));

  const auto nbMacroStaticReferences = model->getMacroStaticRefs().size();
  ASSERT_EQ(nbMacroStaticReferences, 2);
}

}  // namespace dynamicdata
