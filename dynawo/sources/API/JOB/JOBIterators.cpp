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
 * @brief job iterators: implementation file
 *
 * Iterators can be const or not
 */
#include "JOBIterators.h"
#include "JOBIteratorsImpl.h"

using boost::shared_ptr;

namespace job {

job_const_iterator::job_const_iterator(const JobsCollection::Impl* iterated, bool begin) :
impl_(new JobConstIteratorImpl(iterated, begin)) { }

job_const_iterator::job_const_iterator(const job_const_iterator& original) :
impl_(new JobConstIteratorImpl(*(original.impl_))) { }

job_const_iterator::job_const_iterator(const job_iterator& original) :
impl_(new JobConstIteratorImpl(*(original.impl()))) { }

job_const_iterator::~job_const_iterator() {
  delete impl_;
  impl_ = NULL;
}

job_const_iterator&
job_const_iterator::operator=(const job_const_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new JobConstIteratorImpl(*(other.impl_));
  return *this;
}

job_const_iterator&
job_const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

job_const_iterator
job_const_iterator::operator++(int) {
  job_const_iterator previous = *this;
  (*impl_)++;
  return previous;
}

job_const_iterator&
job_const_iterator::operator--() {
  --(*impl_);
  return *this;
}

job_const_iterator
job_const_iterator::operator--(int) {
  job_const_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
job_const_iterator::operator==(const job_const_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
job_const_iterator::operator!=(const job_const_iterator& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<JobEntry>&
job_const_iterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<JobEntry>*
job_const_iterator::operator->() const {
  return impl_->operator->();
}

job_iterator::job_iterator(JobsCollection::Impl* iterated, bool begin) :
impl_(new JobIteratorImpl(iterated, begin)) { }

job_iterator::job_iterator(const job_iterator& original) :
impl_(new JobIteratorImpl(*(original.impl_))) { }

job_iterator::~job_iterator() {
  delete impl_;
  impl_ = NULL;
}

job_iterator&
job_iterator::operator=(const job_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new JobIteratorImpl(*(other.impl_));
  return *this;
}

job_iterator&
job_iterator::operator++() {
  ++(*impl_);
  return *this;
}

job_iterator
job_iterator::operator++(int) {
  job_iterator previous = *this;
  (*impl_)++;
  return previous;
}

job_iterator&
job_iterator::operator--() {
  --(*impl_);
  return *this;
}

job_iterator
job_iterator::operator--(int) {
  job_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
job_iterator::operator==(const job_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
job_iterator::operator!=(const job_iterator& other) const {
  return *impl_ != *(other.impl_);
}

shared_ptr<JobEntry>&
job_iterator::operator*() const {
  return *(*impl_);
}

shared_ptr<JobEntry>*
job_iterator::operator->() const {
  return impl_->operator->();
}

JobIteratorImpl*
job_iterator::impl() const {
  return impl_;
}

}  // namespace job
