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
 * @file API/JOB/test/TestTimelineEntry.cpp
 * @brief Unit tests for API_JOB/JOBTimelineEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBTimelineEntryImpl.h"

namespace job {

TEST(APIJOBTest, testTimelineEntry) {
  boost::shared_ptr<TimelineEntry> timeline = boost::shared_ptr<TimelineEntry>(new TimelineEntry::Impl());
  // check default attributes
  ASSERT_EQ(timeline->getExportMode(), "");
  ASSERT_TRUE(timeline->getMaxPriority() < 0);
  ASSERT_EQ(timeline->getOutputFile(), "");

  timeline->setExportMode("TXT");
  timeline->setMaxPriority(2);
  timeline->setOutputFile("/tmp/output.txt");

  ASSERT_EQ(timeline->getExportMode(), "TXT");
  ASSERT_EQ(timeline->getMaxPriority(), 2);
  ASSERT_EQ(timeline->getOutputFile(), "/tmp/output.txt");
}

}  // namespace job
