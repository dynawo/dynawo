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
#ifdef LANG_CXX11
  events_.emplace(event);
#else
  events_.insert(event);
#endif
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
Timeline::Impl::eraseEvents(int nbEvents, Timeline::event_const_iterator lastEventPosition) {
  Timeline::event_const_iterator firstPosition = lastEventPosition;
  for (int i = 0; i < nbEvents; i++)
    firstPosition--;

  vector<shared_ptr<Event> > eventsToErase;
  for (Timeline::event_const_iterator iE = firstPosition; iE != lastEventPosition; iE++)
    eventsToErase.push_back(*iE);

  for (vector<shared_ptr<Event> >::const_iterator iV = eventsToErase.begin(); iV != eventsToErase.end(); iV++)
    events_.erase(*iV);
}

Timeline::BaseIteratorImpl::BaseIteratorImpl(const Timeline::Impl* iterated, bool begin) {
  current_ = (begin ? iterated->events_.begin() : iterated->events_.end());
}

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
