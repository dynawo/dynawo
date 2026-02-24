//
// Copyright (c) 2025, RTE
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
 * @file JOBClockEntry.h
 * @brief Clock entry description : interface file
 */

#ifndef API_JOB_JOBCLOCKENTRY_H_
#define API_JOB_JOBCLOCKENTRY_H_

#include <string>
#include <boost/optional.hpp>

namespace job {

/**
 * @class ClockEntry
 * @brief Clock entry container class
 */
class ClockEntry {
 public:
  /**
   * @brief Type attribute getter
   * @return Clock type ("INTERNAL" or "EXTERNAL")
   */
  const std::string& getType() const;

  /**
   * @brief Speedup attribute getter
   * @return Speed-up factor (optional)
   */
  boost::optional<double> getSpeedup() const;

  /**
   * @brief Trigger channel attribute getter
   * @return Trigger channel as string (optional)
   */
  const std::string& getTriggerChannel() const;

  /**
   * @brief Type attribute setter
   * @param type Clock type ("INTERNAL" or "EXTERNAL")
   */
  void setType(const std::string& type);

  /**
   * @brief Speedup attribute setter
   * @param speedup Speed-up factor
   */
  void setSpeedup(boost::optional<double> speedup);

  /**
   * @brief Trigger channel attribute setter
   * @param triggerChannel Trigger channel
   */
  void setTriggerChannel(const std::string& triggerChannel);

 private:
  std::string type_;                 ///< Clock type (INTERNAL or EXTERNAL)
  boost::optional<double> speedup_;  ///< Speed-up factor (optional)
  std::string triggerChannel_;       ///< Trigger channel (optional)
};

}  // namespace job

#endif  // API_JOB_JOBCLOCKENTRY_H_
