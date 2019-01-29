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
 * @file  DYNTimer.cpp
 *
 * @brief  Class timer implementation : timers are used to monitored the code execution
 *
 */
#include <iostream>

#include "DYNTimer.h"

using std::stringstream;

namespace DYN {
Timers Timers::INSTANCE;

Timers::Timers() {
}

Timers::~Timers() {
#ifdef _DEBUG_
  std::map<std::string, double>::const_iterator itT;
  for (itT = timers_.begin(); itT != timers_.end(); ++itT) {
    std::cout << "TIMER[" << itT->first << "] = " << itT->second << " secondes en " << nbAppels_[itT->first] << " appels" << std::endl;
  }
#endif
}

void
Timers::add(const std::string& name, const double& time) {
  timers_[name] += time;
  nbAppels_[name] += 1;
}

Timer::Timer(const std::string& name) :
name_(name),
timer_(),
isStopped_(false) {
}

void
Timer::start() {
#ifdef _DEBUG_
  timer_.restart();
#endif
  isStopped_ = false;
}

void
Timer::stop() {
#ifdef _DEBUG_
  Timers::INSTANCE.add(name_, timer_.elapsed());
#endif
  isStopped_ = true;
}

Timer::~Timer() {
  if (!isStopped_)
    stop();
}

}  // namespace DYN
