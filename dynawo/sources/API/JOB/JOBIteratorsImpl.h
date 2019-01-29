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
 * @file  JOBIteratorsImpl.h
 *
 * @brief Iterators over jobs collection : header file
 *
 */
#ifndef API_JOB_JOBITERATORSIMPL_H_
#define API_JOB_JOBITERATORSIMPL_H_

#include "JOBJobsCollectionImpl.h"

namespace job {

class JobEntry;

/**
 * @class JobIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class JobIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on JobsCollection. Can create an implementation for
   * an iterator to the beginning of the jobs' container or to the end.
   *
   * @param iterated Pointer to the jobs' vector iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the jobs' container.
   * @returns Created implementation object
   */
  JobIteratorImpl(JobsCollection::Impl* iterated, bool begin);

  /**
   * @brief Destructor
   */
  ~JobIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  JobIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  JobIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  JobIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  JobIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const JobIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const JobIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns Job pointed to by this
   */
  boost::shared_ptr<JobEntry>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Job pointed to by this
   */
  boost::shared_ptr<JobEntry>* operator->() const;

  /**
   * @brief Get the current iterator
   *
   * @returns Current iterator
   */
  std::vector<boost::shared_ptr<JobEntry> >::iterator current() const;

 private:
  std::vector<boost::shared_ptr<JobEntry> >::iterator current_;  ///< current iterator
};

/**
 * @class JobConstIteratorImpl
 * @brief Implementation class for const iterators' functions
 */
class JobConstIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on jobsCollection. Can create an implementation for
   * a const iterator to the beginning of the jobs' container or to the end.
   *
   * @param iterated Pointer to the jobs' vector iterated
   * @param begin Flag indicating if the const iterator point to the beginning (true)
   * or the end of the jobs' container.
   * @returns Created implementation object
   */
  JobConstIteratorImpl(const JobsCollection::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * @param iterator current iterator on the vector
   * @returns Created constant iterator
   */
  explicit JobConstIteratorImpl(const JobIteratorImpl& iterator);

  /**
   * @brief Destructor
   */
  ~JobConstIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  JobConstIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  JobConstIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this iterator
   */
  JobConstIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  JobConstIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const JobConstIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const JobConstIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns Job pointed to by this
   */
  const boost::shared_ptr<JobEntry>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Job pointed to by this
   */
  const boost::shared_ptr<JobEntry>* operator->() const;

 private:
  std::vector<boost::shared_ptr<JobEntry> >::const_iterator current_;  ///< current const iterator
};

}  // namespace job

#endif  // API_JOB_JOBITERATORSIMPL_H_
