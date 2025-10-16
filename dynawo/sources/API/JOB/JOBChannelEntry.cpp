//
// Copyright (c) 2025, RTE
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

#include "JOBChannelEntry.h"

namespace job {

const std::string&
ChannelEntry::getId() const {
  return id_;
}

const std::string&
ChannelEntry::getKind() const {
  return kind_;
}

const std::string&
ChannelEntry::getType() const {
  return type_;
}

const std::string&
ChannelEntry::getEndpoint() const {
  return endpoint_;
}

void
ChannelEntry::setId(const std::string& id) {
  id_ = id;
}

void
ChannelEntry::setKind(const std::string& kind) {
  kind_ = kind;
}

void
ChannelEntry::setType(const std::string& type) {
  type_ = type;
}

void
ChannelEntry::setEndpoint(const std::string& endpoint) {
  endpoint_ = endpoint;
}

}  // namespace job
