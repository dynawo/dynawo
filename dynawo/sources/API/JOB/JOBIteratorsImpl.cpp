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
 * @file  JOBIteratorsImpl.cpp
 *
 * @brief jobs iterators : implementation file
 *
 */
#include "JOBIteratorsImpl.h"

using boost::shared_ptr;
using std::vector;

namespace job {

JobConstIteratorImpl::JobConstIteratorImpl(const JobsCollection::Impl* iterated, bool begin) :
current_((begin ? iterated->jobs_.begin() : iterated->jobs_.end())) { }

JobConstIteratorImpl::JobConstIteratorImpl(const JobIteratorImpl& iterator) :
current_(iterator.current()) { }

JobConstIteratorImpl::~JobConstIteratorImpl() {
}

JobConstIteratorImpl&
JobConstIteratorImpl::operator++() {
  ++current_;
  return *this;
}

JobConstIteratorImpl
JobConstIteratorImpl::operator++(int) {
  JobConstIteratorImpl previous = *this;
  current_++;
  return previous;
}

JobConstIteratorImpl&
JobConstIteratorImpl::operator--() {
  --current_;
  return *this;
}

JobConstIteratorImpl
JobConstIteratorImpl::operator--(int) {
  JobConstIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
JobConstIteratorImpl::operator==(const JobConstIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
JobConstIteratorImpl::operator!=(const JobConstIteratorImpl& other) const {
  return current_ != other.current_;
}

const shared_ptr<JobEntry>&
JobConstIteratorImpl::operator*() const {
  return *current_;
}

const shared_ptr<JobEntry>*
JobConstIteratorImpl::operator->() const {
  return &(*current_);
}

JobIteratorImpl::JobIteratorImpl(JobsCollection::Impl* iterated, bool begin) :
current_((begin ? iterated->jobs_.begin() : iterated->jobs_.end())) { }

JobIteratorImpl::~JobIteratorImpl() {
}

JobIteratorImpl&
JobIteratorImpl::operator++() {
  ++current_;
  return *this;
}

JobIteratorImpl
JobIteratorImpl::operator++(int) {
  JobIteratorImpl previous = *this;
  current_++;
  return previous;
}

JobIteratorImpl&
JobIteratorImpl::operator--() {
  --current_;
  return *this;
}

JobIteratorImpl
JobIteratorImpl::operator--(int) {
  JobIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
JobIteratorImpl::operator==(const JobIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
JobIteratorImpl::operator!=(const JobIteratorImpl& other) const {
  return current_ != other.current_;
}

shared_ptr<JobEntry>&
JobIteratorImpl::operator*() const {
  return *current_;
}

shared_ptr<JobEntry>*
JobIteratorImpl::operator->() const {
  return &(*current_);
}

vector<shared_ptr<JobEntry> >::iterator
JobIteratorImpl::current() const {
  return current_;
}

}  // namespace job
