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
 * @file  TLTimeline.h
 *
 * @brief Dynawo timeline : interface file
 *
 */
#ifndef API_TL_TLTIMELINE_H_
#define API_TL_TLTIMELINE_H_

#include "TLEvent.h"

#include <boost/none.hpp>
#include <boost/optional.hpp>
#include <boost/shared_ptr.hpp>
#include <string>
#include <vector>
#include <unordered_set>
#include <unordered_map>

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

 public:
  /**
   * @class event_const_iterator
   * @brief Const iterator over events
   *
   * Const iterator over events stored in timeline
   */
  class event_const_iterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on events. Can create an iterator to the
     * beginning of the events' container or to the end. Events
     * cannot be modified.
     *
     * @param iterated Pointer to the events' set iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the events' container.
     */
    event_const_iterator(const Timeline* iterated, bool begin);

    /**
     * @brief Prefix-increment operator
     *
     * @returns Reference to this event_const_iterator
     */
    event_const_iterator& operator++();

    /**
     * @brief Postfix-increment operator
     *
     * @returns Copy of this event_const_iterator
     */
    event_const_iterator operator++(int);

    /**
     * @brief Prefix-decrement operator
     *
     * @returns Reference to this event_const_iterator
     */
    event_const_iterator& operator--();

    /**
     * @brief Postfix-decrement operator
     *
     * @returns Copy of this event_const_iterator
     */
    event_const_iterator operator--(int);

    /**
     * @brief Equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are equals, else false
     */
    bool operator==(const event_const_iterator& other) const;

    /**
     * @brief Not equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are different, else false
     */
    bool operator!=(const event_const_iterator& other) const;

    /**
     * @brief Indirection operator
     *
     * @returns Event pointed to by this
     */
    const boost::shared_ptr<Event>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Pointer to the Event pointed to by this
     */
    const boost::shared_ptr<Event>* operator->() const;

   private:
    std::vector<boost::shared_ptr<Event> >::const_iterator current_;  ///< current set iterator
  };

  /**
   * @brief Get an event_const_iterator to the beginning of the events' set
   * @return beginning of constant iterator
   */
  event_const_iterator cbeginEvent() const;

  /**
   * @brief Get an event_const_iterator to the end of the parameters' set
   * @return end of constant iterator
   */
  event_const_iterator cendEvent() const;

  /**
   * @brief Erase the nbEvents in the timeline being before lastEventPosition
   *
   * @param nbEvents number of events to delete from the timeline starting from last event
   */

  void eraseEvents(int nbEvents);

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
  std::vector<boost::shared_ptr<Event> > events_;  ///< Array of events
  std::string id_;                                 ///< Timeline's id
};

}  // namespace timeline

#endif  // API_TL_TLTIMELINE_H_
