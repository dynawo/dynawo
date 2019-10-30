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
 * @file API/JOB/test/TestSimulationEntry.cpp
 * @brief Unit tests for API_JOB/JOBSimulationEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBSimulationEntryImpl.h"

namespace job {

TEST(APIJOBTest, testSimulationEntry) {
  boost::shared_ptr<SimulationEntry> simulation = boost::shared_ptr<SimulationEntry>(new SimulationEntry::Impl());
  // check default attributes
  ASSERT_EQ(simulation->getStartTime(), 0);
  ASSERT_EQ(simulation->getStopTime(), 0);
  ASSERT_EQ(simulation->getActivateCriteria(), true);
  ASSERT_EQ(simulation->getCriteriaStep(), 10);
  ASSERT_EQ(simulation->getPrecision(), 1e-6);

  simulation->setStartTime(10);
  simulation->setStopTime(100);
  simulation->setActivateCriteria(false);
  simulation->setCriteriaStep(15);
  simulation->setPrecision(1e-8);

  ASSERT_EQ(simulation->getStartTime(), 10);
  ASSERT_EQ(simulation->getStopTime(), 100);
  ASSERT_EQ(simulation->getActivateCriteria(), false);
  ASSERT_EQ(simulation->getCriteriaStep(), 15);
  ASSERT_EQ(simulation->getPrecision(), 1e-8);
}

}  // namespace job
