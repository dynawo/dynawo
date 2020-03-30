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
criteriaStep_(10),
precision_(1e-6) {
}

SimulationEntry::Impl::~Impl() {
}

void
SimulationEntry::Impl::setStartTime(double startTime) {
  startTime_ = startTime;
}

double
SimulationEntry::Impl::getStartTime() const {
  return startTime_;
}

void
SimulationEntry::Impl::setStopTime(double stopTime) {
  stopTime_ = stopTime;
}

double
SimulationEntry::Impl::getStopTime() const {
  return stopTime_;
}

void
SimulationEntry::Impl::addCriteriaFile(const std::string& criteriaFile) {
  criteriaFiles_.push_back(criteriaFile);
}

const std::vector<std::string>&
SimulationEntry::Impl::getCriteriaFiles() const {
  return criteriaFiles_;
}

void
SimulationEntry::Impl::setCriteriaStep(int criteriaStep) {
  criteriaStep_ = criteriaStep;
}

int
SimulationEntry::Impl::getCriteriaStep() const {
  return criteriaStep_;
}

void
SimulationEntry::Impl::setPrecision(double precision) {
  precision_ = precision;
}

double
SimulationEntry::Impl::getPrecision() const {
  return precision_;
}

}  // namespace job
