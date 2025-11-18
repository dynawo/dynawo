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
socket_(context_, zmqpp::socket_type::pub) {
    try {
    socket_.bind(endpoint);
  } catch (const zmqpp::exception& e) {
    throw DYNError(Error::GENERAL, ZMQInterfaceBadEnpoint, endpoint);
  }
}

void
ZmqOutputChannel::sendMessage(const std::string& data) {
  zmqpp::message message;
  message << data;
  socket_.send(message);
  Trace::debug() << DYNLog(ZmqDataSent, "") << Trace::endline;
}

void
ZmqOutputChannel::sendMessage(const std::string& data, const std::string& topic) {
  zmqpp::message message;
  message << topic;
  message << data;
  socket_.send(message);
  Trace::debug() << DYNLog(ZmqDataSent, " (topic: " + topic + ")") << Trace::endline;
}

void
ZmqOutputChannel::sendMessage(const std::vector<std::uint8_t>& data, const std::string& topic) {
  zmqpp::message message;
  message << topic;
  message.add_raw(reinterpret_cast<const void*>(data.data()), data.size());
  socket_.send(message);
  Trace::debug() << DYNLog(ZmqDataSent, " (topic: " + topic + ")") << Trace::endline;
}

}  // end of namespace DYN
