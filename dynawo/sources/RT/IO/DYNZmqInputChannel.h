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
 * @file  DYNZmqInputChannel.h
 *
 * @brief ZmqInputChannel header
 *
 */
#ifndef RT_IO_DYNZMQINPUTCHANNEL_H_
#define RT_IO_DYNZMQINPUTCHANNEL_H_

#include "DYNInputChannel.h"
#include "DYNModel.h"
#include "DYNSubModel.h"

#include <mutex>
#include <vector>
#include <string>
#include <condition_variable>
#include <zmqpp/zmqpp.hpp>
#include <atomic>

namespace DYN {

/**
 * @class ZmqInputChannel
 * @brief Input channel implementation using ZeroMQ.
 *
 * Provides an interface for receiving messages via ZeroMQ sockets,
 * with optional threaded reception and stop signaling.
 */
class ZmqInputChannel: public InputChannel {
 public:
  /**
   * @brief Constructor.
   * @param id Identifier of the channel
   * @param messageFilter Filter applied on incoming messages
   * @param endpoint ZeroMQ endpoint to bind
   */
  ZmqInputChannel(const std::string& id, MessageFilter messageFilter, const std::string& endpoint = "tcp://*:5555");

  /**
   * @brief Start receiving messages.
   * @param callback Function called for each received message
   * @param useThread Whether to run reception in a separate thread (default: true)
   */
  void startReceiving(const std::function<void(std::shared_ptr<InputMessage>)>& callback, bool useThread = true) override;

  /**
   * @brief Stop receiving messages.
   */
  void stop();

  /**
   * @brief Receive messages in synchronous mode  --  to be checked (not used)
   * @param stop If true, stop reception after processing
   */
  void receiveMessages(bool stop);

 private:
  /**
   * @brief Reception loop executed in a thread when enabled.
   */
  void receiveLoop();

 private:
  zmqpp::context context_;              ///< ZeroMQ context
  zmqpp::socket socket_;                ///< ZeroMQ socket
  bool useThread_;                      ///< Whether reception uses a dedicated thread
  std::atomic<bool> stopFlag_;          ///< Flag to signal stopping reception
  long pollTimeoutMs_;                  ///< Polling timeout in milliseconds
  std::function<void(std::shared_ptr<InputMessage>)> callback_;  ///< Callback for received messages
  std::thread thread_;                  ///< Thread for message reception
};

}  // end of namespace DYN

#endif  // RT_IO_DYNZMQINPUTCHANNEL_H_
