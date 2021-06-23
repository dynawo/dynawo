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
 * @file JOBCurvesEntryImpl.h
 * @brief curves entries description : header file
 *
 */

#ifndef API_JOB_JOBCURVESENTRYIMPL_H_
#define API_JOB_JOBCURVESENTRYIMPL_H_

#include <string>
#include "JOBCurvesEntry.h"

namespace job {

/**
 * @brief Curves entry
 * @brief Curves entries container : implemented classs
 */
class CurvesEntry::Impl : public CurvesEntry {
 public:
  /**
   * @brief default constructor
   */
  Impl();

  /**
   * @brief default destructor
   */
  virtual ~Impl();

  /**
   * @copydoc CurvesEntry::getInputFile() const
   */
  std::string getInputFile() const;

  /**
   * @copydoc CurvesEntry::getOutputFile() const
   */
  std::string getOutputFile() const;

  /**
   * @copydoc CurvesEntry::getExportMode() const
   */
  std::string getExportMode() const;

  /**
   * @copydoc CurvesEntry::setInputFile()
   */
  void setInputFile(const std::string & inputFile);

  /**
   * @copydoc CurvesEntry::setOutputFile()
   */
  void setOutputFile(const std::string & outputFile);

  /**
   * @copydoc CurvesEntry::setExportMode()
   */
  void setExportMode(const std::string & exportMode);

  /// @copydoc CurvesEntry::clone()
  boost::shared_ptr<CurvesEntry> clone() const;

 private:
  std::string inputFile_;  ///< Input file for curves
  std::string outputFile_;  ///< Output file for curves
  std::string exportMode_;  ///< Export mode TXT, CSV, XML for curves output file
};

}  // namespace job

#endif  // API_JOB_JOBCURVESENTRYIMPL_H_
