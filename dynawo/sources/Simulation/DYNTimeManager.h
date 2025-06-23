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
 * @file  DYNTimeManager.h
 *
 * @brief TimeManager header
 *
 */
#ifndef SIMULATION_DYNTIMEMANAGER_H_
#define SIMULATION_DYNTIMEMANAGER_H_

#include <vector>
#include <queue>
#include <unordered_map>
#include <boost/shared_ptr.hpp>
#include <boost/optional.hpp>
#include <boost/filesystem.hpp>

// #include "CRVPoint.h"

#ifdef _MSC_VER
  typedef int pid_t;
#endif

namespace DYN {

/**
 * @brief TimeManager class
 *
 * class including all RT mechanics
 *
 */
class TimeManager {
 public:
  explicit TimeManager(double timeSyncAcceleration);

  void pause();

  void start(double referenceSimuTime);

  void wait(double simuTimeWait);

  // void setTimeSync(bool timeSync);

  // bool getTimeSync() {return timeSync_;}

  void setAccelerationFactor(double timeSyncAcceleration);

  // int getStepDuration();

  // void updateStepDurationValue();

  // double* getStepDurationAddr() {return &stepDuration_;}

 private:
  // bool timeSync_;  ///< true if simulation time should be synchronized with real clock >
  double timeSyncAcceleration_;  ///< acceleration factor clockTime/simulationTime >

  std::chrono::system_clock::time_point referenceClockTime_;  ///< clock reference correponding to referenceSimuTime >
  double referenceSimuTime_;  ///< simulation time ("tCurrent") reference correponding to referenceSimuTime >

  std::chrono::system_clock::time_point stepStart_;  ///< clock time before step (after sleep) >
  double stepDuration_;

  bool running_;
};

}  // end of namespace DYN

#endif  // SIMULATION_DYNTIMEMANAGER_H_
