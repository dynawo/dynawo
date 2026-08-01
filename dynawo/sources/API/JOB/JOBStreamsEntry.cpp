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

#include "JOBStreamsEntry.h"

#include "DYNClone.hpp"

namespace job {

StreamsEntry::StreamsEntry(const StreamsEntry& other) {
  copy(other);
}

StreamsEntry& StreamsEntry::operator=(const StreamsEntry& other) {
  copy(other);
  return *this;
}

void
StreamsEntry::copy(const StreamsEntry& other) {
  streams_.reserve(other.streams_.size());
  for (const auto& stream : other.streams_) {
      streams_.push_back(DYN::clone(stream));
  }
}

void
StreamsEntry::addStreamEntry(const std::shared_ptr<StreamEntry>& streamEntry) {
  streams_.push_back(streamEntry);
}

const std::vector<std::shared_ptr<StreamEntry> >&
StreamsEntry::getStreamEntries() const {
  return streams_;
}
}  // namespace job
