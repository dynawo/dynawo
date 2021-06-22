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
  boost::shared_ptr<ModelerEntry> modeler = boost::shared_ptr<ModelerEntry>(new ModelerEntry());
  // check default attributes
  ASSERT_EQ(modeler->getPreCompiledModelsDirEntry(), boost::shared_ptr<ModelsDirEntry>());
  ASSERT_EQ(modeler->getModelicaModelsDirEntry(), boost::shared_ptr<ModelsDirEntry>());
  ASSERT_EQ(modeler->getCompileDir(), "");
  ASSERT_EQ(modeler->getNetworkEntry(), boost::shared_ptr<NetworkEntry>());
  ASSERT_EQ(modeler->getDynModelsEntries().size(), 0);
  ASSERT_EQ(modeler->getInitialStateEntry(), boost::shared_ptr<InitialStateEntry>());

  boost::shared_ptr<ModelsDirEntry> preCompiledModelsDirEntry = boost::shared_ptr<ModelsDirEntry>(new ModelsDirEntry());
  modeler->setPreCompiledModelsDirEntry(preCompiledModelsDirEntry);

  boost::shared_ptr<ModelsDirEntry> modelicaModelsDirEntry = boost::shared_ptr<ModelsDirEntry>(new ModelsDirEntry());
  modeler->setModelicaModelsDirEntry(modelicaModelsDirEntry);

  modeler->setCompileDir("/tmp/compilation");

  boost::shared_ptr<NetworkEntry> network = boost::shared_ptr<NetworkEntry>(new NetworkEntry());
  modeler->setNetworkEntry(network);

  boost::shared_ptr<DynModelsEntry> dynModels1 = boost::shared_ptr<DynModelsEntry>(new DynModelsEntry());
  boost::shared_ptr<DynModelsEntry> dynModels2 = boost::shared_ptr<DynModelsEntry>(new DynModelsEntry());
  modeler->addDynModelsEntry(dynModels1);
  modeler->addDynModelsEntry(dynModels2);

  boost::shared_ptr<InitialStateEntry> initialState = boost::shared_ptr<InitialStateEntry>(new InitialStateEntry());
  modeler->setInitialStateEntry(initialState);

  ASSERT_EQ(modeler->getPreCompiledModelsDirEntry(), preCompiledModelsDirEntry);
  ASSERT_EQ(modeler->getModelicaModelsDirEntry(), modelicaModelsDirEntry);
  ASSERT_EQ(modeler->getCompileDir(), "/tmp/compilation");
  ASSERT_EQ(modeler->getNetworkEntry(), network);
  ASSERT_EQ(modeler->getDynModelsEntries().size(), 2);
  ASSERT_EQ(modeler->getInitialStateEntry(), initialState);

  boost::shared_ptr<ModelerEntry> modeler_bis = DYN::clone(modeler);
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
