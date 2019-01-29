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
 * @file JOBFinalStateEntryImpl.cpp
 * @brief FinalState entry description : implementation file
 *
 */

#include "JOBFinalStateEntryImpl.h"

namespace job {

FinalStateEntry::Impl::Impl() :
exportIIDMFile_(false),
exportDumpFile_(false),
outputIIDMFile_(""),
dumpFile_("") {
}

FinalStateEntry::Impl::~Impl() {
}

bool
FinalStateEntry::Impl::getExportIIDMFile() const {
  return exportIIDMFile_;
}

bool
FinalStateEntry::Impl::getExportDumpFile() const {
  return exportDumpFile_;
}

std::string
FinalStateEntry::Impl::getOutputIIDMFile() const {
  return outputIIDMFile_;
}

std::string
FinalStateEntry::Impl::getDumpFile() const {
  return dumpFile_;
}

void
FinalStateEntry::Impl::setExportIIDMFile(const bool exportIIDMFile) {
  exportIIDMFile_ = exportIIDMFile;
}

void
FinalStateEntry::Impl::setExportDumpFile(const bool exportDumpFile) {
  exportDumpFile_ = exportDumpFile;
}

void
FinalStateEntry::Impl::setOutputIIDMFile(const std::string& outputIIDMFile) {
  outputIIDMFile_ = outputIIDMFile;
}

void
FinalStateEntry::Impl::setDumpFile(const std::string& dumpFile) {
  dumpFile_ = dumpFile;
}

}  // namespace job
