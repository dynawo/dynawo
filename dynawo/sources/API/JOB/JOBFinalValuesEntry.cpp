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
 * @file JOBFinalValuesEntry.cpp
 * @brief FinalValues entry description : implementation file
 */

#include "JOBFinalValuesEntry.h"

namespace job {

FinalValuesEntry::FinalValuesEntry() : dumpFinalValues_(false) {}

void
FinalValuesEntry::setDumpFinalValues(const bool dumpFinalValues) {
    dumpFinalValues_ = dumpFinalValues;
}

bool
FinalValuesEntry::getDumpFinalValues() const {
  return dumpFinalValues_;
}

}  // namespace job
