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
 * @file  JOBJobsCollectionImpl.cpp
 *
 * @brief jobs collection : implementation file
 *
 */
#include "JOBJobsCollectionImpl.h"
#include "JOBJobEntry.h"
#include "JOBIterators.h"

using std::string;
using std::vector;
using boost::shared_ptr;

namespace job {

JobsCollection::Impl::Impl() {
}


JobsCollection::Impl::~Impl() {
}

void
JobsCollection::Impl::addJob(const shared_ptr<JobEntry>& job) {
  jobs_.push_back(job);
}

job_const_iterator
JobsCollection::Impl::cbegin() const {
  return job_const_iterator(this, true);
}

job_const_iterator
JobsCollection::Impl::cend() const {
  return job_const_iterator(this, false);
}

job_iterator
JobsCollection::Impl::begin() {
  return job_iterator(this, true);
}

job_iterator
JobsCollection::Impl::end() {
  return job_iterator(this, false);
}

}  // namespace job
