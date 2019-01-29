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
 * @file  JOBJobsCollectionImpl.h
 *
 * @brief Jobs collection : header file
 *
 */

#ifndef API_JOB_JOBJOBSCOLLECTIONIMPL_H_
#define API_JOB_JOBJOBSCOLLECTIONIMPL_H_

#include <vector>
#include <string>
#include <boost/shared_ptr.hpp>

#include "JOBJobsCollection.h"

namespace job {
class JobEntry;

/**
 * @class JobsCollection::Impl
 * @brief JobsCollection implemented class
 *
 * Implementation of Jobs collection interface class
 */
class JobsCollection::Impl : public JobsCollection {
 public:
  /**
   * @brief Constructor
   */
  Impl();

  /**
   * @brief Destructor
   */
  virtual ~Impl();

  /**
   * @copydoc JobsCollection::addJob(const boost::shared_ptr<JobEntry>& jobEntry)
   */
  void addJob(const boost::shared_ptr<JobEntry>& jobEntry);

  /**
   * @brief get a const_iterator to the beginning of the jobs' vector
   * @return a const_iterator to the beginning of the jobs' vector
   */
  virtual job_const_iterator cbegin() const;

  /**
   * @brief get a const_iterator to the end of the jobs' vector
   * @return a const_iterator to the end of the jobs' vector
   */
  virtual job_const_iterator cend() const;

  /**
   * @brief get an iterator to the beginning of the jobs' vector
   * @return an iterator to the beginning of the jobs' vector
   */
  virtual job_iterator begin();

  /**
   * @brief get an iterator to the end of the jobs' vector
   * @return an iterator to the end of the jobs' vector
   */
  virtual job_iterator end();

  friend class JobConstIteratorImpl;
  friend class JobIteratorImpl;

 private:
  std::vector<boost::shared_ptr<JobEntry> > jobs_;  ///< Vector of the jobs object
};



}  // namespace job

#endif  // API_JOB_JOBJOBSCOLLECTIONIMPL_H_
