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
 * @file  JOBJobsCollection.h
 *
 * @brief jobs collection description : interface file
 *
 */

#ifndef API_JOB_JOBJOBSCOLLECTION_H_
#define API_JOB_JOBJOBSCOLLECTION_H_

#include "JOBJobEntry.h"

#include <memory>


namespace job {

/**
 * @class JobsCollection
 * @brief jobs collection interface class
 *
 * Interface class for jobs collection object. This a container for jobs description
 */
class JobsCollection {
 public:
  /**
   * @brief add a job to the jobs collection
   *
   * @param jobEntry job to add to the structure
   */
  void addJob(const std::shared_ptr<JobEntry>& jobEntry);

  /**
  * @brief get the variables
  *
  * @return variables
  */
  const std::vector<std::shared_ptr<JobEntry> >& getJobs() const {
    return jobs_;
  }

  /**
  * @brief get the variables
  *
  * @return variables
  */
  std::vector<std::shared_ptr<JobEntry> >& getNonCstJobs() {
    return jobs_;
  }

 private:
  std::vector<std::shared_ptr<JobEntry> > jobs_;  ///< Vector of the jobs object
};

}  // namespace job

#endif  // API_JOB_JOBJOBSCOLLECTION_H_
