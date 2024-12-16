//
// Copyright (c) 2024, RTE (http://www.rte-france.com)
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
 * @file  DYNTimeManager.cpp
 *
 * @brief RT time manager
 *
 */

#include <iostream>
#include <iomanip>
#include <vector>
#include <map>
#include <cstdlib>
#include <sstream>
#include <fstream>
#include <thread>
#ifdef _MSC_VER
#include <process.h>
#endif

#include "DYNTimeManager.h"

using std::chrono::system_clock;
using std::chrono::microseconds;
using std::chrono::duration_cast;

namespace DYN {

TimeManager::TimeManager(bool timeSync, double timeSyncAcceleration):
timeSync_(timeSync),
timeSyncAcceleration_(timeSyncAcceleration),
stepDuration_(0.0),
running_(false) {}

void
TimeManager::setTimeSync(bool timeSync) {
  timeSync_ = timeSync;
}

void
TimeManager::setAccelerationFactor(double timeSyncAcceleration) {
  if (timeSyncAcceleration <= 0) {
    timeSyncAcceleration_ = 1;
    timeSync_ = false;
    std::cout << "TimeManager Error: timeSyncAcceleration invalid: " << timeSyncAcceleration << std::endl;
  }
  timeSyncAcceleration_ = timeSyncAcceleration;
}

int TimeManager::getStepDuration() {
  updateStepDurationValue();
  return stepDuration_;
}

void TimeManager::updateStepDurationValue() {
  if (running_)
    stepDuration_ = (1./1000)*(duration_cast<microseconds>(system_clock::now() - stepStart_)).count();
  else
    stepDuration_ = 0.;
}

void
TimeManager::pause() {
  if (running_)
    running_ = false;
}

void
TimeManager::start(double referenceSimuTime) {
  referenceSimuTime_ = referenceSimuTime;
  referenceClockTime_ = system_clock::now();
  stepStart_ = referenceClockTime_;
  std::cout << "TimeManager::start: timeSync_= " << timeSync_ << ", timeSyncAcceleration_= " << timeSyncAcceleration_<< std::endl;
  running_ = true;
}

void
TimeManager::wait(double simuTime) {
  if (running_) {
    if (timeSync_) {
      system_clock::time_point beforeSleepTime = system_clock::now();
      double computationTimeMs = (1./1000)*(duration_cast<microseconds>(beforeSleepTime - stepStart_)).count();
      if (computationTimeMs > 0)
        std::cout << "TimeManager::wait: last step computation time: " << computationTimeMs << "ms" << std::endl;
      std::this_thread::sleep_until(referenceClockTime_ + microseconds(static_cast<int>(1000000*(simuTime-referenceSimuTime_)/timeSyncAcceleration_)));
      stepStart_ = system_clock::now();
      std::cout << "TimeManager::wait: waited for: " << (1./1000)*(duration_cast<microseconds>(stepStart_-beforeSleepTime)).count() << "ms" << std::endl;
    } else {
      system_clock::time_point newStepStart = system_clock::now();
      double computationTimeMs = (1./1000)*(duration_cast<microseconds>(newStepStart - stepStart_)).count();
      if (computationTimeMs > 0 && timeSync_)
        std::cout << "TimeManager::wait: last step computation time: " << computationTimeMs << "ms" << std::endl;
      stepStart_ = newStepStart;
    }
  }
}


}  // end of namespace DYN
