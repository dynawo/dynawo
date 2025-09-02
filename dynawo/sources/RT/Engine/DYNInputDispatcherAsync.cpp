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
#include "DYNInputDispatcherAsync.h"

#include "DYNInputChannel.h"

#include <vector>
#include <functional>
#include <iostream>
#include <atomic>

namespace DYN {

InputDispatcherAsync::InputDispatcherAsync(std::shared_ptr<ActionBuffer> &actionBuffer, std::shared_ptr<Clock>& clock) :
  actionBuffer_(actionBuffer),
  clock_(clock),
  running_(false) {}

InputDispatcherAsync::~InputDispatcherAsync() {
  stop();
}

void
InputDispatcherAsync::addReceiver(std::shared_ptr<InputChannel>& receiver) {
  receivers_.push_back(receiver);
}

void
InputDispatcherAsync::start() {
  std::cout << "InputDispatcherAsync::start receivers_.size() = " << receivers_.size() << std::endl;
  bool useTrigger = false;

  for (auto receiver : receivers_)
    useTrigger |= receiver->supports(MessageFilter::Trigger);
  clock_->setUseTrigger(useTrigger);

  for (auto receiver : receivers_)
    receiver->startReceiving([this](std::shared_ptr<InputMessage> msg){ this->dispatchMessage(std::move(msg)); }, true);
  processorThread_ = std::thread([this](){ processLoop(); });
  running_ = true;
}

void
InputDispatcherAsync::stop() {
  std::cout << "InputDispatcherAsync::stop" << std::endl;
  running_ = false;
  queueCond_.notify_all();
  for (auto receiver : receivers_)
    receiver->stop();
  if (processorThread_.joinable())
    processorThread_.join();
}

void
InputDispatcherAsync::dispatchMessage(std::shared_ptr<InputMessage> msg) {
    if (msg) {
      {
        std::lock_guard<std::mutex> lock(queueMutex_);
        messageQueue_.push(std::move(msg));
      }
      queueCond_.notify_one();
    }
}

void
InputDispatcherAsync::processLoop() {
  while (running_) {
    std::unique_lock<std::mutex> lock(queueMutex_);
    queueCond_.wait_for(lock, std::chrono::milliseconds(100), [this]() { return !messageQueue_.empty() || !running_; });

    while (!messageQueue_.empty()) {
      auto msg = messageQueue_.front();
      messageQueue_.pop();
      lock.unlock();

      switch (msg->getType()) {
        case MessageType::Action:
          actionBuffer_->registerAction(static_cast<ActionMessage &>(*msg));
          break;
        case MessageType::StepTrigger:
          clock_->handleMessage(static_cast<StepTriggerMessage &>(*msg));
          break;
        case MessageType::Stop:
          clock_->handleMessage(static_cast<StopMessage &>(*msg));
          break;
      }

      lock.lock();
    }
  }
}

}  // end of namespace DYN
