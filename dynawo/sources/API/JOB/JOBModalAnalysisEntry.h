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
 * @file JOBLineariseEntry.h
 * @brief Linearise entries description : interface file
 *
 */

#ifndef API_JOB_JOBMODALANALYSISENTRY_H_
#define API_JOB_JOBMODALANALYSISENTRY_H_

#include <string>

// #include "JOBExport.h"

namespace job {

/**
 * @class ModalAnalysisEntry
 * @brief ModalAnalysis entries container class
 */
// class __DYNAWO_JOB_EXPORT ModalAnalysisEntry {
class ModalAnalysisEntry {
 public:
  /**
   * @brief Destructor
   */
  virtual ~ModalAnalysisEntry() {}

  /**
   * @brief Modal Analysis time setter
   * @param ModalAnalysisTime : Start time of Modal Analysis
   */
  virtual void setModalAnalysisTime(const double & ModalAnalysisTime) = 0;

  /**
   * @brief Modal Analysis part setter
   * @param ModalAnalysisPart : Start value of minimum relative participation factor
   */
  virtual void setModalAnalysisPart(const double & ModalAnalysisPart) = 0;

  /* virtual void setModalAnalysisSolver(const int & ModalAnalysisSolver) = 0;
  virtual int getModalAnalysisSolver() const = 0;*/
  /**
   * @brief Modal Analysis time getter
   * @return to retrieve time of Modal Analysis
   */
  virtual double getModalAnalysisTime() const = 0;

  /**
   * @brief Modal Analysis part getter
   * @return to retrieve value of minimum relativ participation factor
   */
  virtual double getModalAnalysisPart() const = 0;

  /**
   * @brief Output file attribute setter
   * @param outputFile: Output file for Modal Analysis
   */
  virtual void setOutputFile(const std::string & outputFile) = 0;

  /**
   * @brief Export Mode attribute setter
   * @param exportMode: Export mode for Modal Analysis
   */
  // virtual void setExportMode(const std::string & exportMode) = 0;

  /**
   * @brief Output file attribute getter
   * @return Output file for Modal Analysis
   */
  virtual std::string getOutputFile() const = 0;

  /**
   * @brief Export mode attribute getter
   * @return Export mode for ModalAnalysis
   */
  // virtual std::string getExportMode() const = 0;

  class Impl;  ///< implemented class
};

}  // namespace job

#endif  // API_JOB_JOBMODALANALYSISENTRY_H_
