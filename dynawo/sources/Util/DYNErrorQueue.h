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

#ifndef UTIL_DYNERRORQUEUE_H_
#define UTIL_DYNERRORQUEUE_H_

#include <queue>
#include <boost/core/noncopyable.hpp>
#include <boost/shared_ptr.hpp>

#include "DYNError.h"

/**
 * @brief API to DYN::ErrorQueue::push
 * @param exception error to register
*/
extern "C" void ErrorQueuePush(const DYN::Error& exception);
/**
 * @brief API to DYN::ErrorQueue::flush
*/
extern "C" void ErrorQueueFlush();

namespace DYN {

/**
 * @class ErrorQueue
 * @brief class to register multiple errors before failing
 */
class ErrorQueue : private boost::noncopyable{
 private:
  /**
   * @brief Constructor
   */
  ErrorQueue();

  /**
   * @brief Destructor
   */
  ~ErrorQueue();

  /**
   * @brief register a new error in the queue
   *
   * @param exception error to register
   */
  static void push(const DYN::Error& exception);

  /**
   * @brief throw errors if the queue is not empty, otherwise do nothing
   */
  static void flush();

  /**
   * @brief get singleton
   *
   * @return singleton
   */
  static ErrorQueue& instance();

  /**
  * @brief register a new error in the queue
  *
  * @param exception error to register
  */
  void push_(const DYN::Error& exception);

  /**
   * @brief throw errors if the queue is not empty, otherwise do nothing
   */
  void flush_();

  /**
   * @brief Get the maximum number of errors displayed
   *
   * @return maximum number of errors displayed
   */
  static size_t getMaxDisplayedError();

  friend void (::ErrorQueuePush)(const DYN::Error& exception);  ///< Method ErrorQueuePush must get access to @p push() private function
  friend void (::ErrorQueueFlush)();  ///< Method ErrorQueueFlush must get access to @p flush() private function

 private:
  std::queue< DYN::Error > exceptionQueue_;  ///< error queue
};

} /* namespace DYN */

#endif  // UTIL_DYNERRORQUEUE_H_
