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

#include <atomic>
#include <mutex>
#include <condition_variable>

#include "DYNRTInputCommon.h"

namespace DYN {

/**
 * @brief Clock class
 *
 * class including time related RT functions
 *
 */
class Clock {
 public:
  /**
   * @brief constructor
   */
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
   * @brief wait for either step trigger signal or time relative to simulation time
   * @param simulationTime current time of the simulation
   */
  void wait(double simulationTime);

  /**
   * @brief set speedup value if
   * @param speedup speedup value
   */
  void setSpeedup(double speedup);

  /**
   * @brief handle a received step trigger message
   * @param stepTriggerMessage step trigger message
   */
  void handleMessage(StepTriggerMessage& stepTriggerMessage);

  /**
   * @brief handle a received Stop message
   * @param stopMessage stop message
   */
  void handleMessage(StopMessage& stopMessage);

  /**
   * @brief use step trigger attribute setter
   * @param useStepTrigger use step trigger attribute
   */
  void setUseStepTrigger(bool useStepTrigger);

  /**
   * @brief use step trigger attribute getter
   * @return use step trigger attribute
   */
  bool getUseStepTrigger() const;

  /**
   * @brief stop message received flag getter
   * @return stop message received flag
   */
  bool getStopMessageReceived() const;

 private:
  bool useStepTrigger_;               ///< true if wait needs a step trigger signal from an input channel
  bool running_;                      ///< running status of clock
  bool stopMessageReceived_;          ///< true if a stop message has been received

  // Internal time sync
  double speedup_;                    ///< acceleration factor clockTime/simulationTime
  std::chrono::steady_clock::time_point referenceClockTime_;  ///< clock reference correponding to referenceSimuTime
  double referenceSimuTime_;          ///< simulation time ("tCurrent") reference correponding to referenceSimuTime

  // External time sync
  std::atomic<int> triggeredStepCnt_;    ///< number of triggered steps
  std::mutex mutex_;                     ///< mutex for trigger wait
  std::condition_variable triggerCond_;  ///< trigger condition variable to unlock mutex in wait
};

}  // end of namespace DYN

#endif  // RT_ENGINE_DYNCLOCK_H_
