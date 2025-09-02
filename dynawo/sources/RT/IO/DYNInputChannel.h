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
 * @brief Input interface header
 *
 */
#ifndef RT_IO_DYNINPUTCHANNEL_H_
#define RT_IO_DYNINPUTCHANNEL_H_

#include <memory>
#include <functional>

#include "DYNRTInputCommon.h"

namespace DYN {

/**
 * @class  InputChannel
 *
 * Channel interface for real-time simulation inputs
 *
 */
class InputChannel {
 public:
  InputChannel(std::string id, MessageFilter supportedMessages) {
    id_ = id;
    supportedMessages_ = supportedMessages;
  }

  virtual void startReceiving(const std::function<void(std::shared_ptr<InputMessage>)>& callback, bool useThread) = 0;

  virtual void stop() = 0;

  inline bool supports(MessageFilter value) {
    return (static_cast<int>(supportedMessages_) & static_cast<int>(value)) != 0;
  }

 protected:
  std::string id_;
  MessageFilter supportedMessages_;
};

}  // end of namespace DYN

#endif  // RT_IO_DYNINPUTCHANNEL_H_
