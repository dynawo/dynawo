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

namespace DYN {
/**
 * @class Server
 * @brief Websocket server
 *
 * Interface class for curve object.
 */
class WebsocketOutputPort {
 public:
  /**
   * @brief Constructor
   */
  WebsocketOutputPort(uint16_t port);

  ~WebsocketOutputPort();

  void sendMessage(const std::string& message);

  void sendMessage(const std::string& data, const std::string& topic);

  void sendMessage(const std::vector<std::uint8_t>& data, const std::string& topic);

 private:
  void run();

  void stop();

  void onOpen(connection_hdl hdl);

  void onClose(connection_hdl hdl);

 private:
  uint16_t port_;
  server server_;
  websocketpp::lib::shared_ptr<websocketpp::lib::thread> serverThread_;
  std::set<connection_hdl, std::owner_less<connection_hdl>> connections_;
  std::mutex connectionLock_;
};
}  // namespace DYN

#endif  // API_WSC_WSCSERVER_H_
