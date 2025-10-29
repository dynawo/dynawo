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
 * @file  DYNZmqOutputChannel.h
 *
 * @brief ZmqOutputChannel header
 *
 */
#ifndef RT_IO_DYNZMQOUTPUTCHANNEL_H_
#define RT_IO_DYNZMQOUTPUTCHANNEL_H_

#include <string>
#include <sstream>
#include <cstdint>
#include <zmqpp/zmqpp.hpp>

#include "DYNOutputChannel.h"

namespace DYN {

/**
 * @class ZmqOutputChannel
 * @brief Output channel implementation using ZeroMQ.
 *
 * Provides an interface to push simulation output messages
 * to external consumers via ZeroMQ sockets.
 */
class ZmqOutputChannel : public OutputChannel {
 public:
  /**
   * @brief Constructor.
   * @param endpoint ZeroMQ endpoint to bind
   */
  explicit ZmqOutputChannel(const std::string& endpoint = "tcp://*:5556");

  /**
   * @brief Send a message as a string.
   * @param data Message content
   */
  void sendMessage(const std::string& data) override;

  /**
   * @brief Send a message as a string with a topic.
   * @param data Message content
   * @param topic Message topic
   */
  void sendMessage(const std::string& data, const std::string& topic) override;

  /**
   * @brief Send a message as raw bytes with a topic.
   * @param data Message content as a byte vector
   * @param topic Message topic
   */
  void sendMessage(const std::vector<std::uint8_t>& data, const std::string& topic) override;

 private:
  zmqpp::context context_;  ///< ZeroMQ context
  zmqpp::socket socket_;    ///< ZeroMQ socket for sending messages
};

}  // end of namespace DYN

#endif  // RT_IO_DYNZMQOUTPUTCHANNEL_H_
