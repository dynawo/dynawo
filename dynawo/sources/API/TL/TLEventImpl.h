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
 * @file  TLEventImpl.h
 *
 * @brief Dynawo timeline event : header file
 *
 */
#ifndef API_TL_TLEVENTIMPL_H_
#define API_TL_TLEVENTIMPL_H_

#include "TLEvent.h"

namespace timeline {

/**
 * @class Event::Impl
 * @brief Event implemented class
 *
 * Implementation of Event interface class
 */

class Event::Impl : public Event {
 public:
  /**
   * @brief Constructor
   */
  Impl();

  /**
   * @brief Destructor
   */
  ~Impl();

  /**
   * @copydoc Event::setTime(const double& time)
   */
  void setTime(const double& time);

  /**
   * @copydoc Event::setModelName(const std::string& modelName)
   */
  void setModelName(const std::string& modelName);

  /**
   * @copydoc Event::setMessage(const std::string& message)
   */
  void setMessage(const std::string& message);

  /**
   * @copydoc Event::setPriority(const boost::optional<int>& priority)
   */
  void setPriority(const boost::optional<int>& priority);

  /**
   * @copydoc Event::getTime()
   */
  double getTime() const;

  /**
   * @copydoc Event::getModelName()
   */
  const std::string& getModelName() const;

  /**
   * @copydoc Event::getMessage()
   */
  const std::string& getMessage() const;

  /**
   * @copydoc Event::hasPriority()
   */
  inline bool hasPriority() const { return (priority_ != boost::none); }

  /**
   * @copydoc Event::getPriority()
   */
  inline int getPriority() const {
    assert(priority_ != boost::none && "Priority should not be none as this point to be able to export it.");
    return *priority_;
  }

 private:
  double time_;  ///< event's time
  std::string modelName_;  ///< Model's name for which event occurs
  std::string message_;  ///<  message to describe event
  boost::optional<int> priority_;  ///< priority of the event
};
}  // namespace timeline

#endif  // API_TL_TLEVENTIMPL_H_

