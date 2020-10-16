//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file API/JOB/test/TestTimestepsEntry.cpp
 * @brief Unit tests for API_JOB/JOBTimestepsEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBTimestepsEntryImpl.h"

namespace job {

TEST(APIJOBTest, testTimestepsEntry) {
  boost::shared_ptr<TimestepsEntry> timesteps = boost::shared_ptr<TimestepsEntry>(new TimestepsEntry::Impl());
  // check default attributes
  ASSERT_EQ(timesteps->getStep(), 1);

  timesteps->setStep(10);

  ASSERT_EQ(timesteps->getStep(), "10");
}

}  // namespace job
