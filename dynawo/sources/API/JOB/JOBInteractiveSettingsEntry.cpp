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
 * @file JOBInteractiveSettingsEntry.cpp
 * @brief Modeler entry description : implementation file
 *
 */

#include "JOBInteractiveSettingsEntry.h"
#include "DYNClone.hpp"

namespace job {

  InteractiveSettingsEntry::InteractiveSettingsEntry():
  timeSync_(false),
  timeSyncAcceleration_(1.),
  eventSubscriberActions_(false),
  eventSubscriberTrigger_(false),
  triggerSimulationTimeStepInS_(1.),
  publishToZmq_(false),
  publishToWebsocket_(false) {}

InteractiveSettingsEntry::InteractiveSettingsEntry(const InteractiveSettingsEntry& other):
  periodicOutputsEntry_(DYN::clone(other.periodicOutputsEntry_)) {}

InteractiveSettingsEntry&
InteractiveSettingsEntry::operator=(const InteractiveSettingsEntry& other) {
  timeSync_ = other.timeSync_;
  timeSyncAcceleration_ = other.timeSyncAcceleration_;
  eventSubscriberActions_ = other.eventSubscriberActions_;
  eventSubscriberTrigger_ = other.eventSubscriberTrigger_;
  triggerSimulationTimeStepInS_ = other.triggerSimulationTimeStepInS_;
  publishToZmq_ = other.publishToZmq_;
  publishToWebsocket_ = other.publishToWebsocket_;
  periodicOutputsEntry_ = DYN::clone(other.periodicOutputsEntry_);
  return *this;
}

void InteractiveSettingsEntry::setPeriodicOutputsEntry(const std::shared_ptr<PeriodicOutputsEntry> &periodicOutputsEntry) {
  periodicOutputsEntry_ = periodicOutputsEntry;
}

std::shared_ptr<PeriodicOutputsEntry>
InteractiveSettingsEntry::getPeriodicOutputsEntry() const {
  return periodicOutputsEntry_;
}

}  // namespace job
