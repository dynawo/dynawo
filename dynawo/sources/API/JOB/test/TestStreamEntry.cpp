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
#include "JOBStreamEntry.h"

namespace job {

TEST(APIJOBTest, testStreamEntry) {
  std::shared_ptr<StreamEntry> stream = std::make_shared<StreamEntry>();

  // check default attributes
  ASSERT_EQ(stream->getData(), "");
  ASSERT_EQ(stream->getChannel(), "");
  ASSERT_EQ(stream->getFormat(), "");

  stream->setData("data");
  stream->setChannel("channel");
  stream->setFormat("format");

  ASSERT_EQ(stream->getData(), "data");
  ASSERT_EQ(stream->getChannel(), "channel");
  ASSERT_EQ(stream->getFormat(), "format");
}

}  // namespace job
