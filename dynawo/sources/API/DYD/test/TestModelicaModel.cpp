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
 * @file API/DYD/test/TestModelicaModel.cpp
 * @brief Unit tests for API_DYD
 *
 */
#include <map>

#include <boost/shared_ptr.hpp>

#include "gtest_dynawo.h"

#include "DYDDynamicModelsCollectionFactory.h"
#include "DYDModelicaModelFactory.h"
#include "DYDModelicaModel.h"
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
// TEST build, export, import ModelicaModel
//-----------------------------------------------------

TEST(APIDYDTest, ModelicaModel) {
  boost::shared_ptr<DynamicModelsCollection> collection = DynamicModelsCollectionFactory::newCollection();

  std::unique_ptr<ModelicaModel> model;
  model = ModelicaModelFactory::newModel("ModelicaModel");
  model->setStaticId("staticId");
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
  ASSERT_THROW_DYNAWO(model->addUnitDynamicModel(udm1), DYN::Error::API, DYN::KeyError_t::ModelIDNotUnique);  // component already exist

  model->addConnect("component1", "var1", "component2", "var2");
  model->addConnect("component2", "var1", "component1", "var2");

  ASSERT_EQ(model->getConnectors().size(), 2);

  model->addInitConnect("component1", "var1", "component2", "var2");
  model->addInitConnect("component2", "var1", "component1", "var2");

  ASSERT_EQ(model->getInitConnectors().size(), 2);

  ASSERT_EQ(model->getType(), Model::MODELICA_MODEL);
  ASSERT_EQ(model->getId(), "ModelicaModel");
  ASSERT_EQ(model->getStaticId(), "staticId");
  ASSERT_FALSE(model->getUseAliasing());
  ASSERT_FALSE(model->getGenerateCalculatedVariables());
  std::map<std::string, std::shared_ptr<UnitDynamicModel> > udms = model->getUnitDynamicModels();
  ASSERT_EQ(udms.size(), 2);
}

TEST(APIDYDTest, ModelicaModelImport_export) {
  // import
  XmlImporter importer;
  boost::shared_ptr<DynamicModelsCollection> collection;
  std::vector<std::string> files;
  files.push_back("res/modelicaModel.xml");
  ASSERT_NO_THROW(collection = importer.importFromDydFiles(files));

  // export
  XmlExporter exporter;
  exporter.exportToFile(collection, "modelicaModelExport.xml");

  ASSERT_EQ(compareFiles("modelicaModelExport.xml", "res/modelicaModel.xml"), true);
}

TEST(APIDYDTest, ModelicaModelMissingInitName) {
  // import
  XmlImporter importer;
  boost::shared_ptr<DynamicModelsCollection> collection;
  std::vector<std::string> files;
  files.push_back("res/modelicaModelMissingInitName.xml");
  ASSERT_THROW_DYNAWO(collection = importer.importFromDydFiles(files), DYN::Error::API, DYN::KeyError_t::XmlFileParsingError);
}

TEST(APIDYDTest, ModelicaModelBadConnectors) {
  boost::shared_ptr<DynamicModelsCollection> collection = DynamicModelsCollectionFactory::newCollection();  // reset identifiable

  std::unique_ptr<ModelicaModel> model;
  model = ModelicaModelFactory::newModel("modelTemplate");
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

//==================================================
// test equality of models with one unitDynamicModel
//==================================================

TEST(APIDYDTest, ModelicaModel_1UDM_EqualsFromXml) {
  // import
  XmlImporter importer;
  boost::shared_ptr<DynamicModelsCollection> collection;
  std::vector<std::string> files;
  files.push_back("res/sameModelicaModel.xml");
  ASSERT_NO_THROW(collection = importer.importFromDydFiles(files));

  std::vector<std::shared_ptr<ModelicaModel> >models;

  for (const auto& modelPair : collection->getModels())
    models.push_back(std::dynamic_pointer_cast<ModelicaModel>(modelPair.second));

  ASSERT_EQ(models.size(), 2);

  std::map<std::shared_ptr<UnitDynamicModel>, std::shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;
  ASSERT_EQ(models[0]->hasSameStructureAs(models[1], tmpUnitDynamicModelsMap), true);
}

//==================================================
// test equality of models when they are different
//==================================================

TEST(APIDYDTest, ModelicaModel_1UDM_DifferentFromXml) {
  // import
  XmlImporter importer;
  boost::shared_ptr<DynamicModelsCollection> collection;
  std::vector<std::string> files;
  files.push_back("res/differentModelicaModel.xml");
  ASSERT_NO_THROW(collection = importer.importFromDydFiles(files));

  std::vector<std::shared_ptr<ModelicaModel> >models;

  for (const auto& modelPair : collection->getModels())
    models.push_back(std::dynamic_pointer_cast<ModelicaModel>(modelPair.second));

  ASSERT_EQ(models.size(), 2);

  std::map<std::shared_ptr<UnitDynamicModel>, std::shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;
  ASSERT_EQ(models[0]->hasSameStructureAs(models[1], tmpUnitDynamicModelsMap), false);
}

//==================================================
//    test equality of models with no connections
//==================================================

TEST(APIDYDTest, ModelicaModel_3UDMsNoConnections_EqualsFromXml) {
  // import
  XmlImporter importer;
  boost::shared_ptr<DynamicModelsCollection> collection;
  std::vector<std::string> files;
  files.push_back("res/3UDMsameModelicaModel.xml");
  ASSERT_NO_THROW(collection = importer.importFromDydFiles(files));

  std::vector<std::shared_ptr<ModelicaModel> >models;

  for (const auto& modelPair : collection->getModels())
    models.push_back(std::dynamic_pointer_cast<ModelicaModel>(modelPair.second));

  ASSERT_EQ(models.size(), 2);

  std::map<std::shared_ptr<UnitDynamicModel>, std::shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;
  ASSERT_EQ(models[0]->hasSameStructureAs(models[1], tmpUnitDynamicModelsMap), true);
}

//========================================================
// test equality of different models with no connections
//========================================================

TEST(APIDYDTest, ModelicaModel_3UDMsNoConnections_DifferentFromXml) {
  // import
  XmlImporter importer;
  boost::shared_ptr<DynamicModelsCollection> collection;
  std::vector<std::string> files;
  files.push_back("res/3UDMdifferentModelicaModel.xml");
  ASSERT_NO_THROW(collection = importer.importFromDydFiles(files));

  std::vector<std::shared_ptr<ModelicaModel> >models;

  for (const auto& modelPair : collection->getModels())
    models.push_back(std::dynamic_pointer_cast<ModelicaModel>(modelPair.second));

  ASSERT_EQ(models.size(), 2);

  std::map<std::shared_ptr<UnitDynamicModel>, std::shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;
  ASSERT_EQ(models[0]->hasSameStructureAs(models[1], tmpUnitDynamicModelsMap), false);
}

//============================================
// test equality between one model and itself
//============================================

TEST(APIDYDTest, ModelicaModelSameModelFromXml) {
  // import
  XmlImporter importer;
  boost::shared_ptr<DynamicModelsCollection> collection;
  std::vector<std::string> files;
  files.push_back("res/modelicaModel.xml");
  ASSERT_NO_THROW(collection = importer.importFromDydFiles(files));

  std::vector<std::shared_ptr<ModelicaModel> >models;

  for (const auto& modelPair : collection->getModels())
    models.push_back(std::dynamic_pointer_cast<ModelicaModel>(modelPair.second));

  ASSERT_EQ(models.size(), 1);

  std::map<std::shared_ptr<UnitDynamicModel>, std::shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;
  ASSERT_EQ(models[0]->hasSameStructureAs(models[0], tmpUnitDynamicModelsMap), true);
}

//=================================================
// test equality between models with different size
//=================================================

TEST(APIDYDTest, ModelicaModelDifferentSize) {
  boost::shared_ptr<DynamicModelsCollection> collection = DynamicModelsCollectionFactory::newCollection();

  // first model
  std::unique_ptr<ModelicaModel> model;
  model = ModelicaModelFactory::newModel("ModelicaModel");
  std::shared_ptr<UnitDynamicModel> udm1 = UnitDynamicModelFactory::newModel("component1", "model1");
  std::unique_ptr<UnitDynamicModel> udm2 = UnitDynamicModelFactory::newModel("component2", "model2");
  model->addUnitDynamicModel(udm1);
  model->addUnitDynamicModel(std::move(udm2));

  // second model
  std::unique_ptr<ModelicaModel> model1;
  model1 = ModelicaModelFactory::newModel("ModelicaModel1");
  model1->addUnitDynamicModel(udm1);

  std::map<std::shared_ptr<UnitDynamicModel>, std::shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;
  ASSERT_EQ(model->hasSameStructureAs(std::move(model1), tmpUnitDynamicModelsMap), false);
}

//=======================================================================
// test equality between models with same size, different init connectors
//=======================================================================

TEST(APIDYDTest, ModelicaModelDifferentInitConnects) {
  boost::shared_ptr<DynamicModelsCollection> collection = DynamicModelsCollectionFactory::newCollection();

  // first model
  std::unique_ptr<ModelicaModel> model;
  model = ModelicaModelFactory::newModel("ModelicaModel");
  std::shared_ptr<UnitDynamicModel> udm1 = UnitDynamicModelFactory::newModel("component1", "model1");
  std::shared_ptr<UnitDynamicModel> udm2 = UnitDynamicModelFactory::newModel("component2", "model2");
  model->addUnitDynamicModel(udm1);
  model->addUnitDynamicModel(udm2);
  model->addInitConnect("component1", "var1", "component2", "var2");
  model->addInitConnect("component2", "var1", "component1", "var2");

  // second model
  std::unique_ptr<ModelicaModel> model1;
  model1 = ModelicaModelFactory::newModel("ModelicaModel1");
  model1->addUnitDynamicModel(udm1);
  model1->addUnitDynamicModel(udm2);
  model1->addInitConnect("component1", "var2", "component2", "var1");
  model1->addInitConnect("component2", "var2", "component1", "var2");

  std::map<std::shared_ptr<UnitDynamicModel>, std::shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;
  ASSERT_EQ(model->hasSameStructureAs(std::move(model1), tmpUnitDynamicModelsMap), false);
}

//==================================================================
// test equality between models with same size, different connectors
//==================================================================

TEST(APIDYDTest, ModelicaModelDifferentConnects) {
  boost::shared_ptr<DynamicModelsCollection> collection = DynamicModelsCollectionFactory::newCollection();

  // first model
  std::unique_ptr<ModelicaModel> model;
  model = ModelicaModelFactory::newModel("ModelicaModel");
  std::shared_ptr<UnitDynamicModel> udm1 = UnitDynamicModelFactory::newModel("component1", "model1");
  std::shared_ptr<UnitDynamicModel> udm2 = UnitDynamicModelFactory::newModel("component2", "model2");
  model->addUnitDynamicModel(udm1);
  model->addUnitDynamicModel(udm2);
  model->addConnect("component1", "var1", "component2", "var2");
  model->addConnect("component2", "var1", "component1", "var2");

  // second model
  std::unique_ptr<ModelicaModel> model1;
  model1 = ModelicaModelFactory::newModel("ModelicaModel1");
  model1->addUnitDynamicModel(udm1);
  model1->addUnitDynamicModel(udm2);
  model1->addConnect("component1", "var2", "component2", "var1");
  model1->addConnect("component2", "var2", "component1", "var2");

  std::map<std::shared_ptr<UnitDynamicModel>, std::shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;
  ASSERT_EQ(model->hasSameStructureAs(std::move(model1), tmpUnitDynamicModelsMap), false);
}

//=======================================================================================
// test equality between models with same size, same connectors but different init models
//=======================================================================================

TEST(APIDYDTest, ModelicaModelDifferentInitUDM) {
  boost::shared_ptr<DynamicModelsCollection> collection = DynamicModelsCollectionFactory::newCollection();

  // first model
  std::unique_ptr<ModelicaModel> model;
  model = ModelicaModelFactory::newModel("ModelicaModel");
  std::unique_ptr<UnitDynamicModel> udm1 = UnitDynamicModelFactory::newModel("component1", "model1");
  std::unique_ptr<UnitDynamicModel> udm2 = UnitDynamicModelFactory::newModel("component2", "model2");
  udm1->setInitModelName("model_init1");
  udm2->setInitModelName("model_init2");
  model->addUnitDynamicModel(std::move(udm1));
  model->addUnitDynamicModel(std::move(udm2));
  model->addConnect("component1", "var1", "component2", "var2");
  model->addConnect("component2", "var1", "component1", "var2");

  // second model
  std::unique_ptr<ModelicaModel> model1;
  model1 = ModelicaModelFactory::newModel("ModelicaModel1");
  std::unique_ptr<UnitDynamicModel> udm3 = UnitDynamicModelFactory::newModel("component3", "model1");
  std::unique_ptr<UnitDynamicModel> udm4 = UnitDynamicModelFactory::newModel("component4", "model2");
  udm3->setInitModelName("model_init3");
  udm4->setInitModelName("model_init4");
  model1->addUnitDynamicModel(std::move(udm3));
  model1->addUnitDynamicModel(std::move(udm4));
  model1->addConnect("component3", "var1", "component4", "var2");
  model1->addConnect("component4", "var1", "component3", "var2");

  std::map<std::shared_ptr<UnitDynamicModel>, std::shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;
  ASSERT_EQ(model->hasSameStructureAs(std::move(model1), tmpUnitDynamicModelsMap), false);
}

//=======================================================================================
// test equality between models with same size, same connectors but different init models
//=======================================================================================

TEST(APIDYDTest, ModelicaModelDifferentInitUDM_2) {
  boost::shared_ptr<DynamicModelsCollection> collection = DynamicModelsCollectionFactory::newCollection();

  // first model
  std::unique_ptr<ModelicaModel> model;
  model = ModelicaModelFactory::newModel("ModelicaModel");
  std::unique_ptr<UnitDynamicModel> udm1 = UnitDynamicModelFactory::newModel("component1", "model1");
  std::unique_ptr<UnitDynamicModel> udm2 = UnitDynamicModelFactory::newModel("component2", "model2");
  udm1->setInitModelName("model_init1");
  udm2->setInitModelName("model_init2");
  model->addUnitDynamicModel(std::move(udm1));
  model->addUnitDynamicModel(std::move(udm2));
  model->addConnect("component1", "var1", "component2", "var2");
  model->addConnect("component2", "var1", "component1", "var2");

  // second model
  std::unique_ptr<ModelicaModel> model1;
  model1 = ModelicaModelFactory::newModel("ModelicaModel1");
  std::unique_ptr<UnitDynamicModel> udm3 = UnitDynamicModelFactory::newModel("component3", "model1");
  std::unique_ptr<UnitDynamicModel> udm4 = UnitDynamicModelFactory::newModel("component4", "model2");
  udm3->setInitModelName("model_init3");
  udm4->setInitModelName("model_init4");
  model1->addUnitDynamicModel(std::move(udm3));
  model1->addUnitDynamicModel(std::move(udm4));
  model1->addConnect("component4", "var2", "component3", "var1");
  model1->addConnect("component4", "var1", "component3", "var2");

  std::map<std::shared_ptr<UnitDynamicModel>, std::shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;
  ASSERT_EQ(model->hasSameStructureAs(std::move(model1), tmpUnitDynamicModelsMap), false);
}

//================================================================================================================================================
// test equality between models with same size, same connectors considered with modelNames but not equivalent connections graphs, same init models
//================================================================================================================================================

TEST(APIDYDTest, ModelicaModelSameConnectsButDifferentConnectionGraph) {
  boost::shared_ptr<DynamicModelsCollection> collection = DynamicModelsCollectionFactory::newCollection();

  // first model
  std::unique_ptr<ModelicaModel> model;
  model = ModelicaModelFactory::newModel("ModelicaModel");
  std::unique_ptr<UnitDynamicModel> udm1 = UnitDynamicModelFactory::newModel("component1", "model1");
  std::unique_ptr<UnitDynamicModel> udm2 = UnitDynamicModelFactory::newModel("component2", "model1");
  std::unique_ptr<UnitDynamicModel> udm3 = UnitDynamicModelFactory::newModel("component3", "model2");
  std::unique_ptr<UnitDynamicModel> udm4 = UnitDynamicModelFactory::newModel("component4", "model2");
  udm1->setInitModelName("model_init1");
  udm2->setInitModelName("model_init2");
  udm3->setInitModelName("model_init3");
  udm4->setInitModelName("model_init4");
  model->addUnitDynamicModel(std::move(udm1));
  model->addUnitDynamicModel(std::move(udm2));
  model->addUnitDynamicModel(std::move(udm3));
  model->addUnitDynamicModel(std::move(udm4));
  model->addConnect("component1", "var1", "component3", "var2");
  model->addConnect("component2", "var1", "component4", "var2");

  // second model
  std::unique_ptr<ModelicaModel> model1;
  model1 = ModelicaModelFactory::newModel("ModelicaModel1");
  std::unique_ptr<UnitDynamicModel> udm11 = UnitDynamicModelFactory::newModel("component11", "model1");
  std::unique_ptr<UnitDynamicModel> udm21 = UnitDynamicModelFactory::newModel("component21", "model1");
  std::unique_ptr<UnitDynamicModel> udm31 = UnitDynamicModelFactory::newModel("component31", "model2");
  std::unique_ptr<UnitDynamicModel> udm41 = UnitDynamicModelFactory::newModel("component41", "model2");
  udm11->setInitModelName("model_init1");
  udm21->setInitModelName("model_init2");
  udm31->setInitModelName("model_init3");
  udm41->setInitModelName("model_init4");
  model1->addUnitDynamicModel(std::move(udm11));
  model1->addUnitDynamicModel(std::move(udm21));
  model1->addUnitDynamicModel(std::move(udm31));
  model1->addUnitDynamicModel(std::move(udm41));
  model1->addConnect("component11", "var1", "component31", "var2");
  model1->addConnect("component11", "var1", "component41", "var2");

  std::map<std::shared_ptr<UnitDynamicModel>, std::shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;
  ASSERT_EQ(model->hasSameStructureAs(std::move(model1), tmpUnitDynamicModelsMap), false);
}

//=========================================================================================================================================
// test equality between models with same size, same init connections considered with modelNames but not equivalent init connections graphs
//=========================================================================================================================================

TEST(APIDYDTest, ModelicaModelSameInitConnectsButDifferentInitConnectionGraph) {
  boost::shared_ptr<DynamicModelsCollection> collection = DynamicModelsCollectionFactory::newCollection();

  // first model
  std::unique_ptr<ModelicaModel> model;
  model = ModelicaModelFactory::newModel("ModelicaModel");
  std::unique_ptr<UnitDynamicModel> udm1 = UnitDynamicModelFactory::newModel("component1", "model1");
  std::unique_ptr<UnitDynamicModel> udm2 = UnitDynamicModelFactory::newModel("component2", "model1");
  std::unique_ptr<UnitDynamicModel> udm3 = UnitDynamicModelFactory::newModel("component3", "model2");
  std::unique_ptr<UnitDynamicModel> udm4 = UnitDynamicModelFactory::newModel("component4", "model2");
  udm1->setInitModelName("model_init1");
  udm2->setInitModelName("model_init2");
  udm3->setInitModelName("model_init3");
  udm4->setInitModelName("model_init4");
  model->addUnitDynamicModel(std::move(udm1));
  model->addUnitDynamicModel(std::move(udm2));
  model->addUnitDynamicModel(std::move(udm3));
  model->addUnitDynamicModel(std::move(udm4));
  model->addInitConnect("component1", "var1", "component3", "var2");
  model->addInitConnect("component2", "var1", "component4", "var2");

  // second model
  std::unique_ptr<ModelicaModel> model1;
  model1 = ModelicaModelFactory::newModel("ModelicaModel1");
  std::unique_ptr<UnitDynamicModel> udm11 = UnitDynamicModelFactory::newModel("component11", "model1");
  std::unique_ptr<UnitDynamicModel> udm21 = UnitDynamicModelFactory::newModel("component21", "model1");
  std::unique_ptr<UnitDynamicModel> udm31 = UnitDynamicModelFactory::newModel("component31", "model2");
  std::unique_ptr<UnitDynamicModel> udm41 = UnitDynamicModelFactory::newModel("component41", "model2");
  udm11->setInitModelName("model_init1");
  udm21->setInitModelName("model_init2");
  udm31->setInitModelName("model_init3");
  udm41->setInitModelName("model_init4");
  model1->addUnitDynamicModel(std::move(udm11));
  model1->addUnitDynamicModel(std::move(udm21));
  model1->addUnitDynamicModel(std::move(udm31));
  model1->addUnitDynamicModel(std::move(udm41));
  model1->addInitConnect("component11", "var1", "component31", "var2");
  model1->addInitConnect("component11", "var1", "component41", "var2");

  std::map<std::shared_ptr<UnitDynamicModel>, std::shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;
  ASSERT_EQ(model->hasSameStructureAs(std::move(model1), tmpUnitDynamicModelsMap), false);
}

//=======================================================================================
// test equality between models with same size, same connectors, same init models
//=======================================================================================

TEST(APIDYDTest, ModelicaModelSameInitUDM) {
  boost::shared_ptr<DynamicModelsCollection> collection = DynamicModelsCollectionFactory::newCollection();

  // first model
  std::unique_ptr<ModelicaModel> model;
  model = ModelicaModelFactory::newModel("ModelicaModel");
  std::unique_ptr<UnitDynamicModel> udm1 = UnitDynamicModelFactory::newModel("component1", "model1");
  std::unique_ptr<UnitDynamicModel> udm2 = UnitDynamicModelFactory::newModel("component2", "model2");
  udm1->setInitModelName("model_init1");
  udm2->setInitModelName("model_init2");
  model->addUnitDynamicModel(std::move(udm1));
  model->addUnitDynamicModel(std::move(udm2));
  model->addConnect("component1", "var1", "component2", "var2");
  model->addConnect("component2", "var1", "component1", "var2");

  // second model
  std::unique_ptr<ModelicaModel> model1;
  model1 = ModelicaModelFactory::newModel("ModelicaModel1");
  std::unique_ptr<UnitDynamicModel> udm3 = UnitDynamicModelFactory::newModel("component3", "model1");
  std::unique_ptr<UnitDynamicModel> udm4 = UnitDynamicModelFactory::newModel("component4", "model2");
  udm3->setInitModelName("model_init1");
  udm4->setInitModelName("model_init2");
  model1->addUnitDynamicModel(std::move(udm3));
  model1->addUnitDynamicModel(std::move(udm4));
  model1->addConnect("component4", "var2", "component3", "var1");
  model1->addConnect("component4", "var1", "component3", "var2");

  std::map<std::shared_ptr<UnitDynamicModel>, std::shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;
  ASSERT_EQ(model->hasSameStructureAs(std::move(model1), tmpUnitDynamicModelsMap), true);
}

TEST(APIDYDTest, ModelicaModelWithMacroConnect) {
  boost::shared_ptr<DynamicModelsCollection> collection = DynamicModelsCollectionFactory::newCollection();  // reset identifiable

  std::unique_ptr<ModelicaModel> model;
  model = ModelicaModelFactory::newModel("ModelicaModel");
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

//====================================================================
// test equality between models with same size, same macroConnects
//===================================================================

TEST(APIDYDTest, ModelicaModelSameMacroConnects) {
  boost::shared_ptr<DynamicModelsCollection> collection = DynamicModelsCollectionFactory::newCollection();

  // first model
  std::unique_ptr<ModelicaModel> model;
  model = ModelicaModelFactory::newModel("ModelicaModel");
  std::shared_ptr<UnitDynamicModel> udm1 = UnitDynamicModelFactory::newModel("component1", "model1");
  std::shared_ptr<UnitDynamicModel> udm2 = UnitDynamicModelFactory::newModel("component2", "model2");
  std::shared_ptr<UnitDynamicModel> udm3 = UnitDynamicModelFactory::newModel("component3", "model3");
  model->addUnitDynamicModel(udm1);
  model->addUnitDynamicModel(udm2);
  model->addUnitDynamicModel(udm3);
  std::shared_ptr<MacroConnect> mc1 = MacroConnectFactory::newMacroConnect("mc1", "component1", "component2");
  std::shared_ptr<MacroConnect> mc2 = MacroConnectFactory::newMacroConnect("mc2", "component3", "component2");
  model->addMacroConnect(mc1);
  model->addMacroConnect(mc2);

  // second model
  std::unique_ptr<ModelicaModel> model1;
  model1 = ModelicaModelFactory::newModel("ModelicaModel1");
  model1->addUnitDynamicModel(udm1);
  model1->addUnitDynamicModel(udm2);
  model1->addUnitDynamicModel(udm3);
  model1->addMacroConnect(mc1);
  model1->addMacroConnect(mc2);

  std::map<std::shared_ptr<UnitDynamicModel>, std::shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;
  ASSERT_EQ(model->hasSameStructureAs(std::move(model1), tmpUnitDynamicModelsMap), true);
}

//======================================================================
// test equality between models with same size, different macroConnects
//=====================================================================

TEST(APIDYDTest, ModelicaModelDifferentMacroConnects) {
  boost::shared_ptr<DynamicModelsCollection> collection = DynamicModelsCollectionFactory::newCollection();

  // first model
  std::unique_ptr<ModelicaModel> model;
  model = ModelicaModelFactory::newModel("ModelicaModel");
  std::shared_ptr<UnitDynamicModel> udm1 = UnitDynamicModelFactory::newModel("component1", "model1");
  std::shared_ptr<UnitDynamicModel> udm2 = UnitDynamicModelFactory::newModel("component2", "model2");
  std::shared_ptr<UnitDynamicModel> udm3 = UnitDynamicModelFactory::newModel("component3", "model3");
  model->addUnitDynamicModel(udm1);
  model->addUnitDynamicModel(udm2);
  model->addUnitDynamicModel(udm3);
  std::shared_ptr<MacroConnect> mc1 = MacroConnectFactory::newMacroConnect("mc1", "component1", "component2");
  std::unique_ptr<MacroConnect> mc2 = MacroConnectFactory::newMacroConnect("mc2", "component3", "component2");
  model->addMacroConnect(mc1);
  model->addMacroConnect(std::move(mc2));

  // second model
  std::unique_ptr<ModelicaModel> model1;
  model1 = ModelicaModelFactory::newModel("ModelicaModel1");
  model1->addUnitDynamicModel(udm1);
  model1->addUnitDynamicModel(udm2);
  model1->addUnitDynamicModel(udm3);
  std::unique_ptr<MacroConnect> mc3 = MacroConnectFactory::newMacroConnect("mc3", "component3", "component1");
  model1->addMacroConnect(mc1);
  model1->addMacroConnect(std::move(mc3));

  std::map<std::shared_ptr<UnitDynamicModel>, std::shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;
  ASSERT_EQ(model->hasSameStructureAs(std::move(model1), tmpUnitDynamicModelsMap), false);
}

//=================================================================================
// test equality between models with same size, different macroConnects connection
//================================================================================

TEST(APIDYDTest, ModelicaModelDifferentMacroConnectsConnection) {
  boost::shared_ptr<DynamicModelsCollection> collection = DynamicModelsCollectionFactory::newCollection();

  // first model
  std::unique_ptr<ModelicaModel> model;
  model = ModelicaModelFactory::newModel("ModelicaModel");
  std::shared_ptr<UnitDynamicModel> udm1 = UnitDynamicModelFactory::newModel("component1", "model1");
  std::shared_ptr<UnitDynamicModel> udm2 = UnitDynamicModelFactory::newModel("component2", "model2");
  std::shared_ptr<UnitDynamicModel> udm3 = UnitDynamicModelFactory::newModel("component3", "model3");
  model->addUnitDynamicModel(udm1);
  model->addUnitDynamicModel(udm2);
  model->addUnitDynamicModel(udm3);
  std::unique_ptr<MacroConnect> mc1 = MacroConnectFactory::newMacroConnect("mc1", "component1", "component2");
  std::unique_ptr<MacroConnect> mc2 = MacroConnectFactory::newMacroConnect("mc2", "component3", "component2");
  model->addMacroConnect(std::move(mc1));
  model->addMacroConnect(std::move(mc2));

  // second model
  std::unique_ptr<ModelicaModel> model1;
  model1 = ModelicaModelFactory::newModel("ModelicaModel1");
  model1->addUnitDynamicModel(udm1);
  model1->addUnitDynamicModel(udm2);
  model1->addUnitDynamicModel(udm3);
  std::unique_ptr<MacroConnect> mc3 = MacroConnectFactory::newMacroConnect("mc1", "component2", "component1");
  std::unique_ptr<MacroConnect> mc4 = MacroConnectFactory::newMacroConnect("mc3", "component2", "component3");
  model1->addMacroConnect(std::move(mc3));
  model1->addMacroConnect(std::move(mc4));

  std::map<std::shared_ptr<UnitDynamicModel>, std::shared_ptr<UnitDynamicModel> > tmpUnitDynamicModelsMap;
  ASSERT_EQ(model->hasSameStructureAs(std::move(model1), tmpUnitDynamicModelsMap), false);
}

//=======================================================================================
// test macro static ref and static ref iterators
//=======================================================================================

TEST(APIDYDTest, ModelicaModelRefIterators) {
  std::unique_ptr<ModelicaModel> model;
  model = ModelicaModelFactory::newModel("ModelicaModel");
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
  for (const auto& macroStaticRefPair : model->getMacroStaticRefs()) {
    std::shared_ptr<MacroStaticRef> ref = macroStaticRefPair.second;
    ASSERT_EQ(ref->getId(), "MyMacroStaticRef");
  }
}
}  // namespace dynamicdata
