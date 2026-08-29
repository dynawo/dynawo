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
 * @file JOBInteractiveSettingsEntry.cpp
 * @brief Interactive settings entry description : implementation file
 */

#include "JOBInteractiveSettingsEntry.h"

#include "DYNClone.hpp"

namespace job {

InteractiveSettingsEntry::InteractiveSettingsEntry(): couplingTimeStep_(0.) { }

InteractiveSettingsEntry::InteractiveSettingsEntry(const InteractiveSettingsEntry& other) {
  copy(other);
}

InteractiveSettingsEntry&
InteractiveSettingsEntry::operator=(const InteractiveSettingsEntry& other) {
  copy(other);
  return *this;
}

void
InteractiveSettingsEntry::copy(const InteractiveSettingsEntry& other) {
  couplingTimeStep_ = other.couplingTimeStep_;

  channels_ = DYN::clone(other.channels_);
  clock_ = DYN::clone(other.clock_);
  streams_ = DYN::clone(other.streams_);
}

void
InteractiveSettingsEntry::setClockEntry(std::shared_ptr<ClockEntry> clockEntry) {
  clock_ = clockEntry;
}

const std::shared_ptr<ClockEntry>
InteractiveSettingsEntry::getClockEntry() const {
  return clock_;
}

void
InteractiveSettingsEntry::setChannelsEntry(std::shared_ptr<ChannelsEntry> channelsEntry) {
  channels_ = channelsEntry;
}

const std::shared_ptr<ChannelsEntry>
InteractiveSettingsEntry::getChannelsEntry() const {
  return channels_;
}

void
InteractiveSettingsEntry::setStreamsEntry(std::shared_ptr<StreamsEntry> streamsEntry) {
  streams_ = streamsEntry;
}

const std::shared_ptr<StreamsEntry>
InteractiveSettingsEntry::getStreamsEntry() const {
  return streams_;
}

void
InteractiveSettingsEntry::setCouplingTimeStep(const double couplingTimeStep) {
  couplingTimeStep_ = couplingTimeStep;
}

double
InteractiveSettingsEntry::getCouplingTimeStep() const {
  return couplingTimeStep_;
}
}  // namespace job
