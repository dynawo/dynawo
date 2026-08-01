//
// Copyright (c) 2022, RTE (http://www.rte-france.com)
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
 * @file JOBLocalInitEntry.cpp
 * @brief Local init entries description : implementation file
 *
 */

#include "JOBLocalInitEntry.h"

namespace job {

void
LocalInitEntry::setParFile(const std::string& initParFile) {
  initParFile_ = initParFile;
}

const std::string&
LocalInitEntry::getParFile() const {
  return initParFile_;
}

void
LocalInitEntry::setParId(const std::string& parametersId) {
  initParId_ = parametersId;
}

const std::string&
LocalInitEntry::getParId() const {
  return initParId_;
}

}  // namespace job
