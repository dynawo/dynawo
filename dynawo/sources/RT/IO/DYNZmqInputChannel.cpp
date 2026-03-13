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

#include "DYNTrace.h"
#include "DYNMacrosMessage.h"

#include <vector>

namespace DYN {

static const char STOP_KEY[] = "stop";  ///< Key used to signal stop

ZmqInputChannel::ZmqInputChannel(const std::string& id, InputMessageFilter messageFilter, const std::string& endpoint) :
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

ZmqInputChannel::zmqControlType_t
ZmqInputChannel::getControlType(const std::string& header) {
  if (header.rfind("step", 0) == 0) {
    return zmqControlType_t::STEP;
  }
  if (header.rfind("stop", 0) == 0) {
    return zmqControlType_t::STOP;
  }
  if (header.rfind("action", 0) == 0) {
    return zmqControlType_t::ACTION;
  }
  if (header.rfind("dump", 0) == 0) {
    return zmqControlType_t::DUMP;
  }
  return zmqControlType_t::UNKNOWN;
}

void
ZmqInputChannel::receiveLoop() {
  zmq::pollitem_t items[] = {
      { static_cast<void*>(socket_), 0, ZMQ_POLLIN, 0 }
  };

  while (!stopFlag_) {
    zmq::poll(items, 1, std::chrono::milliseconds(pollTimeoutMs_));

    if (items[0].revents & ZMQ_POLLIN) {
      try {
        // Receive all parts
        zmq::message_t header;
        socket_.recv(header);

        std::string replyStr;
        std::shared_ptr<InputMessage> inputMsg;

        switch (getControlType(header.to_string())) {
          case zmqControlType_t::STEP:
            if (!supports(InputMessageFilter::STEP)) {
              replyStr = "step trigger received but not supported";
            } else {
              replyStr = "step trigger received";
              inputMsg = std::make_shared<StepTriggerMessage>();
            }
            break;
          case zmqControlType_t::STOP:
            if (!supports(InputMessageFilter::TIME_MANAGEMENT)) {
              replyStr = "stop received but not supported";
            } else {
              replyStr = "stop received";
              inputMsg = std::make_shared<StopMessage>();
            }
            break;
          case zmqControlType_t::ACTION:
            if (!supports(InputMessageFilter::ACTIONS)) {
              replyStr = "action received but not supported";
            } else {
              std::vector<std::string> actions;
              while (socket_.get(zmq::sockopt::rcvmore)) {
                zmq::message_t part;
                socket_.recv(part);
                actions.push_back(part.to_string());
              }
              replyStr = "action received";
              inputMsg = std::make_shared<ActionMessage>(actions);
            }
            break;
          case zmqControlType_t::DUMP:
            if (!supports(InputMessageFilter::DUMP)) {
              replyStr = "dump trigger received but not supported";
            } else {
              replyStr = "dump trigger received";
              inputMsg = std::make_shared<DumpTriggerMessage>();
            }
            break;
          case UNKNOWN:
            replyStr = "Unknown request";
          default:
            break;
        }

        socket_.send(zmq::buffer(replyStr), zmq::send_flags::none);

        if (callback_) callback_(std::move(inputMsg));
      } catch (const zmq::error_t& e) {
        DYN::Trace::error("RTIO") << "ZmqInputChannel: zmq error during reception: " << e.what() << DYN::Trace::endline;
      }
    }
  }
}

}  // end of namespace DYN
