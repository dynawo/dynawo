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

namespace job {

/**
 * @class CurvesEntry
 * @brief Curves entries container class
 */
class CurvesEntry {
 public:
  /**
   * @brief Input file attribute getter
   * @return Input file for curves
   */
  const std::string& getInputFile() const;

  /**
   * @brief Output file attribute getter
   * @return Output file for curves
   */
  const std::string& getOutputFile() const;

  /**
   * @brief Export mode attribute getter
   * @return Export mode for curves
   */
  const std::string& getExportMode() const;

  /**
   * @brief Input file attribute setter
   * @param inputFile Input file for curves
   */
  void setInputFile(const std::string& inputFile);

  /**
   * @brief Output file attribute setter
   * @param outputFile Output file for curves
   */
  void setOutputFile(const std::string& outputFile);

  /**
   * @brief Export Mode attribute setter
   * @param exportMode Export mode for curves
   */
  void setExportMode(const std::string& exportMode);

 private:
  std::string inputFile_;   ///< Input file for curves
  std::string outputFile_;  ///< Output file for curves
  std::string exportMode_;  ///< Export mode TXT, CSV, XML for curves output file
};

}  // namespace job

#endif  // API_JOB_JOBCURVESENTRY_H_
