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

#include <limits>

namespace DYN {

CurrentLimitInterfaceIIDM::CurrentLimitInterfaceIIDM(const boost::optional<double>& limit, const boost::optional<int>& duration) : limit_(limit) {
  if (duration == boost::none)
    acceptableDuration_ = std::numeric_limits<int>::max();
  else
    acceptableDuration_ = duration.get();
}

CurrentLimitInterfaceIIDM::~CurrentLimitInterfaceIIDM() {
}

double
CurrentLimitInterfaceIIDM::getLimit() const {
  if (limit_ == boost::none)
    return std::numeric_limits<double>::quiet_NaN();
  return limit_.get();
}

int
CurrentLimitInterfaceIIDM::getAcceptableDuration() const {
  return acceptableDuration_;
}

}  // namespace DYN
