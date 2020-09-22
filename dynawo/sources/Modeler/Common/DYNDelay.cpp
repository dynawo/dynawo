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
 * @file  DYNDelay.cpp
 *
 * @brief  Delay structure implementation file
 *
 */

#include "DYNDelay.h"

#include "DYNCommon.h"

namespace DYN {
Delay::Delay(const double* time, const double* value, double delayMax) : time_(time), value_(value), buffer_(delayMax), initialValue_() {}

Delay::Delay(const std::vector<std::pair<double, double> >& timepoints) : time_(NULL), value_(NULL), buffer_(0) {
  for (std::vector<std::pair<double, double> >::const_iterator it = timepoints.begin(); it != timepoints.end(); ++it) {
    buffer_.addNoCheck(it->first, it->second);
  }
}

void
Delay::update(const double* time, const double* value, double delayMax) {
#if _DEBUG_
  // shouldn't happen by construction
  assert(time_ == NULL);
  assert(value_ == NULL);
#endif

  time_ = time;
  value_ = value;
  buffer_.maxDelay(delayMax);
}

void
Delay::saveTimepoint() {
  if (!initialValue_.is_initialized()) {
    initialValue_ = doubleEquals(*value_, 0.0) ? 0.0 : *value_;
  }

  buffer_.add(*time_, *value_);
}

}  // namespace DYN
