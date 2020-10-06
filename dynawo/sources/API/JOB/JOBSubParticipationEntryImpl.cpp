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
 * @file JOBSUBPARTICIPATIONEntryImpl.cpp
 * @brief SubParticipation entry description : implementation file
 *
 */

#include "JOBSubParticipationEntryImpl.h"

namespace job {

SubParticipationEntry::Impl::Impl() :
subparticipationTime_(0),
outputFile_("") {

}

SubParticipationEntry::Impl::~Impl() {
}

// to change the value of SubParticipation time
void
SubParticipationEntry::Impl::setSubParticipationTime(const double & subparticipationTime) {
  subparticipationTime_ = subparticipationTime;
}
// to retrieve the value of Sub Participation time
double
SubParticipationEntry::Impl::getSubParticipationTime() const {
  return subparticipationTime_;
}

// to change the value of SubParticipation NbMode
void
SubParticipationEntry::Impl::setSubParticipationNbMode(const double & subparticipationNbMode) {
  subparticipationNbMode_ = subparticipationNbMode;
}
// to retrieve the value of Sub Participation NbMode
double
SubParticipationEntry::Impl::getSubParticipationNbMode() const {
  return subparticipationNbMode_;
}
// to change the value of SubParticipation NbMode
/* void
SubParticipationEntry::Impl::setSubParticipationSolver(const int & subparticipationSolver) {
  subparticipationSolver_ = subparticipationSolver;
}
// to retrieve the value of Sub Participation NbMode
int
SubParticipationEntry::Impl::getSubParticipationSolver() const {
  return subparticipationSolver_;
}*/
// functions set and get of output file and export mode (TXT, log,...)
void
SubParticipationEntry::Impl::setOutputFile(const std::string & outputFile) {
  outputFile_ = outputFile;
}

std::string
SubParticipationEntry::Impl::getOutputFile() const {
  return outputFile_;
}


}  // namespace job
