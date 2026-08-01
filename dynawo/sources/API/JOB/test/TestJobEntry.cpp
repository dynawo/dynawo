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
 * @file API/JOB/test/TestJobEntry.cpp
 * @brief Unit tests for API_JOB/JOBJobEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBJobEntry.h"
#include "JOBModelerEntry.h"
#include "JOBSolverEntry.h"
#include "JOBSimulationEntry.h"
#include "JOBOutputsEntry.h"

#include "DYNClone.hpp"

namespace job {

TEST(APIJOBTest, testJobEntry) {
  std::shared_ptr<JobEntry> job = std::make_shared<JobEntry>();
  // check default attributes
  ASSERT_EQ(job->getName(), "");
  ASSERT_EQ(job->getModelerEntry(), std::shared_ptr<ModelerEntry>());
  ASSERT_EQ(job->getSolverEntry(), std::shared_ptr<SolverEntry>());
  ASSERT_EQ(job->getSimulationEntry(), std::shared_ptr<SimulationEntry>());
  ASSERT_EQ(job->getOutputsEntry(), std::shared_ptr<OutputsEntry>());
  ASSERT_EQ(job->getLocalInitEntry(), std::shared_ptr<LocalInitEntry>());


  std::shared_ptr<ModelerEntry> modeler = std::make_shared<ModelerEntry>();
  std::shared_ptr<SolverEntry> solver = std::make_shared<SolverEntry>();
  std::shared_ptr<SimulationEntry> simulation = std::make_shared<SimulationEntry>();
  std::shared_ptr<OutputsEntry> outputs = std::make_shared<OutputsEntry>();
  std::shared_ptr<LocalInitEntry> localInit = std::make_shared<LocalInitEntry>();


  job->setName("job1");
  job->setModelerEntry(modeler);
  job->setSolverEntry(solver);
  job->setSimulationEntry(simulation);
  job->setOutputsEntry(outputs);
  job->setLocalInitEntry(localInit);

  ASSERT_EQ(job->getName(), "job1");
  ASSERT_EQ(job->getModelerEntry(), modeler);
  ASSERT_EQ(job->getSolverEntry(), solver);
  ASSERT_EQ(job->getSimulationEntry(), simulation);
  ASSERT_EQ(job->getOutputsEntry(), outputs);
  ASSERT_EQ(job->getLocalInitEntry(), localInit);

  std::shared_ptr<JobEntry> job_bis = DYN::clone(job);
  ASSERT_EQ(job_bis->getName(), "job1");
  ASSERT_NE(job_bis->getModelerEntry(), modeler);
  ASSERT_NE(job_bis->getSolverEntry(), solver);
  ASSERT_NE(job_bis->getSimulationEntry(), simulation);
  ASSERT_NE(job_bis->getOutputsEntry(), outputs);
  ASSERT_NE(job_bis->getLocalInitEntry(), localInit);

  JobEntry job_bis2 = *job;
  ASSERT_EQ(job_bis2.getName(), "job1");
  ASSERT_NE(job_bis2.getModelerEntry(), modeler);
  ASSERT_NE(job_bis2.getSolverEntry(), solver);
  ASSERT_NE(job_bis2.getSimulationEntry(), simulation);
  ASSERT_NE(job_bis2.getOutputsEntry(), outputs);
  ASSERT_NE(job_bis2.getLocalInitEntry(), localInit);
}

}  // namespace job
