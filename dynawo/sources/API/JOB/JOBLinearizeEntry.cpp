//
// Copyright (c) 2025, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file JOBLinearizeEntryImpl.cpp
 * @brief Linearize entry description : implementation file
 *
 */

#include "JOBLinearizeEntry.h"

namespace job {

void
LinearizeEntry::setLinearizeTime(const double linearizeTime) {
  linearizeTime_ = linearizeTime;
}

double
LinearizeEntry::getLinearizeTime() const {
  return linearizeTime_;
}

void LinearizeEntry::setUseLinearizeModel(bool useLinearizeModel) {
  useLinearizeModel_ = useLinearizeModel;
}

bool LinearizeEntry::getUseLinearizeModel() const {
  return useLinearizeModel_;
}

}  // namespace job
