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
 * @file JOBDynModelsEntryImpl.cpp
 * @brief Dynamic models entry description : implementation file
 *
 */

#include "JOBDynModelsEntryImpl.h"

namespace job {

DynModelsEntry::Impl::Impl() :
dydFile_("") {
}

DynModelsEntry::Impl::~Impl() {
}

void
DynModelsEntry::Impl::setDydFile(const std::string& dydFile) {
  dydFile_ = dydFile;
}

std::string
DynModelsEntry::Impl::getDydFile() const {
  return dydFile_;
}

}  // namespace job
