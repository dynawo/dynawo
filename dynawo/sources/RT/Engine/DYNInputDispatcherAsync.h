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
 * @file  DYNInputDispatcherAsync.h
 *
 * @brief InputDispatcherAsync header
 *
 */
#ifndef RT_ENGINE_DYNINPUTDISPATCHERASYNC_H_
#define RT_ENGINE_DYNINPUTDISPATCHERASYNC_H_

#include <memory>
#include <queue>
#include <mutex>
#include <condition_variable>
#include <thread>
#include <atomic>
#include <vector>

#include "DYNRTInputCommon.h"
#include "DYNModel.h"
#include "DYNClock.h"
#include "DYNInputChannel.h"



namespace DYN {

class InputDispatcherAsync {
 public:
   /**
   * @brief Constructor
   * @param clock pointer to the Clock object
   */
  explicit InputDispatcherAsync(std::shared_ptr<Clock>& clock);

  /**
   * Destructor
   */
  ~InputDispatcherAsync();

  /**
   * @brief set Model instance
   * @param model model instance
   */
  void setModel(std::shared_ptr<Model> model);

  /**
   * @brief Add an input channel to the dispatcher
   * @param channel input channel pointer
   */
  void addInputChannel(std::shared_ptr<InputChannel>& inputChannel);

  /**
   * @brief set the clock and and start the receivers
   */
  void start();

  /**
   * @brief stop the simulation and all receivers
   */
  void stop();

  /**
   * @brief callback function to register a new message from an input channel
   * @param msg message to append to the message queue
   */
  void dispatchMessage(std::shared_ptr<InputMessage> msg);

 private:
  /**
   * @brief loop for message reception
   */
  void processLoop();

 private:
  std::shared_ptr<Model> model_;                             ///< Model, handles action registration
  std::shared_ptr<Clock> clock_;                             ///< Clock, handles trigger
  std::vector<std::shared_ptr<InputChannel> > channels_;     ///< Receivers for inputs and trigger

  int loopWaitInMs_;                                         ///< loop wait for periodic lock release
  std::queue<std::shared_ptr<InputMessage> > messageQueue_;  ///< queue of received messages
  std::mutex queueMutex_;                                    ///< mutex for message push/pop in the queue
  std::condition_variable queueCond_;                        ///< condition for lock release
  std::thread processorThread_;                              ///< thread for message handling loop
  std::atomic<bool> running_;                                ///< running flag
};

}  // end of namespace DYN

#endif  // RT_ENGINE_DYNINPUTDISPATCHERASYNC_H_
