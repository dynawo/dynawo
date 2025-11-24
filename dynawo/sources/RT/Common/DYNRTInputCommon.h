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
 * @file  DYNRTInputCommon.h
 *
 * @brief Input message header
 *
 */
#ifndef RT_COMMON_DYNRTINPUTCOMMON_H_
#define RT_COMMON_DYNRTINPUTCOMMON_H_
#include <string>
#include <memory>

namespace DYN {

/**
 * @enum MessageFilter
 * @brief Defines categories of messages that can be filtered.
 */
enum class MessageFilter {
  None = 0,                 ///< No filter
  Actions = 1 << 0,         ///< Filter for action messages
  TimeManagement = 1 << 1,  ///< Filter for time management messages
  Trigger = 1 << 2          ///< Filter for trigger messages
};

/**
 * @brief Bitwise OR operator for combining message filters.
 * @param a First filter
 * @param b Second filter
 * @return Combined filter
 */
inline MessageFilter operator|(MessageFilter a, MessageFilter b) {
  return static_cast<MessageFilter>(static_cast<int>(a) | static_cast<int>(b));
}

/**
 * @enum MessageType
 * @brief Defines the types of input messages.
 */
enum class MessageType {
  Action,       ///< Action message
  StepTrigger,  ///< Step trigger message
  Stop          ///< Stop message
};

/**
 * @struct InputMessage
 * @brief Abstract base class for input messages.
 */
struct InputMessage {
  /**
   * @brief Destructor.
   */
  virtual ~InputMessage() = default;

  /**
   * @brief Get the message type.
   * @return Type of the message
   */
  virtual MessageType getType() const = 0;
};

/**
 * @struct ActionMessage
 * @brief Message carrying an action payload.
 */
struct ActionMessage : public InputMessage {
  std::string payload;  ///< Message content

  /**
   * @brief Constructor.
   * @param p Payload string
   */
  explicit ActionMessage(std::string p) : payload(std::move(p)) { }

  /**
   * @brief Get the message type.
   * @return MessageType::Action
   */
  MessageType getType() const override { return MessageType::Action; }
};

/**
 * @struct StepTriggerMessage
 * @brief Message used to trigger a simulation step.
 */
struct StepTriggerMessage : public InputMessage {
  /**
   * @brief Get the message type.
   * @return MessageType::StepTrigger
   */
  MessageType getType() const override { return MessageType::StepTrigger; }
};

/**
 * @struct StopMessage
 * @brief Message used to stop the simulation.
 */
struct StopMessage : public InputMessage {
  /**
   * @brief Get the message type.
   * @return MessageType::Stop
   */
  MessageType getType() const override { return MessageType::Stop; }
};

}  // end of namespace DYN

#endif  // RT_COMMON_DYNRTINPUTCOMMON_H_
