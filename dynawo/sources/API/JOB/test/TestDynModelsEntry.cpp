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
 * @file API/JOB/test/TestDynModelsEntry.cpp
 * @brief Unit tests for API_JOB/JOBDynModelsEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBDynModelsEntry.h"
#include "JOBDynModelsEntryFactory.h"

namespace job {

TEST(APIJOBTest, testDynModelsEntry) {
  const std::unique_ptr<DynModelsEntry> dynModels = DynModelsEntryFactory::newInstance();
  // check default attributes
  ASSERT_EQ(dynModels->getDydFile(), "");

  dynModels->setDydFile("/tmp/dydFile.xml");

  ASSERT_EQ(dynModels->getDydFile(), "/tmp/dydFile.xml");
}

}  // namespace job
