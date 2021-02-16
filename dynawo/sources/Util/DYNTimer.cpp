//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file  DYNTimer.cpp
 *
 * @brief  Class timer implementation : timers are used to monitored the code execution
 *
 */

#include "DYNTimer.h"

namespace DYN {

Timer::Timer(const std::string& name) :
name_(name),
isStopped_(false) {
}

void
Timer::stop() {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  TIMERSADD(name_, timer_.elapsed());
#endif
  isStopped_ = true;
}

Timer::~Timer() {
  if (!isStopped_)
    stop();
}

}  // namespace DYN
