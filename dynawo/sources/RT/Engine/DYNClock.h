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

  /**
   * @brief start the simulation
   * @param simulationTime start
   */
  void start(double simulationTime);

  /**
   * @brief stop the simulation
   */
  void stop();

  /**
   * @brief wait for either trigger signal or time relative to simulation time
   * @param simulationTime current time of the simulation
   */
  void wait(double simulationTime);

  /**
   * @brief set speedup value if
   * @param speedup speedup value
   */
  void setSpeedup(double speedup);

  /**
   * @brief handle a received Trigger message
   * @param triggerMessage trigger message
   */
  void handleMessage(StepTriggerMessage& triggerMessage);

  /**
   * @brief handle a received Stop message
   * @param stopMessage stop message
   */
  void handleMessage(StopMessage& stopMessage);

  /**
   * @brief use trigger attribute
   * @param useTrigger use trigger attribute
   */
  void setUseTrigger(bool useTrigger);

  /**
   * @brief use trigger attribute getter
   * @return use trigger attribute
   */
  bool getUseTrigger();

  /**
   * @brief Stop message received flag getter
   * @return Stop message received flag
   */
  bool getStopMessageReceived();

 private:
  bool useTrigger_;   ///< true if wait needs a trigger from an input channel
  bool running_;      ///< running status of clock
  bool stopMessageReceived_;   ///< true if a stop message has been received

  // Internal time sync
  double speedup_;  ///< acceleration factor clockTime/simulationTime >
  std::chrono::system_clock::time_point referenceClockTime_;  ///< clock reference correponding to referenceSimuTime >
  double referenceSimuTime_;  ///< simulation time ("tCurrent") reference correponding to referenceSimuTime >

  // External time sync
  std::atomic<int> triggeredStepCnt_;   ///< number of triggered step_
  std::mutex mutex_;
  std::condition_variable triggerCond_;
};

}  // end of namespace DYN

#endif  // RT_ENGINE_DYNCLOCK_H_
