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
 * @file JOBInitialStateEntry.h
 * @brief Initial state entries description : interface file
 *
 */

#ifndef API_JOB_JOBINITIALSTATEENTRY_H_
#define API_JOB_JOBINITIALSTATEENTRY_H_

#include <string>

#include "JOBExport.h"

namespace job {

/**
 * @class InitialStateEntry
 * @brief Initial state entries container class
 */
class __DYNAWO_JOB_EXPORT InitialStateEntry {
 public:
  /**
   * @brief initial state file setter
   * @param initialStateFile : initial state file for the job
   */
  virtual void setInitialStateFile(const std::string & initialStateFile) = 0;

  /**
   * @brief initial state file getter
   * @return initial state file  for the job
   */
  virtual std::string getInitialStateFile() const = 0;

  class Impl;  ///< implemented class
};

}  // namespace job

#endif  // API_JOB_JOBINITIALSTATEENTRY_H_
