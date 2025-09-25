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
#include "JOBClockEntry.h"

namespace job {

TEST(APIJOBTest, testClockEntry) {
  std::shared_ptr<ClockEntry> clock = std::make_shared<ClockEntry>();

  // check default attributes
  ASSERT_EQ(clock->getType(), "");
  ASSERT_FALSE(clock->getSpeedup());
  ASSERT_EQ(clock->getTriggerChannel(), "");

  clock->setType("type");
  clock->setSpeedup(2.6);
  clock->setTriggerChannel("channel");

  ASSERT_EQ(clock->getType(), "type");
  ASSERT_TRUE(clock->getSpeedup());
  ASSERT_EQ(clock->getSpeedup().get(), 2.6);
  ASSERT_EQ(clock->getTriggerChannel(), "channel");
}

}  // namespace job
