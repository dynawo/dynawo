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
 * @file API/DYD/test/TestModelTemplate.cpp
 * @brief Unit tests for API_DYD
 *
 */
#include <map>

#include <boost/shared_ptr.hpp>

#include "gtest_dynawo.h"

#include "DYDDynamicModelsCollectionFactory.h"
#include "DYDModelTemplateFactory.h"
#include "DYDModelTemplate.h"
#include "DYDUnitDynamicModelFactory.h"
#include "DYDUnitDynamicModel.h"
#include "DYDMacroConnectFactory.h"
#include "DYDMacroConnect.h"
#include "DYDXmlImporter.h"
#include "DYDXmlExporter.h"
#include "DYDMacroStaticRefFactory.h"
#include "DYDStaticRef.h"
#include "DYDMacroStaticRef.h"

#include "TestUtil.h"

namespace dynamicdata {
//-----------------------------------------------------
// TEST build, export, import ModelTemplate
//-----------------------------------------------------

TEST(APIDYDTest, ModelTemplateCreate) {
  boost::shared_ptr<DynamicModelsCollection> collection = DynamicModelsCollectionFactory::newCollection();  // reset identifiable

  std::unique_ptr<ModelTemplate> model;
  model = ModelTemplateFactory::newModel("modelTemplate");
  ASSERT_TRUE(model->getUseAliasing());
  ASSERT_TRUE(model->getGenerateCalculatedVariables());
  model->setCompilationOptions(false, false);

  // <dyn:unitDynamicModel id="component1" name="model1" initName="model1_init"/>
  std::shared_ptr<UnitDynamicModel> udm1;
  udm1 = UnitDynamicModelFactory::newModel("component1", "model1");
  udm1->setInitModelName("model1_init");
  // <dyn:unitDynamicModel id="component2" name="model2" initName="model2_init"/>
  std::unique_ptr<UnitDynamicModel> udm2;
  udm2 = UnitDynamicModelFactory::newModel("component2", "model2");
  udm2->setInitModelName("model2_init");

  model->addUnitDynamicModel(udm1);
  model->addUnitDynamicModel(std::move(udm2));

  model->addConnect("component1", "var1", "component2", "var2");
  model->addConnect("component2", "var1", "component1", "var2");

  ASSERT_EQ(model->getConnectors().size(), 2);

  model->addInitConnect("component1", "var1", "component2", "var2");
  model->addInitConnect("component2", "var1", "component1", "var2");

  ASSERT_EQ(model->getInitConnectors().size(), 2);


  ASSERT_THROW_DYNAWO(model->addUnitDynamicModel(udm1), DYN::Error::API, DYN::KeyError_t::ModelIDNotUnique);  // component already exist

  ASSERT_EQ(model->getType(), Model::MODEL_TEMPLATE);
  ASSERT_EQ(model->getId(), "modelTemplate");
  ASSERT_FALSE(model->getUseAliasing());
  ASSERT_FALSE(model->getGenerateCalculatedVariables());
  std::map<std::string, std::shared_ptr<UnitDynamicModel> > udms = model->getUnitDynamicModels();
  ASSERT_EQ(udms.size(), 2);
}

TEST(APIDYDTest, ModelTemplateImport_export) {
  XmlImporter importer;
  boost::shared_ptr<DynamicModelsCollection> collection;
  std::vector<std::string> files;
  files.push_back("res/modelTemplate.xml");
  ASSERT_NO_THROW(collection = importer.importFromDydFiles(files));

  // export
  XmlExporter exporter;
  exporter.exportToFile(collection, "modelTemplateExport.xml");

  ASSERT_EQ(compareFiles("modelTemplateExport.xml", "res/modelTemplate.xml"), true);
}

TEST(APIDYDTest, ModelTemplateBadConnectors) {
  boost::shared_ptr<DynamicModelsCollection> collection = DynamicModelsCollectionFactory::newCollection();  // reset identifiable

  std::unique_ptr<ModelTemplate> model;
  model = ModelTemplateFactory::newModel("modelTemplate");
  std::unique_ptr<UnitDynamicModel> udm1 = UnitDynamicModelFactory::newModel("component1", "model1");
  std::unique_ptr<UnitDynamicModel> udm2 = UnitDynamicModelFactory::newModel("component2", "model2");
  model->addUnitDynamicModel(std::move(udm1));
  model->addUnitDynamicModel(std::move(udm2));

  ASSERT_THROW_DYNAWO(model->addConnect("component1", "var1", "component3", "var2"), DYN::Error::API,
          DYN::KeyError_t::ConnectorNotPartofModel);  // component3 does not exist
  ASSERT_THROW_DYNAWO(model->addConnect("component3", "var1", "component2", "var2"), DYN::Error::API,
          DYN::KeyError_t::ConnectorNotPartofModel);  // component3 does not exist

  ASSERT_THROW_DYNAWO(model->addInitConnect("component1", "var1", "component3", "var2"), DYN::Error::API,
          DYN::KeyError_t::ConnectorNotPartofModel);  // component3 does not exist
  ASSERT_THROW_DYNAWO(model->addInitConnect("component3", "var1", "component2", "var2"), DYN::Error::API,
          DYN::KeyError_t::ConnectorNotPartofModel);  // component3 does not exist
}

TEST(APIDYDTest, ModelTemplateWithMacroConnect) {
  boost::shared_ptr<DynamicModelsCollection> collection = DynamicModelsCollectionFactory::newCollection();  // reset identifiable

  std::unique_ptr<ModelTemplate> model;
  model = ModelTemplateFactory::newModel("modelTemplate");
  std::unique_ptr<UnitDynamicModel> udm1 = UnitDynamicModelFactory::newModel("component1", "model1");
  std::unique_ptr<UnitDynamicModel> udm2 = UnitDynamicModelFactory::newModel("component2", "model2");
  std::unique_ptr<UnitDynamicModel> udm3 = UnitDynamicModelFactory::newModel("component3", "model3");
  model->addUnitDynamicModel(std::move(udm1));
  model->addUnitDynamicModel(std::move(udm2));
  model->addUnitDynamicModel(std::move(udm3));

  std::unique_ptr<MacroConnect> mc1 = MacroConnectFactory::newMacroConnect("mc1", "component1", "component2");
  std::unique_ptr<MacroConnect> mc2 = MacroConnectFactory::newMacroConnect("mc2", "component3", "component2");
  std::unique_ptr<MacroConnect> mc3 = MacroConnectFactory::newMacroConnect("mc3", "component4", "component2");  // model4 does not exist
  std::unique_ptr<MacroConnect> mc4 = MacroConnectFactory::newMacroConnect("mc4", "component2", "component4");  // model4 does not exist
  ASSERT_NO_THROW(model->addMacroConnect(std::move(mc1)));
  ASSERT_NO_THROW(model->addMacroConnect(std::move(mc2)));

  ASSERT_THROW_DYNAWO(model->addMacroConnect(std::move(mc3)), DYN::Error::API, DYN::KeyError_t::MacroConnectNotPartofModel);
  ASSERT_THROW_DYNAWO(model->addMacroConnect(std::move(mc4)), DYN::Error::API, DYN::KeyError_t::MacroConnectNotPartofModel);

  std::map<std::string, std::shared_ptr<MacroConnect> > macroConnects = model->getMacroConnects();
  ASSERT_EQ(macroConnects.size(), 2);

  std::map<std::string, std::shared_ptr<MacroConnect > >::const_iterator iter = macroConnects.begin();
  int index = 0;
  for (; iter != macroConnects.end(); ++iter) {
    if (index == 0)
      ASSERT_EQ(iter->first, "component1_component2");
    else
      ASSERT_EQ(iter->first, "component2_component3");
    ++index;
  }
}

//=======================================================================================
// test macro static ref and static ref iterators
//=======================================================================================

TEST(APIDYDTest, ModelTemplateRefIterators) {
  std::unique_ptr<ModelTemplate> model;
  model = ModelTemplateFactory::newModel("modelTemplate");
  std::unique_ptr<MacroStaticRef> macroStaticRef = MacroStaticRefFactory::newMacroStaticRef("MyMacroStaticRef");
  model->addMacroStaticRef(std::move(macroStaticRef));

  model->addStaticRef("MyVar", "MyStaticVar");
  ASSERT_NO_THROW(model->findMacroStaticRef("MyMacroStaticRef"));
  ASSERT_NO_THROW(model->findStaticRef("MyVar_MyStaticVar"));
  for (const auto& staticrefPair : model->getStaticRefs()) {
    const std::unique_ptr<StaticRef>& ref = staticrefPair.second;
    ASSERT_EQ(ref->getModelVar(), "MyVar");
    ASSERT_EQ(ref->getStaticVar(), "MyStaticVar");
  }
  for (const auto& macroStaticrefPair : model->getMacroStaticRefs()) {
    const std::shared_ptr<MacroStaticRef>& ref = macroStaticrefPair.second;
    ASSERT_EQ(ref->getId(), "MyMacroStaticRef");
  }
}

}  // namespace dynamicdata
