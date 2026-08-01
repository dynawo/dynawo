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
 * @file API/JOB/test/TestInitialStateEntry.cpp
 * @brief Unit tests for API_JOB/JOBInitialStateEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBInitialStateEntry.h"

namespace job {

TEST(APIJOBTest, testInitialStateEntry) {
  boost::shared_ptr<InitialStateEntry> initialState = boost::shared_ptr<InitialStateEntry>(new InitialStateEntry());
  // check default attributes
  ASSERT_EQ(initialState->getInitialStateFile(), "");

  initialState->setInitialStateFile("/tmp/initialState.txt");

  ASSERT_EQ(initialState->getInitialStateFile(), "/tmp/initialState.txt");
}

}  // namespace job
