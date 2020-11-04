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
 * @file JOBTimetableEntry.h
 * @brief Timetable entries description : interface file
 *
 */

#ifndef API_JOB_JOBTIMETABLEENTRY_H_
#define API_JOB_JOBTIMETABLEENTRY_H_

#include <string>

namespace job {

/**
 * @class TimetableEntry
 * @brief Timetable entries container class
 */
class TimetableEntry {
 public:
  /**
   * @brief Destructor
   */
  virtual ~TimetableEntry() {}

  /**
   * @brief step getter
   * @return step of timetable
   */
  virtual int getStep() const = 0;

  /**
   * @brief step setter
   * @param step number of iterations between each time dumped
   */
  virtual void setStep(int step) = 0;

  class Impl;  ///< implemented class
};

}  // namespace job

#endif  // API_JOB_JOBTIMETABLEENTRY_H_
