//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file  DYNDelay.h
 *
 * @brief Delay structure header
 *
 */
#ifndef MODELER_COMMON_DYNDELAY_H_
#define MODELER_COMMON_DYNDELAY_H_

#include "DYNRingBuffer.h"

#include <boost/optional.hpp>
#include <cstddef>
#include <utility>
#include <iostream>

namespace DYN {
/**
 * @brief Structure to store delay variables
 */
class Delay {
 public:
  /**
   * @brief Constructor by input reference
   *
   * This constructor will be used during a normal simulation
   *
   * @param time pointer to the time variable used for this delay
   * @param value pointer to the value variable used for this delay
   * @param delayMax maximum allowed delay
   */
  Delay(const double* time, const double* value, double delayMax);

  /**
   * @brief Constructor by timepoints
   *
   * This constructor wil be used to start a simulation from a dump
   *
   * @param timepoints the list of the timepoints to use
   */
  explicit Delay(const std::vector<std::pair<double, double> >& timepoints, double delayMax);

  /**
   * @brief Update reference internal values
   *
   * This function MUST NOT be called for delays constructed with the references (Delay(time, value, delayMax))
   *
   * @param time pointer to the time variable used for this delay
   * @param value pointer to the value variable used for this delay
   * @param delayMax maximum allowed delay
   */
  void update(const double* time, const double* value, double delayMax);

  /**
   * @brief Record a timepoint with the current value
   */
  void saveTimepoint();

  /**
   * @brief Retrieves the delayed variable
   *
   * Use the underlying ring buffer
   *
   * @param delay the delay to apply
   *
   * @returns the value where timepoint is the delayed time value
   */
  double getDelay(double delay) const {
    return buffer_.get(*time_, delay);
  }

  /**
   * @brief Retrieves the size of the delay
   *
   * @returns the number of saved timepoints
   */
  size_t size() const {
    return buffer_.size();
  }

  /**
   * @brief Retrieves initial value of variable
   *
   * @returns initial value
   */
  const boost::optional<double>& initialValue() const {
    return initialValue_;
  }

  /**
   * @brief Retrieves the list of registered timepoints
   *
   * @param vec the list of registered time points
   */
  void points(std::vector<std::pair<double, double> >& vec) const {
    buffer_.points(vec);
  }

  /**
   * @brief Trigger the delay to notify that we must start compute its value
   */
  void trigger(double /*time*/, double /*delayTime*/, const std::string& /*name*/) {
    if (!trigger_.is_initialized()) {
      trigger_ = true;
      triggerValue_ = true;
    }
  }

  /**
   * @brief Reset trigger
   *
   * This has no effect if trigger is not activated.
   * After this call, the trigger can no longer be activated
   */
  void resetTrigger() {
    if (trigger_.is_initialized()) {
      trigger_ = false;
    }
  }

  /**
   * @brief Determines if delay is triggered
   *
   * @returns Whether the trigger has been activated by @a trigger() function
   */
  bool isTriggered() const {
    return trigger_.is_initialized() && *trigger_;
  }

  bool isTriggeredValue() const {
    return triggerValue_;
  }

  double getDelayMax() const {
    return delayMax_;
  }

 private:
  const double* time_;                    ///< pointer to time to use for timepoint and delay computation
  const double* value_;                   ///< pointer to value to use for timepoint
  double delayMax_;                       ///<
  RingBuffer buffer_;                     ///< ring buffer to manage the records
  boost::optional<double> initialValue_;  ///< Initial value to use when delay cannot be computed
  boost::optional<bool> trigger_;         ///< 3-state trigger to determine the first time the delay is computed
  bool triggerValue_;         ///< 3-state trigger to determine the first time the delay is computed
};
}  // namespace DYN

#endif  // MODELER_COMMON_DYNDELAY_H_
