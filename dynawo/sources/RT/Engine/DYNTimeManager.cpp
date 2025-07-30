//
// Copyright (c) 2025, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
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

TimeManager::TimeManager():
triggeredStepCnt_(0),
useTrigger_(false),
timeSyncAcceleration_(1.),
stepDuration_(0.),
running_(false) {}


void
TimeManager::setAccelerationFactor(double timeSyncAcceleration) {
  if (timeSyncAcceleration <= 0) {
    timeSyncAcceleration_ = 1;
    std::cout << "TimeManager Error: timeSyncAcceleration invalid: " << timeSyncAcceleration << std::endl;
  }
  timeSyncAcceleration_ = timeSyncAcceleration;
}

// int TimeManager::getStepDuration() {
//   updateStepDurationValue();
//   return stepDuration_;
// }

// void TimeManager::updateStepDurationValue() {
//   if (running_)
//     stepDuration_ = (1./1000)*(duration_cast<microseconds>(system_clock::now() - stepStart_)).count();
//   else
//     stepDuration_ = 0.;
// }

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
  // std::cout << "TimeManager::start: timeSync_= " << timeSync_ << ", timeSyncAcceleration_= " << timeSyncAcceleration_<< std::endl;
  running_ = true;
  std::cout << "TimeManager::start, running = " << running_ << ", useTrigger = " << useTrigger_ << std::endl;
}

void
TimeManager::handleMessage(StepTriggerMessage& triggerMessage) {
    {
      std::lock_guard<std::mutex> lock(mutex_);
      triggeredStepCnt_++;
    }
    triggerCond_.notify_one();
}

void
TimeManager::handleMessage(StopMessage& stopMessage) {

}

void
TimeManager::wait(double simuTime) {
  std::cout << "wait triggeredStepCnt_ = " << triggeredStepCnt_ << std::endl;
  if (running_) { //TODO & not SIGINT
    if (!useTrigger_) {
      if (timeSyncAcceleration_ > 0)
        std::this_thread::sleep_until(referenceClockTime_ + microseconds(static_cast<int>(1000000*(simuTime-referenceSimuTime_)/timeSyncAcceleration_)));
    } else {
      std::unique_lock<std::mutex> lock(mutex_);
      triggerCond_.wait(lock, [this]()
                    { return triggeredStepCnt_ > 0 || !running_; });
      triggeredStepCnt_--;
    }
  }
}
}  // end of namespace DYN
