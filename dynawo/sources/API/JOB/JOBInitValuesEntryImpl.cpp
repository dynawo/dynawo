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
 * @file JOBInitValuesEntryImpl.cpp
 * @brief InitValues entry description : implementation file
 */

#include "JOBInitValuesEntryImpl.h"

namespace job {

InitValuesEntry::Impl::Impl() :
dumpLocalInitValues_(false),
dumpGlobalInitValues_(false) {
}

InitValuesEntry::Impl::~Impl() {
}

void
InitValuesEntry::Impl::setDumpLocalInitValues(const bool dumpLocalInitValues) {
  dumpLocalInitValues_ = dumpLocalInitValues;
}

bool
InitValuesEntry::Impl::getDumpLocalInitValues() const {
  return dumpLocalInitValues_;
}

void
InitValuesEntry::Impl::setDumpGlobalInitValues(const bool dumpGlobalInitValues) {
  dumpGlobalInitValues_ = dumpGlobalInitValues;
}

bool
InitValuesEntry::Impl::getDumpGlobalInitValues() const {
  return dumpGlobalInitValues_;
}

}  // namespace job
