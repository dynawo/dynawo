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
 * @file JOBAllModesEntry.h
 * @brief AllModes entries description : interface file
 *
 */

#ifndef API_JOB_JOBALLMODESENTRY_H_
#define API_JOB_JOBALLMODESENTRY_H_

#include <string>

// #include "JOBExport.h"

namespace job {

/**
 * @class AllModesEntry
 * @brief AllModes entries container class
 */
class AllModesEntry {
 public:
  /**
   * @brief Destructor
   */
  virtual ~AllModesEntry() {}

  /**
   * @brief All Modes time setter
   * @param AllModesTime : Start time of All Modes
   */
  virtual void setAllModesTime(const double & AllModesTime) = 0;

  /**
   * @brief All Modes time getter
   * @return to retrieve time of All Modes
   */
  virtual double getAllModesTime() const = 0;

  /* virtual void setAllModesSolver(const int & AllModesSolver) = 0;*/

  /**
   * @brief All Modes time getter
   * @return to retrieve time of All Modes
   */
  /* virtual int getAllModesSolver() const = 0;*/
  /**
   * @brief Output file attribute setter
   * @param outputFile: Output file for Modal Analysis
   */
  virtual void setOutputFile(const std::string & outputFile) = 0;

  /**
   * @brief Output file attribute getter
   * @return Output file for All Modes
   */
  virtual std::string getOutputFile() const = 0;

  class Impl;  ///< implemented class
};

}  // namespace job

#endif  // API_JOB_JOBALLMODESENTRY_H_
