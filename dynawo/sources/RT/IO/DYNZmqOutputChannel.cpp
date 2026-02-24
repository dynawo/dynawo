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
 * @file  DYNZmqOutputChannel.cpp
 *
 * @brief Publish string to ZMQ socket
 *
 */

#include "DYNZmqOutputChannel.h"
#include "DYNMacrosMessage.h"
#include "DYNTrace.h"

namespace DYN {

ZmqOutputChannel::ZmqOutputChannel(const std::string& endpoint):
  context_(1),
  socket_(context_, zmq::socket_type::pub) {
    try {
    socket_.bind(endpoint);
  } catch (const zmq::error_t& e) {
    throw DYNError(Error::GENERAL, ZMQInterfaceBadEnpoint, endpoint);
  }
}

void
ZmqOutputChannel::sendMessage(const std::string& data) {
  sendMessage(data, "");
}

void
ZmqOutputChannel::sendMessage(const std::string& data, const std::string& topic) {
  zmq::message_t topic_msg(topic.data(), topic.size());
  zmq::message_t data_msg(data.data(), data.size());

  socket_.send(topic_msg, zmq::send_flags::sndmore);
  socket_.send(data_msg, zmq::send_flags::none);

  Trace::debug() << DYNLog(ZmqDataSent, " (topic: " + topic + ")") << Trace::endline;
}

void
ZmqOutputChannel::sendMessage(const std::vector<std::uint8_t>& data, const std::string& topic) {
  zmq::message_t topic_msg(topic.data(), topic.size());
  zmq::message_t data_msg(data.data(), data.size());

  socket_.send(topic_msg, zmq::send_flags::sndmore);
  socket_.send(data_msg, zmq::send_flags::none);

  Trace::debug() << DYNLog(ZmqDataSent, " (topic: " + topic + ")") << Trace::endline;
}

}  // end of namespace DYN
