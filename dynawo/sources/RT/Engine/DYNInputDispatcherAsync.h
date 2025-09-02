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
#include "DYNActionBuffer.h"
#include "DYNClock.h"
#include "DYNInputChannel.h"



namespace DYN {

class InputDispatcherAsync {
 public:
  InputDispatcherAsync(std::shared_ptr<ActionBuffer> &actionBuffer, std::shared_ptr<Clock>& clock);

  ~InputDispatcherAsync();

  void addReceiver(std::shared_ptr<InputChannel>& receiver);

  void start();

  void stop();

  void dispatchMessage(std::shared_ptr<InputMessage> msg);

 private:
  // void dispatchDirect(std::shared_ptr<InputMessage> msg);

  void processLoop();

 private:
  std::shared_ptr<ActionBuffer> actionBuffer_;
  std::shared_ptr<Clock> clock_;
  std::vector<std::shared_ptr<InputChannel> > receivers_;

  std::queue<std::shared_ptr<InputMessage>> messageQueue_;
  std::mutex queueMutex_;
  std::condition_variable queueCond_;
  std::thread processorThread_;
  std::atomic<bool> running_;
};

}  // end of namespace DYN

#endif  // RT_ENGINE_DYNINPUTDISPATCHERASYNC_H_
