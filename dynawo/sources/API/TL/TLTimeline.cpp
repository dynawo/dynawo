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
 * @brief Dynawo timeline : implementation file
 *
 */
#include "TLTimeline.h"

#include "DYNCommon.h"
#include "TLEvent.h"
#include "TLEventFactory.h"

#include <boost/none.hpp>
#include <iostream>
#include <sstream>
#include <vector>

using boost::shared_ptr;
using std::string;
using std::vector;

namespace timeline {

Timeline::Timeline(const string& id) : id_(id) {}

void
Timeline::addEvent(const double& time, const string& modelName, const std::string& message, const boost::optional<int>& priority) {
  shared_ptr<Event> event = EventFactory::newEvent();
  event->setTime(time);
  event->setModelName(modelName);
  event->setMessage(message);
  event->setPriority(priority);
  if (events_.empty() || !eventEquals(*event, *events_.back()))
    events_.push_back(event);
}

bool
Timeline::eventEquals(const Event& left, const Event& right) const {
  return DYN::doubleEquals(left.getTime(), right.getTime()) && left.getModelName() == right.getModelName() && left.hasPriority() == right.hasPriority() &&
         (!left.hasPriority() || !right.hasPriority() || left.getPriority() == right.getPriority()) && left.getMessage() == right.getMessage();
}

int
Timeline::getSizeEvents() {
  return events_.size();
}

Timeline::event_const_iterator
Timeline::cbeginEvent() const {
  return Timeline::event_const_iterator(this, true);
}

Timeline::event_const_iterator
Timeline::cendEvent() const {
  return Timeline::event_const_iterator(this, false);
}

void
Timeline::eraseEvents(int nbEvents) {
  std::vector<boost::shared_ptr<Event> >::iterator firstPosition = events_.end();
  for (int i = 0; i < nbEvents; i++)
    firstPosition--;
  events_.erase(firstPosition, events_.end());
}

Timeline::event_const_iterator::event_const_iterator(const Timeline* iterated, bool begin) :
    current_((begin ? iterated->events_.begin() : iterated->events_.end())) {}

Timeline::event_const_iterator&
Timeline::event_const_iterator::operator++() {
  ++current_;
  return *this;
}

Timeline::event_const_iterator
Timeline::event_const_iterator::operator++(int) {
  Timeline::event_const_iterator previous = *this;
  current_++;
  return previous;
}

Timeline::event_const_iterator&
Timeline::event_const_iterator::operator--() {
  --current_;
  return *this;
}

Timeline::event_const_iterator
Timeline::event_const_iterator::operator--(int) {
  Timeline::event_const_iterator previous = *this;
  current_--;
  return previous;
}

bool
Timeline::event_const_iterator::operator==(const Timeline::event_const_iterator& other) const {
  return current_ == other.current_;
}

bool
Timeline::event_const_iterator::operator!=(const Timeline::event_const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<Event>& Timeline::event_const_iterator::operator*() const {
  return *current_;
}

const shared_ptr<Event>* Timeline::event_const_iterator::operator->() const {
  return &(*current_);
}

}  // namespace timeline
