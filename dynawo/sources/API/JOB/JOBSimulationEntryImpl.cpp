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
 * @file JOBSimulationEntryImpl.cpp
 * @brief Simulation entry description : implementation file
 *
 */

#include "JOBSimulationEntryImpl.h"

namespace job {

SimulationEntry::Impl::Impl():
startTime_(0),
stopTime_(0),
activateCriteria_(true),
criteriaStep_(10) {
}

SimulationEntry::Impl::~Impl() {
}

void
SimulationEntry::Impl::setStartTime(const double & startTime) {
  startTime_ = startTime;
}

double
SimulationEntry::Impl::getStartTime() const {
  return startTime_;
}

void
SimulationEntry::Impl::setStopTime(const double & stopTime) {
  stopTime_ = stopTime;
}

double
SimulationEntry::Impl::getStopTime() const {
  return stopTime_;
}

void
SimulationEntry::Impl::setActivateCriteria(bool activate) {
  activateCriteria_ = activate;
}

bool
SimulationEntry::Impl::getActivateCriteria() const {
  return activateCriteria_;
}

void
SimulationEntry::Impl::setCriteriaStep(const int & criteriaStep) {
  criteriaStep_ = criteriaStep;
}

int
SimulationEntry::Impl::getCriteriaStep() const {
  return criteriaStep_;
}

}  // namespace job
