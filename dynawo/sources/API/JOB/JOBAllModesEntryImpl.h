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

#ifndef API_JOB_JOBALLMODESENTRYIMPL_H_
#define API_JOB_JOBALLMODESENTRYIMPL_H_

#include <string>
#include "JOBAllModesEntry.h"

namespace job {

/**
 * @class AllModesEntry::Impl
 * @brief All Modes entries container class
 */
class AllModesEntry::Impl : public AllModesEntry {
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
   * @copydoc AllModesEntry::setAllModesTime()
   */
  void setAllModesTime(const double & allmodesTime);

  /**
   * @copydoc AllModesEntry::getAllModesTime()
   */
  double getAllModesTime() const;
  /**
   * @copydoc AllModesEntry::setAllModesTime()
   */
  /* void setAllModesSolver(const int & allmodesSolver);*/

  /**
   * @copydoc AllModesEntry::getAllModesTime()
   */
  /* int getAllModesSolver() const;*/
  /**
   * @copydoc AllModesEntry::setOutputFile()
   */
  void setOutputFile(const std::string & outputFile);

  /**
   * @copydoc AllModesEntry::getOutputFile()
   */
  std::string getOutputFile() const;

 private:
  double allmodesTime_;  ///< Time of compute All Modes
  // int allmodesSolver_;  ///< Time of compute All Modes
  std::string outputFile_;  ///< Export file for Modal Analysis
};

}  // namespace job

#endif  // API_JOB_JOBALLMODESENTRYIMPL_H_
