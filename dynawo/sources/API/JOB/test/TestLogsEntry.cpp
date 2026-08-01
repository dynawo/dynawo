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
 * @file API/JOB/test/TestLogsEntry.cpp
 * @brief Unit tests for API_JOB/JOBLogsEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBLogsEntry.h"
#include "JOBAppenderEntry.h"

#include "DYNClone.hpp"

namespace job {

TEST(APIJOBTest, testLogsEntry) {
  std::shared_ptr<LogsEntry> logs = std::make_shared<LogsEntry>();
  // check default attributes
  ASSERT_EQ(logs->getAppenderEntries().size(), 0);

  std::shared_ptr<AppenderEntry> appender = std::make_shared<AppenderEntry>();
  std::shared_ptr<AppenderEntry> appender1 = std::make_shared<AppenderEntry>();
  logs->addAppenderEntry(appender);
  logs->addAppenderEntry(appender1);

  ASSERT_EQ(logs->getAppenderEntries().size(), 2);

  std::shared_ptr<LogsEntry> logs_bis = DYN::clone(logs);
  ASSERT_EQ(logs_bis->getAppenderEntries().size(), 2);

  LogsEntry logs_bis2 = *logs;
  ASSERT_EQ(logs_bis2.getAppenderEntries().size(), 2);
}

}  // namespace job
