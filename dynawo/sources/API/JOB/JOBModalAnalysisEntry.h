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
 * @file JOBModalAnalysisEntry.h
 * @brief ModalAnalysis entries description : interface file
 *
 */

#ifndef API_JOB_JOBMODALANALYSISENTRY_H_
#define API_JOB_JOBMODALANALYSISENTRY_H_

#include <string>

namespace job {

/**
 * @class ModalAnalysisEntry
 * @brief ModalAnalysis entries container class
 */

class ModalAnalysisEntry {
 public:
  /**
   * @brief ModalAnalysis time setter
   * @param ModalAnalysisTime : Start time for modal analysis
   */
  void setModalAnalysisTime(const double & ModalAnalysisTime);

  /**
   * @brief ModalAnalysis part setter
   * @param ModalAnalysisPart : Start relative participation factor for modal analysis
   */
  void setModalAnalysisPart(const double & ModalAnalysisPart);

  /**
   * @brief ModalAnalysis time getter
   * @return start time for modal analysis
   */
  double getModalAnalysisTime() const;

  /**
   * @brief ModalAnalysis part getter
   * @return start relative participation factor for modal analysis
   */
  double getModalAnalysisPart() const;

 private:
  double modalanalysisTime_;  ///< Time to start the modal analysis
  double modalanalysisPart_;  ///< Minimum relative participation factor for modal analysis
};

}  // namespace job

#endif  // API_JOB_JOBMODALANALYSISENTRY_H_
