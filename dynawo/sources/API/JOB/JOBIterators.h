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
 * @file  JOBIterators.h
 *
 * @brief Iterators for JOB API : header file
 *
 */
#ifndef API_JOB_JOBITERATORS_H_
#define API_JOB_JOBITERATORS_H_

#include "JOBJobEntry.h"

#include <vector>
#include <memory>


namespace job {

class JobsCollection;

/**
 * @class job_iterator
 * @brief iterator over jobs
 *
 * iterator over jobs stored in jobs collection
 */
class job_iterator {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on jobs. Can create an iterator to the
   * beginning of the jobs' container or to the end. Jobs
   * can be modified.
   *
   * @param iterated Pointer to the jobs collection iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the jobs' container.
   */
  job_iterator(JobsCollection* iterated, bool begin);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this job_iterator
   */
  job_iterator& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this job_iterator
   */
  job_iterator operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this job_iterator
   */
  job_iterator& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this job_iterator
   */
  job_iterator operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if job_iterators are equals, else false
   */
  bool operator==(const job_iterator& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if job_iterators are different, else false
   */
  bool operator!=(const job_iterator& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns Job pointed to by this
   */
  std::shared_ptr<JobEntry>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Job pointed to by this
   */
  std::shared_ptr<JobEntry>* operator->() const;

 private:
  std::vector<std::shared_ptr<JobEntry> >::iterator current_;  ///< current iterator
};

/**
 * @class job_const_iterator
 * @brief const iterator over jobs
 *
 * const iterator over jobs stored in jobs collection
 */
class job_const_iterator {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on jobs. Can create a const iterator to the
   * beginning of the jobs' container or to the end. Jobs
   * cannot be modified.
   *
   * @param iterated Pointer to the jobs collection iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the jobs' container.
   */
  job_const_iterator(const JobsCollection* iterated, bool begin);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this job_const_iterator
   */
  job_const_iterator& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this job_const_iterator
   */
  job_const_iterator operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this job_const_iterator
   */
  job_const_iterator& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this job_const_iterator
   */
  job_const_iterator operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if job_const_iterators are equals, else false
   */
  bool operator==(const job_const_iterator& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if job_const_iterators are different, else false
   */
  bool operator!=(const job_const_iterator& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns Job pointed to by this
   */
  const std::shared_ptr<JobEntry>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Job pointed to by this
   */
  const std::shared_ptr<JobEntry>* operator->() const;

 private:
  std::vector<std::shared_ptr<JobEntry> >::const_iterator current_;  ///< current const iterator
};

}  // namespace job

#endif  // API_JOB_JOBITERATORS_H_
