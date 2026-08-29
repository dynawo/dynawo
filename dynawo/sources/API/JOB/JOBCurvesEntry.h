//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
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
#include <boost/optional.hpp>

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
   * @brief Iteration step attribute getter
   * @return Integer step to dump curve values every N iterations
   */
  boost::optional<int> getIterationStep() const;

  /**
   * @brief Time step attribute getter
   * @return Time step to dump curve values every N seconds
   */
  boost::optional<double> getTimeStep() const;

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

  /**
   * @brief Iteration step attribute setter
   * @param iterationStep Integer step to dump curve values every N iterations
   */
  void setIterationStep(boost::optional<int> iterationStep);

    /**
   * @brief Time step attribute setter
   * @param timeStep Time step to dump curve values every N seconds
   */
  void setTimeStep(boost::optional<double> timeStep);

 private:
  std::string inputFile_;                 ///< Input file for curves
  std::string outputFile_;                ///< Output file for curves
  std::string exportMode_;                ///< Export mode TXT, CSV, XML for curves output file
  boost::optional<int> iterationStep_;    ///< Integer step to dump curve values every N iterations
  boost::optional<double> timeStep_;      ///< Time step to dump curve values every N seconds
};

}  // namespace job

#endif  // API_JOB_JOBCURVESENTRY_H_
