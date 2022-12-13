//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
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
 * @file JOBFinalStateValuesEntry.h
 * @brief final state values entries description : interface file
 *
 */

#ifndef API_JOB_JOBFINALSTATEVALUESENTRY_H_
#define API_JOB_JOBFINALSTATEVALUESENTRY_H_

#include <string>

namespace job {

/**
 * @class FinalStateValuesEntry
 * @brief Final state values entries container class
 */
class FinalStateValuesEntry {
 public:
  /**
   * @brief Input file attribute getter
   * @return Input file for final state values
   */
  const std::string& getInputFile() const;

  /**
   * @brief Input file attribute setter
   * @param inputFile Input file for final state values
   */
  void setInputFile(const std::string& inputFile);

  /**
   * @brief Export mode attribute getter
   * @return Export mode for curves
   */
  const std::string& getExportMode() const;

  /**
   * @brief Export Mode attribute setter
   * @param exportMode Export mode for curves
   */
  void setExportMode(const std::string& exportMode);

 private:
  std::string inputFile_;           ///< Input file for final state values
  std::string exportMode_ = "CSV";  ///< Export mode XML, TXT, CSV for curves output file
};

}  // namespace job

#endif  // API_JOB_JOBFINALSTATEVALUESENTRY_H_
