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
 * @file JOBInitValuesEntry.cpp
 * @brief InitValues entry description : implementation file
 */

#include "JOBInitValuesEntry.h"

namespace job {

InitValuesEntry::InitValuesEntry() : dumpInitModelValues_(false), dumpLocalInitValues_(false), dumpGlobalInitValues_(false) {}

void
InitValuesEntry::setDumpLocalInitValues(const bool dumpLocalInitValues) {
  dumpLocalInitValues_ = dumpLocalInitValues;
}

bool
InitValuesEntry::getDumpLocalInitValues() const {
  return dumpLocalInitValues_;
}

void
InitValuesEntry::setDumpGlobalInitValues(const bool dumpGlobalInitValues) {
  dumpGlobalInitValues_ = dumpGlobalInitValues;
}

bool
InitValuesEntry::getDumpGlobalInitValues() const {
  return dumpGlobalInitValues_;
}

void
InitValuesEntry::setDumpInitModelValues(const bool dumpInitModelValues) {
  dumpInitModelValues_ = dumpInitModelValues;
}

bool
InitValuesEntry::getDumpInitModelValues() const {
  return dumpInitModelValues_;
}

}  // namespace job
