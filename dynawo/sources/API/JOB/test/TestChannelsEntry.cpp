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
 * @file API/JOB/test/TestModelerEntry.cpp
 * @brief Unit tests for API_JOB/JOBModelerEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBChannelsEntry.h"
#include "JOBChannelEntry.h"
#include "DYNClone.hpp"

namespace job {

TEST(APIJOBTest, testChannelsEntry) {
  std::shared_ptr<ChannelsEntry> channels = std::make_shared<ChannelsEntry>();

  // check default attributes
  ASSERT_EQ(channels->getChannelEntries().size(), 0);

  // add a pair of channels
  std::shared_ptr<ChannelEntry> channel1 = std::make_shared<ChannelEntry>();
  channel1->setId("channel1");
  channels->addChannelEntry(channel1);

  std::shared_ptr<ChannelEntry> channel2 = std::make_shared<ChannelEntry>();
  channel2->setId("channel2");
  channels->addChannelEntry(channel2);

  // check size
  ASSERT_EQ(channels->getChannelEntries().size(), 2);
  ASSERT_TRUE(channels->getChannelEntryById("channel1"));
  ASSERT_TRUE(channels->getChannelEntryById("channel2"));
  ASSERT_FALSE(channels->getChannelEntryById("channel3"));

  std::shared_ptr<ChannelsEntry> channels_bis = DYN::clone(channels);
  ASSERT_EQ(channels_bis->getChannelEntries().size(), 2);
  ASSERT_TRUE(channels_bis->getChannelEntryById("channel1"));
  ASSERT_TRUE(channels_bis->getChannelEntryById("channel2"));
  ASSERT_FALSE(channels_bis->getChannelEntryById("channel3"));
}

}  // namespace job
