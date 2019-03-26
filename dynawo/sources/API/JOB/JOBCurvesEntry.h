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
 * @file JOBCurvesEntry.h
 * @brief curves entries description : interface file
 *
 */

#ifndef API_JOB_JOBCURVESENTRY_H_
#define API_JOB_JOBCURVESENTRY_H_

#include <string>

#include "JOBExport.h"

namespace job {

/**
 * @brief Curves entry
 * @brief Curves entries container class
 */
class __DYNAWO_JOB_EXPORT CurvesEntry {
 public:
  /**
   * @brief Destructor
   */
  virtual ~CurvesEntry() {}

  /**
   * @brief Input file attribute getter
   * @return Input file for curves
   */
  virtual std::string getInputFile() const = 0;

  /**
   * @brief Output file attribute getter
   * @return Output file for curves
   */
  virtual std::string getOutputFile() const = 0;

  /**
   * @brief Export mode attribute getter
   * @return Export mode for curves
   */
  virtual std::string getExportMode() const = 0;

  /**
   * @brief Input file attribute setter
   * @param inputFile: Input file for curves
   */
  virtual void setInputFile(const std::string & inputFile) = 0;

  /**
   * @brief Output file attribute setter
   * @param outputFile: Output file for curves
   */
  virtual void setOutputFile(const std::string & outputFile) = 0;

  /**
   * @brief Export Mode attribute setter
   * @param exportMode: Export mode for curves
   */
  virtual void setExportMode(const std::string & exportMode) = 0;

  class Impl;  ///< Implemented class
};

}  // namespace job

#endif  // API_JOB_JOBCURVESENTRY_H_
