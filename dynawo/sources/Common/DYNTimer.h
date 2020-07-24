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
 * @file  DYNTimer.h
 *
 * @brief Class timer header : timers are used to monitored the code execution
 *
 */
#ifndef COMMON_DYNTIMER_H_
#define COMMON_DYNTIMER_H_

#include <map>
#include <string>
#include <vector>

#include <boost/timer.hpp>
#include <boost/core/noncopyable.hpp>

// #define PRINT_TIMERS

namespace DYN {

/**
 * @class Timers
 * @brief Timers clas description : stored all timer created during execution
 *
 */
class Timers : private boost::noncopyable {
 public:
  /**
   * @brief add new statistics for a given timer
   *
   * @param name name of timer
   * @param time time elapsed for the timer
   */
  static void add(const std::string& name, const double& time);

  /**
   * @brief get the unique instance of Timers in current memory space
   *
   * @return the unique instance
   */
  static Timers& getInstance();

 private:
  /**
   * @brief default constructor
   */
  Timers();

  /**
   * @brief destructor
   */
  ~Timers();

  /**
   * @brief internal add new statistics for a given timer
   *
   * @param name name of timer
   * @param time time elapsed for the timer
   */
  void add_(const std::string& name, const double& time);

  /**
   * @brief get the best candidate for unique instance of Timers
   *
   * @return the unique instance
   */
  static Timers& getInstance_();

 private:
  std::map<std::string, double> timers_;  ///< association between timers and time elapsed
  std::map<std::string, int32_t> nbAppels_;  ///< association between timers and number of call
};

/**
 * @class Timer
 * @brief Timer clas description :compute time elapsed between its creation
 * and its destruction
 *
 */
class Timer : private boost::noncopyable {
 public:
  /**
   * @brief constructor
   *
   * @param name name of the timer
   */
  explicit Timer(const std::string& name);

  /**
   * @brief destructor
   */
  ~Timer();

  /**
   * @brief stop the timer
   */
  void stop();

 private:
  std::string name_;  ///< name of timer
  boost::timer timer_;  ///< boost timer to compute time elapsed
  bool isStopped_;  ///< @b true is the timer is stopped
};

}  // namespace DYN

#ifdef DYNTIMERS_INSTANCE
/**
 * @brief get the unique instance of Timers in the executable
 *
 * @return the unique instance
 */
extern "C" DYN::Timers& getTimersInstance() {
  return DYN::Timers::getInstance();
}
#endif

#endif  // COMMON_DYNTIMER_H_
