//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file  DYNRingBuffer.h
 *
 * @brief Ring Buffer class header
 *
 */
#ifndef MODELER_COMMON_DYNRINGBUFFER_H_
#define MODELER_COMMON_DYNRINGBUFFER_H_

#include <cstddef>
#include <deque>
#include <utility>
#include <vector>

namespace DYN {

/**
 * @brief Ring buffer for delay
 *
 * Implements circular buffer for delay variables
 *
 * When a variable value is added, the previous elements which timepoint that satisfies t - maxDelay < tmax (where tmax is the most recent timepoint added) are removed
 *
 * When a variable value is requested, if the requested timepoint does not correspond to an element, linear interpolation is performed to retrieve the value
 */
class RingBuffer {
 public:
  /**
   * @brief Constructor
   *
   * @param maxDelay the maximum delay allowed
   */
  explicit RingBuffer(double maxDelay);

  /**
   * @brief Add a timed value
   *
   * After adding the value to the buffer, useless points which cannot be reached by using the maximum delay allowed are removed from the buffer
   *
   * @param time timestamp of the value
   * @param value value of the variable
   */
  void add(double time, double value);

  /**
   * @brief Add timed value without performing other actions
   *
   * @param time timestamp of the value
   * @param value value of the variable
   */
  void addNoCheck(double time, double value) {
    queue_.push_back(std::make_pair(time, value));
  }

  /**
   * @brief Set the maximum allowed delay
   *
   * @param delayMax maximum allowed delay
   */
  void maxDelay(double delayMax) {
    maxDelay_ = delayMax;
  }

  /**
   * @brief Retrieve the variable's value with delay
   *
   * Computes the value associated with the timepoint @a time - @a delay.
   * Performs linear interpolation if necessary and when it is possible
   *
   * @param time the timepoint requested
   * @param delay the delay requested
   * @throw SIMULATION error if the computed timepoint is beyon the maximum delay
   *
   * @returns the computed value
   */
  double get(double time, double delay) const;

  /**
   * @brief Retrieves the number of elements stored in buffer
   *
   * @returns the current size of the buffer
   */
  size_t size() const {
    return queue_.size();
  }

  /**
   * @brief Retrieves maximum delay
   *
   * @returns maximum delay
   */
  double maxDelay() const {
    return maxDelay_;
  }

  /**
   * @brief Retrieves the list of registered timed values as a vector
   *
   * @param vec The list of timed values
   */
  void points(std::vector<std::pair<double, double> >& vec) const;


  /**
   * @brief Retrieves the last registered values (time, value) in the ring buffer
   *
   * @return the last registered values (time, value) in the ring buffer
   */
  std::pair<double, double> getLastRegisteredPoint() const {
    return queue_.back();
  }

 private:
  /**
   * @brief Performs linear interpolation between the two 2D points @p p1 and @p p2 in abcisse @p time
   *
   * @param p1 the first point of interpolation
   * @param p2 the second point of interpolation
   * @param time the abcisse to compute the interpolation at
   *
   * @returns the interpolated value at @a time
   */
  static double interpol(const std::pair<double, double>& p1, const std::pair<double, double>& p2, double time);

 private:
  /**
   * @brief Remove from the buffer useless variables
   */
  void removeUseless();

  /**
   * @brief Compare pair only using its first element (time)
   *
   * @param pair the pair to test
   * @param time_value the time_value to compare the pair to
   *
   * @returns true if the time_value is the pair is less than the time_value
   */
  bool comparePairTime(const std::pair<double, double>& pair, double time_value) const;

 private:
  std::deque<std::pair<double, double> > queue_;  ///< queue of  (timestamp, value) pairs
  double maxDelay_;                               ///< maximum delay allowed for this buffer
};
}  // namespace DYN

#endif  // MODELER_COMMON_DYNRINGBUFFER_H_
