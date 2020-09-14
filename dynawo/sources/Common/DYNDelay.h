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
 * @file  DYNDelay.h
 *
 * @brief Delay structure header
 *
 */
#ifndef COMMON_DYNDELAY_H_
#define COMMON_DYNDELAY_H_

#include "DYNRingBuffer.h"

#include <utility>

namespace DYN {
/**
 * @brief Structure to store delay variables
 *
 * A delay has members pointing on value buffers that will change in time outside this structure.
 *
 * The delay can be a variable, represented by a pointer which value will be updated outside the class, or a number.
 */
class Delay {
 public:
  /**
   * @brief Constructor with delay as a variable
   *
   * @param value pointer on value variable
   * @param delay pointer on delay variable
   * @param delayMax maximum allowed delay
   */
  Delay(const double* value, const double* delay, double delayMax);

  /**
   * @brief Constructor with constant delay
   *
   * In that case, the delay used when retrieving values will be the same as maximum delay
   *
   * @param value pointer on value variable
   * @param delay constant delay value
   */
  Delay(const double* value, double delay);

  /**
   * @brief Record a timepoint with the current value
   *
   * @param time the timepoint of the record
   */
  void saveTimepoint(double time);

  /**
   * @brief Retrieves the delayed variable
   *
   * Use the underlying ring buffer
   *
   * @param time the timepoint when to start the delay
   * @returns the pair (timepoint, value) where timepoint is the delayed time value
   */
  std::pair<double, double> getDelay(double time) const;

  std::pair<double, double> getLastDelay() const {
    return buffer_.last();
  }

  size_t size() const {
    return buffer_.size();
  }

 private:
  /**
   * @brief Determines if the delay is constant
   *
   * the criteria delay_==NULL is enough
   *
   * @returns whether the delay is constant or a variable
   */
  bool isDelayConstant() const {
    return delay_ == NULL;
  }

 private:
  const double* value_;  ///< current value to use
  const double* delay_;  ///< current delay variable to use, can be NULL for constant delay
  RingBuffer buffer_;    ///< ring buffer to manage the records
};
}  // namespace DYN

#endif  // COMMON_DYNDELAY_H_
