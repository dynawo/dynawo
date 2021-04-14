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
   * @brief SubParticipation time setter
   * @param SubParticipationTime : Start time for SubParticipation
   */
  void setSubParticipationTime(const double & SubParticipationTime);

  /**
   * @brief SubParticipation time getter
   * @return start time for SubParticipation
   */
  double getSubParticipationTime() const;

  /**
   * @brief SubParticipation NbMode setter
   * @param SubParticipationNbMode : Start mode number for SubParticipation
   */
  void setSubParticipationNbMode(const double & SubParticipationNbMode);

  /**
   * @brief SubParticipation NbMode getter
   * @return start mode number for SubParticipation
   */
  double getSubParticipationNbMode() const;

 private:
  double subparticipationTime_;  ///< Start time for SubParticipation
  double subparticipationNbMode_;  ///< Start mode number for SubParticipation
};

}  // namespace job

#endif  // API_JOB_JOBSUBPARTICIPATIONENTRY_H_
