//
// Copyright (c) 2025, RTE (http://www.rte-france.com)
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
 * @file  DYNEventSubscriber.h
 *
 * @brief EventSubscriber header
 *
 */
#ifndef SIMULATION_DYNZMQPUBLISHER_H_
#define SIMULATION_DYNZMQPUBLISHER_H_

#include <string>
#include <sstream>
#include <zmqpp/zmqpp.hpp>


#ifdef _MSC_VER
  typedef int pid_t;
#endif

namespace DYN {

/**
 * @brief ZmqPublisher class
 *
 * class to push data
 *
 */
class ZmqPublisher {
 public:
  ZmqPublisher();

  void sendMessage(std::string& data);

  void sendMessage(std::string& data, std::string topic);

 private:
  zmqpp::context context_;
  zmqpp::socket socket_;
};

}  // end of namespace DYN

#endif  // SIMULATION_DYNZMQPUBLISHER_H_
