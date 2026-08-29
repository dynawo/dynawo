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
 * @file JOBFinalStateEntry.cpp
 * @brief FinalState entry description : implementation file
 *
 */

#include "JOBFinalStateEntry.h"

namespace job {

FinalStateEntry::FinalStateEntry() : exportIIDMFile_(false), exportDumpFile_(false), outputIIDMFile_(""), dumpFile_("") {}

bool
FinalStateEntry::getExportIIDMFile() const {
  return exportIIDMFile_;
}

bool
FinalStateEntry::getExportDumpFile() const {
  return exportDumpFile_;
}

const std::string&
FinalStateEntry::getOutputIIDMFile() const {
  return outputIIDMFile_;
}

const std::string&
FinalStateEntry::getDumpFile() const {
  return dumpFile_;
}

void
FinalStateEntry::setExportIIDMFile(const bool exportIIDMFile) {
  exportIIDMFile_ = exportIIDMFile;
}

void
FinalStateEntry::setExportDumpFile(const bool exportDumpFile) {
  exportDumpFile_ = exportDumpFile;
}

void
FinalStateEntry::setOutputIIDMFile(const std::string& outputIIDMFile) {
  outputIIDMFile_ = outputIIDMFile;
}

void
FinalStateEntry::setDumpFile(const std::string& dumpFile) {
  dumpFile_ = dumpFile;
}

}  // namespace job
