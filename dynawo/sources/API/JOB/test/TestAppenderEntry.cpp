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
 * @file API/JOB/test/TestAppenderEntry.cpp
 * @brief Unit tests for API_JOB/JOBAppenderEntry class
 *
 */

#include "gtest_dynawo.h"

#include "JOBAppenderEntry.h"

namespace job {

TEST(APIJOBTest, testAppenderEntry) {
  boost::shared_ptr<AppenderEntry> appender = boost::shared_ptr<AppenderEntry>(new AppenderEntry());
  // check default attributes
  ASSERT_EQ(appender->getShowLevelTag(), true);
  ASSERT_EQ(appender->getSeparator(), " | ");
  ASSERT_EQ(appender->getTimeStampFormat(), "%Y-%m-%d %H:%M:%S");
  ASSERT_EQ(appender->getTag(), "");
  ASSERT_EQ(appender->getLvlFilter(), "");
  ASSERT_EQ(appender->getFilePath(), "");

  // use setters and check getters
  appender->setShowLevelTag(false);
  appender->setSeparator(" / ");
  appender->setTimeStampFormat("%H:%M:%S");
  appender->setTag("TAG");
  appender->setLvlFilter("DEBUG");
  appender->setFilePath("/tmp/log.txt");

  ASSERT_EQ(appender->getShowLevelTag(), false);
  ASSERT_EQ(appender->getSeparator(), " / ");
  ASSERT_EQ(appender->getTimeStampFormat(), "%H:%M:%S");
  ASSERT_EQ(appender->getTag(), "TAG");
  ASSERT_EQ(appender->getLvlFilter(), "DEBUG");
  ASSERT_EQ(appender->getFilePath(), "/tmp/log.txt");
}

}  // namespace job
