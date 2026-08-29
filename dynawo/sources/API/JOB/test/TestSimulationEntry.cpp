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
 * @file API/JOB/test/TestSimulationEntry.cpp
 * @brief Unit tests for API_JOB/JOBSimulationEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBSimulationEntry.h"

namespace job {

TEST(APIJOBTest, testSimulationEntry) {
  boost::shared_ptr<SimulationEntry> simulation = boost::shared_ptr<SimulationEntry>(new SimulationEntry());
  // check default attributes
  ASSERT_EQ(simulation->getStartTime(), 0);
  ASSERT_EQ(simulation->getStopTime(), 0);
  ASSERT_TRUE(simulation->getCriteriaFiles().empty());
  ASSERT_EQ(simulation->getCriteriaStep(), 10);
  ASSERT_EQ(simulation->getPrecision(), 1e-6);
  ASSERT_EQ(simulation->getTimeout(), std::numeric_limits<double>::max());

  simulation->setStartTime(10);
  simulation->setStopTime(100);
  simulation->addCriteriaFile("MyFile1");
  simulation->addCriteriaFile("MyFile2");
  simulation->setCriteriaStep(15);
  simulation->setPrecision(1e-8);
  simulation->setTimeout(10.);

  ASSERT_EQ(simulation->getStartTime(), 10);
  ASSERT_EQ(simulation->getStopTime(), 100);
  ASSERT_EQ(simulation->getCriteriaFiles().size(), 2);
  ASSERT_TRUE(std::find(simulation->getCriteriaFiles().begin(),
      simulation->getCriteriaFiles().end(), "MyFile1") != simulation->getCriteriaFiles().end());
  ASSERT_TRUE(std::find(simulation->getCriteriaFiles().begin(),
      simulation->getCriteriaFiles().end(), "MyFile2") != simulation->getCriteriaFiles().end());
  ASSERT_EQ(simulation->getCriteriaStep(), 15);
  ASSERT_EQ(simulation->getPrecision(), 1e-8);
  ASSERT_EQ(simulation->getTimeout(), 10.);

  simulation->setCriteriaFile("MyFile");
  ASSERT_EQ(simulation->getCriteriaFiles().size(), 1);
  ASSERT_TRUE(std::find(simulation->getCriteriaFiles().begin(),
      simulation->getCriteriaFiles().end(), "MyFile") != simulation->getCriteriaFiles().end());
  ASSERT_TRUE(std::find(simulation->getCriteriaFiles().begin(),
      simulation->getCriteriaFiles().end(), "MyFile1") == simulation->getCriteriaFiles().end());
  ASSERT_TRUE(std::find(simulation->getCriteriaFiles().begin(),
      simulation->getCriteriaFiles().end(), "MyFile2") == simulation->getCriteriaFiles().end());
}

}  // namespace job
