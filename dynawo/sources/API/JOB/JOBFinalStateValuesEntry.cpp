//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
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
 * @file JOBFinalStateValuesEntry.cpp
 * @brief final state values entry description : implementation file
 *
 */

#include "JOBFinalStateValuesEntry.h"

namespace job {

const std::string&
FinalStateValuesEntry::getInputFile() const {
  return inputFile_;
}

void FinalStateValuesEntry::setInputFile(const std::string& inputFile) {
  inputFile_ = inputFile;
}

const std::string&
FinalStateValuesEntry::getExportMode() const {
  return exportMode_;
}

void
FinalStateValuesEntry::setExportMode(const std::string& exportMode) {
  exportMode_ = exportMode;
}

}  // namespace job
