//
// Copyright (c) 2023, RTE (http://www.rte-france.com)
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
 * @file JOBPeriodicOutputsEntry.h
 * @brief FinalValues entries description : interface file
 *
 */

#include <string>

#ifndef API_JOB_JOBPERIODICOUTPUTSENTRY_H_
#define API_JOB_JOBPERIODICOUTPUTSENTRY_H_

namespace job {

/**
 * @class PeriodicOutputsEntry
 * @brief Final values entries container class
 */
class PeriodicOutputsEntry {
 public:
  /**
   * @brief constructor
   */
  PeriodicOutputsEntry();

  /**
   * @brief Periodic outputs file setter
   * @param file : Periodic outputs
   */
  void setFile(const std::string& file);

  /**
   * @brief Periodic outputs file getter
   * @return Periodic outputs file
   */
  const std::string& getFile() const;

  /**
   * @brief Periodic outputs period setter
   * @param period : Periodic outputs
   */
  void setPeriod(const float period);

  /**
   * @brief Periodic outputs period getter
   * @return Periodic outputs period
   */
  const float getPeriod() const;

  /**
   * @brief Periodic outputs adapter setter
   * @param adapter : Periodic adapter
   */
  void setAdapter(const std::string& adapter);

  /**
   * @brief Periodic outputs adapter getter
   * @return Periodic outputs adapter
   */
  const std::string& getAdapter() const;

 private:
  std::string file_;       ///< file where periodic outputs are defined
  float period_;           ///< period at which periodic outputs are defined
  std::string adapter_;    ///< adapter type for the output where periodic outputs are defined
};

}  // namespace job

#endif  // API_JOB_JOBPERIODICOUTPUTSENTRY_H_
