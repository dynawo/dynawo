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
 * @file  DYNZmqInput.h
 *
 * @brief ZmqInput header
 *
 */
#ifndef RT_IO_DYNZMQINPUT_H_
#define RT_IO_DYNZMQINPUT_H_

#include "DYNInputInterface.h"
#include "DYNModel.h"
#include "DYNSubModel.h"

#include <mutex>
#include <vector>
#include <string>
#include <condition_variable>
#include <zmqpp/zmqpp.hpp>
#include <atomic>


#ifdef _MSC_VER
  typedef int pid_t;
#endif

namespace DYN {

/**
 * @brief ZmqInput class
 *
 * class for event interraction
 *
 */
class ZmqInput: public InputInterface {
 public:
  ZmqInput(const std::string id, MessageFilter messageFilter, const std::string& endpoint ="tcp://*:5555");

  // void start();

  void startReceiving(const std::function<void(std::shared_ptr<InputMessage>)>& callback, bool useThread = true) override;

  void stop();

  // bool registerAction(std::string& input);

  // void sendReply(const std::string& msg);

  void receiveMessages(bool stop);

  // void messageReceiverAsync();

 private:
  void receiveLoop();

  // bool handleMessage(zmqpp::message& message);

 private:
  const std::string STOP_KEY = "stop";
  // std::string endpoint_;
  // MessageType type_;
  zmqpp::context context_;
  zmqpp::socket socket_;
  std::atomic<bool> stopFlag_;
  bool useThread_;
  long pollTimeoutMs_;
  // std::thread thread_;
  std::function<void(std::shared_ptr<InputMessage>)> callback_;

  // zmqpp::context context_;
  // zmqpp::socket socket_;
  std::thread thread_;
  // bool running_;
  // bool asyncMode_;

  // Async variables
  // int stepTriggeredCnt_;
  // std::mutex simulationMutex_;
  // std::condition_variable simulationStepTriggerCondition_;
};

}  // end of namespace DYN

#endif  // RT_IO_DYNZMQINPUT_H_
