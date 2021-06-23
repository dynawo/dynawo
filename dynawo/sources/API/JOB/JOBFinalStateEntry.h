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
 * @file JOBFinalStateEntry.h
 * @brief FinalState entries description : interface file
 *
 */

#ifndef API_JOB_JOBFINALSTATEENTRY_H_
#define API_JOB_JOBFINALSTATEENTRY_H_

#include <string>
#include <boost/shared_ptr.hpp>

namespace job {

/**
 * @brief FinalState entry
 * @brief FinalState entries container class
 */
class FinalStateEntry {
 public:
  /**
   * @brief Destructor
   */
  virtual ~FinalStateEntry() {}

  /**
   * @brief whether to export IIDM output file getter
   * @return whether to export IIDM output file
   */
  virtual bool getExportIIDMFile() const = 0;

  /**
   * @brief whether to export output state getter
   * @return whether to export output state
   */
  virtual bool getExportDumpFile() const = 0;

  /**
   * @brief Output file attribute getter
   * @return Output file IIDM for final state
   */
  virtual std::string getOutputIIDMFile() const = 0;

  /**
   * @brief Dump file attribute getter
   * @return Dump file for final state
   */
  virtual std::string getDumpFile() const = 0;

  /**
   * @brief whether to export IIDM output file setter
   * @param exportIIDMFile: whether to export IIDM output file
   */
  virtual void setExportIIDMFile(const bool exportIIDMFile) = 0;

  /**
   * @brief whether to export output state setter
   * @param exportDumpFile: whether to export output state
   */
  virtual void setExportDumpFile(const bool exportDumpFile) = 0;

  /**
   * @brief Output file attribute setter
   * @param outputIIDMFile: Output file for final state
   */
  virtual void setOutputIIDMFile(const std::string& outputIIDMFile) = 0;

  /**
   * @brief Dump file attribute setter
   * @param dumpFile: Dump file for final state
   */
  virtual void setDumpFile(const std::string& dumpFile) = 0;

  /**
   * @brief Clone current entry
   * @returns copy of current entry
   */
  virtual boost::shared_ptr<FinalStateEntry> clone() const = 0;

  class Impl;  ///< implemented class
};

}  // namespace job

#endif  // API_JOB_JOBFINALSTATEENTRY_H_
