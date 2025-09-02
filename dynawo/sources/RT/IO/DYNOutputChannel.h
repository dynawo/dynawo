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
 * @file  DYNOutputChannel.h
 *
 * @brief Output channel header
 *
 */
#ifndef RT_IO_DYNOUTPUTCHANNEL_H_
#define RT_IO_DYNOUTPUTCHANNEL_H_

#include <memory>
#include <vector>
#include <cstdint>

namespace DYN {

/**
 * @class  OutputChannel
 *
 * Channel for real-time simulation outputs
 *
 */
class OutputChannel {
 public:
  virtual void sendMessage(const std::string& data) = 0;

  virtual void sendMessage(const std::string& data, const std::string topic) = 0;

  virtual void sendMessage(const std::vector<std::uint8_t>& data, const std::string topic) = 0;
};

}  // end of namespace DYN

#endif  // RT_IO_DYNOUTPUTCHANNEL_H_
