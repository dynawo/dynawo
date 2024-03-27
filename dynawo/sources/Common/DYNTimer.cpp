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

#include <thread>
#include <sstream>

namespace DYN {

Timers::~Timers() {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  std::map<std::string, double>::const_iterator itT;
  for (itT = timers_.begin(); itT != timers_.end(); ++itT) {
    std::cout << "TIMER[" << itT->first << "] = " << itT->second << " seconds in " << nbAppels_[itT->first] << " calls" << std::endl;
  }
#endif
}

Timers&
Timers::instance() {
  static thread_local Timers instance;
  return instance;
}

void
Timers::add(const std::string& name, const double& time) {
  Timers& timers = instance();
  timers.add_(name, time);
}

void
Timers::add_(const std::string& name, const double& time) {
  std::stringstream ss;
  ss << std::this_thread::get_id() << "_" << name;
  std::string name_formatted = ss.str();
  timers_[name_formatted] += time;
  nbAppels_[name_formatted] += 1;
}

Timer::Timer(const std::string& name) :
name_(name),
startPoint_(std::chrono::steady_clock::now()),
isStopped_(false) {
}

void
Timer::stop() {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  double elapsedTime = elapsed();
  Timers::add(name_, elapsedTime);
#endif
  isStopped_ = true;
}

Timer::~Timer() {
  if (!isStopped_)
    stop();
}

double Timer::elapsed() const {
  if (isStopped_) {
    return 0.;
  }
  auto duration = std::chrono::duration_cast<std::chrono::microseconds>(std::chrono::steady_clock::now() - startPoint_);
  return static_cast<double>(duration.count()) / 1000000;  // For the result in seconds
}

}  // namespace DYN
