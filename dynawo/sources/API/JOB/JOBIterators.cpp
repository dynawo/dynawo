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
 * @file  JOBIterators.cpp
 *
 * @brief jobs iterators : implementation file
 *
 */
#include "JOBIterators.h"

#include "JOBJobsCollection.h"
#include "JOBJobsCollection.h"

using std::shared_ptr;

namespace job {

job_const_iterator::job_const_iterator(const JobsCollection* iterated, bool begin) :
    current_((begin ? iterated->jobs_.begin() : iterated->jobs_.end())) {}

job_const_iterator&
job_const_iterator::operator++() {
  ++current_;
  return *this;
}

job_const_iterator
job_const_iterator::operator++(int) {
  job_const_iterator previous = *this;
  current_++;
  return previous;
}

job_const_iterator&
job_const_iterator::operator--() {
  --current_;
  return *this;
}

job_const_iterator
job_const_iterator::operator--(int) {
  job_const_iterator previous = *this;
  current_--;
  return previous;
}

bool
job_const_iterator::operator==(const job_const_iterator& other) const {
  return current_ == other.current_;
}

bool
job_const_iterator::operator!=(const job_const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<JobEntry>& job_const_iterator::operator*() const {
  return *current_;
}

const shared_ptr<JobEntry>* job_const_iterator::operator->() const {
  return &(*current_);
}

job_iterator::job_iterator(JobsCollection* iterated, bool begin) : current_((begin ? iterated->jobs_.begin() : iterated->jobs_.end())) {}

job_iterator&
job_iterator::operator++() {
  ++current_;
  return *this;
}

job_iterator
job_iterator::operator++(int) {
  job_iterator previous = *this;
  current_++;
  return previous;
}

job_iterator&
job_iterator::operator--() {
  --current_;
  return *this;
}

job_iterator
job_iterator::operator--(int) {
  job_iterator previous = *this;
  current_--;
  return previous;
}

bool
job_iterator::operator==(const job_iterator& other) const {
  return current_ == other.current_;
}

bool
job_iterator::operator!=(const job_iterator& other) const {
  return current_ != other.current_;
}

shared_ptr<JobEntry>& job_iterator::operator*() const {
  return *current_;
}

shared_ptr<JobEntry>* job_iterator::operator->() const {
  return &(*current_);
}

}  // namespace job
