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

#include <dlfcn.h>

#include "DYNTimer.h"

using std::stringstream;

namespace DYN {

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

Timers&
Timers::getInstance() {
  static Timers INSTANCE;  ///< the quasi singleton !
  return INSTANCE;
}

typedef Timers& getTimersInstance_t();

Timers&
Timers::getInstance_() {
  void* handle = dlopen(NULL, RTLD_NOW);
  Timers* pTimers = NULL;

  if (!handle) {
    std::cerr << dlerror() << '\n';
  } else {
    dlerror();
    getTimersInstance_t* getTimersInstance = reinterpret_cast<getTimersInstance_t*> (dlsym(handle, "getTimersInstance"));
    if (!dlerror()) {
      pTimers = &(getTimersInstance());
    }
    dlclose(handle);
  }

  if (!pTimers) {
    pTimers = &(getInstance());
  }

  return *pTimers;
}

void
Timers::add(const std::string& name, const double& time) {
  Timers& timers = getInstance_();
  timers.add_(name, time);
}

void
Timers::add_(const std::string& name, const double& time) {
  timers_[name] += time;
  nbAppels_[name] += 1;
}

Timer::Timer(const std::string& name) :
name_(name),
isStopped_(false) {
}

void
Timer::stop() {
#ifdef _DEBUG_
  Timers::add(name_, timer_.elapsed());
#endif
  isStopped_ = true;
}

Timer::~Timer() {
  if (!isStopped_)
    stop();
}

}  // namespace DYN
