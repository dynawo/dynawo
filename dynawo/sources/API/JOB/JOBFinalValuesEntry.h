//
// Copyright (c) 2023, RTE (http://www.rte-france.com)
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
 * @file JOBFinalValuesEntry.h
 * @brief FinalValues entries description : interface file
 *
 */

#ifndef API_JOB_JOBFINALVALUESENTRY_H_
#define API_JOB_JOBFINALVALUESENTRY_H_

namespace job {

/**
 * @class FinalValuesEntry
 * @brief Final values entries container class
 */
class FinalValuesEntry {
 public:
  /**
   * @brief constructor
   */
  FinalValuesEntry();

  /**
   * @brief whether to dump final values setter
   * @param dumpFinalValues : whether to dump the final values for the job
   */
  void setDumpFinalValues(const bool dumpFinalValues);

  /**
   * @brief whether to dump the final values getter
   * @return whether to dump the final values for the job
   */
  bool getDumpFinalValues() const;

 private:
  bool dumpFinalValues_;  ///< boolean indicating whether to dump the final values in the outputs directory
};

}  // namespace job

#endif  // API_JOB_JOBFINALVALUESENTRY_H_
