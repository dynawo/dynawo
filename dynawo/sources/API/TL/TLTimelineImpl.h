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
 * @file  TLTimelineImpl.h
 *
 * @brief Dynawo timeline : header file
 *
 */
#ifndef API_TL_TLTIMELINEIMPL_H_
#define API_TL_TLTIMELINEIMPL_H_

#include <set>

#include <boost/shared_ptr.hpp>

#include "TLTimeline.h"
#include "TLEventCmp.h"

namespace timeline {
class Event;

/**
 * @class Timeline::Impl
 * @brief Timeline implemented class
 *
 * Implementation of Timeline interface class
 */
class Timeline::Impl : public Timeline {
 public:
  /**
   * @brief constructor
   *
   * @param id Timeline's id
   */
  explicit Impl(const std::string& id);

  /**
   * @brief Destructor
   */
  ~Impl();

  /**
   * @copydoc Timeline::addEvent(const double& time, const std::string& modelName, const std::string& message, const boost::optional<int>& priority)
   */
  void addEvent(const double& time, const std::string& modelName, const std::string& message, const boost::optional<int>& priority);


  /**
   * @copydoc Timeline::getSizeEvents()
   */
  int getSizeEvents();

  /**
   * @copydoc Timeline::cbeginEvent()
   */
  virtual event_const_iterator cbeginEvent() const;

  /**
   * @copydoc Timeline::cendEvent()
   */
  virtual event_const_iterator cendEvent() const;

  /**
   * @copydoc Timeline::eraseEvents(int nbEvents, event_const_iterator lastEventPosition)
   */
  void eraseEvents(int nbEvents, Timeline::event_const_iterator lastEventPosition);

  friend class Timeline::BaseIteratorImpl;

 private:
  /**
   * @brief Constructor
   */
#ifdef LANG_CXX11
  Impl() = delete;
#else
  Impl();
#endif

  std::set<boost::shared_ptr<Event>, EventCmp > events_;  ///< Set of events
  std::string id_;  ///< Timeline's id
};

/**
 * @class Timeline::BaseIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class Timeline::BaseIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on timeline. Can create an implementation for
   * an iterator to the beginning of the events' container or to the end.
   *
   * @param iterated Pointer to the events' set iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the events' container.
   * @returns Created implementation object
   */
  BaseIteratorImpl(const Timeline::Impl* iterated, bool begin);

  /**
   * @brief Destructor
   */
  ~BaseIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this const_iterator
   */
  BaseIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this const_iterator
   */
  BaseIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this const_iterator
   */
  BaseIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this const_iterator
   */
  BaseIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const BaseIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const BaseIteratorImpl& other)const;

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
  std::set<boost::shared_ptr<Event>, EventCmp >::const_iterator current_;  ///< current set iterator
};

}  // namespace timeline

#endif  // API_TL_TLTIMELINEIMPL_H_
