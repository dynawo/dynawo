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
 * @file JOBEvalLineariseEntryImpl.cpp
 * @brief Linearise entry description : implementation file
 *
 */

#include "JOBEvalLineariseEntryImpl.h"

namespace job {

LineariseEntry::Impl::Impl() :
lineariseTime_(0),
outputFile_("") {
// exportMode_("")
}

LineariseEntry::Impl::~Impl() {
}
// to change the value of linearisation time
void
LineariseEntry::Impl::setLineariseTime(const double & lineariseTime) {
  lineariseTime_ = lineariseTime;
}

// to retrieve the value of linearisation time
double
LineariseEntry::Impl::getLineariseTime() const {
  return lineariseTime_;
}
// functions set and get of output file and export mode (TXT, log,...)
void
LineariseEntry::Impl::setOutputFile(const std::string & outputFile) {
  outputFile_ = outputFile;
}

/* void
LineariseEntry::Impl::setExportMode(const std::string & exportMode) {
  exportMode_ = exportMode;
}*/

std::string
LineariseEntry::Impl::getOutputFile() const {
  return outputFile_;
}

/* std::string
LineariseEntry::Impl::getExportMode() const {
  return exportMode_;
}*/

}  // namespace job
