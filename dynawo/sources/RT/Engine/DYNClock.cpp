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
 * @file  DYNClock.cpp
 *
 * @brief RT clock
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

#include "DYNSignalHandler.h"

#include "DYNClock.h"

using std::chrono::steady_clock;
using std::chrono::microseconds;
using std::chrono::duration_cast;

namespace DYN {

Clock::Clock():
useTrigger_(false),
running_(false),
stopMessageReceived_(false),
speedup_(1.),
referenceSimuTime_(0.),
triggeredStepCnt_(0) {}


void
Clock::setSpeedup(double speedup) {
  if (speedup <= 0) {
    speedup_ = 1;
  }
  speedup_ = speedup;
}

void
Clock::start(double simulationTime) {
  referenceSimuTime_ = simulationTime;
  referenceClockTime_ = steady_clock::now();
  running_ = true;
}

void
Clock::stop() {
  running_ = false;
  triggerCond_.notify_all();
}

void
Clock::handleMessage(StepTriggerMessage& /*triggerMessage*/) {
    {
      std::lock_guard<std::mutex> lock(mutex_);
      triggeredStepCnt_++;
    }
    triggerCond_.notify_one();
}

void
Clock::handleMessage(StopMessage& /*stopMessage*/) {
  stopMessageReceived_ = true;
  stop();
}

void
Clock::wait(double simulationTime) {
  if (!useTrigger_) {
    if (running_ && speedup_ > 0)
      std::this_thread::sleep_until(referenceClockTime_ + microseconds(static_cast<int>(1000000*(simulationTime-referenceSimuTime_)/speedup_)));
    return;
  } else {
    while (running_ && !SignalHandler::gotExitSignal()) {
      std::unique_lock<std::mutex> lock(mutex_);
      triggerCond_.wait_for(lock, std::chrono::milliseconds(100), [this]() { return triggeredStepCnt_ > 0 || !running_; });
      if (triggeredStepCnt_ > 0) {
        triggeredStepCnt_--;
        return;
      }
    }
  }
}

bool
Clock::getStopMessageReceived() const {
  return stopMessageReceived_;
}

bool
Clock::getUseTrigger() const {
  return useTrigger_;
}

void
Clock::setUseTrigger(const bool useTrigger) {
  useTrigger_ = useTrigger;
}

}  // end of namespace DYN
