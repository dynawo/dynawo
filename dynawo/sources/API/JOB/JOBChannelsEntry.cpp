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

#include "JOBChannelsEntry.h"

#include "DYNClone.hpp"

namespace job {

ChannelsEntry::ChannelsEntry(const ChannelsEntry& other) {
  copy(other);
}

ChannelsEntry& ChannelsEntry::operator=(const ChannelsEntry& other) {
  copy(other);
  return *this;
}

void
ChannelsEntry::copy(const ChannelsEntry& other) {
  channels_.reserve(other.channels_.size());
  for (const auto& channel : other.channels_) {
      addChannelEntry(DYN::clone(channel));
  }
}

void
ChannelsEntry::addChannelEntry(const std::shared_ptr<ChannelEntry>& channelEntry) {
  channels_.push_back(channelEntry);
  channelsById_.emplace(channelEntry->getId(), channelEntry);
}

const std::vector<std::shared_ptr<ChannelEntry> >&
ChannelsEntry::getChannelEntries() const {
  return channels_;
}

const std::shared_ptr<ChannelEntry>
ChannelsEntry::getChannelEntryById(const std::string& id) const {
  if (channelsById_.find(id) != channelsById_.end())
    return channelsById_.at(id);
  return std::shared_ptr<ChannelEntry>();
}

}  // namespace job
