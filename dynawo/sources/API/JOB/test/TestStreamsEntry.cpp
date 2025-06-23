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

#include <vector>
#include <memory>

#include "gtest_dynawo.h"
#include "JOBStreamsEntry.h"
#include "JOBStreamEntry.h"
#include "DYNClone.hpp"

namespace job {

TEST(APIJOBTest, testStreamsEntry) {
  std::shared_ptr<StreamsEntry> streams = std::make_shared<StreamsEntry>();

  // check default attributes
  ASSERT_EQ(streams->getStreamEntries().size(), 0);

  // add a pair of streams
  std::shared_ptr<StreamEntry> stream1 = std::make_shared<StreamEntry>();
  streams->addStreamEntry(stream1);

  std::shared_ptr<StreamEntry> stream2 = std::make_shared<StreamEntry>();
  streams->addStreamEntry(stream2);

  // check size
  std::vector<std::shared_ptr<StreamEntry> > entries = streams->getStreamEntries();
  ASSERT_EQ(entries.size(), 2);
  ASSERT_EQ(entries.at(0), stream1);
  ASSERT_EQ(entries.at(1), stream2);

  std::shared_ptr<StreamsEntry> streams_bis = DYN::clone(streams);
  ASSERT_EQ(streams_bis->getStreamEntries().size(), 2);
}

}  // namespace job
