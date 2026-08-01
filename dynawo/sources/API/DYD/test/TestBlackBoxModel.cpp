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
 * @file API/DYD/test/TestBlackBoxModel.cpp
 * @brief Unit tests for API_DYD
 *
 */
#include <boost/shared_ptr.hpp>
#include "gtest_dynawo.h"

#include "DYDBlackBoxModelFactory.h"
#include "DYDBlackBoxModel.h"
#include "DYDXmlImporter.h"
#include "DYDXmlExporter.h"
#include "DYDMacroStaticRefFactory.h"
#include "DYDMacroStaticRef.h"
#include "DYDMacroStaticRefFactory.h"
#include "DYDStaticRef.h"

#include "TestUtil.h"

namespace dynamicdata {
//-----------------------------------------------------
// TEST build, export, import blackBoxModel
//-----------------------------------------------------

TEST(APIDYDTest, BlackBoxModelCreate) {
  // create object
  std::unique_ptr<BlackBoxModel> model;
  model = BlackBoxModelFactory::newModel("blackBoxModel");
  model->setLib("model");
  model->setStaticId("staticId");
  model->setParFile("parFile");
  model->setParId("parId");

  ASSERT_EQ(model->getType(), Model::BLACK_BOX_MODEL);
  ASSERT_EQ(model->getId(), "blackBoxModel");
  ASSERT_EQ(model->getLib(), "model");
  ASSERT_EQ(model->getStaticId(), "staticId");
  ASSERT_EQ(model->getParFile(), "parFile");
  ASSERT_EQ(model->getParId(), "parId");
}

TEST(APIDYDTest, BlackBoxModelImport_export) {
  // import
  XmlImporter importer;
  boost::shared_ptr<DynamicModelsCollection> collection;
  std::vector<std::string> files;
  files.push_back("res/blackBoxModel.xml");
  ASSERT_NO_THROW(collection = importer.importFromDydFiles(files));

  // export
  XmlExporter exporter;
  exporter.exportToFile(collection, "blackBoxModelExport.xml");

  ASSERT_EQ(compareFiles("blackBoxModelExport.xml", "res/blackBoxModel.xml"), true);
}

TEST(APIDYDTest, BlackBoxModelWithMacroStaticRef) {
  std::unique_ptr<BlackBoxModel> model;
  model = BlackBoxModelFactory::newModel("blackBoxModel");

  std::unique_ptr<MacroStaticRef> mStRef1 = MacroStaticRefFactory::newMacroStaticRef("mStRef1");
  std::unique_ptr<MacroStaticRef> mStRef2 = MacroStaticRefFactory::newMacroStaticRef("mStRef2");
  std::unique_ptr<MacroStaticRef> mStRef3 = MacroStaticRefFactory::newMacroStaticRef("mStRef3");
  std::unique_ptr<MacroStaticRef> mStRef11 = MacroStaticRefFactory::newMacroStaticRef("mStRef1");

  // addMacroStaticRef
  ASSERT_NO_THROW(model->addMacroStaticRef(std::move(mStRef1)));
  ASSERT_NO_THROW(model->addMacroStaticRef(std::move(mStRef2)));
  ASSERT_NO_THROW(model->addMacroStaticRef(std::move(mStRef3)));
  ASSERT_THROW_DYNAWO(model->addMacroStaticRef(std::move(mStRef11)), DYN::Error::API, DYN::KeyError_t::MacroStaticRefNotUnique);

  const auto nbMacroStaticRefs = model->getMacroStaticRefs().size();
  ASSERT_EQ(nbMacroStaticRefs, 3);

  // findMacroStaticRef
  ASSERT_NO_THROW(model->findMacroStaticRef("mStRef1"));
  ASSERT_THROW_DYNAWO(model->findMacroStaticRef("mStRef4"), DYN::Error::API, DYN::KeyError_t::MacroStaticRefUndefined);
}

//=======================================================================================
// test macro static ref and static ref iterators
//=======================================================================================

TEST(APIDYDTest, BlackBoxModelRefIterators) {
  std::unique_ptr<BlackBoxModel> model;
  model = BlackBoxModelFactory::newModel("BlackBoxModel");
  std::unique_ptr<MacroStaticRef> macroStaticRef = MacroStaticRefFactory::newMacroStaticRef("MyMacroStaticRef");
  model->addMacroStaticRef(std::move(macroStaticRef));

  model->addStaticRef("MyVar", "MyStaticVar");
  ASSERT_NO_THROW(model->findMacroStaticRef("MyMacroStaticRef"));
  ASSERT_NO_THROW(model->findStaticRef("MyVar_MyStaticVar"));
  for (const auto& staticRefPair : model->getStaticRefs()) {
    const auto& ref = staticRefPair.second;
    ASSERT_EQ(ref->getModelVar(), "MyVar");
    ASSERT_EQ(ref->getStaticVar(), "MyStaticVar");
  }
  for (const auto& macroStaticRefPair : model->getMacroStaticRefs()) {
    const auto& ref = macroStaticRefPair.second;
    ASSERT_EQ(ref->getId(), "MyMacroStaticRef");
  }
}

}  // namespace dynamicdata
