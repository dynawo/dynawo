//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  TLEventImpl.cpp
 *
 * @brief Dynawo timeline event : implementation file
 *
 */
#include "TLEvent.h"

using std::string;

namespace timeline {

Event::Event() : time_(0.), modelName_(""), message_(""), priority_(boost::none) {}

void
Event::setTime(const double& time) {
  time_ = time;
}

void
Event::setModelName(const string& modelName) {
  modelName_ = modelName;
}

void
Event::setMessage(const string& message) {
  message_ = message;
}

void
Event::setPriority(const boost::optional<int>& priority) {
  priority_ = priority;
}

double
Event::getTime() const {
  return time_;
}

const string&
Event::getModelName() const {
  return modelName_;
}

const string&
Event::getMessage() const {
  return message_;
}

}  // namespace timeline
