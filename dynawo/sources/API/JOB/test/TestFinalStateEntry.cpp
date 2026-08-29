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
 * @file API/JOB/test/TestFinalStateEntry.cpp
 * @brief Unit tests for API_JOB/JOBFinalStateEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBFinalStateEntry.h"

namespace job {

TEST(APIJOBTest, testFinalStateEntry) {
  boost::shared_ptr<FinalStateEntry> finalState = boost::shared_ptr<FinalStateEntry>(new FinalStateEntry());
  // check default attributes
  ASSERT_EQ(finalState->getExportIIDMFile(), false);
  ASSERT_EQ(finalState->getExportDumpFile(), false);
  ASSERT_EQ(finalState->getDumpFile(), "");
  ASSERT_EQ(finalState->getOutputIIDMFile(), "");
  ASSERT_FALSE(finalState->getTimestamp());

  finalState->setOutputIIDMFile("/tmp/exportIIDMFile.txt");
  finalState->setDumpFile("/tmp/dumpFile.dmp");
  finalState->setExportIIDMFile(true);
  finalState->setExportDumpFile(true);
  finalState->setTimestamp(15.);

  ASSERT_EQ(finalState->getOutputIIDMFile(), "/tmp/exportIIDMFile.txt");
  ASSERT_EQ(finalState->getDumpFile(), "/tmp/dumpFile.dmp");
  ASSERT_EQ(finalState->getExportIIDMFile(), true);
  ASSERT_EQ(finalState->getExportDumpFile(), true);
  ASSERT_TRUE(finalState->getTimestamp());
  ASSERT_EQ(*finalState->getTimestamp(), 15.);
}

}  // namespace job
