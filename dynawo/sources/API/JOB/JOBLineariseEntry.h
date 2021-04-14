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
 * @file JOBLineariseEntry.h
 * @brief Linearise entries description : interface file
 *
 */

#ifndef API_JOB_JOBLINEARISEENTRY_H_
#define API_JOB_JOBLINEARISEENTRY_H_

#include <string>

namespace job {

/**
 * @class LineariseEntry
 * @brief Linearise entries container class
 */
class LineariseEntry {
 public:
  /**
   * @brief Start time setter
   * @param startTime : Start time of the linearization
   */
  void setLineariseTime(const double & lineariseTime);

  /**
   * @brief Start time getter
   * @return linearise time for the job
   */
  double getLineariseTime() const;

 private:
  double lineariseTime_;  ///< Time to start the linearization
};

}  // namespace job

#endif  // API_JOB_JOBLINEARISEENTRY_H_
