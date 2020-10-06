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
 * @file JOBEvalLineariseEntryImpl.h
 * @brief Linearise entries description : header file
 *
 */

#ifndef API_JOB_JOBEVALLINEARISEENTRYIMPL_H_
#define API_JOB_JOBEVALLINEARISEENTRYIMPL_H_

#include <string>
#include "JOBLineariseEntry.h"

namespace job {

/**
 * @class LineariseEntry::Impl
 * @brief Linearise entries container class
 */
class LineariseEntry::Impl : public LineariseEntry {
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
   * @copydoc LineariseEntry::setLineariseTime()
   */
  void setLineariseTime(const double & lineariseTime);

  /**
   * @copydoc LineariseEntry::getLineariseTime()
   */
  double getLineariseTime() const;

  /**
   * @copydoc LineariseEntry::setOutputFile()
   */
  void setOutputFile(const std::string & outputFile);

  /**
   * @copydoc LineariseEntry::setExportMode()
   */
  // void setExportMode(const std::string & exportMode);

  /**
   * @copydoc LineariseEntry::getOutputFile()
   */
  std::string getOutputFile() const;

  /**
   * @copydoc LineariseEntry::getExportMode()
   */
  // std::string getExportMode() const;

 private:
  double lineariseTime_;  ///< Time of the linearization
  std::string outputFile_;  ///< Export file for Linearise
  // std::string exportMode_;  ///< Export mode TXT, CSV, XML for Linearise output file
};

}  // namespace job

#endif  // API_JOB_JOBTIMELINEENTRYIMPL_H_
