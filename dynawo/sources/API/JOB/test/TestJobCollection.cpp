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
 * @file API/JOB/test/TestJobCollection.cpp
 * @brief Unit tests for API_JOB/JOBCollection class
 *
 */

#include "gtest_dynawo.h"
#include "JOBJobsCollectionFactory.h"
#include "JOBJobsCollection.h"
#include "JOBJobEntry.h"
#include "JOBIterators.h"

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
  for (job_const_iterator itJob = jobsCollection->cbegin();
          itJob != jobsCollection->cend();
          ++itJob) {
    ++nbJobs;
    if (nbJobs == 1) {
      ASSERT_EQ((*itJob)->getName(), "job1");
    } else if (nbJobs == 2) {
      ASSERT_EQ((*itJob)->getName(), "job2");
    } else if (nbJobs == 3) {
      ASSERT_EQ((*itJob)->getName(), "job3");
    }
  }

  ASSERT_EQ(nbJobs, 3);

  job_const_iterator itJob1 = jobsCollection->cbegin();
  ASSERT_EQ((*itJob1)->getName(), "job1");

  nbJobs = 0;
  for (job_iterator itJob = jobsCollection->begin();
          itJob != jobsCollection->end();
          ++itJob) {
    ++nbJobs;
    if (nbJobs == 1) {
      ASSERT_EQ((*itJob)->getName(), "job1");
    } else if (nbJobs == 2) {
      ASSERT_EQ((*itJob)->getName(), "job2");
    } else if (nbJobs == 3) {
      ASSERT_EQ((*itJob)->getName(), "job3");
    }
  }

  ASSERT_EQ(nbJobs, 3);
  job_iterator itJob1_bis = jobsCollection->begin();
  ASSERT_EQ((*itJob1_bis)->getName(), "job1");

  job_iterator itVariable(jobsCollection->begin());
  ASSERT_EQ((++itVariable)->get()->getName(), "job2");
  ASSERT_EQ((--itVariable)->get()->getName(), "job1");
  ASSERT_EQ((itVariable++)->get()->getName(), "job1");
  ASSERT_EQ((itVariable--)->get()->getName(), "job2");
  job_iterator itVariable2 = jobsCollection->end();
  itVariable2 = itVariable;
  ASSERT_TRUE(itVariable2 == itVariable);
}

}  // namespace job
