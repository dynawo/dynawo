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
#include "JOBChannelEntry.h"

namespace job {

TEST(APIJOBTest, testChannelEntry) {
  std::shared_ptr<ChannelEntry> channel = std::make_shared<ChannelEntry>();

  // check default attributes
  ASSERT_EQ(channel->getId(), "");
  ASSERT_EQ(channel->getKind(), "");
  ASSERT_EQ(channel->getType(), "");
  ASSERT_EQ(channel->getEndpoint(), "");

  channel->setId("cid");
  channel->setKind("kid");
  channel->setType("tid");
  channel->setEndpoint("eid");

  ASSERT_EQ(channel->getId(), "cid");
  ASSERT_EQ(channel->getKind(), "kid");
  ASSERT_EQ(channel->getType(), "tid");
  ASSERT_EQ(channel->getEndpoint(), "eid");
}

}  // namespace job
