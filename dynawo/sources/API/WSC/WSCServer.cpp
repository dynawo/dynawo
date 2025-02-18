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
 * @file  WSCServer.cpp
 *
 * @brief Dynawo websocket server
 *
 */
#include "WSCServer.h"

#include "DYNTrace.h"


using boost::shared_ptr;
using std::string;
using std::bind;

namespace wsc {

WebsocketServer::WebsocketServer() {
    // Set logging to console
  server_.set_access_channels(websocketpp::log::alevel::all);
  server_.clear_access_channels(websocketpp::log::alevel::frame_payload);

  // Initialize the Asio transport policy
  server_.init_asio();

  // Set the SO_REUSEADDR option
  server_.set_reuse_addr(true);

  // Register our handlers
  server_.set_open_handler(bind(&WebsocketServer::onOpen, this, std::placeholders::_1));
  server_.set_close_handler(bind(&WebsocketServer::onClose, this, std::placeholders::_1));
  // server_.set_message_handler(bind(&WebsocketServer::onMessage, this, std::placeholders::_1, std::placeholders::_2));
}


void
WebsocketServer::onOpen(connection_hdl hdl) {
  // Store the connection handle for later communication
  std::lock_guard<std::mutex> lock(connectionLock_);
  connections_.insert(hdl);
  std::cout << "WebsocketServer: Client connected!" << std::endl;
}

void
WebsocketServer::onClose(connection_hdl hdl) {
  // Remove the connection handle when the client disconnects
  std::lock_guard<std::mutex> lock(connectionLock_);
  connections_.erase(hdl);
  std::cout << "WebsocketServer: Client disconnected!" << std::endl;
}

// void
// WebsocketServer::onMessage(connection_hdl, server::message_ptr) {
//   // to do: command reception
// }

void
WebsocketServer::run(uint16_t port) {
  server_.set_reuse_addr(true);
  server_.listen(port);
  server_.start_accept();
  serverThread_ = websocketpp::lib::make_shared<websocketpp::lib::thread>(&server::run, &server_);
  std::cout << "WebsocketServer run" << std::endl;
}

void
WebsocketServer::sendMessage(const string& message) {
  // Lock the connection list and broadcast to all connected clients
  std::lock_guard<std::mutex> lock(connectionLock_);
  // std::cout << "WebsocketServer sendMessage" << std::endl;
  for (auto it : connections_) {
      server_.send(it, message, websocketpp::frame::opcode::text);
  }
}

void
WebsocketServer::stop() {
  server_.stop_listening();  // Stop accepting new connections
  std::lock_guard<std::mutex> lock(connectionLock_);
  for (auto it : connections_) {
      server_.close(it, websocketpp::close::status::going_away, "Websocket Server shutting down");  // Close all open connections
  }
  server_.stop();  // Stop the ASIO server loop
  serverThread_->join();
  std::cout << ">Websocket Server stopped." << std::endl;
}


}  // namespace wsc
