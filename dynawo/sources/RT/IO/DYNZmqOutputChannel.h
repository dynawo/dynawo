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

#ifdef _MSC_VER
  typedef int pid_t;
#endif

namespace DYN {

/**
 * @brief ZmqOutputChannel class
 *
 * class to push data
 *
 */
class ZmqOutputChannel : public OutputChannel {
 public:
  explicit ZmqOutputChannel(std::string endpoint = "tcp://*:5556");

  void sendMessage(const std::string& data) override;

  void sendMessage(const std::string& data, std::string topic) override;

  void sendMessage(const std::vector<std::uint8_t>& data, std::string topic) override;

 private:
  zmqpp::context context_;
  zmqpp::socket socket_;
};

}  // end of namespace DYN

#endif  // RT_IO_DYNZMQOUTPUTCHANNEL_H_
