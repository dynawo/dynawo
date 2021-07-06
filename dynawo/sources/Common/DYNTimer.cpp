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

#ifdef LANG_CXX11
#include <thread>
#include <sstream>
#endif

namespace DYN {

Timers::Timers() {
}

Timers::~Timers() {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  std::map<std::string, double>::const_iterator itT;
  for (itT = timers_.begin(); itT != timers_.end(); ++itT) {
    std::cout << "TIMER[" << itT->first << "] = " << itT->second << " secondes en " << nbAppels_[itT->first] << " appels" << std::endl;
  }
#endif
}

Timers&
Timers::instance() {
#ifdef LANG_CXX11
  static thread_local Timers instance;
#else
  static Timers instance;
#endif
  return instance;
}

void
Timers::add(const std::string& name, const double& time) {
  Timers& timers = instance();
  timers.add_(name, time);
}

void
Timers::add_(const std::string& name, const double& time) {
#ifdef LANG_CXX11
  std::stringstream ss;
  ss << std::this_thread::get_id() << "_" << name;
  std::string name_formatted = ss.str();
#else
  std::string name_formatted = name;
#endif
  timers_[name_formatted] += time;
  nbAppels_[name_formatted] += 1;
}

Timer::Timer(const std::string& name) :
name_(name),
#ifdef LANG_CXX11
startPoint_(std::chrono::steady_clock::now()),
#endif
isStopped_(false) {
}

void
Timer::stop() {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
#if LANG_CXX11
  auto duration = std::chrono::duration_cast<std::chrono::microseconds>(std::chrono::steady_clock::now() - startPoint_);
  double elapsed = static_cast<double>(duration.count()) / 1000000;  // For the result in seconds
#else
  double elapsed = timer_.elapsed();
#endif
  Timers::add(name_, elapsed);
#endif
  isStopped_ = true;
}

Timer::~Timer() {
  if (!isStopped_)
    stop();
}

}  // namespace DYN
