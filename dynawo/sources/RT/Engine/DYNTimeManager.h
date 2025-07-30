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
 * @file  DYNTimeManager.h
 *
 * @brief TimeManager header
 *
 */
#ifndef RT_SYSTEM_DYNTIMEMANAGER_H_
#define RT_SYSTEM_DYNTIMEMANAGER_H_

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
 * @brief TimeManager class
 *
 * class including time related RT functions
 *
 */
class TimeManager {
 public:
  TimeManager();

  void pause();

  void start(double referenceSimuTime);

  void wait(double simuTimeWait);

  // void setTimeSync(bool timeSync);

  // bool getTimeSync() {return timeSync_;}

  void setAccelerationFactor(double timeSyncAcceleration);

  void handleMessage(StepTriggerMessage& triggerMessage);

  void handleMessage(StopMessage& stopMessage);

  void setUseTrigger(bool useTrigger) {useTrigger_ = useTrigger;};

  // int getStepDuration();

  // void updateStepDurationValue();

  // double* getStepDurationAddr() {return &stepDuration_;}

 private:
  bool useTrigger_;   ///< true if wait is used with usesTrigger_


  // bool timeSync_;  ///< true if simulation time should be synchronized with real clock >
  double timeSyncAcceleration_;  ///< acceleration factor clockTime/simulationTime >

  std::chrono::system_clock::time_point referenceClockTime_;  ///< clock reference correponding to referenceSimuTime >
  double referenceSimuTime_;  ///< simulation time ("tCurrent") reference correponding to referenceSimuTime >

  std::chrono::system_clock::time_point stepStart_;  ///< clock time before step (after sleep) >
  double stepDuration_;

  bool running_;

  std::atomic<int> triggeredStepCnt_;   ///< number of triggered step_
  std::mutex mutex_;
  std::condition_variable triggerCond_;
};

}  // end of namespace DYN

#endif  // RT_SYSTEM_DYNTIMEMANAGER_H_
