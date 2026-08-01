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
 * @file API/JOB/test/TestModelsDirEntry.cpp
 * @brief Unit tests for API_JOB/JOBModelsDirEntry class
 */

#include "gtest_dynawo.h"
#include "JOBModelsDirEntry.h"

namespace job {

TEST(APIJOBTest, testModelsDirEntry) {
  boost::shared_ptr<ModelsDirEntry> modelsDir = boost::shared_ptr<ModelsDirEntry>(new ModelsDirEntry());
  // check default attributes
  ASSERT_EQ(modelsDir->getModelExtension(), "");
  ASSERT_EQ(modelsDir->getUseStandardModels(), false);
  ASSERT_EQ(modelsDir->getDirectories().size(), 0);

  UserDefinedDirectory dir1;
  dir1.path = "/tmp/dir1";
  dir1.isRecursive = false;
  modelsDir->addDirectory(dir1);
  UserDefinedDirectory dir2;
  dir1.path = "/tmp/dir2";
  dir1.isRecursive = true;
  modelsDir->addDirectory(dir1);
  modelsDir->setModelExtension("TXT");
  modelsDir->setUseStandardModels(true);

  ASSERT_EQ(modelsDir->getModelExtension(), "TXT");
  ASSERT_EQ(modelsDir->getUseStandardModels(), true);
  ASSERT_EQ(modelsDir->getDirectories().size(), 2);
  ASSERT_EQ(modelsDir->getDirectories()[0].path, "/tmp/dir1");
  ASSERT_EQ(modelsDir->getDirectories()[0].isRecursive, false);
  ASSERT_EQ(modelsDir->getDirectories()[1].path, "/tmp/dir2");
  ASSERT_EQ(modelsDir->getDirectories()[1].isRecursive, true);

  modelsDir->clearDirectories();

  ASSERT_EQ(modelsDir->getDirectories().size(), 0);
}

}  // namespace job
