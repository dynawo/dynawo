//
// Copyright (c) 2025, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools
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

static const char STOP_KEY[] = "stop";  ///< Key used to signal stop

ZmqInputChannel::ZmqInputChannel(const std::string& id, MessageFilter messageFilter, const std::string& endpoint) :
InputChannel(id, messageFilter),
context_(1),
socket_(context_, zmq::socket_type::rep),
useThread_(false),
stopFlag_(false),
pollTimeoutMs_(10) {
  try {
    socket_.bind(endpoint);
  } catch (const zmq::error_t& e) {
    throw DYNError(Error::GENERAL, ZMQInterfaceBadEnpoint, endpoint);
  }
}

void
ZmqInputChannel::startReceiving(const std::function<void(std::shared_ptr<InputMessage>)>& callback, bool useThread) {
  callback_ = callback;
  useThread_ = useThread;
  if (useThread_) {
    thread_ = std::thread([this]() { receiveLoop(); });
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
  zmq::pollitem_t items[] = {
      { static_cast<void*>(socket_), 0, ZMQ_POLLIN, 0 }
  };

  while (!stopFlag_) {
    zmq::poll(items, 1, std::chrono::milliseconds(pollTimeoutMs_));

  if (items[0].revents & ZMQ_POLLIN) {
        zmq::message_t msg;
        socket_.recv(msg, zmq::recv_flags::none);

        std::string payload(static_cast<char*>(msg.data()), msg.size());

        std::string replyStr;
        std::shared_ptr<InputMessage> inputMsg;

        if (payload.empty()) {
          if (!supports(MessageFilter::Trigger)) {
            replyStr = "trigger received but not supported";
          } else {
            replyStr = "trigger received";
            inputMsg = std::make_shared<StepTriggerMessage>();
          }
        } else if (payload == STOP_KEY) {
          if (!supports(MessageFilter::TimeManagement)) {
            replyStr = "stop received but not supported";
          } else {
            replyStr = "stop received";
            inputMsg = std::make_shared<StopMessage>();
          }
        } else {
          if (!supports(MessageFilter::Actions)) {
            replyStr = "action received but not supported";
          } else {
            replyStr = "action received";
            inputMsg = std::make_shared<ActionMessage>(payload);
          }
        }

        socket_.send(zmq::buffer(replyStr), zmq::send_flags::none);

        if (callback_) callback_(std::move(inputMsg));
      }
    }
}

}  // end of namespace DYN
