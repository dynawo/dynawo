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
 * @file  DYNDelayManager.h
 *
 * @brief Delays manager header
 *
 */
#ifndef COMMON_DYNDELAYMANAGER_H_
#define COMMON_DYNDELAYMANAGER_H_

#include "DYNDelay.h"

#include <vector>

namespace DYN {
/**
 * @brief Manager for delay variables
 */
class DelayManager {
 public:
  /**
   * @brief Add a delay variable when delay is a variable
   *
   * @param value pointer to the memory of the value variable
   * @param delay pointer to the memory of the delay variable
   * @param delayMax maximum delay allowed
   *
   * @returns the id of the delay variable in the manager
   */
  size_t addDelay(const double* value, const double* delay, double delayMax);

  /**
   * @brief Add a delay variable when delay is constant
   *
   * @param value pointer to the memory of the value variable
   * @param delay delay value
   *
   * @returns the id of the delay variable in the manager
   */
  size_t addDelay(const double* value, double delay);

  /**
   * @brief Save a timepoint for delay value of id @p value_id
   *
   * Precondition: the id is acceptable (isIdAcceptable returns true)
   *
   * @param value_id the delayed value id
   * @param time the timepoint to save
   */
  void saveTimepoint(size_t value_id, double time);

  /**
   * @brief Get the delayed value
   *
   * Retrieves the delayed value of timepoint @p time of value @p value_id
   *
   * Precondition: the id is acceptable (isIdAcceptable returns true)
   *
   * @param value_id the delay manager id to use
   * @param time the original timepoint to delay
   *
   * @returns the pair (delayed_timepoint, value)
   */
  std::pair<double, double> getDelay(size_t value_id, double time) const;

  /**
   * @brief Checks whether the id is an acceptable delay manager id
   *
   * If an unacceptable id is used in @p saveTimepoint or @p getDelay, an exception is raised (out of range)
   *
   * @param id the manager id to check
   *
   * @returns whether the id is allowed
   */
  bool isIdAcceptable(size_t id) const {
    return id <= delays_.size();
  }

 private:
  /**
   * @brief Generate a manager id for values
   *
   * Uses delay internal array size. Since this function is only called after adding a new delay, the id is unique
   *
   * @returns the new id
   */
  size_t generateId() const {
    return delays_.size();
  }

  /**
   * @brief Retrieves the delay by id
   *
   * Precondition: the id is acceptable
   *
   * @param value_id the id to use
   * @returns the corresponding delay
   */
  Delay& getDelayById(size_t value_id) {
    return delays_.at(value_id - 1);
  }

  /**
   * @brief Retrieves the delay by id (const version)
   *
   * Precondition: the id is acceptable
   *
   * @param value_id the id to use
   * @returns the corresponding delay
   */
  const Delay& getDelayById(size_t value_id) const {
    return delays_.at(value_id - 1);
  }

 private:
  std::vector<Delay> delays_;  ///< list of registered delayed values
};
}  // namespace DYN

#endif  // COMMON_DYNDELAYMANAGER_H_
