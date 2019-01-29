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
 * @file JOBFinalStateEntryImpl.h
 * @brief FinalState entries description : header file
 *
 */

#ifndef API_JOB_JOBFINALSTATEENTRYIMPL_H_
#define API_JOB_JOBFINALSTATEENTRYIMPL_H_

#include <string>
#include "JOBFinalStateEntry.h"

namespace job {

/**
 * @brief FinalState entry
 * @brief FinalState entries container class
 */
class FinalStateEntry::Impl : public FinalStateEntry {
 public:
  /**
   * @brief constructor
   */
  Impl();

  /**
   * @brief destructor
   */
  ~Impl();

  /**
   * @copydoc FinalStateEntry::getExportIIDMFile()
   */
  bool getExportIIDMFile() const;

  /**
   * @copydoc FinalStateEntry::getExportDumpFile()
   */
  bool getExportDumpFile() const;

  /**
   * @copydoc FinalStateEntry::getOutputIIDMFile()
   */
  std::string getOutputIIDMFile() const;

  /**
   * @copydoc FinalStateEntry::getDumpFile()
   */
  std::string getDumpFile() const;

  /**
   * @copydoc FinalStateEntry::setExportIIDMFile()
   */
  void setExportIIDMFile(const bool exportIIDMFile);

  /**
   * @copydoc FinalStateEntry::setExportDumpFile()
   */
  void setExportDumpFile(const bool exportDumpFile);

  /**
   * @copydoc FinalStateEntry::setOutputIIDMFile()
   */
  void setOutputIIDMFile(const std::string& outputIIDMFile);

  /**
   * @copydoc FinalStateEntry::setDumpFile()
   */
  void setDumpFile(const std::string& dumpFile);

 private:
  bool exportIIDMFile_;  ///< Boolean indicating whether to export IIDM output file
  bool exportDumpFile_;  ///< Boolean indicating whether to export output state
  std::string outputIIDMFile_;  ///< Output IIDM file for final state
  std::string dumpFile_;  ///< Dump file for final state
};

}  // namespace job

#endif  // API_JOB_JOBFINALSTATEENTRYIMPL_H_
