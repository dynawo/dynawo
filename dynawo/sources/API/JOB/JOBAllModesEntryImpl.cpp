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
 * @file JOBAllModesEntryImpl.cpp
 * @brief All Modes entry description : implementation file
 *
 */

#include "JOBAllModesEntryImpl.h"

namespace job {

AllModesEntry::Impl::Impl() :
allmodesTime_(0),
outputFile_("") {
// exportMode_("")
}

AllModesEntry::Impl::~Impl() {
}
// to change the value of All Modes time
void
AllModesEntry::Impl::setAllModesTime(const double & allmodesTime) {
  allmodesTime_ = allmodesTime;
}
// to retrieve the value of All Modes time
double
AllModesEntry::Impl::getAllModesTime() const {
  return allmodesTime_;
}
// to change the value of All Modes time
/* void
AllModesEntry::Impl::setAllModesSolver(const int & allmodesSolver) {
  allmodesSolver_ = allmodesSolver;
}
// to retrieve the value of All Modes time
int
AllModesEntry::Impl::getAllModesSolver() const {
  return allmodesSolver_;
}*/

// functions set and get of output file and export mode (TXT, log,...)
void
AllModesEntry::Impl::setOutputFile(const std::string & outputFile) {
  outputFile_ = outputFile;
}

std::string
AllModesEntry::Impl::getOutputFile() const {
  return outputFile_;
}


}  // namespace job
