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
 * @file JOBSolverEntryImpl.h
 * @brief Solver entries description : header file
 *
 */

#ifndef API_JOB_JOBSOLVERENTRYIMPL_H_
#define API_JOB_JOBSOLVERENTRYIMPL_H_

#include <string>
#include "JOBSolverEntry.h"

namespace job {

/**
 * @class SolverEntry::Impl
 * @brief SolverEntry implemented class
 */
class SolverEntry::Impl : public SolverEntry {
 public:
  /**
   * @brief Default constructor
   */
  Impl();

  /**
   * @brief destructor
   */
  virtual ~Impl();

  /**
   * @copydoc SolverEntry::setLib()
   */
  void setLib(const std::string & lib);

  /**
   * @copydoc SolverEntry::getLib()
   */
  std::string getLib() const;

  /**
   * @copydoc SolverEntry::setParametersFile()
   */
  void setParametersFile(const std::string & parametersFile);

  /**
   * @copydoc SolverEntry::getParametersFile()
   */
  std::string getParametersFile() const;

  /**
   * @copydoc SolverEntry::setParametersId()
   */
  void setParametersId(const std::string& parametersId);

  /**
   * @copydoc SolverEntry::getParametersId()
   */
  std::string getParametersId() const;

  /**
   * @copydoc SolverEntry::clone()
   */
  boost::shared_ptr<SolverEntry> clone() const;

 private:
  std::string lib_;  ///< Solver library used
  std::string parametersFile_;  ///< Parameters file for the solver
  std::string parametersId_;  ///< Number of the parameters set in parameters file
};

}  // namespace job

#endif  // API_JOB_JOBSOLVERENTRYIMPL_H_
