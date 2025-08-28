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

enum class MessageFilter {
    None = 0,
    Actions = 1 << 0,
    TimeManagement = 1 << 1,
    Trigger = 1 << 2,
};

inline MessageFilter operator|(MessageFilter a, MessageFilter b) {
  return static_cast<MessageFilter>(static_cast<int>(a) | static_cast<int>(b));
}

enum class MessageType {
    Action,
    StepTrigger,
    Stop
};

struct InputMessage {
    virtual ~InputMessage() {}
    virtual MessageType getType() const = 0;
};

struct ActionMessage : public InputMessage {
    std::string payload;
    explicit ActionMessage(std::string p) : payload(std::move(p)) {}
    MessageType getType() const override { return MessageType::Action; }
};

struct StepTriggerMessage : public InputMessage {
    MessageType getType() const override { return MessageType::StepTrigger; }
};

struct StopMessage : public InputMessage {
    MessageType getType() const override { return MessageType::Stop; }
};

#endif  // RT_COMMON_DYNRTINPUTCOMMON_H_
