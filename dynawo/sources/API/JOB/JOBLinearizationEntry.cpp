//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
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
 * @file JOBLinearizationEntry.cpp
 * @brief Linearization entry description : implementation file
 *
 */

#include "JOBLinearizationEntry.h"

namespace job {

LinearizationEntry::LinearizationEntry() :
time_(0.),
exportMode_("TXT") {
}

void
LinearizationEntry::setTime(double time) {
  time_ = time;
}

double
LinearizationEntry::getTime() const {
  return time_;
}

const std::string&
LinearizationEntry::getExportMode() const {
  return exportMode_;
}

void
LinearizationEntry::setExportMode(const std::string& exportMode) {
  exportMode_ = exportMode;
}

}  // namespace job
