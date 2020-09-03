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
 * @file  DYNDelay.cpp
 *
 * @brief  Delay structure implementation file
 *
 */

#include "DYNDelay.h"

namespace DYN {
Delay::Delay(const double* value, const double* delay, double delayMax) : value_{value}, delay_{delay}, buffer_(delayMax) {}

Delay::Delay(const double* value, double delay) : value_{value}, delay_{NULL}, buffer_(delay) {}

void
Delay::saveTimepoint(double time) {
  buffer_.add(time, *value_);
}

std::pair<double, double>
Delay::getDelay(double time) const {
  double delay = isDelayConstant() ? buffer_.maxDelay() : *delay_;
  return std::make_pair(time - delay, buffer_.get(time, delay));
}

}  // namespace DYN
