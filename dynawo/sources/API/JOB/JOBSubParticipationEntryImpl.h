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
 * @file JOBAllModesEntryImpl.h
 * @brief All Modes entries description : header file
 *
 */

#ifndef API_JOB_JOBSUBPARTICIPATIONENTRYIMPL_H_
#define API_JOB_JOBSUBPARTICIPATIONENTRYIMPL_H_

#include <string>
#include "JOBSubParticipationEntry.h"

namespace job {

/**
 * @class SubParticipationEntry::Impl
 * @brief SubParticipation entries container class
 */
class SubParticipationEntry::Impl : public SubParticipationEntry {
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
   * @copydoc SubParticipationEntry::setSubParticipationTime()
   */
  void setSubParticipationTime(const double & subparticipationTime);

  /**
   * @copydoc SubParticipationEntry::getSubParticipationTime()
   */
  double getSubParticipationTime() const;

  /**
   * @copydoc SubParticipationEntry::setSubParticipationNbMode()
   */
  void setSubParticipationNbMode(const double & subparticipationNbMode);

  /**
   * @copydoc SubParticipationEntry::getSubParticipationNbMode()
   */
  double getSubParticipationNbMode() const;


  /**
   * @copydoc SubParticipationEntry::setSubParticipationNbMode()
   */
  /* void setSubParticipationSolver(const int & subparticipationSolver);*/

  /**
   * @copydoc SubParticipationEntry::getSubParticipationNbMode()
   */
  /* int getSubParticipationSolver() const;*/

  /**
   * @copydoc SubParticipationEntry::setOutputFile()
   */
  void setOutputFile(const std::string & outputFile);

  /**
   * @copydoc SubParticipationEntry::getOutputFile()
   */
  std::string getOutputFile() const;

 private:
  double subparticipationTime_;  ///< Time of compute SubParticipation
  double subparticipationNbMode_;  ///< NbMode of compute SubParticipation
  // double subparticipationSolver_;  ///< NbMode of compute SubParticipation
  std::string outputFile_;  ///< Export file for SubParticipation
};

}  // namespace job

#endif  // API_JOB_JOBSUBPARTICIPATIONENTRYIMPL_H_
