//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file API/JOB/test/TestTimetableEntry.cpp
 * @brief Unit tests for API_JOB/JOBTimetableEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBTimetableEntry.h"

namespace job {

TEST(APIJOBTest, testTimetableEntry) {
  boost::shared_ptr<TimetableEntry> timetable = boost::shared_ptr<TimetableEntry>(new TimetableEntry());
  // check default attributes
  ASSERT_EQ(timetable->getStep(), 1);

  timetable->setStep(10);

  ASSERT_EQ(timetable->getStep(), "10");
}

}  // namespace job
