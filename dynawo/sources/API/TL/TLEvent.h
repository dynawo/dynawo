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
 * @file  TLEvent.h
 *
 * @brief Dynawo timeline event : interface file
 *
 */
#ifndef API_TL_TLEVENT_H_
#define API_TL_TLEVENT_H_

#include <string>
#include <boost/optional.hpp>
#include "TLExport.h"

namespace timeline {

/**
 * @class Event
 * @brief Event interface class
 *
 * Interface class for event. Event is a container describing an event which occurs
 * during simulation:  for describing an event, there is three field: time of event,
 * model name in which event's occurs and message to describe the event
 */
class __DYNAWO_TL_EXPORT Event {
 public:
  virtual ~Event() { }

  /**
   * @brief Setter for event's time
   * @param time event's time
   */
  virtual void setTime(const double& time) = 0;

  /**
   * @brief Setter for modelName for which event occurs
   * @param modelName Model's name for which event occurs
   */
  virtual void setModelName(const std::string& modelName) = 0;

  /**
   * @brief Setter for event's message
   * @param message message to describe event
   */
  virtual void setMessage(const std::string& message) = 0;

  /**
   * @brief Setter for event's priority
   * @param priority priority to describe event
   */
  virtual void setPriority(const boost::optional<int>& priority) = 0;

  /**
   * @brief Getter for event's time
   * @return event's time
   */
  virtual double getTime() const = 0;

  /**
   * @brief Getter for modelName for which event occurs
   * @return Model's name for which event occurs
   */
  virtual const std::string& getModelName() const = 0;

  /**
   * @brief Getter for event's message
   * @return message to describe event
   */
  virtual const std::string& getMessage() const = 0;

  /**
   * @brief Indicates if the event has a priority
   * @return boolean to know if event has priority
   */
  virtual bool hasPriority() const = 0;

  /**
   * @brief Getter for event's priority
   * @return priority to describe event
   */
  virtual int getPriority() const = 0;

  class Impl;
};

}  // namespace timeline

#endif  // API_TL_TLEVENT_H_
