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
 * @file JOBSolverEntry.h
 * @brief Solver entries description : interface file
 *
 */

#ifndef API_JOB_JOBSOLVERENTRY_H_
#define API_JOB_JOBSOLVERENTRY_H_

#include <string>

#include "JOBExport.h"

namespace job {

/**
 * @class SolverEntry
 * @brief Solver entries container class
 */
class __DYNAWO_JOB_EXPORT SolverEntry {
 public:
  /**
   * @brief Destructor
   */
  virtual ~SolverEntry() {}

   /**
   * @brief Solver lib setter
   * @param lib : Solver lib for the job
   */
  virtual void setLib(const std::string & lib) = 0;

  /**
   * @brief Solver lib getter
   * @return Solver lib for the job
   */
  virtual std::string getLib() const = 0;

  /**
   * @brief Solver parameters file setter
   * @param parametersFile : Solver parameters file for the job
   */
  virtual void setParametersFile(const std::string & parametersFile) = 0;

  /**
   * @brief Solver parameters file getter
   * @return Solver parameters file for the job
   */
  virtual std::string getParametersFile() const = 0;

  /**
   * @brief Solver parameters set number setter
   * @param parametersId : Solver parameters set id for the job
   */
  virtual void setParametersId(const std::string& parametersId) = 0;

  /**
   * @brief Solver parameters set number getter
   * @return Solver parameters set number for the job
   */
  virtual std::string getParametersId() const = 0;

  class Impl;  ///< implemented class
};

}  // namespace job

#endif  // API_JOB_JOBSOLVERENTRY_H_
