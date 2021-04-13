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
 * @file JOBEvalModalAnalysisEntryImpl.h
 * @brief Modal Analysis entries description : header file
 *
 */

#ifndef API_JOB_JOBMODALANALYSISENTRYIMPL_H_
#define API_JOB_JOBMODALANALYSISENTRYIMPL_H_

#include <string>
#include "JOBModalAnalysisEntry.h"

namespace job {

/**
 * @class ModalAnalysisEntry::Impl
 * @brief Modal Analysis entries container class
 */
class ModalAnalysisEntry::Impl : public ModalAnalysisEntry {
 public:
  /**
   * @brief constructor
   */
  Impl();

  /**
   * @brief destructor
   */
  virtual ~Impl();

  /**
   * @copydoc ModalAnalysisEntry::setModalAnalysisTime()
   */
  void setModalAnalysisTime(const double & modalanalysisTime);

  /**
   * @copydoc ModalAnalysisEntry::getModalAnalysisTime()
   */
  double getModalAnalysisTime() const;

  /**
   * @copydoc ModalAnalysisEntry::setModalAnalysisPart()
   */
  void setModalAnalysisPart(const double & modalanalysisPart);

  /**
   * @copydoc ModalAnalysisEntry::getModalAnalysisPart()
   */
  double getModalAnalysisPart() const;


 private:
  double modalanalysisTime_;  ///< Time to start the modal analysis
  double modalanalysisPart_;  ///< Minimum relative participation factor for modal analysis
};

}  // namespace job

#endif  // API_JOB_JOBMODALANALYSISENTRYIMPL_H_
