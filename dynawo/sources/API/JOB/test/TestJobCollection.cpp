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
 * @file API/JOB/test/TestJobCollection.cpp
 * @brief Unit tests for API_JOB/JOBCollection class
 *
 */

#include "gtest_dynawo.h"
#include "JOBJobsCollectionFactory.h"
#include "JOBJobsCollection.h"
#include "JOBJobEntry.h"

#include <memory>


namespace job {

TEST(APIJOBTest, testJobCollection) {
  const std::unique_ptr<JobsCollection> jobsCollection = JobsCollectionFactory::newInstance();
  std::shared_ptr<JobEntry> job1 = std::make_shared<JobEntry>();
  job1->setName("job1");
  std::shared_ptr<JobEntry> job2 = std::make_shared<JobEntry>();
  job2->setName("job2");
  std::shared_ptr<JobEntry> job3 = std::make_shared<JobEntry>();
  job3->setName("job3");

  jobsCollection->addJob(job1);
  jobsCollection->addJob(job2);
  jobsCollection->addJob(job3);

  int nbJobs = 0;
  for (const auto& job : jobsCollection->getJobs()) {
    ++nbJobs;
    if (nbJobs == 1) {
      ASSERT_EQ(job->getName(), "job1");
    } else if (nbJobs == 2) {
      ASSERT_EQ(job->getName(), "job2");
    } else if (nbJobs == 3) {
      ASSERT_EQ(job->getName(), "job3");
    }
  }

  ASSERT_EQ(nbJobs, 3);
}

}  // namespace job
