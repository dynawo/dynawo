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

#include <vector>
#include <string>
#include <boost/shared_ptr.hpp>

namespace job {

/**
 * @class SimulationEntry
 * @brief Simulation entries container class
 */
class SimulationEntry {
 public:
  /**
   * @brief Destructor
   */
  virtual ~SimulationEntry() {}

  /**
   * @brief Start time setter
   * @param startTime : Start time for the job
   */
  virtual void setStartTime(double startTime) = 0;

  /**
   * @brief Start time getter
   * @return Start time for the job
   */
  virtual double getStartTime() const = 0;

  /**
   * @brief Stop time setter
   * @param stopTime : Stop time for the job
   */
  virtual void setStopTime(double stopTime) = 0;

  /**
   * @brief Stop time getter
   * @return Stop time for the job
   */
  virtual double getStopTime() const = 0;

  /**
   * @brief  add a criteria file path to the job
   * @param criteriaFile criteria file path to add
   */
  virtual void addCriteriaFile(const std::string& criteriaFile) = 0;

  /**
   * @brief list of criteria files
   * @return list of criteria files
   */
  virtual const std::vector<std::string>& getCriteriaFiles() const = 0;

  /**
   * @brief  criteria step setter
   * @param criteriaStep : number of iterations between 2 criteria check
   */
  virtual void setCriteriaStep(int criteriaStep) = 0;

  /**
   * @brief criteria step getter
   * @return number of iterations between 2 criteria check
   */
  virtual int getCriteriaStep() const = 0;

  /**
   * @brief precision setter
   * @param precision : double precision for the job
   */
  virtual void setPrecision(double precision) = 0;

  /**
   * @brief precision getter
   * @return precision for the job
   */
  virtual double getPrecision() const = 0;

  /**
   * @brief Clone current job entry
   * @returns copy of current job entry
   */
  virtual boost::shared_ptr<SimulationEntry> clone() const = 0;

  class Impl;  ///< Implemented class
};

}  // namespace job

#endif  // API_JOB_JOBSIMULATIONENTRY_H_
