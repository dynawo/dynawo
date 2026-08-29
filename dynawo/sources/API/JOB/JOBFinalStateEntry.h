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
 * @file JOBFinalStateEntry.h
 * @brief FinalState entries description : interface file
 *
 */

#ifndef API_JOB_JOBFINALSTATEENTRY_H_
#define API_JOB_JOBFINALSTATEENTRY_H_

#include <boost/optional.hpp>
#include <string>

namespace job {

/**
 * @class FinalStateEntry
 * @brief FinalState entries container class
 */
class FinalStateEntry {
 public:
  /**
   * @brief constructor
   */
  FinalStateEntry();

  /**
   * @brief whether to export IIDM output file getter
   * @return whether to export IIDM output file
   */
  bool getExportIIDMFile() const;

  /**
   * @brief whether to export output state getter
   * @return whether to export output state
   */
  bool getExportDumpFile() const;

  /**
   * @brief Output file attribute getter
   * @return Output file IIDM for final state
   */
  const std::string& getOutputIIDMFile() const;

  /**
   * @brief Dump file attribute getter
   * @return Dump file for final state
   */
  const std::string& getDumpFile() const;

  /**
   * @brief whether to export IIDM output file setter
   * @param exportIIDMFile whether to export IIDM output file
   */
  void setExportIIDMFile(const bool exportIIDMFile);

  /**
   * @brief whether to export output state setter
   * @param exportDumpFile whether to export output state
   */
  void setExportDumpFile(const bool exportDumpFile);

  /**
   * @brief Output file attribute setter
   * @param outputIIDMFile Output file for final state
   */
  void setOutputIIDMFile(const std::string& outputIIDMFile);

  /**
   * @brief Dump file attribute setter
   * @param dumpFile Dump file for final state
   */
  void setDumpFile(const std::string& dumpFile);

  /**
   * @brief Get the Timestamp
   *
   * @return the timestamp of the final state if present
   */
  boost::optional<double> getTimestamp() const {
    return timestamp_;
  }

  /**
   * @brief Set the Timestamp
   *
   * @param timestamp the timestamp value
   */
  void setTimestamp(double timestamp) {
    timestamp_ = timestamp;
  }

 private:
  bool exportIIDMFile_;                ///< Boolean indicating whether to export IIDM output file
  bool exportDumpFile_;                ///< Boolean indicating whether to export output state
  boost::optional<double> timestamp_;  ///< Timestamp of entry, if present
  std::string outputIIDMFile_;         ///< Output IIDM file for final state
  std::string dumpFile_;               ///< Dump file for final state
};

}  // namespace job

#endif  // API_JOB_JOBFINALSTATEENTRY_H_
