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
 * @file JOBTimetableEntryImpl.h
 * @brief Timetable entries description : header file
 *
 */

#ifndef API_JOB_JOBTIMETABLEENTRYIMPL_H_
#define API_JOB_JOBTIMETABLEENTRYIMPL_H_

#include <string>
#include "JOBTimetableEntry.h"

namespace job {

/**
 * @class TimetableEntry::Impl
 * @brief Timetable entries container class
 */
class TimetableEntry::Impl : public TimetableEntry {
 public:
  /**
   * @brief constructor
   */
  Impl();

  /**
   * @brief destructor
   */
  virtual ~Impl();

  /**
   * @copydoc TimetableEntry::setStep()
   */
  void setStep(int step);

  /**
   * @copydoc TimetableEntry::getStep()
   */
  int getStep() const;

 private:
  int step_;  ///< time to use
};

}  // namespace job

#endif  // API_JOB_JOBTIMETABLEENTRYIMPL_H_
