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
 * @file JOBLineariseEntryImpl.cpp
 * @brief Linearise entry description : implementation file
 *
 */

#include "JOBLineariseEntryImpl.h"

namespace job {

LineariseEntry::Impl::Impl() :
lineariseTime_(0) {
}

LineariseEntry::Impl::~Impl() {
}

void
LineariseEntry::Impl::setLineariseTime(const double & lineariseTime) {
  lineariseTime_ = lineariseTime;
}

double
LineariseEntry::Impl::getLineariseTime() const {
  return lineariseTime_;
}

}  // namespace job
