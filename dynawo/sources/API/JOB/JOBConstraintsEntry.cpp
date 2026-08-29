//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file JOBConstraintsEntry.cpp
 * @brief Constraints entry description : implementation file
 *
 */

#include "JOBConstraintsEntry.h"

namespace job {

  ConstraintsEntry::ConstraintsEntry() :
  filter_(DYN::CONSTRAINTS_KEEP_FIRST) {}

void
ConstraintsEntry::setOutputFile(const std::string& outputFile) {
  outputFile_ = outputFile;
}

void
ConstraintsEntry::setExportMode(const std::string& exportMode) {
  exportMode_ = exportMode;
}

const std::string&
ConstraintsEntry::getOutputFile() const {
  return outputFile_;
}

const std::string&
ConstraintsEntry::getExportMode() const {
  return exportMode_;
}

void
ConstraintsEntry::setFilterType(DYN::ConstraintValueType_t filter) {
  filter_ = filter;
}

DYN::ConstraintValueType_t
ConstraintsEntry::getFilterType() const {
  return filter_;
}
}  // namespace job
