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
 * @file API/JOB/test/TestLogsEntry.cpp
 * @brief Unit tests for API_JOB/JOBLogsEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBLogsEntryImpl.h"
#include "JOBAppenderEntryImpl.h"

namespace job {

TEST(APIJOBTest, testLogsEntry) {
  boost::shared_ptr<LogsEntry> logs = boost::shared_ptr<LogsEntry>(new LogsEntry::Impl());
  // check default attributes
  ASSERT_EQ(logs->getAppenderEntries().size(), 0);

  boost::shared_ptr<AppenderEntry> appender = boost::shared_ptr<AppenderEntry>(new AppenderEntry::Impl());
  boost::shared_ptr<AppenderEntry> appender1 = boost::shared_ptr<AppenderEntry>(new AppenderEntry::Impl());
  logs->addAppenderEntry(appender);
  logs->addAppenderEntry(appender1);

  ASSERT_EQ(logs->getAppenderEntries().size(), 2);

  boost::shared_ptr<LogsEntry> logs_bis = logs->clone();
  ASSERT_EQ(logs_bis->getAppenderEntries().size(), 2);
}

}  // namespace job
