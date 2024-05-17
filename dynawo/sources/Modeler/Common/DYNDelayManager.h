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
 * @file  DYNDelayManager.h
 *
 * @brief Delays manager header
 *
 */
#ifndef MODELER_COMMON_DYNDELAYMANAGER_H_
#define MODELER_COMMON_DYNDELAYMANAGER_H_

#include "DYNDelay.h"
#include "DYNEnumUtils.h"

#include <unordered_map>


namespace DYN {
/**
 * @brief Manager for delay variables
 *
 * Since during the resolution, timepoints are not stable, timepoints are saved in a temporary map, waiting for
 * external notification to copy these information into the official map that is used for delayed value computation
 */
class DelayManager {
 public:
  /**
   * @brief Constructor
   */
  DelayManager();

  /**
   * @brief Add a delay variable when delay is a variable
   *
   * This initializes the delay with the first value
   *
   * @param id the id of the delay
   * @param time pointer to the time value
   * @param value pointer to the value
   * @param delayMax maximum delay allowed
   */
  void addDelay(size_t id, const double* time, const double* value, double delayMax);

  /**
   * @brief Save timepoints of all registered delays
   */
  void saveTimepoint();

  /**
   * @brief Get the delayed value
   *
   * Retrieves the delayed value of current timepoint refered by variable given at construction of delay @p id , delayed of @p delayValue
   *
   * Precondition: the id is acceptable (isIdAcceptable returns true)
   *
   * @param id the delay id to use
   * @param delayValue the delay to apply
   *
   * @returns the pair (delayed_timepoint, value)
   */
  double getDelay(size_t id, double delayValue) const;

  /**
   * @brief Checks whether the id is an acceptable delay manager id
   *
   * If an unacceptable id is used in APIs, an exception is raised (out of range)
   *
   * @param id the delay id to check
   *
   * @returns whether the id is allowed
   */
  bool isIdAcceptable(size_t id) const {
    return delays_.count(id) > 0;
  }

  /**
   * @brief Retrieves initial value of delay
   *
   * @param id the delay id to use
   *
   * @returns the initial value of the delay, if exists
   */
  const boost::optional<double>& getInitialValue(size_t id) const;

  /**
   * @brief Format delay manager information
   *
   * This list of string follows the following format:
   * 1 line by delay, and for each delay:
   *
   * id:time1,value1;time2,value2;...
   *
   * where id is the delay id ; timex, valuex are the pairs defining a timepoint
   *
   * @returns the formatted delays
   */
  std::vector<std::string> dumpDelays() const;

  /**
   * @brief Load delays from their formatted version
   *
   * @param values the delays definition, formatted according to the format defined by dumpDelays
   * @param time of the restart
   *
   * @returns false if an parsing error occurs, true if not
   */
  bool loadDelays(const std::vector<std::string>& values, double time);

  /**
   * @brief calculates the roots of the model for delays
   *
   * @param p_glocal local buffer to fill
   * @param offset offset to start in p_glocal array for delays
   * @param t local time
   */
  void setGomc(state_g* const p_glocal, size_t offset, const double t);

  /**
  * @brief evaluate modes for delays
  *
  * @param t local time
  *
  * @return mode change type value
  */
  modeChangeType_t evalMode(double t);

  /**
   * @brief Trigger delay
   *
   * pre-condition: the delay id is acceptable
   *
   * @param id the delay id
   */
  void triggerDelay(size_t id) {
    delays_.at(id).trigger();
  }

  /**
  * @brief Retrieves the delay by id (const version)
  *
  * Precondition: the id is acceptable
  *
  * @param id the id to use
  * @returns the corresponding delay
  */
  const Delay& getDelayById(size_t id) const {
    return delays_.at(id);
  }

  /**
   * @brief Set the time of the delay for delay with corresponding id
   *
   * @param id the id to use
   * @param delayTime the time of the delay
   */
  void setDelayTime(size_t id, double delayTime) {
    delays_.at(id).setDelayTime(delayTime);
  }

 private:
  std::unordered_map<size_t, Delay> delays_;  ///< list of registered delayed values
};
}  // namespace DYN

#endif  // MODELER_COMMON_DYNDELAYMANAGER_H_
