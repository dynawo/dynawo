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
 * @file API/JOB/test/TestModelerEntry.cpp
 * @brief Unit tests for API_JOB/JOBModelerEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBModelerEntry.h"
#include "JOBNetworkEntry.h"
#include "JOBDynModelsEntry.h"
#include "JOBInitialStateEntry.h"
#include "JOBModelsDirEntry.h"

#include "DYNClone.hpp"

namespace job {

TEST(APIJOBTest, testModelerEntry) {
  std::shared_ptr<ModelerEntry> modeler = std::make_shared<ModelerEntry>();
  // check default attributes
  ASSERT_EQ(modeler->getPreCompiledModelsDirEntry(), std::shared_ptr<ModelsDirEntry>());
  ASSERT_EQ(modeler->getModelicaModelsDirEntry(), std::shared_ptr<ModelsDirEntry>());
  ASSERT_EQ(modeler->getCompileDir(), "");
  ASSERT_EQ(modeler->getNetworkEntry(), std::shared_ptr<NetworkEntry>());
  ASSERT_EQ(modeler->getDynModelsEntries().size(), 0);
  ASSERT_EQ(modeler->getInitialStateEntry(), std::shared_ptr<InitialStateEntry>());

  std::shared_ptr<ModelsDirEntry> preCompiledModelsDirEntry = std::make_shared<ModelsDirEntry>();
  modeler->setPreCompiledModelsDirEntry(preCompiledModelsDirEntry);

  std::shared_ptr<ModelsDirEntry> modelicaModelsDirEntry = std::make_shared<ModelsDirEntry>();
  modeler->setModelicaModelsDirEntry(modelicaModelsDirEntry);

  modeler->setCompileDir("/tmp/compilation");

  std::shared_ptr<NetworkEntry> network = std::make_shared<NetworkEntry>();
  modeler->setNetworkEntry(network);

  std::unique_ptr<DynModelsEntry> dynModels1 = std::unique_ptr<DynModelsEntry>(new DynModelsEntry());
  std::unique_ptr<DynModelsEntry> dynModels2 = std::unique_ptr<DynModelsEntry>(new DynModelsEntry());
  modeler->addDynModelsEntry(std::move(dynModels1));
  modeler->addDynModelsEntry(std::move(dynModels2));

  std::shared_ptr<InitialStateEntry> initialState = std::make_shared<InitialStateEntry>();
  modeler->setInitialStateEntry(initialState);

  ASSERT_EQ(modeler->getPreCompiledModelsDirEntry(), preCompiledModelsDirEntry);
  ASSERT_EQ(modeler->getModelicaModelsDirEntry(), modelicaModelsDirEntry);
  ASSERT_EQ(modeler->getCompileDir(), "/tmp/compilation");
  ASSERT_EQ(modeler->getNetworkEntry(), network);
  ASSERT_EQ(modeler->getDynModelsEntries().size(), 2);
  ASSERT_EQ(modeler->getInitialStateEntry(), initialState);

  std::shared_ptr<ModelerEntry> modeler_bis = DYN::clone(modeler);
  ASSERT_EQ(modeler_bis->getCompileDir(), "/tmp/compilation");
  ASSERT_EQ(modeler_bis->getDynModelsEntries().size(), 2);
  ASSERT_NE(modeler_bis->getPreCompiledModelsDirEntry(), preCompiledModelsDirEntry);
  ASSERT_NE(modeler_bis->getModelicaModelsDirEntry(), modelicaModelsDirEntry);
  ASSERT_NE(modeler_bis->getNetworkEntry(), network);
  ASSERT_NE(modeler_bis->getInitialStateEntry(), initialState);

  ModelerEntry modeler_bis2 = *modeler;
  ASSERT_EQ(modeler_bis2.getCompileDir(), "/tmp/compilation");
  ASSERT_EQ(modeler_bis2.getDynModelsEntries().size(), 2);
  ASSERT_NE(modeler_bis2.getPreCompiledModelsDirEntry(), preCompiledModelsDirEntry);
  ASSERT_NE(modeler_bis2.getModelicaModelsDirEntry(), modelicaModelsDirEntry);
  ASSERT_NE(modeler_bis2.getNetworkEntry(), network);
  ASSERT_NE(modeler_bis2.getInitialStateEntry(), initialState);
}

}  // namespace job
