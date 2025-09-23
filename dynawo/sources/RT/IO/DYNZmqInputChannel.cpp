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
 * @file  DYNZmqInputChannel.cpp
 *
 * @brief Event interractor
 *
 */
#include "DYNZmqInputChannel.h"

#include "PARParametersSetFactory.h"
#include "DYNModelMulti.h"
#include "DYNSignalHandler.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"

#include <signal.h>

namespace DYN {

ZmqInputChannel::ZmqInputChannel(std::string id, MessageFilter messageFilter, const std::string& endpoint) :
InputChannel(std::move(id), std::move(messageFilter)),
socket_(context_, zmqpp::socket_type::reply),
useThread_(false),
stopFlag_(false),
pollTimeoutMs_(10) {
  try {
    socket_.bind(endpoint);
  } catch (const zmqpp::exception& e) {
    throw DYNError(DYN::Error::GENERAL, ZMQInterfaceBadEnpoint, endpoint);
  }
}

// void
// ZmqInputChannel::start() {
//   if (asyncMode_) {
//     receiverThread_ = std::thread(&ZmqInputChannel::messageReceiverAsync, this);
//     std::cout << "ZmqInputChannel: thread started" << std::endl;
//   }
//   running_ = true;
// }

// void
// ZmqInputChannel::stop() {
//   if (!running_)
//     return;

//   if (asyncMode_) {
//     simulationStepTriggerCondition_.notify_all();
//     receiverThread_.join();
//     std::cout << "ZmqInputChannel: thread stopped" << std::endl;
//   } else {
//     receiveMessages(true);
//   }
//   running_ = false;
// }

void
ZmqInputChannel::startReceiving(const std::function<void(std::shared_ptr<InputMessage>)>& callback, bool useThread) {
  std::cout << "ZmqInputChannel::startReceiving" << std::endl;
  callback_ = callback;
  useThread_ = useThread;
  if (useThread_) {
    thread_ = std::thread([this]() { receiveLoop(); });
    std::cout << "ZmqInputChannel: thread started" << std::endl;
  }
}

void
ZmqInputChannel::stop() {
  if (!stopFlag_) {
    stopFlag_ = true;
    if (thread_.joinable())
      thread_.join();
    socket_.close();
  }
}

void
ZmqInputChannel::receiveLoop() {
  zmqpp::poller poller;
  poller.add(socket_);

  while (!stopFlag_) {
    if (poller.poll(pollTimeoutMs_)) {
      std::cout << "ZmqInputChannel: message received" << std::endl;

      if (poller.has_input(socket_)) {
        zmqpp::message message;
        socket_.receive(message);

        std::string payload;
        message >> payload;

        zmqpp::message reply;
        std::shared_ptr<InputMessage> inputMsg;
        if (payload.empty()) {
          if (!supports(MessageFilter::Trigger)) {
            reply << "trigger received but not supported";
          } else {
            reply << "trigger received";
            inputMsg = std::make_shared<StepTriggerMessage>();
          }
        } else if (payload == STOP_KEY) {
          if (!supports(MessageFilter::TimeManagement)) {
            reply << "stop received but not supported";
          } else {
            reply << "stop received";
            inputMsg = std::make_shared<StopMessage>();
          }
        } else {
          if (!supports(MessageFilter::Actions)) {
            reply << "action received but not supported";
          } else {
            reply << "action received";
            inputMsg = std::make_shared<ActionMessage>(payload);
          }
        }
        socket_.send(reply);
        callback_(std::move(inputMsg));
      }
    }
  }
}

// bool
// ZmqInputChannel::handleMessage(zmqpp::message& message) {
//   std::string payload;
//   message >> payload;

//   zmqpp::message reply;
//   std::shared_ptr<InputMessage> inputMsg;
//   if (payload.empty()) {
//     reply << "trigger received";
//     inputMsg = std::make_shared<StepTriggerMessage>();
//   } else if (!payload.compare(STOP_KEY)) {
//     reply << "stop received";
//     inputMsg = std::make_shared<StopMessage>();
//   } else {
//     reply << "action received";
//     inputMsg = std::make_shared<ActionMessage>(payload);
//   }
//   socket_.send(reply);
//   callback_(std::move(inputMsg));
//   return ((inputMsg) && (inputMsg->getType() == MessageType::StepTrigger || inputMsg->getType() == MessageType::Stop));
// }

// void
// ZmqInputChannel::receiveMessages(bool stop = false) {
//   zmqpp::poller poller;
//   poller.add(socket_);

//   while (running_ && !SignalHandler::gotExitSignal()) {
//     // Polling
//     if (poller.poll(pollTimeoutMs_)) {
//       std::cout << "ZmqInputChannel: message received" << std::endl;

//       if (poller.has_input(socket_)) {
//         zmqpp::message message;
//         socket_.receive(message);
//         std::string input;
//         message >> input;
//         zmqpp::message reply;
//         if (input.empty() && (clock_)) {
//             // trigger next step
//             if (stop) {
//               reply << "simulation ended";
//               std::cout << "Reply: simulation ended" << std::endl;
//             } else {
//               reply << "trigger reply";
//               std::cout << "Reply: trigger reply" << std::endl;
//             }
//             socket_.send(reply);
//             return;

//         } else if (!input.compare(STOP_KEY)) {
//           running_ = false;
//           reply << "stop signal";
//           socket_.send(reply);
//           std::cout << "Stop signal received. Ending simulation." << std::endl;
//           kill(getpid(), SIGINT);

//         } else if (actionBuffer_) {
//           // Register the action
//           if (actionBuffer_->registerAction(input)) {
//             reply << "Action registered";
//           } else {
//             reply << "Action registration failed";
//           }
//           socket_.send(reply);
//         } else {
//           zmqpp::message reply;
//           reply << "Unknown request";
//           socket_.send(reply);
//         }
//       }
//     }
//   }
// }

// void
// ZmqInputChannel::messageReceiverAsync() {
//   //TODO review

//   // zmqpp::poller poller;
//   // poller.add(socket_);

//   // while (running_ && !SignalHandler::gotExitSignal()) {
//   //   zmqpp::message message;

//   //   // Polling
//   //   if (poller.poll(pollTimeoutMs_)) {
//   //     std::cout << "ZmqInputChannel: message received" << std::endl;

//   //     if (poller.has_input(socket_)) {
//   //       zmqpp::message message;
//   //       socket_.receive(message);
//   //       std::string input;
//   //       message >> input;

//   //       zmqpp::message reply;
//   //       if (input.empty() && triggerEnabled_) {
//   //           // trigger next step
//   //           reply << "Step triggered";
//   //           std::lock_guard<std::mutex> simulationLock(simulationMutex_);
//   //           stepTriggeredCnt_++;
//   //           simulationStepTriggerCondition_.notify_one();
//   //           socket_.send(reply);
//   //       } else if (!input.compare(STOP_KEY)) {
//   //         running_ = false;
//   //         reply << "stop signal";
//   //         socket_.send(reply);
//   //         std::cout << "Stop signal received. Ending simulation." << std::endl;
//   //         kill(getppid(), SIGINT);
//   //       } else if (actionsEnabled_) {
//   //         // Register the action
//   //         zmqpp::message reply;
//   //         if (registerAction(input)) {
//   //           reply << "Action registered";
//   //         } else {
//   //           reply << "Action registration failed";
//   //         }
//   //         socket_.send(reply);
//   //       } else {
//   //         reply << "Unknown request";
//   //         socket_.send(reply);
//   //       }
//   //     }
//   //   }
//   // }
//   // stepTriggeredCnt_++;
//   // simulationStepTriggerCondition_.notify_all();
// }

}  // end of namespace DYN
