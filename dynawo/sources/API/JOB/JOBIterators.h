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

#include "JOBJobsCollectionImpl.h"

namespace job {

class JobConstIteratorImpl;
class JobIteratorImpl;

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
   * @returns Created job_iterator.
   */
  job_iterator(JobsCollection::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : the job iterator to copy
   */
  job_iterator(const job_iterator& original);

  /**
   * @brief Destructor
   */
  ~job_iterator();

  /**
   * @brief assignment
   * @param other : job_iterator to assign
   *
   * @returns Reference to this job_iterator
   */
  job_iterator& operator=(const job_iterator& other);

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
  boost::shared_ptr<JobEntry>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Job pointed to by this
   */
  boost::shared_ptr<JobEntry>* operator->() const;

  /**
   * @brief Get the implementation ot the iterator
   * @return the implementation ot the iterator
   */
  JobIteratorImpl* impl() const;

 private:
  JobIteratorImpl* impl_;  ///< Pointer to the implementation of the job iterator;
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
   * @returns Created job_const_iterator.
   */
  job_const_iterator(const JobsCollection::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : the job const iterator to copy
   */
  job_const_iterator(const job_const_iterator& original);

  /**
   * @brief Constructor
   *
   * @param original current iterator
   * @returns Created job_const_iterator
   */
  explicit job_const_iterator(const job_iterator& original);

  /**
   * @brief Destructor
   */
  ~job_const_iterator();

  /**
   * @brief assignment
   * @param other : job_const_iterator to assign
   *
   * @returns Reference to this job_const_iterator
   */
  job_const_iterator& operator=(const job_const_iterator& other);

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
  const boost::shared_ptr<JobEntry>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Job pointed to by this
   */
  const boost::shared_ptr<JobEntry>* operator->() const;

 private:
  JobConstIteratorImpl* impl_;  ///< Pointer to the implementation of the job const iterator;
};

}  // namespace job

#endif  // API_JOB_JOBITERATORS_H_


