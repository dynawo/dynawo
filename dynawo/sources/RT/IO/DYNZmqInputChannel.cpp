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

static const char STOP_KEY[] = "stop";  ///< Key used to signal stop

ZmqInputChannel::ZmqInputChannel(const std::string& id, MessageFilter messageFilter, const std::string& endpoint) :
InputChannel(id, messageFilter),
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
  zmqpp::poller poller;
  poller.add(socket_);

  while (!stopFlag_) {
    if (poller.poll(pollTimeoutMs_)) {
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

}  // end of namespace DYN
