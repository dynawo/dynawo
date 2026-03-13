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
#include <vector>

namespace DYN {

/**
 * @enum InputMessageFilter
 * @brief Defines categories of messages that can be filtered.
 */
enum class InputMessageFilter {
  NONE = 0,                  ///< Filter none
  ACTIONS = 1 << 0,          ///< Filter for action messages
  TIME_MANAGEMENT = 1 << 1,  ///< Filter for time management messages
  STEP = 1 << 2,             ///< Filter for step trigger messages
  DUMP = 1 << 3,             ///< Filter for dump signal messages
  ALL = ACTIONS | TIME_MANAGEMENT | STEP | DUMP  ///< Filter for all messages
};

/**
 * @brief Bitwise OR operator for combining message filters.
 * @param a First filter
 * @param b Second filter
 * @return Combined filter
 */
inline InputMessageFilter operator|(InputMessageFilter a, InputMessageFilter b) {
  return static_cast<InputMessageFilter>(static_cast<int>(a) | static_cast<int>(b));
}

/**
 * @enum InputMessageType
 * @brief Defines the types of input messages.
 */
enum class InputMessageType {
  ACTION,       ///< Action message
  STEP,         ///< Step trigger message
  STOP,         ///< Stop message
  DUMP          ///< Dump message
};

/**
 * @class InputMessage
 * @brief Abstract base class for input messages.
 */
class InputMessage {
 public:
  /**
   * @brief Destructor.
   */
  virtual ~InputMessage();

  /**
   * @brief Get the message type.
   * @return Type of the message
   */
  virtual InputMessageType getType() const = 0;
};

/**
 * @class ActionMessage
 * @brief Message carrying an action payload.
 */
class ActionMessage : public InputMessage {
 public:
  /**
   * @brief Constructor.
   * @param p Action strings
   */
  explicit ActionMessage(std::vector<std::string> p) : payload(std::move(p)) { }

  /**
   * @brief Destructor.
   */
  ~ActionMessage() override;

  /**
   * @brief Get the message type.
   * @return InputMessageType::ACTION
   */
  InputMessageType getType() const override { return InputMessageType::ACTION; }

  /**
   * @brief Get actions strings
   * @return Action strings
   */
  std::vector<std::string> getPayload() {
    return payload;
  }

 private:
  std::vector<std::string> payload;  ///< strings corresponding to the actions of a model
};

/**
 * @class StepTriggerMessage
 * @brief Message used to trigger a simulation step.
 */
class StepTriggerMessage : public InputMessage {
 public:
  /**
   * @brief Destructor.
   */
  ~StepTriggerMessage() override;

  /**
   * @brief Get the message type.
   * @return InputMessageType::STEP
   */
  InputMessageType getType() const override { return InputMessageType::STEP; }
};

/**
 * @class StopMessage
 * @brief Message used to stop the simulation.
 */
class StopMessage : public InputMessage {
 public:
  /**
   * @brief Destructor.
   */
  ~StopMessage() override;

  /**
   * @brief Get the message type.
   * @return InputMessageType::STOP
   */
  InputMessageType getType() const override { return InputMessageType::STOP; }
};

/**
 * @class DumpTriggerMessage
 * @brief Message used to trigger a simulation dump
 */
class DumpTriggerMessage : public InputMessage {
 public:
  /**
   * @brief Get the message type.
   * @return InputMessageType::DUMP
   */
  InputMessageType getType() const override { return InputMessageType::DUMP; }
};

}  // end of namespace DYN

#endif  // RT_COMMON_DYNRTINPUTCOMMON_H_
