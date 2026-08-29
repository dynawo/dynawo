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
 * @file API/DYD/test/TestModelTemplateExpansion.cpp
 * @brief Unit tests for API_DYD
 *
 */

#include "gtest_dynawo.h"

#include "DYDDynamicModelsCollectionFactory.h"
#include "DYDModelTemplateExpansionFactory.h"
#include "DYDModelTemplateExpansion.h"
#include "DYDXmlImporter.h"
#include "DYDXmlExporter.h"
#include "DYDMacroStaticRefFactory.h"
#include "DYDStaticRef.h"
#include "DYDMacroStaticRef.h"

#include "TestUtil.h"

namespace dynamicdata {
//-----------------------------------------------------
// TEST build, export, import ModelTemplateExpansion
//-----------------------------------------------------

TEST(APIDYDTest, ModelTemplateExpansionCreate) {
  boost::shared_ptr<DynamicModelsCollection> collection = DynamicModelsCollectionFactory::newCollection();

  // create object
  std::unique_ptr<ModelTemplateExpansion> model;
  model = ModelTemplateExpansionFactory::newModel("ModelTemplateExpansion");
  model->setStaticId("staticId");
  model->setParFile("parFile");
  model->setParId("parId");
  model->setTemplateId("templateId");

  ASSERT_EQ(model->getType(), Model::MODEL_TEMPLATE_EXPANSION);
  ASSERT_EQ(model->getId(), "ModelTemplateExpansion");
  ASSERT_EQ(model->getStaticId(), "staticId");
  ASSERT_EQ(model->getParFile(), "parFile");
  ASSERT_EQ(model->getParId(), "parId");
  ASSERT_EQ(model->getTemplateId(), "templateId");
}

TEST(APIDYDTest, ModelTemplateExpansionImport_export) {
  // import
  XmlImporter importer;
  boost::shared_ptr<DynamicModelsCollection> collection;
  std::vector<std::string> files;
  files.push_back("res/templateExpansion.xml");
  ASSERT_NO_THROW(collection = importer.importFromDydFiles(files));

  // export
  XmlExporter exporter;
  exporter.exportToFile(collection, "templateExpansionExport.xml");

  ASSERT_EQ(compareFiles("templateExpansionExport.xml", "res/templateExpansion.xml"), true);
}

//=======================================================================================
// test macro static ref and static ref iterators
//=======================================================================================

TEST(APIDYDTest, ModelTemplateExpansionRefIterators) {
  std::unique_ptr<ModelTemplateExpansion> model;
  model = ModelTemplateExpansionFactory::newModel("ModelTemplateExpansion");
  std::unique_ptr<MacroStaticRef> macroStaticRef = MacroStaticRefFactory::newMacroStaticRef("MyMacroStaticRef");
  model->addMacroStaticRef(std::move(macroStaticRef));

  model->addStaticRef("MyVar", "MyStaticVar");
  ASSERT_NO_THROW(model->findMacroStaticRef("MyMacroStaticRef"));
  ASSERT_NO_THROW(model->findStaticRef("MyVar_MyStaticVar"));
  for (const auto& staticRefPair : model->getStaticRefs()) {
    const std::unique_ptr<StaticRef>& ref = staticRefPair.second;
    ASSERT_EQ(ref->getModelVar(), "MyVar");
    ASSERT_EQ(ref->getStaticVar(), "MyStaticVar");
  }
  for (const auto& macroStaticrefPair : model->getMacroStaticRefs()) {
    const std::shared_ptr<MacroStaticRef>& ref = macroStaticrefPair.second;
    ASSERT_EQ(ref->getId(), "MyMacroStaticRef");
  }
}

}  // namespace dynamicdata
