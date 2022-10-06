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

#include <boost/optional.hpp>
#include <string>

namespace timeline {

/**
 * @class Event
 * @brief Event interface class
 *
 * Interface class for event. Event is a container describing an event which occurs
 * during simulation:  for describing an event, there is three field: time of event,
 * model name in which event's occurs and message to describe the event
 */
class Event {
 public:
  /**
   * @brief Constructor
   */
  Event();

  /**
   * @brief Setter for event's time
   * @param time event's time
   */
  void setTime(const double& time);

  /**
   * @brief Setter for modelName for which event occurs
   * @param modelName Model's name for which event occurs
   */
  void setModelName(const std::string& modelName);

  /**
   * @brief Setter for event's message
   * @param message message to describe event
   */
  void setMessage(const std::string& message);

  /**
   * @brief Setter for event's priority
   * @param priority priority to describe event
   */
  void setPriority(const boost::optional<int>& priority);

  /**
   * @brief Getter for event's time
   * @return event's time
   */
  double getTime() const;

  /**
   * @brief Getter for modelName for which event occurs
   * @return Model's name for which event occurs
   */
  const std::string& getModelName() const;

  /**
   * @brief Getter for event's message
   * @return message to describe event
   */
  const std::string& getMessage() const;

  /**
   * @brief Indicates if the event has a priority
   * @return boolean to know if event has priority
   */
  inline bool hasPriority() const {
    return (priority_ != boost::none);
  }

  /**
   * @brief Getter for event's priority
   * @return priority to describe event
   */
  inline int getPriority() const {
    assert(priority_ != boost::none && "Priority should not be none as this point to be able to export it.");
    return *priority_;
  }

  /**
   * @brief Setter for event's key
   * @param key new key to describe event
   */
  inline void setKey(const std::string& key) {
    key_ = key;
  }

  /**
   * @brief Getter for event's key
   * @return key to describe event
   */
  inline const std::string& getKey() const {
    return key_;
  }

 private:
  double time_;                    ///< event's time
  std::string modelName_;          ///< Model's name for which event occurs
  std::string message_;            ///<  message to describe event
  std::string key_;                 ///<  key used from the timeline dictionary, empty if none
  boost::optional<int> priority_;  ///< priority of the event
};

}  // namespace timeline

#endif  // API_TL_TLEVENT_H_
