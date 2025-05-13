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
 * @file API/JOB/test/TestConstraintsEntry.cpp
 * @brief Unit tests for API_JOB/JOBConstraintsEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBConstraintsEntry.h"

namespace job {

TEST(APIJOBTest, testConstraintsEntry) {
  boost::shared_ptr<ConstraintsEntry> constraints = boost::shared_ptr<ConstraintsEntry>(new ConstraintsEntry());
  // check default attributes
  ASSERT_EQ(constraints->getOutputFile(), "");
  ASSERT_EQ(constraints->getExportMode(), "");
  ASSERT_TRUE(constraints->isFilter());

  constraints->setOutputFile("/tmp/exportFile.txt");
  constraints->setExportMode("TXT");
  constraints->setFilter(false);

  ASSERT_EQ(constraints->getOutputFile(), "/tmp/exportFile.txt");
  ASSERT_EQ(constraints->getExportMode(), "TXT");
  ASSERT_FALSE(constraints->isFilter());
}

}  // namespace job
