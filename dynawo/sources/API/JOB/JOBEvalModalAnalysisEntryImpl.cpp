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
 * @file JOBEvalModalAnalysisEntryImpl.cpp
 * @brief Modal analysis entry description : implementation file
 *
 */

#include "JOBEvalModalAnalysisEntryImpl.h"

namespace job {

ModalAnalysisEntry::Impl::Impl() :
modalanalysisTime_(0),
outputFile_("") {
// exportMode_("")
}

ModalAnalysisEntry::Impl::~Impl() {
}
// to change the value of Modal Analysis time
void
ModalAnalysisEntry::Impl::setModalAnalysisTime(const double & modalanalysisTime) {
  modalanalysisTime_ = modalanalysisTime;
}
// to retrieve the value of Modal Analysis time
double
ModalAnalysisEntry::Impl::getModalAnalysisTime() const {
  return modalanalysisTime_;
}
// to change the value of minimum relative participation factor
void
ModalAnalysisEntry::Impl::setModalAnalysisPart(const double & modalanalysisPart) {
  modalanalysisPart_ = modalanalysisPart;
}
double
ModalAnalysisEntry::Impl::getModalAnalysisPart() const {
  return modalanalysisPart_;
}
// to change the solver
/* void
ModalAnalysisEntry::Impl::setModalAnalysisSolver(const int & modalanalysisSolver) {
  modalanalysisSolver_ = modalanalysisSolver;
}
// to retrieve the value of minimum relative participation factor
int
ModalAnalysisEntry::Impl::getModalAnalysisSolver() const {
  return modalanalysisSolver_;
}*/

// functions set and get of output file and export mode (TXT, log,...)
void
ModalAnalysisEntry::Impl::setOutputFile(const std::string & outputFile) {
  outputFile_ = outputFile;
}

/* void
ModalAnalysisEntry::Impl::setExportMode(const std::string & exportMode) {
  exportMode_ = exportMode;
}*/

std::string
ModalAnalysisEntry::Impl::getOutputFile() const {
  return outputFile_;
}

/* std::string
ModalAnalysisEntry::Impl::getExportMode() const {
  return exportMode_;
}*/

}  // namespace job
