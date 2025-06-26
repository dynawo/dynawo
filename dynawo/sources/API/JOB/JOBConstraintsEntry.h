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

namespace job {

/**
 * @class ConstraintsEntry
 * @brief Constraints entries container class
 */
class ConstraintsEntry {
 public:
   /**
   * @brief constructor
   */
  ConstraintsEntry();

  /**
   * @brief Output file attribute setter
   * @param outputFile Output file for constraints
   */
  void setOutputFile(const std::string& outputFile);

  /**
   * @brief Export Mode attribute setter
   * @param exportMode Export mode for constraints
   */
  void setExportMode(const std::string& exportMode);

  /**
   * @brief Output file attribute getter
   * @return Output file for constraints
   */
  const std::string& getOutputFile() const;

  /**
   * @brief Export mode attribute getter
   * @return Export mode for constraints
   */
  const std::string& getExportMode() const;

  /**
   * @brief filter setter
   * @param filter whether to filter the constraints
   */
  void setFilter(bool filter);

  /**
   * @brief filter getter
   * @return whether to filter the constraints
   */
  bool isFilter() const;

 private:
  std::string outputFile_;  ///< Export file for constraints
  std::string exportMode_;  ///< Export mode for constraints output file
  bool filter_;             ///< Wether to filter the constraints
};

}  // namespace job

#endif  // API_JOB_JOBCONSTRAINTSENTRY_H_
