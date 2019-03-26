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
 * @file JOBSimulationEntry.h
 * @brief Simulation entries description : interface file
 *
 */

#ifndef API_JOB_JOBSIMULATIONENTRY_H_
#define API_JOB_JOBSIMULATIONENTRY_H_

#include "JOBExport.h"

namespace job {

/**
 * @class SimulationEntry
 * @brief Simulation entries container class
 */
class __DYNAWO_JOB_EXPORT SimulationEntry {
 public:
  /**
   * @brief Destructor
   */
  virtual ~SimulationEntry() {}

  /**
   * @brief Start time setter
   * @param startTime : Start time for the job
   */
  virtual void setStartTime(const double & startTime) = 0;

  /**
   * @brief Start time getter
   * @return Start time for the job
   */
  virtual double getStartTime() const = 0;

  /**
   * @brief Stop time setter
   * @param stopTime : Stop time for the job
   */
  virtual void setStopTime(const double & stopTime) = 0;

  /**
   * @brief Stop time getter
   * @return Stop time for the job
   */
  virtual double getStopTime() const = 0;

  /**
   * @brief  activate criteria setter
   * @param activate : option to activate the verification of criteria
   */
  virtual void setActivateCriteria(bool activate) = 0;

  /**
   * @brief activate criteria getter
   * @return option to activate the verification of criteria
   */
  virtual bool getActivateCriteria() const = 0;

  /**
   * @brief  criteria step setter
   * @param criteriaStep : number of iterations between 2 criteria check
   */
  virtual void setCriteriaStep(const int & criteriaStep) = 0;

  /**
   * @brief criteria step getter
   * @return number of iterations between 2 criteria check
   */
  virtual int getCriteriaStep() const = 0;

  class Impl;  ///< Implemented class
};

}  // namespace job

#endif  // API_JOB_JOBSIMULATIONENTRY_H_
