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
 * @file  TLTimelineImpl.cpp
 *
 * @brief Dynawo timeline : implementation file
 *
 */
#include <sstream>
#include <iostream>
#include <vector>
#include <boost/none.hpp>
#include "DYNCommon.h"
#include "TLTimelineImpl.h"
#include "TLEvent.h"
#include "TLEventFactory.h"

using std::string;
using std::stringstream;
using std::vector;
using boost::shared_ptr;

namespace timeline {

Timeline::Impl::Impl(const string& id) :
id_(id) {
}

Timeline::Impl::~Impl() {
}

void
Timeline::Impl::addEvent(const double& time, const string& modelName,
        const std::string& message, const boost::optional<int>& priority) {
  shared_ptr<Event> event = EventFactory::newEvent();
  event->setTime(time);
  event->setModelName(modelName);
  event->setMessage(message);
  event->setPriority(priority);
  if (events_.empty() || !eventEquals(*event, *events_.back()))
    events_.push_back(event);
}

bool
Timeline::Impl::eventEquals(const Event& left, const Event& right) const {
  return DYN::doubleEquals(left.getTime(), right.getTime()) &&
      left.getModelName() == right.getModelName() &&
      left.hasPriority() == right.hasPriority() &&
      (!left.hasPriority() || !right.hasPriority() || left.getPriority() == right.getPriority()) &&
      left.getMessage() == right.getMessage();
}


int
Timeline::Impl::getSizeEvents() {
  return events_.size();
}

Timeline::event_const_iterator
Timeline::Impl::cbeginEvent() const {
  return Timeline::event_const_iterator(this, true);
}

Timeline::event_const_iterator
Timeline::Impl::cendEvent() const {
  return Timeline::event_const_iterator(this, false);
}

void
Timeline::Impl::eraseEvents(int nbEvents) {
  std::vector<boost::shared_ptr<Event> >::iterator firstPosition = events_.end();
  for (int i = 0; i < nbEvents; i++)
    firstPosition--;
  events_.erase(firstPosition, events_.end());
}

Timeline::BaseIteratorImpl::BaseIteratorImpl(const Timeline::Impl* iterated, bool begin) :
current_((begin ? iterated->events_.begin() : iterated->events_.end())) { }

Timeline::BaseIteratorImpl::~BaseIteratorImpl() {
}

Timeline::BaseIteratorImpl&
Timeline::BaseIteratorImpl::operator++() {
  ++current_;
  return *this;
}

Timeline::BaseIteratorImpl
Timeline::BaseIteratorImpl::operator++(int) {
  Timeline::BaseIteratorImpl previous = *this;
  current_++;
  return previous;
}

Timeline::BaseIteratorImpl&
Timeline::BaseIteratorImpl::operator--() {
  --current_;
  return *this;
}

Timeline::BaseIteratorImpl
Timeline::BaseIteratorImpl::operator--(int) {
  Timeline::BaseIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
Timeline::BaseIteratorImpl::operator==(const Timeline::BaseIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
Timeline::BaseIteratorImpl::operator!=(const Timeline::BaseIteratorImpl& other) const {
  return current_ != other.current_;
}

const shared_ptr<Event>&
Timeline::BaseIteratorImpl::operator*() const {
  return *current_;
}

const shared_ptr<Event>*
Timeline::BaseIteratorImpl::operator->() const {
  return &(*current_);
}

}  // namespace timeline
