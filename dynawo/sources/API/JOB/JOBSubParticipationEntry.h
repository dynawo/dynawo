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
 * @file JOBSubParticipationEntry.h
 * @brief SubParticipation entries description : interface file
 *
 */

#ifndef API_JOB_JOBSUBPARTICIPATIONENTRY_H_
#define API_JOB_JOBSUBPARTICIPATIONENTRY_H_

#include <string>

namespace job {

/**
 * @class SubParticipationEntry
 * @brief SubParticipation entries container class
 */
class SubParticipationEntry {
 public:
  /**
   * @brief Destructor
   */
  virtual ~SubParticipationEntry() {}

  /**
   * @brief SubParticipation time setter
   * @param SubParticipationTime : Start time for SubParticipation
   */
  virtual void setSubParticipationTime(const double & SubParticipationTime) = 0;

  /**
   * @brief SubParticipation time getter
   * @return start time for SubParticipation
   */
  virtual double getSubParticipationTime() const = 0;

  /**
   * @brief SubParticipation NbMode setter
   * @param SubParticipationNbMode : Start mode number for SubParticipation
   */
  virtual void setSubParticipationNbMode(const double & SubParticipationNbMode) = 0;

  /**
   * @brief SubParticipation NbMode getter
   * @return start mode number for SubParticipation
   */
  virtual double getSubParticipationNbMode() const = 0;

  class Impl;  ///< implemented class
};

}  // namespace job

#endif  // API_JOB_JOBSUBPARTICIPATIONENTRY_H_
