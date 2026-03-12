//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  TLTimeline.h
 *
 * @brief Dynawo timeline : interface file
 *
 */
#ifndef API_TL_TLTIMELINE_H_
#define API_TL_TLTIMELINE_H_

#include "TLEvent.h"

#include <boost/optional.hpp>
#include <string>
#include <vector>
#include <unordered_set>
#include <unordered_map>
#include <memory>

namespace timeline {

class Event;

/**
 * @class Timeline
 * @brief Timeline interface class
 *
 * Interface class for timeline object. This a container for events
 */
class Timeline {
 public:
  /**
   * @brief constructor
   *
   * @param id Timeline's id
   */
  explicit Timeline(const std::string& id);

  /**
   * @brief Copy constructor
   */
  Timeline(const Timeline&) = delete;

  /**
   * @brief Default copy assigment operator
   *
   * @return a new parameter
   */
  Timeline& operator=(const Timeline&) = delete;

  /**
   * @brief Add an event to the timeline
   *
   * @param time time when the event occurs
   * @param modelName model where the event occurs
   * @param message event message
   * @param priority event priority, optional
   * @param key event key, empty if none
   */
  void addEvent(const double& time, const std::string& modelName, const std::string& message, const boost::optional<int>& priority, const std::string& key);

  /**
   * @brief number of event getter
   *
   * @return the number of events stored in timeline
   */
  int getSizeEvents();

  /**
   * @brief filter the timeline by removing duplicated events and opposed events happening in the same time step
   *
   * @param oppositeEventDico the opposite event dictionary
   */
  void filter(const std::unordered_map<std::string, std::unordered_set<std::string>>& oppositeEventDico);

  /**
   * @brief Erase the nbEvents in the timeline being before lastEventPosition
   *
   * @param nbEvents number of events to delete from the timeline starting from last event
   */
  void eraseEvents(int nbEvents);

  /**
   * @brief number of event getter
   *
   * @return the number of events stored in timeline
   */
  const std::vector<std::unique_ptr<Event> >& getEvents() const {
    return events_;
  }

  /**
   * @brief empty constraint collection
   */
  void clear();

 private:
  /**
   * @brief compare two events
   *
   * @param left first event to compare
   * @param right second event to compare
   * @return true if left is the same event as right
   */
  bool eventEquals(const Event& left, const Event& right) const;

 private:
  std::vector<std::unique_ptr<Event> > events_;  ///< Array of events
  std::string id_;                               ///< Timeline's id
};

}  // namespace timeline

#endif  // API_TL_TLTIMELINE_H_
