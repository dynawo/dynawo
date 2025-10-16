//
// Copyright (c) 2025, RTE
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
 * @file JOBClockEntry.cpp
 * @brief Clock entry description : implementation file
 */

#include "JOBClockEntry.h"

namespace job {

const std::string&
ClockEntry::getType() const {
  return type_;
}

boost::optional<double>
ClockEntry::getSpeedup() const {
  return speedup_;
}

const std::string&
ClockEntry::getTriggerChannel() const {
  return triggerChannel_;
}

void
ClockEntry::setType(const std::string& type) {
  type_ = type;
}

void
ClockEntry::setSpeedup(boost::optional<double> speedup) {
  speedup_ = speedup;
}

void
ClockEntry::setTriggerChannel(const std::string& triggerChannel) {
  triggerChannel_ = triggerChannel;
}

}  // namespace job
