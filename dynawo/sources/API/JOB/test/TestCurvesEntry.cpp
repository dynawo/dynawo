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
 * @file API/JOB/test/TestCurvesEntry.cpp
 * @brief Unit tests for API_JOB/JOBCurvesEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBCurvesEntry.h"

namespace job {

TEST(APIJOBTest, testCurvesEntry) {
  boost::shared_ptr<CurvesEntry> curves = boost::shared_ptr<CurvesEntry>(new CurvesEntry());
  // check default attributes
  ASSERT_EQ(curves->getOutputFile(), "");
  ASSERT_EQ(curves->getExportMode(), "");
  ASSERT_EQ(curves->getInputFile(), "");
  ASSERT_FALSE(curves->getIterationStep());
  ASSERT_FALSE(curves->getTimeStep());

  curves->setOutputFile("/tmp/exportFile.txt");
  curves->setExportMode("TXT");
  curves->setInputFile("/tmp/input.txt");
  curves->setIterationStep(5);
  curves->setTimeStep(8);

  ASSERT_EQ(curves->getOutputFile(), "/tmp/exportFile.txt");
  ASSERT_EQ(curves->getExportMode(), "TXT");
  ASSERT_EQ(curves->getInputFile(), "/tmp/input.txt");
  ASSERT_TRUE(curves->getIterationStep());
  ASSERT_EQ(*curves->getIterationStep(), 5);
  ASSERT_TRUE(curves->getTimeStep());
  ASSERT_EQ(*curves->getTimeStep(), 8);
}

}  // namespace job
