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
 * @file JOBConstraintsEntryImpl.h
 * @brief Constraints entries description : header file
 *
 */

#ifndef API_JOB_JOBCONSTRAINTSENTRYIMPL_H_
#define API_JOB_JOBCONSTRAINTSENTRYIMPL_H_

#include <string>
#include "JOBConstraintsEntry.h"

namespace job {

/**
 * @class ConstraintsEntry::Impl
 * @brief Constraints entries implemented class
 */
class ConstraintsEntry::Impl : public ConstraintsEntry {
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
   * @copydoc ConstraintsEntry::setOutputFile()
   */
  void setOutputFile(const std::string & outputFile);

  /**
   * @copydoc ConstraintsEntry::setExportMode()
   */
  void setExportMode(const std::string & exportMode);

  /**
   * @copydoc ConstraintsEntry::getOutputFile()
   */
  std::string getOutputFile() const;

  /**
   * @copydoc ConstraintsEntry::getExportMode()
   */
  std::string getExportMode() const;

  /// @copydoc ConstraintsEntry::clone()
  boost::shared_ptr<ConstraintsEntry> clone() const;

 private:
  std::string outputFile_;  ///< Export file for constraints
  std::string exportMode_;  ///< Export mode for constraints output file
};

}  // namespace job

#endif  // API_JOB_JOBCONSTRAINTSENTRYIMPL_H_
