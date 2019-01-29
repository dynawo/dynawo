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
 * @file  TLTimeline.cpp
 *
 * @brief Dynawo timeline : implementation for iterator
 *
 */

#include "TLTimeline.h"
#include "TLTimelineImpl.h"

using boost::shared_ptr;

namespace timeline {

Timeline::event_const_iterator::event_const_iterator(const Timeline::Impl* iterated, bool begin) {
  impl_ = new BaseIteratorImpl(iterated, begin);
}

Timeline::event_const_iterator::event_const_iterator(const Timeline::event_const_iterator& original) {
  impl_ = new BaseIteratorImpl(*(original.impl_));
}

Timeline::event_const_iterator::~event_const_iterator() {
  delete impl_;
}

Timeline::event_const_iterator&
Timeline::event_const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

Timeline::event_const_iterator
Timeline::event_const_iterator::operator++(int) {
  Timeline::event_const_iterator previous = *this;
  (*impl_)++;
  return previous;
}

Timeline::event_const_iterator&
Timeline::event_const_iterator::operator--() {
  --(*impl_);
  return *this;
}

Timeline::event_const_iterator
Timeline::event_const_iterator::operator--(int) {
  Timeline::event_const_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
Timeline::event_const_iterator::operator==(const Timeline::event_const_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
Timeline::event_const_iterator::operator!=(const Timeline::event_const_iterator& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<Event>&
Timeline::event_const_iterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<Event>*
Timeline::event_const_iterator::operator->() const {
  return impl_->operator->();
}

}  // namespace timeline
