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
#include <set>

using boost::shared_ptr;
using std::string;
using std::vector;
using std::map;
using std::unordered_map;
using std::unordered_set;
using std::set;


namespace timeline {

Timeline::Timeline(const string& id) : id_(id) {}

void
Timeline::addEvent(const double& time, const string& modelName, const std::string& message, const boost::optional<int>& priority, const std::string& key) {
  shared_ptr<Event> event = EventFactory::newEvent();
  event->setTime(time);
  event->setModelName(modelName);
  event->setMessage(message);
  event->setPriority(priority);
  event->setKey(key);
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
  return static_cast<int>(events_.size());
}

/**
 * @brief double comparison with tolerance
 */
struct dynawoDoubleLess : std::binary_function<double, vector<size_t>, bool> {
  /**
   * @brief double comparison with tolerance
   * @param left first real to compare
   * @param right second real to compare
   * @return true if left < right
   */
  bool operator() (const double left, const double right) const {
    return !DYN::doubleEquals(left, right) && left < right;
  }
};
void
Timeline::filter(const unordered_map<string, unordered_set<string>>& oppositeEventDico) {
  map<double, vector<size_t>, dynawoDoubleLess> timeToEventIndexes;
  for (size_t i = 0, iEnd = events_.size(); i < iEnd; ++i) {
    timeToEventIndexes[events_[i]->getTime()].push_back(i);
  }

  // Remove duplicated events
  set<size_t> indexesToRemove;
  for (const auto& it : timeToEventIndexes) {
    const auto& events = it.second;
    unordered_set<string> eventFounds;
    for (size_t i = 0, iEnd = events.size(); i < iEnd; ++i) {
      size_t index = events[events.size() -1 - i];
      if (indexesToRemove.find(index) != indexesToRemove.end()) {
        continue;
      }
      const auto& event = events_[index];
      string uniqueId = event->getModelName()+"_"+event->getMessage();
      if (eventFounds.find(uniqueId) == eventFounds.end()) {
        eventFounds.insert(uniqueId);
      } else {
        indexesToRemove.insert(index);
      }
    }
  }

  // Remove opposed events
  for (const auto& itEvent : timeToEventIndexes) {
    const auto& events = itEvent.second;
    size_t indexToCheck = 1;
    while (indexToCheck <= events.size() - 1) {
      if (indexesToRemove.find(events[events.size() - indexToCheck]) != indexesToRemove.end()) {
        ++indexToCheck;
        continue;
      }
      const auto& currEvent = events_[events[events.size() - indexToCheck]];
      const auto& it = oppositeEventDico.find(currEvent->getKey());
      if (it == oppositeEventDico.end()) {
        ++indexToCheck;
        continue;
      }
      const auto & eventKeysToDelete = it->second;

      for (size_t i = events.size() - indexToCheck - 1; i > 0; --i) {
        if (events_[events[i]]->getModelName() == currEvent->getModelName() &&
            eventKeysToDelete.find(events_[events[i]]->getKey()) != eventKeysToDelete.end()) {
          indexesToRemove.insert(events[i]);
        }
      }
      if (events_[events[0]]->getModelName() == currEvent->getModelName() &&
          eventKeysToDelete.find(events_[events[0]]->getKey()) != eventKeysToDelete.end()) {
        indexesToRemove.insert(events[0]);
      }
      ++indexToCheck;
    }
  }

  for (auto it = indexesToRemove.rbegin(), itEnd = indexesToRemove.rend(); it != itEnd; ++it) {
    events_.erase(events_.begin() + *it);
  }
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
