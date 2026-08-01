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
 * @file JOBInitialStateEntry.cpp
 * @brief Initial state entries description : implementation file
 *
 */

#include "JOBInitialStateEntry.h"

namespace job {

void
InitialStateEntry::setInitialStateFile(const std::string& initialStateFile) {
  initialStateFile_ = initialStateFile;
}

const std::string&
InitialStateEntry::getInitialStateFile() const {
  return initialStateFile_;
}

}  // namespace job
