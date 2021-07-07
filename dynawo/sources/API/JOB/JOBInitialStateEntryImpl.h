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
 * @file JOBInitialStateEntryImpl.h
 * @brief Initial state entries description : header file
 *
 */

#ifndef API_JOB_JOBINITIALSTATEENTRYIMPL_H_
#define API_JOB_JOBINITIALSTATEENTRYIMPL_H_

#include <string>
#include "JOBInitialStateEntry.h"

namespace job {

/**
 * @class InitialStateEntry::Impl
 * @brief Initial state entries implemented class
 */
class InitialStateEntry::Impl : public InitialStateEntry {
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
   * @copydoc InitialStateEntry::setInitialStateFile()
   */
  void setInitialStateFile(const std::string & initialStateFile);

  /**
   * @copydoc InitialStateEntry::getInitialStateFile()
   */
  std::string getInitialStateFile() const;

  /**
   * @copydoc InitialStateEntry::clone()
   */
  boost::shared_ptr<InitialStateEntry> clone() const;

 private:
  std::string initialStateFile_;  ///< initial state file for the simulation
};

}  // namespace job

#endif  // API_JOB_JOBINITIALSTATEENTRYIMPL_H_
