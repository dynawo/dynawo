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
 * @file JOBConstraintsEntry.h
 * @brief Constraints entries description : interface file
 *
 */

#ifndef API_JOB_JOBCONSTRAINTSENTRY_H_
#define API_JOB_JOBCONSTRAINTSENTRY_H_

#include <string>
#include <boost/shared_ptr.hpp>

namespace job {

/**
 * @class ConstraintsEntry
 * @brief Constraints entries container class
 */
class ConstraintsEntry {
 public:
  /**
   * @brief Destructor
   */
  virtual ~ConstraintsEntry() {}

  /**
   * @brief Output file attribute setter
   * @param outputFile: Output file for constraints
   */
  virtual void setOutputFile(const std::string & outputFile) = 0;

  /**
   * @brief Export Mode attribute setter
   * @param exportMode: Export mode for constraints
   */
  virtual void setExportMode(const std::string & exportMode) = 0;

  /**
   * @brief Output file attribute getter
   * @return Output file for constraints
   */
  virtual std::string getOutputFile() const = 0;

  /**
   * @brief Export mode attribute getter
   * @return Export mode for constraints
   */
  virtual std::string getExportMode() const  = 0;

  /**
   * @brief Clone current entry
   * @returns copy of current entry
   */
  virtual boost::shared_ptr<ConstraintsEntry> clone() const = 0;

  class Impl;  ///< implemented class
};

}  // namespace job

#endif  // API_JOB_JOBCONSTRAINTSENTRY_H_
