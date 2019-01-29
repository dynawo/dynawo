//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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
 * @file  TLEventImpl.cpp
 *
 * @brief Dynawo timeline event : implementation file
 *
 */
#include "TLEventImpl.h"

using std::string;

namespace timeline {

Event::Impl::Impl() :
time_(0.),
modelName_(""),
message_(""),
priority_(boost::none) {
}

Event::Impl::~Impl() {
}

void
Event::Impl::setTime(const double& time) {
  time_ = time;
}

void
Event::Impl::setModelName(const string& modelName) {
  modelName_ = modelName;
}

void
Event::Impl::setMessage(const string& message) {
  message_ = message;
}

void
Event::Impl::setPriority(const boost::optional<int>& priority) {
  priority_ = priority;
}

double
Event::Impl::getTime() const {
  return time_;
}

const string&
Event::Impl::getModelName() const {
  return modelName_;
}

const string&
Event::Impl::getMessage() const {
  return message_;
}

}  // namespace timeline

