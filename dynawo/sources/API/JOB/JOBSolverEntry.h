//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
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

namespace job {

/**
 * @class SolverEntry
 * @brief Solver entries container class
 */
class SolverEntry {
 public:
  /**
   * @brief Solver lib setter
   * @param lib : Solver lib for the job
   */
  void setLib(const std::string& lib);

  /**
   * @brief Solver lib getter
   * @return Solver lib for the job
   */
  const std::string& getLib() const;

  /**
   * @brief Solver parameters file setter
   * @param parametersFile : Solver parameters file for the job
   */
  void setParametersFile(const std::string& parametersFile);

  /**
   * @brief Solver parameters file getter
   * @return Solver parameters file for the job
   */
  const std::string& getParametersFile() const;

  /**
   * @brief Solver parameters set number setter
   * @param parametersId : Solver parameters set id for the job
   */
  void setParametersId(const std::string& parametersId);

  /**
   * @brief Solver parameters set number getter
   * @return Solver parameters set number for the job
   */
  const std::string& getParametersId() const;

 private:
  std::string lib_;             ///< Solver library used
  std::string parametersFile_;  ///< Parameters file for the solver
  std::string parametersId_;    ///< Number of the parameters set in parameters file
};

}  // namespace job

#endif  // API_JOB_JOBSOLVERENTRY_H_
