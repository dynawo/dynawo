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
#include "JOBOutputsEntry.h"
#include "JOBInitValuesEntry.h"
#include "JOBConstraintsEntry.h"
#include "JOBTimelineEntry.h"
#include "JOBFinalStateEntry.h"
#include "JOBCurvesEntry.h"
#include "JOBLogsEntry.h"

namespace job {

TEST(APIJOBTest, testOutputsEntry) {
  boost::shared_ptr<OutputsEntry> outputs = boost::shared_ptr<OutputsEntry>(new OutputsEntry());
  // check default attributes
  ASSERT_EQ(outputs->getOutputsDirectory(), "");
  ASSERT_EQ(outputs->getInitValuesEntry(), boost::shared_ptr<InitValuesEntry>());
  ASSERT_EQ(outputs->getConstraintsEntry(), boost::shared_ptr<ConstraintsEntry>());
  ASSERT_EQ(outputs->getTimelineEntry(), boost::shared_ptr<TimelineEntry>());
  ASSERT_EQ(outputs->getFinalStateEntry(), boost::shared_ptr<FinalStateEntry>());
  ASSERT_EQ(outputs->getCurvesEntry(), boost::shared_ptr<CurvesEntry>());
  ASSERT_EQ(outputs->getLogsEntry(), boost::shared_ptr<LogsEntry>());

  outputs->setOutputsDirectory("/tmp/outputs");

  boost::shared_ptr<InitValuesEntry> initValues = boost::shared_ptr<InitValuesEntry>(new InitValuesEntry());
  outputs->setInitValuesEntry(initValues);

  boost::shared_ptr<ConstraintsEntry> constraints = boost::shared_ptr<ConstraintsEntry>(new ConstraintsEntry());
  outputs->setConstraintsEntry(constraints);

  boost::shared_ptr<TimelineEntry> timeline = boost::shared_ptr<TimelineEntry>(new TimelineEntry());
  outputs->setTimelineEntry(timeline);

  boost::shared_ptr<FinalStateEntry> finalState = boost::shared_ptr<FinalStateEntry>(new FinalStateEntry());
  outputs->setFinalStateEntry(finalState);

  boost::shared_ptr<CurvesEntry> curves = boost::shared_ptr<CurvesEntry>(new CurvesEntry());
  outputs->setCurvesEntry(curves);

  boost::shared_ptr<LogsEntry> logs = boost::shared_ptr<LogsEntry>(new LogsEntry());
  outputs->setLogsEntry(logs);


  ASSERT_EQ(outputs->getOutputsDirectory(), "/tmp/outputs");
  ASSERT_EQ(outputs->getInitValuesEntry(), initValues);
  ASSERT_EQ(outputs->getConstraintsEntry(), constraints);
  ASSERT_EQ(outputs->getTimelineEntry(), timeline);
  ASSERT_EQ(outputs->getFinalStateEntry(), finalState);
  ASSERT_EQ(outputs->getCurvesEntry(), curves);
  ASSERT_EQ(outputs->getLogsEntry(), logs);
}

}  // namespace job
