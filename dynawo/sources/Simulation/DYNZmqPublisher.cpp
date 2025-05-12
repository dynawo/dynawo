//
// Copyright (c) 2024, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNZmqPublisher.cpp
 *
 * @brief Publish string to ZMQ socket
 *
 */

#include "DYNZmqPublisher.h"


namespace DYN {

ZmqPublisher::ZmqPublisher():
socket_(context_, zmqpp::socket_type::pub) {
  socket_.bind("tcp://*:5556");
}

void
ZmqPublisher::sendMessage(std::string& data) {
  zmqpp::message message;
  message << data;
  socket_.send(message);
  std::cout << "ZmqPublisher: data sent" << std::endl;
}

void
ZmqPublisher::sendMessage(std::string& data, std::string topic) {
  std::stringstream ss;
  ss << topic << "\n" << data;
  std::string dataWithTopic = ss.str();
  sendMessage(dataWithTopic);
}

}  // end of namespace DYN
