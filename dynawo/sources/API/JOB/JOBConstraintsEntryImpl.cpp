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
 * @file JOBConstraintsEntryImpl.cpp
 * @brief Constraints entry description : implementation file
 *
 */

#include "JOBConstraintsEntryImpl.h"

namespace job {

ConstraintsEntry::Impl::Impl() :
outputFile_(""),
exportMode_("") {
}

ConstraintsEntry::Impl::~Impl() {
}

void
ConstraintsEntry::Impl::setOutputFile(const std::string & outputFile) {
  outputFile_ = outputFile;
}

void
ConstraintsEntry::Impl::setExportMode(const std::string & exportMode) {
  exportMode_ = exportMode;
}

std::string
ConstraintsEntry::Impl::getOutputFile() const {
  return outputFile_;
}

std::string
ConstraintsEntry::Impl::getExportMode() const {
  return exportMode_;
}

}  // namespace job
