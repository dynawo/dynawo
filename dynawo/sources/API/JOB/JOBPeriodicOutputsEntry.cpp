//
// Copyright (c) 2023, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite
// of simulation tools for power systems.
//

/**
 * @file JOBPeriodicOutputsEntry.cpp
 * @brief Periodic outputs entry description : implementation file
 */

#include "JOBPeriodicOutputsEntry.h"

namespace job {

PeriodicOutputsEntry::PeriodicOutputsEntry() : file_("") {}

void PeriodicOutputsEntry::setFile(const std::string &file) {
  file_ = file;
}

const std::string &PeriodicOutputsEntry::getFile() const {
  return file_;
}

void PeriodicOutputsEntry::setPeriod(const float period) {
  period_ = period;
}

const float PeriodicOutputsEntry::getPeriod() const {
    return period_;
}

void PeriodicOutputsEntry::setAdapter(const std::string &adapter) {
  adapter_ = adapter;
}

const std::string &PeriodicOutputsEntry::getAdapter() const {
    return adapter_;
}

}  // namespace job
