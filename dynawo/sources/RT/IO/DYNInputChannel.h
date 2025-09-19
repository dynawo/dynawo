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
 * @file  DYNInputChannel.h
 *
 * @brief Input channel header
 *
 */
#ifndef RT_IO_DYNINPUTCHANNEL_H_
#define RT_IO_DYNINPUTCHANNEL_H_

#include <memory>
#include <functional>

#include "DYNRTInputCommon.h"

namespace DYN {

/**
 * @class InputChannel
 * @brief Abstract base class for real-time simulation input channels.
 *
 * Defines the interface for receiving messages from an external source
 * into the simulation, with filtering capabilities.
 */
class InputChannel {
 public:
  /**
   * @brief Constructor.
   * @param id Identifier of the input channel
   * @param supportedMessages Message types supported by the channel
   */
  InputChannel(std::string id, MessageFilter supportedMessages);

  /**
   * @brief Start receiving messages.
   * @param callback Function called for each received message
   * @param useThread Whether to run reception in a separate thread
   */
  virtual void startReceiving(const std::function<void(std::shared_ptr<InputMessage>)>& callback,
                              bool useThread) = 0;

  /**
   * @brief Stop receiving messages.
   */
  virtual void stop() = 0;

  /**
   * @brief Check if this channel supports a given message type.
   * @param value Message filter to test
   * @return true if the channel supports the message type, false otherwise
   */
  inline bool supports(MessageFilter value) {
    return (static_cast<int>(supportedMessages_) & static_cast<int>(value)) != 0;
  }

 protected:
  std::string id_;                   ///< Identifier of the input channel
  MessageFilter supportedMessages_;  ///< Supported message types
};

}  // end of namespace DYN

#endif  // RT_IO_DYNINPUTCHANNEL_H_
