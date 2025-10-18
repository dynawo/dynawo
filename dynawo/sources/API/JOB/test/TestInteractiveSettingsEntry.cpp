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
#include "JOBInteractiveSettingsEntry.h"
#include "JOBChannelsEntry.h"
#include "JOBClockEntry.h"
#include "JOBStreamsEntry.h"
#include "DYNClone.hpp"

namespace job {

TEST(APIJOBTest, testInteractiveSetingsEntry) {
  std::shared_ptr<InteractiveSettingsEntry> interactiveSettings = std::make_shared<InteractiveSettingsEntry>();

  // check default attributes
  ASSERT_EQ(interactiveSettings->getCouplingTimeStep(), 0.);
  ASSERT_EQ(interactiveSettings->getChannelsEntry(), std::shared_ptr<ChannelsEntry>());
  ASSERT_EQ(interactiveSettings->getClockEntry(), std::shared_ptr<ClockEntry>());
  ASSERT_EQ(interactiveSettings->getStreamsEntry(), std::shared_ptr<StreamsEntry>());

  std::shared_ptr<ChannelsEntry> channels = std::make_shared<ChannelsEntry>();
  std::shared_ptr<ClockEntry> clock = std::make_shared<ClockEntry>();
  std::shared_ptr<StreamsEntry> streams = std::make_shared<StreamsEntry>();

  interactiveSettings->setCouplingTimeStep(2.);
  interactiveSettings->setChannelsEntry(channels);
  interactiveSettings->setClockEntry(clock);
  interactiveSettings->setStreamsEntry(streams);

  ASSERT_EQ(interactiveSettings->getCouplingTimeStep(), 2.);
  ASSERT_EQ(interactiveSettings->getChannelsEntry(), channels);
  ASSERT_EQ(interactiveSettings->getClockEntry(), clock);
  ASSERT_EQ(interactiveSettings->getStreamsEntry(), streams);

  std::shared_ptr<InteractiveSettingsEntry> interactiveSettings_bis = DYN::clone(interactiveSettings);
  ASSERT_EQ(interactiveSettings_bis->getCouplingTimeStep(), 2.);
  ASSERT_NE(interactiveSettings_bis->getChannelsEntry(), channels);
  ASSERT_NE(interactiveSettings_bis->getClockEntry(), clock);
  ASSERT_NE(interactiveSettings_bis->getStreamsEntry(), streams);

  InteractiveSettingsEntry settings = *interactiveSettings;
  ASSERT_EQ(interactiveSettings_bis->getCouplingTimeStep(), 2.);
  ASSERT_NE(interactiveSettings_bis->getChannelsEntry(), channels);
  ASSERT_NE(interactiveSettings_bis->getClockEntry(), clock);
  ASSERT_NE(interactiveSettings_bis->getStreamsEntry(), streams);
}

}  // namespace job
