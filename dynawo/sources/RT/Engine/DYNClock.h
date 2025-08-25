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
 * @file  DYNClock.h
 *
 * @brief Clock header
 *
 */
#ifndef RT_ENGINE_DYNCLOCK_H_
#define RT_ENGINE_DYNCLOCK_H_

#include <vector>
#include <queue>
#include <unordered_map>
#include <boost/shared_ptr.hpp>
#include <boost/optional.hpp>
#include <boost/filesystem.hpp>
#include <atomic>
#include <mutex>
#include <condition_variable>

#include "DYNRTInputCommon.h"

#ifdef _MSC_VER
  typedef int pid_t;
#endif

namespace DYN {

/**
 * @brief Clock class
 *
 * class including time related RT functions
 *
 */
class Clock {
 public:
  Clock();

  void start(double referenceSimuTime);

  void pause();

  void stop();

  void wait(double simuTimeWait);

  void setAccelerationFactor(double speedup);

  void handleMessage(StepTriggerMessage& triggerMessage);

  void handleMessage(StopMessage& stopMessage);

  void setUseTrigger(bool useTrigger) {useTrigger_ = useTrigger;}

  bool getStopMessageReceived();

 private:
  bool useTrigger_;   ///< true if wait needs a trigger from an input channel
  double period_;     ///< period of time in s for step outputs
  bool running_;      ///< running status of clock
  bool stopMessageReceived_;   ///< true if a stop message has been received

  // Internal time sync
  // bool timeSync_;  ///< true if simulation time should be synchronized with real clock >
  double speedup_;  ///< acceleration factor clockTime/simulationTime >
  std::chrono::system_clock::time_point referenceClockTime_;  ///< clock reference correponding to referenceSimuTime >
  double referenceSimuTime_;  ///< simulation time ("tCurrent") reference correponding to referenceSimuTime >

  std::chrono::system_clock::time_point stepStart_;  ///< clock time before step (after sleep) >
  double stepDuration_;


  std::atomic<int> triggeredStepCnt_;   ///< number of triggered step_
  std::mutex mutex_;
  std::condition_variable triggerCond_;
};

}  // end of namespace DYN

#endif  // RT_ENGINE_DYNCLOCK_H_
