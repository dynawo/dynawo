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

#ifndef API_JOB_JOBSUBPARTICIPATIONENTRY_H_
#define API_JOB_JOBSUBPARTICIPATIONENTRY_H_

#include <string>

// #include "JOBExport.h"

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
   * @param SubParticipationTime : Start time of SubParticipation
   */
  virtual void setSubParticipationTime(const double & SubParticipationTime) = 0;

  /**
   * @brief SubParticipation time getter
   * @return to retrieve time of SubParticipation
   */
  virtual double getSubParticipationTime() const = 0;

  /**
   * @brief SubParticipation NbMode setter
   * @param SubParticipationNbMode : Start number of mode of SubParticipation
   */
  virtual void setSubParticipationNbMode(const double & SubParticipationNbMode) = 0;

  /**
   * @brief SubParticipation NbMode getter
   * @return to retrieve NbMode of SubParticipation
   */
  virtual double getSubParticipationNbMode() const = 0;
  /**
   * @brief SubParticipation NbMode setter
   * @param SubParticipationNbMode : Start number of mode of SubParticipation
   */
  /* virtual void setSubParticipationSolver(const int & SubParticipationSolver) = 0;*/

  /**
   * @brief SubParticipation NbMode getter
   * @return to retrieve NbMode of SubParticipation
   */
  /* virtual int getSubParticipationSolver() const = 0;*/

  /**
   * @brief Output file attribute setter
   * @param outputFile: Output file for SubParticipation
   */
  virtual void setOutputFile(const std::string & outputFile) = 0;

  /**
   * @brief Output file attribute getter
   * @return Output file for SubParticipation
   */
  virtual std::string getOutputFile() const = 0;

  class Impl;  ///< implemented class
};

}  // namespace job

#endif  // API_JOB_JOBSUBPARTICIPATIONENTRY_H_
