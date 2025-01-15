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
 * @file  DYNCurrentLimitInterfaceIIDM.cpp
 *
 * @brief Current limit interface : implementation file
 *
 */

#include "DYNCurrentLimitInterfaceIIDM.h"
#include "DYNCommon.h"

#include <limits>

namespace DYN {

CurrentLimitInterfaceIIDM::CurrentLimitInterfaceIIDM(double limit, unsigned long duration, bool fictitious)
: limit_(limit), fictitious_(fictitious) {
  if (duration == std::numeric_limits<unsigned long>::max())
    acceptableDuration_ = std::numeric_limits<int>::max();
  else
    acceptableDuration_ = duration;
}

double
CurrentLimitInterfaceIIDM::getLimit() const {
  if (doubleEquals(limit_, std::numeric_limits<double>::max()))
    return std::numeric_limits<double>::quiet_NaN();
  return limit_;
}

int
CurrentLimitInterfaceIIDM::getAcceptableDuration() const {
  return static_cast<int>(acceptableDuration_);
}

bool
CurrentLimitInterfaceIIDM::isFictitious() const {
  return fictitious_;
}

}  // namespace DYN
