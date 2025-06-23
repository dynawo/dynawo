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
 * @file  WSCServer.h
 *
 * @brief Dynawo websocket server
 *
 */
#ifndef API_WSC_WSCSERVER_H_
#define API_WSC_WSCSERVER_H_

// #include "CRVPoint.h"

#include <boost/shared_ptr.hpp>
// #include <limits>
// #include <string>
// #include <vector>
#include <thread>
#include <set>
#include <websocketpp/config/asio_no_tls.hpp>
#include <websocketpp/server.hpp>

typedef websocketpp::server<websocketpp::config::asio> server;
using websocketpp::connection_hdl;

namespace wsc {
/**
 * @class Server
 * @brief Websocket server
 *
 * Interface class for curve object.
 */
class WebsocketServer {
 public:
  /**
   * @brief Constructor
   */
  WebsocketServer();

  void onOpen(connection_hdl hdl);

  void onClose(connection_hdl hdl);

  // void onMessage(connection_hdl hdl, server::message_ptr msg);

  void run(uint16_t port);

  void sendMessage(const std::string& message);

  void stop();

 private:
  server server_;
  websocketpp::lib::shared_ptr<websocketpp::lib::thread> serverThread_;
  std::set<connection_hdl, std::owner_less<connection_hdl>> connections_;
  std::mutex connectionLock_;
};
}  // namespace wsc

#endif  // API_WSC_WSCSERVER_H_
