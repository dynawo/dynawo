//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file JOBTimestepsEntryImpl.cpp
 * @brief Timesteps entry description : implementation file
 *
 */

#include "JOBTimestepsEntryImpl.h"

namespace job {

TimestepsEntry::Impl::Impl() :
step_(1) {
}

TimestepsEntry::Impl::~Impl() {
}

void
TimestepsEntry::Impl::setStep(int step) {
  step_ = step;
}

int
TimestepsEntry::Impl::getStep() const {
  return step_;
}

}  // namespace job
