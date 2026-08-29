//
// Copyright (c) 2025, RTE
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
 * @file JOBStreamEntry.cpp
 * @brief Output stream entry description : implementation file
 */

#include "JOBStreamEntry.h"

namespace job {

const std::string&
StreamEntry::getData() const {
  return data_;
}

const std::string&
StreamEntry::getChannel() const {
  return channel_;
}

const std::string&
StreamEntry::getFormat() const {
  return format_;
}

void
StreamEntry::setData(const std::string& data) {
  data_ = data;
}

void
StreamEntry::setChannel(const std::string& channel) {
  channel_ = channel;
}

void
StreamEntry::setFormat(const std::string& format) {
  format_ = format;
}

}  // namespace job
